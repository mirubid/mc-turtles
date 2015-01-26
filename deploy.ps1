$destfolder = 'D:\Users\Public\minecraft\at\Instances\SkyFactory\saves\New World\computer'
$dest_nums = (3,4)

function copyfiles{ 
param(
	[Parameter(ValueFromPipeline=$true)]
	$num
)

	ls -File src | %{
	write-host "src\$_" "$destfolder\$num\$($_.BaseName)"
	cp "src\$_" "$destfolder\$num\$($_.BaseName)"
	}
	ls -File src\api | %{
	write-host "$($_.FullName)" "$destfolder\$num\api\$($_.BaseName)"
	cp "$($_.FullName)" "$destfolder\$num\api\$($_.BaseName)"
	}
	ls -File src\test | %{
	write-host "$($_.FullName)" "$destfolder\$num\test\$($_.BaseName)"
	cp "$($_.FullName)" "$destfolder\$num\test\$($_.BaseName)"
	}
}
#copy and remove .lua
#ls src | %{cp "src\$_" "$destfolder\$($_.BaseName)"}

$dest_nums | %{$_ |copyfiles}