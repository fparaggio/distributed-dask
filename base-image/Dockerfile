ARG BASE_CONTAINER=condaforge/miniforge3:4.12.0-0
FROM $BASE_CONTAINER

ARG python
ARG dask_version

SHELL ["/bin/bash", "-c"]

ENV PATH /opt/conda/bin:$PATH
ENV PYTHON_VERSION=$python
ENV DASK_VERSION=$dask_version

RUN conda update conda
RUN conda install --yes -c conda-forge nomkl cytoolz cmake mamba python=${PYTHON_VERSION} \
    && mamba install --yes -c conda-forge \
    python-blosc \
    cytoolz \
    dask==${DASK_VERSION} \
    lz4 \
    numpy \
    pandas \
    tini==0.18.0 \
    cachey \
    streamz \
    && mamba clean -tipsy \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete \
    && rm -rf /opt/conda/pkgs

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY prepare.sh /usr/bin/prepare.sh

RUN chmod +x /usr/bin/prepare.sh

RUN mkdir /opt/app

ENTRYPOINT ["tini", "-g", "--", "/usr/bin/prepare.sh"]
