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
	@aws s3 sync --delete src s3://example.melvyn.dev
