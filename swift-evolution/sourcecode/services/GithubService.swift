import Unbox

struct GithubService {
    
    typealias CompletionUserProfile = (_ error: Error?, _ profile: GithubProfile?) -> Swift.Void
    
    static func profile(from username: String, completion: @escaping CompletionUserProfile) {
        
        let url = "https://api.github.com/users/\(username)"
        Service.requestKeyValue(url) { (error, object) in
            guard error == nil else {
                completion(error, nil)
                return
            }
            
            if let object = object, let profile: GithubProfile = try? unbox(dictionary: object) {
                completion(nil, profile)
            }
        }
    }
}
