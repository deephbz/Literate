# Use Ubuntu as base image
FROM ubuntu:latest

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gpg \
    xz-utils \
    gcc \
    make \
    && rm -rf /var/lib/apt/lists/*

# Install DMD compiler
RUN curl -fsS https://dlang.org/install.sh | bash -s dmd \
    && ln -s /root/dlang/dmd-*/linux/bin64/dmd /usr/local/bin/dmd \
    && ln -s /root/dlang/dmd-*/linux/bin64/dub /usr/local/bin/dub

# Set working directory
WORKDIR /app

# Copy only dependency files first to leverage Docker cache
COPY dub.sdl ./
COPY lit/markdown/dub.json ./lit/markdown/

# Install dependencies
RUN dub fetch --cache=local

# Copy the rest of the project
COPY . .

# Build the project
RUN make

# Set the entrypoint to the binary
ENTRYPOINT ["/app/bin/lit"]