#!/usr/bin/perl -w
# usage : ExtractFastx.pl fa/fq id_list
# to do : extract fa/fq sequence

use strict;
my %target;

open IN, $ARGV[1];

while(<IN>) {
	chomp;
	/^(\S+)/;
	$target{$1}++;
}
close IN;

if ($ARGV[0] =~ /(fastq|fq)$/) {
	extractfq(); exit;
} else {
	extractfa(); exit;
}

sub extractfq {
	open FQ, $ARGV[0];
	while(<FQ>) {
		/^@(\S+)/;
		if (exists $target{$1}) {
			print "\@$1\n";
			print $_ = <FQ>;
			print $_ = <FQ>;
			print $_ = <FQ>;
			next;
		}
		<FQ>; <FQ>; <FQ>;
	}
	close FQ;
}
sub extractfa {
	open FA, $ARGV[0];
	local $/ = "\n>";
	seek(FA, 1, 1);

	while(<FA>) {
		s/>$//;
		my ($id) = split "\n";
		print ">$_" if exists $target{$id};
	}
	close FA;
}
