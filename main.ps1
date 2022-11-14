$file = "C:\projects\exfil3.exe"
$ZipFilePath ="C:\projects\exfil3.zip"
$Token = Get-Content "creds.ini"

#LR-ToDo: Need to set it up so the token is read from an ini file
#This block is for the api request
#Need to put token in the double qoutes
$authorization = "Bearer " + $Token
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", $authorization)
$headers.Add("Dropbox-API-Arg", '{"path":"/Apps/LR-DE/exfil.zip", "mode": "add", "autorename": true, "mute": false}')
$headers.Add("Content-Type", 'application/octet-stream')

#If the file does not exist, download and zip it
if (-not(Test-Path -Path $file -PathType Leaf)) {
	try {
		Invoke-WebRequest -Uri "http://192.168.100.115/exfil3.exe" -OutFile $file
		Write-Host "File has been downloaded."
		Compress-Archive -LiteralPath $file -DestinationPath $ZipFilePath
		Write-Host "File has been zipped up."
	}
	catch {
		throw $_.Exception.Message
	}
}

#If the file exists then delete it and download it
else {
	Write-Host "File already exists. Now deleting file."
	Remove-Item $file
	Remove-Item $ZipFilePath
	Invoke-WebRequest -Uri "http://192.168.100.115/exfil3.exe" -OutFile $file
	Write-Host "File has been downloaded."
	Compress-Archive -LiteralPath $file -DestinationPath $ZipFilePath
	Write-Host "File has been zipped up."
}

#Uploads file to dropbox via api
Invoke-RestMethod -Uri https://content.dropboxapi.com/2/files/upload -Method Post -InFile $ZipFilePath -Headers $headers
#Remove files
Remove-Item $file
Remove-Item $ZipFilePath