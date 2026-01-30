import CallKit
import F53OSC

class OSCServer: NSObject, F53OSCServerDelegate {
    
    private var server: F53OSCServer = F53OSCServer()
    private var callManager: CallManager = CallManager()
    func take(_ message: F53OSCMessage?) {
        if let addressPattern = message?.addressPattern {
            print("received address pattern: \(addressPattern)")
            if addressPattern == "/call/incoming" {
                if let arguments = message?.arguments {
                    if arguments.count != 1 {
                        print("incoming call must have one argument")
                        return
                    }
                    let handle = String(describing: arguments[0])
                    if handle.starts(with: "+") {
                        callManager.reportIncomingCall(uuid: UUID(), handle: CXHandle(type: .phoneNumber, value: handle))
                    } else {
                        callManager.reportIncomingCall(uuid: UUID(), handle: CXHandle(type: .generic, value: handle))
                    }
                }
            }
        }
    }
    
    
    override init(){
        super.init()
        self.server.delegate = self
    }
    
    func start(port: UInt16){
        print("OSC Server starting on port \(port)")
        self.server.port = port
        self.server.startListening()
    }
    
    func stop(){
        print("OSC Server stopped")
        self.server.stopListening()
    }
}
