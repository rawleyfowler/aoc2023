#!/usr/bin/env perl
## no critic
use DDP;
my $sum1;
my $sum2;
my %lookup = (
    one   => 1,
    two   => 2,
    three => 3,
    four  => 4,
    five  => 5,
    six   => 6,
    seven => 7,
    eight => 8,
    nine  => 9
);
while (<STDIN>) {
    @_ = /[0-9]/gmx;
    my $t = shift @_;
    my $v = pop @_ // $t;
    $sum1 += "$t$v";

    my @n = /(?=([0-9]|one|two|three|four|five|six|seven|eight|nine))/gx;
    my $j = shift @n;
    if ( int $j == 0 ) {
        $j = $lookup{$j};
    }

    my $i = pop @n // $j;
    if ( int $i == 0 ) {
        $i = $lookup{$i};
    }

    $sum2 += "$j$i";
}

print "PART 1: ", $sum1, "\n";
print "PART 2: ", $sum2, "\n";
