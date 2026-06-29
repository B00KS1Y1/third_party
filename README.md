# third_party — 独立依赖管理项目

一个独立、可复用的 C++ 依赖管理模块。任何项目都能引用它：按配置指定库版本，
构建时自动检查源码是否已存在，不存在则从 GitHub 克隆。下载的库源码集中存放，
多个项目共享同一份。

## 用法

这是独立目录，主程序通过 `add_subdirectory` 引用它的**绝对/相对路径**，并指定
一个构建输出目录。建议用变量记录 third_party 的位置：

```cmake
# 指向 third_party 项目所在位置（按你的实际路径改）
set(THIRD_PARTY_DIR "E:/Cpp/Project/third_party" CACHE PATH "依赖管理目录")

add_subdirectory(${THIRD_PARTY_DIR} ${CMAKE_BINARY_DIR}/third_party)

target_link_libraries(your_app PRIVATE
    nlohmann_json::nlohmann_json
    spdlog::spdlog
)
```

> 只链接你需要的库即可，未链接的库不会被编译（`EXCLUDE_FROM_ALL`）。

## 改版本 / 加库

只编辑 `dependencies.cmake`：

```cmake
tp_declare(<名称>
    REPO    <GitHub 地址>
    TAG     <版本 tag>
    OPTIONS 该库的CMake开关=值 ...
)
```

- 源码克隆到 `third_party/<名称>/`，克隆一次后复用。
- 想升级版本：改 `TAG`，删掉对应的 `third_party/<名称>/` 目录，重新 cmake 配置即可。
- 按需禁用某个库：主程序加 `-DTP_ENABLE_<名称>=OFF`，该库既不下载也不构建。

## 当前依赖

| 库 | 版本 | 链接目标 |
|---|---|---|
| nlohmann_json | v3.11.3 | `nlohmann_json::nlohmann_json` |
| spdlog | v1.15.0 | `spdlog::spdlog` |
| httplib | v0.18.3 | `httplib::httplib` |
| Cyclone DDS | 0.10.5 | `CycloneDDS::ddsc` |

## 文件说明

| 文件 | 作用 |
|---|---|
| `CMakeLists.txt` | 统一入口 |
| `dependencies.cmake` | 版本配置表（单一数据源） |
| `AddDependency.cmake` | `tp_declare` 函数：检查/下载/构建 |

## 注意

- 首次配置会从 GitHub 克隆, Cyclone DDS 较大, 需要网络通畅。
- 需要本机安装 `git`。
- Cyclone DDS 默认开启 `BUILD_IDLC=ON`, 提供 IDL 编译器与 `idlc_generate()`；
  不需要从 `.idl` 生成代码时可在主程序加 `-DBUILD_IDLC=OFF`。
