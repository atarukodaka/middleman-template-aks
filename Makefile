MM = bundle exec middleman

bld:
	$(MM) build

server:
	$(MM) server --force-polling &

deploy:
	ASSET_HOST=/site $(MM) deploy -b

clean:
	rm -rf build
	rake clean

