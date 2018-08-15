#!/bin/bash
# The wav file to play only once
SOUND_FILE="/home/wallet/Music/source/sms-alert-2-daniel_simon.wav"
aplay -q $SOUND_FILE &
