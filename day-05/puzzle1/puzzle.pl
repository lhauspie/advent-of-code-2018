#!/usr/bin/perl
use diagnostics;
use strict;
use warnings;


my $alphabet = "azertyuiopqsdfghjklmwxcvbn";
my @matchers = qw();

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



# INIT SCRIPTS GO HERE !

for my $char (split //, $alphabet) {
    push(@matchers, (lc $char) . (uc $char));
    push(@matchers, (uc $char) . (lc $char));
}

my $file_content = do{local(@ARGV,$/)='input.txt';<>};
print "react_polymer length: " . length(react_polymer($file_content)) . "\n";