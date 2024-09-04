import Foundation

extension Encodable {
    func asDictionary() -> [String: Any]? {
        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(self)

            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return nil
            }

            return dictionary
        }
        catch {
            print("[Encodable] [asDictionary] Error: \(error.localizedDescription)")
        }

        return nil
    }
}
