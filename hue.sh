#!/bin/sh

. /usr/share/libubox/jshn.sh

hue_conf=/etc/hue.conf

if [ -e "$hue_conf" ]; then
	. $hue_conf
else
	# hue ip
	json_load "$(curl -s -k 'https://www.meethue.com/api/nupnp' | sed -e 's/^\[//' -e 's/\]$//' )"
	json_get_var ip internalipaddress
	echo ip=$ip > $hue_conf

	# hue username
	echo -n "username: "
	read username
	echo username=$username >> $hue_conf
fi
	
while [ 1 == 1 ]; do
	json_load "$(curl -s http://$ip/api/$username/lights)"
	json_get_keys lights

	for light in $lights; do
		json_select $light
		json_select state
		json_get_var on on
		json_get_values xy xy
		json_select ..
		json_select ..
		# eval "x=xxxx;y=yyyyy;"
		eval "$(echo $xy | awk '{printf("x=%g;y=%g;\n",$1,$2) ;}')"

		echo on=$on
		echo x=$x
		echo y=$y
		
		if [ "$on" == "1" ] &&  [ "$x" == "0.4595" ] && [ "$y" == "0.4105" ]; then
			curl -X PUT -d "{\"xy\":[0.3151,0.3252]}" http://$ip/api/$username/lights/$light/state
		fi
		echo
	done
	sleep 3;
done
