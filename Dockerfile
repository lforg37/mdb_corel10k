from alpine
ENV INSTALL_DIR="/install" 
RUN 	mkdir $INSTALL_DIR ;\
	apk add --no-cache p7zip
COPY corel-10k.7z /corel-10k.7z
COPY scripts/install.sh install.sh

ENTRYPOINT ["sh", "install.sh"]
