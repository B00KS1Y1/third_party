// ============================================================
// main.cpp -- third_party dependency smoke test
// Touches spdlog / nlohmann_json to verify headers and linking.
// ============================================================
#include <iostream>

#include <httplib.h>
#include <nlohmann/json.hpp>
#include <spdlog/spdlog.h>

using json = nlohmann::json;

int main() {
  // --- spdlog ---
  spdlog::info("spdlog OK: logging library linked");

  // --- nlohmann_json ---
  json j;
  j["lib"] = "nlohmann_json";
  j["ok"] = true;
  j["nums"] = {1, 2, 3};
  spdlog::info("nlohmann_json OK: {}", j.dump());

  // --- httplib --- (仅构造一个 client, 验证头文件与链接)
  httplib::Client cli("http://localhost");
  (void)cli;
  spdlog::info("httplib OK: version {}", CPPHTTPLIB_VERSION);

  spdlog::info("All dependency tests passed");
  return 0;
}
