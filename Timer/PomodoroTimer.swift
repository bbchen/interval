import Foundation

class PomodoroTimer {
    enum Stage: TimeInterval {
        case Work, ShortBreak, LongBreak
    }
    static let PROD: Dictionary<Stage, TimeInterval> = [.Work: 25.0 * 60, .ShortBreak: 5.0 * 60, .LongBreak: 15.0 * 60]
    static let DEV: Dictionary<Stage, TimeInterval> = [.Work: 10, .ShortBreak: 5, .LongBreak: 10]
    
    private(set) var since: Date?
    private(set) var stage: Stage
    private(set) var workCount: Int
    private(set) var remaining: TimeInterval
    
    private var config: Dictionary<Stage, TimeInterval>
    
    convenience init() {
        self.init(config: PomodoroTimer.PROD)
    }
    
    init(config: Dictionary<Stage, TimeInterval>) {
        self.config = config
        since = Date.init()
        stage = .Work
        remaining = self.config[stage]!
        workCount = 0
    }
    
    func pause() {
        self.since = nil
    }
    
    func resume() {
        self.since = Date.init()
    }
    
    func switchTo(_ stage: Stage) {
        self.stage = stage
        self.since = Date.init()
        self.remaining = self.config[stage]!
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
    
    func progress() -> Double {
        return remaining / config[stage]!
    }
    
    func countDownTillNextStage(date: Date) -> TimeInterval {
        return self.remaining
    }
}
