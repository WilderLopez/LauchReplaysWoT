//
//  NSOpenPanelExtension.swift
//  LaunchReplaysWoT
//
//  Created by Wilder López on 7/10/23.
//

import Foundation
import AppKit

extension NSOpenPanel {
    
//    static func openImage(completion: @escaping (_ result: Result<NSImage, Error>) -> ()) {
//        let panel = NSOpenPanel()
//        panel.allowsMultipleSelection = false
//        panel.canChooseFiles = true
//        panel.canChooseDirectories = false
//        panel.allowedFileTypes = ["jpg", "jpeg", "png", "heic"]
//        panel.canChooseFiles = true
//        panel.begin { (result) in
//            if result == .OK,
//                let url = panel.urls.first,
//                let image = NSImage(contentsOf: url) {
//                completion(.success(image))
//            } else {
//                completion(.failure(
//                    NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get file location"])
//                ))
//            }
//        }
//    }
//
    static func openFile(completion: @escaping (_ result: Result<MyFileItem, Error>) -> ()){
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
//        panel.allowedFileTypes = ["mp3"]
        panel.canChooseFiles = true
        panel.begin { (result) in
            if result == .OK,
                let url = panel.urls.first,
                let filename : String = url.pathComponents.last,
                let data = NSData(contentsOf: url) {
                
                var type = MyFileType.file
                var preview = NSImage(imageLiteralResourceName: "WotReplayFile")
                
                switch url.pathExtension.lowercased() {
                case "jpg","jpeg","png","heic", "gif":
                    type = .image
                    if let img = NSImage(contentsOf: url) {
                        preview = img
                        print("got it 🌅")
                    }
                    
                    print("Image 🌅")
                case "mp3", "wav", "m4a":
                    type = .audio
                    preview = NSImage(imageLiteralResourceName: "audio")
                    print("Audio 🔊")
                case "mp4", "avi", "mpg":
                    type = .video
                    preview = NSImage(imageLiteralResourceName: "video")
                    print("Video 📺")
                default:
                    type = .file
                    preview = NSImage(imageLiteralResourceName: "WotReplayFile")
                    print("File 📄")
                }
                
                let item : MyFileItem = .init(name: filename, data: data, type: type, preview: preview, url: url)
                completion(.success(item))
            } else {
                completion(.failure(
                    NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get file location"])
                ))
            }
        }
        
    }
}

struct MyFileItem{
    let name: String
    let data: NSData
    let type: MyFileType
    var preview : NSImage? = NSImage(imageLiteralResourceName: "file")
    var url: URL?
}

enum MyFileType {
    case audio, image, video, file
}
