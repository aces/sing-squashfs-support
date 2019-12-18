
# How to build a set of .squashfs files to store a large set of data files.

This document provides hints and tips on creating one or several
SquashFS filesystems to hold static data files.

## Prerequisites & Assumptions

The core unix utility to create squashfs filesystems is called
`mksquashfs`.  It comes from the `squashfs-tools` package.

None of the operations described below require root access.

We will assume we are trying to package a large directory structure.
As a general model, let us say it is stored under the path `/data/large`
and that under that directory, a set of 1000 data subdirectories
exist, named like this:

```
001   116   ...   431   ...   761   876   991
002   117   ...   432   ...   762   877   992
003   118   ...   433   ...   763   878   993
004   119   ...   434   ...   764   879   994
...
```

Of course they can be named anything else, the procedure below
works just as well.

## Figuring out how to pack things

First, run this to figure out the amount of disk space on each
separate data subdirectory:

```
cd /data/large
du -h -s -c *
```

You will get a size for each of them, and a total size report at
the end.

### a) When the total size is small

If the total amount of data is less than a terabyte, there's probably
no point in trying to split it into several squashfs filesystems;
just build a single large one and you'll be on your way. The utility
called `mk_sq_slice` in this directory will do it for you and even
re-root the data unto any other path that you find more elegant
within the new filesystem. This command would do the trick:

```
mk_sq_slice mynewfs.sqs /newroot /data/large/*
```

Run `mk_sq_slice -h` to get an explanation of its options and arguments.

### b) When the total size is large

In the case where the total amount of data is several terabytes,
it is better to start considering splitting the dataset into several
distinct squashfs filesystems. Not to worry, once all the squashfs
filesystems are mounted, it will look like all the files are together
again.

Given we have 1000 subdirectories named `000` to `999`, we need to figure
out how many of those we want to group together into each squashfs
filesystem. The size of the squashfs filesystem should be (in 2019) between
1TB and 2TB (problems can occur if the files are greater than 2TB, but
this is not about squashfs, it's about the host filesystem itself).
Let's say we determined that we can put 150 data subdirectories into
each filesystem. Then we will need to create a filesystem for data
directories `000` to `149`, another one for `150` to `299` etc.

The utility command `mk_sq_all` will perform this operation for
you. You give it a prefix for your squashfs files, the path to
the container directory for all the data subdirectories, and
the number of data subdirectories you want in each filesystem,
and it will run the command `mk_sq_slice` for you as often as needed
to create the needed squashfs filesystems.

```
mk_sq_all supdata /newroot /data/large 150
```

This produces seven squashfs filesystem files:

* supdata_00.squashfs (containing data 000 to 149)
* supdata_01.squashfs (containing data 150 to 299)
* supdata_02.squashfs (containing data 300 to 449)
* supdata_03.squashfs (containing data 450 to 599)
* supdata_04.squashfs (containing data 600 to 749)
* supdata_05.squashfs (containing data 750 to 899)
* supdata_06.squashfs (containing data 900 to 999)

Run `mk_sq_all -h` to get more information about this program.

