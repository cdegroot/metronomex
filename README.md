# Metronomex

Roughly, the RabbitMQ [metronome](https://github.com/rabbitmq/rabbitmq-metronome) plugin in Elixir.

The tricky bit of getting an Elixir plugin to work is that you need to build .ez archives of
all the dependencies, including Elixir. Metronomex builds archives for dependencies, while
building one for Elixir is a bit more involved.

## Building .ez files for dependencies

Just run `make ez` and various dirty tricks will be executed to create the needed archives.

## Building an .ez for elixir

Checkout the [Elixir source code](https://github.com/elixir-lang/elixir/). MAKE 100% SURE YOU
HAVE THE SAME OTP VERSION AS YOUR TARGET RABBITMQ INSTALLATION! (or, at least, not a newer
one :-)).

```
git clone git@github.com:elixir-lang/elixir
cd elixir
make
cd lib
ln -s elixir elixir-1.8.1
zip -r elixir-1.8.1.ez elixir-1.8.1/ebin
rm elixir-1.8.1
```

Put the resulting .ez file in your RabbitMQ directory and you're done. On Linux:

```
sudo cp elixir-1.8.1.ez /usr/lib/rabbitmq/plugins
```

## Extra notes

### Logging

I haven't tried Logger yet - don't include it in `:extra_applications` and don't use it.

### RabbitMQ dependencies

Declare `rabbit` and `rabbit_common` as dependencies (see [mix.exs](mix.exs)) so that your
application won't be started until the RabbitMQ server is started.
