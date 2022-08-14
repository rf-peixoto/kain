#!/bin/bash
echo -e "\e[1;32m   ____  __.      .__"
echo -e "  |    |/ _|____  |__| ____"
echo -e "  |      < \__  \ |  |/    \ "
echo -e "  |    |  \ / __ \|  |   |  \ "
echo -e "  |____|__ (____  /__|___|  /"
echo -e "          \/    \/        \/"
echo -e "  v1.0            eml parser"

if [ "$1" == "" ]
then
  echo -e "  USAGE: $1 [file.eml]\e[0m"
  exit
fi
echo -e "\e[0m"

# ---------------- #
# From:
# ---------------- #
from=$(grep "From: "  $1 | head -n 1 | grep -E -o "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+.[a-zA-Z0-9.-]+\b")
echo -e "\e[32m[\e[0mFROM\e[32m]\e[0m\t\t\t$from"

# ---------------- #
# Reply-To:
# ---------------- #
replyto=$(grep "Reply-To: "  $1 | head -n 1 | grep -E -o "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+.[a-zA-Z0-9.-]+\b")
echo -e "\e[32m[\e[0mReply-To\e[32m]\e[0m\t\t$replyto"

# ---------------- #
# To:
# ---------------- #
to=$(grep "To: "  $1 | head -n 1 | grep -E -o "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+.[a-zA-Z0-9.-]+\b")
echo -e "\e[32m[\e[0mTO\e[32m]\e[0m\t\t\t$to"

# ---------------- #
# Find Sender IP
# ---------------- #
source_ip=$(grep spf $1 | head -n 1 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
echo -e "\e[32m[\e[0mIP\e[32m]\e[0m\t\t\t$source_ip"

# ---------------- #
# Check SPF Test:
# ---------------- #
spf=$(grep spf $1 | cut -d " " -f 2 | cut -d "=" -f 2)
if [ "$spf" == "pass" ]
then
  echo -e "\e[32m[\e[0mSPF\e[32m]\t\t\t$spf"
else
  echo -e "\e[31m[\e[0mSPF\e[31m]\t\t\e[31m$spf\e[0m"
fi

# ---------------- #
# Check DMARC:
# ---------------- #
dmarc=$(grep dmarc $1 | cut -d ";" -f 2 | cut -d " " -f 1 | cut -d "=" -f 2)
if [ "$dmarc" == "pass" ]
then
  echo -e "\e[32m[\e[0mDMARC\e[32m]\t\t\t$dmarc"
else
  echo -e "\e[31m[\e[0mDMARC\e[31m]\t\t\t\e[31m$dmarc\e[0m"
fi

# ---------------- #
# Check DKIM:
# ---------------- #
dkim=$(grep dkim $1 | cut -d " " -f 3 | cut -d "=" -f 2)
if [ "$dkim" == "pass" ]
then
  echo -e "\e[32m[\e[0mDKIM\e[32m]\t\t\t$dkim"
else
  echo -e "\e[31m[\e[0mDKIM\e[31m]\t\t\t\e[31m$dkim\e[0m"
fi

echo -e "\e[0m"
