cf-create:
	aws cloudformation create-stack --stack-name example --template-body file://stack.yaml

cf-update:
	aws cloudformation update-stack --stack-name example --template-body file://stack.yaml

cf-delete:
	aws cloudformation delete-stack --stack-name example

deploy-site:
	aws s3 sync --delete src s3://example.melvyn.dev

run-site:
	docker run --rm -it -v ${CURDIR}/src:/usr/share/nginx/html:ro -p 80:80 nginx:1.15.8
