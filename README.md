# network-failover-switcher
I built this because I have a raspberry pi that I wanted to use for home automation.

Because of the security element of home automation I didn't want to assume that my normal broadband connection was up, so I got a 3g USB dongle and plugged that in, all good but my pi didn't know to route over the 3g dongle when the lan/wifi was down.

What this script will do is ping an IP you specify (`8.8.8.8` by default), and it will adjust your routing 'metric' based on the order you set the interfaces in.

You can run this script as often as you like, but I guess running it every 1 minute via cron is probably going to be 'ok', the risk you're exposing yourself to in that I guess is that someone will break your internet connection then enter your house within 60 seconds and because your home automation system doesn't retry to send you the notification of the breach you'll miss it.

## Installation
1. `apt-get install ifmetric`
1. Put this script in `/usr/local/bin/failover-network.sh`
1. `chmod +x /usr/local/bin/failover-network.sh`
1. Edit `INTERFACES` (below) to be in order the interfaces you have in the order you want them
1. (optional) Edit the `IP_TO_POLL`, I've used google's primary DNS service `8.8.8.8`
1. (optional) Edit `TIMEOUT` this is how long to wait for a ping reply
1. `echo "* * * * * root /usr/local/bin/failover-network.sh" > /etc/cron.d/failover-network`
