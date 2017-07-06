mkdir /scratch
7z x /corel-10k.7z -o/scratch
i=1
for name in $( find /scratch -name *.jpg)
do
	mv $name $INSTALL_DIR/$i.jpg
	i=$((i + 1))	
done
chmod -R 777 $INSTALL_DIR
exit 0
