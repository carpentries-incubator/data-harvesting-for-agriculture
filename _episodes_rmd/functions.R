### These are functions found in the Data Carpentry for Agriculture Workshop

utm_zone <- function(long){
  utm <- (floor((long + 180)/6) %% 60) + 1
  return(utm)
}

st_transform_utm <- function(sfobject){
  utmzone <- utm_zone(mean(st_bbox(sfobject)[c(1,3)]))
  projutm <- as.numeric(paste0("326", utmzone))
  newobj <- st_transform(sfobject, projutm)
  return(newobj)
}

# `long2UTM()` is a function written to take the argument `long` and output the
# result of the equation. `floor()` returns the largest integer that is not
# greater than the input.  The `st_bbox()` function returns the bounding box of
# the dataset, i.e. the four corners defining a rectangle that would contain all
# of the polygons.  By taking the mean of the first and third items returned by
# `st_bbox()`, we get the longitude of the point directly in the center of the box.
# 
# The code below pastes together the full
# ESPG code for any `utmzone` we calculate with `long2UTM`. `paste0()` pastes
# together the two arguments `"326"` and `utmzone` as string. But when we transform
# `trial` into UTM, we only need the ESPG number. So we convert that to numeric with
# `as.numeric()`, giving us a final ESPG of `r paste0("326", utmzone)`.

cent_long <- function(sfobject){
  mean(st_bbox(sfobject)[c(1,3)])
}

cent_lat <- function(sfobject){
  mean(st_bbox(sfobject)[c(2,4)])
}

as.Date.daymetr <- function(daymetdata){
  date <- as.Date(daymetdata$yday, origin = paste0(daymetdata$year-1, "-12-31"))
  return(date)
}

sumprec_by_monthyear <- function(data){
  data %>% dplyr::group_by(month, year) %>% dplyr::summarise(prec_month = sum(prec))
}

avgprec_by_month <- function(data){
  data %>% dplyr::group_by(month) %>% dplyr::summarise(prec_avg = mean(prec_month)) 
}

# conversions 
c_to_f <- function(varc){
  conv_unit(varc, "C", "F") 
}

mm_to_in <- function(varc){
  conv_unit(varc, "mm", "inch") 
}

cm_to_in <- function(varc){
  conv_unit(varc, "cm", "inch") 
}

ha_to_ac <- function(varc){
  conv_unit(varc, "hectare", "acres") 
}

kg_to_lb <- function(varc){
  conv_unit(varc, "kg", "lb") 
}

map_poly <- function(sfobject, variable, name){
  tm_shape(sfobject) + tm_polygons(variable, title = name) +
    tm_layout(legend.outside = TRUE, frame = FALSE) 
}

map_points <- function(sfobject, variable, name){
  tm_shape(sfobject) + tm_dots(variable, title = name) +
    tm_layout(legend.outside = TRUE, frame = FALSE) 
}

wt_mean <- function(property, weights)
{
  # compute thickness weighted mean, but only when we have enough data
  # in that case return NA
  
  # save indices of data that is there
  property.that.is.na <- which( is.na(property) )
  property.that.is.not.na <- which( !is.na(property) )
  
  if( length(property) - length(property.that.is.na) >= 1)
    prop.aggregated <- sum(weights[property.that.is.not.na] * property[property.that.is.not.na], na.rm=TRUE) / sum(weights[property.that.is.not.na], na.rm=TRUE)
  else
    prop.aggregated <- NA
  
  return(prop.aggregated)
}

profile_total <- function(property, thickness)
{
  # compute profile total
  # in that case return NA
  
  # save indices of data that is there
  property.that.is.na <- which( is.na(property) )
  property.that.is.not.na <- which( !is.na(property) )
  
  if( length(property) - length(property.that.is.na) >= 1)
    prop.aggregated <- sum(thickness[property.that.is.not.na] * property[property.that.is.not.na], na.rm=TRUE)
  else
    prop.aggregated <- NA
  
  return(prop.aggregated)
}

# define a function to perfom hz-thickness weighted aggregtion
component_level_aggregation <- function(i)
{
  # horizon thickness is our weighting vector
  hz_thick <- i$hzdepb.r - i$hzdept.r
  
  # compute wt.mean aggregate values
  clay <- wt_mean(i$claytotal.r, hz_thick) 
  silt <- wt_mean(i$silttotal.r, hz_thick)
  sand <- wt_mean(i$sandtotal.r, hz_thick)
  # compute profile sum values
  water_storage <- profile_total(i$awc.r, hz_thick)
  
  # make a new dataframe out of the aggregate values
  d <- data.frame(cokey=unique(i$cokey), clay=clay, silt=silt, sand=sand, water_storage=water_storage)
  
  return(d)
}

mapunit_level_aggregation <- function(i)
{
  # component percentage is our weighting vector
  comppct <- i$comppct.r 
  
  # wt. mean by component percent
  clay <- wt_mean(i$clay, comppct)
  silt <- wt_mean(i$silt, comppct)
  sand <- wt_mean(i$sand, comppct)
  water_storage <- wt_mean(i$water_storage, comppct)
  
  # make a new dataframe out of the aggregate values
  d <- data.frame(mukey=unique(i$mukey), clay=clay, silt=silt, sand=sand, water_storage=water_storage)
  
  return(d)
}

###############################################
# using these functions on my data
c_s_s_soil <- function(ssurgo){
  
  chorizon<-ssurgo$tabular$chorizon
  
  component<-ssurgo$tabular$component 
  
  # aggregate horizon data to the component level
  chorizon.agg <- ddply(chorizon, .(cokey), .fun=component_level_aggregation, .progress='text')
  
  # join up the aggregate chorizon data to the component table
  comp.merged <- merge(component, chorizon.agg, by='cokey')
  
  # aggregate component data to the map unit level
  component.agg <- ddply(comp.merged, .(mukey), .fun=mapunit_level_aggregation, .progress='text')
  
  # save data to the ssurgo shapefile
  spatial <- as(ssurgo$spatial, "sf")
  spatial <- dplyr::rename(spatial, mukey = MUKEY)
  spatial <- merge.data.frame(spatial, component.agg, by="mukey")
  spatial <- spatial[,-5]
  spatial <- dplyr::distinct(spatial)
  #spatial <- spatial[,6:9]
  return(spatial)
}

make_abline <- function(LongA,LongB,LatA,LatB,projutm){
  ab_string <- rbind(c(LongA, LatA),c(LongB, LatB)) %>% 
    st_linestring()  
  ab_line <-st_sf(
    id='ab_line',
    st_sfc(ab_string)
  ) 
  st_crs(ab_line) <- '+proj=longlat +datum=WGS84 +no_defs' 
  ab_line <- st_transform(ab_line,projutm)
  return(ab_line)
}

make_grids <- function(bothfields,ab_line,long_in,short_in,starting_point){
  
  #===================================
  # Define the long and short vectors
  #===================================
  ab_1 <- st_geometry(ab_line)[[1]][1,]
  ab_2 <- st_geometry(ab_line)[[1]][2,]
  
  #--------------------------
  # find the origin, end point, and the rotation matrix
  #--------------------------
  if (long_in=='SN'){ # if the plot is long in SN direction
    #--- find the origin and end points ---#
    if (ab_1[2]>=ab_2[2]){
      origin <- ab_2
      end_point <- ab_1
    } else{
      origin <- ab_1
      end_point <- ab_2
    }
    #--- find rotation vector ---#
    if (short_in=='WE'){
      rotate_mat <- matrix(c(cos(-3.000*pi/2),sin(-3.000*pi/2),-sin(-3.000*pi/2),cos(-3.000*pi/2)),nrow=2)
    } else{
      rotate_mat <- matrix(c(cos(3.000*pi/2),sin(3.000*pi/2),-sin(3.000*pi/2),cos(3.000*pi/2)),nrow=2)
    }
  } else if (long_in=='NS') {
    #--- find the origin and end points ---#
    if (ab_1[2]>=ab_2[2]){
      origin <- ab_1
      end_point <- ab_2
    } else{
      origin <- ab_2
      end_point <- ab_1
    }
    #--- find rotation vector ---#
    if (short_in=='WE'){
      rotate_mat <- matrix(c(cos(3.000*pi/2),sin(3.000*pi/2),-sin(3.000*pi/2),cos(3.000*pi/2)),nrow=2)
    } else{
      rotate_mat <- matrix(c(cos(-3.000*pi/2),sin(-3.000*pi/2),-sin(-3.000*pi/2),cos(-3.000*pi/2)),nrow=2)
    }
  } else if (long_in=='WE') {
    #--- find the origin and end points ---#
    if (ab_1[1]>=ab_2[1]){
      origin <- ab_2
      end_point <- ab_1
    } else{
      origin <- ab_1
      end_point <- ab_2
    }
    #--- find rotation vector ---#
    if (short_in=='SN'){
      rotate_mat <- matrix(c(cos(-3.000*pi/2),sin(-3.000*pi/2),-sin(-3.000*pi/2),cos(-3.000*pi/2)),nrow=2)
    } else if (short_in=='NS'){
      rotate_mat <- matrix(c(cos(3.000*pi/2),sin(3.000*pi/2),-sin(3.000*pi/2),cos(3.000*pi/2)),nrow=2)
    }
  } else if (long_in=='EW'){
    #--- find the origin and end points ---#
    if (ab_1[1]>=ab_2[1]){
      origin <- ab_1
      end_point <- ab_2
    } else{
      origin <- ab_2
      end_point <- ab_1
    }
    
    #--- find rotation vector ---#
    if (short_in=='SN'){
      rotate_mat <- matrix(c(cos(3.000*pi/2),sin(3.000*pi/2),-sin(3.000*pi/2),cos(3.000*pi/2)),nrow=2)
    } else if (short_in=='NS'){
      rotate_mat <- matrix(c(cos(-3.000*pi/2),sin(-3.000*pi/2),-sin(-3.000*pi/2),cos(-3.000*pi/2)),nrow=2)
    }
  }
  
  #--------------------------
  # Find the long and short vectors
  #--------------------------
  #--- long vector ---#
  long_vec <- end_point-origin 
  
  #--- short vector ---#
  short_vec <- rotate_mat %*% long_vec
  
  #--------------------------
  # normalize the vectors
  #--------------------------
  vector_len <- sqrt(long_vec[1]^2+long_vec[2]^2)
  long_norm <- long_vec/vector_len*plot_length_meter 
  short_norm <- (short_vec/vector_len*plot_width_meter) %>% as.vector()
  
  #===================================
  # Create grids
  #===================================
  
  bbox_field['ymax']-bbox_field['ymin']
  
  
  
  #--- how many rows and columns ---#
  if (long_in %in% c('SN','NS')){
    num_rows <- ceiling((bbox_field['ymax']-bbox_field['ymin'])/plot_length_meter)
    num_cols <- ceiling((bbox_field['xmax']-bbox_field['xmin'])/plot_width_meter) + 1 #want an extra to cover borders.
  } else if (long_in %in% c('WE','EW')){
    num_rows <- ceiling((bbox_field['ymax']-bbox_field['ymin'])/plot_width_meter)
    num_cols <- ceiling((bbox_field['xmax']-bbox_field['xmin'])/plot_length_meter) + 1 #want an extra to cover borders.
  }
  
  #--------------------------
  # Create grids
  #--------------------------
  
  all_polygons_ls <- list()
  if (long_in %in% c('SN','NS')){ # if the applicator moves NS or SN
    if (short_in %in% c('EW')){
      for (i in 1:num_cols){
        #i=1
        if(i==1){
          col_start <- starting_point
        } else{
          col_start <- st_geometry(all_polygons_ls[[i-1]])[[1]][[1]][4,]
        }
        
        col_polygons_ls <- list()
        for (j in 1:num_rows){
          #j=1
          if(j==1){
            point_1 <- col_start
          } else{
            point_1 <- col_polygons_ls[[j-1]][[1]][2,]
          }
          
          point_2 <- point_1+long_norm
          point_3 <- point_2-short_norm
          point_4 <- point_3-long_norm
          
          p_temp <- rbind(point_1,point_2,point_3,point_4,point_1) %>%
            list() %>%
            st_polygon()
          col_polygons_ls[[j]] <- p_temp
        }
        
        
        all_polygons_ls[[i]] <-
          st_sf(
            plotid=(1+(i-1)*num_rows):(i*num_rows),
            GRIDY = (1:num_rows),
            GRIDX = i,
            st_sfc(col_polygons_ls)
          )
      }
    }else{#needs to complete
    }
    
  }else if(long_in %in% c('WE','EW')){ # if the applicator moves WE or EW
    if (short_in %in% c('SN')){
      for (i in 1:num_rows){
        # i=2
        if(i==1){
          col_start <- starting_point
        } else{
          col_start <- st_geometry(all_polygons_ls[[i-1]])[[1]][[1]][2,]
        }
        
        col_polygons_ls <- list()
        for (j in 1:num_cols){
          #j = 2
          if(j==1){
            point_1 <- col_start
          } else{
            point_1 <- col_polygons_ls[[j-1]][[1]][4,]
          }
          point_2 <- point_1+short_norm
          point_3 <- point_2+long_norm
          point_4 <- point_3-short_norm
          
          # point_2 <- point_1+long_norm
          # point_3 <- point_2+short_norm
          # point_4 <- point_3-long_norm
          
          p_temp <- rbind(point_1,point_2,point_3,point_4,point_1) %>%
            list() %>%
            st_polygon()
          col_polygons_ls[[j]] <- p_temp
        }
        
        all_polygons_ls[[i]] <-
          st_sf(
            plotid=(1+(i-1)*num_cols):(i*num_cols),
            GRIDY = i,
            GRIDX = (1:num_cols),
            st_sfc(col_polygons_ls)
          )
      }
    }else if(short_in %in% c('NS')){ 
      for (i in 1:num_rows){
        # i=2
        if(i==1){
          col_start <- starting_point
        } else{
          col_start <- st_geometry(all_polygons_ls[[i-1]])[[1]][[1]][1,]
        }
        
        col_polygons_ls <- list()
        for (j in 1:num_cols){
          #j = 2
          if(j==1){
            point_2 <- col_start
          } else{
            point_2 <- col_polygons_ls[[j-1]][[1]][3,]
          }
          point_1 <- point_2+short_norm
          point_3 <- point_2+long_norm
          point_4 <- point_3+short_norm
          
          # point_2 <- point_1+long_norm
          # point_3 <- point_2+short_norm
          # point_4 <- point_3-long_norm
          
          p_temp <- rbind(point_1,point_2,point_3,point_4,point_1) %>%
            list() %>%
            st_polygon()
          col_polygons_ls[[j]] <- p_temp
        }
        
        all_polygons_ls[[i]] <-
          st_sf(
            plotid=(1+(i-1)*num_cols):(i*num_cols),
            GRIDY = i,
            GRIDX = (1:num_cols),
            st_sfc(col_polygons_ls)
          )
      }
    }
  }
  #--- combine all the grids ---#
  all_grids <- do.call(rbind,all_polygons_ls)
  
  return(all_grids)
}
make_subplots <- function(boundary.utm,ab_line,long_in,short_in,starting_point){
  
  design_grids_utm <- make_grids(boundary.utm,ab_line,long_in,short_in,starting_point)
  st_crs(design_grids_utm) <-st_crs(boundary.utm) #bothfields file came with crs as utm
  
  CentX <- lapply(st_geometry(st_centroid(design_grids_utm)),function(x) x[1]) %>% unlist()
  CentY <- lapply(st_geometry(st_centroid(design_grids_utm)),function(x) x[2]) %>% unlist()
  design_grids_utm <- design_grids_utm %>% 
    mutate(cent_x=CentX,cent_y=CentY)
  
  trial_grid1_utm <- st_intersection(boundary.utm, design_grids_utm)
  trial_grid1_utm$Name <- NULL
  rownames(trial_grid1_utm) <- 1:nrow(trial_grid1_utm)
  
  max_area <- as.numeric(max(st_area(trial_grid1_utm)))
  
  trial_grid2 <- trial_grid1_utm %>%
    mutate(area=as.numeric(st_area(.))) %>%
    mutate(drop=ifelse(area<(max_area-100), 1, 0) )
  
  return(trial_grid2)
}

treat_assign <- function(trial_grid2_intrial,num_treats,seed_treat_rates,nitrogen_treat_rates,seed_quo,nitrogen_quo){
  
  num_plots <- nrow(trial_grid2)
  num_rep <- floor(num_plots/num_treats)
  
  treat_ls <- list()
  for (i in 1:num_rep){
    treat_ls[[i]] <- sample(1:num_treats,num_treats,replace=FALSE) 
  }
  
  remainder_ls <- sample(1:num_treats,num_plots%%num_treats,replace=FALSE) 
  treat_list <- c(unlist(treat_ls),remainder_ls)
  
  trial_grid2$GRIDID <- trial_grid2$plotid
  
  
  grid_list <- trial_grid2 %>%
    .$GRIDID
  
  grid_to_treat <- data.table(GRIDID=grid_list,treat_type=treat_list)
  
  trial_grid3 <-left_join(trial_grid2,grid_to_treat,by='GRIDID') %>%
    mutate(treat_type=ifelse(drop==1,num_treats+1, treat_type)) %>%
    dplyr::select(-area,-drop)
  
  exception <- data.table(
    SEEDRATE=c(seed_quo),
    NRATE=c(nitrogen_quo),
    treat_type=c(num_treats+1)
  )
  
  pair_ls <- expand.grid(seed_treat_rates,nitrogen_treat_rates) %>% 
    data.table() %>% 
    setnames(names(.),c('SEEDRATE','NRATE')) %>% 
    .[,treat_type:=1:num_treats] %>% 
    rbind(exception) %>% 
    dplyr::select(NRATE,SEEDRATE,treat_type)
  
  whole <- left_join(trial_grid3,pair_ls,by='treat_type')
  class(whole)
  
  tm_shape(whole) + tm_polygons("NRATE")
  
  whole_td <- tidy(as(whole, "Spatial")) 
  
  whole_td$new_id <- paste('ID',whole_td$id,sep='')
  whole_td$id <- whole_td$new_id
  whole_td$new_id <- NULL
  
  temp_whole <- whole %>% 
    mutate(id=paste('ID',1:nrow(whole),sep='')) %>% 
    dplyr::select(id,treat_type,NRATE,SEEDRATE)
  
  whole_plot <- left_join(whole_td,temp_whole,by='id') %>% 
    data.table()
  
  return(whole_plot)
}