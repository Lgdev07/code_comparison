# Using hexpm/elixir:1.11.4-erlang-23.2.7.2-alpine-3.13.3 as the base image
FROM hexpm/elixir:1.11.4-erlang-23.2.7.2-alpine-3.13.3 AS base

# Set the working directory in the container
WORKDIR /code_comparison

# Install system dependencies
# npm is needed for asset building.
# inotify-tools is often for development (auto-reload), might not be strictly needed for a prod build,
# but keeping it as per original Dockerfile's intent for now.
RUN apk add --no-cache npm inotify-tools

# Set environment variables for production
ENV MIX_ENV=prod
ENV PORT=4000

# Copy the entire application source code into the working directory
# This includes the 'topics/' directory, mix files, config, lib, assets, etc.
COPY . .

# Install Elixir dependencies
# --force is used to ensure local hex and rebar are up-to-date
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get --only prod && \
    mix deps.compile

# Build frontend assets
# This assumes your assets/package.json has a "deploy" script.
# If not, you might use "build" or a direct webpack command.
# The --prefix flag tells npm to run the command in the ./assets directory.
RUN npm install --prefix ./assets && \
    npm run deploy --prefix ./assets
    # A common alternative if 'deploy' script is not set up:
    # npm run --prefix ./assets build
    # or direct webpack:
    # ./assets/node_modules/.bin/webpack --mode production --config ./assets/webpack.config.js

# Compile the Phoenix application and digest assets
# phx.digest prepares static assets (CSS, JS, images) for production.
RUN mix phx.digest && \
    mix compile

# Expose the port the application will run on
EXPOSE ${PORT}

# Command to run the application
# For production, `mix release` is generally recommended.
# However, `mix phx.server` is simpler and can be used if that's the current deployment strategy.
CMD ["mix", "phx.server"]
