#!/bin/bash

# =================================================================
# NanoMQ ARM 一键构建脚本
# 作者: Antigravity
# 说明: 用于在 Linux 环境下交叉编译 NanoMQ 至 ARM 平台 (335x)
# =================================================================

# 1. 配置基础路径 (请根据实际环境修改)
SOURCE_DIR=$(pwd)
BUILD_DIR="${SOURCE_DIR}/build_arm"
TOOLCHAIN_FILE="${SOURCE_DIR}/arm_linux_toolchain.cmake"

echo ">>> 开始构建 NanoMQ (ARM 版本) <<<"
echo ">>> 源码路径: ${SOURCE_DIR}"
echo ">>> 构建路径: ${BUILD_DIR}"

# 2. 初始化子模块 (NanoMQ 依赖 NNG 等多个子模块)
if [ ! -f "nng/CMakeLists.txt" ]; then
    echo ">>> 检测到子模块未初始化，正在拉取..."
    git submodule update --init --recursive
    if [ $? -ne 0 ]; then
        echo "错误: 子模块更新失败，请检查网络连接。"
        exit 1
    fi
fi

# 3. 创建并进入构建目录
mkdir -p "${BUILD_DIR}"

# 4. 运行 CMake 配置
# -DCMAKE_TOOLCHAIN_FILE: 使用指定的交叉编译工具链文件
# -DNNG_ENABLE_QUIC=OFF: 嵌入式平台通常不需要 QUIC，关闭以减少依赖
# -DNNG_ENABLE_TLS=OFF:  如果不需要 SSL/TLS 加密，关闭可减小体积
# -DBUILD_NANOMQ_CLI=ON: 编译命令行工具 (pub/sub/conn 等)
echo ">>> 正在运行 CMake 配置..."
cmake -S . -B "${BUILD_DIR}" \
    -DCMAKE_TOOLCHAIN_FILE="${TOOLCHAIN_FILE}" \
    -DNNG_ENABLE_QUIC=OFF \
    -DNNG_ENABLE_TLS=OFF \
    -DBUILD_NANOMQ_CLI=ON \
    -DCMAKE_BUILD_TYPE=Release

if [ $? -ne 0 ]; then
    echo "错误: CMake 配置失败。"
    exit 1
fi

# 5. 执行编译
echo ">>> 正在编译..."
cmake --build "${BUILD_DIR}" -j $(nproc)

if [ $? -ne 0 ]; then
    echo "错误: 编译过程中出现问题。"
    exit 1
fi

echo ">>> 构建完成！ <<<"
echo ">>> 可执行文件路径: ${BUILD_DIR}/nanomq/nanomq"
echo ">>> CLI 工具路径:   ${BUILD_DIR}/nanomq_cli/nanomq_cli"
