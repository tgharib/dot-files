https://github.com/oblitum/Interception?tab=readme-ov-file#driver-installation

The above steps are those recommended by the interception driver author. However, I have found that those steps work inconsistently and sometimes the dll stops being able to be loaded. I think it has something to do with being installed in the privileged location of system32\drivers.

To help with the dll issue, you can copy the following file in the zip archive to the directory that kanata starts from: Interception\library\x64\interception.dll.

E.g. if you start kanata from your Documents folder, put the file there:

C:\Users\my_user\Documents\
    kanata_wintercept.exe
    kanata.kbd
    interception.dll