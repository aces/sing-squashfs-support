#!/bin/bash

cd /lustre03/project/6008063/prioux/UKBB_squashfs || exit
perl mk_bids_sqfs.pl ~/projects/rpp-aevans-ab/ukbb/data/BIDS 3000

