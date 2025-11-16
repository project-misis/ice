FROM elixir:1.18-alpine AS build

RUN apk add --no-cache build-base git

ENV MIX_ENV=prod \
    LANG=C.UTF-8

WORKDIR /app

COPY mix.exs mix.lock ./
COPY config config

RUN mix local.hex --force \
 && mix local.rebar --force \
 && mix deps.get --only prod \
 && mix deps.compile

COPY lib lib

RUN mix compile
RUN mix release

FROM elixir:1.18-alpine AS runtime

ENV LANG=C.UTF-8 \
    MIX_ENV=prod \
    SHELL=/bin/bash \
    PORT=4000 \
    HOME=/app

WORKDIR /app

COPY --from=build /app/_build/prod/rel/ice ./

EXPOSE 4000

CMD ["bin/ice", "start"]
