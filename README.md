# Hierarchical Cluster Analysis using Gower Distance

## Overview

This repository contains R code for performing hierarchical cluster analysis on binary variables using Gower distance and Ward's linkage method. The analysis includes PCA visualization and generates comprehensive cluster summaries with country-specific distributions.

## Description

This script is part of a PhD research project analyzing clustering patterns in binary data across Italy and Austria. The analysis identifies distinct clusters based on rural/urban characteristics, positioning variables, and hybridity levels.

## Author

**Helyaneh Aboutalebi Tabrizi**  
Email: Helyaneh.aboutalebi@polimi.it  
Date: 2025

## Data

The data and results belong to the author and are part of her PhD work. The dataset can be provided upon request by contacting the author.

## Requirements

### R Version
- R >= 4.0.0

### Required R Packages
```r
install.packages(c(
  "readxl",
  "dplyr", 
  "cluster",
  "factoextra",
  "writexl",
  "ggplot2",
  "ggalt",
  "tidyr"
))
```

## Input Data

The script expects an Excel file (`ITA_AUT_Oct_2024.xlsx`) containing the following binary variables:
- `Rural_area`: Rural area indicator
- `P2_second_third_place`: Second-third place positioning
- `P2_fourth_place`: Fourth place positioning  
- `Moderate_hybridity`: Moderate hybridity level
- `Low_hybridity`: Low hybridity level
- `Italy`: Country indicator for Italy
- `Austria`: Country indicator for Austria

## Methodology

### 1. Data Preprocessing
- Converts binary variables to factors
- Selects clustering variables for analysis

### 2. Hierarchical Clustering
- Computes Gower distance matrix for mixed-type data
- Performs hierarchical clustering using Ward's method (ward.D2)
- Cuts dendrogram into 4 clusters

### 3. Visualization
- Principal Component Analysis (PCA) for dimensionality reduction
- Scatter plot with convex hulls showing cluster boundaries
- Color-coded clusters with jittered points

### 4. Cluster Analysis
- Calculates percentage statistics for each clustering variable
- Provides country-specific case counts per cluster
- Generates interpretable cluster descriptions

## Output

### Generated Files
- **Excel file**: `cluster_results_YYYYMMDD.xlsx` containing:
  - Cluster summary statistics
  - Cluster interpretations
  - Full dataset with cluster assignments
  - PCA coordinates

### Console Output
- Cluster analysis results table
- Cluster interpretations
- Session information for reproducibility

## Cluster Interpretations

The analysis identifies four distinct clusters:

1. **Cluster 1**: Highly hybrid second-third place CWS mostly in towns and semi-dense areas with a few in rural areas
2. **Cluster 2**: High to moderately hybrid fourth place CWS in both towns and semi-dense areas and rural areas  
3. **Cluster 3**: Moderately hybrid second-third place and non-third place CWS mostly in towns and semi-dense areas with a few in rural areas
4. **Cluster 4**: Low-hybrid non-third place CWS mostly in towns and semi-dense areas with a few in rural areas

## Usage

1. **Setup**: Ensure all required packages are installed
2. **Data**: Place your Excel data file in the working directory
3. **Configure**: Update the working directory path in the script
4. **Run**: Execute the entire script or run sections individually

```r
# Example usage
source("Cluster_analysis.r")
```

## File Structure

```
├── Cluster_analysis.r          # Main analysis script
├── README.md                   # This file
├── ITA_AUT_Oct_2024.xlsx      # Input data (not included)
└── cluster_results_YYYYMMDD.xlsx # Output results
```

## Key Features

- **Robust Distance Metric**: Uses Gower distance for binary variables
- **Hierarchical Clustering**: Ward's method for optimal cluster formation
- **Visualization**: PCA-based cluster visualization with convex hulls
- **Comprehensive Analysis**: Detailed cluster characteristics and interpretations
- **Export Functionality**: Multi-sheet Excel output for further analysis
- **Reproducibility**: Session information included for transparency

## Technical Notes

- The script uses Ward's linkage method (ward.D2) which minimizes within-cluster variance
- Gower distance is particularly suitable for binary and mixed-type variables
- PCA visualization provides a 2D representation of the multi-dimensional cluster structure
- Jittering is applied to prevent point overlap in visualization

## Citation

If you use this code or methodology in your research, please cite appropriately and contact the author for proper attribution.

## License

This code is provided for academic and research purposes. Please contact the author for permission regarding commercial use or redistribution.

## Contact

For questions, data requests, or collaboration inquiries, please contact:
Helyaneh Aboutalebi Tabrizi - Helyaneh.aboutalebi@polimi.it