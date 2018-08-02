#! /usr/bin/env bash

echo 'Creating geo-point text index mapping...'
curl -XPUT -H "Content-type: application/json" localhost:9200/test1 -d '{
  "mappings": {
    "doc": {
      "properties": {
        "location": {
          "type": "geo_point"
        }
      }
    }
  }
}'

echo 'Creating geo-shape test index mapping...'
curl -XPUT -H "Content-type: application/json" localhost:9200/test2 -d '{
  "mappings": {
    "doc": {
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

echo 'Creating test record with geo-point location...'
curl -XPOST -H "Content-type: application/json" localhost:9200/test1/doc -d '{
    "city": "Missoula",
    "state": "MT",
    "location": {
        "lat": 46.872,
        "lon": -113.994
    }
}'

echo 'Confirming record exists in test1 index...'
curl localhost:9200/_search?q=Missoula&pretty=true

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

echo 'Confirming new record exists in test2 index...'
curl localhost:9200/test2/_search?q=Missoula&pretty=true

echo 'Cleaning up ...'
curl -XDELETE localhost:9200/test1
curl -XDELETE localhost:9200/test2

echo 'All done...'
exit 0
