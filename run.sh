#!/bin/sh

FIRST_RUN=true

while [ : ]
do
    HOUR_NOW=$(date +"%H")
    if [ "$HOUR_NOW" -ge "$HOUR_OF_DAY_START" ]  && [ "$HOUR_NOW" -le "$HOUR_OF_DAY_END" ]; then

        if [ "$FIRST_RUN" == "true" ]; then

            if [ "$RUN_ON_STARTUP" == "true" ]; then
                echo "Running system prune on startup..."
                docker system prune --all $VOLUMES --force --filter until="${UNUSED_TIME}"
            fi

            RANDOM_SLEEP_TIME=$((RANDOM % TIME_BETWEEN_RUNS))
            if [ "$SKIP_RANDOM_BACKOFF" == "false" ]; then
                echo "Waiting for a random time (${RANDOM_SLEEP_TIME}s) to avoid cluster instances to start to perform the cleanup at the same time..."
                sleep ${RANDOM_SLEEP_TIME}s
            fi

            FIRST_RUN=false
        fi

        echo "$(date) Calling 'docker system prune --all --force --filter until=${UNUSED_TIME}'..."
        docker system prune --all --force --filter "until=${UNUSED_TIME}"

        if [ "$PRUNE_VOLUMES" == "true" ]; then
            echo "$(date) Calling 'docker volume prune --force'..."
            docker volume prune --force
        fi
        
        echo "$(date) Done. Waiting for next run..."
        sleep ${TIME_BETWEEN_RUNS}

    else
        echo "CURRENT HOUR ($HOUR_NOW) IS OUTSIDE WORKING WINDOW"
        sleep 60
    fi

done
