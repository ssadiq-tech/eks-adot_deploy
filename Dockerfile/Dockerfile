FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv \
    && python3 -m venv /opt/awscli-env \
    && /opt/awscli-env/bin/pip install awscli \
    && ln -s /opt/awscli-env/bin/aws /usr/local/bin/aws \
    && rm -rf /var/lib/apt/lists/*


# Copy static site and AWS config (optional)
COPY ./site/ /usr/share/nginx/html
COPY ./aws /root/.aws

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

