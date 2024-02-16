FROM public.ecr.aws/docker/library/python:3.11-slim-bookworm as base

WORKDIR /code

RUN apt-get update \
    && apt-get install -y \
        git \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean 

COPY ./requirements.txt ./requirements.txt

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --upgrade -r requirements.txt

FROM base as devcontainer

RUN apt-get update \
    && apt-get install -y \
        curl \
        git \
        unzip \
        vim \
        wget \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean 

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install --update \
    && echo 'complete -C '/usr/local/bin/aws_completer' aws' >> ~/.bashrc \
    && rm -rf awscliv2.zip ./aws

WORKDIR /workspace

CMD ["tail", "-f", "/dev/null"]
