use strict;
use inc::Module::Install;
use ExtUtils::CChecker;

name                'Time-Monotonic';
perl_version        '5.008001';
all_from            'lib/Time/Monotonic.pm';
repository          'http://github.com/chansen/p5-time-monotonic';
#readme_from         'lib/Time/Monotonic.pod';

requires            'Carp'               => '0';
requires            'Exporter'           => '0';
requires            'XSLoader'           => '0';

configure_requires  'ExtUtils::CChecker' => '0';

test_requires       'Test::More'         => '0.88';

my $cc = ExtUtils::CChecker->new;
$cc->try_compile_run(
   define => "HAVE_GETHRTIME",
   source => <<'EOF' );
        #include <unistd.h>
        #include <time.h>
        #include <sys/time.h>
        int main(int argc, char *argv[]) {
            hrtime_t ret = gethrtime();
            return 0;
        }
EOF
$cc->try_compile_run(
    define => "HAVE_CLOCK_GETTIME",
    source => <<'EOF' );
        #include <unistd.h>
        #include <time.h>
        #include <sys/time.h>
        int main(int argc, char *argv[]) {
            struct timespec ts;
            int ret = clock_gettime(CLOCK_MONOTONIC, &ts);
            return ret;
        }
EOF
$cc->try_compile_run(
   define => "HAVE_MACH_TIME",
   source => <<'EOF' );
        #include <unistd.h>
        #include <time.h>
        #include <sys/time.h>
        #include <mach/mach.h>
        #include <mach/mach_time.h>
        int main(int argc, char *argv[]) {
            mach_timebase_info_data_t timebase_info;
            (void)mach_timebase_info(&timebase_info);
            return 0;
        }
EOF

die "OS unsupported - Could not find a monotonic clock source\n"
  unless @{$cc->extra_compiler_flags};

makemaker_args      INC     => '-I.';
makemaker_args      DEFINE  => join ' ', @{$cc->extra_compiler_flags};

requires_external_cc;

WriteAll;

