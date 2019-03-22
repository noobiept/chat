import Foundation
import UIKit


fileprivate var COLORS: [String: UIColor] = [:]


func getUserColor( _ username: String, darker: Bool = true ) -> UIColor {
    if let existingColor = COLORS[ username ] {
        return existingColor
    }

    else {
        let color = generateRandomColor( darker )

        COLORS[ username ] = color
        return color
    }
}


fileprivate func generateRandomColor( _ darker: Bool ) -> UIColor {
    var min = 0.0
    var max = 0.6

    if !darker {
        min = 0.8
        max = 1.0
    }

    let red = Double.random( in: min ... max )
    let green = Double.random( in: min ... max )
    let blue = Double.random( in: min ... max )

    return UIColor( red: CGFloat( red ), green: CGFloat( green ), blue: CGFloat( blue ), alpha: 1 )
}

