# ============================================================
# dependencies.cmake  —— 依赖版本配置表 (单一数据源)
# 改库的版本 / 仓库 / 编译选项, 只动这个文件。
#   字段: REPO=GitHub 地址  TAG=版本号  OPTIONS=该库的 CMake 开关
# 源码会被 clone 到 third_party/<name>/
# ============================================================

# --- nlohmann_json: header-only JSON 库 ---
tp_declare(nlohmann_json
    REPO    https://github.com/nlohmann/json.git
    TAG     v3.11.3
    OPTIONS JSON_BuildTests=OFF
            JSON_Install=OFF
)

# --- spdlog: 高性能日志库 ---
tp_declare(spdlog
    REPO    https://github.com/gabime/spdlog.git
    TAG     v1.15.0
    OPTIONS SPDLOG_BUILD_EXAMPLE=OFF
            SPDLOG_BUILD_TESTS=OFF
            SPDLOG_INSTALL=OFF
)

# --- httplib: 轻量级 HTTP/HTTPS 客户端/服务端 (header-only) ---
# 注: HTTPS 需要 OpenSSL, 默认仅 HTTP。如需 HTTPS, 装好 OpenSSL 后
#     主程序加 -DHTTPLIB_REQUIRE_OPENSSL=ON 即可。
tp_declare(httplib
    REPO    https://github.com/yhirose/cpp-httplib.git
    TAG     v0.18.3
    OPTIONS HTTPLIB_INSTALL=OFF
)

# --- Cyclone DDS: Eclipse 开源 DDS 中间件 (C 库) ---
# 链接目标: CycloneDDS::ddsc
# 注: BUILD_IDLC=ON 提供 IDL 编译器与 idlc_generate() 宏, 用于从 .idl 生成类型代码。
#     如需 C++ 绑定 (ddscxx), 那是另一个仓库 cyclonedds-cxx, 依赖本库。
tp_declare(cyclonedds
    REPO    https://github.com/eclipse-cyclonedds/cyclonedds.git
    TAG     0.10.5
    OPTIONS BUILD_TESTING=OFF
            BUILD_EXAMPLES=OFF
            BUILD_IDLC=ON
            BUILD_DDSPERF=OFF
            ENABLE_SECURITY=OFF
)

