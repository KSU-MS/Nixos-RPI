# NixOS RPi Image for Test

This repository contains a NixOS configuration and SD card image build setup for the Raspberry Pi 3.  
It’s primarily for testing and experimenting with NixOS on ARM devices.

## Features
- Prebuilt `.img.zst` image for Raspberry Pi 3
- Simple flake-based configuration
- Includes CopyParty module and user config

## Usage
Flash the image to your SD card using `dd` or Balena Etcher:
```bash
sudo dd if=rpi3.img.zst of=/dev/sdX bs=4M status=progress

