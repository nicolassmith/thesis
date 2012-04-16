#!/usr/bin/python

from svgfig import * 
from math import *
from subprocess import call

baseName = 'ring';

massRadius = 2; #radius of masses
massNumber = 8; #how many masses
circleRadius = 10; #radius of mass circle

h0 = 0.2; # gravitational wave strain
period = 20; # wave period (in frames)
maxFrames = 110; # how many images to make

edgeLength = massRadius + circleRadius*(1+h0); 

for frame in range(maxFrames):
    # this loops over the frames
    g = SVG('svg',height=str(2*edgeLength)+'px',width=str(2*edgeLength)+'px')
    h = h0*cos(2*pi*frame/period);
    for n in range(massNumber):
        # this loops over the masses in the ring
        c = SVG('circle',cx=edgeLength+(1+h)*circleRadius*cos(2*pi*n/massNumber),cy=edgeLength+(1-h)*circleRadius*sin(2*pi*n/massNumber),r=massRadius,fill='black',stroke='none');
        g.append(c);
    
    name = baseName+str(frame);
    g.save(name+'.svg')
    call(['inkscape', '--export-area-page','--export-pdf='+name+'.pdf',name+'.svg'])
    call(['rm', name+'.svg'])
