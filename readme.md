# PARALLEL DASK SETUP

The project consist in a docker image for the dask sheduler and workers and a configuration file for the client sagemaker notebook.
The aim is to mantain same version of dask and all other libraries on the sheduler and workers image spawned on Fargate and the client machine running the notebok.

## DOCKER IMAGE

The docker image is automatically built and pushed to its ECR repository using github actions.
The docker image is hosted in the folder `base-image`.
Python version and dask version are setted in the file `.env_file`.

## LIFECYCLE CONFIGURATION

use the script `./generate_lifecycle_oncreate.sh` to generate the configuration script to be associated to the notebook istance you are creating in sagemaker. The same script with some care/fixes can be used to create a local environment to work with the dask cluster (TBC the network configuration).

In sagemaker in Notebook/Lifecycle configuration create a new configuration with the generated code. Then when a new notebook is created add it in the section "Additional configuration". Remember to configure also network with VPC / SUBNET and Security group (Default ones are ok). 

The lifecycle configuration will add a kerner `conda_amygda_dask`, use it to work with the distributed Fargate cluster.

## TEST NOTEBOOK

Test notebook is herte `./test__dask_distributed.ipynb`, please modify `my_vpc` and `my_subnets` based on the network option chosen when the notebook has been created.


## TODO
- condaforge reference as variable to avoid discrepancies between the docker image and the Lifecycle script
- Check/remove conda update to avoid unwanted misalignements between the image and the lifecycle script



