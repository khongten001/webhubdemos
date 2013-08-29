#!/bin/sh

# established 28-Aug-2013
# written by HREF Tools Corp.
# http://db.demos.href.com/webhub/seleniumgrid_linux/start_zombie.bash

echo selenium grid call-back port will be $1

# host has to be set to the current public dns entry
# let Amazon tell us our current public hostname
if [-e public-hostname];
then
cat public-hostname
else
wget http://169.254.169.254/latest/meta-data/public-hostname
fi

# pipe relevant portion into an environment variable
ec2publichost=`grep ^ec2*. public-hostname`

# start zombie
java -jar selenium-server-standalone-2.33.0.jar -role webdriver -hub http://db.demos.href.com:4444/grid/register -browser "browserName=htmlunit" -port $1 -host $ec2publichost

