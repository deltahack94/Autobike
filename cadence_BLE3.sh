#!/bin/bash

# Adresse MAC du périphérique Bluetooth
DEVICE_MAC="D0:DC:74:5C:A6:46"

# Référencement de la caractéristique sur bluetooth
CHARACTERISTIC_REF="/org/bluez/hci0/dev_D0_DC_74_5C_A6_46/service0009/char000a"

# Fichier de sortie pour enregistrer les données
OUTPUT_FILE="donnees_cadence.txt"

# Fonction pour se connecter au périphérique Bluetooth
connect_bluetooth_device() {
    echo -e "power on\nscan on" | bluetoothctl
    echo -e "connect $DEVICE_MAC\n" | bluetoothctl
}

# Select attribute CSC Measurement
select_data() {
    bluetoothctl <<- EOF
    menu gatt
    select-attribute $CHARACTERISTIC_REF
    notify on
    EOF
}

# Fonction pour lire et enregistrer les données
read_and_record_data() {
    while true
    do
   	
        # Lire les données de la caractéristique
        result=$(notify on)
	echo "result: $result"	
        
    done
}

#####

#!/bin/bash

# Set the Bluetooth device MAC address
DEVICE_MAC="D0:DC:74:5C:A6:46"

# Output file for notifications
OUTPUT_FILE="cadence_notifications.log"

# Connect to the Bluetooth device and start notifications
bluetoothctl <<- EOF
connect $DEVICE_MAC
menu gatt
select-attribute 0x000b
notify on
EOF

# Continuously read notifications and write to the log file
bluetoothctl | while IFS= read -r line; do
    # Check if the line contains "Notification"
    if [[ "$line" == *"Notification"* ]]; then
        # Append the notification to the output file
        echo "$line" >> "$OUTPUT_FILE"
        # Optional: Print the notification to the console
        echo "$line"
    fi
done

#####


connect_bluetooth_device # Connecter au périphérique Bluetooth
sleep 5  # Attendre que la connexion soit établie
echo "connected"

select_data # Selectionne l'attribut
echo "selected"

#read_and_record_data # Lire et enregistrer les données
