//
//  ContentView.swift
//  Shooting
//
//  Created by yuki on 2024/06/04.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    let screenwidth = UIScreen.main.bounds.width
    let screenheight = UIScreen.main.bounds.height
    
    var TitleScene: SKScene{
        let scene = Shooting.TitleScene()
        scene.size = CGSize(width: screenwidth, height: screenheight)
        scene.scaleMode = .fill
        scene.backgroundColor = .white
        return scene
    }
    
    var body: some View {
        SpriteView(scene:TitleScene)
            .frame(width: screenwidth, height: screenheight)
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
