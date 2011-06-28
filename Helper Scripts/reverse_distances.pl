#!/usr/local/bin/perl -w

use strict;
use warnings;

my @rows = <>;

my %distances;
chop(@rows);
foreach my $row (@rows) {
  my @row_info = split(/,/, $row);
  $distances{"$row_info[0],$row_info[1]"} = $row_info[2];
}
foreach my $row (@rows) {
  my @row_info = split(/,/, $row);
  if($row_info[2] == 9999) {
    $row_info[2] = $distances{"$row_info[1],$row_info[0]"};
    $row = join(",", @row_info);
  }
}

print join "\n", @rows;
print "\n";
