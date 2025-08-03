FROM node:20-bookworm

# Build arguments
ARG TZ=America/Los_Angeles
ARG CLAUDE_CODE_VERSION=latest
ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Set timezone
ENV TZ="$TZ"

# Install system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Basic utilities
    less \
    git \
    curl \
    wget \
    procps \
    sudo \
    zsh \
    unzip \
    jq \
    nano \
    vim \
    # Python development
    python3 \
    python3-pip \
    python3-venv \
    # Build tools
    build-essential \
    make \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Create required directories
RUN mkdir -p /usr/local/share/npm-global \
    /workspace \
    /home/$USERNAME/.claude \
    /home/$USERNAME/.config \
    /commandhistory \
    && chown -R $USERNAME:$USERNAME /usr/local/share /workspace /home/$USERNAME /commandhistory

# Configure npm
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV PATH=$PATH:/usr/local/share/npm-global/bin

# Switch to non-root user for installations
USER $USERNAME

# Install global npm packages
RUN npm install -g \
    @anthropic-ai/claude-code@${CLAUDE_CODE_VERSION} \
    prettier \
    eslint \
    typescript \
    @types/node \
    nodemon \
    npm-check-updates \
    concurrently \
    http-server \
    json-server

# Install Python packages
RUN pip3 install --user \
    requests \
    python-dotenv \
    pytest \
    black \
    flake8 \
    pylint \
    httpie \
    ipython

# Set up Zsh (simplified)
ENV SHELL=/bin/zsh
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Configure bash history persistence
RUN echo "export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" >> ~/.bashrc

# Set environment variables
ENV EDITOR=nano \
    VISUAL=nano \
    DEVCONTAINER=true \
    CLAUDE_CONFIG_DIR=/home/$USERNAME/.claude \
    NODE_OPTIONS="--max-old-space-size=4096"

# Set working directory
WORKDIR /workspace

# Copy initialization scripts (if any)
# COPY --chown=$USERNAME:$USERNAME init-scripts/* /usr/local/bin/

# Switch back to non-root user
USER $USERNAME