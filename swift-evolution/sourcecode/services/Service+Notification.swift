import Foundation

struct NotificationService {
    typealias AddSuccessClosure = (ServiceResult<Device>) -> Swift.Void
    
    @discardableResult
    static func add(_ device: Device, completion: @escaping AddSuccessClosure) -> URLSessionDataTask? {
        guard let params = device.asDictionary() else {
            return nil
        }
        
        let key = Environment.Keys.notification ?? ""
        let url = Config.Base.URL.Notification.add
        
        let headers: [Header: String] = [.authorization: key, .contentType: MimeType.applicationJSON.rawValue]
        let request = RequestSettings(url, method: .post, params: params, headers: headers)
        
        let task = Service.dispatch(request) { result in
            let value = result.flatMap { try JSONDecoder().decode(Device.self, from: $0) }
            completion(value)
        }
        
        return task
    }
}
