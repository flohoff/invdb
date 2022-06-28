
Vue.js vscodium Debian/Bullseye
===============================

	curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key \
		| gpg --dearmor \
		| tee /usr/share/keyrings/nodesource.gpg 

	echo 'deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x bullseye main' > /etc/apt/sources.list.d/nodesource.list
	echo 'deb-src [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x bullseye main' >> /etc/apt/sources.list.d/nodesource.list

