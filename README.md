
# SquashFS through Singularity : Supporting Code

This repository contains code, examples, hints and other documentation
related to using singularity containers as access methods to overlay
files (typically, squashfs files).

The data organization addressed here generally consists of

1. Creating one or several `.squashfs` files that contain the data;
2. Having a singularity container image with specific capabilities (`rsync`, `openssh` etc);
3. Combining the two, along with other scripts, to build a system that can seemlessly access the data files.

## What this repo contains

* The directory `build_data` contains code and instructions to make squashfs files
* The directory `build_simg` contains code and instructions to build a singularity container
* The directory `bin` contain some utility scripts (e.g. `sing_sftpd`)
* The directory `examples` contains sample README files to install with your data, for helping users access it.

## Accessing data files

* TODO direct program in container

* TODO mount using sshfs and sing_sftpd

## Other tricks and tips

* Writable overlays?

