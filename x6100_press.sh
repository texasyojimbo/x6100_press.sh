#!/bin/bash

#################################################################################
##
## x6100_press.sh
##
#################################################################################
##
## Author: James "Gwen" Dallas, AD5NL
##
## Description: This script emultates button pushes and rotary encoder spins
##              on the Xiegu X6100 transceiver. This allows for the radio to 
##              controlled using macros/scripts or remotely without the use 
##              of CAT/Hamlib (you will want to use VNC to see screen!)
##
##		This script depends on:
##
##		1) A Xiegu X6100 transceiver (duh).
##		2) An Armbian OS, particularly the image from CrazyCats100
##			and Links2004/x6100-armbian.
##			See: https://www.youtube.com/watch?v=DA8XQ1y5LEo
##		3) An SD card for the Armbian OS (duh).
##		4) Evemu. To install: sudo apt-get install evemu-tools
##
##		This script builds on the work of Branko Djokic HB9TXB.
##		See: djbr1/x6100_evtest.txt on GitHub gist.
##		https://gist.github.com/djbr1/a2adff422ae26ac113d9b527f7ec2e2b
##
##		The press function was inspired by Alessio Ciriea's 
##		article on fedoramagazine.org about evemu.
##		https://fedoramagazine.org/simulate-device-input-evemu/
##
##		Discussion will be on the TOADS discord server:
##		https://discord.com/channels/755897811148734536
##
##		For most buttons, just enter one option.
## 		The script will emulate pressing and releasing the button.
##
##		Long-press functions (ATT, TUNE, SPL, etc.) are treated 
##       	as separate from their physical buttons (PRE, ATU, AGC).
##
##		For PTT, there is separate PTT-ON (press) and PTT-OF
##		(release) since the length is arbitrary. DIT and DAH
##		turn the PTT on for 0.1 and 0.3 seconds respectively and then
##		turn it off (releases the button).
##
##		For the rotary encoders, you can optionally include a number
##		of steps to turn.
##
##		Note that this script only emulates controls on the X6100 unit
##		itself and does not emulate any buttons/keys on the hand mic or 
##		morse code key. Using the hand mic PTT/buttons does not appear to
##		trigger an event at the OS level, and are likely processed by the
##		baseband firmware. 
##
## Examples:
##		1) Enable ATU: x6100_press.sh ATU
##		2) Tune ATU (long press of ATU button): x6100_press.sh TUNE
##		3) Decrease volume by 5 units: x6100_press.sh VSG-DN 5
##		   (note this assumes VSG knob is in "Volume" mode).
##		4) Turn the VFO clockwise by one step: x6100_press.sh VFO-UP
##              5) Change the VOL-SQL-RFG function: x6100_press.sh VSG
##		6) Turn the PTT on and leave it on: x6100_press.sh PTT-ON
##		7) Turn the PTT on for length of a dit: x6100_press.sh DIT
##		8) Power off the radio: x6100_press.sh PWR-OFF
##
#################################################################################
##
## Versions:
##		1.0	Initial Release		7 December 2022
##
#################################################################################

function press {
if [[ $# -gt 1 ]]; then delay=$2; else delay="0.2"; fi
device="/dev/input/event0"
evemu-event ${device} --type EV_KEY --code $1 --value 1 --sync
sleep $delay
evemu-event ${device} --type EV_KEY --code $1 --value 0 --sync
sleep 0.2
}

function vfo {
device="/dev/input/event1"
evemu-event ${device} --type EV_REL --code REL_X --value $1 --sync
}

function vsg {
device="/dev/input/event2"
evemu-event ${device} --type EV_REL --code REL_Y --value $1 --sync
}

function mfk {
device="/dev/input/event3"
evemu-event ${device} --type EV_REL --code REL_Z --value $1 --sync
}

function ptt-on {
device="/dev/input/event0"
evemu-event ${device} --type EV_KEY --code BTN_TRIGGER_HAPPY4 --value 1 --sync
}

function ptt-off {
device="/dev/input/event0"
evemu-event ${device} --type EV_KEY --code BTN_TRIGGER_HAPPY4 --value 0 --sync
}

function power-off {
device="/dev/input/event4"
evemu-event ${device} --type EV_KEY --code KEY_POWER --value 1 --sync
sleep 2.0
evemu-event ${device} --type EV_KEY --code KEY_POWER --value 0 --sync
}

if [[ $# -gt 1 ]]; then steps=$2; else steps=1; fi

case $1 in

	GEN)
		press BTN_TRIGGER_HAPPY1
		;;
	
	KEY)
		press BTN_TRIGGER_HAPPY2 
		;;

	DFN)
		press BTN_TRIGGER_HAPPY3
		;;

	APP)
		press BTN_TRIGGER_HAPPY7
		;;
	
	MSG)
		press BTN_TRIGGER_HAPPY8
		;;

	DFL)
		press BTN_TRIGGER_HAPPY9
		;;

	1)
		press BTN_TRIGGER_HAPPY13
		;;
	
	2) 	
		press BTN_TRIGGER_HAPPY14
		;;
	
	3) 
		press BTN_TRIGGER_HAPPY15
		;;

	4)
		press BTN_TRIGGER_HAPPY19
		;;

	5)
		press BTN_TRIGGER_HAPPY20
		;;

        PTT-ON)
		ptt-on
		;;

	PTT-OFF)
		ptt-off
		;;
	
	BAND-DN)
		press BTN_TRIGGER_HAPPY5
		;;
	
	BAND-UP)
		press BTN_TRIGGER_HAPPY6
		;;
	
	AMFM)
		press BTN_TRIGGER_HAPPY10
		;;
	
	CW)
		press BTN_TRIGGER_HAPPY11
		;;
	
	SSB)
		press BTN_TRIGGER_HAPPY12
		;;
	
	BKLT)
		press BTN_TRIGGER_HAPPY25
		;;

	LOCK)
		press BTN_TRIGGER_HAPPY25 1.1
		;;
	
	AB)
		press BTN_TRIGGER_HAPPY16
		;;
        
	A2B)
		press BTN_TRIGGER_HAPPY16 1.1
		;;

	PRE)
		press BTN_TRIGGER_HAPPY17
		;;
	
	ATT)
		press BTN_TRIGGER_HAPPY17 1.1
		;;

	ATU)
		press BTN_TRIGGER_HAPPY18
		;;
	
	TUNE)
		press BTN_TRIGGER_HAPPY18 1.1
		;;

	VM)
		press BTN_TRIGGER_HAPPY22
		;;

	V2M)
		press BTN_TRIGGER_HAPPY22 1.1
		;;

	AGC)
		press BTN_TRIGGER_HAPPY23
		;;
	
	SPL)	
		press BTN_TRIGGER_HAPPY23 1.1
		;;

	FST)
		press BTN_TRIGGER_HAPPY24
		;;

	#VOL - SQL - RFG KNOB PRESS
	VSG)
		press BTN_TRIGGER_HAPPY21
		;;
	
	#MULTIFUNCTION KNOB PRESS
	MFK)
		press BTN_TRIGGER_HAPPY27
		;;

	VFO-UP)
		for steps in $(seq 1 1 $steps); do vfo 1; done
		;;
	
	VFO-DN)	
		for steps in $(seq 1 1 $steps); do vfo -1; done
		;;

	# Note the encoding for VSG and MFK seems backward (negative is up, positive is down).
	VSG-UP)
		for steps in $(seq 1 1 $steps); do vsg -1; done
		;;
	
	VSG-DN)
		for steps in $(seq 1 1 $steps); do vsg 1; done
		;;

	MFK-UP)
		for steps in $(seq 1 1 $steps); do mfk -1; done
		;;

	MFK-DN)
		for steps in $(seq 1 1 $steps); do mfk 1; done
		;;

	DIT)
		ptt-on
		sleep 0.1
		ptt-off
		sleep 0.1
		;;

	DAH)
		ptt-on
		sleep 0.3
		ptt-off
		sleep 0.1
		;;

	SPC)
		sleep 0.3
		;;

	PWR-OFF)
		power-off
		;;

	*)
		echo "Available options: "
		echo " (Left Buttons)...........GEN KEY DFN APP MSG DFL"
		echo " (Bottom Buttons).........1 2 3 4 5"
		echo " (PTT Button).............PTT-ON PTT-OFF DIT DAH SPC"
		echo " (Top Buttons)............BAND-DN BAND-UP AMFM CW SSB"
		echo " (Top Buttons)............AB A2B PRE ATT ATU TUNE"
		echo " (Top Buttons)............VM V2M AGC SPL FST"
		echo " (Right Button)...........BKLT LOCK"
		echo " (Rotary Encoder Push)....VSG MFK"
		echo " (Rotary Encoder Spin)....VFO-DN VFO-UP VSG-DN VSG-UP MFK-DN MFK-UP" 
		echo " (Power Button)...........PWR-OFF"
		;;
esac

