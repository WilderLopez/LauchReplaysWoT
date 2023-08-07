//
//  ProcessModel.swift
//  LaunchReplaysWoT
//
//  Created by Wilder López on 7/8/23.
//

import Foundation

struct ProcessModel : Identifiable , Equatable{
    var id: UUID
    var type: ProcessType {
        didSet {
            definedPaths(for: type)
        }
    }
    var status: ProcessStatus
    var path: String?
    var region : GameRegion = .EU
    
    init(type: ProcessType, status: ProcessStatus, path: String?) {
        self.id = UUID()
        self.type = type
        self.status = status
        self.path = path
        definedPaths(for: type)
    }
    
    init() {
        self.id = UUID()
        self.type = .replay
        self.status = .initial
        definedPaths(for: type)
    }
    
    static func InitialModel() -> [ProcessModel] {
        let initialModel : [ProcessModel] = [
            .init(type: .wine, status: .initial, path: nil),
            .init(type: .executable, status: .initial, path: nil),
            .init(type: .replay, status: .initial, path: nil)
        ]
        return initialModel
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
    
    public mutating func changeRegion(_ value: GameRegion) {
        self.region = value
        status = .initial
        definedPaths(for: type)
    }
    
    private mutating func definedPaths(for type: ProcessType) {
        let username = NSUserName()
        switch type {
        case .wine:
            let wineFilePath = "/Applications/Wargaming.net Game Center.app/Contents/SharedSupport/wargaminggamecenter/Wargaming.net Game Center/wine"
            path = wineFilePath
        case .executable:
            let gameFilePath = "/Users/\(username)/Library/Application Support/Wargaming.net Game Center/Bottles/wargaminggamecenter64/drive_c/Games/World_of_Tanks_\(self.region)/win64/WorldOfTanks.exe"
            path = gameFilePath
        case .replay:
            let replayFilePath = "/Users/\(username)/Library/Application Support/Wargaming.net Game Center/Bottles/wargaminggamecenter64/drive_c/Games/World_of_Tanks_\(self.region)/replays/replay_last_battle.wotreplay"
            path = replayFilePath
        case .notDefined:
            path = nil
        }
    }
}

enum GameRegion : String {
    case EU = "EU"
    case NA = "NA"
    case RU = "RU"
    case ASIA = "ASIA"
}

enum ProcessStatus {
    case initial, loading, done, failed
}

enum ProcessType {
    case wine, executable, replay, notDefined
    
    func getInfo() -> String {
        switch self {
        case .wine:
            return "Wine🍷 from Wargaming Center"
        case .executable:
            return "WorldOfTanks.exe"
        case .replay:
            return "Your last battle replay file"
        default:
            return "Undefined process"
        }
    }
}




