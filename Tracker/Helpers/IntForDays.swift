
import Foundation

extension Int {
    func days() -> String {
        let remainder10 = self % 10
        let remainder100 = self % 100
        
        if self == 1 {
            return "\(self) \("oneDay".localized)"
        } else if remainder10 == 1 && remainder100 != 11 {
            return "\(self) \("numberEndingOneWithoutEleven".localized)"
        } else if remainder10 >= 2 && remainder10 <= 4 && (remainder100 < 10 || remainder100 >= 20) {
            return "\(self) \("numberEndingFromTwoToFour".localized)"
        } else {
            return "\(self) \("otherDaysNumber".localized)"
        }
    }
}
