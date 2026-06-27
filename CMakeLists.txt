# ============================================================
# third_party/CMakeLists.txt
# 独立的依赖管理项目。任意主程序按路径引用:
#   add_subdirectory(<third_party路径> ${CMAKE_BINARY_DIR}/third_party)
# 然后 link:  nlohmann_json::nlohmann_json / spdlog::spdlog / fastdds
# ============================================================
cmake_minimum_required(VERSION 3.16)

# 注册封装函数 tp_declare
include("${CMAKE_CURRENT_LIST_DIR}/AddDependency.cmake")

# 读取版本配置表并逐个拉取/构建
include("${CMAKE_CURRENT_LIST_DIR}/dependencies.cmake")
