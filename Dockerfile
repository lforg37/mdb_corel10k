from alpine
ENV INSTALL_DIR="/install" 
RUN mkdir $INSTALL_DIR
COPY corel-10k.tar.bz2 /corel-10k.tar.bz2
COPY scripts/install.sh install.sh

ENTRYPOINT ["sh", "install.sh"]
