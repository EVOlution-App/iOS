import Foundation

public struct Environment {
    
    private static var settings: [String: Any]? {
        guard
            let dict = Bundle.main.infoDictionary,
            let settings = dict["EnvironmentSettings"] as? [String: Any] else {
                return nil
        }
        
        return settings
    }
    
    public static var title: String? {
        guard
            let settings = self.settings,
            let title = settings["Title"] as? String else {
                return nil
        }
        
        return title
    }
}
