#!/bin/bash
cd /gdal-$GDAL_VERSION/swig/include
sed -i "s/ GetDriver/ OGR_GetDriver/" ogr.i
sed -i "s/ GetDriver/ GDAL_GetDriver/" gdal.i
sed -i "s/wrap_/_gdal_wrap/" gdal.i
sed -i "s/wrap_/_ogr_wrap/" ogr.i

cd /gdal-$GDAL_VERSION/swig/ruby
sed -i "s/Config::CONFIG/RbConfig::CONFIG/" RubyMakefile.mk

make veryclean
VERBOSE=1 \
USER_DEFS="-I/usr/local/include/ruby-2.4.0/x86_64-linux/ -I/usr/include/x86_64-linux-gnu/ruby-2.4.0/ -lgdal -lruby" \
make build