FROM hexpm/elixir:1.14.0-erlang-25.1-alpine-3.15.6 AS base

WORKDIR /code_comparison

RUN mix do local.hex --force, local.rebar --force

RUN apk add npm inotify-tools

# -----------------
# BUILD
# -----------------
FROM base AS build

RUN apk add curl bash git

ARG MIX_ENV=prod
ENV MIX_ENV=$MIX_ENV
COPY . ./

# install application
RUN mix do deps.get, compile

# -----------------
# RELEASE
# -----------------
FROM build AS release

# digests and compresses static files
RUN mix assets.deploy

# generate release executable
RUN mix release

# -----------------
# PRODUCTION
# -----------------
FROM alpine:3.15.6

WORKDIR /code_comparison

ARG MIX_ENV=prod

# install dependencies
RUN apk add ncurses-libs curl libgcc libstdc++

COPY --from=release /code_comparison/_build/$MIX_ENV/rel/code_comparison ./

# start application
CMD ["bin/code_comparison", "start"]
