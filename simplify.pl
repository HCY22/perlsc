#!/usr/bin/perl -w
# usage : simplify.pl file.fa

use strict;

print $_ = <>;

while(<>) {
	if (/^>/) {
		print "\n" . $_;
	} else {
		chomp; print;
	}
}
