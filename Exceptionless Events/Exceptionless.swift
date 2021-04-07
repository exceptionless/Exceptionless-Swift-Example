//
//  Exceptionless.swift
//  Exceptionless Events
//
//  Created by Justin Hunter on 4/2/21.
//

import Foundation

class Exceptionless {
    var apiKey: String
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func submit(type: String, event: String) {
            switch type {
            case "log":
                return logMessage(logMessage: event)
            case "error":
                return logError(errorEvent: event)
            default:
                print("log")
            }
        }
        
    private func logMessage(logMessage: String) {
        let now = Date()
        let formatter = ISO8601DateFormatter()
        let datetime = formatter.string(from: now)
        let eventDictionary : [String: Any] = [ "type": "log", "message":logMessage, "date": datetime ]
        let jsonData = (try? JSONSerialization.data(withJSONObject: eventDictionary, options: []))!
        postToApi(event: jsonData)
    }
    
    private func logError(errorEvent: String) {
        let now = Date()
        let formatter = ISO8601DateFormatter()
        let datetime = formatter.string(from: now)
        
        let errorDictionary : [String: Any] = ["message": errorEvent, "type": "System.Exception"]
        
        let errorJson = (try? JSONSerialization.data(withJSONObject:errorDictionary))!
        let errorJsonString = String(data: errorJson, encoding: String.Encoding.ascii)!
        let eventDictionary : [String: Any] = [ "type": "error", "@simple_error":errorJsonString, "date": datetime ]
        let jsonData = (try? JSONSerialization.data(withJSONObject: eventDictionary))!
        //let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)!
        postToApi(event: jsonData)
    }
    
    private func postToApi(event: Data) {
        let url = URL(string: "https://api.exceptionless.com/api/v2/events")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // insert json data to the request
        request.httpBody = event
        request.setValue("application/json; charset=utf-8",
             forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8",
             forHTTPHeaderField: "Accept")
        request.setValue("Bearer " + self.apiKey,
             forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }

        task.resume()
    }
}
