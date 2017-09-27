## ---- eval=FALSE---------------------------------------------------------
#  install.packages("devtools")
#  devtools::install_github("michaeldorman/mapsapi")

## ------------------------------------------------------------------------
library(mapsapi)

## ---- eval=FALSE---------------------------------------------------------
#  doc = google_directions(
#    origin = c(34.81127, 31.89277),
#    destination = "Haifa",
#    alternatives = TRUE
#  )

## ------------------------------------------------------------------------
library(xml2)
doc = as_xml_document(response_directions)

## ------------------------------------------------------------------------
r = extract_routes(doc)

## ------------------------------------------------------------------------
r

## ------------------------------------------------------------------------
library(leaflet)
pal = colorFactor(palette = "Dark2", domain = r$alternative_id)
leaflet() %>% 
  addProviderTiles(provider = providers$Stamen.TonerLite) %>% 
  addPolylines(data = r, opacity = 1, weight = 7, color = ~pal(alternative_id))

## ------------------------------------------------------------------------
seg = extract_segments(doc)

## ------------------------------------------------------------------------
head(seg)

## ------------------------------------------------------------------------
pal = colorFactor(palette = sample(colors(), length(unique(seg$segment_id))), domain = seg$segment_id)
leaflet(seg) %>% 
  addProviderTiles(provider = providers$Stamen.TonerLite) %>% 
  addPolylines(opacity = 1, weight = 7, color = ~pal(segment_id), popup = ~instructions)

## ------------------------------------------------------------------------
locations = c("Tel-Aviv", "Jerusalem", "Beer-Sheva")

## ---- eval = FALSE-------------------------------------------------------
#  doc = google_matrix(
#    origins = locations,
#    destinations = locations
#  )

## ------------------------------------------------------------------------
doc = as_xml_document(response_matrix)

## ------------------------------------------------------------------------
m = extract_matrix(doc, value = "distance_m")
colnames(m) = locations
rownames(m) = locations
m

