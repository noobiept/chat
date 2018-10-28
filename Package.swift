// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "chat",
    products: [
        .executable( name: "chat", targets: [ "chat" ] )
    ],
    dependencies: [
        .package( url: "https://github.com/IBM-Swift/Kitura.git",                       .upToNextMajor( from: "2.5.0" ) ),
        .package( url: "https://github.com/IBM-Swift/HeliumLogger.git",                 .upToNextMajor( from: "1.7.0" ) ),
        .package( url: "https://github.com/IBM-Swift/Kitura-WebSocket.git",             .upToNextMajor( from: "2.1.0" ) )
    ],
    targets: [
        .target(
            name: "chat",
            dependencies: [
                "Kitura",
                "HeliumLogger",
                "Kitura-WebSocket"
            ],
            path: "./Sources"
        )
    ]
)
