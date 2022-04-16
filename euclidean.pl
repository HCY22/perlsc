#!/usr/bin/perl
# usage : euclidean.pl table
# to do : calculate the Euclidean distance of between each sample
#
# table format :
#
# D\S S1 S2 S3 ...
# Dim1
# Dim2
# Dim3
#   :

use strict;

my %mx;
my $hd = <>; chomp $hd;
$hd =~ s/^\S+/#Eucli/;

while(<>) {
	my @F = split "\t";

	for my $i (1..$#F) {
		for my $j ($i..$#F) {
			next if $i == $j;
			$mx{"$i:$j"} += ($F[$i]-$F[$j])**2;
		}
	}
}

# distance matrix (full)
print "$hd\n";
my @sp = split("\t", $hd);
for my $i (1..$#sp) {
	print "$sp[$i]\t";
	for my $j (1..$#sp) {
		if ($i <= $j) {
			printf "%.2f\t", sqrt($mx{"$i:$j"});
		} else {
			printf "%.2f\t", sqrt($mx{"$j:$i"});
		}
	}
	seek(STDOUT,-1,1); print "\n";
}

__END__
# distance matrix (half)
print "$hd\n";
my @sp = split("\t", $hd);
for my $j (1..$#sp) {
	print "$sp[$j]\t";
	for my $i (1..$j) {
		printf "%.2f\t", sqrt($mx{"$i:$j"});
	}
	seek(STDOUT,-1,1); print "\n";
}
