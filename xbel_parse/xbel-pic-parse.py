#!/usr/bin/env python3

import sys, os
from urllib import parse as ulp

recent_xbel = os.path.expanduser('~/.local/share/recently-used.xbel')

if not os.path.exists(recent_xbel):
    sys.exit("No file found at '~/.local/share/recently-used.xbel'")

with open(recent_xbel, 'r') as xbel_f:
    from xml.etree import ElementTree as ET
    tree = ET.parse(xbel_f)

bookmarks = tree.findall("bookmark[@modified]")

def getTimeModified(elem):
    return elem.attrib['modified']

for bookmark in bookmarks:
   bookmarks[:] = sorted(bookmarks, key = getTimeModified)

for recent_b in bookmarks[::-1]:
    mime = recent_b.find("info/metadata/*[@type]")
    mtype=mime.attrib['type']
    if mtype.split('/')[0] == 'image':
        f_href = recent_b.attrib['href']
        if not f_href.startswith('file://'): continue
        print('Opening', f_href)
        import subprocess
        subprocess.Popen(["gimp",f_href])
        break
