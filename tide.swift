import AppKit

class AppController : NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem?
    var timer: Timer?
    var targetDate: Date?

    func applicationDidFinishLaunching(_ n: Notification) {
        let s = NSStatusBar.system()
        let item = s.statusItem(withLength: NSVariableStatusItemLength)
        self.statusItem = item
        if let button = item.button {
            button.title = "Tide"
        }
        let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "25 minutes", action: #selector(start(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "5 minutes", action: #selector(start(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Cancel", action: #selector(cancel), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))

        item.menu = menu
        update()
    }

    func cancel(_ item: NSMenuItem?) {
        timer?.invalidate()
        timer = nil
        targetDate = nil
        update()
    }

    func quit() {
        let app = NSApp
        app?.terminate(self)
    }

    func start(_ item: NSMenuItem?) {
        timer?.invalidate()
        timer = nil

        if let title = item?.title {
            let t: Int = {
                switch (title) {
                case "25 minutes":
                    return 25
                case "5 minutes":
                    return 5
                default:
                    NSLog("Unknown menu item")
                    return 5
                }
            }()

            targetDate = Date.init(timeIntervalSinceNow: (Double(t * 60)))

            timer = Timer.scheduledTimer(timeInterval: 1, // fires every second
                                         target: self,
                                         selector: #selector(update),
                                         userInfo: nil,
                                         repeats: true)
            update()
        }
    }

    func update() {
        let now = Date.init()
        if let d = targetDate?.timeIntervalSince(now) {
            let di = Int(d)
            let m  = di / 60
            let s  = di % 60
            let ss: String = { if (s < 10) { return "0\(s)" } else { return "\(s)" } }()

            if (d > 0) {
                if let button = statusItem?.button {
                    button.title = "\(m):\(ss)"
                }
            } else {

                timer?.invalidate()
                timer = nil
                if let button = statusItem?.button {
                    button.title = "Tide"
                }

                utter("Hello, your time is up")
            }
        } else {
            timer?.invalidate()
            timer = nil
            if let button = statusItem?.button {
                button.title = "Tide"
            }
        }
    }

    func utter(_ t: String) {
        let synthesizer = NSSpeechSynthesizer.init(voice: "com.apple.speech.synthesis.voice.Alex")
        synthesizer?.startSpeaking(t)
    }

    func applicationWillTerminate(_ n: Notification) {
    }
}

NSApplication.shared()

let controller = AppController()
NSApp.delegate = controller

NSApp.run()
