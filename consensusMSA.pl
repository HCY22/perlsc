#!/usr/bin/perl
# usage : consensusMSA.pl -exact MSA.afa
# to do : get consensus from muscle output (FASTA format)

use strict;
use Getopt::Long;

my $exact = 0;
GetOptions("exact|e!" => \$exact);

# A: A  R: AG  B: TCG  N: ATCG
# T: T  Y: TC  D: ATG
# C: C  K: TG  H: ATC
# G: G  M: AC  V: ACG
#       S: CG
#       W: AT

my %nucencode = (A => "A",   T => "T",   C => "C",   G => "G",
	AG => "R",  TC => "Y",  TG => "K",  AC => "M",  CG => "S", AT => "W",
	TCG => "B", ATG => "D", ATC => "H", ACG => "V", ATCG => "N");

my $MSA = [];
my $seq;

while(<>) {
	if (/^>/) {
		my @S = split //, $seq;
		$MSA->[$_]->{ $S[$_] }++, foreach 0..$#S;
		$seq = "";
	} else {
		chomp;
		$seq .= $_;
	}
}
my @S = split //, $seq;
$MSA->[$_]->{ $S[$_] }++, foreach 0..$#S;

# get consensus (exact)
if ($exact != 0) {
	foreach my $base (@$MSA) {
		my $cs;
		my $maxv = (sort { $b <=> $a } $base->{A}, $base->{T}, $base->{C}, $base->{G})[0];
		foreach (qw/A T C G/) {
			$cs .= $_ if $base->{$_} == $maxv;
		}
		print $nucencode{$cs};
	}

# get consensus (random)
} else {
	foreach my $base (@$MSA) {
		foreach (sort { $base->{$b} <=> $base->{$a} } keys %$base) {
			next unless /[ATGC]/;
			print; last;
		}
	}
}
print "\n";
