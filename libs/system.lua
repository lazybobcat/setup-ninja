local config = require("libs.config")

local M = {}

--- Checks if a given command exists in the system's PATH.
--- @param command string: The name of the command to check.
--- @return boolean: Returns true if the command exists, false otherwise.
M.command_exists = function(command)
  local handle, error = io.popen("which " .. command .. " 2>/dev/null")
  if nil == handle then
    print("error")
    return false;
  end
  local result = handle:read("*a")
  handle:close()
  return result ~= ""
end


--- Executes a shell command with optional dry-run mode.
--- @param command string: The shell command to execute.
--- @return boolean: Returns true if the command was successful or if in dry-run mode, false otherwise.
M.execute_command = function(command)
  if config.dry_run then
    print("[DRY RUN] Would execute: " .. command)
    return true
  else
    local success = os.execute(command)
    return success == 0
  end
end

--- Reads the operating system release information from the "/etc/os-release" file.
--- @return string|nil The ID of the operating system if found, or nil if the file cannot be read or the ID is not present.
local function read_os_release()
  local file = io.open("/etc/os-release", "r")
  if not file then return nil end

  local content = file:read("*a")
  file:close()

  local id = content:match("ID=([^\n]*)")
  if id then
    id = id:gsub('"', '') -- Remove quotes
    return id
  end
  return nil
end


--- Detects the Linux distribution based on the contents of the os-release file.
--- @return "arch"|"debian"|"fedora"|nil
M.detect_distro = function()
  local os_id = read_os_release()
  if not os_id then return nil end

  if os_id == "arch" or os_id == "manjaro" then
    return "arch"
  elseif os_id == "ubuntu" or os_id == "debian" then
    return "debian"
  elseif os_id == "fedora" or os_id == "centos" or os_id == "rhel" then
    return "fedora"
  end

  return nil;
end

--- Prints a humorous message based on the detected Linux distribution.
--- @param distro string|nil: The detected Linux distribution.
M.print_distro_message = function(distro)
  local messages = {
    arch = "Ah, Arch Linux! The choice of the brave and the endlessly tinkering. Virginity intact!",
    debian = "Debian: The universal operating system. Stable, like your grandma's cooking!",
    fedora = "Fedora: Bleeding edge and stylish. You must love living on the edge!",
    default = "Unknown distro: Are you even on Linux?"
  }

  local message = messages[distro] or messages.default
  print(message)
end

return M;
