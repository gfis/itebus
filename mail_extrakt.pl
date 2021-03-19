#!perl

# Extrakte aus den kv-Emails
# @(#) $Id$
# 2021-03-19, Georg Fischer

use strict;
use warnings;
use integer;

my $mail_type = "vm"; # oder "tb", "ab"
my $date;
my $time;
my $timestamp;
my $vaccine;
my $vm = "";
my $millisec;
my $termin;
my $plz;
my $link;
my $server;
while (<>) {
    s/\s+\Z//; # chompr
    my $line = $_;
    if (0) {
    } elsif ($line =~ m{\AFrom \- }) {
        $mail_type  = "tb";
        $termin     = "";
        $millisec   = "";
        $plz        = "";
        $vm         = "";
        $vaccine    = "";
        $timestamp  = "";
        $link       = "";
        $server     = "";
    } elsif ($line =~ m{\ASubject\: }) {
        if (0) {
        } elsif ($line =~ m{Vermittlungscodes}) {
            $mail_type = "vm";
        } elsif ($line =~ m{wurde abgesagt}) {
            $mail_type = "ab";
        } elsif ($line =~ m{Terminbuchung}) {
            $mail_type = "tb";
        } else {
            print STDERR "unbekannter Mail-Typ, Subject=\"$line\"\n";
        }
    } elsif ($line =~ m{\AMessage\-ID\: \<(\d+)\-(\d+)}) { # Message-ID: <20210307-174744
        ($date, $time) = ($1, $2);
        $timestamp = substr($date, 0, 4) . "-" . substr($date, 4, 2) . "-" . substr($date, 6, 2) . " "
                   . substr($date, 0, 2) . ":" . substr($date, 2, 2) . ":" . substr($date, 4, 2);
    } elsif ($line =~ m{\A(Comirnaty|COVID\-1912) \((\w+)\)\<\/h3\>\<\/p\>}) { # Comirnaty (BioNTech)</h3></p>
        $vaccine = $2;
    } elsif ($line =~ m{Ihr Vermittlungscode\: ([A-Z0-9\-]+)}) { #
        $vm = $1;
    } elsif ($line =~ m{\<h3\>Ihr Impftermin\: (\d+\.\d+\.\d+) um (\d+\:\d+) Uhr}) { # <h3>Ihr Impftermin: 05.04.2021 um 15:00 Uhr</h3=
        $termin = "$1 $2";
    } elsif ($line =~ m{\A *([0-9]{5}) \w+}) { #
        $plz = $1;;
    } elsif ($line =~ m{\A\s+boundary\=[^\.]+\.(\d+)}) { #         boundary="----=_Part_26660297_571508914.1615139264205"
        $millisec = $1;
    } elsif ($line =~ m{\A\s+\<a href\=3D\"(https\:\/\/[0-9\-]+)\=\Z}) {
        $link = $1;
      #                                                    <a href=3D"https://005-=
      #iz.impfterminservice.de/impftermine/suche/GM5L-6KV8-7W6C/79341/" target=3D"=
    } elsif ($line =~ m{\A(iz\.impfterminservice.de\/impftermine\/suche\/([^\/]+)\/(\d+)\/)}) {
        $link .= $1;
        $vm    = $2;
        $plz   = $3;
        $link  =~ m{\/\/(\d+)};
        $server = $1;
    } elsif ($line =~ m{\A\<\/html\>}) { # </html>
        if (0) {
        } elsif ($mail_type eq "vm") {
            print join("\t", $mail_type, $millisec, $timestamp, $vm, $plz, "--", "--", $link) . "\n";
        } elsif ($mail_type eq "tb") {
            print join("\t", $mail_type, $millisec, $timestamp, $vm, $plz, $termin, $vaccine) . "\n";
        } elsif ($mail_type eq "ab") {
        }
    }

} # while <>
__DATA__
