PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin

.PHONY: all build install install-nix clean test

all: build

build:
	go build -ldflags="-s -w" -o bin/keychron-battery ./cmd/keychron-battery

install: build
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 bin/keychron-battery $(DESTDIR)$(BINDIR)/keychron-battery
	@if [ -d /etc/udev/rules.d ]; then \
		install -m 644 50-keychron.rules /etc/udev/rules.d/50-keychron.rules; \
		udevadm control --reload-rules && udevadm trigger; \
	fi

install-nix: build
	install -d $(HOME)/.local/bin $(HOME)/.config/systemd/user
	install -m 755 bin/keychron-battery $(HOME)/.local/bin/keychron-battery
	install -m 644 keychron-battery.service $(HOME)/.config/systemd/user/keychron-battery.service
	systemctl --user daemon-reload
	systemctl --user enable --now keychron-battery.service

clean:
	rm -rf bin/

test:
	go test -v ./...
