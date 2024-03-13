# docker-xjamppt

This image is my fork of `docker-xampp` adding Tomcat and Java. Like the orifinal image, it also runs SSH server to connect to. __Both MySQL and phpmyadmin use default XAMPP password__.


# Building this image

You can build this image with this command:
```bash 
docker build -t xjamppt . --build-arg XAMPP_PATH=~/Downloads/xampp-linux-x64-8.2.4-0-installer.run
```
You need to set the XAMPP_PATH variable to your local download of xampp, which can be downloaded [here](https://www.apachefriends.org/it/download.html)

Or if you want you can enable downloading of the package by docker by changing the Dockerfile on the line where XAMPP_URL is.

# Running the image

This image uses /www directory for your page files, so you need to mount it.

```
docker run --name myXampp -p 41061:22 -p 41062:80 -d -v ~/my_web_pages:/www xjamppt
```
The command above will expose the SSH server on port 41061 and HTTP server on port 41062.
Feel free to use your own name for the container.

To browse to your web page, visit this URL: [http://localhost:41062/www](http://localhost:41062/www)
And to open up the XAMPP interface: [http://localhost:41062/](http://localhost:41062/)

---

| PHP version | Corresponding tag |
--------------|---------------------
| 8.2.4 | `tomsik68/xampp:8`|
| 7.4.33 | `tomsik68/xampp:7` |
| 5.6.40 | `tomsik68/xampp:5` |

For PHP 8, start your container like this:
```bash
docker run --name myXampp -p 41061:22 -p 41062:80 -d -v ~/my_web_pages:/www tomsik68/xampp:8
```

## Default credentials

service | username | password
------- | -------- | ---------
ssh     | root     | root

---

# Additional How-tos

## My app can't function in `/www` folder

No problem, just mount your app in the `/opt/lampp/htdocs` folder, for example:

```
docker run --name myXampp -p 41061:22 -p 41062:80 -d -v ~/my_web_pages:/opt/lampp/htdocs xjamppt
```

## ssh connection

default SSH password is 'root'.

```
ssh root@localhost -p 41061
```

## get a shell terminal inside your container

```
docker exec -ti myXampp bash
```

## use binaries provided by XAMPP

Inside docker container:
```
export PATH=/opt/lampp/bin:$PATH
```
You can then use `mysql` and friends installed in `/opt/lampp/bin` in your current bash session. If you want this to persist, you need to add it to your user or system-wide `.bashrc` (inside container).

## Use your own configuration

In your home directory, create a `my_apache_conf` directory in which you place any number of apache configuration files. As soon as they end with the `.conf` extension, they will be used by xampp. Make sure to use the following flag in your command: `-v ~/my_apache_conf:/opt/lampp/apache2/conf.d`, for example:

```
docker run --name myXampp -p 41061:22 -p 41062:80 -d -v ~/my_web_pages:/www  -v ~/my_apache_conf:/opt/lampp/apache2/conf.d xjamppt
```

## Restart the server

Once you have modified configuration for example
```
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
