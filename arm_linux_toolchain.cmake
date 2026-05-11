# =================================================================
# NanoMQ ARM 交叉编译工具链配置文件 (CMake Toolchain File)
# 适用于: 335x-toolchain (arm-linux-gnueabihf)
# =================================================================

# 1. 设置目标操作系统和处理器架构
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)

# 2. 指定交叉编译工具链的根路径
set(TOOLCHAIN_PATH "/home/picohood/env/335x-toolchain")

# 3. 指定 C 和 C++ 编译器
# 这里的路径必须指向您解压后的工具链 bin 目录下的具体程序
set(CMAKE_C_COMPILER "${TOOLCHAIN_PATH}/bin/arm-linux-gnueabihf-gcc")
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_PATH}/bin/arm-linux-gnueabihf-g++")

# 4. 设置寻找库、头文件和程序的根目录
set(CMAKE_FIND_ROOT_PATH "${TOOLCHAIN_PATH}/arm-linux-gnueabihf")

# 5. 配置搜索行为 (非常重要)
# NEVER:  只在主机环境寻找 (通常用于寻找构建过程中需要的工具，如 flex, bison)
# ONLY:   只在交叉编译环境寻找 (用于寻找目标板运行所需的库和头文件)
# BOTH:   两者都找
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# 6. (可选) 设置一些全局编译标志
# 例如强制使用硬浮点或针对特定内核优化
# set(CMAKE_C_FLAGS "-mfloat-abi=hard -mcpu=cortex-a8" CACHE STRING "" FORCE)
