//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode!
    private var ball : SKShapeNode!
    private var block : SKShapeNode!
    private var paddle : SKShapeNode!
    
    let categoryBall:UInt32 = 1 << 1 //0001
    let categoryBlock:UInt32 = 1 << 2 //0010
    let categoryPaddle:UInt32 = 1 << 3 //0100
    
    override func didMove(to view: SKView) {
        // Get label node from scene and store it for use later
        label = childNode(withName: "//helloLabel") as? SKLabelNode
        label.alpha = 0.0
        let fadeInOut = SKAction.sequence([.fadeIn(withDuration: 2.0),
                                           .fadeOut(withDuration: 2.0)])
        label.run(.repeatForever(fadeInOut))
        
        // Create ball
        let w = (size.width + size.height) * 0.02
        
        ball = SKShapeNode(circleOfRadius: w / 2.0)
        ball.fillColor = SKColor.white
        ball.physicsBody = SKPhysicsBody(circleOfRadius: w / 2.0)
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.friction = 0.0
        ball.physicsBody?.restitution = 1.0
        ball.physicsBody?.linearDamping = 0.0
        ball.physicsBody?.velocity = CGVector(dx: 200.0, dy: 200.0)
        
        ball.physicsBody?.categoryBitMask = categoryBall
        ball.physicsBody?.contactTestBitMask = categoryBlock | categoryPaddle
        
//        ball.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 200.0))
        addChild(ball)
        
        // Create blocks
        block = SKShapeNode(rectOf: CGSize(width: w * 2, height: w))
        block.fillColor = SKColor.gray
        block.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
                width: w * 2.0,
                height: w
            )
        )
        block.physicsBody?.affectedByGravity = false
        block.physicsBody?.categoryBitMask = categoryBlock
        block.physicsBody?.contactTestBitMask = categoryBall
        for i in 0...4 {
            for j in 0...10 {
                let b = block.copy() as! SKShapeNode
                b.position = CGPoint(
                    x: self.frame.midX + CGFloat(j - 5) * w * 2,
                    y: self.frame.midY + size.height / 3.0 + CGFloat(i - 5) * w)
                addChild(b)
            }
        }
        
        // Create paddle
        paddle = SKShapeNode(rectOf: CGSize(width: w * 4, height: w), cornerRadius: w * 0.2)
        paddle.fillColor = SKColor.red
        paddle.position = CGPoint(
            x: self.frame.midX,
            y: self.frame.midY - size.height / 3.0
        )
        paddle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
                width: w * 4,
                height: w
            )
        )
        paddle.physicsBody?.affectedByGravity = false
        paddle.physicsBody?.mass = 99999999.9
        paddle.physicsBody?.categoryBitMask = categoryPaddle
        addChild(paddle)
        
        self.physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let blockBody = contact.bodyA
        blockBody.affectedByGravity = true
    }
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
        paddle.position = CGPoint(
            x: (paddle.position.x + pos.x) / 2.0,
            y: paddle.position.y
        )
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    
    scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)
    
    // Present the scene
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
