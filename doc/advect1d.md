---
title: Advect1d
---

Advect1d is a 1-d advection solver. It translates an arbitrary function through a periodic 1-D domain. The example Fortran code consists of advect1d and interfaces between advect1d and LightDA. A python wrapper is provided that advances an ensemble of advect1d simulations, periodically stopping to assimilate synthetic observations.

## Building

Building advect1d and its LightDA interface requires CMake, MPI, HDF5, and a Fortran compiler.

To build advect1d and its LightDA interface:

```
cd /path/to/lightda-examples
mkdir examples/advect1d/build
cd examples/advect1d/build
cmake ../superbuild
make
```

Advect1d and its python wrapper will be installed in the directory lightda-examples-advect1d.

## Running

The python example code can be run from the build directory with

```bash
venv/bin/python -m advect1d.animate_mpi
```

An animated spaghetti plot should appear, showing an ensemble of advect1d simulations. Periodically the animation will pause as synthetic data is assimilated.