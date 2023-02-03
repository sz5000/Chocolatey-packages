import-module au

function global:au_GetLatest {
   $Repo = 'https://github.com/TheJoeFin/Text-Grab'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $URL32 = $Release.Assets | Where-Object {$_.FileName -match '\.zip$'} | Select-Object -First 1 -ExpandProperty DownloadURL

   return @{ 
      Version = $version
      URL32   = $URL32
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "(^- Version:).*"     = "`${1} $($Latest.Version)"
            "(^- URL:).*"     = "`${1} $($Latest.URL32)"
            "(^- SHA256+:).*" = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading RBTray $($Latest.Version) zip files"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
