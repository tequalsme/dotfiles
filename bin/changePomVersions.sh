find . -name pom.xml -print0 | xargs -0 sed -i 's/${1}/${2}/g'
