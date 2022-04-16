#!/usr/bin/perl
# usage : myfastqc.pl -i data -o fastqc
# to do : run fastqc and combine all plot in one html
# tools : need to preinstall fastqc and convert

use strict;
use Cwd qw/cwd abs_path/;
use Getopt::Long;
use HTML::Table;

my $cwd = cwd();
my $input_dir;
my $output_dir = "fastqc";
my $files_pattern = "*.fastq *.fastq.gz *.fq *.fq.gz";

my $thread = 8;
my $help;
my $skip;

GetOptions( "input|i=s"  => \$input_dir,
			"output|o=s" => \$output_dir,
			"thread|s=i" => \$thread,
			"skip|s!"    => \$skip,
			"help|h!"    => \$help,);

usage() if $help;
usage() unless $input_dir;

sub usage {
	print <<EOF;
usage: fastqc2-0.pl [option]
e.g. : fastqc2-0.pl -i data -o fastqc -t 8

-i, --input   INPUT DIR. The directory that holds the input fastq files.
              Automatically detect [fastq, fastq.gz, fq, fq.gz] files.
-o, --output  OUTPUT DIR. The directory to output the qc data and reports. Defult [fastqc/].
-t, --thread  Set the number of worker threads. Defult [8].
-s, --skip    Do not run fastqc on the sequence data, only generate reports from a previous run.
-h, --help    Print this message.

EOF
	exit;
}

# creat output dir
`mkdir -p $output_dir` unless $skip;
$output_dir = abs_path($output_dir);

# get names of fastq files
chdir $input_dir;
chomp (my @files = `ls -v $files_pattern 2> /dev/null`);

# run fastqc on all sequence files in dir
`fastqc @files -o $output_dir -t $thread -extract` unless $skip;
chdir $cwd;

# combine all fastqc plot
chdir $output_dir;

# html table header
my @header = qw/ sample base_quality tile_quality seq_quality base_content GC_content N_content length_distribution seq_duplication adapter /;
my $table = HTML::Table->new(-col => 10, -border=> 1, -padding=> 10, -head => \@header);

# each sample of html file
my @html_files = map{ my ($p) = $_ =~ /(\S+)(?<ext>\.fastq$|\.fastq\.gz$|\.fq$|\.fq\.gz$)/; $p .= "_fastqc.html" } @files;

# each sample of qc plot
my @img_path = map{ my ($p) = $_ =~ /(\S+)(?<ext>\.fastq$|\.fastq\.gz$|\.fq$|\.fq\.gz$)/; $p .= "_fastqc/Images/" } @files;
my @img_src;
my @img_files = qw/ per_base_quality.png              per_tile_quality.png         per_sequence_quality.png
				    per_base_sequence_content.png     per_sequence_gc_content.png  per_base_n_content.png
				    sequence_length_distribution.png  duplication_levels.png       adapter_content.png /;

foreach my $p (@img_path) {
	push @img_src, [map{ $p . $_ } @img_files];
}

foreach my $i( 0..$#files) {

	# add sample name
	$table->addRow($files[$i]);

	# add sample hypertext reference
	$table->setCellFormat($i+2, 1, "<a href=\"$html_files[$i]\">", "</a>");

	# add image
	foreach my $j(2..10) {
		# using convert to get img_src base64 encoding
		my $img_base64 = `convert $img_src[$i]->[$j-2] -resize 200 INLINE:PNG:-`;
		$table->setCellFormat($i+2, $j, "<img src=\"$img_base64\" alt=\"NA\" width=\"200\">");
	}
}

# output html file
open HTML, ">fastqc_plots.html";
print HTML $table;
close HTML;
