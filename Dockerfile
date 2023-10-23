FROM ubuntu:latest

# Cria o usuário "bilhalvadiego"
RUN useradd -m bilhalvadiego

# Define uma senha para o usuário "bilhalvadiego"
RUN echo 'bilhalvadiego:s3nh4' | chpasswd

# Adiciona o usuário "bilhalvadiego" ao grupo "sudo" para dar permissões de superusuário
RUN usermod -a -G sudo bilhalvadiego


USER root

RUN apt-get update && apt-get install -y wget
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y python3 python3-pip
RUN apt-get install -y tesseract-ocr

# Instala o Jupyter Lab
RUN pip3 install jupyterlab

# Define a porta em que o Jupyter Lab será executado
ENV JUPYTER_PORT 8888

# Expõe a porta
EXPOSE $JUPYTER_PORT

# Instala o OpenJDK 8 para o Spark
RUN apt-get update && apt-get install -y openjdk-8-jdk && \
    update-alternatives --config java && \
    update-alternatives --config javac && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER bilhalvadiego

WORKDIR /home/bilhalvadiego

COPY . /home/bilhalvadiego

COPY requirements.txt .

RUN pip install -r requirements.txt

# COPY . .

# Inicia o Jupyter Lab no contêiner
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--LabApp.token="]