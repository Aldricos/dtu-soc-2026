scalaVersion := "2.13.14"

scalacOptions ++= Seq(
  "-feature",
  "-language:reflectiveCalls",
)
fork := true

Compile / unmanagedSourceDirectories += baseDirectory.value / "wildcat/src"
Compile / unmanagedSourceDirectories += baseDirectory.value / "wildcat/soc-comm/src"
Compile / unmanagedSourceDirectories += baseDirectory.value / "wildcat/ip-contributions/src"

val chiselVersion = "6.7.0"
addCompilerPlugin("org.chipsalliance" % "chisel-plugin" % chiselVersion cross CrossVersion.full)
libraryDependencies += "org.chipsalliance" %% "chisel" % chiselVersion
libraryDependencies += "edu.berkeley.cs" %% "chiseltest" % "6.0.0"
libraryDependencies += "com.fazecast" % "jSerialComm" % "[2.0.0,3.0.0)"
libraryDependencies += "net.fornwall" % "jelf" % "0.9.0"