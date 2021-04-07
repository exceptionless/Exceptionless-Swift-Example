//
//  ContentView.swift
//  Exceptionless Events
//
//  Created by Justin Hunter on 4/2/21.
//

import SwiftUI

struct ContentView: View {
    private func submitEvent() {
        print("event")
    }
    private func submitError() {
        print("error")
    }
    var body: some View {
        VStack{
            Spacer()
            Button(action: {Exceptionless.init(apiKey: "YOUR API KEY").submit(type: "log", event: "Log Message")}) {
                Text("Log Message")
            }
            Spacer()
            Button(action:{Exceptionless.init(apiKey: "YOUR API KEY").submit(type: "error", event: "Log Error")}) {
                Text("Log Error")
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
