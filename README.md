# EXAONE-Deep-2.4B-GGUF + llama.cpp C++ 예제 실행 가이드

이 문서는 EXAONE-Deep-2.4B-GGUF 모델을 llama.cpp 기반 C++ 예제(`run_exaone.cpp`)로 빌드하고 실행하는 방법을 안내합니다. (macOS M1/M2 기준)

---

## 1. 사전 준비

### 1-1. 의존성 설치
- CMake, gcc/g++, make, git 필요
- Homebrew로 설치 예시:

```bash
brew install cmake make git
```

### 1-2. 모델 파일 준비
- [EXAONE-Deep-2.4B-GGUF](https://huggingface.co/EXAONE/EXAONE-Deep-2.4B-GGUF) 모델을 다운로드하여 `./models/` 폴더에 저장하세요.
- 예시:
  - `EXAONE-Deep-2.4B-Q8_0.gguf`
  - `EXAONE-Deep-2.4B-BF16.gguf`

---

## 2. 빌드 방법

### 2-1. llama.cpp 빌드

```bash
cd llama.cpp
mkdir build && cd build
cmake ..
make -j
cd ../..
```

### 2-2. 예제(run_exaone.cpp) 빌드

```bash
g++ -std=c++11 -I./llama.cpp/include -L./llama.cpp/build -lllama -o run_exaone run_exaone.cpp
```

- 만약 라이브러리 경로가 다르거나, `libllama.dylib`이 다른 위치에 있다면 `-L` 옵션을 조정하세요.

---

## 3. 실행 방법

### 3-1. 환경 변수 설정 (필요시)

```bash
export DYLD_LIBRARY_PATH=./llama.cpp/build:$DYLD_LIBRARY_PATH
```

### 3-2. 실행

```bash
./run_exaone
```

- 실행 전, `run_exaone.cpp` 내 `model_path`가 실제 모델 파일 경로와 일치하는지 확인하세요.
- BF16 모델 사용 시 메모리 부족이 발생할 수 있습니다. (M1/M2 16GB 이상 권장)

---

## 4. 주요 옵션 및 참고 사항

- `n_predict` 값(생성 토큰 수)은 코드에서 직접 수정 가능합니다.
- 프롬프트 및 OCR 결과는 코드 상단에서 수정할 수 있습니다.
- Q8_0 모델은 메모리 사용량이 적고, BF16은 더 많은 메모리를 요구합니다.
- 오류 발생 시 assert 메시지, 메모리 부족 경고 등을 참고하세요.

---

## 5. 기타

- llama.cpp 최신 버전과 호환되지 않을 경우, include/library 경로를 맞춰주세요.
- 추가 문의: [EXAONE Huggingface](https://huggingface.co/EXAONE) 