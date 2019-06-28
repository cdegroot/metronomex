
# TODO get these versions dynamically
AMQP_VERSION := 1.2.1
GOLDRUSH_VERSION := 0.1.9
LAGER_VERSION := 3.6.10

all:
	mix deps.get
	mix archive.build
	$(MAKE) ez

ez: amqp-${AMQP_VERSION}.ez goldrush-${GOLDRUSH_VERSION}.ez lager-${LAGER_VERSION}.ez


amqp-${AMQP_VERSION}.ez:
	cd deps/amqp; mix archive.build; mv $@ ../..

goldrush-${GOLDRUSH_VERSION}.ez:
	cd deps/goldrush; rebar3 compile; \
		rm -f $@; \
		ln -sf _build/default/lib/goldrush goldrush-${GOLDRUSH-VERSION}; \
		zip -r $@ goldrush-${GOLDRUSH_VERSION}; mv $@ ../..; rm goldrush-${GOLDRUSH_VERSION}

lager-${LAGER_VERSION}.ez:
	cd deps/lager; rebar3 compile; \
		rm -f $@; \
		ln -sf _build/default/lib/lager lager-${LAGER-VERSION}; \
		zip -r $@ lager-${LAGER_VERSION}; mv $@ ../..; rm lager-${LAGER_VERSION}
