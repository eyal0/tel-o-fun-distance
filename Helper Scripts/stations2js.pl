#!/usr/local/bin/perl -w

use strict;
use warnings;
use open qw(:std :utf8);
use Encode;

my @rows = <>;
chop @rows;

sub sorter {
  my @a = split(/,/, $a);
  my @b = split(/,/, $b);
  return $a[0] <=> $b[0];
}

@rows = sort sorter @rows;

#print join("", @rows);

print "var stations = {";
my $count = 0;
foreach my $row (@rows) {
  if($count % 1 != 0) {
    print "  ";
  } else {
    print "\n  ";
  }

  my @elems = split(/,/, $row);
  printf("\"\\u%s\":%d", join("\\u", map({sprintf "%04x", ord;} split(//, $elems[3]))), $count);
  $count++;
  if($count < @rows) {
    print ",";
  }
}
print "\n};\n";
