MM = bundle exec middleman

bld:
	$(MM) build

server:
	$(MM) server --force-polling &

deploy:
	ASSET_HOST=/site $(MM) deploy -b

webrick:
	ruby server.rb >& /dev/null&

clean:
	rm -rf build
	rake clean
