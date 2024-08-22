# bookstack-reports
# Інсталяція

1) Заповнити ВСІ необхідні поля(змінні) в файлі `.env` директорії інсталяції Bookstack (Наприклад: /var/www/bookstack/.env)
```bash
sudo nano /var/www/bookstack/.env
```

```bash
APP_KEY=base64:d54hfVzaVNDcdToyDfjff33GhT8oLC58L3NygnAs4/6C9Vht7Bs= #Вже заповнено за замовчуванням
APP_URL=https://new.example.com #Вже заповнено за замовчуванням

DB_HOST=localhost #Вже заповнено за замовчуванням
DB_DATABASE=bookstack #Вже заповнено за замовчуванням
DB_USERNAME=bookstack #Вже заповнено за замовчуванням
DB_PASSWORD=5jngbz76hFJKnd87 #Вже заповнено за замовчуванням

MAIL_DRIVER=smtp #Вже заповнено за замовчуванням

MAIL_FROM_NAME="BookStack" #ОБОВ`ЯЗКОВО ЗАПОВНИТИ!!!
MAIL_FROM=bookstack.reports@gmail.com #ОБОВ`ЯЗКОВО ЗАПОВНИТИ!!!

MAIL_HOST=smtp.gmail.com #ОБОВ`ЯЗКОВО ЗАПОВНИТИ!!!
MAIL_PORT=465 #ОБОВ`ЯЗКОВО ЗАПОВНИТИ!!!
MAIL_USERNAME=bookstack.reports@gmail.com #ОБОВ`ЯЗКОВО ЗАПОВНИТИ!!!

#ОБОВ`ЯЗКОВО ДО ЗАПОВНЕННЯ!!! Перевірялось з SMTP серверами Google.
#Необхідно в обліковому записі Google створити App Password та вказати тут сгенерований 16 значний пароль з 3 пробілами
#та в ОДИНАРНИХ лапках
MAIL_PASSWORD='yiic nevz tiuc eavq' 
```

2) Встановити git, якщо ще не встановлено:
```bash
sudo apt install git
```

3) Завантажити проєкт:
```bash
git clone https://github.com/samuel-edmund-morgan/bookstack-reports.git
```

4) Перейти в директорію:
```bash
cd bookstack-reports
```

5) Встановити:
```bash
sudo bash setup.sh вашаПоштаКудиВідправлятимутьсяЗвіти@gmail.com
```
**Наприклад: sudo bash setup.sh samuel.morgan@gmail.com**

6) Готово!


Щоденно генеруватимуться звіти та відправлятимуться на пошту, яку ви вказали на кроці 5.

**Директорія з журналами: /var/log/bookstack-reports/**

**Директорія з файлами програми(включаючи конфігураційні та SQL запит): /etc/bookstack-reports/**

**Сервіс та таймер сстворені та запущені в: /etc/systemd/system/bookstack-reports.service та /etc/systemd/system/bookstack-reports.timer**

