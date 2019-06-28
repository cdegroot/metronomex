
# TODO get these versions dynamically
AMQP_VERSION := 1.2.1
GOLDRUSH_VERSION := 0.1.9
LAGER_VERSION := 3.6.10

all:
	mix deps.get
	mix archive.build
	$(MAKE) ez
	@echo "=== All done. You can copy *.ez plus the elixir-1.8.1.ez in the RabbitMQ plugins directory."
	@echo "=== For a default Linux setup, run 'sudo make install'"

install:
	install -o rabbitmq -g rabbitmq -m 640 *.ez /usr/lib/rabbitmq/plugins

clean:
	rm -rf _build deps *.ez

ez: amqp-${AMQP_VERSION}.ez goldrush-${GOLDRUSH_VERSION}.ez lager-${LAGER_VERSION}.ez

amqp-${AMQP_VERSION}.ez:
	cd deps/amqp; mix do deps.get, archive.build; mv $@ ../..

goldrush-${GOLDRUSH_VERSION}.ez:
	cd deps/goldrush; rebar3 compile; \
		rm -f $@; \
		ln -sf _build/default/lib/goldrush goldrush-${GOLDRUSH_VERSION}; \
		zip -r $@ goldrush-${GOLDRUSH_VERSION}; mv $@ ../..; rm goldrush-${GOLDRUSH_VERSION}

lager-${LAGER_VERSION}.ez:
	cd deps/lager; rebar3 compile; \
		rm -f $@; \
		ln -sf _build/default/lib/lager lager-${LAGER_VERSION}; \
		zip -r $@ lager-${LAGER_VERSION}; mv $@ ../..; rm lager-${LAGER_VERSION}
