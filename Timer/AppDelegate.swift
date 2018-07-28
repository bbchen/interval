import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var lockScreenView: NSView!

    // Menu
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var resetOrStopItem: NSMenuItem!

    let rootItem: NSStatusItem
    var timer: Timer!
    let pomodoroTimer: PomodoroTimer
    var windows: [NSWindow]

    override init() {
        self.rootItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.timer = nil
        self.pomodoroTimer = PomodoroTimer.init()
        
        pomodoroTimer.switchTo(PomodoroTimer.Stage.Work, duration: 5)
        
        self.windows = []

        super.init()
    }
    
    func resetTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(update(timer:)),
                                     userInfo: nil,
                                     repeats: true)
    }

    @IBAction func resetOrStopTimerAction(_ sender: NSMenuItem) {
        if timer != nil && timer.isValid {
            stopAction(nil)
        } else {
            resetTimer()
        }
        
        updateMenu()
    }

    @IBAction func stopAction(_ sender: NSButton?) {
        stopTimer()
        updateMenu()
        
        for w in windows {
            w.setIsVisible(false)
        }
        rootItem.attributedTitle = NSAttributedString.init(string: "")
    }
    
    @IBAction func quitAction(_ sender: NSView) {
        let app = NSApplication.shared
        app.terminate(self)
    }

    func stopTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    func lockScreen(window: NSWindow, lock: Bool) {
        if lock {
            if window.contentView?.isInFullScreenMode != true {
                window.contentView?.enterFullScreenMode(window.screen!, withOptions: nil)
            }
            window.setIsVisible(true)
        } else {
            if window.contentView?.isInFullScreenMode == true {
                window.contentView?.exitFullScreenMode(options: nil)
            }
            window.setIsVisible(false)
        }
    }
    
    @objc func update(timer: Timer) {
        let now = Date.init()
        let newStage = pomodoroTimer.update(date: now)
        
        for w in windows {
            lockScreen(window: w, lock: newStage != .Work)
        }
        
        let seconds = pomodoroTimer.countDownTillNextStage(date: now)
        updateRootItem(seconds)
        
        label.stringValue = String.init(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        resetTimer()
        
        createLockWindows()

        rootItem.title = ""
        rootItem.menu = statusMenu
        
        updateMenu()
    }
    
    
    func createLockWindows() {
        self.windows = NSScreen.screens.map({ (s: NSScreen) -> NSWindow in
            let w = NSWindow.init(contentRect: NSMakeRect(0, 0, 200, 200),
                                  styleMask: .borderless,
                                  backing: .buffered,
                                  defer: true,
                                  screen: s)
            w.level = NSWindow.Level.screenSaver
            w.delegate = self
            return w
        })

        // https://blogs.wcode.org/2015/06/howto-create-a-locked-down-fullscreen-cocoa-application-and-implement-nslayoutconstraints-using-swift/
        for w in windows {
            if w.screen == NSScreen.main {
                if let view = lockScreenView {
                    lockScreenView.autoresizingMask = [.width, .height]
                    w.contentView?.addSubview(view)
                    view.frame = w.frame
                }
            }
            w.makeKeyAndOrderFront(nil)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func updateRootItem(_ seconds: Int) {
        let title = String.init(format: "%02d:%02d", seconds / 60, seconds % 60)
        rootItem.attributedTitle = Helper.monospaceMenuTitle(title)
        
        if let button = rootItem.button {
            var p = 0.0
            if timer.isValid {
                p = Double(seconds) / (pomodoroTimer.stage.rawValue * 60.0)
            }
            let image = Helper.makeClockImage(height: 18, progress: p)
            button.image = image
            button.alternateImage = image
        }
    }
    
    func updateMenu() {
        if timer != nil && timer.isValid {
            resetOrStopItem.title = "Stop Pomodoro"
        } else {
            resetOrStopItem.title = "Start Pomodoro"
        }
    }
}

