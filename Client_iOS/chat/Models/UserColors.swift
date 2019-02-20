import Foundation
import UIKit


fileprivate var COLORS: [String: UIColor] = [:]


func getUserColor( _ username: String ) -> UIColor {
    if let existingColor = COLORS[ username ] {
        return existingColor
    }

    else {
        let color = generateRandomColor()

        COLORS[ username ] = color
        return color
    }
}


fileprivate func generateRandomColor() -> UIColor {
    let red = Float.random( in: 0 ..< 0.6 )
    let green = Float.random( in: 0 ..< 0.6 )
    let blue = Float.random( in: 0 ..< 0.6 )

    return UIColor( red: CGFloat( red ), green: CGFloat( green ), blue: CGFloat( blue ), alpha: 1 )
}

