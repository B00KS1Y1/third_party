# ============================================================
# AddDependency.cmake
# 依赖管理核心: "本目录有就用, 没有就从 GitHub clone 到本目录"
#   tp_declare(<name> REPO <url> TAG <tag>
#              [SUBMODULES] [SUBDIR <子目录>] [OPTIONS k=v ...])
# 所有库源码常驻于 third_party/<name>, clone 一次后复用。
# ============================================================

# 依赖根目录 = 本文件所在目录 (即 third_party/), 库克隆于此
get_filename_component(TP_ROOT "${CMAKE_CURRENT_LIST_DIR}" ABSOLUTE)

function(tp_declare name)
    cmake_parse_arguments(D "SUBMODULES" "REPO;TAG;SUBDIR" "OPTIONS" ${ARGN})

    # --- 0. 启用开关: 主程序可用 -DTP_ENABLE_<name>=OFF 跳过某个库 ---
    option(TP_ENABLE_${name} "启用依赖 ${name}" ON)
    if(NOT TP_ENABLE_${name})
        message(STATUS "[deps] ${name}: 已禁用, 跳过")
        return()
    endif()

    set(src_dir "${TP_ROOT}/${name}")

    # --- 1. 检查本目录是否已存在有效副本 ---
    if(NOT EXISTS "${src_dir}/CMakeLists.txt")
        find_package(Git REQUIRED)

        # 支持镜像加速 (中国区直连 github 常卡): -DTP_GITHUB_MIRROR=https://gitee.com/mirrors/
        # 或 ghproxy: -DTP_GITHUB_MIRROR=https://ghfast.top/https://github.com/
        set(_repo "${D_REPO}")
        if(TP_GITHUB_MIRROR)
            string(REPLACE "https://github.com/" "${TP_GITHUB_MIRROR}" _repo "${D_REPO}")
        endif()
        message(STATUS "[deps] ${name}: 未找到, 从 ${_repo} @ ${D_TAG} 下载...")

        # 完整克隆 (保留 git 仓库与历史). 不捕获输出 -> 进度实时打印, 便于观察是否卡住。
        execute_process(
            COMMAND ${GIT_EXECUTABLE} clone --progress ${_repo} "${src_dir}"
            RESULT_VARIABLE _git_res)
        if(NOT _git_res EQUAL 0)
            file(REMOVE_RECURSE "${src_dir}")   # 失败时清理半成品, 避免坏缓存
            message(FATAL_ERROR "[deps] ${name} clone 失败 (网络/镜像问题?), 详见上方 git 输出")
        endif()

        execute_process(
            COMMAND ${GIT_EXECUTABLE} -C "${src_dir}" checkout ${D_TAG}
            RESULT_VARIABLE _co_res
            OUTPUT_VARIABLE _co_out ERROR_VARIABLE _co_out)
        if(NOT _co_res EQUAL 0)
            message(FATAL_ERROR "[deps] ${name} checkout ${D_TAG} 失败:\n${_co_out}")
        endif()

        # 需要子模块的库 
        if(D_SUBMODULES)
            execute_process(
                COMMAND ${GIT_EXECUTABLE} -C "${src_dir}"
                        submodule update --init --recursive
                RESULT_VARIABLE _sm_res)
            if(NOT _sm_res EQUAL 0)
                message(FATAL_ERROR "[deps] ${name} 子模块拉取失败")
            endif()
        endif()
    else()
        message(STATUS "[deps] ${name}: 使用已有副本 ${src_dir}")
    endif()

    # --- 2. 注入该库的 CMake 选项 (作为 cache 变量, 在 add_subdirectory 前生效) ---
    foreach(opt IN LISTS D_OPTIONS)
        string(REPLACE "=" ";" _kv "${opt}")
        list(GET _kv 0 _k)
        list(GET _kv 1 _v)
        set(${_k} "${_v}" CACHE INTERNAL "set by tp_declare(${name})" FORCE)
    endforeach()

    # --- 3. 加入构建 (SUBDIR 用于源码 CMakeLists 不在根目录的库) ---
    set(_add "${src_dir}")
    if(D_SUBDIR)
        set(_add "${src_dir}/${D_SUBDIR}")
    endif()
    # EXCLUDE_FROM_ALL: 只构建被主程序实际依赖到的目标, 不连带 examples 等
    add_subdirectory("${_add}" "${CMAKE_BINARY_DIR}/_deps/${name}-build" EXCLUDE_FROM_ALL)
endfunction()
