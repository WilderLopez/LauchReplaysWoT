//
//  String++.swift
//  LaunchReplaysWoT
//
//  Created by Wilder López on 1/6/24.
//

import Foundation

class AppHelper {
    static let shared = AppHelper()
    
    func getFileName(from filePath: String) -> String {
        let fileURL = URL(fileURLWithPath: filePath)
        return fileURL.lastPathComponent
    }

}
