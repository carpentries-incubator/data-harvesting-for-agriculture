####Creating Spatial Objects

You may also have the coordinates of a spatial object but not a spatial file.
One example is a boundary file or AB-line for your field. We will use the
AB-line and boundary files later when designing the trials. But for this
example, they are good for displaying how to create a spatial object from
coordinates. 

####AB-line File (reading it in or creating it)

Some of you may have a shapefile of your ab-line, but most of you will have the
two endpoints. This is all you need to make a geospatial object for your ab_line 
in R. First, we define the latitude and longitude of the two points. We will call
these point A and point B.

```{r points }
LongA <- -82.87339
LatA <- 40.84575

LongB <- -82.87329
LatB <- 40.83987
```

`st_linestring()` creates an object of class sf from a matrix.
`rbind(c(LongA, LatA), c(LongB, LatB))` creates a matrix with two rows, one for point A and
one for point B. This object is then piped into the function `st_linestring()` to create 
the `sf` object. Finally, using `st_sf()` and  `st_sfc()` we create a simple feature geometry 
column from the set of geometries in `ab_string`. 

```{r abline }
ab_string <- rbind(c(LongA, LatA), c(LongB, LatB)) %>% st_linestring() 
ab_line <-st_sf(id = 'ab_line', st_sfc(ab_string))
```

Now we must assign the CRS of the line. We know that the coordinates were taken
from an object in WGS84, **Dena - How do we know that?** so we can assign the same 
CRS with `st_crs` and typing
out the correct `crs`. Another way we can do this is by using `crs()`. This
second method is preferred to avoid mistakes when remembering the UTM zone of
multiple files. **Dena: If the second method is preferred, then let's not introduce
the first method, so that the instructions they see lead them to do the right thing.**

```{r ab_lineproj}
st_crs(ab_line) <- st_crs(trial)
st_crs(ab_line)
st_write(ab_line,"abline.gpkg", layer_options = 'OVERWRITE=YES', update = TRUE)
```

Plot the resulting AB-line with the generic plotting function for `sf` objects.

```{r plotabline }
plot(ab_line)
```
