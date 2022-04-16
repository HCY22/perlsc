#!/usr/bin/perl -w
# usage : fastalength.pl file.fa
# to do : calcualte sequence length

use strict;

my $len;
print $_ = <>;

while(<>){
	if (/^>/) {
		print $len . "\n";
		$len = 0;
		print; next;
	}
	chomp;
	$len += length;
}
print $len . "\n";
