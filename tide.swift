import AppKit

class AppController : NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ n: Notification) {
        let app = NSApp
        let s = NSStatusBar.system()
        let item = s.statusItem(withLength: NSVariableStatusItemLength)
        self.statusItem = item
        if let button = item.button {
            button.title = "Tide"
        }
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(app?.terminate(_:)), keyEquivalent: "q"))

        item.menu = menu
    }

    func applicationWillTerminate(_ n: Notification) {
    }
}

NSApplication.shared()

let controller = AppController()
NSApp.delegate = controller

NSApp.run()
