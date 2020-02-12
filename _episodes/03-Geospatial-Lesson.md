---
title: "Geospatial Data and SSURGO"
output: html_document
source: Rmd
---



#### Motivating Questions:
- What are the common file types in agricultural data?
- What applications do I need to open these files?
- How can I make maps of my yield or application?

#### Objectives with Spatial Data:
- Determine whether data are stored in vector or raster format
- Identify the coordinate system for a dataset
- Talk about when data don't have a projection defined (missing .prj file)
- Determine UTM zone of a dataset
- Reproject the dataset into UTM
- Import geospatial files into your R environment
- Visualize geospatial data with R
- Create geospatial files from lat/long coordinates
- Create an ab-line

#### Keypoints:
- sf is prefereable for data analysis; it is easier to access the dataframe
- Projecting your data in utm is necessary for many of the geometric operations
you perform (e.g. making trial grids and splitting plots into subplot data)
- Different data formats that you are likely to encounter include gpkg, shp
(cpg, dbf, prj, sbn, sbx), geojson, and tif

### Setup

Below are the packages that we will use in this episode.



###Introducing Spatial Data with an Example Using Trial Design Data

####Read in the trial design

Use the function `read_sf()` to bring the dataset into your R environment.
Because we have already set the working directory for this file, we only need to
supply the file name. There are many functions for reading files into the
environment, but this function will create an object of class `sf`. This class
makes accessing spatial data much easier. Much like a data frame, you can access
variables within an `sf` object using the `$` operator, for example
`trial$DISTANCE`. For this and other reasons like the number of spatial
calculations available for `sf` objects, this class is perferred in most situations.


```r
trial <- read_sf("data/trialdesign.gpkg")
```

An `sf` object contains a geometry column. We can see the geometric points for
each polygon.
In geospatial terms, a polygon represents an area of land with distinct
boundaries represented by a series of points.


```r
head(trial$geom)
```

```
## Geometry set for 6 features 
## geometry type:  POLYGON
## dimension:      XY
## bbox:           xmin: -81.97862 ymin: 41.74608 xmax: -81.97743 ymax: 41.74659
## epsg (SRID):    4326
## proj4string:    +proj=longlat +datum=WGS84 +no_defs
## First 5 geometries:
```

```
## POLYGON ((-81.97853 41.74656, -81.97853 41.7463...
```

```
## POLYGON ((-81.97832 41.74657, -81.9783 41.74608...
```

```
## POLYGON ((-81.9781 41.74659, -81.97808 41.74609...
```

```
## POLYGON ((-81.97788 41.74658, -81.97787 41.7460...
```

```
## POLYGON ((-81.97767 41.74658, -81.97765 41.7460...
```

####What is a projection?

Geospatial data has a coordinate reference system (CRS) that projects the map in
a specific location. A projection is a way of making the earth's curved surface fit into something you 
can represent on a flat computer screen. To understand why that matters, take a look
at the difference between [the Mercator projection](https://en.wikipedia.org/wiki/Mercator_projection#/media/File:Mercator_projection_Square.JPG) of the world and the 
[Boggs eumorphic projection](https://en.wikipedia.org/wiki/Boggs_eumorphic_projection#/media/File:Boggs_eumorphic_projection_SW.JPG)

In the Mercator projection, space that doesn't exist is created to make a "flat" map 
and Greenland and Antarctica disproportionately huge. In the Boggs projection, strategic 
slices are cut out of the ocean so that the sizes appear a bit closer to true, but Canada 
and Russia get pinched and Greenland gets bisected. There will always be some compromises 
made in a projection system that converts curved surfaces to flat ones for the same reason 
that it's difficult to make an orange peel lie flat. So the method you select will have an 
effect on your outcome.

####Check the coordinate reference system

Some coordinate reference systems, such as UTM zones, are
measured in meters from a reference point in the zone. Latitude and longitude
represent a different type of CRS, defined in terms of angles across a sphere.
Before combining files
and performing operations on a file, it is important to check the CRS. The
function for this is `st_crs().`


```r
st_crs(trial)
```

```
## Coordinate Reference System:
##   EPSG: 4326 
##   proj4string: "+proj=longlat +datum=WGS84 +no_defs"
```



































