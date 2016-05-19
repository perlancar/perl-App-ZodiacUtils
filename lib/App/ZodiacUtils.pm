package App::ZodiacUtils;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our %SPEC;

$SPEC{zodiac_of} = {
    v => 1.1,
    summary => 'Show zodiac for a date',
    args => {
        dates => {
            summary => 'Dates',
            'x.name.is_plural' => 1,
            schema => ['array*', of=>'date*', min_len=>1],
            req => 1,
            pos => 0,
            greedy => 1,
        },
    },
    result_naked => 1,
    examples => [
        {
            args => {dates=>['2015-06-15']},
            result => 'gemini',
            test => 0, # at the time of this writing, Test::Rinci hasn't used Perinci::Sub::CoerceArgs
        },
        {
            summary => 'Multiple dates',
            description => <<'_',

If multiple dates are specified, the result will include the date to
differentiate which zodiac belongs to which date.

_
            args => {dates=>['2015-12-17','2015-12-29']},
            result => [["2015-12-17","sagittarius"], ["2015-12-29","capricornus"]],
            test => 0,
        }
    ],
};
sub zodiac_of {
    require Zodiac::Tiny;
    my %args = @_;

    my $dates = $args{dates};

    my $res = [];
    for my $date (@$dates) {
        my @lt = localtime($date);
        my $ymd = sprintf("%04d-%02d-%02d", $lt[5]+1900, $lt[4], $lt[3]);
        my $z = Zodiac::Tiny::zodiac_of($ymd);
        push @$res, @$dates > 1 ? [$ymd, $z] : $z;
    }
    $res = $res->[0] if @$res == 1;
    $res;
}

$SPEC{chinese_zodiac_of} = {
    v => 1.1,
    summary => 'Show Chinese zodiac for a date',
    args => {
        dates => {
            summary => 'Dates',
            'x.name.is_plural' => 1,
            schema => ['array*', of=>'date*', min_len=>1],
            req => 1,
            pos => 0,
            greedy => 1,
        },
    },
    result_naked => 1,
    examples => [
        {
            args => {dates=>['1980-02-17']},
            result => 'monkey (metal)',
        },
        {
            summary => 'Multiple dates',
            args => {dates=>['2015-12-17','2016-12-17']},
            result => [["2015-12-17","goat (wood)"], ["2016-12-17","monkey (fire)"]],
            test => 0,
        }
    ],

};
sub chinese_zodiac_of {
    require Zodiac::Chinese::Table;
    my %args = @_;

    my $dates = $args{dates};

    my $res = [];
    for my $date (@$dates) {
        my @lt = localtime($date);
        my $ymd = sprintf("%04d-%02d-%02d", $lt[5]+1900, $lt[4], $lt[3]);
        my $czres = Zodiac::Chinese::Table::chinese_zodiac($ymd);
        my $z = $czres ? "$czres->[7] ($czres->[3])" : undef;
        push @$res, @$dates > 1 ? [$ymd, $z] : $z;
    }
    $res = $res->[0] if @$res == 1;
    $res;
}

1;
# ABSTRACT: CLI utilities related to zodiac

=head1 DESCRIPTION

This distribution includes the following CLI utilities:

#INSERT_EXECS_LIST


=head1 SEE ALSO
