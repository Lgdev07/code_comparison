# -----------------
# BASE
# -----------------
FROM hexpm/elixir:1.11.4-erlang-23.2.7.2-alpine-3.13.3 AS base

# RUN apk upgrade --update-cache --available \
#   && apk add build-base curl git tzdata vim wget

# RUN mkdir -p /usr/src/app

# WORKDIR /code_comparison

# RUN mix do local.hex --force, local.rebar --force

# COPY . /code_comparison

# RUN mix do deps.get, deps.compile

# RUN apk add npm inotify-tools

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

# install mix dependencies
COPY mix.exs mix.lock ./
COPY apps/web/mix.exs apps/web/mix.exs
COPY apps/publishing/mix.exs apps/publishing/mix.exs
COPY config config
RUN mix do deps.get, deps.compile --skip-umbrella-children

# install application
COPY . ./
RUN mix compile


# -----------------
# RELEASE
# -----------------
FROM build AS release

# install node dependencies
RUN npm ci --prefix ./apps/web/assets --no-audit

# generate static files
RUN npm run --prefix ./apps/web/assets deploy

# digests and compresses static files
RUN mix phx.digest

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

COPY --from=release /code_comparison/_build/$MIX_ENV/rel/web ./

# start application
CMD ["bin/web", "start"]

