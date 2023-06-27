FROM harbor.cyverse.org/vice/jupyter/datascience:3.6.1

USER root

# Install and configure jupyter lab.
COPY jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json

# install conda environment
RUN conda config --add channels bioconda && \
    conda config --add channels conda-forge \
    && mamba install jupyterlab_widgets \
    && mamba install ipywidgets \
    && mamba install kallisto

#intstall fastx
RUN mkdir fastx_bin \
    && wget -O fastx_bin/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2 http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2 \
    && tar -xjf fastx_bin/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2 -C ./fastx_bin \
    && sudo cp fastx_bin/bin/* /usr/local/bin \ 
    && rm -r fastx_bin

#intstall fastx matching script
COPY fastx_full.sh /bin/fastx_full

# install clang
RUN apt-get update && apt-get install -y clang

#pull openmp
RUN git clone https://github.com/pdewan/OpenMPTraining.git /OpenMPTraining

#pull dylan_plugin
RUN git clone https://github.com/dylanjtastet/llvm-instr /llvm-instr \
    && sudo apt-get install -y llvm

#pull super shell and install
RUN git clone -b CyverseLogging-v1.1 https://github.com/pdewan/SuperShell.git /SuperShellInstall \
    && mv /SuperShellInstall /SuperShell \
    && sudo apt-get install -y jq
COPY linux_install_supershell_docker.sh /SuperShell/linux_install_supershell_docker.sh

# Add sudo to jovyan user
RUN apt update && \
    apt install -y sudo && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

#Set Custom permissions
ENV PATH "$PATH:/home/jovyan/bin"

#Set Permissions 
RUN chmod 777 -R /SuperShell 
    
# Rebuild the Jupyter Lab with new tools
RUN jupyter lab build

USER jovyan
WORKDIR /home/jovyan
EXPOSE 8888

COPY entry.sh /bin
RUN mkdir -p /home/jovyan/.irods

ENTRYPOINT ["bash", "/bin/entry.sh"]
