#!/bin/bash
# Today I Learned Bot

# You can add .json to any subreddit URL... 
# You could probably add any subreddit URL to get the text title from top post
URL="https://www.reddit.com/r/todayilearned.json"
CHARLIMIT=280
OVER280="..."

# Get the first /r/todayilearned - save to var
TILTILE=$(curl $URL -A 'random' | jq '.data.children[0].data.title')

# Remove the first and last quote from json returned
# https://stackoverflow.com/questions/9733338/shell-script-remove-first-and-last-quote-from-a-variable
TILTILE="${TILTILE%\"}"
TILTILE="${TILTILE#\"}"

# Get the length of the TIL
TILLEN=${#TILTILE}

# If TIL is bigger than Tweet max length, shorten with an ellipsis 
if (( $TILLEN > 280 )); then
	CHARDELETE=$[TILLEN - (CHARLIMIT - 3)]
	TILTILE=${TILTILE::${#TILTILE}-CHARDELETE}
	TILTILE="${TILTILE}${OVER280}"
fi

# post to twitter api using Tweet.sh
./tweet.sh/tweet.sh post $TILTILE
