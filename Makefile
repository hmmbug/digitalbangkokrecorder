
all: clean
	hugo server --disableFastRender -D

dev: clean
	hugo

deploy-test: clean
	hugo --config config-deploy-test.toml,config.toml
	hugo --config config-deploy-test.toml,config.toml deploy --target aws-test

deploy-prod: clean
	hugo --config config-deploy-prod.toml,config.toml
	hugo --config config-deploy-prod.toml,config.toml deploy --target aws-prod

clean:
	rm -rf public /tmp/hugo_cache
