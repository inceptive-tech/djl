@rem https://chocolatey.org/docs/installation#install-with-cmdexe
@rem to install rust java etc..
@rem choco install jdk17 -y

set VERSION="%1"

if exist "llama.cpp" (
    echo Found "llama.cpp"
) else (
    git clone https://github.com/ggerganov/llama.cpp.git -b %VERSION%
)

if exist build rd /q /s build
md build\classes
cd build
javac -classpath "%2" -sourcepath ..\src\main\java\ ..\src\main\java\ai\djl\llama\jni\LlamaLibrary.java -h include -d classes
cmake .. -DCMAKE_CUDA_COMPILER="nvcc" -DLLAMA_CUDA=ON -DOS_NAME="windows" -DOS_ARCH="x86_64" -DLLAMA_VERSION="%VERSION%"
cmake --build . --config Release

@rem for nightly ci
md jnilib\win-x86_64
copy Release\djl_llama.dll jnilib\win-x86_64\
copy bin\Release\llama.dll jnilib\win-x86_64\
