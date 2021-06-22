LightDA is a lightweight, extensible data assimilation library. It is designed with the following goals in mind:

- The data assimilation process be model-agnostic, and adding a new model should be as simple as possible
- Assimilation can be done in parallel if needed
- Parallel models are supported without making any assumptions about how the model's parallelism is implemented

This repository contains usage examples for LightDA.

## Requirements

LightDA requires CMake 3.0.2 or later, a Fortran 2008 compiler (gcc 4.9.4 and later and ifort 2021 have been tested) and an MPI library. Building the LightDA documentation additionally requires Python 3.5 or later. The LightDA examples also require HDF5 and a python interpeter with the matplotlib and ffi packages.

## Quick start

Use the following commands to build lightda-examples and its dependencies (including the LightDA core library):
```bash
git clone https://github.com/LightDA-assim/lightda-examples.git
cd lightda-examples
mkdir build
cmake ../superbuild
make
```
