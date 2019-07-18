#!/bin/bash
# Добавление и конфигурация сайта
path="web" # путь до папки сайта /home/$USER не нужно
echo "Введите название папки сайта"
read hostName #Читаем название сайта 

if [ -e "/etc/apache2/sites-available/$hostName.ru.conf" ]; then  #Проверка добавлен ли virtualhost
	read -r -p "Сайт уже добавлен, вы хотите его удалить [y/N] " response 
		if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
			sudo rm  /etc/apache2/sites-available/$hostName.ru.conf #удаляем virtualHost
			sudo rm -rf ~/$path/$hostName.ru  #удаляем папку с сайтом
			sudo a2dissite $hostName.ru.conf # удаляем конфиг
			sudo sed -i_bak -e "/[\t]$hostName/d" /etc/hosts # удаляем адрес и hosts	
			sudo systemctl restart apache2 #Перезагрузка apache
			echo "Сайт $hostName.ru удалён" 
		else 
			echo "Отмена - выход из скрипта"
		fi
else
	mkdir ~/$path/$hostName.ru
	sudo chown -Rv $USER:$USER ~/$path/$hostName.ru
	sudo touch /etc/apache2/sites-available/$hostName.ru.conf
	sudo bash -c "cat > /etc/apache2/sites-available/$hostName.ru.conf <<EOF    
	<VirtualHost *:80>
	ServerAlias $hostName.ru www.$hostName.ru
	DocumentRoot /home/$USER/$path/$hostName.ru
	<Directory /home/$USER/$path/$hostName.ru>
	AllowOverride All
	Require all granted
	</Directory>
	</VirtualHost>
EOF
	"	
	sudo a2ensite $hostName.ru.conf
	sudo sh -c "echo '127.0.1.1	$hostName.ru' >> /etc/hosts"
	sudo systemctl restart apache2
	echo "Сайт $hostName.ru успешно добавлен"
fi