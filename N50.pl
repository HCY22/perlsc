#!/usr/bin/perl -w
# usage : N50.pl contigs.fa
# to do : summary for contigs

use strict;

my ($len, $total, $contig, $mean, @x);

open (IN,"<$ARGV[0]");
<IN>; $contig++; # 1st

while(<IN>){
	chomp;
	if (/^>/){
		$contig++;
		$total += $len;
		push (@x, $len);
		$len = 0;
		next;
	}
	$len += length;
}
close IN;

# last contig
$total += $len;
push (@x, $len);

$mean = int($total / $contig);
@x = sort { $b <=> $a } @x;

# calculate N50, N90
my ($count, $n50, $n90);

foreach (@x) {
	$count += $_;
	if(($count >= $total / 2) && !$n50) {
		$n50 = $_;
	}
	elsif($count >= $total * 0.9) {
		$n90 = $_;
		last;
	}
}

# output
print<<EOF;
Contig :$contig
Max    :$x[0] \tbp
Min    :$x[-1]\tbp
Mean   :$mean \tbp
Total  :$total\tbp
N50    :$n50
N90    :$n90
EOF
