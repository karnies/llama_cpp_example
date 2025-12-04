@echo off
echo ========================================
echo EXAONE-4.0-1.2B-GGUF 빌드 및 실행 스크립트
echo ========================================

REM llama.cpp 빌드
echo.
echo 1. llama.cpp 빌드 중...
if not exist "llama.cpp\build" (
    mkdir llama.cpp\build
)
cd llama.cpp\build

REM Visual Studio 버전 확인 및 CMake 실행
cmake .. -G "Visual Studio 17 2022" -A x64
if errorlevel 1 (
    echo Visual Studio 2022를 찾을 수 없습니다. Visual Studio 2019로 시도합니다...
    cmake .. -G "Visual Studio 16 2019" -A x64
    if errorlevel 1 (
        echo CMake 구성 실패! Visual Studio가 설치되어 있는지 확인하세요.
        pause
        exit /b 1
    )
)

cmake --build . --config Release
if errorlevel 1 (
    echo llama.cpp 빌드 실패!
    pause
    exit /b 1
)

cd ..\..

REM 예제 빌드
echo.
echo 2. 예제 빌드 중...
if not exist "build" (
    mkdir build
)
cd build

cmake .. -G "Visual Studio 17 2022" -A x64
if errorlevel 1 (
    cmake .. -G "Visual Studio 16 2019" -A x64
    if errorlevel 1 (
        echo 예제 CMake 구성 실패!
        pause
        exit /b 1
    )
)

cmake --build . --config Release
if errorlevel 1 (
    echo 예제 빌드 실패!
    pause
    exit /b 1
)

cd ..

REM 모델 파일 확인
echo.
echo 3. 모델 파일 확인 중...
if not exist "models\EXAONE-4.0-1.2B-Q4_K_M.gguf" (
    echo 모델 파일이 없습니다!
    echo 다음 명령어로 다운로드하세요:
    echo huggingface-cli download LGAI-EXAONE/EXAONE-4.0-1.2B-GGUF --include "EXAONE-4.0-1.2B-Q4_K_M.gguf" --local-dir ./models
    echo.
    echo 또는 수동으로 다운로드하여 models 폴더에 저장하세요.
    pause
    exit /b 1
)

REM 실행
echo.
echo 4. 실행 중...
echo ========================================
.\build\Release\run_exaone.exe
echo ========================================

echo.
echo 실행 완료!
pause 