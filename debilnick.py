#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# (c) 2011 DebilNick v 0.13
# Author: Jakub 'samu' Szafrański <samu@pirc.pl>
#
# This is actually a script made out of boredom. What it tries to do is
# check a nick and score its studipidity level - the higher it is, the
# more stupid the nick should be.
#
# Syntax: ./DebilNick <someStupidNick1337L0L>
#

import sys

def cnick(nick):
    ocena = 0
    
    duzaLitera = 0
    duzyMnoznik = 1
    numer = 0
    cyfra = 0
    cyfraMnoznik = 1
    litera = 0
    cplMnoznik = 1
    zlyCharM = 1
    zlyCharMM = 1
    nl = 1
    premia = 0
    lc = ""
    lcM = 1
    for c in nick:
        numer += 1
        
        if c in "_-+=":
            p = 2*zlyCharM
            ocena += p
            print "Niedozwolony znak (1): +"+str(int(p))+" (mnożnik: "+str(zlyCharM)+")"+" ["+str(ocena)+"]"
            zlyCharM = zlyCharM*1.3
        
        if c in "[]{}()<>":
            p = 2*zlyCharMM
            ocena += p
            print "Niedozwolony znak (2): +"+str(int(p))+" (mnożnik: "+str(zlyCharMM)+")"+" ["+str(ocena)+"]"
            zlyCharMM = zlyCharMM*1.8
            
        try: 
            c = int(c)
            
            if litera == 1:
                p = 3*cplMnoznik
                ocena += p
                print "Mieszanie liter z cyframi: +"+str(int(p))+" (mnożnik: "+str(cplMnoznik)+")"+" ["+str(ocena)+"]"
                cplMnoznik = cplMnoznik*1.8
            
            if cyfra == 1:
                p = 2*cyfraMnoznik
                ocena += p
                print "kilka cyfer pod rząd: +"+str(int(p))+" (mnożnik: "+str(cyfraMnoznik)+")"+" ["+str(ocena)+"]"
                cyfraMnoznik = cyfraMnoznik*1.4
                
            cyfra = 1
            litera = 0
        except:
            cyfra = 0
            litera = 1
        
            if cyfra == 1:
                p = 3*cplMnoznik
                ocena += p
                print "Mieszanie liter z cyframi: +"+str(int(p))+" (mnożnik: "+str(cplMnoznik)+")"+" ["+str(ocena)+"]"
                cplMnoznik = cplMnoznik*1.7
            
            if c.isupper():
                if duzaLitera == 1 and numer != 1:
                    p = 1*duzyMnoznik
                    ocena += p
                    print "Duża litera: +"+str(int(p))+" (mnożnik: "+str(duzyMnoznik)+")"+" ["+str(ocena)+"]"
                    duzyMnoznik = duzyMnoznik*1.25
                else:
                    if numer != 1:
                        p = 1*duzyMnoznik
                        ocena += p
                        print "Duża litera (CamelCase): +"+str(int(p))+" (mnożnik: "+str(duzyMnoznik)+")"+" ["+str(ocena)+"]"
                        duzyMnoznik = duzyMnoznik*1.5
                duzaLitera = 1
            else:
                if duzaLitera == 0:

                    if premia < 2:
                        ocena = ocena - 1*nl
                        nl = nl*1
                        premia += 1
                        if ocena <= 0:
                            ocena = 0
                else:
                    p = 1*duzyMnoznik
                    ocena += p
                    print "Mała litera (CamelCase): +"+str(int(p))+" (mnożnik: "+str(duzyMnoznik)+")"+" ["+str(ocena)+"]"
                    duzyMnoznik = duzyMnoznik*1.5
                    
                duzaLitera = 0
            if lc == c:
                p = 1.5*lcM
                ocena += p
                #print 1.5*lcM
                print "Powtórzenie znaku: +"+str(p)+" (mnożnik: "+str(lcM)+")"+" ["+str(ocena)+"]"
                lcM = lcM*1.5
            lc = c
            
    print "Premia za 'normalną' kolokację: -"+str(premia)+" (mnożnik: 1)"
    if ocena > 14:
        print "Oceniam to jako wkurwiający nick, z oceną: ",
    else:
        print "Nick wcale nie wydaje sie wkurwiajacy, ocena: ",
        
    return ocena
    
print cnick(sys.argv[1])
