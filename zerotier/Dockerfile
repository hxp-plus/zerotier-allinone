FROM fedora:latest
RUN dnf update -y && dnf install -y gcc git make gcc-c++ cargo openssl-devel bind-utils procps-ng
RUN git clone https://github.com/zerotier/ZeroTierOne.git /src \
  && cd /src \
  && make -f make-linux.mk
RUN echo "Installing ZeroTier"
RUN cd /src && make install
COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh
EXPOSE 9993/tcp
EXPOSE 9993/udp
ENTRYPOINT /root/start.sh
