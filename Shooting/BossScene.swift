import SpriteKit

class BossScene: GameBase{
    
    let boss = SKSpriteNode()
    var bossHealth = 500
    
    override func didMove(to view: SKView) {
        // 背景を設定
        makeBackground()
        
        // ラベルを設定
        makescoreLabel(pos: CGPoint(x: UIScreen.main.bounds.maxX - 100, y: UIScreen.main.bounds.maxY - 100))
        makebestscoreLabel(pos: CGPoint(x: UIScreen.main.bounds.minX + 100, y: UIScreen.main.bounds.maxY - 100))
        makeStageLabel(pos: CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY - 70))
        
        // シップを作成
        createShip()
        
        // 締め切り線を設定
        makeDeadline()
        
        // ボスを作成
        createBoss()
        
        // 衝突検出デリゲートを設定
        physicsWorld.contactDelegate = self
    }
    
    func createBoss() {
        boss.texture = SKTexture(imageNamed: "player")
        boss.size = CGSize(width: 200, height: 200)
        boss.position = CGPoint(x: frame.midX, y: frame.maxY - 150)
        boss.name = "boss"
        boss.zPosition = 2
        
        boss.physicsBody = SKPhysicsBody(rectangleOf: boss.frame.size)
        boss.physicsBody?.isDynamic = false
        boss.physicsBody?.affectedByGravity = false
        boss.physicsBody?.usesPreciseCollisionDetection = true
        boss.physicsBody?.categoryBitMask = PhysicsCategory.Boss
        boss.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
        
        addChild(boss)
        
        let moveRight = SKAction.moveBy(x: 100, y: 0, duration: 1.0)
        let moveLeft = SKAction.moveBy(x: -100, y: 0, duration: 1.0)
        let sequence = SKAction.sequence([moveRight, moveLeft])
        let repeatSequence = SKAction.repeatForever(sequence)
        
        boss.run(repeatSequence)
    }
    
    func bossAttack() {
        let bullet = SKSpriteNode()
        bullet.texture = SKTexture(imageNamed: "makaron1")
        bullet.size = CGSize(width: 30, height: 30)
        bullet.position = CGPoint(x: boss.position.x, y: boss.position.y - 200)
        bullet.name = "boss_bullet"
        
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Ship | PhysicsCategory.Boss
        
        addChild(bullet)
        
        let moveDown = SKAction.moveBy(x: 0, y: -frame.height, duration: 2.0)
        let delete = SKAction.removeFromParent()
        let sequenceActions = SKAction.sequence([moveDown, delete])
        
        bullet.run(sequenceActions)
    }
    
    override func explosion(pos: CGPoint) {
        let explosion = SKSpriteNode()
        explosion.size = CGSize(width: 100, height: 100)
        explosion.position = pos
        explosion.texture = SKTexture(imageNamed: "explosion")
        addChild(explosion)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            explosion.removeFromParent()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if currentTime.truncatingRemainder(dividingBy: 2.0) < 0.1 {
            bossAttack()
        }
    }
    
    override func didBegin(_ contact: SKPhysicsContact) {
        let collisionObject = contact.bodyA.categoryBitMask == PhysicsCategory.Boss ? contact.bodyB : contact.bodyA
        
        if collisionObject.categoryBitMask == PhysicsCategory.Bullet {
            explosion(pos: contact.contactPoint)
            bossHealth -= 10
            collisionObject.node?.removeFromParent()
            
            if bossHealth <= 0 {
                explosion(pos: contact.contactPoint)
                boss.removeFromParent()
                value.score += 1000
                value.boss.toggle()
                scoreLabel.text = "Score: \(value.score)"
                
                // ボスが倒された後の処理
                let scene = GameScene()
                scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                scene.scaleMode = .fill
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.nextLabel()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.view?.presentScene(scene)
                }
            }
        }
        
        if collisionObject.categoryBitMask == PhysicsCategory.Ship {
            if value.score > value.hero {
                value.hero = value.score
                bestScoreLabel.text = "BestScore: \(value.hero)"
            }
            GameOver()
        }
        
        if collisionObject.categoryBitMask == PhysicsCategory.Item {
            collisionObject.node?.removeFromParent()
            value.score += 50
            scoreLabel.text = "Score: \(value.score)"
        }
    }
}
