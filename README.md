# x6100_press.sh
Script to emulate / remotely "push" buttons on the Xiegu X6100, using evemu-tools.

I haven't tested this on the "stock" Linux OS. I used crazycat's Armbian because it has apt built in. You'll need to get evemu-tools one way or another.

Use at your own risk, etc.

One of the biggest problems is this just presses buttons; you'll need to use VNC or CAT to determine the state of the radio (i.e. frequency, mode, etc.).
