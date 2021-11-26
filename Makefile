seal-file:
	@[ "${file}" ] || ( echo "*** file is not set"; exit 1 )
	@[ "${name}" ] || ( echo "*** name is not set"; exit 1 )
	@[ "${ns}" ] || ( echo "*** ns is not set"; exit 1 )

	mkdir -p .secrets/generated

	kubectl create secret generic $(name) -n $(ns) \
	--from-file=$(file) \
	--dry-run=client \
	-o json > .secrets/generated/$(name).json

	kubeseal --format=yaml --cert=.secrets/cert.pem \
		--scope=strict \
		--namespace=$(ns) < .secrets/generated/$(name).json > .secrets/generated/$(name).yaml

	rm .secrets/generated/$(name).json

external-dns:
	make seal-file name=external-dns-credentials ns=external-dns file=.secrets/external-dns-credentials.yaml

flux-alerts-slack:
	kubectl -n flux-system create secret generic flux-slack-url \
		--from-literal=address=${JOSA_SLACK_URL} \
		--dry-run=client \
		-o json > .secrets/flux-slack-url.json

	kubeseal --format=yaml --cert=.secrets/cert.pem \
		--scope=strict \
		--namespace=flux-system < .secrets/flux-slack-url.json > .secrets/generated/flux-slack-url.yaml

watch-hello:
	@while sleep 5; do curl --insecure -s https://hello.josa.kubechamp.gq/ | grep -A 2 "message" | sed -n 2p; done