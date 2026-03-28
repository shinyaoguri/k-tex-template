#!/usr/bin/env perl
@default_files = ('main.tex');

$latex = 'uplatex -synctex=1 -halt-on-error';
$bibtex = 'upbibtex';
$dvipdf = 'dvipdfmx %O -o %D %S';
$makeindex = 'mendex -U %O -o %D %S';
$pdf_mode = 3;
$max_repeat = 5;

$ENV{'TZ'}='Asia/Tokyo';

if ($^O eq 'linux') {
    $ENV{OPENTYPEFONTS} = '/usr/share/fonts//:';
    $ENV{TTFONTS} = '/usr/share/fonts//:';
} elsif ($^O eq 'Darwin') {
    $pdf_previewer = "open %S";
    $ENV{OPENTYPEFONTS} = '/usr/local/texlive/texmf-local/fonts//:';
    $ENV{TTFONTS} = '/usr/local/texlive/texmf-local/fonts//:';
}