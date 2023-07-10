//
//  ProcessManager.swift
//  LaunchReplaysWoT
//
//  Created by Wilder López on 7/8/23.
//

import Foundation
import SwiftUI

class ProcessManager: ObservableObject {
    
    @Published var processStack : [ProcessModel] = [
        .init(type: .wine, status: .initial, path: nil),
        .init(type: .executable, status: .initial, path: nil),
        .init(type: .replay, status: .initial, path: nil)
    ]
    @Published var currentProcessFailed : ProcessModel? = nil
    
//    @Published var currentProcess : ProcessModel = .init()
    
    
    func doAction(for process: ProcessModel) {
        // find the process
        if let index = processStack.firstIndex(where: {$0.id == process.id}) {
            let statuss = processStack[index].status
            switch statuss {
            case .initial:
                // do loading
                processStack[index].status = .loading
                
                //check if file path exists
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                    if self.checkFileExists(filePath: process.path) {
                        self.processStack[index].status = .done
                        print("file exist with default url")
                    }else {
                        self.processStack[index].status = .failed
                        print("file not found, with default: \(String(describing: process.path))")
                        //check first process to fail
                        self.checkFirstProcessToFail()
                    }
                }
                
                break
            case .loading:
                // should wait for a response (fail or success)
                break
            case .done:
                // do noting
                break
            case .failed:
                // do initial again
                processStack[index].status = .initial
                break
            }
            objectWillChange.send()
        }
        
    }
    
    func checkFirstProcessToFail() {
        currentProcessFailed = processStack.first(where: {$0.status == .failed})
    }
    
    private func checkFileExists(filePath: String?) -> Bool {
        if let filePath = filePath{
            debugPrint("fie path ", filePath)
            let fileManager = FileManager.default
            return fileManager.fileExists(atPath: filePath)
        }
        return false
    }
    
}
