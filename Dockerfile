FROM elixir:1.18.3-otp-27-slim AS base

WORKDIR /code_comparison

RUN apt-get update && \
    apt-get install -y npm inotify-tools ca-certificates curl bash git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mix do local.hex --force, local.rebar --force

# -----------------
# BUILD
# -----------------
FROM base AS build

ARG MIX_ENV=prod
ARG SECRET_KEY_BASE=dummy_secret
ENV MIX_ENV=$MIX_ENV
ENV SECRET_KEY_BASE=$SECRET_KEY_BASE

COPY . ./

# install application
RUN mix do deps.get, compile

# -----------------
# RELEASE
# -----------------
FROM build AS release

# Build static assets and digest them
RUN npm install --prefix assets && npm run deploy --prefix assets && mix phx.digest

# generate release executable
RUN mix release

# -----------------
# PRODUCTION
# -----------------
FROM elixir:1.18.3-otp-27-slim AS production

WORKDIR /code_comparison

ARG MIX_ENV=prod

# install dependencies
RUN apt-get update && \
    apt-get install -y ncurses-bin curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=release /code_comparison/_build/$MIX_ENV/rel/code_comparison ./
COPY --from=build /code_comparison/topics ./topics

CMD ["bin/code_comparison", "start"]