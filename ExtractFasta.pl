#!/usr/bin/perl
# usage : ExtractFasta.pl fasta id
# to do :

use strict;

my @id = @ARGV[1..$#ARGV];

# load desired ID
my %idq=();

foreach my $id (@id) {
	$idq{$id} = 1;
}

open IN, $ARGV[0];
my $r;

while (<IN>) {
	if (/^>(\S+)/) {
		$r = $1;
	}
	print $_ if $idq{$r};
}
close IN;
