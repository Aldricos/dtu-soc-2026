### Integrate Wildcat in Caravel
Import the 3-stage wildcat using
```scala
    import wildcat.pipeline._
```
in `CaravelTop`

Compile binary (example "Blink"):
```bash
    make -C wildcat/ app APP=asm/apps/blink.s
```

A binary file will be created
```txt
    "wildcat/a.out"
```

Initiate the wildcat as a module and make the relevant I/O connections. Ex
```Scala
val wc = Module(new WildcatTop("wildcat/a.out"))
val led = wc.io.led
val tx = wc.io.tx
wc.io.rx := false.B //Tentative
```

Run the CaravelTop
```shell
sbt "runMain CaravelTop"
```




