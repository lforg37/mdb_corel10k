from alpine
RUN 	apk --no-cache add wget;\
	mkdir corel-10k ; \
	for i in $(seq 1 10000) ; \
	do echo "http://www.ci.gxnu.edu.cn/cbir/Corel/${i}.jpg" >> urls.txt ; \
	done ;\
	wget -i urls.txt -P corel-10k ;\
	rm urls.txt ;\
	apk del wget

VOLUME /corel-10k
ENTRYPOINT ["true"]
