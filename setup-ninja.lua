#!/usr/bin/env lua

local version = "1.0.1"

local sys = require("libs.system")
local pm = require("libs.package-manager")
local config = require("libs.config")

local function parse_arguments(args)
  local i = 1
  while i <= #args do
    local arg = args[i]
    if arg == "--dry-run" then
      config.dry_run = true
    elseif arg == "--config" then
      i = i + 1
      if i <= #args then
        local cwd = io.popen("pwd"):read("*l")       -- Get current working directory
        if args[i]:sub(1, 1) == "/" or args[i]:sub(1, 2) == "~/" then
          config.config_file = args[i]               -- Use the absolute path directly
        else
          config.config_file = cwd .. "/" .. args[i] -- Prepend cwd to config file path
        end
      else
        error("--config requires a filename")
      end
    elseif arg == "--help" or arg == "-h" then
      print("Usage: setup-ninja [--dry-run] [--config CONFIG_FILE]")
      print("Options:")
      print("  --dry-run          Show what would be installed without actually installing")
      print("  --config FILE      Use specified config file (default: packages.lua)")
      print("  --help, -h         Show this help message")
      print("  --version, -v      Show the script version")
      os.exit(0)
    elseif arg == "--version" or arg == "-v" then -- Handle version option
      print("Setup Ninja version " .. version)
      os.exit(0)
    else
      error("Unknown option: " .. arg .. "\nUse --help for usage information")
    end
    i = i + 1
  end
end

local function confirm_installation()
  io.write("Continue? (y/N): ")
  local response = io.read()
  return response and (response:lower() == "y" or response:lower() == "yes")
end

-- Main execution
local function main()
  -- Get the distro and greet the user
  local distro = sys.detect_distro()
  if nil == distro then
    print("Error: Unknown or unsupported distribution!")
    print("Supported distributions: Arch Linux, Debian, Ubuntu")
    os.exit(1)
  end

  -- Parse command line arguments
  local success, err = pcall(parse_arguments, arg)
  if not success then
    print("Error: " .. err)
    os.exit(1)
  end

  local useless_logo = "\
███████╗███████╗████████╗██╗   ██╗██████╗     ███╗   ██╗██╗███╗   ██╗     ██╗ █████╗ \
██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗    ████╗  ██║██║████╗  ██║     ██║██╔══██╗\
███████╗█████╗     ██║   ██║   ██║██████╔╝    ██╔██╗ ██║██║██╔██╗ ██║     ██║███████║\
╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝     ██║╚██╗██║██║██║╚██╗██║██   ██║██╔══██║\
███████║███████╗   ██║   ╚██████╔╝██║         ██║ ╚████║██║██║ ╚████║╚█████╔╝██║  ██║\
╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝         ╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚════╝ ╚═╝  ╚═╝\
"
  print(useless_logo)
  sys.print_distro_message(distro)

  print("Config file: " .. config.config_file)

  print("")
  if not confirm_installation() then
    print("Aborted.")
    os.exit(0)
  end

  success, err = pcall(pm.install_packages, distro)
  if not success then
    print("Error: " .. err)
    os.exit(1)
  end
end


main()
