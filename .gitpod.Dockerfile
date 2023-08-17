# docker build --no-cache --progress=plain -f .gitpod.Dockerfile .
FROM gitpod/workspace-full

RUN bash -c "curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip' && unzip awscliv2.zip \
    && sudo ./aws/install \
    && aws --version \

RUN bash -c "brew install terraform"