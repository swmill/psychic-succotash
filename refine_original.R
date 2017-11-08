
# Data Refining script
# Leverage tidyverse library bundle

library(tidyverse)

# Step 0 - Read the CVS dataset and make ready.
refinedata <- read.csv("refine_original.csv", header = TRUE, sep = ",")

# Step 1 - Change company name to all lowercase
refinedata$company <- tolower(refinedata$company)
refinedata$company <- sub(pattern = ".*\\ps$", replacement = "Phillips", x = refinedata$company)
refinedata$company <- sub(pattern = "^ak.*", replacement = "Akzo", x = refinedata$company)
refinedata$company <- sub(pattern = "^u.*", replacement = "Unilever", x = refinedata$company)
refinedata$company <- sub(pattern = "^v.*", replacement = "Van Houten", x = refinedata$company)

# Step 2 - Segment the product code and number

refinedata <- separate(refinedata,col=Product.code...number, c("product_code","product_number"), sep = "-")

# Step 3 - Add product cateegories
refinedata$product_category <- refinedata$product_code

# Transalte product code to actual product
refinedata$product_category <- sub(pattern="p",replacement = "Smartphone", refinedata$product_category)
refinedata$product_category <- sub(pattern="v",replacement = "TV", refinedata$product_category)
refinedata$product_category <- sub(pattern="x",replacement = "Laptop", refinedata$product_category)
refinedata$product_category <- sub(pattern="q",replacement = "Tablet", refinedata$product_category)

# Step 4  Add full address for geo coding
refinedata <- refinedata %>%
    mutate(full_address = paste(address, city, country, sep = "-"))

# Step 5  Define Dummy variables

refinedata <- mutate(refinedata, company_philips = ifelse(company == "Philips", 1, 0))
refinedata <- mutate(refinedata, company_akzo = ifelse(company == "Akzo", 1, 0))
refinedata <- mutate(refinedata, company_van_houten = ifelse(company == "Van Houten", 1, 0))
refinedata <- mutate(refinedata, company_unilever = ifelse(company == "Unilever", 1, 0))
refinedata <- mutate(refinedata, product_smartphone = ifelse(product_category == "Smartphone", 1, 0))
refinedata <- mutate(refinedata, product_tv = ifelse(product_category == "TV", 1, 0))
refinedata <- mutate(refinedata, product_laptop = ifelse(product_category == "Laptop", 1, 0))
refinedata <- mutate(refinedata, product_tablet = ifelse(product_category == "Tablet", 1, 0))

# Step 6 - save new file and Write the outputfile
refine_clean <- refinedata
write.csv(refine_clean,file="refine_clean.csv")



