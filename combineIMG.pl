#!/usr/bin/perl
# usage : combineIMG.pl -s [3x3] -l [A,B,C,D] pic{1..N} > out.png
# to do : combine images by custom number of rows and columns

use strict;
use Getopt::Long;
use Image::Magick;

my $label;
my $shape = "x2";
my $fsize = 20;
my $color = "black";
my $geome = "300x300>+2+2";

GetOptions(
	"shape|s=s" => \$shape,
	"label|l=s" => \$label,
	"fsize|f=s" => \$fsize,
	"color|c=s" => \$color,
);

# creat the image object Image::Magick=ARRAY
my $image = Image::Magick->new;

# load each image into object
$image->Read(@ARGV);

# label each image
my @label = split ",", $label;
@label = ($label[0]) x scalar @ARGV if scalar @label == 1;

$image->[$_]->Annotate(
	text      => $label[$_],
	fill      => $color,
	pointsize => $fsize,
	gravity   => "NorthWest",
	x         => +10,
	y         => +10,
) foreach 0..$#label;

# combining images using montage
my $combine = $image->Montage(tile => $shape, geometry => $geome);

# stdout images
binmode STDOUT;
$combine->Write('png:-');
