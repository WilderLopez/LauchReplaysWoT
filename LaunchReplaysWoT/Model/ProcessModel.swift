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
        self.type = .lastReplay
        self.status = .initial
        definedPaths(for: type)
    }
    
    static func InitialModel() -> [ProcessModel] {
        let initialModel : [ProcessModel] = [
            .init(type: .wine, status: .initial, path: nil),
            .init(type: .executable, status: .initial, path: nil),
            .init(type: .lastReplay, status: .initial, path: nil)
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
        case .lastReplay:
            let replayFilePath = "/Users/\(username)/Library/Application Support/Wargaming.net Game Center/Bottles/wargaminggamecenter64/drive_c/Games/World_of_Tanks_\(self.region)/replays/replay_last_battle.wotreplay"
            path = replayFilePath
        case .replay(filename: let filename):
            let replayFilePath = "/Users/\(username)/Library/Application Support/Wargaming.net Game Center/Bottles/wargaminggamecenter64/drive_c/Games/World_of_Tanks_\(self.region)/replays/\(filename).wotreplay"
            path = replayFilePath
        case .notDefined:
            path = nil
        }
    }
}

extension ProcessModel {
    static func == (lhs: ProcessModel, rhs: ProcessModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.type == rhs.type &&
               lhs.status == rhs.status &&
               lhs.path == rhs.path &&
               lhs.region == rhs.region
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
    case wine, executable,lastReplay, notDefined
    case replay(filename: String)
    
    func getInfo() -> String {
        switch self {
        case .wine:
            return "Wine🍷 from Wargaming Center"
        case .executable:
            return "WorldOfTanks.exe"
        case .lastReplay:
            return "Your last battle replay file"
        case .replay(let name):
            return "Your replay: \(name)"
        default:
            return "Undefined process"
        }
    }
}

extension ProcessType: Equatable {
    static func == (lhs: ProcessType, rhs: ProcessType) -> Bool {
        switch (lhs, rhs) {
        case (.wine, .wine), (.executable, .executable), (.lastReplay, .lastReplay), (.notDefined, .notDefined):
            return true
        case (.replay(let filename1), .replay(let filename2)):
            return filename1 == filename2
        default:
            return false
        }
    }
}





