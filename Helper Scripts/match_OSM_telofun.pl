#!/usr/local/bin/perl -w

use strict;
use warnings;

use Math::Trig;

open(STATIONS, "<telofun_stations.csv");
my @stations;

while(<STATIONS>) {
  my @station_info = split /,/;
  push @stations, [@station_info];
}

open(NODES, "<OSM_nodes.csv");
my @nodes;

while(<NODES>) {
  my @node_info = split /,/;
  push @nodes, [@node_info];
}

my @distances;

sub Haversine {
  my ($lat1, $long1, $lat2, $long2) = @_;
  my $r=3956;

  my $dlong = deg2rad($long1) - deg2rad($long2);
  my $dlat  = deg2rad($lat1) - deg2rad($lat2);

  my $a = sin($dlat/2)**2 +cos(deg2rad($lat1)) 
      * cos(deg2rad($lat2))
      * sin($dlong/2)**2;
  my $c = 2 * (asin(sqrt($a)));
  my $dist = $r * $c;
  return $dist;
}

for(my $i=0; $i < @stations; $i++) {
  for(my $j=0; $j < @nodes; $j++) {
    my $station_id = $stations[$i][0];
    my $station_lat = $stations[$i][1];
    my $station_lon = $stations[$i][2];
    my $node_id = $nodes[$j][0];
    my $node_lat = $nodes[$j][1];
    my $node_lon = $nodes[$j][2];
    my $distance = Haversine($station_lat, $station_lon, $node_lat, $node_lon);
    push @distances, [$distance, $station_id, $node_id];
  }
}

my @final_distances;

while(@distances > @stations) {
  @distances = sort {$a->[0] <=> $b->[0]} @distances;
  #assume that the first one is right
  push(@final_distances, $distances[0]);  #save for later

  #remove the others
  @distances = grep({$_->[1] != $distances[0][1] && $_->[2] != $distances[0][2]} @distances[1..@distances-1]);
}

map {print join(",", @{$_}); print "\n";} @final_distances;
exit();
