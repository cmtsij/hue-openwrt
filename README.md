## Hue script for OpenWrt

This script fixed Hue light always use yellow color by default. 

Pre-requirement:
* curl
* jshn and jshn.sh to parsse JSON (from libubox. Already include in OpenWrt)

## Implementation

Tt probes specific color(default color) by Hue API, and then switch to white color.

## Why not python

There are many Hue API written by python. 
Those python Hue API uses numpy to translate RGB to xy color space. 
But it is hard to porting to OpenWrt, and need lots flash space.(python itself and numpy)
So I dropped python and select "curl" and "jshn" to hook Hue API.
