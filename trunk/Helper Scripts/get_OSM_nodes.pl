#!/usr/local/bin/perl -w

use strict;
use warnings;

open(NODE_LIST, "wget -O - 'http://www.openstreetmap.org/api/0.6/relation/1435552' |");

while(<NODE_LIST>) {
  if(/ref="(\d+)"/) {
    my $node_id = $1;
    open(NODE, "wget -O - 'http://www.openstreetmap.org/api/0.6/node/$node_id' |");
    while(<NODE>) {
      if(/lat="([0-9.]+)" lon="([0-9.]+)"/) {
        print("$node_id,$1,$2\n");
      }
    }
  }
}
