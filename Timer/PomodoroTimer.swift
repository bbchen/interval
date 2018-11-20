import Foundation

class PomodoroTimer {
    enum Stage: TimeInterval {
        case Work = 25.0, ShortBreak = 5.0, LongBreak = 15.0
    }

    private(set) var since: Date?
    private var secondsTillNextStage: Double
    private(set) var stage: Stage
    private(set) var workCount: Int
    private(set) var remaining: TimeInterval
    
    init() {
        since = Date.init()
        stage = .Work
        secondsTillNextStage = stage.rawValue * 60.0
        remaining = 0
        workCount = 0
    }
    
    func pause() {
        self.since = nil
    }
    
    func resume() {
        self.since = Date.init()
    }
    
    func switchTo(_ stage: Stage, duration: Double) {
        self.stage = stage
        self.secondsTillNextStage = duration
        self.remaining = stage.rawValue * 60.0
    }
    
    func switchTo(_ stage: Stage) {
        self.stage = stage
        self.since = Date.init()
        self.remaining = stage.rawValue * 60.0
        self.secondsTillNextStage = stage.rawValue * 60.0
    }
    
    func update(date: Date) -> Stage {
        self.remaining -= date.timeIntervalSince(since!)
        self.since = Date.init()

        if (remaining <= 0.0) {
            switch stage {
            case .Work:
                workCount += 1
                if workCount == 4 {
                    switchTo(Stage.LongBreak)
                    workCount = 0
                } else {
                    switchTo(Stage.ShortBreak)
                }
            case .ShortBreak, .LongBreak:
                switchTo(Stage.Work)
            }
        }
        return stage
    }
    
    func countDownTillNextStage(date: Date) -> TimeInterval {
        return self.remaining
    }
}
