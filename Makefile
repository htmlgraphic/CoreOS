# Create a new node on Digital Ocean
# By Jason Gegere <jason@htmlgraphic.com>

.PHONY: update-discovery-token .coreos-token

all:: help
help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "     make token		update discovery token and save in a file"
	@echo "     make node		create node on Digital Ocean"



token: .discovery-token

node: create-on-do

.discovery-token:
	curl -w "\n" https://discovery.etcd.io/new > .discovery-token

create-on-do:
	sed -i.bak -E 's|discovery:(.*$$)|discovery: '$(shell cat .discovery-token)'|' cloud-config.yaml
	chmod +x create_node_vars.sh
	./create_node_vars.sh
