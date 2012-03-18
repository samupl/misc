#!/usr/bin/env tclsh
# -*- coding: utf-8 -*-
#
# Copyright (c) 2009 Jakub Szafrański <s@samu.pl>
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#

#
# Raw IRC
#

if {[lindex $argv 0] == "" || [lindex $argv 1] == ""} {
	puts "usage: script.tcl ip port";
	exit;
}

proc send {text} {
	puts $::fd $text;
	flush $::fd;
}

proc irc_recv {} {
	gets $::fd line;
	if {[eof $::fd]} {
		puts stdout "Socket closed.";
		exit;
	}
	if {[string trim $line] ne ""} {
                puts stdout $line;
		if {[lindex [split $line] 0] eq "PING"} {
			send "PONG [lindex [split $line] 1]";
		}
	}
}

proc get_line {} {
	gets stdin line;
	if {[string trim $line] ne ""} {
		send $line;
	}
}

set fd [socket [lindex $argv 0] [lindex $argv 1]];
fileevent $fd readable irc_recv;
fileevent stdin readable get_line;
vwait forever;

