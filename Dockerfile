FROM alanfranz/fpm-within-docker:centos-7

ENV NAME "oauth2_proxy"
ENV VERSION "4.0.0"
ENV ITERATION "1.vortex.el7.centos"

RUN mkdir /pkg
WORKDIR /pkg

# RUN yum install -y epel-release
#RUN yum install -y golang git wget
RUN yum install -y git wget

RUN git clone https://github.com/pusher/${NAME}

WORKDIR /pkg/${NAME}

RUN git checkout v${VERSION}
#RUN go build -v
#RUN strip ${NAME}
RUN wget "https://github.com/pusher/${NAME}/releases/download/v${VERSION}/${NAME}-v${VERSION}.linux-amd64.go1.12.1.tar.gz"
RUN tar xfv *.tar.gz
RUN mv ${NAME}-v${VERSION}.linux-amd64.go1.12.1/${NAME} .
RUN sed -i "s#www-data#nobody#g;s#/usr/local/bin#/usr/bin#g" contrib/oauth2_proxy.service.example

WORKDIR /pkg
RUN cp ${NAME}/${NAME} /usr/bin/
RUN mkdir -p /usr/share/doc/${NAME}-${VERSION}
RUN cp -v ${NAME}/contrib/oauth2_proxy.cfg.example /usr/share/doc/${NAME}-${VERSION}/
RUN cp -v ${NAME}/contrib/oauth2_proxy.service.example /etc/systemd/system/${NAME}.service

RUN sh -c 'fpm -s dir -t rpm --rpm-autoreqprov --rpm-autoreq --rpm-autoprov --license "MIT" --vendor "Vortex RPM" -m "Vortex Maintainers <dev@vortex-rpm.org>" --url "http://vortex-rpm.org" -n ${NAME} -v ${VERSION} --iteration "${ITERATION}" --epoch 1 /usr/bin/${NAME} /usr/share/doc/${NAME}-${VERSION} /etc/systemd/system/${NAME}.service'
