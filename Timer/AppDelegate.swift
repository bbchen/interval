import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var lockScreenView: NSView!
    @IBOutlet weak var imageView: NSImageView!

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
        self.pomodoroTimer = PomodoroTimer.init(config: PomodoroTimer.DEV)
        
        pomodoroTimer.switchTo(.Work)

        self.windows = []

        super.init()
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(update(timer:)),
                                     userInfo: nil,
                                     repeats: true)
    }

    func stopTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }

    @IBAction func backToWorkAction(_ sender: NSObject) {
        for w in windows {
            lockScreen(window: w, lock: false)
        }

        pomodoroTimer.switchTo(.Work)
        startTimer()

        updateMenu()
        rootItem.attributedTitle = NSAttributedString.init(string: "")
    }
    
    @IBAction func stopAction(_ sender: NSObject) {
        stopTimer()
        updateMenu()
        
        for w in windows {
            w.setIsVisible(false)
        }
        rootItem.attributedTitle = NSAttributedString.init(string: "")
    }
    
    @IBAction func startAction(_ sender: NSObject) {
        for w in windows {
            lockScreen(window: w, lock: false)
        }
        // pomodoroTimer.switchTo(.Work)
        
        pomodoroTimer.resume()
        startTimer()
    }
    
    @IBAction func resumeAction(_ sender: NSObject) {
        for w in windows {
            lockScreen(window: w, lock: false)
        }
        pomodoroTimer.resume()
        startTimer()
    }
    
    @IBAction func pauseAction(_ sender: NSObject) {
        for w in windows {
            lockScreen(window: w, lock: false)
        }
        pomodoroTimer.pause()
        stopTimer()
    }
    
    @IBAction func quitAction(_ sender: NSView) {
        let app = NSApplication.shared
        app.terminate(self)
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

        let oldStage = pomodoroTimer.stage
        let newStage = pomodoroTimer.update(date: now)
        
        if oldStage != newStage && newStage == .Work {
            stopTimer()
            return
        }
        
        for w in windows {
            lockScreen(window: w, lock: newStage != .Work)
        }
        
        let seconds = Int(pomodoroTimer.countDownTillNextStage(date: now))
        updateRootItem(seconds)
        
        updateLockScreen()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        startTimer()
        
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

    func updateLockScreen() {
        let seconds = Int(pomodoroTimer.remaining)
        label.attributedStringValue = Helper.monospaceDigitString(String.init(format: "%02d:%02d", seconds / 60, seconds % 60), size: 32.0)

        var p = 0.0
        if timer != nil && timer.isValid {
            p = pomodoroTimer.progress()
        }
        let image = Helper.makeClockImage(height: 48.0, progress: p)
        imageView.image = image
    }

    func updateRootItem(_ seconds: Int) {
        let title = String.init(format: "%02d:%02d", seconds / 60, seconds % 60)
        rootItem.attributedTitle = Helper.monospaceDigitStringForMenuBar(title)
        
        if let button = rootItem.button {
            var p = 0.0
            if timer != nil && timer.isValid {
                p = pomodoroTimer.progress()
            }
            let image = Helper.makeClockImage(height: 18, progress: p)
            button.image = image
            button.alternateImage = image
        }
    }

    func updateMenu() {
    }
}

