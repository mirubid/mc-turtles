$destfolder = 'D:\Users\Public\minecraft\at\Instances\SkyFactory\saves\New World\computer\3'
#copy and remove .lua
ls src | %{cp "src\$_" "$destfolder\$($_.BaseName)"}