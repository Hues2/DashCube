import UIKit

extension UserDefaults {
    func colorForKey(key: String) -> UIColor? {
        var colorReturnded: UIColor?
        if let colorData = data(forKey: key) {
            do {
                if let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
                    colorReturnded = color
                }
            } catch {
                print("Error UserDefaults")
                return nil
            }
        }
        return colorReturnded
    }
    
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
                colorData = data
            } catch {
                print("Couldn't save selected cube color")
            }
        }
        set(colorData, forKey: key)
    }
}
