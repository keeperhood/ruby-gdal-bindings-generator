This repository contains bash scripts and a Dockerfile that can be used for generating ruby bindings from GDAL 1.11.5 (latest before 2.x).

**Usage**

```bash
./generate-ruby-bindings.sh
```

This command should produce the following file tree structure:

```
generated/
├── gdal.cpp
├── ogr.cpp
└── osr.cpp
```

The *.cpp files can be copied into the ruby-gdal gem source for recompiling the gem.