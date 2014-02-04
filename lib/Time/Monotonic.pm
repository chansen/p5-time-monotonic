package Time::Monotonic;

use strict;
use warnings;

BEGIN {
    our $VERSION    = '0.01';
    our @EXPORT_OK  = qw[ monotime ];
    our %EXPORT_TAGS = (
        all => [ @EXPORT_OK ],
    );

    require XSLoader;
    XSLoader::load(__PACKAGE__, $VERSION);

    require Exporter;
    *import = \&Exporter::import;
}

1;

