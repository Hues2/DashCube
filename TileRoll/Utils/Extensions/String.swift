import Foundation

extension String {
    var localizedString : String {
        String.LocalizationValue(self).localizedString()
    }
    
    func localizedStringWithParam(_ param : String) -> String {
        String(format: self.localizedString, param)
    }
    
    func isEmptyOrWhitespace() -> Bool {
        if self.isEmpty {
            return true
        }
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
}

extension String.LocalizationValue {
    func localizedString() -> String {
        String(localized: self)
    }
}
