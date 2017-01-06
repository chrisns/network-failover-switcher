#!/bin/bash

###############################################################################
#                            Instructions for use                             #
#                                                                             #
# 1. apt-get install ifmetric                                                 #
# 1. Put this script in /usr/local/bin/failover-network.sh                    #
# 2. chmod +x /usr/local/bin/failover-network.sh                              #
# 2. Edit INTERFACES (below) to be in order the interfaces you have in the    #
#    order you want them                                                      #
# 3(optional). Edit the IP_TO_POLL (below), I've used google's DNS service    #
# 4. echo "* * * * * root /usr/local/bin/failover-network.sh" >               #
#      /etc/cron.d/failover-network                                           #
#                                                                             #
###############################################################################


#interfaces in order, first preferred
INTERFACES=(eth0 wlan0 eth1)

IP_TO_POLL=8.8.8.8

TIMEOUT=1 #second(s) timeout attempt

##################
for IFACE in "${INTERFACES[@]}"; do
  if ping -c 1 -w $TIMEOUT -q -I $IFACE $IP_TO_POLL &> /dev/null ; then
    export FIRST_WORKING_INTERFACE=$IFACE
    break
  fi
done

echo First working interface found was $FIRST_WORKING_INTERFACE
/usr/sbin/ifmetric $FIRST_WORKING_INTERFACE 0

for i in "${!INTERFACES[@]}"; do
  if [ ${INTERFACES[i]} != $FIRST_WORKING_INTERFACE ]; then
    /usr/sbin/ifmetric ${INTERFACES[i]} $((i+1))
  fi
done
