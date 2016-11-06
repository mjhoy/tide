import AppKit

class AppController : NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem?
    var timer: Timer?
    var targetDate: Date?

    func applicationDidFinishLaunching(_ n: Notification) {
        let app = NSApp
        let s = NSStatusBar.system()
        let item = s.statusItem(withLength: NSVariableStatusItemLength)
        self.statusItem = item
        if let button = item.button {
            button.title = "Tide"
        }
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "25 minutes", action: #selector(start(_:)), keyEquivalent: "q"))
        menu.addItem(NSMenuItem(title: "5 minutes", action: #selector(start(_:)), keyEquivalent: "q"))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(app?.terminate(_:)), keyEquivalent: "q"))

        item.menu = menu
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
                                         selector: #selector(fire),
                                         userInfo: nil,
                                         repeats: true)
            fire()
        }

    }

    func fire() {
        let now = Date.init()
        if let d = targetDate?.timeIntervalSince(now) {
            let di = Int(d)

            if (d > 0) {
                if let button = statusItem?.button {
                    button.title = "\(di)"
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
