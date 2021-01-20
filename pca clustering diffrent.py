import pandas as pd 
import numpy as np
wine = pd.read_csv("C:/Users/user/Downloads/wine.csv")
wine.describe()
wine.head()

from sklearn.decomposition import PCA
import matplotlib.pyplot as plt
from sklearn.preprocessing import scale 


# Normalizing the numerical data 
wine_normal = scale(wine)

pca = PCA(n_components = 6)
pca_values = pca.fit_transform(wine_normal)


# The amount of variance that each PCA explains is 
var = pca.explained_variance_ratio_
var
pca.components_[0]



# Cumulative variance 
var1 = np.cumsum(np.round(var,decimals = 4)*100)
var1

# Variance plot for PCA components obtained 
plt.plot(var1,color="red")

# plot between PCA1 and PCA2 
x = pca_values[:,0]
y = pca_values[:,1]
z = pca_values[:2:3]
plt.scatter(x,y,z,color=["red","blue"])

from mpl_toolkits.mplot3d import Axes3D
Axes3D.scatter(np.array(x), np.array(y), np.array(z), c=["green","blue","red"])


################### Clustering  ##########################
new_df = pd.DataFrame(pca_values[:,0:4])

from sklearn.cluster import KMeans

kmeans = KMeans(n_clusters = 3)
kmeans.fit(new_df)
kmeans.labels_

from scipy.cluster.hierarchy import linkage 
import scipy.cluster.hierarchy as sch # for creating dendrogram 

type(new_df)
p = np.array(new_df) # converting into numpy array format 
z = linkage(new_df, method="complete",metric="euclidean")
z
plt.figure(figsize=(15, 5));plt.title('Hierarchical Clustering Dendrogram');plt.xlabel('Index');plt.ylabel('Distance')
sch.dendrogram(
    z,
    leaf_rotation=0.,  # rotates the x axis labels
    leaf_font_size=8.,  # font size for the x axis labels
)
plt.show()

# 
hc_average = linkage(new_df, "average")
hc_single = linkage(new_df, "single")

from scipy.cluster.hierarchy import dendrogram
# calculate full dendrogram
plt.figure(figsize=(25, 10))
plt.title('Hierarchical Clustering Dendrogram')
plt.xlabel('sample index')
plt.ylabel('distance')
dendrogram(
  hc_average ,
    leaf_rotation=90.,  # rotates the x axis labels
    leaf_font_size=8.,  # font size for the x axis labels
)
plt.show()

from scipy.cluster.hierarchy import cut_tree
print(cut_tree(hc_average, n_clusters = 2).T)



# Now applying AgglomerativeClustering choosing 3 as clusters from the dendrogram
from	sklearn.cluster	import	AgglomerativeClustering 
h_complete	=	AgglomerativeClustering(n_clusters=3,	linkage='complete',affinity = "euclidean").fit(wine_normal) 
cluster_labels=pd.Series(h_complete.labels_)


cluster = AgglomerativeClustering(n_clusters=5,	linkage='ward',affinity = "euclidean").fit(wine_normal) 
cluster_labels=pd.Series(cluster.labels_)

