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