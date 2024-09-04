import CloudKit
import KeychainAccess

enum CloudKitService {
  typealias UserClosure = (ServiceResult<User>) -> Swift.Void

  static func user(completion: @escaping UserClosure) {
    let container = CKContainer.default()
    container.fetchUserRecordID { result, error in
      if let error {
        completion(.failure(error))
      }

      guard let recordID = result else {
        completion(.failure(ServiceError.unknownState))
        return
      }

      let bundleID = Environment.bundleID ?? "io.swift-evolution.app"
      let keychain = Keychain(service: bundleID).synchronizable(true)

      let userID = recordID.recordName
      keychain["currentUser"] = userID

      let user = User(id: userID)
      completion(.success(user))
    }
  }
}
