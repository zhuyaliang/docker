#金仓镜像

##build
	docker build -t kingbase:latest .
##run
	docker run -tid -v /data:/home/kingbase/data -p 54321:54321 kingbase:latest
##change username or change password

	only supports changing user name or password at the first time of create data table

	-e USERNMAE="username"    ------>change username 
	-e PASSWORD="passeord"    ------>change password
