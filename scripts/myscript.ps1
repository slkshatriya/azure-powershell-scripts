param(
    [string]$ComputerName,
    #[string]$ServerName = $env:COMPUTERNAME,
    [int]$ThresholdGB = 10
)

# Micro Bot: Check Disk Space
$healthData = @()

#Write-Output "Checking disk space for server: $ComputerName"
try {
    $diskInfo = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
        $freeSpaceGB = [math]::Round($_.FreeSpace / 1GB, 2)
        $totalSpaceGB = [math]::Round($_.Size / 1GB, 2)
        $usedSpaceGB = [math]::Round(($_.Size - $_.FreeSpace) / 1GB, 2)
        $freeSpacePercent = [math]::Round(($_.FreeSpace / $_.Size) * 100, 2)
        
        $status = if ($freeSpaceGB -lt $ThresholdGB) { "CRITICAL" } else { "OK" }
        
        $healthData += [pscustomobject]@{
            Server = $ComputerName
            Category = "DiskSpace"
            Item = "Drive $($_.DeviceID)"
            Value = "$freeSpaceGB GB Free ($freeSpacePercent%)"
            Status = $status
            Details = "Total: $totalSpaceGB GB, Used: $usedSpaceGB GB, Free: $freeSpaceGB GB, Threshold: $ThresholdGB GB"
            Time = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        }
        
    }
    
    # Return as JSON
    $healthData | ConvertTo-Json -Depth 3
    
} catch {
    $errorData = @([pscustomobject]@{
        Server = $ComputerName
        Category = "DiskSpace"
        Item = "Error"
        Value = "Failed to retrieve disk information"
        Status = "ERROR"
        Details = $_.Exception.Message
        Time = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    })
    
    #Write-Output "ERROR: Failed to check disk space - $($_.Exception.Message)"
    $errorData | ConvertTo-Json -Depth 3

}
