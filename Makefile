TAG_PRODUCTION=production
TAG_DEVELOPMENT=development
TAG_STAGING=staging
TARGET_ENV?=development

kubernetes_generate_yml:
	@rm -rf ./tmp/$(TARGET_ENV); \
	mkdir -p ./tmp/$(TARGET_ENV); \
	if [ -z "$(NUM_SHARDS)" ]; then echo "No num of shards provided!" ; exit 2; fi; \
	if [ ! "$(NUM_SHARDS)" -gt 0 ]; then echo "NUM_SHARDS MUST be > 0"; exit 1; fi; \
	rm -f ./tmp/$(TARGET_ENV)-kubernetes*.yaml; \
	for (( i=0; i<"$(NUM_SHARDS)"; i++ )) do \
		for l in service deployment; do \
			fn=$(TARGET_ENV)-kubernetes-$${l}-$${i}.yaml ; \
			cat kubernetes-$${l}.tpl.yml | \
					sed -e "s/%ENV%/$(TARGET_ENV)/g" | \
					sed -e "s/%SHARD_NUM%/$${i}/g" \
					  > tmp/$(TARGET_ENV)/$$fn; \
		done; \
	done;

apply_service: guard_right_env kubernetes_generate_yml
	kubectl create -f ./tmp/$(TARGET_ENV);/$(TARGET_ENV)-kubernetes-service*.yaml

apply_deployment: guard_right_env kubernetes_generate_yml
	kubectl apply -f ./tmp/$(TARGET_ENV);

# the kubernetes cluster name postfix is the environment name
guard_right_env:
	@ if [ ! "$$(kubectl config current-context | cut -d"-"  -f5)" = "$(TARGET_ENV)" ]; then  \
		echo "Mismatch between the target environment and the context"; exit 1; \
	fi;
