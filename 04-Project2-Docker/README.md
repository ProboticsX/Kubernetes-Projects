How to connect mysql container running on localhost to users.js app?
- docker exec -it <mysql container name> sh
- mysql -u root -p
- Enter passowrd: rootpassword
- SHOW DATABASES; USE mydatabase; SELECT * FROM users;