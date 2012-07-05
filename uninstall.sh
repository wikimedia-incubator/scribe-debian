#!/bin/bash

aptitude search 'thrift|fb303|scribe' | egrep "^i" | awk '{print $2}' | xargs dpkg -r