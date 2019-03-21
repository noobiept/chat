import Foundation


enum AppDataEvent {
    case connected
    case username
    case message
}


class AppData {

    private var _callbacks: [AppDataEvent: [() -> Void]] = [:]
    private var _connected = 0
    private var _username: String?


    var connected: Int {
        get {
            return self._connected
        }

        set( value ) {
            self._connected = value
            self.callListeners( .connected )
        }
    }


    var username: String? {
        get {
            return self._username
        }

        set( value ) {
            self._username = value
            self.callListeners( .username )
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


    /**
     * Call all the associated listeners of the given event.
     */
    private func callListeners( _ event: AppDataEvent ) {
        if let callbacks = self._callbacks[ event ] {
            for callback in callbacks {
                callback()
            }
        }
    }
}


let DATA = AppData()
