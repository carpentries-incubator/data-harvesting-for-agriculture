---
title: "Geospatial Data and SSURGO"
output: html_document
source: Rmd
---

<!-- #knitr::opts_chunk$set(echo = TRUE, fig.path='../figure/') -->




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

<!-- ```{r, message=FALSE, warning=FALSE, include=FALSE}
#library(sf)
#library(fasterize)
#library(gstat)
#library(raster)
#library(rjson)
#library(httr)
#library(rgdal)
#library(rgeos)
#library(maptools)
#library(knitr)
#library(tmap)
#library(ggplot2)
#library(gridExtra)
#library(grid)
#library(FedData)
#library(plyr)
```
-->


```r
x = c(2:11)
y = c(43:52)
plot(x~y)
```

![plot of chunk unnamed-chunk-1](../fig/unnamed-chunk-1-1.png)


### Introducing Spatial Data with SSURGO data

#### What is a CRS?

Geospatial data has a coordinate reference system (CRS) that reports how the map is projected and what point is used as a reference. A projection is a way of making the earth's curved surface fit into something you 
can represent on a flat computer screen. The point used for reference during projection is called a datum.

## Importance of Projections
To understand why projection matters, take a look
at the difference between [the Mercator projection](https://en.wikipedia.org/wiki/Mercator_projection#/media/File:Mercator_projection_Square.JPG) of the world and the 
[Boggs eumorphic projection](https://en.wikipedia.org/wiki/Boggs_eumorphic_projection#/media/File:Boggs_eumorphic_projection_SW.JPG)

In the Mercator projection, space that doesn't exist is created to make a "flat" map 
and Greenland and Antarctica disproportionately huge. In the Boggs projection, strategic 
slices are cut out of the ocean so that the sizes appear a bit closer to true, but Canada 
and Russia get pinched and Greenland gets bisected. There will always be some compromises 
made in a projection system that converts curved surfaces to flat ones for the same reason 
that it's difficult to make an orange peel lie flat. So the method you select will have an 
effect on your outcome.

#### Reading in the Boundary File

Before we can look at a CRS in R, we need to have a geospatial file in the R environment. We will bring in the field boundary. Use the function `read_sf()` to bring the dataset into your R environment.
Because we have already set the working directory for this file, we only need to
supply the file name. 


```r
boundary <- read_sf("data/boundary_transformed.gpkg")
```

```
## Error in read_sf("data/boundary_transformed.gpkg"): could not find function "read_sf"
```

There are many functions for reading files into the
environment, but `read_sf()` creates an object of class `sf` or simple feature. This class
makes accessing spatial data much easier. Much like a data frame, you can access
variables within an `sf` object using the `$` operator. For this and other reasons like the number of spatial
calculations available for `sf` objects, this class is perferred in most situations.

#### Check the coordinate reference system

The function for retreiving the CRS of a simple feature is `st_crs().` Generally it is good practice to know the CRS of your files, but before combining files and performing operations on geospatial data, it is particularly important. Some commands will not work if the data is in the wrong CRS or if two dataframes are in different CRSs.


```r
st_crs(boundary)
```

```
## Error in st_crs(boundary): could not find function "st_crs"
```
The boundary file is projected in longitude and latitude using the WGS84 datum. This will be CRS of most of the data you see. 


Sometimes when looking at a shapefile, the .prj file can be lost. Then `st_crs()` will return empty, but `sf` objects contain a geometry column. We can see the geometric points for the vertices of
each polygon or the points in the data.


```r
head(boundary$geom)
```

```
## Error in head(boundary$geom): object 'boundary' not found
```

The trial design is in lat/long using WGS84. 

## UTM Zones

Some coordinate reference systems, such as UTM zones, are measured in meters. Latitude and longitude represent a different type of CRS, defined in terms of angles across a sphere. If we want to create measures of distance, we need the trial design in UTM. But there are many UTM zones, so we must determine the zone of the trial area. 

The UTM system divides the surface of Earth between 80°S and 84°N latitude into
60 zones, each 6° of longitude in width. Zone 1 covers longitude 180° to 174° W;
zone numbering increases eastward to zone 60 that covers longitude 174 to 180
East. 

#### st_transform and ESPG Codes

For reprojecting spatial data, the function `st_transform()` uses an ESPG code to transform a simple feature to the new CRS. EPSG Geodetic Parameter Dataset is a public registry of spatial reference systems, Earth ellipsoids, coordinate transformations and related units of measurement. The ESPG is one way to assign or transform the CRS in R. 

The ESPG for UTM always begins with "326" and the last numbers are the number of the zone. The ESPG for WGS84 is 4326. This is the projection your equipment reads, so any trial design  files will need to be transformed back into WGS84 before you implement the trial. Also, all files from your machinery, such as yield, as-applied, and as-planted, will be reported in latitude and longitude with WGS84.

#### Transforming

The function `st_transform_utm()` transforms a simple feature into a new CRS. This function is in the functions.R script, and is described there.

```r
boundaryutm <- st_transform_utm(boundary)
```

```
## Error in st_transform_utm(boundary): could not find function "st_transform_utm"
```

```r
st_crs(boundaryutm)
```

```
## Error in st_crs(boundaryutm): could not find function "st_crs"
```

**Exercise**
1. Bring the file called "asplanted_transformed.gpkg" in your environment. Name
the object `planting`. This file contains the planting information for 2017.
2. Identify the CRS of the object. 
3. Look at the geometry features. What kind of geometric features are in this dataset?
4. Transform the file to UTM or Lat/Long, depending on the current CRS.

**Solution**


```r
planting <- read_sf("data/asplanted_transformed.gpkg")
```

```
## Error in read_sf("data/asplanted_transformed.gpkg"): could not find function "read_sf"
```

```r
st_crs(planting)
```

```
## Error in st_crs(planting): could not find function "st_crs"
```

```r
planting$geom
```

```
## Error in eval(expr, envir, enclos): object 'planting' not found
```

```r
plantingutm <- st_transform_utm(planting)
```

```
## Error in st_transform_utm(planting): could not find function "st_transform_utm"
```

```r
st_crs(plantingutm)
```

```
## Error in st_crs(plantingutm): could not find function "st_crs"
```






















