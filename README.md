
# SquashFS through Singularity : Hints And Tips

This repository contains code, examples, hints and other documentation
related to using singularity containers as access methods to overlay
files (typically, squashfs files).

The data organization addressed here generally consists of

1. Having one or several `.squashfs` files that contain the data;
2. Having a singularity container image with specific capabilities (`rsync`, `openssh` etc);
3. Combining the two, along with other scripts, to build a system that can seemlessly access the data files.

## What this repo contains

* The directory `build_data` contains code and instructions to make squashfs files;
* The directory `build_simg` contains code and instructions to build a singularity container;
* The directory `bin` contain some utility scripts (e.g. `sing_sftpd`);
* The directory `examples` contains sample README files to install with your data, for helping users access it;
* The directory `images` contains a PDF of technical diagrams, and its source in OmniGraffle format;
* The rest of this README here contains hints and code snippets on accessing the data files.

## Accessing data files

For the examples below, let's assume we have a data distribution directory
containing two SquashFS filesystem files, and a singularity container image
file:

```
unix% ls -l
total 83068518941
-rw-r--r-- 1 prioux rpp-aevans-ab 1508677619712 Aug  1 16:13 hcp1200-00-100206-103414.squashfs
-rw-r--r-- 1 prioux rpp-aevans-ab 1532533477376 Aug  1 20:33 hcp1200-01-103515-108020.squashfs
-rwxr-xr-x 1 prioux rpp-aevans-ab     147062784 Dec  3 16:51 sing_squashfs.simg
```

(This example is taken as a subset of a real dataset, and more information about it can
be found by reading the file [README.txt](examples/hcp_1200_README.txt) that was provided
to its users)

The two squashfs files store a bunch of data files inside them under the root path `/HCP_1200_data`. The first file
contains 20 subdirectories named `100206` ... `103414`, and the second file contains 20 subdirectories
named `103515` ... `108020`.

### a) Connecting interactively (low-level, directly)

This will allow you to have a look at the files, with only the first squashfs file mounted:

```
singularity shell --overlay=hcp1200-00-100206-103414.squashfs sing_squashfs.simg
```

You can then `cd /HCP_1200_data` and `ls` the files. Use `exit` to exit the container!

To get both squashfs files:

```
singularity shell --overlay=hcp1200-00-100206-103414.squashfs --overlay=hcp1200-01-103515-108020.squashfs sing_squashfs.simg
```

Now you can notice that the content of `/HCP_1200_data` has 40 subdirectories instead of just 20.

To connect with all .squashfs file, no matter how many:

```
singularity shell $(ls -1 | grep '\.squashfs$' | sed -e 's/^/--overlay /') sing_squashfs.simg
```

### b) Running a command (low-level, directly)

This is just like in a) above, but instead of running `singularity shell` we run `singularity exec`:

```
singularity exec --overlay=hcp1200-00-100206-103414.squashfs sing_squashfs.simg ls -l /HCP_1200_data
```

### c) Running a command (with utility wrapper)

In the [bin](bin) directory of this repo, you will find a set of utility wrapper
scripts. In fact, it's a single script with multiple names. It has many features
and options allowing you to choose which squashfs files to access and which singularity
image file to run, but the simplest use scenario is to copy the one called `sing_command_here`
into the same directory as the squashfs files and singularity image:

```
unix% ls -l
total 83068518941
-rw-r--r-- 1 prioux rpp-aevans-ab 1508677619712 Aug  1 16:13 hcp1200-00-100206-103414.squashfs
-rw-r--r-- 1 prioux rpp-aevans-ab 1532533477376 Aug  1 20:33 hcp1200-01-103515-108020.squashfs
-rwxr-xr-x 3 prioux rpp-aevans-ab          7542 Dec  3 16:57 sing_command_here
-rwxr-xr-x 1 prioux rpp-aevans-ab     147062784 Dec  3 16:51 sing_squashfs.simg
```

When invoked, it will automatically detect those files around it. Now you can run
the same command as in example b) above, but in a simpler way:

```
# Run on all squashfs files:
./sing_command_here ls -l /HCP_1200_data

# Run on just one squashfs file:
./sing_command_here -O hcp1200-00-100206-103414.squashfs ls -l /HCP_1200_data
```

### d) Mounting the data files using sshfs

TODO

### e) Extracting data using rsync

TODO

### f) Streaming data with cat

TODO

## Other tricks and tips

* Writable overlays?

