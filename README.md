# Drupal 8 Docker Development Environment

This repo contains Dockerfiles and a docker-compose.yml which can be used to 
spin up a Drupal 8 development environment in Docker containers. The Drupal 8
development environments consists of three interconnected containers: A MySQL
database container, a Drupal 8 container and a NGINX web server container.

# Table of Contents

* [Pre-Requisites](#pre-requisites)
* [Docker Installation](#docker-installation)
  * [Setting up Docker on Linux](#setting-up-docker-on-linux)
  * [Setting up Docker on Mac](#setting-up-docker-on-mac)
  * [Setting up Docker on Windows](#setting-up-docker-on-windows)
  * [Verifying Your Docker Installation](#verifying-your-docker-installation)
* [Configuration](#configuration)
  * [NGINX](#nginx)
  * [Drupal](#drupal)
  * [MySQL](#mysql)
    * [Importing a Database Dump](#importing-a-database-dump)
* [Using the Development Environment](#using-the-development-environment)
  * [Which docker-compose.yml should I use?](#which-docker-compose.yml-should-i-use?)
  * [Using the Vanilla Drupal Development Environment](#using-the-vanilla-drupal-development-environment)
  * [Using the Drupal Development Environment with an Existing Site](#using-the-drupal-development-environment-with-an-existing-site)
  * [Accessing Drupal and MySQL Volumes](#accessing-drupal-and-mysql-volumes)
  * [Stopping the Development Environment](#stopping-the-development-environment)
  * [Interacting with the MySQL Container](#interacting-with-the-mysql-container)
  * [Starting a Fresh Environment](#starting-a-fresh-environment)
* [Example Site](#example-site)


# Pre-Requisites

To utilize the Drupal 8 Docker development environment, the following software
must be availble on the host where the the environment is to be deployed.

* Docker
* docker-compose

# Docker Installation

## Setting up Docker on Linux

### Installing Docker

Docker-CE may be easily installed from package repositories on CentOS, Debian,
Fedora and Ubuntu systems. Please see the specific installation instructions 
for your Linux distribution on [this page](https://docs.docker.com/install/).

### Installing docker-compose

docker-compose may be installed on Linux by following the instructions on
[this page](https://docs.docker.com/compose/install/).

## Setting up Docker on Mac

### Installing Docker

Install Docker Desktop for Mac. See [this page](https://docs.docker.com/docker-for-mac/install/) 
for detailed installation instructions.

### Installing docker-compose

docker-compose is automatically installed alongside Docker Desktop for Mac.

## Setting up Docker on Windows

### Installing Docker

Install Docker Desktop for Windows. See [this page](https://docs.docker.com/docker-for-windows/install/)
for detailed installation instructions.

### Installing docker-compose

docker-compose is automatically installed alongside Docker Desktop for Windows.

## Verifying Your Docker Installation

The Docker and docker-compose installation may be verified by running the 
following commands in a command line terminal.

```bash
# Verify that Docker is working correctly.
$ docker run --rm hello-world:latest
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
1b930d010525: Pull complete
Digest: sha256:6540fc08ee6e6b7b63468dc3317e3303aae178cb8a45ed3123180328bcc1d20f
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

# Verify that docker-compose is installed and available.
$ docker-compose --version
docker-compose version 1.23.2, build 1110ad01
```

If these commands do not succeed, please review the Docker installation
instructions for your platform and try re-installing.

# Configuration

This section outlines the configuration for the three containers that
constitute the Drupal 8 Docker development environment.

## NGINX

The Drupal 8 Docker development environment utilizes an NGINX 1.17 container as 
its frontend web server.

The environment variables set in the NGINX container may be viewed in the 
[nginx.env](nginx/resources/nginx.env) file.

The NGINX server block for the Drupal application may be viewed in the
[default.conf](nginx/resources/default.conf) file.

## Drupal

The environment variables set in the Drupal container may be viewed in the 
[drupal.env](drupal/resources/drupal.env) file.

When the Drupal container is built, it will copy in a custom [composer.json](drupal/resources/composer.json)
that will include all of the public modules required in the development environment.
Additionally, a [shell script](drupal/resources/enable_modules.sh) will be copied
into the container which may be used to easily enable all of these modules once
the Drupal instance is up and running.

## MySQL

The Drupal 8 Docker development environment utilizes a MySQL 8 container as its
backend database.

The environment variables set in the MySQL container may be viewed in the 
[mysql.env](mysql/resources/mysql.env) file.

### Importing a Database Dump

If a SQL database dump is available, it may be placed under the 
`./mysql/resources/init` directory. When the MySQL container starts, it will 
mount in this directory and automatically import the database dump. The database
dump file must have a `.sql` or `.sql.gz` extension.

By default, the database dump will be read into the database defined by the 
`MYSQL_DATABASE` enviroment variable specificed in [mysql.env](mysql/resources/mysql.env#L2).

The database dump will only be imported during a fresh deployment of the MySQL
container.

# Using the Development Environment

## Which docker-compose.yml should I use?

The default `docker-compose.yml` will build out a Drupal 8 development environment
and mount in an existing Drupal 8 site. Use this docker-compose.yml when you 
want to develop against an existing site.

`docker-compose.vanilla.yml` will build out a plain Drupal 8 development 
environment with no existing site. Use this docker-compose.yml when you want 
to create a Drupal 8 development environment with no existing data.

To use `docker-compose.vanilla.yml`, be sure to include `-f docker-compose.vanilla.yml`
when you invoke `docker-compose` so that the vanilla docker-compose.yml is targeted.

## Using the Vanilla Drupal Development Environment

### Starting the Development Environment

The vanilla Drupal 8 Docker development cluster may be started via `docker-compose`.

```bash
# Execute in the top level directory where docker-compose.vanilla.yml is.
$ docker-compose -f docker-compose.vanilla.yml up -d --build
```

This command will spin up a MySQL 8 database container, a Drupal 8 container and  
an NGINX web server frontend container.

Once completed, Drupal may be accessed at `http://localhost:8080`.  
The MySQL database will be available at `localhost:3306`.

### Initial Setup

If you are deploying the Drupal 8 Docker development environment for the first
time, there are a few initial setup steps the must be completed.

1. Once the Drupal container is up, navigate to `http://localhost:8080/index.php`
   and go through the guided Drupal 8 installation. Select the "Standard" installation
   profile on the "Choose Profile" tab.
2. On the "Set up database" tab, select "MySQL, MariaDB, Percona Server, or equivalent"
   as the database type. For the fields, use the values in [mysql.env](mysql/resources/mysql.env).
   The database name should be the value of  `MYSQL_DATABASE`, the database username
   should be the value of `MYSQL_USER` and  the database password should be the
   value of `MYSQL_PASSWORD`. Under advanced options, set the "Host" option to `mysql`
   to match the name of the MySQL service.

   ![Drupal Database Setup](img/drupal_db_setup.png "Drupal Database Setup")

3. Enter whatver values you wish on the "Configure site" tab.
4. Once the Drupal installation wizard is complete, you will need to enable all
   of the public modules installed previously during the build of the Drupal
   container. This can be done by running the enable_modules.sh script via
   `docker exec`.
   ```bash
   # Find the ID of the Drupal container.
   $ docker ps -qf "ancestor=drupal-8-docker-dev_drupal"
   0ac1284fca93

   # Run enable_modules.sh within the Drupal container
   $ docker exec 0ac1284fca93 ./enable_modules.sh
   ```
5. Once this script completes, refresh your browser and you should see that
   the Bootstrap theme has become active an all of the third party modules are
   now enabled. You are now ready to use the Drupal environment.

## Using the Drupal Development Environment with an Existing Site

### Initial Setup

The following list outline the process of importing an existing Drupal 8 site
into the Drupal 8 Docker development environment. Steps 1-8 will only need to be 
done during the initial deployment of the development environment. Once completed,
the development environment may be stopped and restarted and the site changes will
be persisted.

1. Obtain a copy of your site(s). This should be the contents of the `sites` directory
   in your Drupal 8 project.
2. Copy the site contents in the `dev` directory. This directory will be mounted 
   into the Drupal 8 instance at `/var/www/html/sites`. This directory needs to 
   be readable by the `www-data` (UID: 33) user within the Drupal 8 container. This can be 
   done by changing the ownership of the `dev` directory.
   ```bash
   $ chown -R 33:33 ./dev
   ```
3. Obtain a SQL dump of your site's database. The dump file should be placed in
   `./mysql/resources/init` and must have the extension `.sql` or `.sql.gz`.
4. Update the `settings.php` file for your site. In particular, you will need to 
   update the database connection options to match the MySQL database, user and 
   password being used by the MySQL container. The values used by the container
   may be found in [mysql.env](mysql/resources/mysql.env). The MySQL host should 
   be changed to `mysql`.
   ```php
   # An example settings.php snippet using the default MySQL container credentials.
   $databases['default']['default'] = array (
      'database' => 'drupaldb',
      'username' => 'drupaluser',
      'password' => 'drupalpassword',
      'prefix' => '',
      'host' => 'mysql',
      'port' => '3306',
      'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
      'driver' => 'mysql',
      );
   ```
6. Add any additional third party modules required for your site to the Drupal
   [composer.json](drupal/resources/composer.json#L6-L26). Make sure to also add 
   a line to [enable_modules.sh](drupal/resources/enable_modules.sh) so that the
   script will enable your module via Drush.
5. Start up the Drupal 8 Docker development environment via `docker-compose`.
   ```bash
   $ docker-compose up -d --build
   ```
6. Wait for the MySQL DB to import and become available. It will take some time to
   import your database from the SQL dump. During this time, the MySQL database
   will not be available and Drupal will not be able to connect. You can determine
   when the MySQL database is up and available by examining the logs of the MySQL
   container via `docker logs`. You can tell that MySQL is ready to accept connections
   when the log message `/usr/sbin/mysqld: ready for connections.` appears in the logs.
   ```bash
   # Get the ID of the MySQL container.
   $ docker ps -qf "ancestor=drupal-8-docker-dev_mysql"
   ab50798d19f6

   # SQL dump still importing. MySQL unavailable.
   $ docker logs ab50798d19f6
   ...
   /usr/local/bin/docker-entrypoint.sh: running /docker-entrypoint-initdb.d/my_db_dump.sql
   mysql: [Warning] Using a password on the command line interface can be insecure.

   # MySQL ready for client connections.
   $ docker logs ab50798d19f6
   ...
   /usr/local/bin/docker-entrypoint.sh: running /docker-entrypoint-initdb.d/my_db_dump.sql
   mysql: [Warning] Using a password on the command line interface can be insecure.


   2019-07-22T18:49:58.746740Z 0 [System] [MY-010910] [Server] /usr/sbin/mysqld: Shutdown complete (mysqld 8.0.16)  MySQL Community Server - GPL.

   MySQL init process done. Ready for start up.

   2019-07-22T18:49:59.072256Z 0 [Warning] [MY-011070] [Server] 'Disabling symbolic links using --skip-symbolic-links (or equivalent) is the default. Consider not using this option as it' is deprecated and will be removed in a future release.
   2019-07-22T18:49:59.072321Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 8.0.16) starting as process 1
   2019-07-22T18:49:59.575815Z 0 [Warning] [MY-010068] [Server] CA certificate ca.pem is self signed.
   2019-07-22T18:49:59.585663Z 0 [Warning] [MY-011810] [Server] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
   2019-07-22T18:49:59.600307Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.16'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server - GPL.
   2019-07-22T18:49:59.695809Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Socket: '/var/run/mysqld/mysqlx.sock' bind-address: '::' port: 33060
   ```
8. Enable third party modules via the `enable_modules.sh` script.
   ```bash
   # Find the ID of the Drupal container.
   $ docker ps -qf "ancestor=drupal-8-docker-dev_drupal"
   0ac1284fca93

   # Run enable_modules.sh within the Drupal container
   $ docker exec 0ac1284fca93 ./enable_modules.sh
   ```
7. Access your Drupal 8 development instance at `http://localhost:8080` and your
   database instance at `localhost:3306`. You should now be ready to use the 
   Drupal 8 Docker development instance!

## Accessing Drupal and MySQL Volumes

In the Drupal development environment, the Drupal directory 
`/var/www/html` and the MySQL data directory `/var/lib/mysql` are exposed and 
persisted on the host via Docker named volumes. This allows the data in these
directories to be persisted across restarts of the development environment.

If you wish to retrieve data from these volumes, you can locate the mount point
on the host via `docker volume inspect`.

```bash
# List out all Docker volumes.
$ docker volume list
DRIVER              VOLUME NAME
local               drupal-8-docker-dev_html
local               drupal-8-docker-dev_mysql-data

# Get the host mountpoint of a Docker volume.
$ docker volume inspect --format '{{ .Mountpoint }}' drupal-8-docker-dev_html
/var/lib/docker/volumes/drupal-8-docker-dev_html/_data
```

Note: If you are running the Drupal 8 Docker development environment on Mac or
Windows via Docker Desktop, the mountpoint paths will not exist on your host
system. This is because Docker Desktop actually runs Docker within a small VM.
The mountpoint paths Docker returns will be paths within this VM. If you wish to
copy data to and from the Drupal or MySQL containers on these operating systems,
consider using [docker cp](https://docs.docker.com/engine/reference/commandline/cp/)
instead.

## Interacting with the MySQL Container

Along with the NGINX webserver, the MySQL container is also exposed for local
connections. 

### Connect to the MySQL container via the `mysql` client.

You may connect to the MySQL container via a local client on the 
same host as your development environment using the host `127.0.0.1` and the 
port `3306`.

```bash 
$ mysql -h 127.0.0.1 -P 3306 -u drupaluser --password=drupalpassword
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 90
Server version: 8.0.16 MySQL Community Server - GPL

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| drupaldb           |
| information_schema |
+--------------------+
2 rows in set (0.00 sec)
```

### Connect to MySQL via the `mysql` client within the MySQL container.

It is also possible to connect to the database using the MySQL client within
the MySQL container if no local client is available.
```bash
# Get the ID of the MySQL container.
$ docker ps -qf "ancestor=drupal-8-docker-dev_mysql"
ab50798d19f6

# Start the MySQL client within the container.
$ docker exec -it ab50798d19f6 mysql --user=drupaluser --password=drupalpassword
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 91
Server version: 8.0.16 MySQL Community Server - GPL

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| drupaldb           |
| information_schema |
+--------------------+
2 rows in set (0.01 sec)
```

### Dump a database within the MySQL container.

The MySQL container also contains the `mysqldump` binary, which may be used to 
easily dump databases within the MySQL container.

```bash
# Get the ID of the MySQL container.
$ docker ps -qf "ancestor=drupal-8-docker-dev_mysql"
ab50798d19f6

# Dump the database to the local host file drupaldb_dump.sql.
$ docker exec -i ab50798d19f6 /usr/bin/mysqldump --user=drupaluser --password=drupalpassword drupaldb > drupaldb_dump.sql

# Dump the database to the local host file drupaldb_dump.sql and print to stdout.
$ docker exec -i ab50798d19f6 /usr/bin/mysqldump --user=drupaluser --password=drupalpassword drupaldb | tee drupaldb_dump.sql
```

## Stopping the Development Environment

The Drupal 8 Docker development cluster may be stopped via `docker-compose`.

```bash
# Stopping the cluster.
$ docker-compose stop

# Stopping a vanilla cluster.
$ docker-compose -f docker-compose.vanilla.yml stop
```

Edits made to the Drupal site and changes made to the MySQL database will be 
persisted across restarts of the Drupal 8 development cluster.

## Starting a Fresh Environment

If you wish to start a fresh Drupal 8 Docker development environment, execute
the following commands to remove the persistent volumes for the containers and 
restart them with new volumes. Be sure to copy data you wish to save before
removing the persistent volumes.

```bash 
# Standard Cluster
# Stop all containers and delete persistent volumes.
$ docker-compose down -v

# Restart containers with fresh volumes
$ docker-compose up -d --build


# Vanilla Cluster
# Stop all containers and delete persistent volumes.
$ docker-compose -f docker-compose.vanilla.yml down -v

# Restart containers with fresh volumes
$ docker-compose -f docker-compose.vanilla.yml up -d --build
```

Keep in mind that you will need to go back through the intitial setup following
the deployment of a fresh environment.

# Example Site

Please see the [drupal-8-umami-example repo](https://github.com/OULibraries/drupal-8-umami-example)
for an example Drupal 8 site that can be imported into the Drupal 8 Docker development environment
for testing.
