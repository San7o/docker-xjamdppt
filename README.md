
# docker-xjamdppt


This image is my fork of `docker-xampp` adding Tomcat, Java and Derby DB. Like the original image, it also runs SSH server to connect to. __Both MySQL and phpmyadmin use default XAMPP password__.


# Building this image

Example build command:
```bash 
docker build -t xjamdppt . --build-arg XAMPP_PATH=./xampp-linux-*-installer.run
```
Where you need to set the "XAMPP_PATH" variable to your local download of xampp, which can be downloaded [here](https://www.apachefriends.org/it/download.html)

Or if you want you can enable downloading from docker by changing the Dockerfile on the line where XAMPP_URL is.

# Running the image

This image uses /www directory for your page files, so you need to mount it.

```bash
docker run --name myXampp -p 41061:22 -p 41062:80 -p 41063:8080 -d -v ~/my_web_pages:/www xjamppt
```

Where:

- `41061` is the SSH server 

- `41062` is the HTTP server

- `41063` is tomcat server. To run the tomcat server you have to execute `/opt/tomcat/apache-tomcat-8.5.79/bin/startup.sh`. All the other scripts are in the same directory.

- `~/my_web_pages` is a shared volume, It enables you to store data permanently outside docker

To browse to your web page, visit this URL: [http://localhost:41062/www](http://localhost:41062/www)
And to open up the XAMPP interface: [http://localhost:41062/](http://localhost:41062/)


# Deploy the webapp with tomcat

Start tomcat with
```
docker exec -it myXampp bash
bash> /opt/tomcat/apache-tomcat-8.5.79/bin/startup.sh
```
Then, you need to move the webapp to `my_web_pages/<webapp_name>` and run the command
```
docker exec -it myXampp deploy_website.sh /www/<webapp_name>
```

# Derby DB

## Start server 

```bash
docker exec -ti myXampp bash
bash> java -jar $DERBY_INSTALL/lib/derbyrun.jar server start &
```

## Interact with the DBMS
```bash
java -jar $DERBY_INSTALL/lib/derbyrun.jar ij
```


# Get a shell terminal inside your container

```bash
docker exec -ti myXampp bash
```

---

# Useful docker commands

```bash 
# List running containers
docker ps
# Stop a container 
docker stop CONTAINER_ID
# List all installed containers
docker container list -a 
# Remove a container 
docker rm CONTAINER_ID
```

## Default credentials

service | username | password
------- | -------- | ---------
ssh     | root     | root
tomcat  | admin    | admin
tomcat  | manager  | manager

---

# Additional How-tos

## My app can't function in `/www` folder

No problem, just mount your app in the `/opt/lampp/htdocs` folder, for example:

```bash
docker run --name myXampp -p 41061:22 -p 41062:80 -d -v ~/my_web_pages:/opt/lampp/htdocs xjamppt
```

## ssh connection

default SSH password is 'root'.

```bash
ssh root@localhost -p 41061
```

## use binaries provided by XAMPP

Inside docker container:
```bash
export PATH=/opt/lampp/bin:$PATH
```
You can then use `mysql` and friends installed in `/opt/lampp/bin` in your current bash session. If you want this to persist, you need to add it to your user or system-wide `.bashrc` (inside container).

## Use your own configuration

In your home directory, create a `my_apache_conf` directory in which you place any number of apache configuration files. As soon as they end with the `.conf` extension, they will be used by xampp. Make sure to use the following flag in your command: `-v ~/my_apache_conf:/opt/lampp/apache2/conf.d`, for example:

```bash
docker run --name myXampp -p 41061:22 -p 41062:80 -d -v ~/my_web_pages:/www  -v ~/my_apache_conf:/opt/lampp/apache2/conf.d xjamppt
```

## Restart the server

Once you have modified configuration for example
```bash
docker exec myXampp /opt/lampp/lampp restart
```

## phpmyadmin

If you used the flag `-p 41062:80` with `docker run`, just browse to http://localhost:41062/phpmyadmin/ .

## Use a Different XAMPP or PHP Version

Currently, the Docker image is built only for PHP 5, 7 and 8.
If you need another version, you can easily build a Docker image yourself, here's how:

1. Clone this repo (local clone is sufficient, no need to fork)
2. Find the URL to a URL to your desired version. List of versions can be found here: https://sourceforge.net/projects/xampp/files/XAMPP%20Linux/
3. Build the image using e.g. `docker build --build-arg XAMPP_URL="https://www.apachefriends.org/xampp-files/5.6.40/xampp-linux-x64-5.6.40-1-installer.run?from_af=true" .` (with XAMPP_URL uncommented in the Dockerfile).
