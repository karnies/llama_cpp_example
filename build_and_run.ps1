# EXAONE-4.0-1.2B-GGUF 빌드 및 실행 스크립트 (PowerShell)
Write-Host "========================================" -ForegroundColor Green
Write-Host "EXAONE-4.0-1.2B-GGUF 빌드 및 실행 스크립트" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

# llama.cpp 빌드
Write-Host "`n1. llama.cpp 빌드 중..." -ForegroundColor Yellow
if (-not (Test-Path "llama.cpp\build")) {
    New-Item -ItemType Directory -Path "llama.cpp\build" -Force
}

Push-Location "llama.cpp\build"

# Visual Studio 버전 확인 및 CMake 실행
$cmakeSuccess = $false

# Visual Studio 2022 시도
try {
    cmake .. -G "Visual Studio 17 2022" -A x64
    if ($LASTEXITCODE -eq 0) {
        $cmakeSuccess = $true
        Write-Host "Visual Studio 2022로 CMake 구성 완료" -ForegroundColor Green
    }
} catch {
    Write-Host "Visual Studio 2022를 찾을 수 없습니다. Visual Studio 2019로 시도합니다..." -ForegroundColor Yellow
}

# Visual Studio 2019 시도
if (-not $cmakeSuccess) {
    try {
        cmake .. -G "Visual Studio 16 2019" -A x64
        if ($LASTEXITCODE -eq 0) {
            $cmakeSuccess = $true
            Write-Host "Visual Studio 2019로 CMake 구성 완료" -ForegroundColor Green
        }
    } catch {
        Write-Host "CMake 구성 실패! Visual Studio가 설치되어 있는지 확인하세요." -ForegroundColor Red
        Pop-Location
        Read-Host "계속하려면 아무 키나 누르세요"
        exit 1
    }
}

# 빌드 실행
cmake --build . --config Release
if ($LASTEXITCODE -ne 0) {
    Write-Host "llama.cpp 빌드 실패!" -ForegroundColor Red
    Pop-Location
    Read-Host "계속하려면 아무 키나 누르세요"
    exit 1
}

Pop-Location

# 예제 빌드
Write-Host "`n2. 예제 빌드 중..." -ForegroundColor Yellow
if (-not (Test-Path "build")) {
    New-Item -ItemType Directory -Path "build" -Force
}

Push-Location "build"

# 예제 CMake 구성
$exampleCmakeSuccess = $false

try {
    cmake .. -G "Visual Studio 17 2022" -A x64
    if ($LASTEXITCODE -eq 0) {
        $exampleCmakeSuccess = $true
    }
} catch {
    try {
        cmake .. -G "Visual Studio 16 2019" -A x64
        if ($LASTEXITCODE -eq 0) {
            $exampleCmakeSuccess = $true
        }
    } catch {
        Write-Host "예제 CMake 구성 실패!" -ForegroundColor Red
        Pop-Location
        Read-Host "계속하려면 아무 키나 누르세요"
        exit 1
    }
}

# 예제 빌드
cmake --build . --config Release
if ($LASTEXITCODE -ne 0) {
    Write-Host "예제 빌드 실패!" -ForegroundColor Red
    Pop-Location
    Read-Host "계속하려면 아무 키나 누르세요"
    exit 1
}

Pop-Location

# 모델 파일 확인
Write-Host "`n3. 모델 파일 확인 중..." -ForegroundColor Yellow
if (-not (Test-Path "models\EXAONE-4.0-1.2B-Q4_K_M.gguf")) {
    Write-Host "모델 파일이 없습니다!" -ForegroundColor Red
    Write-Host "다음 명령어로 다운로드하세요:" -ForegroundColor Yellow
    Write-Host "huggingface-cli download LGAI-EXAONE/EXAONE-4.0-1.2B-GGUF --include `"EXAONE-4.0-1.2B-Q4_K_M.gguf`" --local-dir ./models" -ForegroundColor Cyan
    Write-Host "`n또는 수동으로 다운로드하여 models 폴더에 저장하세요." -ForegroundColor Yellow
    Read-Host "계속하려면 아무 키나 누르세요"
    exit 1
}

# 실행
Write-Host "`n4. 실행 중..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Green
& ".\build\Release\run_exaone.exe"
Write-Host "========================================" -ForegroundColor Green

Write-Host "`n실행 완료!" -ForegroundColor Green
Read-Host "계속하려면 아무 키나 누르세요" 