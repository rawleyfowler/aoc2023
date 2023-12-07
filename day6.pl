#!/usr/bin/env perl

use strict;
use warnings;

use List::Util qw(reduce);
use DDP;

my @times   = ( <STDIN> =~ /(\d+)/gx );
my @records = ( <STDIN> =~ /(\d+)/gx );

my $total = 0;
my @results;
for ( my $i = 0 ; $i <= $#times ; $i++ ) {
    my $time   = $times[$i];
    my $record = $records[$i];

    for ( my $j = 1 ; $j < $time ; $j++ ) {
        next unless $j * ( $time - $j ) > $record;
        $results[$i]++;
    }
}

my $big_time   = join "", @times;
my $big_record = join "", @records;

my $p2_sum;
for ( my $j = 1 ; $j < $big_time ; $j++ ) {
    next unless $j * ( $big_time - $j ) > $big_record;
    $p2_sum++;
}

my $sum = pop @results;
$sum *= $_ for @results;

print "PART 1: ", $sum,    "\n";
print "PART 2: ", $p2_sum, "\n";
