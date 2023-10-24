Create a file /etc/udev/rules.d/70-logi-k380.rules with the following line:
```
ACTION=="add", SUBSYSTEM=="hidraw", KERNEL=="hidraw*", SUBSYSTEMS=="hid", KERNELS=="*:046D:B342.*", RUN+="/bin/bash -c \"echo -ne '\x10\xff\x0b\x1e\x00\x00\x00' > /dev/%k\""
```
