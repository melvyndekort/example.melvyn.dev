.PHONY := clean_secrets decrypt encrypt clean apply deploy
.DEFAULT_GOAL := deploy

ifndef AWS_SESSION_TOKEN
  $(error Not logged in, please run 'awsume')
endif

clean_secrets:
	@rm -f terraform/secrets.yaml

decrypt: clean_secrets
	@aws kms decrypt \
		--ciphertext-blob $$(cat terraform/secrets.yaml.encrypted) \
		--output text \
		--query Plaintext \
		--encryption-context target=example.melvyn.dev | base64 -d > terraform/secrets.yaml

encrypt:
	@aws kms encrypt \
		--key-id alias/generic \
		--plaintext fileb://terraform/secrets.yaml \
		--encryption-context target=example.melvyn.dev \
		--output text \
		--query CiphertextBlob > terraform/secrets.yaml.encrypted
	@rm -f secrets.yaml

clean: clean_secrets
	@rm -rf \
	terraform/.terraform \
	terraform/.terraform.lock.hcl

apply: clean_secrets
	@cd terraform; terraform init; terraform apply

deploy: clean_secrets
	@aws s3 sync --delete src s3://example.melvyn.dev
