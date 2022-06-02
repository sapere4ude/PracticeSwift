import UIKit

class Color: NSObject {
    @objc var colorName: String?
}

// KVC (Key Value Coding)
let color = Color()
color.value(forKey: "colorName")
color.setValue("green", forKey: "colorName")
color.value(forKey: "colorName")

