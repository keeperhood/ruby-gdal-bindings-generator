#!/bin/bash
GDAL_VERSION="1.11.5"
TAG="ruby-gdal:$GDAL_VERSION"
docker build -t $TAG .
DOCKER_CID_FILE="docker.cid"
rm $DOCKER_CID_FILE
docker run --cidfile="$DOCKER_CID_FILE" ruby-gdal:$GDAL_VERSION bash /gen-ruby-bindings.sh
CONTAINER_ID=`cat $DOCKER_CID_FILE`
mkdir -p generated
docker start $CONTAINER_ID
docker cp $CONTAINER_ID:"/gdal-$GDAL_VERSION/swig/ruby/gdal_wrap.cpp" generated/gdal.cpp
docker cp $CONTAINER_ID:"/gdal-$GDAL_VERSION/swig/ruby/ogr_wrap.cpp" generated/ogr.cpp
docker cp $CONTAINER_ID:"/gdal-$GDAL_VERSION/swig/ruby/osr_wrap.cpp" generated/osr.cpp

sed -i "s/ogr_get_driver/get_driver/" generated/ogr.cpp
sed -i "s/gdal_get_driver/get_driver/" generated/gdal.cpp
sed -i '/rb_require("gdal\/osr")/d' generated/ogr.cpp

docker stop $CONTAINER_ID
docker rm $CONTAINER_ID