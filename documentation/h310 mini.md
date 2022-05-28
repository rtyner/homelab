# Flashing Perc H310 Mini to IT Mode

This is a copy of the docs at <https://fohdeesha.com/docs/> in the case of this site going offline.

## Preparation

Ensure there is only one LSI-based adapter in your system. If there are others besides the adapter you intend to flash, remove them! You also need to disable a few BIOS settings. This step is not optional. In your server BIOS, **disable** all of the following:

- Processor Settings > Virtualization Technology
- Integrated Devices > SR-IOV Global Enable
- Integrated Devices > I/OAT DMA Engine

> Note: If you're flashing a full size card on a non-Dell system, such as an AMD based desktop or server, make sure you find any BIOS settings related to IOMMU and Virtualization, and disable them

You also **must** set the server boot mode to BIOS, not UEFI:

- Boot Settings > Boot Mode > Set to **BIOS**

When you're finished with this guide, don't forget to go back and enable Virtualization, as well as SR-IOV if you plan to use it. Switch boot mode back to UEFI as well if you were using it previously. But only once you've finished the guide!

**Remove the RAID battery** from the adapter. The IT firmware has no cache for the battery to back, in fact the IT firmware will have no clue the battery is there if you leave it connected. To make matters worse, in rare cases some people observed the battery holding old Dell code in the card's RAM and it made their crossflash process a pain. Just unplug/remove the battery and store it somewhere in case you return to Dell firmware.

Download the ZIP below which contains two ISOs. One is a FreeDOS live image, the other is a Debian live image. Both come prepackaged with all the required tools and files, and they can be booted either via iDRAC virtual media or by burning them to a flash drive via [Rufus](https://rufus.ie/), using `dd`, or your favorite flashing utility - up to you.

[`Dell Perc Flashing ZIP`](https://fohdeesha.com/docs/store/perc/perc-crossflash-v2.1.zip)  
`Version: v2.1`  
`ZIP Updated: 04-08-2022`  
`MD5: 42a87bd496f6d2e3aa1d8f2afe3cc699`

## H310 Mini & Full Size IT Mode Flashing

Instructions for flashing the H310 Mini Mono or H310 Full Size. Full credits for this guide go to [fourlynx](mailto:fourlynx@phoxden.net) and his original [H310 Mini guide](https://doku.phoxden.net/pages/viewpage.action?pageId=7208964). As we were working on these H710 guides together and building a convenient live ISO, we figured we might as well add an easy H310 script to it.

### Linux Time

Boot into the Linux ISO from the ZIP. Use the following credentials to login: **user/live**

We highly recommend SSH'ing to the live ISO so you can copy/paste commands and not have to use the iDRAC virtual console. To do so, run the following to find the IP of the install:

`ipinfo`

It should spit out an IP. SSH to it, using the same **user/live** credentials. This is not required and you can continue on using the iDRAC (or physical) console, but it will be slightly more inconvenient.

### Flashing IT Firmware

Now, still in Linux, we need to change to the root user:

`sudo su -`

Now we need to note down the SAS address of the adapter so we can program it back later. Run the following and save the output somewhere:

`sas-h310`

Once you have the address saved, run the flashing script. This will program the appropriate IT mode SBR, then flash the card with IT firmware:

`H310`

It should automatically do everything required to flash the card. If you don't get any unexpected errors and it completes, we need to reboot and program the SAS address back to finish. See the following note.

**Note:** For some reason, the very first boot after crossflashing the card will cause a kernel panic - I believe it's iDRAC not letting go of something (I was able to see the card put in a fault state via the debug UART when this happens). This only happens the first reboot after crossflashing. When you boot back into the live ISO and get the panic, either let it reboot itself, or use iDRAC to force a reboot. After that boot back into the live ISO again and all will be well.

### Programming SAS Address Back

Now rebooted back into the live Linux image, just run the following commands, filling in the example address with your own, that you noted down earlier:

`sudo su - setsas 500605b123456777`

It should succeed without errors. That's it! You can run the following command to get some info about your new card. You should be able to see your SAS address and the same firmware version:

`info`

        Controller Number              : 0
        Controller                     : SAS2008(B2)
        PCI Address                    : 00:02:00:00
        SAS Address                    : 5b8ca3a-0-f37a-4500
        NVDATA Version (Default)       : 14.01.00.08
        NVDATA Version (Persistent)    : 14.01.00.08
        Firmware Product ID            : 0x2213 (IT)
        Firmware Version               : 20.00.07.00
        NVDATA Vendor                  : LSI
        NVDATA Product ID              : SAS9211-8i
        BIOS Version                   : N/A
        UEFI BSD Version               : N/A
        FCODE Version                  : N/A
        Board Name                     : SAS9211-8i
        Board Assembly                 : N/A
        Board Tracer Number            : N/A

Unless you also need to flash boot images for booting off the card, you can now ditch all the live images and reboot back into your normal system, and enjoy your IT mode card.

### Optional: Boot Images

> Note: flashing these can add up to 2 minutes to server boot time if you have a lot of drives. Be sure you need them!

If you need to boot from drives connected to this adapter, you'll need to flash a boot image to it. Otherwise, skip it. This is what gives you the "press blahblah to enter the LSI boot configuration utility" text when the server boots. To flash the regular BIOS boot image:

`flashboot /root/Bootloaders/mptsas2.rom`

If you want to UEFI boot from drives connected to this adapter, you need to flash the UEFI boot image (the card can have both UEFI and BIOS boot images flashed):

`flashboot /root/Bootloaders/x64sas2.rom`

You can now ditch the live images and boot back into your normal system.

### Optional: Reverting

**Note:** This is only for reverting the H310 Mini to stock. A script for reverting the H310 Full Size will be added shortly.

If for some reason you need to revert back to the stock Dell PERC firmware, that's easy. Boot into the FreeDOS live image, and run the following command:

`310REVRT`

That's it! When it finishes, just reboot back to your normal system with the `reboot` command.

> Note: This uses the unmodified latest Dell firmware `20.13.3-0001,A11` extracted from the update EXE found [here](https://www.dell.com/support/home/us/en/04/drivers/driversdetails?driverid=yp0nf&oscode=ws8r2&productcode=poweredge-r720).
