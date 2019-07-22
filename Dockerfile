FROM ubuntu:16.04

ARG NB_USER="michael"
ARG NB_UID="1000"
ARG NB_GID="100"

RUN apt-get update && \
    apt-get install -y tzdata \ 
        build-essential \
        libssl-dev \
        curl \
        python \
        python-pip \
        python-dev \
        pandoc \
        python-software-properties \
        texlive-xetex && \
    ln -fs /usr/share/zoneinfo/Africa/Johannesburg /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs
RUN pip install --upgrade pip
RUN pip install jupyter
RUN npm install -g ijavascript && ijsinstall

WORKDIR /home/jupyter
USER $NB_USER
RUN jupyter notebook --generate-config && \
    echo "c.NotebookApp.ip = '*'" >> .jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.open_browser = False" >> .jupyter/jupyter_notebook_config.py
RUN mkdir -p /home/jupyter/work
RUN chown -R $NB_UID: $NB_GID /home/jupyter/work
WORKDIR /home/jupyter/work
VOLUME /home/jupyter/work
EXPOSE 8888
ENTRYPOINT ["ijs", "--no-browser", "--ip=0.0.0.0", "--notebook-dir=/home/jupyter/work" ]