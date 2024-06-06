//
//  TitleScene.swift
//  Shooting
//
//  Created by yuki on 2024/06/05.
//

import Foundation
import SpriteKit

class TitleScene:SKScene{
        
        let startLabel = SKLabelNode(fontNamed: "Helvetica")
        
        override func didMove(to view: SKView) {
            
            let BestscoreLabel = SKLabelNode(fontNamed: "Helvetica")
            BestscoreLabel.text = "BestScore: \(ScoreManager.shared.hero)"
            BestscoreLabel.fontSize = 25
            BestscoreLabel.position = CGPoint(x: UIScreen.main.bounds.maxX / 2, y: UIScreen.main.bounds.maxY - 100)
            BestscoreLabel.fontColor = .red
            addChild(BestscoreLabel)
            
            startLabel.text = "Start"
            startLabel.fontSize = 50
            startLabel.position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            startLabel.fontColor = .blue
            addChild(startLabel)
            
            print("title loading")
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            
            let touch = touches.first
            let location = touch!.location(in: self)
            
            if startLabel.contains(location){
                let scene = Shooting.GameScene(size: self.size)
                scene.scaleMode = .fill
                scene.backgroundColor = .white
                self.view?.presentScene(scene)
            }
        }
    
}
