# This rule installs the `setup-ninja` script to `/usr/local/bin` and makes it executable.
install:
	@echo "Installing lua files to /usr/local/share/setup-ninja..."
	@mkdir -p /usr/local/share/setup-ninja/
	@cp setup-ninja.lua /usr/local/share/setup-ninja/
	@cp -r libs /usr/local/share/setup-ninja/
	@echo "Installing setup-ninja to /usr/local/bin..."
	@cp setup-ninja /usr/local/bin/setup-ninja
	@chmod +x /usr/local/bin/setup-ninja
