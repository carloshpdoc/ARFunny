//
//  ContentView.swift
//  ARFunnyFace
//
//  Created by Carlos Henrique on 14/03/21.
//

import SwiftUI
import RealityKit
import ARKit

var arView: ARView!
var robot: Experience.Robo!


struct ContentView : View {
    @State var propId: Int = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(propId: $propId).edgesIgnoringSafeArea(.all)
            HStack {
                Spacer()
                
                Button(action: {
                    self.propId = self.propId <= 0 ? 0 : self.propId - 1
                }) {
                    Image("PreviousButton").clipShape(Circle())
                }
                
                Spacer()
                
                Button(action: {
                    self.TakeSnapshot()
                }) {
                    Image("ShutterButton").clipShape(Circle())
                }
                
                Spacer()
                
                Button(action: {
                    self.propId = self.propId >= 3 ? 3 : self.propId + 1
                    
                }) {
                    Image("NextButton").clipShape(Circle())
                }
                
                Spacer()
                
            }
        }
    }
    
    func TakeSnapshot() {
        arView.snapshot(saveToHDR: false) { (image) in
            
            let compressedImage = UIImage(data: (image?.pngData())!)
            
            UIImageWriteToSavedPhotosAlbum(
                compressedImage!, nil, nil, nil)
        }
    }
    
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var propId: Int
    
    func makeUIView(context: Context) -> ARView {
        
        arView = ARView(frame: .zero)
        arView.session.delegate = context.coordinator
        
        return arView
    }
    
    func makeCoordinator() -> ARDelegateHandler {
      ARDelegateHandler(self)
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        robot = nil
        arView.scene.anchors.removeAll()
        
        let arConfiguration = ARFaceTrackingConfiguration()
        
        uiView.session.run(arConfiguration,
                           options:[.resetTracking, .removeExistingAnchors])
        
        switch(propId) {
        
        case 0: // Olhos
            let arAnchor = try! Experience.loadOlhos()
            uiView.scene.anchors.append(arAnchor)
            break
            
        case 1: // Oculos
            let arAnchor = try! Experience.loadOculos()
            uiView.scene.anchors.append(arAnchor)
            break
            
        case 2: // Bigode
            let arAnchor = try! Experience.loadBigode()
            uiView.scene.anchors.append(arAnchor)
            break
        case 3: // Robo
            // 1
            let arAnchor = try! Experience.loadRobo()
            uiView.scene.anchors.append(arAnchor)

            robot = arAnchor
            break
        default:
            break
        }
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
