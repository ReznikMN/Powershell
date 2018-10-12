#$strComputer = Read-Host "Enter Computer Name"
$colSlots = Get-WmiObject -Class win32_PhysicalMemoryArray -namespace root\CIMV2 -computerName .
$colRAM = Get-WmiObject -Class win32_PhysicalMemory -namespace root\CIMV2 -computerName .


write-host "Общее количество слотов DIMM: " $colSlots.MemoryDevices
Foreach ($objRAM In $colRAM) {
     "Слот: " + $objRAM.DeviceLocator
     "Объем памяти: " + ($objRAM.Capacity / 1GB) + " GB"
}
Read-Host