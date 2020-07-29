#  Diagitizer - Diags booting utility

PLEASE NOTE THAT WE WON'T PROVIDE THE DIAGNOSTIC FILES! YOU CAN GRAB THEM FROM PURPLE TOOL BY @1nsane_dev

Features:
+ Setting usbserial bootarg automatically on bootup
+ One click booting diags (after correct setup)


Usage:

Place the bootchain in ~/Documents/diagitizer_bootchain/

If you use the bootchain of Purple, you may need to edit file named.
The DeviceModel values you can look up in TheiPhoneWiki and in supportedDevices.json

A valid bootchain set looks like that:


- iBSS.DeviceModel.img4
- iBoot.DeviceModel.img4
- diag.DeviceModel.img4

Example for iPhone X Model D221:
- iBSS.D221.img4
- iBoot.D221.img4
- diag.D221.img4


If there are only an iBoot and diags file, you need to create the iBSS file and place DEADBEEF bytes to it.
It should look like this:

![Image of DEEDBEED](https://github.com/j4nf4b3l/Diagitizer-Open-Source/blob/master/DEADBEEF_Example.png)

If you add a new model, you need to modify supportedDevices.json and add the missing information...

This tool is under MIT License, so feel free to contribute and modify like you want :)
