#######################################################################
#
#  Author: Vinicius Calil        
#  Date:   2020-04-22
#
#  This script shows how to use PowerShell commands to access ADS.
#
#######################################################################


$FileName = "File-with-ADS.txt"
$DirName = "ADS-Test"
$PathDir = "$env:USERPROFILE\Documents"
$PathFile = "${PathDir}\${DirName}"
$FileContent = "This is the content of the file's main stream!"
$ADS1Name = "MyADS1"     
$ADS1Content = "This is the content of my NTFS Alternate Data Stream-ADS, named ${FileName}:${ADS1Name}." # This should be a STRING, because write method used to ADS1 requires an input STRING.
$ADS2Name = "BinaryProgram.exe"   
$ADS2Content = "C:\Windows\write.exe"  # This should be the Path and name of a (binary) program, because write method used to ADS 2 requires a file.

# Check if directory already exists.
if ((Test-Path "$PathFile") -eq $false) {
    New-Item -Path $PathFile -ItemType Directory
}

# Stop running if file already exists, to avoid unintentionally lost of data previously created by users.
if ((Test-Path "$PathFile\$FileName") -eq $true) {
    Write-Host "This program has stopped because there is already a file called $FileName in the path $PathName."
    Write-Host "this program will destroy the file content if it proceeds. Delete or rename it before run this program again."
    pause
    exit
}

# Create the file
New-Item -Path $PathFile -ItemType File -Name $FileName -Force 

# Fill the file (main unnamed stream).
Set-Content -Path  "${PathFile}\${FileName}" -Value $FileContent

# Show file contents
Write-Host ""
Write-Host "Initial (unnamed main stream) File Content:"
Get-Content -Path  "${PathFile}\${FileName}"

# Show other ways to fill the file (main unnamed stream).
"The NEW content of the old file's main stream!" >  "${PathFile}\${FileName}"     # Pipeline command '>' truncates the file contents.
"More appended data." >>  "${PathFile}\${FileName}"    # Pipeline command '>>'  appends the file contents.
Write-Host ""

# Show the new contents of the file
Write-Host "New (unnamed main stream) File Content:"
Get-Content -Path  "${PathFile}\${FileName}"

# Show the directory contents.
Write-Host ""
Write-Host "Initial Directory Content (viewed with 'dir' command):"
Get-ChildItem -Path "${PathFile}" 

# Show all streams in the file.
Write-Host ""
Write-Host "Initial File Content (viewed with 'Get-Item' command):"
Get-Item -Path "${PathFile}\${FileName}" -Stream '*' | Select -Property Stream, Length, PSChildName

# Fill the ADS 1 with a string
cmd "/c echo ""This is my first NTFS Alternate Data Stream-ADS, named ${$ADS1Name}."" > ${PathFile}\${FileName}:${ADS1Name}"
cmd "/c echo ... Now, this is just data been appended to my first ADS. >> ${PathFile}\${FileName}:${ADS1Name}"

# Show the content of the first ADS
Write-Host ""
Write-Host "Initial content of $ADS1Name"
Get-Content -Path "${PathFile}\${FileName}:${ADS1Name}"

# truncate the ADS 1 content
Set-Content -Path "${PathFile}\${FileName}" -Stream $ADS1Name -Value $ADS1Content
Add-Content -Path "$PathFile\${FileName}:$ADS1Name" -Value "More date appended to ${ADS1Name}."

# Show the content of the first ADS
Write-Host ""
Write-Host "New content of $ADS1Name"
type "${PathFile}\${FileName}:${ADS1Name}"

# Fill the ADS 2 with a binary program
cmd "/c type $ADS2Content > ${PathFile}\${FileName}:${ADS2Name}"

# Show the content of the first ADS
Write-Host ""
Write-Host "Content of $ADS2Name"
type "${PathFile}\${FileName}:${ADS2Name}"
    # cmd "/c more < ${PathFile}\${FileName}:${ADS2Name}" # This is an alternating way to see the content of the ADS 2.

# Execute the program saved in ADS 2
cmd.exe /c "wmic process call create '${PathFile}\${FileName}:${ADS2Name}'"








