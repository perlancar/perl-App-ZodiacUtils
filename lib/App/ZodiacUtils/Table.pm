package App::ZodiacUtils::Table;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

use Perinci::Sub::Gen::AccessTable qw(gen_read_table_func);
use Zodiac::Chinese::Table;

our %SPEC;

my $res = gen_read_table_func(
    name => 'list_chinese_zodiac_table',
    table_spec => $Zodiac::Chinese::Table::meta,
    table_data => $Zodiac::Chinese::Table::data,
);
$res->[0] == 200 or die "Can't generate list_chinese_zodiac_table(): $res->[0] - $res->[1]";

1;
# ABSTRACT: Zodiac table functions
