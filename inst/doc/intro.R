## ---- eval=FALSE--------------------------------------------------------------
#  install.packages("mapsapi")

## ---- eval=FALSE--------------------------------------------------------------
#  install.packages("remotes")
#  remotes::install_github("michaeldorman/mapsapi")

## -----------------------------------------------------------------------------
library(mapsapi)

## ---- eval=FALSE--------------------------------------------------------------
#  key = "AIz....."

## ---- eval=FALSE--------------------------------------------------------------
#  doc = mp_directions(
#    origin = c(34.81127, 31.89277),
#    destination = "Haifa",
#    alternatives = TRUE,
#    key = key,
#    quiet = TRUE
#  )

## -----------------------------------------------------------------------------
library(xml2)
doc = as_xml_document(response_directions_driving)

## -----------------------------------------------------------------------------
r = mp_get_routes(doc)

## -----------------------------------------------------------------------------
r

## -----------------------------------------------------------------------------
library(leaflet)
pal = colorFactor(palette = "Dark2", domain = r$alternative_id)
leaflet() %>% 
  addProviderTiles("CartoDB.DarkMatter") %>%
  addPolylines(data = r, opacity = 1, weight = 7, color = ~pal(alternative_id))

## -----------------------------------------------------------------------------
seg = mp_get_segments(doc)

## -----------------------------------------------------------------------------
head(seg)

## -----------------------------------------------------------------------------
pal = colorFactor(
  palette = sample(colors(), length(unique(seg$segment_id))), 
  domain = seg$segment_id
  )
leaflet(seg) %>% 
  addProviderTiles("CartoDB.DarkMatter") %>%
  addPolylines(opacity = 1, weight = 7, color = ~pal(segment_id), popup = ~instructions)

## -----------------------------------------------------------------------------
locations = c("Tel-Aviv", "Jerusalem", "Beer-Sheva")

## ---- eval=FALSE--------------------------------------------------------------
#  doc = mp_matrix(
#    origins = locations,
#    destinations = locations,
#    key = key,
#    quiet = TRUE
#  )

## -----------------------------------------------------------------------------
doc = as_xml_document(response_matrix)

## -----------------------------------------------------------------------------
m = mp_get_matrix(doc, value = "distance_m")
colnames(m) = locations
rownames(m) = locations
m

## ---- eval=FALSE--------------------------------------------------------------
#  doc = mp_geocode(
#    addresses = "Tel-Aviv",
#    key = key,
#    quiet = TRUE
#  )

## -----------------------------------------------------------------------------
doc = list("Tel-Aviv" = as_xml_document(response_geocode))

## -----------------------------------------------------------------------------
pnt = mp_get_points(doc)
pnt

## -----------------------------------------------------------------------------
leaflet() %>% 
  addProviderTiles("CartoDB.DarkMatter") %>%
  addCircleMarkers(data = pnt)

## -----------------------------------------------------------------------------
bounds = mp_get_bounds(doc)
bounds

## -----------------------------------------------------------------------------
leaflet() %>% 
  addProviderTiles("CartoDB.DarkMatter") %>%  
  addPolygons(data = bounds)

## ---- eval=FALSE--------------------------------------------------------------
#  r = mp_map(center = "31.253205,34.791914", zoom = 14, key = key, quiet = TRUE)

## -----------------------------------------------------------------------------
r = response_map

## ---- eval=FALSE--------------------------------------------------------------
#  library(stars)
#  plot(r)

## ---- echo=FALSE--------------------------------------------------------------
library(stars)
plot(r, useRaster = TRUE)

## -----------------------------------------------------------------------------
library(ggplot2)
cols = attr(r[[1]], "colors")
ggplot() +
  geom_stars(data = r, aes(x = x, y = y, fill = color)) +
  scale_fill_manual(values = cols, guide = FALSE) +
  coord_sf()

