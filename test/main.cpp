// ============================================================
// main.cpp -- third_party dependency smoke test
// Touches spdlog / nlohmann_json to verify headers and linking.
// ============================================================
#include <iostream>

#include <spdlog/spdlog.h>
#include <nlohmann/json.hpp>

using json = nlohmann::json;

int main()
{
    // --- spdlog ---
    spdlog::info("spdlog OK: logging library linked");

    // --- nlohmann_json ---
    json j;
    j["lib"] = "nlohmann_json";
    j["ok"] = true;
    j["nums"] = {1, 2, 3};
    spdlog::info("nlohmann_json OK: {}", j.dump());

    spdlog::info("All dependency tests passed");
    return 0;
}
