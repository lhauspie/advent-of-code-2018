#!/usr/bin/perl
use diagnostics;
use warnings;
use strict;
use Test::More qw( no_plan );

do './puzzle.pl';

# tests go here
is(react_polymer('absdefxXpoiyt'), 'absdefpoiyt', 'xX should react so it should be removed from the string');
is(react_polymer('absdefxxpoiyt'), 'absdefxxpoiyt', 'xx Is not reacting exactly the same as xX or Xx');
is(react_polymer('absdefxXpXxoiyt'), 'absdefpoiyt', 'xX & Xx should react so it should be removed from the string');
is(react_polymer('absdefxxXypoiyt'), 'absdefxypoiyt', 'xX should react but not xx so xX should be removed from the string but not the first x');
is(react_polymer('dabAcCaCBAcCcaDA'), 'dabCBAcaDA', 'dabAcCaCBAcCcaDA should result dabCBAcaDA');
