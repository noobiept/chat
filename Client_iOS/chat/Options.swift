import Foundation


protocol OptionsDelegate: class {
    func getOptions() -> Options
    func updateShowJoinLeft(_ value: Bool) -> Void
    func updateShowUsername(_ value: Bool) -> Void
}


struct Options {
    var showJoinLeftMessages = true
    var showUsernameInMessages = true
}
