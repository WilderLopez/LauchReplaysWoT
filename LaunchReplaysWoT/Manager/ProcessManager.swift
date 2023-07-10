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
                    if self.detectIfPathExists(process: process) {
                        self.processStack[index].status = .done
                        print("file exist!")
                        //try to save the path url
                    }else {
                        self.processStack[index].status = .failed
                        print("file not found")
                        
                    }
                }
                
                break
            case .loading:
                // should wait for a response (fail or success)
                processStack[index].status = .done
                break
            case .done:
                // do noting
//                processStack[index].status =
                break
            case .failed:
                // do initial again
                processStack[index].status = .initial
                break
            }
            objectWillChange.send()
        }
        
    }
    
    private func detectIfPathExists(process: ProcessModel) -> Bool {
        switch process.type {
        case .wine: return checkWineExists()
        case .executable: return checkGameExists()
        case .replay: return checkReplayExistis()
        }
    }
    
    private func checkWineExists() -> Bool {
        let winePath = "/Applications/Wargaming.net Game Center.app/Contents/SharedSupport/wargaminggamecenter/Wargaming.net Game Center/wine"
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: winePath)
    }
    
    private func checkGameExists() -> Bool {
        let username = NSUserName()
        let gameFilePath = "/Users/\(username)/Library/Application Support/Wargaming.net Game Center/Bottles/wargaminggamecenter64/drive_c/Games/World_of_Tanks_EU/win64/WorldOfTanks.exe"
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: gameFilePath)
    }

    private func checkReplayExistis() -> Bool {
        let username = NSUserName()
        let replayFilePath = "/Users/\(username)/Library/Application Support/Wargaming.net Game Center/Bottles/wargaminggamecenter64/drive_c/Games/World_of_Tanks_EU/replays"
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: replayFilePath)
    }
    
}
