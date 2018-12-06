#!/usr/bin/perl
use diagnostics;
use strict;
use warnings;


my $alphabet = "azertyuiopqsdfghjklmwxcvbn";
my @matchers = qw();


sub remove_unit {
    my ($input_str, $unit) = @_;

    my $lc_unit = (lc $unit);
    my $uc_unit = (uc $unit);
    $unit = $lc_unit . $uc_unit;
    $input_str =~ s/[$unit]//g;
    
    return $input_str;
}

sub react_polymer {
    my ($input_str) = @_;

    my $str = $input_str;
    my $temp_str;
    do {
        $temp_str = $str;
        for my $match (@matchers) {
            $str =~ s/($match)//g;
        }
    } while (length($str) != length($temp_str));

    return $str;
}

sub shortest_reacted_polymer {
    my ($input_polymer) = @_;
    my $shortest_reacted_polymer = $input_polymer;

    for my $char (split //, $alphabet) {
        my $reacted_polymer = react_polymer(remove_unit($input_polymer, $char));
        if (length($reacted_polymer) < length($shortest_reacted_polymer)) {
            $shortest_reacted_polymer = $reacted_polymer;
        }
    } 

    return $shortest_reacted_polymer;
}


# INIT SCRIPTS GO HERE !

for my $char (split //, $alphabet) {
    push(@matchers, (lc $char) . (uc $char));
    push(@matchers, (uc $char) . (lc $char));
}

my $file_content = do{local(@ARGV,$/)='input.txt';<>};
print "shortest_reacted_polymer length: " . length(shortest_reacted_polymer($file_content)) . "\n";