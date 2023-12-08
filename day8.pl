#!/usr/bin/env perl

use strict;
use warnings;

use DDP;

sub node {
    my ( $left, $right ) = @_;
    return +{ left => $left, right => $right };
}

my @lines = <STDIN>;

chomp( my $directions = shift @lines );
my @directions = split '', $directions;
shift @lines;    # get rid of new line

my %map;
for (@lines) {
    my @vals = /([\dA-Z]+)/gx;
    my $key  = shift @vals;
    $map{$key} = node(@vals);
}

my @queue = ('AAA');

my $i      = 0;
my $ticker = 0;
while ( my $key = pop @queue ) {
    last if $key eq 'ZZZ';
    my $node = $map{$key};
    if ( $directions[$ticker] eq 'L' ) {
        push @queue, $node->{left};
    }
    elsif ( $directions[$ticker] eq 'R' ) {
        push @queue, $node->{right};
    }

    $ticker++;
    $ticker = 0 if ( $ticker > $#directions );
    $i++;
}

print "PART 1: $i\n";

@queue = grep { $_ =~ /[\dA-Z][\dA-Z]A/x } keys(%map);

my $t = scalar(@queue);

use Inline 'CPP';

my $j = 0;
my @distances;
foreach my $key (@queue) {
    my @q = ($key);
    $i      = 0;
    $ticker = 0;
    while ( my $k = pop @q ) {
        if ( $k =~ /[\dA-Z][\dA-Z]Z/x ) {
            @distances[$j] = $i;
            last;
        }
        my $node = $map{$k};
        if ( $directions[$ticker] eq 'L' ) {
            push @q, $node->{left};
        }
        elsif ( $directions[$ticker] eq 'R' ) {
            push @q, $node->{right};
        }
        $i++;
        $ticker++;
        $ticker = 0 if $ticker > $#directions;
    }
    $j++;
}

get_lcm( \@distances );

__END__
__CPP__

  #include <algorithm>
  #include <numeric>
  #include <vector>
  #include <iostream>

  void get_lcm(SV *array_ref) {
    AV *array;
    std::vector<uint64_t> vec;

    if (!SvROK( array_ref )) croak("Param is not a reference.");
    if (SvTYPE(SvRV(array_ref)) != SVt_PVAV) croak("Param is not an array reference.");

    array = (AV *)SvRV(array_ref);

    int n = av_top_index(array);
    for (; n >= 0; n--) {
      std::size_t t = SvIV(*av_fetch(array, n, 0));
      vec.push_back(t);
    }

    int64_t num = std::accumulate(vec.begin(), vec.end(), vec.front(), [](auto& a, auto& b) {
      return std::lcm<uint64_t>(a, b);
    });

    std::cout << "PART 2: " << num << std::endl;
  }
