#!/bin/sh

#
# Copyright (C) 2017-2018 @rockinroyle aka Ralph L Royle III
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>

#
# rsync backup script
# To be run as root user. syntax should be: "backup.sh <path to backup files>"
#

if [ $# -lt 1 ]; then
    echo "No destination defined. Usage: $0 destination" >&2
    exit 1
elif [ $# -gt 1 ]; then
    echo "Too many arguments. Usage: $0 destination" >&2
    exit 1
elif [ ! -d "$1" ]; then
   echo "Invalid path: $1" >&2
   exit 1
elif [ ! -w "$1" ]; then
   echo "Directory not writable: $1" >&2
   exit 1
fi

case "$1" in
  "/mnt") ;;
  "/mnt/"*) ;;
  "/media") ;;
  "/media/"*) ;;
  "/run/media") ;;
  "/run/media/"*) ;;
  *) echo "Destination not allowed." >&2
     exit 1
     ;;
esac

START=$(date +%s)
rsync -aAXv --delete --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} /* "$1" 
FINISH=$(date +%s)
echo "total time: $(( ($FINISH-$START) / 60 )) minutes, $(( ($FINISH-$START) % 60 )) seconds" | tee $1/"Backup from $(date '+%Y-%m-%d, %T, %A')"
