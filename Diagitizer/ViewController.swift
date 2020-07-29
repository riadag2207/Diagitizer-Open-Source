import Cocoa


class ViewController: NSViewController {

    var connectedDeviceModel = String()
    var deviceDetectionHandler:Bool = true
    var supportedDevicesJson = [supportedDevicesStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.GoBTN.isEnabled = false
        FlashProgress.minValue = 0
        FlashProgress.maxValue = 1
        DispatchQueue.global(qos: .background).async {
            self.DCSD_init()
            do {
                      let data = try Data(contentsOf: Bundle.main.url(forResource: "supportedDevices", withExtension: "json")!)
                self.supportedDevicesJson = try JSONDecoder().decode([supportedDevicesStruct].self, from: data)
            
                             
                  } catch {
                      print(error)
                  }
        }
        var timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in DispatchQueue.global(qos: .background).async {
            if self.deviceDetectionHandler == true {
                self.deviceDetect(timer: timer)
            }
            }}
        DispatchQueue.global(qos: .background).async {
            timer.fire()
        }


    }
    
    func DCSD_init() {
        DCSDStatus(status: 2)
        usleep(100000)
        DCSDStatus(status: 0)
        usleep(100000)
        DCSDStatus(status: 2)
        usleep(100000)
        DCSDStatus(status: 0)
        usleep(100000)
        DCSDStatus(status: 2)
        usleep(100000)
        DCSDStatus(status: 0)
        usleep(100000)
        DCSDStatus(status: 2)
        usleep(100000)
        DCSDStatus(status: 0)
        usleep(100000)

    }
    
    @IBOutlet weak var FlashProgress: NSProgressIndicator!
    
    @IBAction func Go(_ sender: Any) {
        deviceDetectionHandler = false
        DispatchQueue.global(qos: .background).async {
             /// iPhone 6, 6+, iPad mini 4
            DispatchQueue.main.async {
                self.ConnectedString.stringValue = "Exploiting..."
                self.FlashProgress.doubleValue = 0.2
            }
            self.DCSDStatus(status: 2)
            DispatchQueue.main.async {
            self.GoBTN.isEnabled = false
            }
            if self.connectedDeviceModel == "N61" || self.connectedDeviceModel == "N56" || self.connectedDeviceModel == "J96" {
                if self.eclipsa7000() == 0 {
                    print("Successfully exploited")
                    self.getBootchain()
                        }else {
                    self.deviceDetectionHandler = true
                            self.DCSDStatus(status: 3)
                        }
                   }
            
            if self.connectedDeviceModel == "J81" {
                if self.eclipsa7001() == 0 {
                    print("Successfully exploited")
                    self.getBootchain()
                        }else {
                    self.deviceDetectionHandler = true
                            self.DCSDStatus(status: 3)
                        }
                   }
                   
                   /// iPhone 6S. 6S+ (N71 & N66), iPad 5 (2017)
            if self.connectedDeviceModel == "N71" || self.connectedDeviceModel == "N66" || self.connectedDeviceModel == "J71S" || self.connectedDeviceModel == "J71T" {
                if self.eclipsa8000() == 0 {
                    print("Successfully exploited")
                    self.getBootchain()
                       }else {
                    self.deviceDetectionHandler = true
                           self.DCSDStatus(status: 3)
                       }
                   }
                   /// iPhone 6S, 6S+ (N71m & N66m)
            if self.connectedDeviceModel == "N71m" || self.connectedDeviceModel == "N66m" {
                if self.eclipsa8003() == 0 {
                    print("Successfully exploited")
                    self.getBootchain()
                        }else {
                    self.deviceDetectionHandler = true
                            self.DCSDStatus(status: 3)
                        }
                   }
                   /// iPhone 7, 7+, iPad 6 (2018), iPad Pro 2nd gen 12,9', iPad Pro 10,5'
            if self.connectedDeviceModel == "D101" || self.connectedDeviceModel == "D111" || self.connectedDeviceModel == "J71B" || self.connectedDeviceModel == "J120" || self.connectedDeviceModel == "J207" {
                if self.ipwndfu8010() == 0 {
                    print("Successfully exploited")
                    self.getBootchain()
                       }else {
                    self.deviceDetectionHandler = true
                           self.DCSDStatus(status: 3)
                       }
                   }
                   
                   /// iPhone 8, 8+, X
            if self.connectedDeviceModel == "D20" || self.connectedDeviceModel == "D21" || self.connectedDeviceModel == "D221" {
                    if self.ipwndfu8015() == 0 {
                    print("Successfully exploited")
                    self.getBootchain()
                    } else {
                        self.deviceDetectionHandler = true
                        self.DCSDStatus(status: 3)
                    }
                   }

        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

func getBootchain() {
    DispatchQueue.main.async {
        self.ConnectedString.stringValue = "Fetching bootchain..."
        self.FlashProgress.doubleValue = 0.3
    }
    
    do {

        
            let directory = getDocumentsDirectory()
        print(directory.path)
        let boot1_path = URL(fileURLWithPath: "\(directory.path)/diagitizer_bootchain/iBSS.\(connectedDeviceModel).img4")
        let boot2_path = URL(fileURLWithPath: "\(directory.path)/diagitizer_bootchain/iBoot.\(connectedDeviceModel).img4")
        let boot3_path = URL(fileURLWithPath: "\(directory.path)/diagitizer_bootchain/diag.\(connectedDeviceModel).img4")
        
        let iBSS_data = try Data(contentsOf: boot1_path)
        let iBoot_data = try Data(contentsOf: boot2_path)
        let diag_data = try Data(contentsOf: boot3_path)

        print(boot1_path.path)
            DispatchQueue.main.async {
                self.ConnectedString.stringValue = "Sending stage1 to iDevice..."
                self.FlashProgress.doubleValue = 0.4
            }
           // Sending stage1
                    print("Sending stage1")
                    DispatchQueue.main.async {
                        self.ConnectedString.stringValue = "Sending stage1 to iDevice..."
                        self.FlashProgress.doubleValue = 0.4
                    }
                    if iBSS_data != Data([0xDE,0xAD,0xBE,0xEF]) {
                       if iRecovery("-f", path: boot1_path.path) == 0 {
                        print("Successfully sent stage1")
                        sleep(1)
                        print("Sleep done")
                       } else {print("error while sending stage1");                        DispatchQueue.main.async {
                        self.ConnectedString.stringValue = "Error while sending stage1"
                        };                            deviceDetectionHandler = false
; return }
                    } else {print("iBSS skipped") }
        
        
                    /// Sending stage2
                    DispatchQueue.main.async {
                        self.ConnectedString.stringValue = "Sending stage2 to iDevice..."
                        self.FlashProgress.doubleValue = 0.5
                    }
                    print("Sending stage2")
                    if iBoot_data != Data([0xDE,0xAD,0xBE,0xEF]) {
                       if iRecovery("-f", path: boot2_path.path) == 0 {
                        print("Successfully sent stage2")
                        sleep(1)
                        print("Sleep done")
                       } else {print("error while sending stage2");                            deviceDetectionHandler = false
;     DispatchQueue.main.async {
                                   self.ConnectedString.stringValue = "Error while sending stage2"
                        }; return }
                    } else {print("iBoot skipped") }

                    /// Sending stage3
                    DispatchQueue.main.async {
                        self.ConnectedString.stringValue = "Sending stage3 to iDevice..."
                        self.FlashProgress.doubleValue = 0.6
                    }
                    print("Sending stage2")
                    if diag_data != Data([0xDE,0xAD,0xBE,0xEF]) {
                       if iRecovery("-f", path: boot3_path.path) == 0 {
                        print("Successfully sent stage3")
                        sleep(1)
                        print("Sleep done")
                        } else {print("error while sending stage3");                            deviceDetectionHandler = false
                        ;     DispatchQueue.main.async {
                                   self.ConnectedString.stringValue = "Error while sending stage3"
                        }; return }
                    } else {print("diag skipped") }
                    /// Setting usbserial bootarg
                    DispatchQueue.main.async {
                        self.ConnectedString.stringValue = "Setting 'usbserial' bootarg"
                        self.FlashProgress.doubleValue = 0.7
                    }
                    if iRecovery("-c", path: "setenv boot-args usbserial=enabled") == 0 {
                    print("Successfully set usbserial to 'enabled'")
                    usleep(250000)
                    print("Sleep done")
                    } else {
                        print("error while setting usbserial bootarg")
                        DCSDStatus(status: 3)
                        deviceDetectionHandler = false
                    }
        
                    /// Saving usbserial bootarg
                    DispatchQueue.main.async {
                        self.ConnectedString.stringValue = "Saving 'usbserial' bootarg"
                        self.FlashProgress.doubleValue = 0.8
                    }
                    if iRecovery("-c", path: "saveenv") == 0 {
                    print("Successfully saved nvram")
                        usleep(250000)
                        print("Sleep done")
                    } else {
                        print("error while saving bootargs")
                        deviceDetectionHandler = false
                        DCSDStatus(status: 3)
                    }
        
                    DispatchQueue.main.async {
                        self.ConnectedString.stringValue = "Diagitizing iDevice"
                        self.FlashProgress.doubleValue = 0.9
                    }
                    if iRecovery("-c", path: "go") == 0 {
                    print("Successfully diagitize")
                        DispatchQueue.main.async {
                            self.ConnectedString.stringValue = "Successfully diagitize!"
                            self.FlashProgress.doubleValue = 1
                        }
                        DCSDStatus(status: 1)
                        sleep(2)
                        deviceDetectionHandler = false

                    } else {
                        print("error while diagitizing the iDevice")
                        deviceDetectionHandler = false
                        DispatchQueue.main.async {
                                   self.ConnectedString.stringValue = "Error while diagitizing"
                                  }
                    }
            
            
            
    } catch {
        self.DCSDStatus(status: 3)
        DispatchQueue.main.async {
            self.ConnectedString.stringValue = "Error while fetching bootchain..."
        }
        self.deviceDetectionHandler = true
        print("Error while fetching Bootchain\n\(error)")
    }
    


}

    
    
    func iRecovery(_ arg1: String,path: String) -> Int32 {
        let task = Process()
        task.launchPath = Bundle.main.path(forResource: "irecovery", ofType: "")
        task.arguments = [arg1,path]
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
    
    func eclipsa7000() -> Int32 {
        var timer = Int()
        let task = Process()
        task.launchPath = Bundle.main.path(forResource: "eclipsa7000", ofType: "", inDirectory: "exploits/")
        task.arguments = ["eclipsa7000"]
        task.launch()
        while task.isRunning {
            sleep(1)
            timer += 1
            if timer == 5 {
                task.terminate()
                print("Exploitation terminated")
                DispatchQueue.main.async {
                    self.ConnectedString.stringValue = "Exploitation timeout..."
                    self.FlashProgress.doubleValue = 0
                }
            }
        }
        task.waitUntilExit()
        return task.terminationStatus
    }
    func eclipsa7001() -> Int32 {
        let task = Process()
        task.launchPath = Bundle.main.path(forResource: "eclipsa7001", ofType: "", inDirectory: "exploits/")
        task.arguments = ["eclipsa7001"]
        task.launch()
        var timer = Int()
        while task.isRunning {
            sleep(1)
            timer += 1
            if timer == 5 {
                task.terminate()
                print("Exploitation terminated")
                DispatchQueue.main.async {
                    self.ConnectedString.stringValue = "Exploitation timeout..."
                    self.FlashProgress.doubleValue = 0
                }
            }
        }
        task.waitUntilExit()
        return task.terminationStatus
    }
    func eclipsa8000() -> Int32 {
        let task = Process()
        task.launchPath = Bundle.main.path(forResource: "eclipsa8000", ofType: "", inDirectory: "exploits/")
        task.arguments = ["eclipsa8000"]
        task.launch()
        var timer = Int()
        while task.isRunning {
            sleep(1)
            timer += 1
            if timer == 5 {
                task.terminate()
                print("Exploitation terminated")
                DispatchQueue.main.async {
                    self.ConnectedString.stringValue = "Exploitation timeout..."
                    self.FlashProgress.doubleValue = 0
                }
            }
        }
        task.waitUntilExit()
        return task.terminationStatus
    }
    func eclipsa8003() -> Int32 {
        let task = Process()
        task.launchPath = Bundle.main.path(forResource: "eclipsa8003", ofType: "", inDirectory: "exploits/")
        task.arguments = ["eclipsa8003"]
        task.launch()
        var timer = Int()
        while task.isRunning {
            sleep(1)
            timer += 1
            if timer == 5 {
                task.terminate()
                print("Exploitation terminated")
                DispatchQueue.main.async {
                    self.ConnectedString.stringValue = "Exploitation timeout..."
                    self.FlashProgress.doubleValue = 0
                }
            }
        }
        task.waitUntilExit()
        return task.terminationStatus
    }
    func
        ipwndfu8010() -> Int32 {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = [Bundle.main.path(forResource: "exploit.sh", ofType: "", inDirectory: "exploits/ipwndfu8010")!]
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
    func ipwndfu8015() -> Int32 {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = [Bundle.main.path(forResource: "exploit.sh", ofType: "", inDirectory: "exploits/ipwndfu8015")!]
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
   
            func deviceDetect(timer:Timer) {
            let task = Process()
            task.launchPath = Bundle.main.path(forResource: "irecovery", ofType: "")
            task.arguments = ["-q"]
            let output = Pipe()
            task.standardOutput = output
            task.launch()
            task.waitUntilExit()
            let str = String(data: output.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)
            let strArr = str?.split(separator: "\n")
            var cpid = Int32()
            var bdid = Int32()
            var mode = String()
            
            for st in strArr! {
                if st.contains("CPID"){

                    let str = st.replacingOccurrences(of: "CPID: 0x", with: "")
                    cpid = NSString(string: str).intValue
                    //print(cpid)
                }
                if st.contains("BDID") {
                    let string = (st.replacingOccurrences(of: "BDID: 0x", with: ""))
                    if let value = UInt8(string, radix: 16) {
                    bdid = Int32(value)
                    //print(bdid)
                    }}else{
                }
                if st.contains("MODE") {
                    let str = st.replacingOccurrences(of: "MODE: ", with: "")
                    mode = str
                }
            }
                for devices in supportedDevicesJson {
                    if cpid == devices.cpid && bdid == devices.bdid {
                        DispatchQueue.main.async {
                            self.ConnectedString.stringValue = "\(devices.productName) in \(mode) mode detected"
                            if mode == "DFU" {
                                self.GoBTN.isEnabled = true
                            } else {
                                self.GoBTN.isEnabled = false
                            }

                        }
                        connectedDeviceModel = devices.internalName
                    }
                }
            if task.terminationStatus == 0 {
                print(connectedDeviceModel)
                    DCSDStatus(status: 0)
                    usleep(5000)
                    DCSDStatus(status: 1)
                    usleep(5000)
                    DCSDStatus(status: 2)
                    usleep(5000)
                    DCSDStatus(status: 3)
                    usleep(5000)
                    DCSDStatus(status: 2)
                    usleep(5000)
                    DCSDStatus(status: 1)
                    usleep(5000)
                    DCSDStatus(status: 0)
                    usleep(5000)

            } else {
                DispatchQueue.main.async {
                    self.ConnectedString.stringValue = "Please connect your iDevice"
                    self.GoBTN.isEnabled = false
                }
                DCSDStatus(status: 2)
                usleep(100000)
                DCSDStatus(status: 0)
                usleep(100000)
                DCSDStatus(status: 2)
                usleep(100000)
                DCSDStatus(status: 0)
                usleep(100000)

            }
        }
    @IBOutlet weak var GoBTN: NSButton!
    func DCSDParty() {
        let lol = 1
        while lol == 1 {
            DCSDStatus(status: 0)
            usleep(50000)
            DCSDStatus(status: 1)
            usleep(50000)
            DCSDStatus(status: 2)
            usleep(50000)
            DCSDStatus(status: 3)
            usleep(50000)
            DCSDStatus(status: 2)
            usleep(50000)
            DCSDStatus(status: 1)
            usleep(50000)
            DCSDStatus(status: 2)
            usleep(50000)
            DCSDStatus(status: 3)
            usleep(50000)
            DCSDStatus(status: 2)
            usleep(50000)
            DCSDStatus(status: 1)
            usleep(50000)
            DCSDStatus(status: 0)
            usleep(5000)
            DCSDStatus(status: 4)
            usleep(5000)
        }
    }
    
    func DCSDStatus(status: Int) {
        let task = Process()
        task.launchPath = Bundle.main.path(forResource: "dcsd", ofType: "")
        task.arguments = ["\(status)"]
        task.launch()
        task.waitUntilExit()
    }
    @IBOutlet weak var ConnectedString: NSTextField!
}




struct supportedDevicesStruct: Codable {
    let productName:String
    let internalName:String
    let cpid:Int32
    let bdid:Int32
}




func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}

extension String {

    /// Create `Data` from hexadecimal string representation
    ///
    /// This creates a `Data` object from hex string. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.

    var hexadecimal: Data? {
        var data = Data(capacity: count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }

        guard data.count > 0 else { return nil }

        return data
    }

}
