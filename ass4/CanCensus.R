library(cancensus)
library(tidyverse)
library(sf)
library(tongfen)

# read https://cran.r-project.org/web/packages/cancensus/vignettes/cancensus.html

# set_api_key(Your API Code Here, install = TRUE)
options(cancensus.api_key = "Your API Code Here")
###API----
# set_api_key(CensusMapper_b215f7071b8ace0c533b0fd5c**e, install = TRUE) # 
options(cancensus.api_key = "CensusMapper_b215f7071b8ace0c533b0fd5c**e") # 
#######-----

# ######## Not to forget to REMOVEAPI KEY during the presentation :)


# To view available named regions at different levels of Census hierarchy for the 2021 Census (for example)
z <- list_census_regions("CA21")

# Returns a data frame with data only
census_data <- get_census(dataset='CA21', regions=list(CMA="59933"),
                          vectors=c("v_CA21_434","v_CA21_435","v_CA21_440"),
                          level='CSD', use_cache = FALSE, geo_format = NA, quiet = TRUE)

# Returns data and geography as an sf-class data frame
census_data <- get_census(dataset='CA21', regions=list(CMA="59933"),
                          vectors=c("v_CA21_434","v_CA21_435","v_CA21_440"),
                          level='CSD', use_cache = FALSE, geo_format = 'sf', quiet = TRUE)

# Returns a SpatialPolygonsDataFrame object with data and geography
census_data <- get_census(dataset='CA21', regions=list(CMA="59933"),
                          vectors=c("v_CA21_434","v_CA21_435","v_CA21_440"),
                          level='CSD', use_cache = FALSE, geo_format = 'sp', quiet = TRUE)

explore_census_vectors(dataset = "CA21")

##### https://doodles.mountainmath.ca/blog/2020/04/23/census-tract-level-t1ff-tax-data/
vsb_regions <- list(CSD=c("5915022","5915803"),
                    CT=c("9330069.01","9330069.02","9330069.00"))

years=seq(2005,2017)
lico_vectors <- setNames(paste0("v_TX",years,"_551"),paste0("lico_",years))

vancouver_lico <- get_tongfen_census_ct(regions=vsb_regions, vectors=lico_vectors, 
                                        geo_format = "sf",na.rm=FALSE)
vancouver_lico %>%
        pivot_longer(cols=starts_with("lico"), names_pattern = "lico_(\\d+)",
                     names_to = "Year", values_to = "Share") %>%
        mutate(Share=Share/100) %>%
        st_sf() %>%
        ggplot(aes(fill=Share)) +
        geom_sf(size=0.1) +
        scale_fill_viridis_c(option = "magma",labels=scales::percent) +
        facet_wrap("Year") +
        # tax_theme +
        coord_sf(datum=NA) +
        labs(title="Share of people in low income")


vancouver_lico %>%
        mutate(Change=(lico_2017-lico_2005)/100) %>%
        st_sf %>%
        ggplot(aes(fill=Change)) +
        geom_sf(size=0.1) +
        scale_fill_gradient2(labels=scales::percent) +
        # tax_theme +
        coord_sf(datum=NA) +
        labs(title="Change in share of people in low income 2005-2017",
             fill="Percentage\npoint change")
