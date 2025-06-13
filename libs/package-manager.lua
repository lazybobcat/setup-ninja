local fs = require("libs.filesystem")
local sys = require("libs.system")
local config = require("libs.config")

local M = {}

local get_package_manager = function(distro)
  if distro == "arch" then
    if sys.command_exists("yay") then
      return "yay -S --needed"
    else
      return "sudo pacman -S --needed"
    end
  elseif distro == "debian" then
    return "sudo apt install -y"
  elseif distro == "fedora" then
    return "sudo dnf install -y"
  end
  return nil
end

-- Package management functions
local update_package_lists = function(distro)
  if config.dry_run then
    print("[DRY RUN] Would update package lists for " .. distro)
    return
  end

  print("Updating package lists...")
  if distro == "debian" then
    sys.execute_command("sudo apt update")
  elseif distro == "arch" then
    sys.execute_command("sudo pacman -Sy")
  elseif distro == "fedora" then
    sys.execute_command("sudo dnf check-update")
  else
    print("No update command defined for " .. distro)
  end
end

local load_packages = function(filename)
  if not fs.file_exists(filename) then
    error("Config file '" .. filename .. "' not found!")
  end

  local success, packages = pcall(dofile, filename)
  if not success then
    error("Error loading config file: " .. packages)
  end

  return packages
end

M.install_packages = function(distro)
  local package_manager = get_package_manager(distro)
  if not package_manager then
    error("No package manager found for " .. distro)
  end

  local packages = load_packages(config.config_file)

  update_package_lists(distro)

  print("")
  if config.dry_run then
    print("=== DRY RUN MODE - No packages will be installed ===")
    print("Package manager would be: " .. package_manager)
  else
    print("=== Installing packages ===")
    print("Using package manager: " .. package_manager)
  end
  print("")

  local install_count = 0
  local skip_count = 0

  -- Sort packages by name for consistent output
  local sorted_names = {}
  for name in pairs(packages) do
    table.insert(sorted_names, name)
  end
  table.sort(sorted_names)

  for _, name in ipairs(sorted_names) do
    local pkg_info = packages[name]
    local package_name = pkg_info[distro]

    if package_name then
      if config.dry_run then
        print(string.format("[DRY RUN] Would install: %s -> %s (%s)",
          name, package_name, pkg_info.description or ""))
        install_count = install_count + 1
      else
        print(string.format("Installing %s (%s)...", name, package_name))
        local cmd = package_manager .. " " .. package_name
        if sys.execute_command(cmd) then
          install_count = install_count + 1
        else
          print("  ⚠️  Failed to install " .. package_name)
        end
      end
    else
      print(string.format("  ⚠️  No package mapping found for %s on %s", name, distro))
      skip_count = skip_count + 1
    end
  end

  print("")
  print("=== Summary ===")
  if config.dry_run then
    print("Would install: " .. install_count .. " packages")
  else
    print("Installed: " .. install_count .. " packages")
  end
  if skip_count > 0 then
    print("Skipped: " .. skip_count .. " packages")
  end
end

return M
