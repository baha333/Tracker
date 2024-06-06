
import UIKit

extension UIColor {
    static var ypBlack: UIColor { UIColor(named: "YP Black") ?? UIColor.black }
    static var ypBackground: UIColor { UIColor(named: "YP Background") ?? UIColor.darkGray }
    static var ypWhite: UIColor { UIColor(named: "YP White") ?? UIColor.white }
    static var ypGreen: UIColor { UIColor(named: "YP Green") ?? UIColor.green }
    static var ypBlue: UIColor { UIColor(named: "YP Blue") ?? UIColor.blue }
    static var ypRed: UIColor { UIColor(named: "YP Red") ?? UIColor.red }
    static var ypGray: UIColor { UIColor(named: "YP Gray") ?? UIColor.gray }
    static var ypLightGray: UIColor { UIColor(named: "YP Light Gray") ?? UIColor.lightGray }
    
    static var colorSelection1: UIColor {
        guard let color = UIColor(named: "Color selection 1") else {
            assertionFailure("Unable to load color")
            return UIColor.white
        }
        return color
    }
    static var colorSelection2: UIColor {
        guard let color = UIColor(named: "Color selection 2") else {
            assertionFailure("Unable to load color")
            return UIColor.white
        }
        return color
    }
    static var colorSelection3: UIColor {
        guard let color = UIColor(named: "Color selection 3") else {
            assertionFailure("Unable to load color")
            return UIColor.white
        }
        return color
    }
    static var colorSelection4: UIColor {
        guard let color = UIColor(named: "Color selection 4") else {
            assertionFailure("Unable to load color")
            return UIColor.white
        }
        return color
    }
    static var colorSelection5: UIColor {
        guard let color = UIColor(named: "Color selection 5") else {
            assertionFailure("Unable to load color")
            return UIColor.white
        }
        return color
    }
    static var colorSelection6: UIColor {
        guard let color = UIColor(named: "Color selection 6") else {
            assertionFailure("Unable to load color")
            return UIColor.white
        }
        return color
    }
    static var colorSelection7: UIColor {
        guard let color = UIColor(named: "Color selection 7") else {
            assertionFailure("Unable to load color")
            return UIColor.white
        }
        return color
    }
    static var colorSelection8: UIColor {
        guard let color = UIColor(named: "Color selection 8") else {
            assertionFailure("Unable to load color")
            return UIColor.white
        }
        return color
    }
    static var colorSelection9: UIColor {
        guard let color = UIColor(named: "Color selection 9") else {
            assertionFailure("Unable to load color")
            return UIColor.white
        }
        return color
    }
    static var colorSelection10: UIColor {
        guard let color = UIColor(named: "Color selection 10") else {
            assertionFailure("Unable to load color")
            return UIColor.white
        }
        return color
    }
    static var colorSelection11: UIColor {
        guard let color = UIColor(named: "Color selection 11") else {
            assertionFailure("Unable to load color")
            return UIColor.white
        }
        return color
    }
    static var colorSelection12: UIColor {
        guard let color = UIColor(named: "Color selection 12") else {
            assertionFailure("Unable to load color")
            return UIColor.white
        }
        return color
    }
    static var colorSelection13: UIColor {
        guard let color = UIColor(named: "Color selection 13") else {
            assertionFailure("Unable to load color")
            return UIColor.white
        }
        return color
    }
    static var colorSelection14: UIColor {
        guard let color = UIColor(named: "Color selection 14") else {
            assertionFailure("Unable to load color")
            return UIColor.white
        }
        return color
    }
    static var colorSelection15: UIColor {
        guard let color = UIColor(named: "Color selection 15") else {
            assertionFailure("Unable to load color")
            return UIColor.white
        }
        return color
    }
    static var colorSelection16: UIColor {
        guard let color = UIColor(named: "Color selection 16") else {
            assertionFailure("Unable to load color")
            return UIColor.white
        }
        return color
    }
    static var colorSelection17: UIColor {
        guard let color = UIColor(named: "Color selection 17") else {
            assertionFailure("Unable to load color")
            return UIColor.white
        }
        return color
    }
    static var colorSelection18: UIColor {
        guard let color = UIColor(named: "Color selection 18") else {
            assertionFailure("Unable to load color")
            return UIColor.white
        }
        return color
    }
    
}

let colorDictionary: [String: UIColor] = [
        "Color selection 1": UIColor.colorSelection1,
        "Color selection 2": UIColor.colorSelection2,
        "Color selection 3": UIColor.colorSelection3,
        "Color selection 4": UIColor.colorSelection4,
        "Color selection 5": UIColor.colorSelection5,
        "Color selection 6": UIColor.colorSelection6,
        "Color selection 7": UIColor.colorSelection7,
        "Color selection 8": UIColor.colorSelection8,
        "Color selection 9": UIColor.colorSelection9,
        "Color selection 10": UIColor.colorSelection10,
        "Color selection 11": UIColor.colorSelection11,
        "Color selection 12": UIColor.colorSelection12,
        "Color selection 13": UIColor.colorSelection13,
        "Color selection 14": UIColor.colorSelection14,
        "Color selection 15": UIColor.colorSelection15,
        "Color selection 16": UIColor.colorSelection16,
        "Color selection 17": UIColor.colorSelection17,
        "Color selection 18": UIColor.colorSelection18
    ]
