#!/usr/bin/env perl
while(<STDIN>){@_=/([0-9])/g;$K+=$_[0].($_[-1])};print $K
