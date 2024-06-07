//
//  GameOverScene.swift
//  Shooting
//
//  Created by yuki on 2024/06/05.
//

import Foundation
import SpriteKit

class GameOverScene:SKScene{
    
    let value = ValueManager.shared
    
    let restartLabel = SKLabelNode(fontNamed: "Helvetica")
    let titleLabel = SKLabelNode(fontNamed: "Helvetica")
    
    override func didMove(to view: SKView) {
        
        let BestscoreLabel = SKLabelNode(fontNamed: "Helvetica")
        BestscoreLabel.text = "BestScore: \(value.hero)"
        BestscoreLabel.fontSize = 25
        BestscoreLabel.position = CGPoint(x: UIScreen.main.bounds.maxX / 2, y: UIScreen.main.bounds.maxY - 100)
        BestscoreLabel.fontColor = .white
        addChild(BestscoreLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel.text = "YourScore: \(value.score)"
        scoreLabel.fontSize = 25
        scoreLabel.position = CGPoint(x: UIScreen.main.bounds.maxX / 2, y: UIScreen.main.bounds.maxY - 300)
        scoreLabel.fontColor = .white
        addChild(scoreLabel)
        
        restartLabel.text = "Restart"
        restartLabel.fontSize = 30
        restartLabel.position = CGPoint(x: UIScreen.main.bounds.maxX / 4, y: UIScreen.main.bounds.minY + 100 )
        restartLabel.fontColor = .red
        addChild(restartLabel)
        
        titleLabel.text = "Title"
        titleLabel.fontSize = 30
        titleLabel.position = CGPoint(x: UIScreen.main.bounds.maxX * (3/4), y: UIScreen.main.bounds.minY + 100 )
        titleLabel.fontColor = .blue
        addChild(titleLabel)
        
        print("gameover loading")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let location = touch!.location(in: self)
        
        if restartLabel.contains(location){
            value.score = 0
            value.stage = 0
            let scene = Shooting.GameScene(size: self.size)
            scene.scaleMode = .fill
            scene.backgroundColor = .white
            self.view?.presentScene(scene)
        }
        if titleLabel.contains(location){
            value.score = 0
            value.stage = 0
            let scene = Shooting.TitleScene(size: self.size)
            scene.scaleMode = .fill
            scene.backgroundColor = .white
            self.view?.presentScene(scene)
        }
    }
    
}
