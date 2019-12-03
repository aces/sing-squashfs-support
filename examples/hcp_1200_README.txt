
#####################################################
# HCP 1200 Subjects Data Release in SquashFS format #
#####################################################

This directory contains the HCP 1200 dataset for 1113 subjects, as
downloaded by Shawn Brown for the ACE lab and processed by Pierre Rioux.

It contains 16656085 files and subdirectories and uses 83 terabytes of space.

Okay so... maybe you have questions?

1) Wait, I only see 56 files here.

Yep, these are the SquashFS files; each file contain the information
for 20 subjects. The names of the files contain the range of subjects,
e.g. the file

   hcp1200-00-100206-103414.squashfs

contains subjects 100206 to 103414.

2) Is this like a tar archive?

Nope, there is no need to uncompress or unarchive any of these squashfs
files.

3) But how do I access the files then?

Using singularity. Version 3.2 or better is needed, and happens to be
installed on Beluga (type "module load singularity/3.2").

Using any container of your choice, you can 'mount' these files inside
your container, and magically all the HCP dataset files will appear in
your container's filesystem space. A simple CentOS container is provided
here for you to experiment with (it's the file called sing_squashfs.simg).

  # Make sure 3.2 is loaded; only needed once per login (consider putting this in your bashrc)
  module load singularity/3.2

  # Enter a shell in the container with one of the SquashFS file mounted:
  singularity shell --overlay hcp1200-00-100206-103414.squashfs sing_squashfs.simg

  # Have a look at the 20 subjects, they will be under the path "/HCP_1200_data"
  ls -l /HCP_1200_data

  # Exit the container and return to beluga.
  exit

4) Can I access more subjects instead of just 20 at a time?

Of course. Add more --overlay options to the singularity command. All subjects
will appear under /HCP_1200_data.

To get the first 40 subjects:

  singularity shell \
    --overlay hcp1200-00-100206-103414.squashfs \
    --overlay hcp1200-01-103515-108020.squashfs \
    sing_squashfs.simg

To get them all, using bash magic:

  singularity shell $(ls -1 | grep 'hcp1200.*squashfs' | sed -e 's/^/--overlay /') sing_squashfs.simg

5) I see all these annoying WARNING messages...

Use the '-s' option (silent) of singularity:

  singularity -s shell --overlay ...

6) What if I want to run an analysis program on these files, instead
of just browsing them with a shell?

Either start your program from that shell, or use the singularity
'exec' command instead. Also remember that you can use any singularity
container, including the ones with your favorite programs in them.

  # To run the 'ls -l' command on a subject, without entering
  # the container interactively with a shell:
  singularity exec --overlay hcp1200-00-100206-103414.squashfs sing_squashfs.simg /bin/ls -l /HCP_1200_data/100408

7) Isn't this all slower than just having the files directly on Beluga?

Nope, it's the other way around. Once mounted, these SquashFS filesystems
are much, much faster than having the plain files around. Within
singularity, you can do a 'ls' of all 16 million files in about 3 minutes;
the same test on Beluga would probably take hours.

Also, as you can see, the entire dataset fits in a small number of files,
each of them of large size (between 1.1 and 2.0 terabytes each), which is
a great organization for large production clusters. And finally, our lab's
quota is very much restricted in the number of files we can have, so it
would simply not be possible to have the dataset as normal files anyway.

8) Are there other ways to access the data files?

Of course! The website https://github.com/aces/sing-squashfs-support
contains hints and tips. Through the use of utility commands that
happen to be installed here too, you can:

   a) mount the files using sshfs (sing_sftpd_here)
   b) rsync the content out of there (sing_rsync_here)
   c) run a command in an easier way than described above (sing_command_here)

Just don't rsync the entire dataset out, it's nonsensical and
you don't have the room anyway!

9) Who do I contact to complain?

Shawn T Brown, my manager.

10) Who do I contact to give praise?

Pierre Rioux, with Cc to Shawn T Brown.

