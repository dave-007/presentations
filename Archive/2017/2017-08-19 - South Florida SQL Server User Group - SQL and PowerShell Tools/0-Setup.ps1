#Setup
New-Item -ItemType Directory -Path c:\sqlpsscripts
Set-Location c:\sqlpsscripts
#Remove-Item C:\sqlpsscripts\transcript.log 
Start-Transcript -Path C:\sqlpsscripts\transcript2.log


#Cleanup
Stop-Transcript
notepad C:\sqlpsscripts\transcript.log