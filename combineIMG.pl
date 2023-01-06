#!/usr/bin/perl
# usage : combineIMG.pl -s [3x3] -l [A,B,C,D] pic{1..N} > out.png
# to do : combine images by custom number of rows and columns
# sudo apt-get install perlmagick

use strict;
use List::Util qw/min/;
use Getopt::Long;
use Image::Magick;
sub reshape(\@$$);

my $shape;
my $label;
my $fsize = 18;
my $color = "black";

GetOptions(
	"shape|s=s" => \$shape,
	"label|l=s" => \$label,
	"fsize|f=s" => \$fsize,
	"color|c=s" => \$color,
);

# get row and column
my ($r, $c) = $shape =~ /(\d+)[x\*](\d+)/;

# creat the image object Image::Magick=ARRAY
my $image = Image::Magick->new;

# load each image into object
$image->Read(@ARGV);

# autosize
my @H;
$H[$_] = $image->[$_]->Get("rows") foreach 0..$#ARGV;
my $Hmin = min @H;
$image->[$_]->Resize( Geometry => "x$Hmin" ) foreach 0..$#ARGV;

# label each image
my @label = split ",", $label;
$image->[$_]->Annotate(
	text      => $label[$_],
	fill      => $color,
	pointsize => $fsize,
	gravity   => "NorthWest",
	x         => +0,
	y         => +0,
) foreach 0..$#label;

# reshape Image::Magick=ARRAY to 2D ARRAY
# bless each ARRAY to Image::Magick
@$image = reshape @$image, $r, $c;
bless $image->[$_], "Image::Magick" foreach 0..$#$image;

# stack from left to right and push into ARRAY(1D)
# bless to Image::Magick
my $append_row = [];
push @$append_row, @{ $image->[$_]->Append(stack => "false") } foreach 0..$#$image;
bless $append_row, "Image::Magick";

# stack from top to bottom
my $append_col = $append_row->Append(stack => "true");

# stdout images
binmode STDOUT;
$append_col->Write('png:-');

#### reshape 1D ARRAY to 2D ARRAY
sub reshape(\@$$) {
	my @arr = @{+shift};
	my ($r, $c) = (shift, shift);
	my @res;

	# fill by column
	push @res, [splice @arr, 0, $c] while @arr;

	return @res;
}
