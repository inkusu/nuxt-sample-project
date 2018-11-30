apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce
usermod -aG docker ubuntu

mkdir /app
mkdir /app/nginx
cat <<EOL > /app/nginx/default.conf
server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://app:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOL

cat <<EOL > /app/docker-compose.yml
version: '3.1'
services:

  app:
    image: wakachan/nuxt-sample-project:release
    working_dir: /home/node/app
    deploy:
      replicas: 2

  nginx:
    image: nginx:1.15
    ports:
      - "80:80"
    volumes:
      - ./nginx:/etc/nginx/conf.d
    depends_on:
      - app
EOL

docker swarm init
docker stack deploy -c /app/docker-compose.yml sample