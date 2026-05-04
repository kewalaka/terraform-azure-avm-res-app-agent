# connectors

This submodule manages a connector resource (`Microsoft.App/agents/connectors`) as a child of an SRE Agent. Example: `module "connector" { source = "../../modules/connectors"; name = "my-connector"; parent_id = module.sre_agent.resource_id; location = "eastus" }`
