deploy:
	terraform destroy --auto-approve && \
		terraform apply --auto-approve && \
		make connect

connect:
	echo ssh ubuntu@$(shell cat terraform.tfstate | jq -r '.resources[0].instances[0].attributes.public_dns')  
