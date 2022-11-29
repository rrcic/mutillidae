FROM tutum/lamp:latest
MAINTAINER Nikolay Golub <nikolay.v.golub@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Preparation
RUN rm -fr /app/* && \
  apt-get update && apt-get install -yqq git wget php5-curl dnsutils && \
  apt-get upgrade -yqq ca-certificates && \
  update-ca-certificates && \
  rm -rf /var/lib/apt/lists/*

# Deploy Mutillidae
RUN \
#  git clone https://github.com/webpwnized/mutillidae.git && \
  wget https://github.com/webpwnized/mutillidae/archive/refs/tags/2.8.59.tar.gz && \
  tar -zxvf 2.8.69.tar.gz && \
  rm -rf /app/* && \
  cp -r /mutillidae-2.8.59/* /app  && \
  rm -rf /mutillidae-2.8.59  && \
  sed -i 's/DirectoryIndex index.html.*/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/g' /etc/apache2/mods-enabled/dir.conf&& \
  sed -i 's/static public \$mMySQLDatabaseUsername =.*/static public \$mMySQLDatabaseUsername = "admin";/g' /app/classes/MySQLHandler.php && \
  echo "sed -i 's/static public \$mMySQLDatabasePassword =.*/static public \$mMySQLDatabasePassword = \\\"'\$PASS'\\\";/g' /app/classes/MySQLHandler.php" >> /create_mysql_admin_user.sh && \
  echo 'session.save_path = "/tmp"' >> /etc/php5/apache2/php.ini

EXPOSE 80 3306
CMD ["/run.sh"]
