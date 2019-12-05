
# How to build a container image file suitable for accessing squashfs files

All access to SquashFS files as a non-privileged user is accomplished
through a Singularity container. The image for that container doesn't
need to include anything particular if one just wants to enter it and
work from within the container.

If the container is to be used by other external access programs
(e.g. sshfs or rsync, as explained in other parts of this GitHub repo)
then it must include a few more system packages:

* openssh-server :
  This package provides /usr/libexec/openssh/sftp-server (Centos) or /usr/lib/sftp-server (Ubuntu)
* rsync :
  This package provides the rsync executable

To build a singularity container image with both of these, we provide
here a [singularity definition file](https://sylabs.io/guides/3.0/user-guide/definition_files.html).

This command (run as root) will build the container in the file `sing_squashfs.simg`.

```shell
singularity build sing_squashfs.simg sing_squashfs.def
```

Note that singularity doesn't care all that much about the extension given
to the image file, so you can also call it with `.img` or `.sif` instead of `.simg`.

