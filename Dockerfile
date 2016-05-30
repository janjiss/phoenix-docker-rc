FROM ubuntu:16.04

MAINTAINER Dainis Lapins <dainis186@gmail.com>

# Elixir requires UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# update and install some software requirements
RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y curl wget git make imagemagick


# install Node.js (>= 5.0.0) and NPM in order to satisfy brunch.io dependencies
# See http://www.phoenixframework.org/docs/installation#section-node-js-5-0-0-
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash
RUN apt-get install -y nodejs

# download and install Erlang package
RUN wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
 && dpkg -i erlang-solutions_1.0_all.deb \
 && apt-get update -y

# install latest elixir package
RUN apt-get install -y elixir erlang-dev erlang-parsetools && rm erlang-solutions_1.0_all.deb

# Install last hex
RUN mix local.hex && mix local.rebar

# install the Phoenix Mix archive
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/1.2-rc/phoenix_new.ez

RUN apt-get autoremove
RUN apt-get autoclean

WORKDIR /code
