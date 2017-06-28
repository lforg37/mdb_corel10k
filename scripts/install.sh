INSTALL_DIR=/local/corel-10k
COREL_URL='http://www.ci.gxnu.edu.cn/cbir/Corel/'

rm -rvf scratch
mkdir scratch
cd scratch

#Getting the JAR for lire indexing
wget https://github.com/dermotte/liresolr/releases/download/v6.3.0-beta.2/lire.jar
wget https://github.com/dermotte/liresolr/releases/download/v6.3.0-beta.2/liresolr.jar
wget http://mirror.softaculous.com/apache/commons/codec/binaries/commons-codec-1.10-bin.zip
unzip commons-codec-1.10-bin.zip
mv commons-codec-1.10/commons-codec-1.10.jar .
rm -r *.zip commons-codec-1.10
SCRATCH_DIR=$PWD

#getting all images
echo "" > "${INSTALL_DIR}/image_list.txt"
for i in $(seq 1 10000)
do
	if test ! -f "${INSTALL_DIR}/${i}.jpg" ; then
		echo "${COREL_URL}${i}.jpg" >> urls.txt
	fi
	echo "${i}.jpg" >> "${INSTALL_DIR}/image_list.txt"
done

wget -i urls.txt -P ${INSTALL_DIR}

cd ${INSTALL_DIR}

#Computing the index
java -cp ${SCRATCH_DIR}/lire.jar:${SCRATCH_DIR}/liresolr.jar:${SCRATCH_DIR}/commons-codec-1.10.jar net.semanticmetadata.lire.solr.indexing.ParallelSolrIndexer -i image_list.txt -o ${SCRATCH_DIR}/index.xml

PING_URL='http://lireserv:8983/solr/admin/ping'

echo "LIRE Index computed"

until test "$(curl -s -o /dev/null -w \"%{http_code}\" ${PING_URL})" = "200"
do
	echo "Solr server not reachable, a new attempt will be made in a few seconds"
	sleep 5
done

cd $SCRATCH_DIR

# Upload the index to Solr
curl http://localhost:8983/solr/lire/update -H "Content-Type: text/xml" --data-binary "<delete><query>*:*</query></delete>"
curl http://localhost:8983/solr/lire/update -H "Content-Type: text/xml" --data-binary @index.xml
curl http://localhost:8983/solr/lire/update -H "Content-Type: text/xml" --data-binary "<commit/>"

