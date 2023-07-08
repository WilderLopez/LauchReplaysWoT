//
//  ProcessModel.swift
//  LaunchReplaysWoT
//
//  Created by Wilder López on 7/8/23.
//

import Foundation

struct ProcessModel : Identifiable {
    var id: UUID
    
    var type: ProcessType
    var status: ProcessStatus
    var path: URL?
    
    init(type: ProcessType, status: ProcessStatus, path: URL?) {
        self.id = UUID()
        self.type = type
        self.status = status
        self.path = path
    }
    
    init() {
        self.id = UUID()
        self.type = .replay
        self.status = .initial
        self.path = nil
    }
    
    func getInfo() -> String {
        switch status {
        case .initial:
            return "Waiting to load \(type.getInfo())."
        case .loading:
            return "Loading \(type.getInfo())."
        case .done:
            return "\(type.getInfo()) has been loaded successfully."
        case .failed:
            return "Failed to load \(type.getInfo())."
        }
    }
}

enum ProcessStatus {
    case initial, loading, done, failed
}

enum ProcessType {
    case wine, executable, replay
    
    func getInfo() -> String {
        switch self {
        case .wine:
            return "Wine🍷 from Wargaming Center"
        case .executable:
            return "WorldOfTanks.exe"
        case .replay:
            return "Your replay file"
        }
    }
}


