import Foundation

struct NotificationsService {
    typealias AddSuccessClosure = (ServiceResult<Notifications.Device>) -> Swift.Void
    
    @discardableResult
    static func add(_ device: Notifications.Device, completion: @escaping AddSuccessClosure) -> URLSessionDataTask? {
        guard let params = device.asDictionary() else {
            return nil
        }
        
        let key = Environment.Keys.notification ?? ""
        let url = Config.Base.URL.Notifications.add
        
        let headers: [Header: String] = [.authorization: key, .contentType: MimeType.applicationJSON.rawValue]
        let request = RequestSettings(url, method: .post, params: params, headers: headers)
        
        let task = Service.dispatch(request) { result in
            let value = result.flatMap { try JSONDecoder().decode(Notifications.Device.self, from: $0) }
            completion(value)
        }
        
        return task
    }
}
