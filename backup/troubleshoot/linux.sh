#!/bin/bash

sudo ps -e
service walinuxagent start

sudo rm -f /var/lib/waagent/*.[0-9]*.xml
