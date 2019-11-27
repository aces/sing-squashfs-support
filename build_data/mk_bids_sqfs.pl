#!/usr/bin/perl

use strict;
use warnings;

die "Usage: $0 bids_root_path num_subjects_per_fs\n" unless @ARGV == 2;
my $PATH   = shift;
my $NUMSUB = shift()+ 0;

die "Error: num_subjects_per_fs must be a number > 1\n" unless $NUMSUB > 1;
die "Error: Path doesn't seem to be a directory\n" unless -d $PATH;

my @subjects = `/bin/ls -1f $PATH`;
chomp(@subjects);
@subjects = grep(/^sub-/, @subjects);
@subjects = sort(@subjects);

print "Found ",scalar(@subjects), " subjects.\n";
die "Error: Not subjects found.\n" if @subjects == 0;

sub subname {
  my $sub = shift; # e.g. sub-123455
  $sub =~ s/^sub-//;
  $sub;
}

my $slice = 0;
for (my $i=0;$i<@subjects;$i+=$NUMSUB) {
  my $end = $i+$NUMSUB-1; # inclusive
  $end = $#subjects if $end > $#subjects;
  my $first = subname($subjects[$i]);
  my $last  = subname($subjects[$end]);
  printf "start=%6.6d\tend=%6.6d\t%s\t%s\n",$i,$end,$first,$last;

  my @exclude = @subjects;
  splice(@exclude,$i,$NUMSUB);

  my $fsname = "bids-$slice-$first-$last.squashfs";
  if (-e $fsname) {
    print "Skipping: File already exists: $fsname\n";
    next;
  }

  my $res = system(
    "mksquashfs", $PATH, $fsname,
      "-noI", "-noD", "-noF", "-noX", "-no-xattrs", "-no-exports",
      "-processors", "1",
      "-keep-as-directory",
      "-e", @exclude
  );
  my $rc = $res >> 8;
  if ($rc > 0 || (($res & 127) > 0)) {
    print "Failed: rc=$rc, res=$res\n";
    exit(2);
  }

  $slice += 1;
}

