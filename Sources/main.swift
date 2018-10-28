import Foundation
import Kitura
import KituraNet
import KituraWebSocket
import HeliumLogger
import LoggerAPI


HeliumLogger.use( .info )
WebSocket.register( service: Chat(), onPath: "chat" )


let router = Router()

router.all( "/", middleware: StaticFileServer( path: "./Static" ) )
router.get( "/" ) {
    request, response, next in

    try response.redirect( "/home.html" )
}


let serverPort = Int( ProcessInfo.processInfo.environment[ "PORT" ] ?? "8000" ) ?? 8000

Kitura.addHTTPServer( onPort: serverPort, with: router )
Kitura.run()
