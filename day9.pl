#!/usr/bin/env perl

use strict;
use warnings;

use List::Util qw(sum all);
use DDP;

my @input;

while (<STDIN>) {
    push @input, [/([-]?\d+)/gx];
}

sub find_tally {
    my @nums  = @_;
    my $tally = 0;
    for (@nums) {
        p $_;
        my @buf     = $_->@*;
        my @subbufs = ( [@buf] );
        my @subvals;

        until ( all { $_ == 0 } @buf ) {

            #p @buf;
            for ( my $i = 0 ; $i < $#buf ; $i++ ) {
                my $diff = $buf[ $i + 1 ] - $buf[$i];
                push @subvals, $diff;
            }

            push @subbufs, [@subvals];
            @buf     = @subvals;
            @subvals = ();
        }

        $tally += sum( map { my @a = @$_; $a[$#a] } @subbufs );
    }

    return $tally;
}

my $silver = find_tally(@input);

print "PART 1: $silver\n";

my $gold = find_tally( map { [ reverse @$_ ] } @input );

print "PART 2: $gold\n";
