//
//  TerminalHelper.swift
//  LaunchReplaysWoT
//
//  Created by Wilder López on 8/8/23.
//

import Foundation

class TerminalHelper {
    static let shared = TerminalHelper()
    
      func executeCommand(_ command: String) {
            let task = Process()
            task.launchPath = "/usr/bin/env"
            task.arguments = ["bash", "-c", command]

            let pipe = Pipe()
            task.standardOutput = pipe
            task.standardError = pipe

            task.launch()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                print(output)
            }

            task.waitUntilExit()
        }
    

    func executeCommand(_ command: String, completion: @escaping (String) -> Void) {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["bash", "-c", command]

        let outputPipe = Pipe()
        task.standardOutput = outputPipe
        task.standardError = outputPipe

        let outputHandle = outputPipe.fileHandleForReading

        var outputData = Data()

        outputHandle.readabilityHandler = { pipe in
            let data = pipe.availableData
            outputData.append(data)
        }

        task.terminationHandler = { process in
            outputHandle.readabilityHandler = nil
            let output = String(data: outputData, encoding: .utf8) ?? ""
            completion(output)
        }

        task.launch()
    }

}
