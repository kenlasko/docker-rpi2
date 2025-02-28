#!/usr/bin/expect -f

set controller "DC:A6:32:C9:E7:97"
set device "F4:4E:FD:A1:CE:76"
set timeout 60

spawn bluetoothctl
expect "Agent registered"
set timeout 5
send -- "paired-devices\r"
expect {
   "$device" { 
     send -- "exit\r"
     expect eof
     exit 
  }
}
set timeout 30
send -- "scan on\r"
expect "$device"
send -- "pair $device\r"
expect "Pairing successful"
send -- "trust $device\r"
expect "trust succeeded"
send -- "exit\r"
expect eof
