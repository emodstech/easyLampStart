#!/bin/bash

read -r -p " Сконфигурировать apache в автоматическом режиме [y/N] ? " response 
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
	sudo sh -c "echo 'Include /etc/phpmyadmin/apache.conf ' >>  /etc/apache2/apache2.conf"
	sudo cp -v /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.old.conf
	sudo sed -i "s!/var/www/html!$HOME/web/index.php!" /etc/apache2/sites-available/000-default.conf
	sudo mkdir -v $HOME/web
	sudo a2enmod rewrite
	sudo chown $USER:$USER $HOME/web

	sudo tee -a /etc/apache2/apache2.conf  <<EOF

	<Directory /home/$USER/web/>
		Options Indexes FollowSymLinks
		AllowOverride All
		Require all granted
	</Directory>
EOF

	sudo systemctl restart apache2
	echo "Готово! Осталось запустить siteAdd.sh"
else 
	echo "apache2 без изменений"
fi

read -r -p " Добавить пользователя $USER в mysql по умолчанию пароль 1234 [y/N] ? " resp
if	[[ "$resp" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
	sudo mysql --user=root mysql <<EQF

	CREATE USER '$USER'@'localhost' IDENTIFIED BY '1234';
	GRANT ALL PRIVILEGES ON *.* to '$USER'@'localhost' WITH GRANT OPTION;
	FLUSH PRIVILEGES;
	exit
EQF
	sudo systemctl restart mysql.service
	echo "Пользователь $USER добавлен, пароль для входа 1234 (при необходимости смените пароль)"
else
	echo "Пользователь не добавлен"
fi

read -r -p "Скорректировать ошибку 'Warning in ./libraries/sql.lib.phpcount(): Parameter must be an array' phpmyadmin [y/N] ? " resp
if	[[ "$resp" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
	sudo sed -i "s/|\s*\((count(\$analyzed_sql_results\['select_expr'\]\)/| (\1)/g" /usr/share/phpmyadmin/libraries/sql.lib.php
	sudo systemctl restart mysql.service
	echo "ошибка исправлена"
else
	echo "несконфигурированно"
fi

read -r -p "Скорректировать ошибку 'Warning in ./libraries/plugin_interface.lib.php#532' phpmyadmin [y/N] ? " resp
if	[[ "$resp" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
	sudo sed -i "s#count(\$options) >#count((array)\$options) >#" /usr/share/phpmyadmin/libraries/plugin_interface.lib.php
	sudo systemctl restart mysql.service
	echo "ошибка исправлена"
else
	echo "несконфигурированно"
fi