#!/usr/local/bin/perl -w

use strict;
use warnings;

my @rows = <>;

chop(@rows);

for(my $i=0; $i < @rows; $i++) {
  for(my $j=0; $j < @rows; $j++) {
    #next if($i == $j);

    $rows[$i] =~ /(\d+),([0-9.]+),([0-9.]+),/;
    my($id1) = $1;
    my($lat1) = $2;
    my($lon1) = $3;
    $rows[$j] =~ /(\d+),([0-9.]+),([0-9.]+),/;
    my($id2) = $1;
    my($lat2) = $2;
    my($lon2) = $3;

    my $shortest_distance;
    my $bike_distance = 9999;
    my $foot_distance = 9999;

    unlink <short*>;
    #print("./router --lat1=$lat1 --lon1=$lon1 --lat2=$lat2 --lon2=$lon2 --transport=foot --profile=foot --dir=\"../data/\"\n");
    system("./router --quiet --lat1=$lat1 --lon1=$lon1 --lat2=$lat2 --lon2=$lon2 --transport=foot --profile=foot --dir=\"../data/\"");
    if(open(SHORTEST, "<shortest.txt")) {
      for(my $k=0; $k<6; $k++) {
        <SHORTEST>; #discard
      }
      $foot_distance = 0;
      while(<SHORTEST>) {
        my($lat, $lon, $distance) = split;
        $foot_distance += $distance;
      }
    }

    unlink <short*>;
    #print("./router --lat1=$lat1 --lon1=$lon1 --lat2=$lat2 --lon2=$lon2 --transport=bicycle --profile=bicycle --dir=\"../data/\"\n");
    system("./router --quiet --lat1=$lat1 --lon1=$lon1 --lat2=$lat2 --lon2=$lon2 --transport=bicycle --profile=bicycle --dir=\"../data/\"");
    if(open(SHORTEST, "<shortest.txt")) {
      for(my $k=0; $k<6; $k++) {
        <SHORTEST>; #discard
      }
      $bike_distance = 0;
      while(<SHORTEST>) {
        my($lat, $lon, $distance) = split;
        $bike_distance += $distance;
      }
    }

    if($bike_distance == $foot_distance) {
      print("$id1,$id2,$bike_distance,tie,$bike_distance,$foot_distance\n");
    } elsif($foot_distance < $bike_distance) {
      print("$id1,$id2,$foot_distance,foot,$bike_distance,$foot_distance\n");
    } else {
      print("$id1,$id2,$bike_distance,bicycle,$bike_distance,$foot_distance\n");
    }
  }
}
