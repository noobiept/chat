import Foundation


enum AppDataEvent {
    case connected
    case message
}


class AppData {

    private var _callbacks: [AppDataEvent: [() -> Void]] = [:]
    private var _connected = 0
    var username: String?


    var connected: Int {
        get {
            return self._connected
        }

        set( value ) {
            self._connected = value

            if let callbacks = self._callbacks[ AppDataEvent.connected ] {
                for callback in callbacks {
                    callback()
                }
            }
        }
    }


    /**
     * Register an event listener to be called when the associated data is updated.
     */
    func register( _ event: AppDataEvent, _ callback: @escaping () -> Void) {
        if var callbacks = self._callbacks[ event ] {
            callbacks.append( callback )
        }

        else {
            self._callbacks[ event ] = [
                callback
            ]
        }
    }
}


let DATA = AppData()
