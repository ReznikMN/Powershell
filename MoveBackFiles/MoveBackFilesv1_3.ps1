######Резник М.Н. 20.09.2018#########################################################################################################################
#####################################################################################################################################################
### Копирование бэкапов SQL-сервера
#####################################################################################################################################################
#####################################################################################################################################################
#разрешение выполнения скриптов на время действия программы
Set-ExecutionPolicy Bypass -Force

#Очищаем папку Archiv на компе, чтобы освободить место для нового копирования
Get-ChildItem C:\Users\reznikmn.GKUNION\Desktop\Archiv | Remove-Item -Recurse -Force

#Расположение каталогов с бэкапами SQL-сервера
$BackupDirs = Get-Content "C:\Users\reznikmn.GKUNION\Desktop\MoveBackFiles\bakupsqldirslist.txt"

#Расположение каталогов, в которые должны быть скопированы бэкапы
$DirsForBakFiles = Get-Content "C:\Users\reznikmn.GKUNION\Desktop\MoveBackFiles\backupresultdirslist.txt"

#Сегодняшняя дата в формате 09_20_2018, используется для формирования названия результирующей папки для бэкапов
$TodayDate =  Get-Date -Format MM_dd_yyyy

#Пустой массив, который будет содержать пути к результирующим папкам для бэкапов
$ResultDir = @()

#Cоздание результирующих папок для бэкапов
ForEach ($DirForBackFile in $DirsForBakFiles) {
    $ResultDir +=  New-Item -Path "$DirForBackFile\$TodayDate" -ItemType Directory -Force -ErrorAction SilentlyContinue
}

#Копируем в каждую результирующую папку бэкапы SQL
ForEach ($Res in $ResultDir) {
    ForEach ($Backup in $BackupDirs) {
        Get-ChildItem -Path $Backup -File -Recurse | Where-Object {((get-date) - $_.LastWriteTime).Days -eq 1} | Copy-Item -Destination "$Res"
    }
}


#####################################################################################################################################################
#####################################################################################################################################################
### Копирование папок
#####################################################################################################################################################
#####################################################################################################################################################


#Формируем массив содержащий расположения резервных папок
$DirsForReserv = Get-Content "C:\Users\reznikmn.GKUNION\Desktop\MoveBackFiles\backupdirslist.txt"

#Копирует всю резервную папку в папку с текущей датой в каждое результирующее расположение


ForEach ($Res in $ResultDir) {
    ForEach ($DirForReserv in $DirsForReserv) {
        Copy-Item -Path $DirForReserv -Destination $Res -Force -Recurse
    }
}

#Отправка письма администратору о завершении резервного копирования
#Задаем адрес отправителя
$sender = "reznikmn@gkunion.ru"
#Задаем адрес получателя
$recipient = "reznikmn@gkunion.ru"
#Задаем имя сервера
$server = "mail.gkunion.ru"
#Определяем заголовок сообщения
$subject = "Резервное копирование"
#Формируем тело сообщения
$body = "Резервное копирование успешно завершено!!!"
#Создаем экземпляр класса System.Net.Mail.MailMessage, соответствующий
#сообщению
$msg = New-Object System.Net.Mail.MailMessage $sender, $recipient,
$subject, $body
#Создаем экземпляр класса System.Net.Mail.SmtpClient, соответствующий
#клиенту SMTP для указанного сервера SMTP
$client = New-Object System.Net.Mail.SmtpClient $server
#Указываем имя и пароль для подключения к серверу SMTP
$client.Credentials = New-Object System.Net.NetworkCredential "reznikmn@gkunion.ru",
"#thehichhickers42guidToThegalaxy7"
#Отсылаем сообщение
$client.Send($msg)