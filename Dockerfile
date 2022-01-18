FROM alpine:latest as base

ADD http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz .
RUN tar -xf install-tl-*
RUN apk add perl wget
RUN cd install-tl-* && yes i | ./install-tl
RUN mv /usr/local/texlive/$(find /usr/local/texlive -type d -maxdepth 1 -mindepth 1 -regex '.*/[0-9]*$' | cut -d/ -f5)/* /usr/local/texlive/

ADD https://httpbin.org/uuid force-cache-invalidation
RUN /usr/local/texlive/bin/x86_64-linuxmusl/tlmgr update --all

FROM alpine:latest
MAINTAINER Oliver Ford <dev@ojford.com>

COPY --from=base /usr/local/texlive /usr/local/texlive
ENV INFOPATH "/usr/local/texlive/texmf-dist/doc/info:$INFOPATH"
ENV MANPATH "/usr/local/texlive/texmf-dist/doc/man:$MANPATH"
ENV PATH "/usr/local/texlive/bin/x86_64-linuxmusl:$PATH"
