import ServiceManagement

/// Thin wrapper over `SMAppService.mainApp` for registering Boarder as a login item.
/// Registration only works when running from an app bundle (`make install`), not the debug binary.
enum LaunchAtLogin {
    static var isEnabled: Bool {
        SMAppService.mainApp.status == .enabled
    }

    static func setEnabled(_ enabled: Bool) throws {
        if enabled {
            try SMAppService.mainApp.register()
        } else {
            try SMAppService.mainApp.unregister()
        }
    }
}
