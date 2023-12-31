//
//  ProcessManager.swift
//  LaunchReplaysWoT
//
//  Created by Wilder López on 7/8/23.
//

import Foundation
import SwiftUI

class ProcessManager: ObservableObject {
    
    @Published var processStack : [ProcessModel] = ProcessModel.InitialModel()
    @Published var currentProcessFailed : ProcessModel? = nil
    
    @Published var isProcessRunning = false
    
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
                    if self.checkFileExists(for: process) {
                        self.processStack[index].status = .done
                        print("file exist with default url")
                        self.checkFirstProcessToFail()
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
                self.checkFirstProcessToFail()
                break
            case .failed:
                // do initial again
                processStack[index].status = .initial
                doAction(for: processStack[index])
                break
            }
            objectWillChange.send()
        }
        
    }
    
    @discardableResult
    func updateProcessWith(newPath: String) -> Bool {
        
        if let index = processStack.firstIndex(where: { $0.type == .lastReplay ||
            $0.type != .wine && $0.type != .executable && $0.type != .notDefined }) {
            processStack[index].path = newPath
            let filename = AppHelper.shared.getFileName(from: newPath)
            processStack[index].type = .replay(filename: filename)
            return true
        }
        return false
    }
    
    func checkFirstProcessToDone() {
        guard let currentProcessFailed = currentProcessFailed else { return }
        if let index = processStack.firstIndex(where: {$0.id == currentProcessFailed.id}) {
            processStack[index].path = currentProcessFailed.path
//            processStack[index].status = .initial
            doAction(for: currentProcessFailed)
        }
    }
    
    //TODO: chequear la visibilidad (Posible metodo private)
    func checkFirstProcessToFail() {
        currentProcessFailed = processStack.first(where: {$0.status == .failed})
    }
    
    func chageRegion(_ value: GameRegion) {
        for (index, process) in processStack.enumerated() {
            if process.type != .wine {
                processStack[index].changeRegion(value)
            }
        }
        
        processStack.forEach { [weak self] process in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.doAction(for: process)
            }
        }
    }
    
    private func checkFileExists(for process: ProcessModel) -> Bool {
        
        if let filePath = process.path{
            debugPrint("fie path ", filePath)
            let fileManager = FileManager.default
            return fileManager.fileExists(atPath: filePath)
        }
        return false
    }
    
    func launchReplay(){
        var pathWine: String?
        var pathExe: String?
        var pathReplay: String?
        
        processStack.forEach { process in
            switch process.type {
            case .wine:
                pathWine = process.path
            case .executable:
                pathExe = process.path
            case .lastReplay , .replay(filename: _):
                pathReplay = process.path
            case .notDefined:
                return
            }
        }
        
        guard let pathWine = pathWine?.replacingOccurrences(of: " ", with: "\\ "),
              let pathExe = pathExe?.replacingOccurrences(of: " ", with: "\\ "),
              let pathReplay = pathReplay?.replacingOccurrences(of: " ", with: "\\ ") else { return }

        let command = "\(pathWine) \(pathExe) \(pathReplay)"
        print("command: \(command)")
//        TerminalHelper.shared.executeCommand(command)
        isProcessRunning = true
        TerminalHelper.shared.executeCommand(command) { [unowned self] output in
            print("Output: \(output)")
            DispatchQueue.main.async {
                self.isProcessRunning = false
            }
        }
    }
    
}
