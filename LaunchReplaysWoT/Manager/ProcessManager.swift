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
        .init(type: .executable, status: .loading, path: nil),
        .init(type: .replay, status: .failed, path: nil)
    ]

//    @Published var currentProcess : ProcessModel = .init()
    
}
