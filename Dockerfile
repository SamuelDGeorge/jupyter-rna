FROM harbor.cyverse.org/vice/jupyter/datascience:3.6.1

USER root

# non-interactive frontend
ENV DEBIAN_FRONTEND noninteractive

# Install and configure jupyter lab.
COPY jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json

# install conda environment
RUN conda config --add channels bioconda && \
    conda config --add channels conda-forge \
    && mamba install ipywidgets jupyterlab_widgets kallisto -y

#intstall fastx
RUN mkdir fastx_bin \
    && wget -O fastx_bin/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2 http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2 \
    && tar -xjf fastx_bin/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2 -C ./fastx_bin \
    && cp fastx_bin/bin/* /usr/local/bin \ 
    && rm -r fastx_bin

# install clang
RUN apt-get update && apt-get install -y clang jq llvm

# Rebuild the Jupyter Lab with new tools
RUN jupyter lab build

USER jovyan

#pull openmp
RUN git clone https://github.com/pdewan/OpenMPTraining.git /home/jovyan/OpenMPTraining

#pull dylan_plugin
RUN git clone https://github.com/dylanjtastet/llvm-instr /home/jovyan/llvm-instr 

#Clone SuperShell and run install script
RUN cd /home/jovyan && \
    git clone -b CyverseLogging-v1.1 https://github.com/pdewan/SuperShell.git  && \
    cd /home/jovyan/SuperShell/DockerSuperShell/SuperShellV2/ && ls && \
    chmod 755 cyverse_install.sh && \
    chmod 755 push_events.sh && \
    ./cyverse_install.sh 
    #cd && source /home/jovyan/.bash_profile

#intstall fastx matching script
RUN mkdir -p /home/jovyan/fastx_full/
COPY fastx_full.sh /home/jovyan/fastx_full/

# Entrypoint is already set in base container, examples retained below:
#
# EXPOSE 8888
# 
# COPY entry.sh /bin
# RUN mkdir -p /home/jovyan/.irods
# 
# ENTRYPOINT ["bash", "/bin/entry.sh"]