//
//  ContentView.swift
//  LaunchReplaysWoT
//
//  Created by Wilder López on 7/8/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var vm : ProcessManager = .init()
    @State var processStack : [ProcessModel] = []
        
    @State var currentFailedProcess: ProcessModel = .init()
    
    @State var idProcessHovered : UUID = .init()
    @State var shouldShowDragArea = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            ForEach(processStack, id: \.id) { process in
                RowView(process: process)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.purple, lineWidth: idProcessHovered == process.id ? 3 : 0))
                    .transition(.opacity)
                    .onHover { isHover in
                        withAnimation(.default) {
                            if isHover {
                                idProcessHovered = process.id
                            }else {
                                idProcessHovered = .init()
                            }
                        }
                    }
                    .onTapGesture {
                        debugPrint("tapped proccess: \(process.type) - \(process.status)")
                        
                        //select action for current process
                        vm.doAction(for: process)
                    }
                    .onAppear{
                        withAnimation(.default) {
                            vm.doAction(for: process)
                        }
                    }
                    
            }
            Spacer()
            
            if shouldShowDragArea {
                //Drag and Drop
                dragAndDropView
            }
            
        }
        .padding()
        .onReceive(vm.$processStack) { processStack in
            self.processStack = processStack
        }
        .onReceive(vm.$currentProcessFailed) { failedProcess in
            shouldShowDragArea = failedProcess != nil
            if let failedProcess = failedProcess {
                currentFailedProcess = failedProcess
            }
        }
    }
    
    func RowView(process: ProcessModel) -> some View {
         HStack {
            
            Text(process.getInfo())
                .multilineTextAlignment(.leading)
                .frame(minWidth: 30, maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            LoadingStatusView(status: process.status)
        }
        .padding(5)
        .frame(maxWidth: 350, alignment: .center)
        .background(Color.primary.colorInvert())
        .cornerRadius(10)
        .shadow(color: .gray, radius: 2, x: 0, y: 1)
        
    }
    
    func LoadingStatusView(status: ProcessStatus) -> some View {
        VStack {
            
            switch status {
            case .initial:
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.yellow)
                
            case .loading:
                ProgressView()
                
            case .done:
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.green)
                
            case .failed:
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.red)
            }
        }.frame(height: 40)
        
    }
    
    
    @State var isHoverDragArea = false
    var dragAndDropView : some View {
        ZStack {
            Color.purple.opacity(0.1)
            
            Text("Drag and Drop or click to search \(currentFailedProcess.type.getInfo())")
                .multilineTextAlignment(.center)
                .font(.title2)
                .foregroundColor(.purple)
                .overlay(
                    Rectangle()
                        .fill(Color.purple)
                        .frame(height: isHoverDragArea ? 2 : 0)
                        .offset(x: 0, y: 15)
                )
                
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(10, antialiased: true)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.purple.opacity(isHoverDragArea ? 1 : 0.5), style: StrokeStyle(lineWidth: 3, dash: [10])))
        .padding(10)
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
                    self.vm.currentProcessFailed?.path = item.url?.absoluteString
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
                                    self.vm.currentProcessFailed?.path = url.absoluteString
                                }
                            }
                        }
                    }
                }
                return true
            }
            return false
        }
    }
    
    var LaunchReplayButton: some View {
        Button {
            
        } label: {
            Text("Launch replay")
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
