#!/usr/bin/perl -w
# usage : revcom.pl file.fa

use strict;

print $_ = <>;
my $seq;

while(<>) {
	if (/^>/) {
		$seq = revcom($seq);
		$seq = desimplify($seq);
		print $seq;
		print; 
		next;
	}
	chomp;
	$seq .= $_;
}

$seq = revcom($seq);
$seq = desimplify($seq);
print $seq;


sub revcom {
	my $revcom = reverse shift;
	$revcom =~ tr/ACGTacgt/TGCAtgca/;
	return $revcom;
}

sub desimplify {
	my @seq = unpack("(A60)*", shift);
	return join("\n", @seq) . "\n";
}
