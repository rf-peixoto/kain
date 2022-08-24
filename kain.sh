#!/bin/bash
echo -e "\e[1;32m   ____  __.      .__"
echo -e "  |    |/ _|____  |__| ____"
echo -e "  |      < \__  \ |  |/    \ "
echo -e "  |    |  \ / __ \|  |   |  \ "
echo -e "  |____|__ (____  /__|___|  /"
echo -e "          \/    \/        \/"
echo -e "  v1.1            eml parser"

if [ "$2" == "" ]
then
  echo -e "  USAGE: $0 [service] [file.eml]\e[0m"
  exit
fi
echo -e "\e[0m"

# -------------------- #
# Outlook
# -------------------- #
if [ "$1" == "outlook" ]
then
  from=$(grep "From: "  $2 | head -n 1 | grep -E -o "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+.[a-zA-Z0-9.-]+\b")
  echo -e "\e[32m[\e[0mFROM\e[32m]\e[0m\t\t\t$from"
  replyto=$(grep "Reply-To: "  $2 | head -n 1 | grep -E -o "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+.[a-zA-Z0-9.-]+\b")
  echo -e "\e[32m[\e[0mReply-To\e[32m]\e[0m\t\t$replyto"
  to=$(grep "To: "  $2 | head -n 1 | grep -E -o "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+.[a-zA-Z0-9.-]+\b")
  echo -e "\e[32m[\e[0mTO\e[32m]\e[0m\t\t\t$to"
  source_ip=$(grep spf $2 | head -n 1 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
  echo -e "\e[32m[\e[0mIP\e[32m]\e[0m\t\t\t$source_ip"
  spf=$(grep spf $2 | cut -d " " -f 2 | cut -d "=" -f 2)
  if [ "$spf" == "pass" ]
  then
    echo -e "\e[32m[\e[0mSPF\e[32m]\t\t\t$spf"
  else
    echo -e "\e[31m[\e[0mSPF\e[31m]\t\t\e[31m$spf\e[0m"
  fi
  dmarc=$(grep dmarc $2 | cut -d ";" -f 2 | cut -d " " -f 1 | cut -d "=" -f 2)
  if [ "$dmarc" == "pass" ]
  then
    echo -e "\e[32m[\e[0mDMARC\e[32m]\t\t\t$dmarc"
  else
    echo -e "\e[31m[\e[0mDMARC\e[31m]\t\t\t\e[31m$dmarc\e[0m"
  fi
  dkim=$(grep dkim $2 | cut -d " " -f 3 | cut -d "=" -f 2)
  if [ "$dkim" == "pass" ]
  then
    echo -e "\e[32m[\e[0mDKIM\e[32m]\t\t\t$dkim"
  else
    echo -e "\e[31m[\e[0mDKIM\e[31m]\t\t\t\e[31m$dkim\e[0m"
  fi
fi

# -------------------- #
# Gmail
# -------------------- #
if [ "$1" == "gmail" ]
then
  from=$(grep "From: " $2 | head -n 1 | grep -E -o "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+.[a-zA-Z0-9.-]+\b")
  echo -e "\e[32m[\e[0mFROM\e[32m]\e[0m\t\t\t$from"
  replyto=$(grep "Received: from" $2 | cut -d " " -f 3)
  echo -e "\e[32m[\e[0mRF\e[32m]\e[0m\t\t$replyto"
  to=$(grep "To: " $2 | head -n 1 | grep -E -o "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+.[a-zA-Z0-9.-]+\b")
  echo -e "\e[32m[\e[0mTO\e[32m]\e[0m\t\t\t$to"
  source_ip=$(grep SPF $2 | head -n 1 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | head -n 1)
  echo -e "\e[32m[\e[0mIP\e[32m]\e[0m\t\t\t$source_ip"
  spf=$(grep spf $2 | cut -d " " -f 8 | head -n 1 | cut -d "=" -f 2)
  if [ "$spf" == "pass" ]
  then
    echo -e "\e[32m[\e[0mSPF\e[32m]\t\t\t$spf"
  else
    echo -e "\e[31m[\e[0mSPF\e[31m]\t\t\e[31m$spf\e[0m"
  fi
  dmarc=$(grep dmarc $2 | head -n 1 | cut -d " " -f 8 | cut -d "=" -f 2)
  if [ "$dmarc" == "pass" ]
  then
    echo -e "\e[32m[\e[0mDMARC\e[32m]\t\t\t$dmarc"
  else
    echo -e "\e[31m[\e[0mDMARC\e[31m]\t\t\t\e[31m$dmarc\e[0m"
  fi
  dkim=$(grep dkim= $2 | head -n 1 | cut -d " " -f 8 | cut -d "=" -f 2)
  if [ "$dkim" == "pass" ]
  then
    echo -e "\e[32m[\e[0mDKIM\e[32m]\t\t\t$dkim"
  else
    echo -e "\e[31m[\e[0mDKIM\e[31m]\t\t\t\e[31m$dkim\e[0m"
  fi
fi



# End
echo -e "\e[0m"
