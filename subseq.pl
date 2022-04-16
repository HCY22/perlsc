#!/usr/bin/perl -w
# usage : subseq.pl -i [>id] -r [n1..n2] -c file.fa
# to do : get subsequence from fasta

use strict;
use Getopt::Long;

my $len = 1; # default -> one nucl
my $com = 0; # default -> not complementary
my($id, $seq, $range, $str, $sub);

GetOptions( "id|i=s" => \$id, "range|r=s" => \$range, "com|c!" => \$com);

$range =~ /(\d+)[\-\.\,\~]*(\d+)?/;
$str = $1-1;
$len = $2-$1+1 if defined $2;

open(IN,"<$ARGV[0]") || die "$!\n";
chomp($id = <IN>), seek(IN,0,0) unless $id;

while(<IN>){
	chomp;
	next if $_ ne $id;
	$/ = ">";
	$seq = <IN>;
	$seq =~ s/\s//g;
	$sub = substr($seq, $str, $len);
	$sub = revcom($sub) if $com;
	print "$sub\n";
	last;
}
close IN;

# get reverse complement of DNA sequence
sub revcom {
	my $revcom = reverse($_[0]);
	$revcom =~ tr/ACGTacgt/TGCAtgca/;
	return $revcom;
}
