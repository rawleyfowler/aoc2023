#!/usr/bin/env perl
use List::Util qw(max);

my $sum;
my $power;
while (<STDIN>) {
    chomp;
    my @id  = /Game\s(\d+):.*/gx;
    my @red = /(\d+)\sred/gmx;
    my @grn = /(\d+)\sgreen/gmx;
    my @blu = /(\d+)\sblue/gmx;

    my $mred = max(@red);
    my $mgrn = max(@grn);
    my $mblu = max(@blu);

    $power += ( $mred * $mgrn * $mblu );

    next unless ( $mred <= 12
        && $mgrn <= 13
        && $mblu <= 14 );

    $sum += pop @id;
}
print "PART 1: $sum\n";
print "PART 2: $power\n";
