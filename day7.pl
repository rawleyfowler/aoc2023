#!/usr/bin/env perl

use strict;
use warnings;

use List::MoreUtils qw(uniq);
use List::Util      qw(max);
use DDP;

my %card_values = (
    A   => 14,
    K   => 13,
    Q   => 12,
    J   => 11,
    T   => 10,
    '9' => 9,
    '8' => 8,
    '7' => 7,
    '6' => 6,
    '5' => 5,
    '4' => 4,
    '3' => 3,
    '2' => 2
);

sub calc_value {
    my %cards = shift->%*;

    my $hand_value;

    # High card
    if ( scalar( uniq( keys %cards ) ) == 5 ) {
        return 100;
    }

    my $m = max( values %cards );

    # Two pair
    if ( $m == 2 && scalar( grep { $_ == 2 } ( values %cards ) ) == 2 ) {
        return 200;
    }
    elsif ( $m == 2 ) {

        # one pair
        return 150;
    }

    # Three of a kind
    if ( $m == 3 ) {

        # Full house

        if ( scalar( values(%cards) ) == 2 ) {
            return 350;
        }
        return 300;
    }

    # Four of a kind
    if ( $m == 4 ) {
        return 400;
    }

    # 5 of a kind
    if ( $m == 5 ) {
        return 500;
    }

    p %cards;

    return 0;
}

my @rows = <STDIN>;
my @hands;

for (@rows) {
    my ( $hand, $bid ) = split /\s/, $_;

    my $hand_map = +{};
    my @hand     = split '', $hand;
    for (@hand) {
        $hand_map->{$_}++;
    }

    push @hands,
      +{
        hand     => $hand_map,
        hand_raw => [@hand],
        bid      => $bid,
        value    => calc_value($hand_map)
      };
}

my @sorted_hands = sort {
    if ( $a->{value} == $b->{value} ) {
        my @a_hand = @{ $a->{hand_raw} };
        my @b_hand = @{ $b->{hand_raw} };
        for ( my $i = 0 ; $i < scalar(@a_hand) ; $i++ ) {
            my $v = $card_values{ $a_hand[$i] };
            my $k = $card_values{ $b_hand[$i] };
            next if $k == $v;
            return $v <=> $k;
        }
    }

    return $a->{value} <=> $b->{value};
} @hands;

my $sum = 0;
my $i   = 1;
for (@sorted_hands) {
    $sum += $i++ * $_->{bid};
}

print "PART 1: $sum\n";

sub calc_value_2 {
    my %cards = shift->%*;

    my $n_jokers = $cards{J};
    my $m        = max( values %cards );

    return 0 unless $n_jokers;

    my $hand_value = 0;

    # Always at least 1 pair of there is a joker
    if ( $n_jokers == 1 && scalar( uniq( keys %cards ) ) == 5 ) {
        $hand_value = 150;
    }

    # If there are 2 jokers, we're always 3 of a kind
    if ( $n_jokers == 2
        || ( $n_jokers == 1 && $m == 2 ) )
    {
        $hand_value = 300;
    }

    if (   $n_jokers == 1
        && $m == 2
        && scalar( grep { $_ == 2 } values(%cards) ) == 2 )
    {
        $hand_value = 350;
    }

    # If there are 3 jokers we're at least 4 of a kind
    if (   $n_jokers == 3
        || ( $n_jokers == 1 && $m == 3 )
        || ( $n_jokers == 2 && scalar( grep { $_ == 2 } values(%cards) ) == 2 )
      )
    {
        $hand_value = 400;
    }

    # If there are 3 jokers we're at least 4 of a kind
    if (   $n_jokers == 4
        || ( $n_jokers == 1 && $m == 4 )
        || ( $n_jokers == 2 && $m == 3 )
        || ( $n_jokers == 3 && grep { $_ == 2 } values(%cards) ) )
    {
        $hand_value = 500;
    }

    return $hand_value;
}

@hands = ();

for (@rows) {
    my ( $hand, $bid ) = split /\s/, $_;

    my $hand_map = +{};
    my @hand     = split '', $hand;
    for (@hand) {
        $hand_map->{$_}++;
    }

    push @hands,
      +{
        hand     => $hand_map,
        hand_raw => [@hand],
        bid      => $bid,
        value    => max( calc_value($hand_map), calc_value_2($hand_map) )
      };
}

@sorted_hands = sort {
    if ( $a->{value} == $b->{value} ) {
        my @a_hand = @{ $a->{hand_raw} };
        my @b_hand = @{ $b->{hand_raw} };
        for ( my $i = 0 ; $i < scalar(@a_hand) ; $i++ ) {
            my $v = $a_hand[$i] eq 'J' ? 0 : $card_values{ $a_hand[$i] };
            my $k = $b_hand[$i] eq 'J' ? 0 : $card_values{ $b_hand[$i] };
            next if $k == $v;
            return $v <=> $k;
        }
    }

    return $a->{value} <=> $b->{value};
} @hands;

$sum = 0;
$i   = 1;
for (@sorted_hands) {
    $sum += $i++ * $_->{bid};
}

print "PART 2: $sum\n";
