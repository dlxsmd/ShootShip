import Foundation
import SpriteKit

class TitleScene: SKScene {
    
    let value = ValueManager.shared
    let startLabel = SKSpriteNode()
    let background = SKSpriteNode(imageNamed: "background")
    var backnpo: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        let BestscoreLabel = SKLabelNode(fontNamed: "Helvetica")
        BestscoreLabel.text = "BestScore: \(value.hero)"
        BestscoreLabel.fontSize = 25
        BestscoreLabel.position = CGPoint(x: UIScreen.main.bounds.maxX / 2, y: UIScreen.main.bounds.maxY - 100)
        BestscoreLabel.fontColor = .yellow
        BestscoreLabel.zPosition = 1
        addChild(BestscoreLabel)
        
        makeBackground()
        
        let titlediv = ["んぽちゃむ", "しゅ〜てぃんぐ"]
        for num in 0...1 {
            let titleLabel = SKLabelNode()
            titleLabel.text = titlediv[num]
            titleLabel.fontName = "JF-Dot-ShinonomeMaru-12-Regular"
            titleLabel.fontSize = 50
            titleLabel.fontColor = .white
            titleLabel.zPosition = 1
            titleLabel.position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY - 170 - CGFloat(num * 60))
            addChild(titleLabel)
        }
        
        backnpo = SKSpriteNode(imageNamed: "player")
        backnpo.size = CGSize(width: 200, height: 200)
        backnpo.position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        backnpo.zPosition = 1
        backnpo.name = "backnpo"
        addChild(backnpo)
        
        // 物理ボディを追加
        backnpo.physicsBody = SKPhysicsBody(circleOfRadius: backnpo.size.width / 2)
        backnpo.physicsBody?.isDynamic = true
        backnpo.physicsBody?.affectedByGravity = false
        backnpo.physicsBody?.allowsRotation = true
        backnpo.physicsBody?.restitution = 0.9 // 跳ね返りの強さ
        backnpo.physicsBody?.friction = 0.0
        backnpo.physicsBody?.linearDamping = 0.0
        
        // 壁を追加
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        startLabel.texture = SKTexture(imageNamed: "start")
        startLabel.size = CGSize(width: 200, height: 100)
        startLabel.position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.minY + 200)
        startLabel.zPosition = 2
        addChild(startLabel)
        
        print("title loading")
        
        // 初期状態でゆっくり動かす
        applyRandomImpulse(to: backnpo, withMagnitude: 50)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let location = touch!.location(in: self)
        
        if startLabel.contains(location) {
            let scene = Shooting.GameScene(size: self.size)
            scene.scaleMode = .fill
            scene.backgroundColor = .white
            self.view?.presentScene(scene)
        }else if backnpo.contains(location) {
                generatemakaron()
        } else {
            // ランダムな方向に飛ばす
            applyRandomImpulse(to: backnpo, withMagnitude: 100)
        }
    }
    

    
    func generatemakaron(){
        let makaron = SKSpriteNode(imageNamed: "makaron1")
        makaron.size = CGSize(width: 80, height: 80)
        makaron.position = CGPoint(x: backnpo.position.x + 20, y: backnpo.position.y + 50)
        makaron.zPosition = 1
        makaron.name = "makaron"
        addChild(makaron)
        
        // 物理ボディを追加
        makaron.physicsBody = SKPhysicsBody(circleOfRadius: makaron.size.width / 2)
        makaron.physicsBody?.isDynamic = true
        makaron.physicsBody?.affectedByGravity = false
        makaron.physicsBody?.allowsRotation = true
        makaron.physicsBody?.restitution = 0.9 // 跳ね返りの強さ
        makaron.physicsBody?.friction = 0.0
        makaron.physicsBody?.linearDamping = 0.0
        
        applyRandomImpulse(to: makaron, withMagnitude: 60)
        
//        if countSpriteNodes(name: "makaron") > 50 {
//            let scene = TabesugiScene(size: self.size)
//            scene.scaleMode = .fill
//            scene.backgroundColor = .black
//            self.view?.presentScene(scene)
//        }
    }
    
    func makeBackground(){
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        addChild(background)
    }
    
    func applyRandomImpulse(to node: SKNode, withMagnitude magnitude: CGFloat) {
        let randomX = CGFloat.random(in: -magnitude...magnitude)
        let randomY = CGFloat.random(in: -magnitude...magnitude)
        node.physicsBody?.applyImpulse(CGVector(dx: randomX, dy: randomY))
    }
}



