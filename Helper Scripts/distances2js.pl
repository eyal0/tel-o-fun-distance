#!/usr/local/bin/perl -w

use strict;
use warnings;

my @rows = <>;

sub sorter {
  my @a = split(/,/, $a);
  my @b = split(/,/, $b);
  if(($a[0] <=> $b[0]) != 0) {
    return $a[0] <=> $b[0];
  } else {
    return $a[1] <=> $b[1];
  }
}

@rows = sort sorter @rows;

#print join("", @rows);

print "var distances = {";
my $count = 0;
foreach my $row (@rows) {
  if($count % 10 != 0) {
    print "  ";
  } else {
    print "\n  ";
  }

  my @elems = split(/,/, $row);
  printf("%6.0f", $elems[2] * 1000);
  $count++;
  if($count < @rows) {
    print ",";
  }
}
print "\n};\n";
