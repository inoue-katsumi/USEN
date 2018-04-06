#!/usr/bin/env bash
[ -z $3 ] && echo "Usage: $0 (YYYYMMDD) (HH:MI:SS) (any string to filter usen channel list)" && exit 1
curl --silent  https://raw.githubusercontent.com/inoue-katsumi/USEN/master/usen_channels_genre_uniq.csv |
grep $3 |
awk -F',' '{print $2,$3,$1}' | tr -d '"' |
while read band npch name
do
  curl --silent "http://music.usen.com/usencms/search_nowplay1.php?npband=$band&npch=$npch&npdate=$1&nptime=$2" |
  sed '1i<head> <meta charset="utf-8"/></head>' |
  xmllint --html --xpath "//ul[@class='clearfix np-now']/li/text()" - 2>/dev/null \
  && echo ",\"$name\""
done
