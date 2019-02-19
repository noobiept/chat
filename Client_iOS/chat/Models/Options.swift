import Foundation


protocol OptionsDelegate: class {
    func getOptions() -> Options
    func updateOptions( _ options: Options ) -> Void
}


struct Options {
    var showJoinLeftMessages = true
    var showUsernameInMessages = true
}
