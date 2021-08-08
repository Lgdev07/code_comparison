FROM hexpm/elixir:1.11.4-erlang-23.2.7.2-alpine-3.13.3 AS base

WORKDIR /code_comparison

RUN mix do local.hex --force, local.rebar --force

RUN apk add npm inotify-tools
