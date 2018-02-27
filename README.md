# Decentralized search on power-law graphs.
Decentralized search based on landmarks for fast shortest path approximation in large-scale power-law graphs.
Implemented on Powergraph, a distributed graph processing platform.


## System Overview:
The algorithm contains two phases, an offline preprocessing phase which builds landmark indices and an online query phase which performs decentralized search on the preprocessed indices.
![alt text](./example/system_overview.png?raw=true "System Overview")     

## Generate Indices:
Indices used in our system consist of several landmarks and a shortest path tree from each landmark. It is later used by decentralized search as distance estimates between arbitrary vertex pairs. To make the search works more efficiently, we want to construct the shortest path tree in a way that the distance estimates for average case is more accurate. Our idea is to index shortest pathes with higher "path degree". 

### The intuition:
<img src="./examples/landmark_intuitive.png" width="900px"/>

![alt text](./example/landmark_intuitive.png?raw=true "Shortest Path Tree Indexing Intuition")   

### Index construction based on "path degree":
![alt text](./example/index_construction.png?raw=true "Index Construction Algorithm")   

## Search Algorithm
When performing decentralized search on landmark based indices, the search at each step only examine its neighbor and make the decision on distance estimates to the target. The search terminates once it reaches any vertex on the indexed shortest path to the target vertex.
![alt text](./example/search.png?raw=true "Index Guided decentralized search")   

## Performance
### Accuracy
![alt text](./example/accuracy.png?raw=true "Performance (accuracy)")   
### Throughput
![alt text](./example/throughput.png?raw=true "Performance (throughput)")   
