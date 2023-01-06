#!/usr/bin/perl -s
# usage : Index.pl -sep="\t" -col=1 file
# to do : get table header

$sep ||= "\t";
$col ||= 1;

<> while $col-- > 1;
$_ = <>;
my @F = split $sep;
print "$_\t$F[$_]\n" for 0..$#F;
