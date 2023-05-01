FROM hexpm/elixir:1.11.4-erlang-23.2.7.2-alpine-3.13.3 AS base

WORKDIR /code_comparison

ADD mix.exs ./
RUN mix do local.hex --force, local.rebar --force, deps.get, deps.compile

RUN apk add npm inotify-tools
RUN npm install --prefix assets

# -----------------
# BUILD
# -----------------
FROM base AS build

RUN apk add curl bash git

ARG MIX_ENV=prod
ENV MIX_ENV=$MIX_ENV
COPY . ./

# install application
RUN mix do setup, compile

# -----------------
# RELEASE
# -----------------
FROM build AS release

# generate release executable
RUN mix release

# -----------------
# PRODUCTION
# -----------------
FROM alpine:3.13.3

WORKDIR /code_comparison

ARG MIX_ENV=prod

# install dependencies
RUN apk add ncurses-libs curl

COPY --from=release /code_comparison/_build/$MIX_ENV/rel/code_comparison ./

# start application
CMD ["bin/code_comparison", "start"]