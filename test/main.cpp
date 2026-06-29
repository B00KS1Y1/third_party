// ============================================================
// main.cpp -- third_party dependency smoke test
// Touches spdlog / nlohmann_json to verify headers and linking.
// ============================================================
#include <iostream>

#include <dds/dds.h>
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

  // --- Cyclone DDS --- (创建并删除一个 participant, 验证头文件与链接)
  dds_entity_t participant =
      dds_create_participant(DDS_DOMAIN_DEFAULT, NULL, NULL);
  if (participant < 0) {
    spdlog::error("cyclonedds FAIL: {}", dds_strretcode(-participant));
    return 1;
  }
  dds_delete(participant);
  spdlog::info("cyclonedds OK: participant created and deleted");

  spdlog::info("All dependency tests passed");
  return 0;
}
