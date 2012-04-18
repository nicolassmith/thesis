#!/usr/bin/python

from svgfig import * 
from math import *
from subprocess import call

print 'chargin mah laser';

baseName = 'ring';

massRadius = 2; #radius of masses
massNumber = 8; #how many masses
circleRadius = 10; #radius of mass circle

h0 = 0.2; # gravitational wave strain
period = 20; # wave period (in frames)
maxFrames = 100; # how many images to make
frameOffset = 14;

edgeLength = massRadius + circleRadius*(1+h0); 

for frame in range(maxFrames):
    # this loops over the frames
    name = baseName+str(frame+1);
    if frame >= period:
        call(['ln','-s',baseName+str(frame%period+1)+'.pdf',name+'.pdf'])
    else:
        g = SVG('svg',height=str(2*edgeLength)+'px',width=str(2*edgeLength)+'px')
        h = h0*sin(2*pi*(frame+frameOffset)/period);
        for n in range(massNumber):
            # this loops over the masses in the ring
            c = SVG('circle',cx=edgeLength+(1+h)*circleRadius*cos(2*pi*n/massNumber),cy=edgeLength+(1-h)*circleRadius*sin(2*pi*n/massNumber),r=massRadius,fill='black',stroke='none');
            g.append(c);
        g.save(name+'.svg')
        call(['inkscape', '--export-area-page','--export-pdf='+name+'.pdf',name+'.svg'])
        call(['rm', name+'.svg'])
