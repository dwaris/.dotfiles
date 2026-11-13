#!/usr/bin/env bash

pw-loopback --capture-props='target.object="alsa_input.pci-0000_11_00.6.analog-stereo"' --playback-props='target.object="effect_input.sennheiser_momentum_4"'
