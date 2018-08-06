#! /usr/bin/env bash

echo 'Creating geo-point text index mapping...'
curl -XPUT -H "Content-type: application/json" localhost:9200/test1 -d '{
  "mappings": {
    "_doc": {
      "properties": {
        "location": {
          "type": "geo_point"
        }
      }
    }
  }
}'

sleep .5

echo 'Creating geo-shape test index mapping...'
curl -XPUT -H "Content-type: application/json" localhost:9200/test2 -d '{
  "mappings": {
    "_doc": {
      "properties": {
        "location": {
          "type": "geo_shape",
          "tree": "quadtree",
          "precision": "50m"
        }
      } 
    }
  }
}'

sleep .5

echo 'Creating test record with geo-point location...'
curl -XPOST -H "Content-type: application/json" localhost:9200/test1/_doc -d '{
    "city": "Missoula",
    "state": "MT",
    "location": {
        "lat": 46.872,
        "lon": -113.994
    }
}'

sleep 1

echo 'Confirming record exists in test1 index...'
DOC_ORIG=$(curl -s 'localhost:9200/_search?q=Missoula&pretty=true' 2>/dev/null)
echo "$DOC_ORIG"
echo $2

sleep .5

echo 'Reindexing test1 to test2 and converting to geo-shape...'
curl -XPOST -H "Content-type: application/json" localhost:9200/_reindex -d '{
    "source": {
        "index": "test1"
    },
    "dest": {
        "index": "test2"
    },
    "script": {
        "source": "ctx._source.location.type = \"point\"; ctx._source.location.coordinates = [ctx._source.location.lon, ctx._source.location.lat]; ctx._source.location.remove(\"lat\"); ctx._source.location.remove(\"lon\")"
    }
}'

sleep 1

echo 'Confirming new record exists in test2 index...'
DOC_NEW=$(curl -s 'localhost:9200/test2/_search?q=Missoula&pretty=true' 2>/dev/null)
echo "$DOC_NEW"
echo $2

sleep .5

echo 'Cleaning up ...'
curl -XDELETE localhost:9200/test1
curl -XDELETE localhost:9200/test2

echo 'All done...'
exit 0
