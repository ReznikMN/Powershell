Set-ExecutionPolicy Bypass -Force

$COMConnector=New-Object -ComObject "V83.Comconnector"
$hostname="192.168.221.26" # ip сервера кластера
$serv_agent=$COMConnector.ConnectAgent($hostname) # коннектимся агентом к кластеру
$cluster=($serv_agent.GetClusters())[0] # получаем объект кластера
$serv_agent.Authenticate($cluster,"","") # аутентифицируемся на кластере
$baseinfo=$serv_agent.GetInfoBases($cluster) # получаем список баз на кластере
$dropsesCOM=$serv_agent.GetInfoBaseSessions($cluster,$bases) #получаем список сеансов к базе
foreach($ses in $dropsesCOM){$serv_agent.terminateSession($cluster,$ses)} # удаляем найденные сессии


Get-Service -DisplayName '*1с*' | Stop-Service

Start-Sleep -Seconds 360

Get-Service -DisplayName '*1с*' | Start-Service

