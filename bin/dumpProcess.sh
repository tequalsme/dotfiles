PID=${1}
DIR=${2}

echo "Dumping heap histogram to ${DIR}/jmap-histo"
/usr/java/default/bin/jmap -J-Xmx1024m -histo ${PID} > ${DIR}/jmap-histo

echo "Dumping heap summary to ${DIR}/jmap-summary"
/usr/java/default/bin/jmap -J-Xmx1024m -heap ${PID} > ${DIR}/jmap-summary

echo "Dumping heap to ${DIR}/jmap-dump"
/usr/java/default/bin/jmap -J-Xmx1024m -dump:live,format=b,file=${DIR}/jmap-dump ${PID}

echo "Dumping threads to ${DIR}/jstack"
/usr/java/default/bin/jstack ${PID} > ${DIR}/jstack
