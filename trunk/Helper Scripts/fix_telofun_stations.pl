#!/usr/local/bin/perl -w

use strict;
use warnings;

open(NODES, "<OSM_nodes.csv");
my %nodes;

while(<NODES>) {
  chop;
  my @node_info = split /,/;
  $nodes{$node_info[0]} = [@node_info[1..2]];
}

my %corrections;
while(<>) {
  chop;
  my @correction = split /,/;
  $corrections{$correction[1]} = $nodes{$correction[2]};
}

open(STATIONS, "<telofun_stations.csv");
my @stations;

while(<STATIONS>) {
  chop;
  my @station_info = split /,/;
  if(exists $corrections{$station_info[0]}) {
    splice(@station_info,1,2,@{$corrections{$station_info[0]}});
  }
  print join(",", @station_info) . "\n";
}
