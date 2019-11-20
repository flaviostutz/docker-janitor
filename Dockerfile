FROM docker:18.05

COPY run.sh /run.sh

VOLUME [ "/var/run/docker.sock" ]

#time between system prune calls in seconds
ENV TIME_BETWEEN_RUNS 86400

#time of unused resources to be pruned
ENV UNUSED_TIME 24h
ENV PRUNE_VOLUMES false
ENV RUN_ON_STARTUP false
ENV HOUR_OF_DAY_START 0
ENV HOUR_OF_DAY_END 23

ENV SKIP_RANDOM_BACKOFF false

CMD [ "/run.sh" ]
