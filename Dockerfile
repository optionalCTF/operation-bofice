FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# system dependencies
RUN apt-get update && apt-get install -y \
    curl wget gnupg2 software-properties-common apt-transport-https \
    git unzip build-essential clang lldb lld \
    nasm yasm \
    libssl-dev libcurl4-openssl-dev libelf-dev \
    ca-certificates sudo libicu-dev \
    g++-mingw-w64-x86-64 gcc-mingw-w64-x86-64 \
    && rm -rf /var/lib/apt/lists/*

# opt user
RUN useradd -m opt \
    && echo "opt ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER opt
WORKDIR /home/opt

# install .NET
RUN curl -fsSL https://builds.dotnet.microsoft.com/dotnet/scripts/v1/dotnet-install.sh -o dotnet-install.sh \
    && chmod +x dotnet-install.sh \
    && ./dotnet-install.sh --channel STS \
    && rm dotnet-install.sh

ENV PATH="/home/opt/.dotnet:${PATH}"

# install Go
ENV GO_VERSION=1.22.4
RUN wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -O go.tar.gz \
    && rm -rf /home/opt/go /home/opt/.go \
    && tar -C /home/opt -xzf go.tar.gz \
    && rm go.tar.gz

ENV GOROOT=/home/opt/go
ENV GOPATH=/home/opt/.go
ENV PATH="${GOROOT}/bin:${GOPATH}/bin:${PATH}"

# install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# install extensions
RUN code-server --install-extension vadimcn.vscode-lldb \
    && code-server --install-extension usernamehw.errorlens \
    && code-server --install-extension muhammad-sammy.csharp \
    && code-server --install-extension 13xforever.language-x86-64-assembly \
    && code-server --install-extension llvm-vs-code-extensions.vscode-clangd \
    && code-server --install-extension arcticicestudio.nord-visual-studio-code \
    && code-server --install-extension golang.Go

# configure code-server preferences
RUN mkdir -p /home/opt/.local/share/code-server/User \
    && printf '%s\n' \
    '{' \
    '  "workbench.colorTheme": "Nord",' \
    '  "telemetry.telemetryLevel": "off",' \
    '  "terminal.integrated.defaultProfile.linux": "bash",' \
    '  "terminal.integrated.profiles.linux": {' \
    '    "bash": {' \
    '      "path": "/bin/bash"' \
    '    }' \
    '  },' \
    '  "editor.fontSize": 16,' \
    '  "terminal.integrated.fontSize": 16' \
    '}' > /home/opt/.local/share/code-server/User/settings.json \
    && chown -R opt:opt /home/opt/.local

EXPOSE 8080
ENTRYPOINT ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none", "--disable-telemetry"]