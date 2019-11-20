#!/bin/sh

VOLUMES=""
if [ "$PRUNE_VOLUMES" == "true" ]; then
    VOLUMES="--volumes"
fi

if [ "$RUN_ON_STARTUP" == "true" ]; then
    echo "Running system prune on startup..."
    docker system prune --all $VOLUMES --force --filter until="${UNUSED_TIME}"
fi 

RANDOM_SLEEP_TIME=$((RANDOM % SLEEP_TIME))
if [ "$SKIP_RANDOM_BACKOFF" == "false" ]; then
    echo "Waiting for a random time (${RANDOM_SLEEP_TIME}s) to avoid cluster instances to start to perform the cleanup at the same time..."
    sleep ${RANDOM_SLEEP_TIME}s
fi

while [ : ]
do
    echo "$(date) Calling 'docker system prune --all --force --filter until=${UNUSED_TIME}'..."
    docker system prune --all $VOLUMES --force --filter until="${UNUSED_TIME}"
    echo "$(date) Done"
    sleep ${SLEEP_TIME}
done
