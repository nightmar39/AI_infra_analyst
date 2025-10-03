# Postgres to Grafana MCP Demo 

## Requirements 

An AI Client to configure (Demo tested with Claude Desktop)
Docker Desktop 

## Instructions 

### Setup Envrionment 
Run following docker commands to setup a local Postgres DB and Grafana instance 

```
docker run -d \
  --name postgres \
  --network monitoring \
  -e POSTGRES_USER=grafana \
  -e POSTGRES_PASSWORD=password\
  -e POSTGRES_DB=cloudquery \
  -p 5432:5432 \
  postgres:15

docker run -d \
  --name grafana_test \
  --network monitoring \
  -p 3001:3000 \
  -e GF_SECURITY_ADMIN_USER=cloudquery \
  -e GF_SECURITY_ADMIN_PASSWORD=password \
  -v $(pwd)/datasources:/etc/grafana/provisioning/datasources \
  grafana/grafana
```

### Setup Database 

Once you have a running Postgres instance, run a Cloudquery sync to populate your DB with data. A sample sync file is attached 
`cloudquery sync aws_to_postgres.yaml`

### Setup Grafana 

Create a service account and generate an API_KEY. 

Administration -> Users and Access -> Service account

Copy the API key and update the mcp-config.json with the value

### Setup MCP servers 

```
#TEST MCP Servers Locally 
docker pull mcp/grafana
docker pull mcp/postgres

docker run --rm -i \
  --network monitoring \
  -e GRAFANA_URL=http://localhost:3000 \
  -e GRAFANA_API_KEY=*GRAFANA_API_KEY* \
  mcp/grafana \
  -t stdio 

docker run --rm -i \
  --network monitoring \
  -e POSTGRES_URL="postgresql://grafana:password@host.docker.internal:5432/cloudquery" \
  mcp/postgres \
  $POSTGRES_URL
```

On your local AI agent, configure the mcp servers using `mcp-config.json`. 

In Claude you can set this up under 
Settings -> Developer -> Edit Config

This will start the MCP containers on your machine. 

(The postgres connection string will look similar to `postgresql://grafana:password@host.docker.internal:5432/cloudquery`)

### Run queries on your machine 
Once your MCP containers are running and connected to your agent, you can start running queries and creating dashboards.

Run the following to verify your connection 
`Show me my grafana datasources`
`List the first 5 tables in my postgres database`

Verify the information in the query is correct, and we can start running more advanced queries. 
`Write a query to get all EC2 instances with open SSH rules` 
`Create a grafana dashboard which shows all EC2 instances with Open SSH rules` 

