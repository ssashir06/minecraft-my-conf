#!/bin/sh

set -e

CONTAINER=$1
WAIT_MS=$2
EXPLAIN=$3
shift 3
RUN_COMMAND=$@

show_message() {
    MESSAGE=$1
    if [ -n "$CONTAINER" ]
    then
        docker exec $CONTAINER sh -c "echo \"say $MESSAGE\" > /proc/\$(pgrep -n bedrock_server)/fd/0"
    else
        echo "$MESSAGE"
    fi
}

get_time_string() {
    MS=$(printf "%.0f" "$1")
    if [ $MS -ge 86400000 ]
    then
        TIME="$(echo $MS/86400000 | bc)"
        UNIT="day"
    elif [ $MS -ge 3600000 ]
    then
        TIME="$(echo $MS/3600000 | bc)"
        UNIT="hour"
    elif [ $MS -ge 60000 ]
    then
        TIME="$(echo $MS/60000 | bc)"
        UNIT="minute"
    else
        TIME="$(echo $REMAINING_MS/1000 | bc)"
        UNIT="second"
    fi
    if [ $TIME -gt 1 ]
    then
        UNIT="${UNIT}s"
    fi
    echo "$TIME $UNIT"
}



REMAINING_MS=$WAIT_MS
while [ $(printf "%.0f" $REMAINING_MS) -gt 10000 ]
do
    show_message "WARNING: After $(get_time_string $REMAINING_MS), $EXPLAIN"
    SLEEP_MS=$(echo $REMAINING_MS*0.5 | bc)
    REMAINING_MS=$(echo $REMAINING_MS-$SLEEP_MS | bc)
    sleep $(echo $SLEEP_MS/1000 | bc)
done

while [ $(printf "%.0f" $REMAINING_MS) -gt 0 ]
do
    show_message "$(get_time_string $REMAINING_MS)"
    SLEEP_MS=1000
    REMAINING_MS=$(echo $REMAINING_MS-$SLEEP_MS | bc)
    sleep $(echo $SLEEP_MS/1000 | bc)
done

exec $RUN_COMMAND