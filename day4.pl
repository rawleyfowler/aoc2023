#!/usr/bin/env perl
## no critic
use strict;
use warnings;
use List::Util qw(sum);
use DDP;

my $i = 0;
my %a;
my @k;
my $K;
while (<STDIN>) {
    my @a = split( /\|/, ( split( /:/, $_, 2 ) )[1], 2 );
    my @t = $a[0] =~ /(\d+)/gx;
    my @f = $a[1] =~ /(\d+)/gx;
    my $j = 0;
    foreach my $a (@t) {
    	foreach my $b (@f) {
    		$j++ if $a == $b;
    	}
    }

    if ($j < 1) {
    	$a{$i} = 0;
    } else {
    	$a{$i} = $j;
    	my $l = 2**( $j - 1 );
    	$K += $l;
    }

    $i++;
}

$i--;

unshift @k, 0..$i;

my %h;
my $t;
while (defined(my $j = shift @k)) {
	next if $j > $i;
	if (my $l = $a{$j}) {
		for (1 .. $l) {
			my $o = $j + $_;
			push @k, $o;
		}
	}
	$t++;
}

print "PART 1: $K\n";
print "PART 2: $t\n";