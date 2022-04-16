#!/usr/bin/perl
# usage : Join.pl [-i -j] file1 file2
# to do : join file1 and file2 using keys of file2
#       : multiple columns can be used as key for joining

use strict;
use Getopt::Long;

my %f2;
my ($i, $j) = (1, 1);
GetOptions("i=s" => \$i, "j=s" => \$j,);

my @i = map { $_ -1} split ",", $i;
my @j = map { $_ -1} split ",", $j;

open(IN,"<$ARGV[1]");

while(<IN>) {
	chomp;
	my @F = split "\t";
	my @e = exc_indx($#F, \@j);
	my $kj = join("\t", @F[@j]);
	my $vj = join("\t", @F[@e]);
	$f2{$kj} = $vj;
}
close IN;

open(IN,"<$ARGV[0]");

while(<IN>) {
	chomp;
	my @F = split "\t";
	my $ki = join("\t", @F[@i]);
	
	if (exists $f2{$ki}) {
		print $_ . "\t" . $f2{$ki} . "\n";
	} else {
		print $_ . "\t---\n";
	}
}
close IN;

sub exc_indx {
	my $size = shift;
	my $indx = shift;
	my %indx = map { $_ => 1 } @$indx;
	return grep { !exists $indx{$_} } (0..$size);
}
