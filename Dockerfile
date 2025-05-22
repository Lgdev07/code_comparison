FROM elixir:1.18.3-otp-27-slim AS base

WORKDIR /code_comparison

# Install system dependencies first!
RUN apt-get update && \
    apt-get install -y npm inotify-tools ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Now it's safe to run mix commands
RUN mix do local.hex --force, local.rebar --force

# Copy the entire application
COPY . .

# Install Elixir dependencies
RUN mix deps.get

# Install npm dependencies
RUN cd assets && npm install