#!/bin/sh

echo Use the following code to creaate a LIFECYCLE CONFIGURATION FOR SAGEMAKER or to create a custom environment for working locally.
echo -----
echo -----
if [ -f .env_file ]; then
  export $(echo $(cat .env_file | sed 's/#.*//g'| xargs) | envsubst)
fi
python_nodot=$(echo $python | sed -e 's/\.//g')


echo \#!/bin/bash

echo set -e
echo sudo -u ec2-user -i \<\<\'EOF\'
echo unset SUDO_UID
echo WORKING_DIR=/home/ec2-user/SageMaker/custom-miniconda
echo mkdir -p \"\$WORKING_DIR\"
echo wget https://github.com/conda-forge/miniforge/releases/download/4.12.0-0/Miniforge3-4.12.0-0-Linux-x86_64.sh -O \"\$WORKING_DIR/miniconda.sh\"
# echo wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.11.0-Linux-x86_64.sh -O \"\$WORKING_DIR/miniconda.sh\"
echo bash \"\$WORKING_DIR/miniconda.sh\" -b -u -p \"\$WORKING_DIR/miniconda\"
echo rm -rf \"\$WORKING_DIR/miniconda.sh\"
# Create a custom conda environment
echo source \"\$WORKING_DIR/miniconda/bin/activate\"
echo KERNEL_NAME=\"amygda_dask\"
echo PYTHON=\"$python\"
echo conda create --yes --name \"\$KERNEL_NAME\" python=\"\$PYTHON\"
echo conda activate \"\$KERNEL_NAME\"
echo pip install --quiet ipykernel
# Customize these lines as necessary to install the required packages
echo conda install --yes -c conda-forge nomkl cytoolz cmake mamba python=$python
echo mamba install --yes -c conda-forge python-blosc cytoolz dask==$dask_version lz4 numpy pandas tini==0.18.0 cachey streamz
echo mamba clean -tipsy
file=./base-image/requirements.txt
for line in `cat $file`
do
    echo yes \| pip install "$line"
done
echo EOF
echo ----
echo ----
