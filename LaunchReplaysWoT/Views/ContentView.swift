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
    @State var currentNewReplayProcess: ProcessModel = .init()
    
    @State var showDropAreaWhenFails = false
    
    @State var idProcessHovered : UUID = .init()
    
    @State var selectedRegion : GameRegion = .ASIA
    
    var body: some View {
        VStack(spacing: 20) {
            
            VStack {
                Picker("Choose your Region", selection: $selectedRegion) {
                    Text("Europe").tag(GameRegion.EU)
                    Text("North America").tag(GameRegion.NA)
                    Text("Russia").tag(GameRegion.RU)
                    Text("Asia").tag(GameRegion.ASIA)
                }.pickerStyle(.menu)
            }.onChange(of: selectedRegion) { newRegion in
                vm.chageRegion(newRegion)
            }
            
            
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
                            vm.chageRegion(selectedRegion)
//                            vm.doAction(for: process)
                        }
                    }
                    
            }
            Spacer()
            
            if showDropAreaWhenFails {
                VStack (spacing: 0) {
                    Text("⬇️ Try to add the missing file ⬇️\n\(currentFailedProcess.type.getInfo())")
                        .font(.title2)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    
                    DragAndDropView(currentProcess: $currentFailedProcess)
                        .onChange(of: currentFailedProcess) { newValue in
                            vm.currentProcessFailed?.path = newValue.path
                            vm.checkFirstProcessToDone()
                        }
                }
                
            }else { //new replay
                VStack(spacing: 0){
                    Text("⬇️ Add a replay file here ⬇️")
                        .font(.title2)
                        .foregroundColor(.purple)
                    
                    DragAndDropView(currentProcess: $currentNewReplayProcess)
                        .onChange(of: currentNewReplayProcess) { newValue in
                            vm.currentProcessFailed?.path = newValue.path
                        }
                }
            }
            
        }
        .padding()
        .onReceive(vm.$processStack) { processStack in
            self.processStack = processStack
        }
        .onReceive(vm.$currentProcessFailed) { failedProcess in
            showDropAreaWhenFails = failedProcess != nil
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
