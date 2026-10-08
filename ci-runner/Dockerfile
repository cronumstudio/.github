FROM ghcr.io/actions/actions-runner:latest

USER root
# What the suite's workflows expect from ubuntu-latest and the base image lacks.
RUN apt-get update \
 && apt-get install -y --no-install-recommends nodejs wget zstd \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /state /home/runner/_work \
 && chown runner:runner /state /home/runner/_work
COPY --chmod=755 start.sh job-started.sh /usr/local/bin/

USER runner
ENTRYPOINT ["/usr/local/bin/start.sh"]
