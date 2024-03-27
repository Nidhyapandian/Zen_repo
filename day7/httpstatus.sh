#!/bin/bash

read -p "Enter the Website url:" URL

http_code=$(curl --write-out %{http_code} --silent --output /dev/null $URL)


if [ $http_code -eq 200 ]

then
        echo "success"
else
        echo "Connection failure"
fi
~
~
~

