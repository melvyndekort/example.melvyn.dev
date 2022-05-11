.PHONY := clean apply deploy
.DEFAULT_GOAL := deploy

ifndef AWS_SESSION_TOKEN
  $(error Not logged in, please run 'awsume')
endif

clean:
	@rm -rf \
	terraform/.terraform \
	terraform/.terraform.lock.hcl

apply:
	@cd terraform; terraform init; terraform apply

deploy:
	@cd src; aws s3 sync --delete . s3://example.melvyn.dev
