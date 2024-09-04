import UIKit

extension UIDevice {
    func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return simulatorModelIdentifier
        }

        var sysinfo = utsname()
        uname(&sysinfo)

        let data = Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN))
        guard let model = String(bytes: data, encoding: .ascii) else {
            return "iPhone"
        }

        return model.trimmingCharacters(in: .controlCharacters)
    }
}
