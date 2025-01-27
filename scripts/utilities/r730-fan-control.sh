#!/bin/bash

# Variables
IDRAC_HOSTS=("10.1.1.222" "10.1.1.223" "10.1.1.224")
IDRAC_USER="root"
IDRAC_PASSWORD=""

# Fan speed in %
SPEED0="0x00"
SPEED5="0x05"
SPEED10="0x0a"
SPEED15="0x0f"
SPEED20="0x14"
SPEED25="0x19"
SPEED30="0x1e"
SPEED35="0x23"

# Temperature settings
TEMP_THRESHOLD="65" # iDRAC dynamic control enable threshold
TEMP_SENSOR="04h"   # Inlet Temp
#TEMP_SENSOR="01h"  # Exhaust Temp
TEMP_SENSOR="0Eh"  # CPU 1 Temp
TEMP_SENSOR="0Fh"  # CPU 2 Temp

# Get system date & time
DATE=$(date +%d-%m-%Y\ %H:%M:%S)
echo "Date: $DATE"

# Function to control fans for a single host
control_fans() {
    local IDRAC_IP=$1
    echo "Processing iDRAC host: $IDRAC_IP"

    # Get temperature from iDRAC
    T=$(ipmitool -I lanplus -H $IDRAC_IP -U $IDRAC_USER -P $IDRAC_PASSWORD sdr type temperature | grep $TEMP_SENSOR | cut -d"|" -f5 | cut -d" " -f2)

    echo "--> iDRAC IP Address: $IDRAC_IP"
    echo "--> Current Inlet Temp: $T"

    # Check if temperature reading was successful
    if [ -z "$T" ]; then
        echo "--> Failed to get temperature reading from $IDRAC_IP"
        return 1
    fi

    # If ambient temperature is above threshold enable dynamic control and exit
    if [[ $T -ge $TEMP_THRESHOLD ]]; then
        echo "--> Temperature is above 65deg C"
        echo "--> Enabled dynamic fan control"
        ipmitool -I lanplus -H $IDRAC_IP -U $IDRAC_USER -P $IDRAC_PASSWORD raw 0x30 0x30 0x01 0x01
        return 0
    else
        echo "--> Temperature is below 60deg C"
        echo "--> Disabled dynamic fan control"
        ipmitool -I lanplus -H $IDRAC_IP -U $IDRAC_USER -P $IDRAC_PASSWORD raw 0x30 0x30 0x01 0x00
    fi

    # Set fan speed based on temperature ranges
    if [ "$T" -ge 1 ] && [ "$T" -le 24 ]; then
        echo "--> Setting fan speed to 10%"
        ipmitool -I lanplus -H $IDRAC_IP -U $IDRAC_USER -P $IDRAC_PASSWORD raw 0x30 0x30 0x02 0xff $SPEED10
    elif [ "$T" -ge 25 ] && [ "$T" -le 34 ]; then
        echo "--> Setting fan speed to 15%"
        ipmitool -I lanplus -H $IDRAC_IP -U $IDRAC_USER -P $IDRAC_PASSWORD raw 0x30 0x30 0x02 0xff $SPEED15
    elif [ "$T" -ge 35 ] && [ "$T" -le 54 ]; then
        echo "--> Setting fan speed to 20%"
        ipmitool -I lanplus -H $IDRAC_IP -U $IDRAC_USER -P $IDRAC_PASSWORD raw 0x30 0x30 0x02 0xff $SPEED20
    elif [ "$T" -ge 55 ] && [ "$T" -le 59 ]; then
        echo "--> Setting fan speed to 25%"
        ipmitool -I lanplus -H $IDRAC_IP -U $IDRAC_USER -P $IDRAC_PASSWORD raw 0x30 0x30 0x02 0xff $SPEED25
    elif [ "$T" -ge 60 ] && [ "$T" -le 64 ]; then
        echo "--> Setting fan speed to 30%"
        ipmitool -I lanplus -H $IDRAC_IP -U $IDRAC_USER -P $IDRAC_PASSWORD raw 0x30 0x30 0x02 0xff $SPEED30
    fi

    echo "--> Completed processing for $IDRAC_IP"
    echo "----------------------------------------"
}

# Main loop to process all hosts
for host in "${IDRAC_HOSTS[@]}"; do
    control_fans "$host"
    if [ $? -ne 0 ]; then
        echo "Warning: Failed to process host $host"
    fi
done