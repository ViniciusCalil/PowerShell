# Alternate Data Stream
-------

The file "Create_Alternate_Data_Streams.ps1" is a Microsoft PowerShell script intended to provide a little knowledge and experience with Microsoft NTFS ADS.

It will:
  1) create a directory called "ADS-Test" inside the user's "Documents" folder;
  2) create a new file, called "File-with-ADS.txt", in the "ADS-Test" directory;
  3) fill the file's main stream, and show it;
  4) append more data to the file's main stream, and show it;
  5) show the "ADS-Test" directory contents;
  6) show the name of all file stream;
  7) create a new ADS called "myADS1" and fill it;
  8) append more data into "myADS1";
  9) show the contens of "myADS1";
  10) change the contents of "myADS1" and append more data;
  11) show the new contens of "myADS1";
  12) create a new ADS called "BinaryProgram.exe" and fill it with the binary content of the Windows WordPad application;
  13) show the contents of "BinaryProgram.exe";
  14) execute the content of "BinaryProgram.exe".

----------------------------------------
About ADS:
----------

The ADS - Alternate Data Stream is an exclusive resource of the Microsoft NTFS file system. It allows many data streams be saved into a single file.

If you open that file by normal methods (often used by most programs) only the file's main data stream is opened.

To access (create or read) an ADS, a special name format is required. But, even if you supply this special format name to common programs, they shall not access the ADS (neither the file).

To access ADS you may use a special program or use Microsoft PowerShell.

For more technical information see: https://docs.microsoft.com/en-us/windows/win32/fileio/file-streams .

----------------------------------------
Search for files with ADS:
--------------------------

To check all streams (ADS or file's main stream) present in a specific file, use the PowerShell command:

    Get-Item -Path "C:\Path\Directory_Name\File_Name" -Stream '*' | Select -Property Stream, Length, PSChildName


To check all streams (ADS or file's main stream) present in all files in a specific directory, use the PowerShell command:

    Get-Item -Path "C:\Path\Directory_Name\*" -Stream '*' | Select -Property Stream, Length, PSChildName
    
    
Using 'dir' command:
-------
To check if there is any ADS in a specific file, use the command: 

    'dir /R "specific_file_name" ' .

To check if there is any file with ADS in a specific directory, use the command:

    'dir /R "directory_name" | find ":$DATA" ' .

To check if there is any file with ADS in a specific directory subtree, use the command :

    'dir /R /S "directory_name" | find ":$DATA" ' . 
    
----------------------------------------
Interesting facts:
------------------

  *) if you delete a file with ADS and restore it from "$Recycle.Bin" all the ADS's will also be restored;
  
  *) if you compact the file and then extract it again, the ADS's shall not be restored; - even when compacting with Windows File Browser and "extracting" the file by copying from Windows File Browser, no ADS is restored -


Vinicius Calil, 2020-04-22
  
