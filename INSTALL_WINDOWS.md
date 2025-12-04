# Windows에서 EXAONE-4.0-1.2B 설치 및 실행 가이드

## 빠른 시작

### 1. 필수 소프트웨어 설치

1. **Visual Studio 2019/2022** 또는 **Visual Studio Build Tools** 설치
   - [Visual Studio Community](https://visualstudio.microsoft.com/ko/vs/community/) (무료)
   - 또는 [Visual Studio Build Tools](https://visualstudio.microsoft.com/ko/downloads/#build-tools-for-visual-studio-2022)

2. **CMake** 설치
   - [CMake 다운로드](https://cmake.org/download/)
   - 설치 시 "Add CMake to the system PATH" 옵션 선택

3. **Git** 설치
   - [Git for Windows](https://git-scm.com/download/win)

### 2. 모델 다운로드

```cmd
# huggingface-cli 설치 (Python 필요)
pip install huggingface_hub

# 모델 다운로드
huggingface-cli download LGAI-EXAONE/EXAONE-4.0-1.2B-GGUF --include "EXAONE-4.0-1.2B-Q4_K_M.gguf" --local-dir ./models
```

### 3. 자동 빌드 및 실행

#### 방법 1: 배치 파일 사용 (권장)
```cmd
build_and_run.bat
```

#### 방법 2: PowerShell 스크립트 사용
```powershell
.\build_and_run.ps1
```

#### 방법 3: 수동 빌드
```cmd
# llama.cpp 빌드
cd llama.cpp
mkdir build
cd build
cmake .. -G "Visual Studio 17 2022" -A x64
cmake --build . --config Release
cd ../..

# 예제 빌드
mkdir build
cd build
cmake .. -G "Visual Studio 17 2022" -A x64 -DLLAMA_CURL=OFF -DLLAMA_METAL=OFF -DLLAMA_CUBLAS=OFF
cmake --build . --config Release
cd ..

# 실행
.\build\Release\run_exaone.exe
```

## 문제 해결

### 빌드 오류
- **Visual Studio 버전 오류**: `-G` 옵션을 사용 중인 Visual Studio 버전에 맞게 수정
- **CMake 오류**: CMake가 PATH에 추가되었는지 확인
- **라이브러리 오류**: llama.cpp가 먼저 빌드되었는지 확인

### 실행 오류
- **모델 파일 없음**: `models` 폴더에 모델 파일이 있는지 확인
- **DLL 오류**: `llama.dll`이 실행 파일과 같은 폴더에 있는지 확인
- **메모리 부족**: 더 작은 양자화 모델 사용 (Q4_K_S)

### 성능 최적화
- **GPU 가속**: CUDA 지원 llama.cpp 빌드 사용
- **메모리 최적화**: 적절한 양자화 모델 선택
- **배치 크기 조정**: `n_batch` 파라미터 조정

## 지원

- **llama.cpp**: https://github.com/ggerganov/llama.cpp
- **EXAONE-4.0**: https://huggingface.co/LGAI-EXAONE/EXAONE-4.0-1.2B-GGUF
- **기술 보고서**: https://arxiv.org/abs/2507.11407 