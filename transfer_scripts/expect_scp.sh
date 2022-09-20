#!/usr/bin/expect -f
set filename [lindex $argv 0]
set timeout -1
spawn scp $filename oxygen@ranch.tacc.utexas.edu:/stornext/ranch_01/ranch/projects/ATM22002/CESM2_Data
set pass ""
expect {
        Password: {send "$pass\r" ; exp_continue}
        eof exit
}
