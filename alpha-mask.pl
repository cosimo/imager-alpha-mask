#!/usr/bin/env perl

use strict;
use warnings;

use Imager;

our $CHANNELS = 4;  # RGBA

sub process_colors {
	my @rgba = @_;

	# Set the alpha component as any of r,g,b
	# and reset rgb to 0

	@rgba = ("\0", "\0", "\0", $rgba[0]);

	return @rgba;
}

my $pic = Imager->new();
my $mask = $ARGV[0];

$pic->read(file=>$mask) or
	die "Can't read mask file '$mask': " . $pic->errstr . "\n";

my $width = $pic->getwidth();
my $height = $pic->getheight();

for (my $y = $height - 1; $y >= 0; $y--) {

	my $scanline = $pic->getscanline(y=>$y);
	my $processed = '';

	for my $pos (0 .. length($scanline)/$CHANNELS - 1) {
		my @rgba = split //, substr($scanline, $pos * $CHANNELS, $CHANNELS);
		@rgba = process_colors(@rgba);
		$processed .= join('', @rgba);
  	}

	$pic->setscanline($processed, y => $y);

}

$pic->write(file => "$mask.alpha.png") or
	die "Can't write output mask file: " . $pic->errstr . "\n";

