folder_path <- "C:/Users/nikhi/Downloads/GLobal temperature"
files <- list.files(path=folder_path,pattern="\\.csv$",full.names=TRUE)

data_list <- lapply(files,read.csv)
merged_data <- dplyr::bind_rows(data_list,.id="source")

# converting dt to proper date type

merged_data$dt <- as.Date(merged_data$dt)

# Checking for the missing values
summary(merged_data)
colSums(is.na(merged_data))

# Removing the rows where average temperature is not mentioned
cleaned_data <- merged_data %>% filter(!is.na(AverageTemperature))

# Removing the duplicates
cleaned_data <- cleaned_data %>% distinct()

# Converting country/city/state to a single religion column
cleaned_data <- cleaned_data %>% mutate(Region = coalesce(Country, City, State))

# Creating different year and month columns for easier plotting
cleaned_data <- cleaned_data %>% mutate(Year = year(dt), Month = month(dt))
