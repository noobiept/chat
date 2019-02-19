import Foundation


protocol OptionsDelegate: class {
    func getOptions() -> Options
    func updateOptions( _ options: Options ) -> Void
}


struct Options {
    var showJoinLeftMessages = true
    var showUsernameInMessages = true


    enum UserDefaultsKeys: String {
        case joinLeft = "Options-joinLeft"
        case showUsername = "Options-showUsername"
    }


    static func load() -> Options {
        let joinLeft = UserDefaults.standard.object( forKey: UserDefaultsKeys.joinLeft.rawValue ) as! Bool?
        let showUsername = UserDefaults.standard.object( forKey: UserDefaultsKeys.showUsername.rawValue ) as! Bool?

        if let joinLeft = joinLeft,
           let showUsername = showUsername {
            return Options( showJoinLeftMessages: joinLeft, showUsernameInMessages: showUsername )
        }

        return Options()
    }


    static func save( _ options: Options ) {
        UserDefaults.standard.set( options.showJoinLeftMessages, forKey: UserDefaultsKeys.joinLeft.rawValue )
        UserDefaults.standard.set( options.showUsernameInMessages, forKey: UserDefaultsKeys.showUsername.rawValue )
    }
}
