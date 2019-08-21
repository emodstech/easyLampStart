# easyLampStart Linux mint / ubuntu

Устанавливаем lamp <br>
<b>sudo apt-get install lamp-server^</b><br>
Устанавливаем phpmyadmin <br>
<b>sudo apt-get install phpmyadmin</b><br>

Конфигурация lamp сервера. <br>

Скачиваем файлы, в настройка файла - во вкладке права, установить <b>"Разрешить исполнять как программу"</b><br>
Или в терминале выполнить команду <b>sudo chmod +x /путь</b>

Запускаем <b>easyLampStart.sh (Не запускать под root)</b>, cкрипт редактирует конфиги 000-default.conf, apache2.conf, <br>
cоздает папку "web" для проектов по адресу <b>/home/user/web</b><br>
При необходимости создает пользователя mysql.<br>

Корректирует ошибки phpmyadmin по выбору<br>

<b>Warning in ./libraries/sql.lib.phpcount(): Parameter must be an array <br>
Warning in ./libraries/plugin_interface.lib.php#532<br></b>

Запускаем файл <b>SiteAdd.sh</b> и вводим название папки с сайтом/проектом</br>
Скрипт создает virtualhost, создает папку с названием сайта по адресу /home/user/web/проект и добавляет в hosts сайт. <br>

Далее при создании нового сайта/проекта, просто запускаем <b>SiteAdd.sh</b> и вводим название папки сайта/проекта</br>

Для удаления сайта/проекта, запускаем <b>SiteAdd.sh</b> и вводим имя имеющегося сайта/проекта для удаления.<br>
Скрипт удаляет сайт/проект, обновляет etc/hosts, удаляет virtualhost

