#!/bin/bash

mv *.patch ../skiffos/buildroot
cd ../skiffos/buildroot

# specify here which patches to apply
git apply br-mesa3d-vc4.patch 
