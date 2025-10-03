#Dev environment setup
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


