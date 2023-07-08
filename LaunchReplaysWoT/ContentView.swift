//
//  ContentView.swift
//  LaunchReplaysWoT
//
//  Created by Wilder López on 7/8/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var vm : ProcessManager = .init()
    
//    @State var currentProcess : ProcessInfo = .loadingWine
    
    @State var processStep = 0
    
    var pathWine = ""
    var pathExecutable = ""
    var pathReplay = ""
    
    @State var shouldOverlayBorders = false
    @State var idProcessHovered : UUID = .init()
    
    var body: some View {
        VStack(spacing: 20) {
            
            ForEach(vm.processStack, id: \.id) { process in
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
                    }
                    
            }
            
                
//            if currentProcess == .readyToPlay {
//                LaunchReplayButton
//            } else {
//                LoadPathButton
//            }
            
            
            
        }
        .padding()
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
        }
        
    }
    
    var LoadPathButton : some View {
        Button {
//            processStep +=  processStep < 5 ? 1 : 0
//            currentProcess = ProcessInfo(rawValue: processStep) ?? .readyToPlay
        } label: {
            Text("Search path")
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
