#!/usr/bin/perl
#
# $Id$
#
# vbsfilter v0.0 - Very simple VBScript filter for Doxygen.
#
# 2009 (c) Igor Ostapenko [ mailto:igor.ostapenko@gmail.com ]
#
# Usage:
#   vbsfilter.pl file1 [file2 ...]
#
# Forward Doxygen comments should begin with '' (two 'single quote' characters).
# Backward comments should be the same but followed by < ('lesser than' character).
# It doesn't pay attention for comments like "rem comment".
#
# P.S. PERL - Practically Encrypted by RSA Language (c) piranha
#

use Switch;

sub parseParameters {
    ($line) = @_;
    print "(";
    @params = split(/,/, $line);
    $theFirst = 1;
    foreach (@params) {
        if (/\s*(?:(byref|byval)\s+)?(\w+)/i) {
            if ($theFirst) {
                $theFirst = 0;
            } else {
                print ", ";
            }
            if ($1 eq "byref") {
                print "byref";
            }
            print " ".$2;
        }
    }
    print ")";
}

while (<>) {

    # look for comment avoiding strings (e.g., "it's not comment's begin")
    # and cut it from the line
    $comment = "";
    if (/^(?:[^"']|"[^"]*")*''(.*)$/) {
        $comment = $1;
        $_ = substr($_, 0, index($_, $comment) - 2);
    }

    # split line by 'colon' into several ones
    while (/^((?:[^:"]|".*")+)(:.*)?$/) {

        # get line and remember the rest
        $_ = $1;
        $left = $2;

        # const
        if (/^\s*const\s+(\w+)\s*=\s*(.*)$/i) {
            print "const ".$1." = ".$2.";\n";
        }

        # class
        if (/^\s*class\s+(\w+)\s*$/i) {
            print "class ".$1."{\n";
        }

        # function/sub
        if (/^\s*(?:(public(?:\s+default)?|private)\s+)?(function|sub|property\s+(?:get|let|set))\s+(\w+)(?:\s*\((.*)\))?\s*$/i) {
            print index(lc($1), "private") >= 0 ? "private:" : "public:", " ";
            switch ($2) {
                print "function" case /function/i;
                print "sub" case /sub/i;
                print "property_get" case /get/i;
                print "property_let" case /let/i;
                print "property_set" case /set/i;
            }
            print " ".$3;
            parseParameters($4);
            print "{\n";
        }

        # end class/function/sub/property
        if (/^\s*end\s+(class|function|sub|property)\s*$/i) {
            print "}";
            print ";" if index(lc($1), "class") >= 0;
            print "\n";
        }

        # get next line
        if ($left) {
            $_ = substr($left, 1, length($left) - 1);
        } else {
            $_ = "";
        }
    }

    # show comment
    if ($comment) {
        print "///".$comment."\n";
    }
}

