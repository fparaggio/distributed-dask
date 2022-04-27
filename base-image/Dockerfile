ARG BASE_CONTAINER=condaforge/miniforge3:4.11.0-4
FROM $BASE_CONTAINER

ARG python=3.8
ARG release

SHELL ["/bin/bash", "-c"]

ENV PATH /opt/conda/bin:$PATH
ENV PYTHON_VERSION=3.9
ENV DASK_VERSION=2022.4.0

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