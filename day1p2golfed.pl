#!/usr/bin/env perl
%t=(one=>1,two=>2,three=>3,four=>4,five=>5,six=>6,seven=>7,eight=>8,nine=>9,ten=>10);$z=join'|',keys(%t);while(<STDIN>){@_=map{int$_?$_:$t{$_}}/(?=([0-9]|$z))/g;$K+=$_[0].$_[-1]};print$K
