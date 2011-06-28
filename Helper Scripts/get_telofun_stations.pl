#!/usr/local/bin/perl -w

use strict;
use warnings;

open(STATION_LIST, "wget -O - 'http://www.tel-o-fun.co.il/%D7%AA%D7%97%D7%A0%D7%95%D7%AA%D7%AA%D7%9C%D7%90%D7%95%D7%A4%D7%9F.aspx' |");

while(<STATION_LIST>) {
  while(/sid='(\d+)' x='([0-9.]+)' y='([0-9.]+)'>([^<]+)</g) {
    print("$1,$3,$2,$4\n");
  }
}
