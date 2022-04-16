#!/usr/bin/perl -w
# usage : desimplify.pl -l [60] file.fa

use strict;
use Getopt::Long;

my $len = 60;
GetOptions("length|l=s" => \$len);

while(<>){
	if(/^>/) {
		print;
	} else {
		my @seq = unpack("(A$len)*");
		print join("\n", @seq) . "\n";
	}
}
