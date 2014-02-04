#!perl

use strict;
use warnings;

use Test::More tests => 1;

BEGIN {
    use_ok('Time::Monotonic');
}

diag("Time::Monotonic $Time::Monotonic::VERSION, Perl $], $^X");

