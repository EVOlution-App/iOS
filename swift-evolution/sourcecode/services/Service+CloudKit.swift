import CloudKit
import KeychainAccess

import ModelsLibrary

@available(*, deprecated, message: "Use NetworkLibrary instead")
enum CloudKitService {
  typealias UserClosure = (ServiceResult<User>) -> Swift.Void

  static func user(completion: @escaping UserClosure) {
    let container = CKContainer.default()
    container.fetchUserRecordID { result, error in
      if let error {
        completion(.failure(error))
      }

      guard let recordIdentifier = result else {
        completion(.failure(ServiceError.unknownState))
        return
      }

      let bundleIdentifier = Environment.bundleIdentifier ?? "io.swift-evolution.app"
      let keychain = Keychain(service: bundleIdentifier).synchronizable(true)

      let userIdentifier = recordIdentifier.recordName
      keychain["currentUser"] = userIdentifier

      let user = User(identifier: userIdentifier)
      completion(.success(user))
    }
  }
}
