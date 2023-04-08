FROM hexpm/elixir:1.13.0-erlang-23.3.4.10-alpine-3.14.3 AS base

RUN mkdir /code_comparison
WORKDIR /code_comparison

# Cache elixir deps
ADD mix.exs ./
RUN mix do local.hex --force, local.rebar --force, deps.get, deps.compile, tailwind.install

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
FROM alpine:3.14.3

WORKDIR /code_comparison

ARG MIX_ENV=prod

# install dependencies
RUN apk add ncurses-libs curl

COPY --from=release /code_comparison/_build/$MIX_ENV/rel/code_comparison ./

# start application
CMD ["bin/code_comparison", "start"]
