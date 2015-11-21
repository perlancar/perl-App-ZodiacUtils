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
        # dates => {
        date => {
            summary => 'Date',
            #schema => ['array*', of=>'date*', min_len=>1],
            schema => 'date*',
            'x.perl.coerce_to' => 'DateTime',
            req => 1,
            pos => 0,
            #greedy => 1,
        },
    },
    result_naked => 1,
    examples => [
        {
            args => {date=>'2015-06-15'},
            result => 'gemini',
            test => 0, # at the time of this writing, Test::Rinci hasn't used Perinci::Sub::CoerceArgs
        },
    ],
};
sub zodiac_of {
    require DateTime::Event::Zodiac;
    my %args = @_;

    #my $dates = $args{dates};
    my $dates = [$args{date}];

    my $res = [];
    for my $date (@$dates) {
        push @$res, DateTime::Event::Zodiac::zodiac_date_name($date);
    }
    $res = $res->[0] if @$res == 1;
    $res;
}

$SPEC{chinese_zodiac_of} = {
    v => 1.1,
    summary => 'Show Chinese zodiac for a date',
    args => {
        # dates => {
        date => {
            summary => 'Date',
            #schema => ['array*', of=>'date*', min_len=>1],
            schema => 'date*',
            'x.perl.coerce_to' => 'DateTime',
            req => 1,
            pos => 0,
            #greedy => 1,
        },
    },
    result_naked => 1,
    examples => [
        {
            args => {date=>'1980-02-17'},
            result => 'monkey (metal)',
        },
    ],

};
sub chinese_zodiac_of {
    require Zodiac::Chinese::Table;
    my %args = @_;

    #my $dates = $args{dates};
    my $dates = [$args{date}];

    my $res = [];
    for my $date (@$dates) {
        my $czres = Zodiac::Chinese::Table::chinese_zodiac(
            ref($date) ? $date->ymd : $date);
        push @$res, $czres ? "$czres->[7] ($czres->[3])" : undef;
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
