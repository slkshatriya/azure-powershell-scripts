param(
    [string]$InputMessage = "Default message",
    [string]$Environment = "Production"
)

Write-Output "=== PowerShell Script Execution Started ==="
Write-Output "Timestamp: $(Get-Date)"
Write-Output "Input Message: $InputMessage"
Write-Output "Environment: $Environment"

try {
    
    $processedData = $InputMessage.ToUpper()
    
    $result = @{
        Status = "Success"
        OriginalMessage = $InputMessage
        ProcessedMessage = $processedData
        ExecutionTime = Get-Date
        Environment = $Environment
    }
    
    Write-Output "Processing completed successfully"
    Write-Output "Result: $($result | ConvertTo-Json)"
    
    return $result
}
catch {
    Write-Output "Error: $($_.Exception.Message)"
    throw
}
