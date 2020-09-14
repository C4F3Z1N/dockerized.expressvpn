ARG TAG="stable-slim"
FROM debian:${TAG}

ARG DEBIAN_FRONTEND="noninteractive"

VOLUME ["/var/cache/apt", "/var/lib/apt/lists"]
RUN apt-get update --fix-missing && \
	apt-get install -fy --no-install-recommends \
		ca-certificates \
		dtach \
		expect \
		iproute2 \
		libnm0 \
		locales-all \
		procps \
		runit \
		tini \
		wget

ARG APP_URL="https://download.expressvpn.xyz/clients/linux/expressvpn_2.6.3.3-1_amd64.deb"
ADD ${APP_URL} /tmp/pkg.deb
RUN apt-get install -fy --no-install-recommends /tmp/pkg.deb

ARG PWD="/opt/services"
WORKDIR ${PWD}
ADD services .
RUN find . -name "run" | xargs chmod -v a+x

ENTRYPOINT ["tini", "--"]
CMD ["runsvdir", "."]

ENV ACTIVATION_CODE=""
ENV SERVER=""

HEALTHCHECK --interval=1m --timeout=5s --start-period=1m \
	CMD wget -qO - "https://expressvpn.com/what-is-my-ip" | \
		grep -q "Your IP address is secured.")
