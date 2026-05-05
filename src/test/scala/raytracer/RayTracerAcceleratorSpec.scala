package raytracer

import chisel3._
import chiseltest._
import org.scalatest.freespec.AnyFreeSpec

class RayTracerAcceleratorSpec extends AnyFreeSpec with ChiselScalatestTester {

  private case class SceneParams(
    cols:    Int,
    rows:    Int,
    scaleX:  Double,
    scaleY:  Double,
    camX:    Double,
    camY:    Double,
    camZ:    Double,
    sphereX: Double = 0.0,
    sphereY: Double = 1.0,
    sphereZ: Double = 0.0
  ) {
    val midCol = cols / 2
    val midRow = rows / 2
    val total  = cols * rows
  }

  // 32x32 default scene
  private val defaultScene = SceneParams(
    cols = 32, rows = 32,
    scaleX = 1.0 / 24.0, scaleY = 1.0 / 24.0,
    camX = 0.0, camY = 1.5, camZ = -3.0
  )

  // must match the palette in RayTracerAccelerator
  private val gSky              = 0x00
  private val gFloorDark        = 0x40
  private val gFloorLight       = 0xC0
  private val gSphereSky        = 0x20
  private val gSphereFloorDark  = 0x60
  private val gSphereFloorLight = 0xA0

  // Q16.16 reference, mirrors the hardware bit-exactly (truncation, multi-cycle div, int sqrt)
  private def refByte(col: Int, row: Int, p: SceneParams): Int = {
    def toFP(x: Double): Long = math.round(x * (1L << 16))
    // mimic Wire(SInt(32.W)) := x
    def trunc32(x: Long): Long = {
      val lo = x & 0xFFFFFFFFL
      if ((lo & 0x80000000L) != 0) lo - (1L << 32) else lo
    }
    def mulFP(a: Long, b: Long): Long = trunc32((a * b) >> 16)
    def divFP(a: Long, b: Long): Long = trunc32((a << 16) / b)
    def sqrtFP(x: Long): Long = {
      val wide = BigInt(x) << 16
      BigInt(wide.bigInteger.sqrt()).toLong
    }

    val camX_fp = toFP(p.camX)
    val camY_fp = toFP(p.camY)
    val camZ_fp = toFP(p.camZ)
    val sphereX_fp = toFP(p.sphereX)
    val sphereY_fp = toFP(p.sphereY)
    val sphereZ_fp = toFP(p.sphereZ)

    val ocX_fp = trunc32(camX_fp - sphereX_fp)
    val ocY_fp = trunc32(camY_fp - sphereY_fp)
    val ocZ_fp = trunc32(camZ_fp - sphereZ_fp)
    val cScalar_fp = trunc32(
      mulFP(ocX_fp, ocX_fp) + mulFP(ocY_fp, ocY_fp) + mulFP(ocZ_fp, ocZ_fp) - toFP(1.0)
    )
    val negCamY_fp = trunc32(-camY_fp)

    // dx, dy: (col - midCol) << F, then mul with the Q16.16 scale.
    // matches the hardware exactly (one Q16.16 mul with truncation),
    // not a Double pre-multiply.
    val scaleX_fp = toFP(p.scaleX)
    val scaleY_fp = toFP(p.scaleY)
    val dx_fp  = mulFP(((col - p.midCol).toLong) << 16, scaleX_fp)
    val dy_fp  = mulFP(((p.midRow - row).toLong) << 16, scaleY_fp)
    val dxSq_fp = mulFP(dx_fp, dx_fp)
    val dySq_fp = mulFP(dy_fp, dy_fp)
    val valid   = row > p.midRow

    val ocYdy_fp: Long = mulFP(ocY_fp, dy_fp)
    val tFloor_fp: Long = if (valid) divFP(negCamY_fp, dy_fp) else 0L

    val ocXdx = mulFP(ocX_fp, dx_fp)
    val k_fp  = trunc32(dxSq_fp + dySq_fp)
    val A_fp  = trunc32(k_fp + toFP(1.0))
    val hPart = trunc32(ocZ_fp + ocXdx)
    val h_fp  = trunc32(hPart + ocYdy_fp)
    val hSq   = mulFP(h_fp, h_fp)
    val AcScalar = mulFP(A_fp, cScalar_fp)
    val disc_fp  = trunc32(hSq - AcScalar)
    val sphereHit = disc_fp >= 0

    if (!sphereHit) {
      if (!valid) gSky
      else {
        val floorHitX = trunc32(camX_fp + mulFP(tFloor_fp, dx_fp))
        val floorHitZ = trunc32(camZ_fp + tFloor_fp)
        val fx = (floorHitX >> 16).toInt
        val fz = (floorHitZ >> 16).toInt
        if (((fx + fz) & 1) != 0) gFloorLight else gFloorDark
      }
    } else {
      val s_fp = sqrtFP(disc_fp)
      val tNum = trunc32(-(h_fp + s_fp))
      val tSphere_fp = divFP(tNum, A_fp)

      val hitX_fp = trunc32(camX_fp + mulFP(tSphere_fp, dx_fp))
      val hitY_fp = trunc32(camY_fp + mulFP(tSphere_fp, dy_fp))
      val hitZ_fp = trunc32(camZ_fp + tSphere_fp)

      val twoS  = trunc32(s_fp << 1)
      val twoSt = mulFP(twoS, tSphere_fp)
      val bigK  = trunc32(toFP(1.0) + twoSt)
      val rdirX = trunc32(mulFP(bigK, dx_fp) + mulFP(twoS, ocX_fp))
      val rdirY = trunc32(mulFP(bigK, dy_fp) + mulFP(twoS, ocY_fp))
      val rdirZ = trunc32(bigK + mulFP(twoS, ocZ_fp))

      if (rdirY >= 0) gSphereSky
      else {
        val rdirYSafe: Long = if (rdirY == 0L) toFP(-1.0) else rdirY
        val negHitY = trunc32(-hitY_fp)
        val tRefl_fp = divFP(negHitY, rdirYSafe)
        val reflHitX = trunc32(hitX_fp + mulFP(tRefl_fp, rdirX))
        val reflHitZ = trunc32(hitZ_fp + mulFP(tRefl_fp, rdirZ))
        val rfx = (reflHitX >> 16).toInt
        val rfz = (reflHitZ >> 16).toInt
        if (((rfx + rfz) & 1) != 0) gSphereFloorLight else gSphereFloorDark
      }
    }
  }

  private def pokeScene(dut: RayTracerAccelerator, p: SceneParams): Unit = {
    def toFP(x: Double): Long = math.round(x * (1L << 16))
    dut.io.camX.poke(toFP(p.camX).S(dut.FpW.W))
    dut.io.camY.poke(toFP(p.camY).S(dut.FpW.W))
    dut.io.camZ.poke(toFP(p.camZ).S(dut.FpW.W))
    dut.io.sphereX.poke(toFP(p.sphereX).S(dut.FpW.W))
    dut.io.sphereY.poke(toFP(p.sphereY).S(dut.FpW.W))
    dut.io.sphereZ.poke(toFP(p.sphereZ).S(dut.FpW.W))
    dut.io.cols.poke(p.cols.U(13.W))
    dut.io.rows.poke(p.rows.U(13.W))
    dut.io.scaleX.poke(toFP(p.scaleX).S(dut.FpW.W))
    dut.io.scaleY.poke(toFP(p.scaleY).S(dut.FpW.W))
  }

  // raster-order pixels, ready always asserted
  private def captureScene(dut: RayTracerAccelerator, p: SceneParams): Array[Int] = {
    val data = Array.fill(p.total)(-1)
    dut.clock.setTimeout(0)
    pokeScene(dut, p)
    dut.io.start.poke(false.B)
    dut.io.pixel.ready.poke(true.B)

    dut.io.start.poke(true.B)
    dut.clock.step()
    dut.io.start.poke(false.B)

    var idx    = 0
    var cycles = 0
    val maxCycles = p.total * 30 + 200
    while (dut.io.busy.peek().litToBoolean && cycles < maxCycles) {
      if (dut.io.pixel.valid.peek().litToBoolean) {
        val d = dut.io.pixel.bits.peek().litValue.toInt
        if (idx < p.total) data(idx) = d
        idx += 1
      }
      dut.clock.step()
      cycles += 1
    }
    assert(cycles < maxCycles, s"timeout: busy never fell within $maxCycles cycles")
    data
  }

  private def writePgm(path: String, p: SceneParams, byteAt: (Int, Int) => Int): Unit = {
    val file = java.nio.file.Paths.get(path)
    Option(file.getParent).foreach(java.nio.file.Files.createDirectories(_))
    val out = new java.io.BufferedOutputStream(new java.io.FileOutputStream(path))
    try {
      out.write(s"P5\n${p.cols} ${p.rows}\n255\n".getBytes("US-ASCII"))
      for (r <- 0 until p.rows; c <- 0 until p.cols) out.write(byteAt(c, r) & 0xFF)
    } finally out.close()
    println(s"wrote PGM: $path (${p.cols}x${p.rows})")
  }

  private def writeBmp(path: String, p: SceneParams, byteAt: (Int, Int) => Int): Unit = {
    val file = java.nio.file.Paths.get(path)
    Option(file.getParent).foreach(java.nio.file.Files.createDirectories(_))
    val rowBytes = p.cols * 3
    val pad = (4 - (rowBytes & 3)) & 3
    val pixelBytes = (rowBytes + pad) * p.rows
    val fileSize = 54 + pixelBytes
    val buf = java.nio.ByteBuffer.allocate(fileSize).order(java.nio.ByteOrder.LITTLE_ENDIAN)
    buf.put('B'.toByte); buf.put('M'.toByte)
    buf.putInt(fileSize); buf.putShort(0); buf.putShort(0); buf.putInt(54)
    buf.putInt(40); buf.putInt(p.cols); buf.putInt(p.rows)
    buf.putShort(1); buf.putShort(24); buf.putInt(0); buf.putInt(pixelBytes)
    buf.putInt(2835); buf.putInt(2835); buf.putInt(0); buf.putInt(0)
    // BMP rows are bottom-up
    for (r <- (p.rows - 1) to 0 by -1) {
      for (c <- 0 until p.cols) {
        val g = (byteAt(c, r) & 0xFF).toByte
        buf.put(g); buf.put(g); buf.put(g)
      }
      for (_ <- 0 until pad) buf.put(0.toByte)
    }
    java.nio.file.Files.write(file, buf.array())
    println(s"wrote BMP: $path (${p.cols}x${p.rows})")
  }

  private def writePng(path: String, p: SceneParams, byteAt: (Int, Int) => Int): Unit = {
    val file = java.nio.file.Paths.get(path)
    Option(file.getParent).foreach(java.nio.file.Files.createDirectories(_))
    val img = new java.awt.image.BufferedImage(p.cols, p.rows, java.awt.image.BufferedImage.TYPE_BYTE_GRAY)
    val raster = img.getRaster
    val px = new Array[Int](1)
    for (r <- 0 until p.rows; c <- 0 until p.cols) {
      px(0) = byteAt(c, r) & 0xFF
      raster.setPixel(c, r, px)
    }
    javax.imageio.ImageIO.write(img, "png", file.toFile)
    println(s"wrote PNG: $path (${p.cols}x${p.rows})")
  }

  "32x32 HW at default camera matches exact Q16.16 reference" in {
    val p = defaultScene
    test(new RayTracerAccelerator) { dut =>
      val data = captureScene(dut, p)
      for (i <- 0 until p.total) {
        val c = i % p.cols
        val r = i / p.cols
        val expected = refByte(c, r, p)
        assert(data(i) == expected,
          f"($c%d,$r%d) got 0x${data(i)}%02x, expected 0x$expected%02x")
      }
    }
  }

  "32x32 HW at offset camera (0.5, 1, -3) matches reference — exercises runtime camera path" in {
    val p = defaultScene.copy(camX = 0.5)
    test(new RayTracerAccelerator) { dut =>
      val data = captureScene(dut, p)
      for (i <- 0 until p.total) {
        val c = i % p.cols
        val r = i / p.cols
        val expected = refByte(c, r, p)
        assert(data(i) == expected,
          f"($c%d,$r%d) got 0x${data(i)}%02x, expected 0x$expected%02x")
      }
    }
  }

  "16x16 HW at default scene matches reference — exercises runtime cols/rows path" in {
    val p = defaultScene.copy(cols = 16, rows = 16, scaleX = 1.0 / 12.0, scaleY = 1.0 / 12.0)
    test(new RayTracerAccelerator) { dut =>
      val data = captureScene(dut, p)
      for (i <- 0 until p.total) {
        val c = i % p.cols
        val r = i / p.cols
        val expected = refByte(c, r, p)
        assert(data(i) == expected,
          f"($c%d,$r%d) got 0x${data(i)}%02x, expected 0x$expected%02x")
      }
    }
  }

  "32x32 HW with offset sphere (1.0, 1.0, 0.0) matches reference — exercises runtime sphere path" in {
    val p = defaultScene.copy(sphereX = 1.0)
    test(new RayTracerAccelerator) { dut =>
      val data = captureScene(dut, p)
      for (i <- 0 until p.total) {
        val c = i % p.cols
        val r = i / p.cols
        val expected = refByte(c, r, p)
        assert(data(i) == expected,
          f"($c%d,$r%d) got 0x${data(i)}%02x, expected 0x$expected%02x")
      }
    }
  }

  "Dump: 32x32 hardware output at default pose" in {
    val p = defaultScene
    test(new RayTracerAccelerator) { dut =>
      val data = captureScene(dut, p)
      writePgm("build/raytracer/hw_default.pgm", p, (c, r) => data(r * p.cols + c))
      writeBmp("build/raytracer/hw_default.bmp", p, (c, r) => data(r * p.cols + c))
      writePng("build/raytracer/hw_default.png", p, (c, r) => data(r * p.cols + c))
    }
  }

  "Dump: high-resolution (1920x1080) pure-Scala reference" in {
    // pure Scala, no ChiselSim. Same bit-exact math, just to see what 1080p looks like.
    val p = defaultScene.copy(cols = 1920, rows = 1080,
      scaleX = 1.0 / 810.0, scaleY = 1.0 / 810.0)
    writePgm("build/raytracer/ref_1080p.pgm", p, (c, r) => refByte(c, r, p))
    writeBmp("build/raytracer/ref_1080p.bmp", p, (c, r) => refByte(c, r, p))
    writePng("build/raytracer/ref_1080p.png", p, (c, r) => refByte(c, r, p))
  }

  "Start pulse re-runs the scene from cell 0" in {
    val p = defaultScene
    test(new RayTracerAccelerator) { dut =>
      dut.clock.setTimeout(0)
      pokeScene(dut, p)
      dut.io.start.poke(false.B)
      dut.io.pixel.ready.poke(true.B)
      var guard = 0
      while (dut.io.busy.peek().litToBoolean && guard < p.total * 30 + 200) {
        dut.clock.step()
        guard += 1
      }
      dut.io.busy.expect(false.B)

      dut.io.start.poke(true.B)
      dut.clock.step()
      dut.io.start.poke(false.B)

      dut.io.busy.expect(true.B)
    }
  }
}
