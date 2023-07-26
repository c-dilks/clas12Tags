#!/usr/bin/env zsh

# Purpose:
# Checkout clas12-config and prepare the matrix of tests to be run

# The remote container (for now) is based on fedora 36, so cvmfs action is not available,
# see https://github.com/cvmfs-contrib/github-action-cvmfs (only ubuntu supported)
# Container run:
# docker run -it --rm --platform linux/amd64 jeffersonlab/base:fedora36 sh
# git clone http://github.com/gemc/clas12Tags /root/clas12Tags && cd /root/clas12Tags
# ./ci/gcards_to_test.sh

validTags=(4.4.2 dev)
git clone https://github.com/JeffersonLab/clas12-config

echo "{\"include\":["
for clas12Tag in $validTags; do
  # if $clas12Tags is not dev, gcards are the files in clas12-config/gemc/$clas12Tags/config,
  # otherwise they are in config
  if [[ $clas12Tag != "dev" ]]; then
    gcards=($(ls clas12-config/gemc/$clas12Tag/*.gcard))
  else
    gcards=($(ls config/*.gcard))
  fi
  for jc in $=gcards; do
    echo "{\"gcard\": \"$jc\"}"
  done
done

echo "]}"