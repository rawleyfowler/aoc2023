#!/usr/bin/env perl

use strict;
use warnings;

use List::Util qw(min max first);
use DDP;
use feature qw(state say);

my @filters;
my $input = join( "", <STDIN> );
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
            my $ddelta = $d + $k;

            #say "$d $s $k -- $val";

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
    return +{ hi => shift, lo => shift };
}

my @p2_filters;
for (@maps) {
    my @split = ( split /\n/, $_ );
    my @nums  = map { [/(\d+)/gx] } @split[ 1 .. $#split ];

    my $filter = sub {
        my $highlows = shift;

        my @ret;
        for (@nums) {
            my ( $d, $s, $k ) = @$_;

            my $delta  = $d - $s - 1;
            my $sdelta = $s + ( $k - 1 );

            while ( my $o = pop $highlows->@* ) {
                my $high = $o->{hi};
                my $low  = $o->{lo};

                if ( max( $s, $low ) - min( $sdelta, $high ) > 0 ) {
                    push @ret, range( $high, $low );
                }
                elsif ( $low >= $s && $high <= $sdelta ) {
                    push @ret, range( $high + $delta, $low + $delta );
                }
                elsif ( $low < $s && $high > $sdelta ) {
                    push @ret,          range( $s + $delta, $sdelta + $delta );
                    push $highlows->@*, range( $low,        $s );
                    push $highlows->@*, range( $sdelta,     $high );
                }
                elsif ( $low < $s && $high < $sdelta ) {
                    push @ret,          range( $s + $delta, $high + $delta );
                    push $highlows->@*, range( $low,        $s );
                }
                elsif ( $low > $s && $high > $sdelta ) {
                    push @ret, range( $low + $delta, $sdelta + $delta );
                    push $highlows->@*, range( $sdelta, $high );
                }
            }
        }

        return \@ret;
    };

    push @p2_filters, $filter;
}

my %seed_ranges_map = @seeds;
my @m = map { +{ lo => $_, hi => $_ + ( $seed_ranges_map{$_} - 1 ) } }
  keys(%seed_ranges_map);

my $m = \@m;
for (@p2_filters) {
    $m = $_->($m);
}

# p $m;

print "PART 2: ", min( map { $_->{lo}, $_->{hi} } $m->@* ), "\n";
