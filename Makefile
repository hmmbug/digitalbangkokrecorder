

all: clean
	hugo server --logLevel debug --ignoreCache --buildDrafts --disableFastRender 

dev: clean
	hugo server --logLevel debug --ignoreCache --disableFastRender

clean:
	rm -rf public/* /tmp/hugo_cache
