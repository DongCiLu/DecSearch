hostname_master=$HOSTNAME
# hostname_prefix_array=("node-0" "node-1" "node-2" "node-3" "node-4" "node-5" "node-6" "node-7")
hostname_prefix_array=("node-0" "node-1")

sudo chown zlu12 /local
sudo chown zlu12 /mydata

sudo chmod 600 /local/DecSearch/distributed/utils/others/cloud_zlu12_pkey_openssh

for hostname_node in "${hostname_prefix_array[@]}"
do
    ssh -i /local/DecSearch/distributed/utils/others/cloud_zlu12_pkey_openssh ${hostname_master//node-0/$hostname_node} 'sudo -Sv && sh' < /local/DecSearch/distributed/utils/setup_decsearch_remote.sh
done

ssh-copy-id lanterns2.eecs.utk.edu

# scp lanterns2.eecs.utk.edu:/local_scratch/Datasets/graph_datasets/large/* /mydata
scp lanterns2.eecs.utk.edu:/local_scratch/Datasets/graph_datasets/regular/* /mydata
scp -r lanterns2.eecs.utk.edu:/local_scratch/Datasets/graph_datasets/testcases /mydata

sudo apt-get update
sudo apt-get -y install vim ssh gcc g++ build-essential cmake zlib1g-dev git automake  

cd /local
git clone https://github.com/dato-code/PowerGraph.git
cd /local/PowerGraph/apps
mkdir ds_dist
cd /local/PowerGraph/apps/ds_dist
ln -s /local/DecSearch/distributed/build_tree.hpp
ln -s /local/DecSearch/distributed/common.hpp
ln -s /local/DecSearch/distributed/dec_search.hpp
ln -s /local/DecSearch/distributed/ds_dist.cpp
ln -s /local/DecSearch/distributed/query_handler.hpp
ln -s /local/DecSearch/distributed/real_dist.hpp
ln -s /local/DecSearch/distributed/utils/CMakeLists.txt
cd /local/PowerGraph/src/graphlab/engine/
cp /local/DecSearch/distributed/engine/* .

cd /local/PowerGraph
./configure --no_jvm
cp /local/DecSearch/distributed/utils/boost_1_53_0.tar.gz /local/PowerGraph/deps/boost/src/
cp /local/DecSearch/distributed/utils/libevent-2.0.18-stable.tar.gz /local/PowerGraph/deps/event/src/
cd /local/PowerGraph/release/apps/ds_dist/
make -j2

ln -s /mydata /local/PowerGraph/release/apps/ds_dist/datasets
ln -s /local/DecSearch/results /local/PowerGraph/release/apps/ds_dist/results
ln -s /local/DecSearch/distributed/utils/simple_multi.sh /local/PowerGraph/release/apps/ds_dist/simple.sh
ln -s /local/DecSearch/distributed/utils/load.sh /local/PowerGraph/release/apps/ds_dist/load.sh
mkdir binary
mv ds_dist binary/ds_dist_test

rm /local/PowerGraph/release/apps/ds_dist/machines
for hostname_node in "${hostname_prefix_array[@]}"
do
    echo ${hostname_master//node-0/$hostname_node} >> /local/PowerGraph/release/apps/ds_dist/machines
done

cp /local/PowerGraph/release/apps/ds_dist/machines /users/zlu12/machines

echo "You are all set."
