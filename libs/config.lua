--- Configuration table for managing package settings.
--- @class Config
--- @field config_file string: The name of the configuration file (default: "packages.lua").
--- @field dry_run boolean: Whether to perform a dry run without making changes (default: false).
local config = {
  config_file = "packages.lua",
  dry_run = true,
}

return config;
