use Scalar::Util qw(looks_like_number);
use List::Util   qw(sum);
use feature      qw(say);

my @lines;
while (<STDIN>) {
	chomp;
    push @lines, [ split //, $_ ];
}

my $sum;
my $gear_ratio;
for ( my $i = 0; $i <= $#lines; ++$i ) {
    my @arr = @{ $lines[$i] };
    for ( my $j = 0; $j <= $#arr; $j++ ) {
        my $char = $arr[$j];

        next if looks_like_number($char) || $char eq '.';

        my $is_gear = $char eq '*';
        my @values;

        if ( $j < $#arr && looks_like_number( $arr[ $j + 1 ] ) ) {
            my $n         = $j + 1;
            my $right_num = $arr[ $n++ ];
            while ( $n <= $#arr && looks_like_number($arr[$n]) ) {
                $right_num .= $arr[ $n++ ];
            }

            push @values, $right_num if looks_like_number($right_num);
        }

        if ( $j > 0 && looks_like_number( $arr[ $j - 1 ] ) ) {
            my $n        = $j - 1;
            my $left_num = $arr[ $n-- ];
            while ( $n >= 0 && looks_like_number($arr[$n]) ) {
                $left_num = $arr[ $n-- ] . $left_num;
            }

            push @values, $left_num if looks_like_number($left_num);
        }

        my $handle = sub {
            my @a = shift->@*;
            my @nums;
            my $num;
            my %traversed;
            foreach my $k ( ( $j, $j - 1, $j + 1 ) ) {
            	next if $traversed{$k};

                if ( looks_like_number($a[$k]) ) {
                    $num = $a[$k];
                    my ( $l, $p ) = ( $k - 1, $k + 1 );
                    while ( looks_like_number( $a[$l] ) ) {
                    	$traversed{$l} = 1;
                    	$num = $a[ $l-- ] . $num;
                    }
                    
                    while ( looks_like_number( $a[$p] ) ) {
                    	$traversed{$p} = 1;
                    	$num .= $a[ $p++ ];
                    }
                }


                if (looks_like_number($num)) {
                	push @nums, $num;
                	$num = undef;
                }

                break;
            }

            return @nums;
        };

        if ( $i >= 0 && $i != $#lines ) {
            my @bottom = @{ $lines[ $i + 1 ] };
            my @v      = $handle->( \@bottom );
            push @values, @v;
        }

        if ( $i <= $#lines && $i != 0 ) {
            my @top = @{ $lines[ $i - 1 ] };
            my @v   = $handle->( \@top );
            push @values, @v;
        }

        if ($is_gear && $#values == 1) {
        	$gear_ratio += $values[0] * $values[1];
        }

        $sum += sum(@values);
    }
}

print "PART 1: $sum\n";
print "PART 2: $gear_ratio\n";