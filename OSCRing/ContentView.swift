//
//  ContentView.swift
//  OSCRing
//
//  Created by Joel Wetzell on 1/27/26.
//

import SwiftUI
import CallKit

struct ContentView: View {
    var callManager = CallManager()
    private var oscServer = OSCServer()
    private var oscClient = OSCClient()
    var body: some View {
        HStack {
            Text("Server listening on port 8080")
        }
    }
    
    init(){
        oscServer.start()
    }
}

#Preview {
    ContentView()
}
