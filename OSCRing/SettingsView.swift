import SwiftUI
import CallKit

struct SettingsView: View {
    var callManager = CallManager()
    private var oscServer = OSCServer()
    @AppStorage("server.port") var serverPort = 1234
    @State private var serverPortInput = 1234
    @State private var saveDisabled = true
    @State private var serverPortError: String? = nil
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Server")){
                    LabeledContent("Port") {
                        TextField("", value: $serverPortInput, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .onChange(of: serverPortInput) { oldValue, newValue in
                            let formValid = validateSettings()
                            if newValue != serverPort {
                                saveDisabled = !formValid
                            }
                        }
                    }
                    if let error = serverPortError {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }
                Section(header: Text("Actions")) {
                    Button("Save") {
                        print("saving")
                        serverPort = serverPortInput
                        oscServer.stop()
                        oscServer.start(port: UInt16(serverPort))
                        saveDisabled = true
                    }.disabled(saveDisabled)
                    Button("Restore Defaults") {
                        serverPortInput = 1234
                    }
                }
            }.onAppear {
                serverPortInput = serverPort
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
    
    func validateSettings() -> Bool {
        var formValid = true
        serverPortError = nil
        if serverPortInput > 65535 {
            serverPortError = "Port must be 65535 or below."
            formValid = false
        }
        
        if serverPortInput < 1024 {
            serverPortError = "Port must be 1024 or above."
            formValid = false
        }
    
        return formValid
    }
    
    init(){
        oscServer.start(port: UInt16(serverPort))
    }
}

#Preview {
    SettingsView()
}
