#!perl

use strict;
use warnings;

use Test::More tests => 2;

BEGIN {
    use_ok('Time::Monotonic');
}

ok(Time::Monotonic::monotime() > 0, "monotime() > 0");

