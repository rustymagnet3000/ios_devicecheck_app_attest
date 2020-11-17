import DeviceCheck


final class AppAttest {
    private let keyName = "AppAttestKeyIdentifier"
    private let attestService = DCAppAttestService.shared
    private let userDefaults = UserDefaults.standard
    var keyID: String? {
        didSet
        {
            print("🐝 Key ID:", keyID!)
        }
    }
    
    init?() {
        
        guard attestService.isSupported == true else {
            print("[!] Attest service not available:")
            return nil
        }
        
        guard let id = userDefaults.object(forKey:keyName) as? String else {
            attestService.generateKey { keyIdentifier, error in
                
                guard error == nil, keyIdentifier == nil else { return }
                self.keyID = keyIdentifier
                if self.keyID != nil {
                    print("🐝 Generated key")
                    self.userDefaults.set(self.keyID, forKey: self.keyName)
                }
                
            }
            return nil
        }
        keyID = id
    }
}
