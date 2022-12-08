# x6100_press.sh
Script to emulate / remotely "push" buttons on the Xiegu X6100, using evemu-tools.

I haven't tested this on the "stock" Linux OS. I used crazycat's Armbian because it has apt built in. You'll need to get evemu-tools one way or another.

Use at your own risk, etc.

One of the biggest problems is this just presses buttons; you'll need to use VNC or CAT to determine the state of the radio (i.e. frequency, mode, etc.).

Also this doesn't handle hand-mic or morse code key. Those do not seem to trigger events.

Demonstration video: https://www.youtube.com/watch?v=T6632P8i37g&ab_channel=JamesDallas

Note that emulating the power key (PWR-OFF) only seems to shut down the SoC, including the display and input buttons. I still hear static and the light on the microphone is still on (and pressing the PTT mic actually lights up the transmit light!). Using this option should at the very least reduce battery consumption, and probably keeps the radio from transmitting unattended/remotely. But it's only half as useful as it could/should be.

The web server script (x6100_press_server.sh) uses netcat. It is pretty slow and not always reliable. This is more a proof-of-concept. A python or perl based server would probably work better. It runs on port 8081. You can "press" buttons like so -- add the button code to the URL. For example: http://192.168.10.196:8081/ATU enables and disables the ATU on my radio (which has IP address 192.168.10.196).

73s de AD5NL
