import Foundation

extension URL {
    subscript(parameter: String) -> String? {
        guard let components = URLComponents(string: absoluteString) else {
            return nil
        }

        guard let query = components.queryItems else {
            return nil
        }

        guard let param = query.first(where: { $0.name == parameter }), let value = param.value else {
            return nil
        }

        return value
    }
}
