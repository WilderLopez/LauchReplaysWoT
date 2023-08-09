//
//  DragAndDropView.swift
//  LaunchReplaysWoT
//
//  Created by Wilder López on 7/10/23.
//

import Foundation
import SwiftUI

struct DragAndDropView :  View {
    
    @Binding var currentProcess : ProcessModel
    @State var isHoverDragArea = false
    @State var showAlertMissingFile = false
    
    var body : some View {
        ZStack {
            Color.accentColor.opacity(0.1)
            
            Text("Drag and Drop or click to search the file")
                .padding(.horizontal, 20)
                .multilineTextAlignment(.center)
                .font(.title3)
                .foregroundColor(Color.accentColor.opacity(isHoverDragArea ? 1 : 0.5))
                
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(10, antialiased: true)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.accentColor.opacity(isHoverDragArea ? 1 : 0.5), style: StrokeStyle(lineWidth: 3, dash: [10])))
//        .padding(10)
        .onHover { isHover in
            withAnimation(.default) {
                isHoverDragArea = isHover
            }
        }
        .onTapGesture {
            //open sheet folder
            NSOpenPanel.openFile { result in
                if case let .success(item) = result {
                    debugPrint("item loaded: \(item.name)")
                    
                    //checking for right file
                    switch self.currentProcess.type {
                    case .wine:
                        guard item.url?.pathExtension == "wine" else {
                            debugPrint("🔥 wine file dont match")
                            self.showAlertMissingFile = true
                            return }
                        break
                    case .executable:
                        guard item.url?.lastPathComponent == "WorldOfTanks.exe" else {
                            debugPrint("🔥 WorldOfTanks.exe file dont match")
                            self.showAlertMissingFile = true
                            return }
                        break
                    case .replay:
                        guard item.url?.pathExtension == "wotreplay" else {
                            debugPrint("🔥 .wotreplay file dont match")
                            self.showAlertMissingFile = true
                            return }
                        break
                    default : break
                    }
                    
                    self.currentProcess.path = item.url?.relativePath.replacingOccurrences(of: "%20", with: " ")
                }
            }
        }
        .onDrop(of: ["public.url" , "public.file-url"], isTargeted: nil) { (items) -> Bool in
            if let item = items.first {
                if let identifier = item.registeredTypeIdentifiers.first {
                    if identifier == "public.url" || identifier == "public.file-url" {
                        item.loadItem(forTypeIdentifier: identifier, options: nil) { (urlData, error) in
                            DispatchQueue.main.async {
                                if let urlData = urlData as? Data {
                                    let url = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
                                    debugPrint("File URL Droped: \(url)")
                                    
                                    switch self.currentProcess.type {
                                    case .wine:
                                        guard url.pathExtension == "wine" else {
                                            debugPrint("🔥 wine file dont match")
                                            self.showAlertMissingFile = true
                                            return }
                                        break
                                    case .executable:
                                        guard url.lastPathComponent == "WorldOfTanks.exe" else {
                                            debugPrint("🔥 WorldOfTanks.exe file dont match")
                                            self.showAlertMissingFile = true
                                            return }
                                        break
                                    case .replay:
                                        guard url.pathExtension == "wotreplay" else {
                                            debugPrint("🔥 .wotreplay file dont match")
                                            self.showAlertMissingFile = true
                                            return }
                                        break
                                    default : break
                                    }
                                    
                                    self.currentProcess.path = url.relativePath.replacingOccurrences(of: "%20", with: " ")
                                }
                            }
                        }
                    }
                }
                return true
            }
            return false
        }
        .alertSupportMacOS12(isPresented: $showAlertMissingFile)
        .frame(height: 100)
    }
}


struct DragAndDropView_Preview: PreviewProvider {
    static var previews: some View {
        VStack{
            
            DragAndDropView(currentProcess: .constant(ProcessModel()))
        }
        .frame(width: 360, height: 400, alignment: .center)
        .mainBackgroundSupportable()
    }
}
