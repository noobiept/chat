import Foundation
import Kitura
import KituraNet
import KituraWebSocket
import HeliumLogger
import LoggerAPI
import KituraStencil


HeliumLogger.use( .info )
WebSocket.register( service: Chat(), onPath: "chat" )


let router = Router()

router.setDefault( templateEngine: StencilTemplateEngine() )
router.all( "/static", middleware: StaticFileServer( path: "./Static" ) )

router.get( "/" ) {
    request, response, next in

    try response.render( "home.stencil", context: [:] ).end()
}


let serverPort = Int( ProcessInfo.processInfo.environment["PORT"] ?? "8000" ) ?? 8000

Kitura.addHTTPServer( onPort: serverPort, with: router )
Kitura.run()