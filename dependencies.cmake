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

