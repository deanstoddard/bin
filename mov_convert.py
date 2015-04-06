#!/usr/bin/env python

import os

files=os.listdir(".")

mov_files=[filename for filename in os.listdir(".") if filename[-4:] == '.mov']

# HandBrakeCLI --preset="High Profile" -i ${timestamp}.AVI -o "${timestamp}.m4v"

for mov_file in mov_files:
    mp4_file = mov_file[:-4] + '.mp4'
    #cmd_string = "/usr/bin/ffmpeg -i %s %s" % (mov_file,mp4_file)
    #cmd_string = "HandBrakeCLI --preset=\"High Profile\" -i %s -o %s" % (mov_file,mp4_file)
    cmd_string = "/usr/bin/ffmpeg -i %s -vcodec h264 -acodec aac -strict -2 %s" % (mov_file,mp4_file)
    print("%s") % cmd_string
    os.system(cmd_string)


