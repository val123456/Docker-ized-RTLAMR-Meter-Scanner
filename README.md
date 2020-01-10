# Acknowledgments

This project leverages the great work done by Douglas Hall ([https://github.com/bemasher](https://github.com/bemasher)) on rtlamr, a rtl-sdr receiver for Itron ERT compatible smart meters operating in the 900MHz ISM band.  Project link for rtlamr:  [https://github.com/bemasher/rtlamr](https://github.com/bemasher/rtlamr).  He has also done some work with Docker (see [https://hub.docker.com/u/bemasher](https://hub.docker.com/u/bemasher)).

# Background

I've been using rtlamr plus some custom collection and graphing code on my general purpose Linux server for several years to track electric usage and solar panel output.  In the middle of 2019 I decided to move it to a [Raspberry Pi](https://www.raspberrypi.org/).  At that time I decided to see if using [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/) could help with managing deployment and fault tolerance.

So far the results are very promising, and I have decided to open source the result.  Docker-ized RTLAMR Meter Scanner is the first release, designed to help potential users test rtlamr and see if their meter data can be collected.

# Requirements 

Linux OS with Docker and Docker Compose installed and an RTL2832U SDR.  I have had good luck with the dongles from RTL-SDR ([https://www.rtl-sdr.com/buy-rtl-sdr-dvb-t-dongles/](https://www.rtl-sdr.com/buy-rtl-sdr-dvb-t-dongles/)).

This project has been tested on the following:



| OS  | Docker | Docker Compose |Hardware| 
| ------------- | ------------- |------------|---------|
| CentOS 7.7 (x86_64)|19.03.5|1.18.0|Dell PowerEdge T20|
|Ubuntu 18.04.3 LTS (aarch64)|18.09.7|1.17.1|Raspberry Pi 3 B+ *(underpowered if looking for R900 meters)*|
|Raspbian 10 (buster)|19.03.5|1.17.1|Raspberry Pi 4 B *(may be underpowered if looking for all meters types, running from a SanDisk Extreme SSD)*|


**Hardware Notes**: 

* This will not work on Mac OS X due to the way the USB is handled when using Docker.  I may release a version that works on Mac.
* The software used to interface with the SDR will output "error messages" on underpowered platforms.  It will still work, see comments in script.sh for more info.

# Building/Using
Download/clone source.  Open a terminal, `cd` into the top-level directory and run `docker-compose build` to build the container.  Then run `docker-compose up` to run it. To stop, use `CTRL-C`.

**Note:** On some systems, you may have to run these as commands as root using sudo: `sudo docker-compose build` and `sudo docker-compose up`.  On most systems you can avoid using `sudo` by adding your account to the docker group like this:  `sudo gpasswd -a $USER docker`

On my Raspberry Pi 4 with 4GB of RAM running Raspbian 10/buster, it takes about 90 seconds to build from scratch including downloads of base OS image.  

## Expected Output

The meter readings will be sent to the screen and written to a text file **meters.txt** in the ../meter_data folder. 

**Note**: this file will be appended to each time this program is run!

Screen output:


```bash
docker-compose up
Recreating rtlamr-print-docker_rtlamr-print_1 ... done
Attaching to rtlamr-print-docker_rtlamr-print_1
rtlamr-print_1  |
rtlamr-print_1  | Starting rtl_tcp:
rtlamr-print_1  |
rtlamr-print_1  | Found 1 device(s):
rtlamr-print_1  |   0:  Realtek, RTL2838UHIDIR, SN: 00000001
rtlamr-print_1  |
rtlamr-print_1  | Using device 0: Generic RTL2832U OEM
rtlamr-print_1  | Found Rafael Micro R820T tuner
rtlamr-print_1  | [R82XX] PLL not locked!
rtlamr-print_1  | Tuned to 100000000 Hz.
rtlamr-print_1  | listening...
rtlamr-print_1  |
rtlamr-print_1  | Starting rtlamr looking for SCM meters only
rtlamr-print_1  |
rtlamr-print_1  | Edit script.sh file to look for all meter types
rtlamr-print_1  |
rtlamr-print_1  | Output printed to display (STDOUT) and written to file in ../meter_data/meters.txt
rtlamr-print_1  |
rtlamr-print_1  | 10:09:51.302176 decode.go:45: CenterFreq: 912600155
rtlamr-print_1  | 10:09:51.302996 decode.go:46: SampleRate: 2359296
rtlamr-print_1  | 10:09:51.303062 decode.go:47: DataRate: 32768
rtlamr-print_1  | 10:09:51.303120 decode.go:48: ChipLength: 72
rtlamr-print_1  | 10:09:51.303193 decode.go:49: PreambleSymbols: 21
rtlamr-print_1  | 10:09:51.303251 decode.go:50: PreambleLength: 3024
rtlamr-print_1  | 10:09:51.303307 decode.go:51: PacketSymbols: 96
rtlamr-print_1  | 10:09:51.303377 decode.go:52: PacketLength: 13824
rtlamr-print_1  | 10:09:51.303458 decode.go:59: Protocols: scm
rtlamr-print_1  | 10:09:51.303515 decode.go:60: Preambles: 111110010101001100000
rtlamr-print_1  | 10:09:51.303570 main.go:119: GainCount: 29
rtlamr-print_1  | {"Time":"2020-01-04T10:09:51.60970623-05:00","Offset":0,"Length":0,"Type":"SCM","Message":{"ID":44448439,"Type":12,"TamperPhy":0,"TamperEnc":0,"Consumption":414046,"ChecksumVal":30302}}
rtlamr-print_1  | {"Time":"2020-01-04T10:09:55.504602295-05:00","Offset":0,"Length":0,"Type":"SCM","Message":{"ID":60450380,"Type":4,"TamperPhy":0,"TamperEnc":1,"Consumption":78990,"ChecksumVal":12768}}
rtlamr-print_1  | {"Time":"2020-01-04T10:09:56.561566232-05:00","Offset":0,"Length":0,"Type":"SCM","Message":{"ID":60450358,"Type":4,"TamperPhy":0,"TamperEnc":2,"Consumption":75805,"ChecksumVal":52579}}
^CGracefully stopping... (press Ctrl+C again to force)
Stopping rtlamr-print-docker_rtlamr-print_1   ... done
```
 