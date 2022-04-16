#!/usr/bin/perl -w
# usage : accn2data.pl [accn:(c)n1-n2] > ouput.fa
# to do : use accession number get fasta from ncbi

use strict;
use LWP::Simple;

$ARGV[0] =~ />?(\w\w_\d+\.?\d?\d?):?(\S+)?/;
my $pos = '';
my $acc = $1;

if (defined $2){
	$2 =~ /(c)?(\d+)-(\d+)/;
	if (defined $1){
		$pos = "&from=$3&to=$2&strand=on"; # complementary
	} else {
		$pos = "&from=$2&to=$3";
	}
}

# convert accession number to gi number
my $url = "https://www.ncbi.nlm.nih.gov/nuccore/$acc?report=gilist&log\$=seqview&format=text";
my($gi) = get($url) =~ /<pre>(\d+)\s?<\/pre>/;

# get fasta using gi number
my $base  = 'https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?tool=portal&save=file&log$=seqview&db=nuccore&report=fasta';
my $url2 = $base . "&id=$gi$pos&extrafeat=null&conwithfeat=on&hide-cdd=on";
chomp (my $fasta = get($url2));
print $fasta;
