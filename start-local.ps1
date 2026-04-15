$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$logsDir = Join-Path $repoRoot 'run-logs'
New-Item -ItemType Directory -Path $logsDir -Force | Out-Null

function Start-LoggedProcess {
    param(
        [string]$Name,
        [string]$FilePath,
        [string[]]$Arguments,
        [string]$WorkingDirectory
    )

    $stdout = Join-Path $logsDir "$Name.out.log"
    $stderr = Join-Path $logsDir "$Name.err.log"
    Remove-Item $stdout, $stderr -Force -ErrorAction SilentlyContinue

    $process = Start-Process -FilePath $FilePath `
        -ArgumentList $Arguments `
        -WorkingDirectory $WorkingDirectory `
        -RedirectStandardOutput $stdout `
        -RedirectStandardError $stderr `
        -PassThru

    [pscustomobject]@{
        Name = $Name
        Id = $process.Id
        Stdout = $stdout
        Stderr = $stderr
    }
}

function Wait-Port {
    param(
        [int]$Port,
        [int]$TimeoutSeconds = 60
    )

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    while ((Get-Date) -lt $deadline) {
        $tcp = Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | Where-Object { $_.LocalPort -eq $Port }
        if ($tcp) {
            return $true
        }
        Start-Sleep -Seconds 1
    }
    return $false
}


function Ensure-LocalDatabase {
    $mysql = 'C:\wamp64\bin\mysql\mysql8.4.7\bin\mysql.exe'
    $seedSql = Join-Path $repoRoot 'second_hand_trading.sql'

    if (-not (Test-Path $mysql) -or -not (Test-Path $seedSql)) {
        return
    }

    $dbCheck = & $mysql -uroot -N -e "SHOW DATABASES LIKE 'second_hand_trading';" 2>$null
    if ($dbCheck -match 'second_hand_trading') {
        Write-Host 'Database second_hand_trading already exists'
        return
    }

    Write-Host 'Importing second_hand_trading.sql ...'
    Get-Content $seedSql | & $mysql -uroot
}

function Start-LocalMySql {
    $mysqld = 'C:\wamp64\bin\mysql\mysql8.4.7\bin\mysqld.exe'
    $sourceIni = 'C:\wamp64\bin\mysql\mysql8.4.7\my.ini'
    $tempIni = Join-Path $repoRoot 'tmp-mysql-my.ini'

    if (-not (Test-Path $mysqld) -or -not (Test-Path $sourceIni)) {
        Write-Warning 'Local WAMP MySQL not found. Please start MySQL manually or set DB_* environment variables.'
        return $null
    }

    if (Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | Where-Object { $_.LocalPort -eq 3306 }) {
        Write-Host 'MySQL already listening on 3306'
        return $null
    }

    (Get-Content $sourceIni -Raw).Replace('[wampmysqld64]', '[mysqld]') | Set-Content $tempIni

    $mysqlProcess = Start-LoggedProcess -Name 'mysql' -FilePath $mysqld -Arguments @("--defaults-file=$tempIni", '--console') -WorkingDirectory $repoRoot
    if (-not (Wait-Port -Port 3306 -TimeoutSeconds 20)) {
        throw 'MySQL did not start on port 3306'
    }
    return $mysqlProcess
}

$mysqlProcess = Start-LocalMySql
Ensure-LocalDatabase

if (-not ((Wait-Port -Port 8761 -TimeoutSeconds 1) -or (Wait-Port -Port 8040 -TimeoutSeconds 1) -or (Wait-Port -Port 8080 -TimeoutSeconds 1))) {
    Push-Location $repoRoot
    try {
        & .\mvnw.cmd -f Server\pom.xml -DskipTests package | Out-Host
        if ($LASTEXITCODE -ne 0) { throw 'Server build failed' }
        & .\mvnw.cmd -f pom.xml -DskipTests package | Out-Host
        if ($LASTEXITCODE -ne 0) { throw 'Root build failed' }
    } finally {
        Pop-Location
    }
} else {
    Write-Host 'Detected running services, skip build step'
}

$javaArgs = @('--add-opens=java.base/java.lang=ALL-UNNAMED', '--add-opens=java.base/java.io=ALL-UNNAMED', '--add-opens=java.base/java.util=ALL-UNNAMED', '--add-opens=java.base/java.lang.reflect=ALL-UNNAMED', '--add-opens=java.base/java.text=ALL-UNNAMED', '--add-opens=java.desktop/java.awt.font=ALL-UNNAMED', '--add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED', '-jar')

$eureka = $null
if (-not (Wait-Port -Port 8761 -TimeoutSeconds 1)) {
    $eureka = Start-LoggedProcess -Name 'eureka-jar' -FilePath 'java' -Arguments ($javaArgs + (Join-Path $repoRoot 'eureka-server\target\eurekaServer-1.0-SNAPSHOT.jar')) -WorkingDirectory $repoRoot
    if (-not (Wait-Port -Port 8761 -TimeoutSeconds 30)) {
        throw 'Eureka server failed to start on port 8761'
    }
} else {
    Write-Host 'Eureka already listening on 8761'
}

$zuul = $null
if (-not (Wait-Port -Port 8040 -TimeoutSeconds 1)) {
    $zuul = Start-LoggedProcess -Name 'zuul-jar' -FilePath 'java' -Arguments ($javaArgs + (Join-Path $repoRoot 'zuul\target\serviceZuul-1.0-SNAPSHOT.jar')) -WorkingDirectory $repoRoot
    if (-not (Wait-Port -Port 8040 -TimeoutSeconds 30)) {
        throw 'Zuul failed to start on port 8040'
    }
} else {
    Write-Host 'Zuul already listening on 8040'
}

$server = $null
if (-not (Wait-Port -Port 8080 -TimeoutSeconds 1)) {
    $server = Start-LoggedProcess -Name 'server-jar' -FilePath 'java' -Arguments @('-jar', (Join-Path $repoRoot 'Server\target\server-1.0-SNAPSHOT.jar')) -WorkingDirectory $repoRoot
    if (-not (Wait-Port -Port 8080 -TimeoutSeconds 30)) {
        throw 'Server failed to start on port 8080'
    }
} else {
    Write-Host 'Server already listening on 8080'
}

$frontend = $null
if (-not (Wait-Port -Port 8081 -TimeoutSeconds 1)) {
    $frontend = Start-LoggedProcess -Name 'frontend-static' -FilePath 'python' -Arguments @('-m', 'http.server', '8081', '--bind', '127.0.0.1') -WorkingDirectory (Join-Path $repoRoot 'WebApp\dist')
    if (-not (Wait-Port -Port 8081 -TimeoutSeconds 15)) {
        throw 'Frontend failed to start on port 8081'
    }
} else {
    Write-Host 'Frontend already listening on 8081'
}

Write-Host ''
Write-Host 'Services started successfully:'
@($mysqlProcess, $eureka, $zuul, $server, $frontend) | Where-Object { $_ } | Format-Table -AutoSize
Write-Host ''
Write-Host 'URLs:'
Write-Host '  Eureka : http://localhost:8761'
Write-Host '  Zuul   : http://localhost:8040'
Write-Host '  Server : http://localhost:8080'
Write-Host '  WebApp : http://localhost:8081'
