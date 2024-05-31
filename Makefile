
all: clean
	hugo server --logLevel debug --ignoreCache --buildDrafts --disableFastRender 

dev: clean
	hugo

deploy-test: clean
	hugo --config config-deploy-test.toml,config.toml
	hugo --maxDeletes "-1" --config config-deploy-test.toml,config.toml deploy --target aws-test
	@echo "Goto https://www-test.digitalbangkokrecorder.com"

deploy-prod: clean
	hugo --config config-deploy-prod.toml,config.toml
	hugo --config config-deploy-prod.toml,config.toml deploy --target aws-prod
	@echo "Goto https://www.digitalbangkokrecorder.com"

clean:
	rm -rf public/* /tmp/hugo_cache
