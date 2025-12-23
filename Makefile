

build: clean
	hugo build --logLevel debug --ignoreCache

dev: clean
	hugo server --logLevel debug --ignoreCache --disableFastRender

dev-drafts: clean
	hugo server --logLevel debug --ignoreCache --disableFastRender --buildDrafts

clean:
	rm -rf public/* /tmp/hugo_cache
