cmake_minimum_required(VERSION 3.16)
project(exaone_example)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# llama.cpp 경로 설정
set(LLAMA_CPP_DIR "${CMAKE_SOURCE_DIR}/llama.cpp")

# llama.cpp 라이브러리 찾기
find_library(LLAMA_LIBRARY
    NAMES llama
    PATHS "${LLAMA_CPP_DIR}/build/Release"
          "${LLAMA_CPP_DIR}/build"
          "${LLAMA_CPP_DIR}/build/Debug"
    NO_DEFAULT_PATH
)

if(NOT LLAMA_LIBRARY)
    message(FATAL_ERROR "llama 라이브러리를 찾을 수 없습니다. llama.cpp를 먼저 빌드해주세요.")
endif()

# llama.h 헤더 파일 경로
set(LLAMA_INCLUDE_DIR "${LLAMA_CPP_DIR}/include")

# 실행 파일 생성
add_executable(run_exaone run_exaone.cpp)

# 헤더 파일 경로 설정
target_include_directories(run_exaone PRIVATE ${LLAMA_INCLUDE_DIR})

# 라이브러리 링크
target_link_libraries(run_exaone ${LLAMA_LIBRARY})

# Windows에서 DLL 복사 (필요시)
if(WIN32)
    add_custom_command(TARGET run_exaone POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${LLAMA_CPP_DIR}/build/Release/llama.dll"
        $<TARGET_FILE_DIR:run_exaone>
    )
endif()

# 빌드 후 모델 폴더 생성
add_custom_command(TARGET run_exaone POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_BINARY_DIR}/models"
    COMMENT "models 폴더 생성"
) 