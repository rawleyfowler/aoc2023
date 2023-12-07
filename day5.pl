#!/usr/bin/env perl

use strict;
use warnings;

use List::Util qw(min max first);
use DDP;
use feature qw(state say);

my @filters;
chomp( my $input = join( "", <STDIN> ) );
my @maps  = split( /\n\n/x, $input );
my @seeds = ( shift(@maps) =~ /(\d+)/gmx );

for (@maps) {
    my @split = ( split /\n/, $_ );
    my @nums  = map { [/(\d+)/gx] } @split[ 1 .. $#split ];

    my %cache;

    my $filter = sub {
        my $val = shift;
        my $t   = $val;

        return $cache{$val} if exists $cache{$val};

        my @k;
        for (@nums) {
            my ( $d, $s, $k ) = @$_;

            my $sdelta = $s + ( $k - 1 );

            if ( $val <= $sdelta && $val >= $s ) {
                $val = $d + ( abs( $val - $s ) );
                last;
            }
        }

        return $val;
    };

    push @filters, $filter;
}

sub do_mapping {
    my $seed = shift;
    my $val  = $seed;

    for (@filters) {
        $val = $_->($val);
    }

    return $val;
}

my @r = map { do_mapping($_) } @seeds;

print "PART 1: ", min(@r), "\n\n\n\n\n";

sub range {
    my ( $low, $high ) = @_;
    return +{ lo => $low, hi => $high };
}

my %seed_ranges_map = @seeds;
my @highlows        = map { range( $_, $_ + $seed_ranges_map{$_} - 1 ) }
  keys(%seed_ranges_map);

for (@maps) {
    my @split = ( split /\n/, $_ );
    my @nums  = map { [/(\d+)/gx] } @split[ 1 .. $#split ];
    my @ret;
    my @next;
    for (@nums) {
        my ( $d, $s, $k ) = @$_;

        my $delta = sub {
            return shift() + ( $d - $s );
        };

        my $start = $s;
        my $end   = $s + $k - 1;
        for (@highlows) {

            my $high = $_->{hi};
            my $low  = $_->{lo};

            # No overlap
            #
            # XXX
            #     YYYYYYY
            if ( ( max( $low, $start ) - min( $high, $end ) ) > 0 ) {
                push @next, range( $low, $high );
            }

            # Inclusive overlap
            #
            #    XXXXXXX
            #   YYYYYYYYY
            elsif ($low >= $start
                && $low < $end
                && $high <= $end
                && $high > $start )
            {
                push @ret, range( $delta->($low), $delta->($high) );
            }

            # Double sided Overlap
            #
            #  XXXXXXXXXXX
            #    YYYYYYY
            elsif ( $low < $start && $high > $end ) {
                push @ret,  range( $delta->($start), $delta->($end) );
                push @next, range( $low,             $start - 1 );
                push @next, range( $end + 1,         $high );
            }

            # Left Overlap
            #
            #  XXXXXX
            #    YYYYYYY
            elsif ( $low < $start && $high <= $end && $high >= $start ) {
                push @ret,  range( $delta->($start), $delta->($high) );
                push @next, range( $low,             $start - 1 );
            }

            # Right Overlap
            #
            #      XXXXXXX
            #    YYYYYYY
            elsif ( $low >= $start && $high >= $end && $low < $end ) {
                push @ret,  range( $delta->($low), $delta->($end) );
                push @next, range( $end + 1,       $high );
            }
        }

        @highlows = @next;
        @next     = ();
    }

    push @highlows, @ret;
    @next = ();
    @ret  = ();
}

print "PART 2: ", min( map { $_->{lo}, $_->{hi} } @highlows ), "\n";
