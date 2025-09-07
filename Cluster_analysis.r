# ==============================================================================
# Hierarchical Cluster Analysis using Gower Distance
# ==============================================================================
# Description: This script performs hierarchical clustering on binary variables
# using Gower distance and Ward's linkage method. It includes PCA visualization
# and generates comprehensive cluster summaries.
# Data and results belongs to the author 
# and is the part of her PhD work
# data can be provided upon request
# Author: [Helyaneh Aboutalebi Tabrizi; Email: Helyaneh.aboutalebi@polimi.it]
# Date [2025-24]
# ==============================================================================

# Load required libraries
library(readxl)
library(dplyr)
library(cluster)    # For clustering algorithms
library(factoextra) # For cluster visualization
library(writexl)    # For Excel export
library(ggplot2)
library(ggalt)      # For geom_encircle
library(tidyr)

# ==============================================================================
# Data Loading and Preprocessing
# ==============================================================================

# Set working directory (modify with your actual path)
setwd("/Users/helyaaboutalebi/Desktop/Backup")

# Load dataset
data <- read_excel("ITA_AUT_Oct_2024.xlsx")

# Select clustering variables
clustering_vars <- c("Rural_area", "P2_second_third_place", "P2_fourth_place",
                     "Moderate_hybridity", "Low_hybridity")

data_clustering <- data %>%
  select(all_of(clustering_vars))

# Convert binary columns to factors for Gower distance calculation
data_clustering[clustering_vars] <- lapply(data_clustering[clustering_vars], as.factor)

# ==============================================================================
# Hierarchical Clustering
# ==============================================================================

# Compute Gower distance matrix
gower_dist <- daisy(data_clustering, metric = "gower")

# Perform hierarchical clustering using Ward's method
hclust_result <- hclust(as.dist(gower_dist), method = "ward.D2")

# Cut dendrogram into specified number of clusters
num_clusters <- 4
clusters <- cutree(hclust_result, k = num_clusters)

# Add cluster assignment to main dataset
data$Cluster <- as.factor(clusters)

# ==============================================================================
# PCA Visualization
# ==============================================================================

# Perform PCA for cluster visualization
pca_result <- prcomp(as.matrix(gower_dist), scale. = TRUE)
pca_data <- as.data.frame(pca_result$x[, 1:2])
pca_data$Cluster <- data$Cluster

# Create cluster visualization with convex hulls
cluster_plot <- ggplot(pca_data, aes(x = PC1, y = PC2, color = Cluster, fill = Cluster)) +
  geom_jitter(size = 3, alpha = 0.7, width = 0.3, height = 0.3) +
  geom_encircle(aes(group = Cluster), alpha = 0.2, size = 1, expand = 0.03) +
  labs(
    title = "PCA of Hierarchical Clustering (Gower Distance)",
    x = "Principal Component 1", 
    y = "Principal Component 2"
  ) +
  scale_color_manual(values = c("#E41A1C", "#377EB8", "#4DAF4A", "grey")) +
  scale_fill_manual(values = c("#E41A1C", "#377EB8", "#4DAF4A", "grey")) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, hjust = 0.5),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    legend.text = element_text(size = 12),
    legend.title = element_text(size = 14)
  )

# Display the plot
print(cluster_plot)

# ==============================================================================
# Cluster Summary Analysis
# ==============================================================================

# Function to calculate cluster characteristics
calculate_cluster_summary <- function(cluster_data, cluster_number) {
  """
  Calculate percentage of positive cases for each clustering variable
  
  Args:
    cluster_data: Data frame containing cluster subset
    cluster_number: Numeric cluster identifier
    
  Returns:
    Data frame with cluster summary statistics
  """
  
  get_percentage <- function(column) {
    round(100 * mean(as.numeric(as.character(cluster_data[[column]])) == 1), 1)
  }
  
  summary_stats <- data.frame(
    Cluster = cluster_number,
    Number_of_Cases = nrow(cluster_data),
    Rural_area = paste(get_percentage("Rural_area"), "%"),
    P2_second_third_place = paste(get_percentage("P2_second_third_place"), "%"),
    P2_fourth_place = paste(get_percentage("P2_fourth_place"), "%"),
    Moderate_hybridity = paste(get_percentage("Moderate_hybridity"), "%"),
    Low_hybridity = paste(get_percentage("Low_hybridity"), "%")
  )
  
  return(summary_stats)
}

# Generate summaries for all clusters
cluster_summaries <- bind_rows(
  calculate_cluster_summary(data[data$Cluster == 1, ], 1),
  calculate_cluster_summary(data[data$Cluster == 2, ], 2),
  calculate_cluster_summary(data[data$Cluster == 3, ], 3),
  calculate_cluster_summary(data[data$Cluster == 4, ], 4)
)

# Calculate country distribution within clusters
country_counts <- data %>%
  group_by(Cluster) %>%
  summarise(
    Italy = sum(as.numeric(Italy) == 1, na.rm = TRUE),
    Austria = sum(as.numeric(Austria) == 1, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(Cluster = as.numeric(as.character(Cluster)))

# Combine cluster characteristics with country counts
cluster_summaries_final <- left_join(cluster_summaries, country_counts, by = "Cluster")

# Display results
cat("\n=== CLUSTER ANALYSIS RESULTS ===\n")
print(cluster_summaries_final)

# ==============================================================================
# Cluster Interpretation
# ==============================================================================

cluster_interpretations <- data.frame(
  Cluster = 1:4,
  Description = c(
    "Highly hybrid second-third place CWS mostly in towns and semi-dense areas with a few in rural areas",
    "High to moderately hybrid fourth place CWS in both towns and semi-dense areas and rural areas",
    "Moderately hybrid second-third place and non-third place CWS mostly in towns and semi-dense areas with a few in rural areas",
    "Low-hybrid non-third place CWS mostly in towns and semi-dense areas with a few in rural areas"
  )
)

cat("\n=== CLUSTER INTERPRETATIONS ===\n")
print(cluster_interpretations)

# ==============================================================================
# Export Results
# ==============================================================================

# Export comprehensive results to Excel
output_filename <- paste0("cluster_results_", format(Sys.Date(), "%Y%m%d"), ".xlsx")

write_xlsx(list(
  Cluster_Summary = cluster_summaries_final,
  Cluster_Interpretations = cluster_interpretations,
  Full_Data_with_Clusters = data,
  PCA_Coordinates = pca_data
), output_filename)

cat(paste("\nResults exported to:", output_filename, "\n"))

# ==============================================================================
# Session Information
# ==============================================================================

cat("\n=== SESSION INFORMATION ===\n")
sessionInfo()