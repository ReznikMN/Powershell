######������ �.�. 20.09.2018#########################################################################################################################
#####################################################################################################################################################
### ����������� ������� SQL-�������
#####################################################################################################################################################
#####################################################################################################################################################
#���������� ���������� �������� �� ����� �������� ���������
Set-ExecutionPolicy Bypass -Force

#������� ����� Archiv �� �����, ����� ���������� ����� ��� ������ �����������
Get-ChildItem C:\Users\reznikmn.GKUNION\Desktop\Archiv | Remove-Item -Recurse -Force

#������������ ��������� � �������� SQL-�������
$BackupDirs = Get-Content "C:\Users\reznikmn.GKUNION\Desktop\MoveBackFiles\bakupsqldirslist.txt"

#������������ ���������, � ������� ������ ���� ����������� ������
$DirsForBakFiles = Get-Content "C:\Users\reznikmn.GKUNION\Desktop\MoveBackFiles\backupresultdirslist.txt"

#����������� ���� � ������� 09_20_2018, ������������ ��� ������������ �������� �������������� ����� ��� �������
$TodayDate =  Get-Date -Format MM_dd_yyyy

#������ ������, ������� ����� ��������� ���� � �������������� ������ ��� �������
$ResultDir = @()

#C������� �������������� ����� ��� �������
ForEach ($DirForBackFile in $DirsForBakFiles) {
    $ResultDir +=  New-Item -Path "$DirForBackFile\$TodayDate" -ItemType Directory -Force -ErrorAction SilentlyContinue
}

#�������� � ������ �������������� ����� ������ SQL
ForEach ($Res in $ResultDir) {
    ForEach ($Backup in $BackupDirs) {
        Get-ChildItem -Path $Backup -File -Recurse | Where-Object {((get-date) - $_.LastWriteTime).Days -eq 1} | Copy-Item -Destination "$Res"
    }
}


#####################################################################################################################################################
#####################################################################################################################################################
### ����������� �����
#####################################################################################################################################################
#####################################################################################################################################################


#��������� ������ ���������� ������������ ��������� �����
$DirsForReserv = Get-Content "C:\Users\reznikmn.GKUNION\Desktop\MoveBackFiles\backupdirslist.txt"

#�������� ��� ��������� ����� � ����� � ������� ����� � ������ �������������� ������������


ForEach ($Res in $ResultDir) {
    ForEach ($DirForReserv in $DirsForReserv) {
        Copy-Item -Path $DirForReserv -Destination $Res -Force -Recurse
    }
}

#�������� ������ �������������� � ���������� ���������� �����������
#������ ����� �����������
$sender = "reznikmn@gkunion.ru"
#������ ����� ����������
$recipient = "reznikmn@gkunion.ru"
#������ ��� �������
$server = "mail.gkunion.ru"
#���������� ��������� ���������
$subject = "��������� �����������"
#��������� ���� ���������
$body = "��������� ����������� ������� ���������!!!"
#������� ��������� ������ System.Net.Mail.MailMessage, ���������������
#���������
$msg = New-Object System.Net.Mail.MailMessage $sender, $recipient,
$subject, $body
#������� ��������� ������ System.Net.Mail.SmtpClient, ���������������
#������� SMTP ��� ���������� ������� SMTP
$client = New-Object System.Net.Mail.SmtpClient $server
#��������� ��� � ������ ��� ����������� � ������� SMTP
$client.Credentials = New-Object System.Net.NetworkCredential "reznikmn@gkunion.ru",
"#thehichhickers42guidToThegalaxy7"
#�������� ���������
$client.Send($msg)