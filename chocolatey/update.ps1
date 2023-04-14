import-module au

$project = "crowdin/crowdin-cli"
$file = "crowdin-cli.zip"

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*url\s*=\s*)('.*')"          = "`$1'$($Latest.Url32)'"
      "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
      "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }
  }
}

function global:au_GetLatest {
  $releasePage = Invoke-WebRequest -UseBasicParsing -Uri "https://api.github.com/repos/$project/releases/latest"
  $latest = $releasePage.Content | ConvertFrom-Json
  $tag = $latest.tag_name
  $version = $tag -replace "v", ""
  $url = ($latest.assets | Where-Object -Property name -eq $file)[0].browser_download_url
  @{
    Version = $version
    Url32   = $url
  }
}

Update-Package -ChecksumFor 32