#!/bin/sh

# established 28-Aug-2013
# written by HREF Tools Corp.
# http://db.demos.href.com/webhub/seleniumgrid_linux/start_zombie.bash

# host has to be set to the current public dns entry
java -jar selenium-server-standalone-2.33.0.jar -role webdriver -hub http://db.demos.href.com:4444/grid/register -browser "browserName=htmlunit" -port 5555 -host ec2-54-213-191-149.us-west-2.compute.amazonaws.com

