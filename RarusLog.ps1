Set-ExecutionPolicy Bypass -Force

$DateOfStart = Read-Host "Введите дату и время начала поиска, в формате: ММ.ДД.ГГГГ мм:сс (10.03.2018 20:00)"

Write-Host "Идёт обработка входа, подождите..."
Get-EventLog -Log Security -After $DateOfStart  -EntryType SuccessAudit | where {$_.InstanceID -eq 4648 -and $_.Message -like "*1crarus*"} | Sort-Object -Descending | Format-Table @{Label="Время входа москалей"; Expression={$_.TimeGenerated}}

Write-Host "Идёт обработка выхода, подождите..."
Get-EventLog -Log Security -After $DateOfStart  -EntryType SuccessAudit | where {$_.InstanceID -eq 4634 -and $_.Message -like "*1crarus*"} | Sort-Object -Descending | Format-Table @{Label="Время выхода москалей"; Expression={$_.TimeGenerated}}


Write-Host "Нажмите любую клавишу, чтобы завершить программу."
$Host.UI.RawUI.ReadKey() > $Null