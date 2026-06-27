# ============================================================
# test/CMakeLists.txt
# 验证 third_party 依赖管理是否工作: 拉取/构建/链接三个库。
# 单独构建:  cmake -S . -B build && cmake --build build
# ============================================================
cmake_minimum_required(VERSION 3.16)
project(third_party_test LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 引用上一级的依赖管理项目 (test 在 third_party/test/, 故为 ..)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/.. ${CMAKE_BINARY_DIR}/third_party)

add_executable(tp_test main.cpp)

target_link_libraries(tp_test PRIVATE
    nlohmann_json::nlohmann_json
    spdlog::spdlog
)
