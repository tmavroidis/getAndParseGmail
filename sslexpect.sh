#!/usr/local/bin/expect -f
set timeout 20

spawn openssl s_client -connect pop.gmail.com:995
expect "+OK POP"           
send "USER <youremail>@gmail.com\n"       
expect "+OK send PASS" 
send "PASS <yourAppPassword>\n"
expect "+OK Welcome."
send "top 1 10\n"
expect "Subject:You received a voicemail from"
send "dele 1\n"
expect "+OK marked for deletion"
send "quit\n"   
expect "+OK Farewell." 
