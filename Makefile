deploy:
	aws s3 sync --delete src s3://example.melvyn.dev

run:
	docker run --rm -it -v ${CURDIR}/src:/usr/share/nginx/html:ro -p 80:80 nginx:1.15.8
