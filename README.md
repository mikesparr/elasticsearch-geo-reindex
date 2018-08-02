# Elasticsearch Reindex (Geo Point to Geo Shape)
This example demonstrates how to convert records in an index with geo-point mappings 
to and index with geo-shape mappings in Elasticsearch.

## Background
While working on visualizations of data and creating heat maps, I learned that 
you can compare geo shapes with other geo shapes, but not geo point records. In order 
to visualize my data in comparison to, for example, county line shape bounds, I needed 
to get both indexes geo data the same type.

# Requirements
You should have Elasticsearch 6.2.4 or later but this may work for older versions that 
support the reindex API.

# Testing
There is a script, `commands.sh` that shows the curl commands to create mappings for two 
indexes, `test1` and `test2` respectively. It will then insert a geo-point-mapped record in 
`test1` and display it, then reindex and display resulting record in `test2`.

## Extras
I've included the JSON objects for mappings, test record, and reindex object so you can 
execute with any tool you choose (if curl and bash not available)

# Resources
 * https://www.elastic.co/guide/en/elasticsearch/reference/current/geo-shape.html
 * https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-reindex.html
 
Enjoy!
