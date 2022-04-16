#!/usr/bin/perl -w
# usage : relabelID.pl file.fa/fq [label]
# to do : relabel fastaID | fastqID

use strict;
use 5.010;

my $basename = `basename $ARGV[0]`;
my ($bn) = $basename =~ /(.+)(?:\.)(?<extention>fa|fq|fasta|fastq)$/;

$bn = $ARGV[1] if defined $ARGV[1];

open(IN, "<$ARGV[0]");

if ($+{extention} =~ /a$/) {
	 labfa(\*IN, $bn);
}
elsif ($+{extention} =~ /q$/) {
	labfq(\*IN, $bn);
}

close IN;


sub labfa{
	my $fh = shift;
	my $lable = shift;
	while(<$fh>) {
		if (/^>/) {
			 state $i++;
			 print "\>$lable.$i\n"; # newID
			 next;
		}
		print;                      # seq
	}
}

sub labfq{
	my $fh = shift;
	my $lable = shift;
	while(<$fh>) {
		state $i++;
		print "\@$lable.$i\n";   # newID
		print $_ = <IN>;         # seq
		print $_ = <IN>;         # +
		print $_ = <IN>;         # qua
	}
}
