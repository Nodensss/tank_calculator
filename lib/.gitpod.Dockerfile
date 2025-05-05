FROM gitpod/workspace-full

RUN sudo apt-get update && \
    sudo apt-get install -y clang cmake unzip xz-utils zip libglu1-mesa

ENV FLUTTER_VERSION=3.22.0
RUN curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz \
    | tar -xJ -C /home/gitpod/ && \
    echo 'export PATH="$PATH:/home/gitpod/flutter/bin"' >> /home/gitpod/.bashrc
