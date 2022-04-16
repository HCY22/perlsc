#!/usr/bin/perl
# usage : Transpose.pl [matrix]
# to do : rotate the maxtrix

use strict;

my $mx = [];

while(<>) {
	my @F = split "\t"; chomp $F[-1];
	push @{ $mx->[$_] }, $F[$_] foreach 0..$#F;
}

foreach my $r (@$mx) {
	print join("\t", @$r), "\n";
}
