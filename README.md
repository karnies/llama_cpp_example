# EXAONE-4.0-1.2B-GGUF + llama.cpp C++ 예제 실행 가이드 (Windows)

이 문서는 EXAONE-4.0-1.2B-GGUF 모델을 llama.cpp 기반 C++ 예제(`run_exaone.cpp`)로 빌드하고 실행하는 방법을 안내합니다. (Windows 기준)

---

## 1. 사전 준비

### 1-1. 개발 환경 설치
- **Visual Studio 2019/2022** 또는 **Visual Studio Build Tools** 설치
- **CMake** 설치 (https://cmake.org/download/)
- **Git** 설치 (https://git-scm.com/download/win)

### 1-2. 모델 파일 준비
- [EXAONE-4.0-1.2B-GGUF](https://huggingface.co/LGAI-EXAONE/EXAONE-4.0-1.2B-GGUF) 모델을 다운로드하여 `./models/` 폴더에 저장하세요.
- 권장 모델:
  - `EXAONE-4.0-1.2B-Q4_K_M.gguf` (812 MB) - 메모리 효율적
  - `EXAONE-4.0-1.2B-Q8_0.gguf` (1.36 GB) - 더 나은 품질

다운로드 명령어:
```bash
# huggingface-cli 사용
huggingface-cli download LGAI-EXAONE/EXAONE-4.0-1.2B-GGUF --include "EXAONE-4.0-1.2B-Q4_K_M.gguf" --local-dir ./models

# 또는 수동으로 다운로드 후 models 폴더에 저장
```

---

## 2. 빌드 방법

### 2-1. llama.cpp 빌드 (Windows)

```bash
cd llama.cpp
mkdir build
cd build
cmake .. -G "Visual Studio 16 2019" -A x64
# 또는 Visual Studio 2022 사용시: cmake .. -G "Visual Studio 17 2022" -A x64

# 빌드 실행
cmake --build . --config Release
cd ../..
```

### 2-2. 예제(run_exaone.cpp) 빌드

먼저 `run_exaone.cpp` 파일의 모델 경로를 수정해야 합니다:

```cpp
// run_exaone.cpp 상단에서 모델 경로 수정
const char* model_path = "./models/EXAONE-4.0-1.2B-Q4_K_M.gguf";
```

그 다음 빌드:

```bash
# Visual Studio Developer Command Prompt에서 실행
cl /std:c++17 /I"./llama.cpp/include" /Fe:run_exaone.exe run_exaone.cpp /link /LIBPATH:"./llama.cpp/build/Release" llama.lib

# 또는 CMake 사용 (권장)
mkdir build_example
cd build_example
cmake .. -G "Visual Studio 16 2019" -A x64 -DLLAMA_CPP_DIR=../llama.cpp
cmake --build . --config Release
cd ..
```

---

## 3. 실행 방법

### 3-1. 환경 변수 설정 (필요시)

```cmd
set PATH=%PATH%;.\llama.cpp\build\Release
```

### 3-2. 실행

```cmd
# 빌드된 실행 파일 실행
.\run_exaone.exe
# 또는
.\build_example\Release\run_exaone.exe
```

---

## 4. EXAONE-4.0-1.2B 모델 특징

### 4-1. 모델 정보
- **파라미터 수**: 1.07B (임베딩 제외)
- **레이어 수**: 30
- **어텐션 헤드**: GQA with 32-heads and 8-KV heads
- **어휘 크기**: 102,400
- **컨텍스트 길이**: 65,536 토큰
- **지원 언어**: 한국어, 영어, 스페인어

### 4-2. 추천 설정
- **비추론 모드**: `temperature < 0.6`
- **추론 모드**: `temperature = 0.6`, `top_p = 0.95`
- **한국어 대화**: `temperature = 0.1` (코드 스위칭 방지)

---

## 5. 문제 해결

### 5-1. 빌드 오류
- **Visual Studio 버전 불일치**: `-G` 옵션을 사용 중인 Visual Studio 버전에 맞게 수정
- **라이브러리 경로 오류**: `llama.cpp/build/Release` 경로 확인
- **C++17 지원**: Visual Studio 2017 이상 필요

### 5-2. 실행 오류
- **모델 파일 없음**: `./models/` 폴더에 모델 파일이 있는지 확인
- **메모리 부족**: 더 작은 양자화 모델 사용 (Q4_K_M → Q4_K_S)
- **DLL 오류**: `llama.dll`이 PATH에 있는지 확인

### 5-3. 성능 최적화
- **GPU 가속**: CUDA 지원 llama.cpp 빌드 사용
- **메모리 최적화**: 적절한 양자화 모델 선택
- **배치 크기 조정**: `n_batch` 파라미터 조정

---

## 6. 추가 정보

- **llama.cpp 공식 문서**: https://github.com/ggerganov/llama.cpp
- **EXAONE-4.0 모델 정보**: https://huggingface.co/LGAI-EXAONE/EXAONE-4.0-1.2B-GGUF
- **기술 보고서**: https://arxiv.org/abs/2507.11407

---

## 7. 라이선스

EXAONE-4.0-1.2B는 EXAONE AI Model License Agreement 1.2 - NC 라이선스 하에 제공됩니다. 