#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright (c) 2011 Jakub Szafrański <samu@pirc.pl>
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

# Console encoding detection

import termios, tty, sys, os

try:
    os.environ["TERM"]
except KeyError:
    os.environ["TERM"] = "none"
	
if os.environ["TERM"] != "xterm":
	print "Nie moge rozpoznac Twojego kodowania terminala"
else:
	
	def is_number(s):
		try:
			float(s)
			return True
		except ValueError:
			return False

	fd = sys.stdin.fileno()
	old = termios.tcgetattr(fd)
	tty.setraw(fd)

	print "żółćżółć",
	print "\033[6n",

	x = "";

	for c in iter(lambda: sys.stdin.read(1), "R"):
		if is_number(c) or c == ";":
			x+= c
		
	termios.tcsetattr(fd, termios.TCSADRAIN, old)
	x = x.split(";")

	if x[1] == "10":
		print "\rTwoje kodowanie terminala to UTF";
	else:
		print "\rTwoje kodowanie terminala to ISO";

