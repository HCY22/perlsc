#!/usr/bin/perl
# usage : Sum.pl [matrix]
# to do : sum each field

use strict;

my $total = 0;

sub sum(\@) {
	my ($arref) = @_;
	my $sum = 0;
	$sum += $arref->[$_] foreach 0..$#$arref;
	return $sum;
}

while(<>) {
	my @F =  split "\t";
	$total += sum @F;
}
print "$total\n";
