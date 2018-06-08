//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

class GameScene: SKScene {
    
    private var label : SKLabelNode!
    private var ball : SKShapeNode!
    private var block : SKShapeNode!
    
    override func didMove(to view: SKView) {
        // Get label node from scene and store it for use later
        label = childNode(withName: "//helloLabel") as? SKLabelNode
        label.alpha = 0.0
        let fadeInOut = SKAction.sequence([.fadeIn(withDuration: 2.0),
                                           .fadeOut(withDuration: 2.0)])
        label.run(.repeatForever(fadeInOut))
        
        // Create shape node to use during mouse interaction
        let w = (size.width + size.height) * 0.02
        
        ball = SKShapeNode(circleOfRadius: w / 1.0)
        ball.fillColor = SKColor.white
        ball.physicsBody = SKPhysicsBody(circleOfRadius: w / 1.0)
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.velocity = CGVector(dx: 200.0, dy: 200.0)
//        ball.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 200.0))
        addChild(ball)
        
        block = SKShapeNode(rectOf: CGSize(width: w, height: w))
        block.fillColor = SKColor.gray
        block.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
                width: w,
                height: w
            )
        )
        block.physicsBody?.affectedByGravity = false
        for i in 1...10 {
            for j in 1...10 {
                if i==1 || i==10 || j==1 || j==10 {
                    let b = block.copy() as! SKShapeNode
                    b.position = CGPoint(
                        x: self.frame.midX + CGFloat(j - 5) * w,
                        y: self.frame.midY + CGFloat(i - 5) * w)
                    addChild(b)
                }
            }
        }
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        guard let n = ball.copy() as? SKShapeNode else { return }
        
        n.position = pos
        n.strokeColor = SKColor.green
        addChild(n)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        guard let n = self.ball.copy() as? SKShapeNode else { return }
        
        n.position = pos
        n.strokeColor = SKColor.blue
        addChild(n)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        guard let n = ball.copy() as? SKShapeNode else { return }
        
        n.position = pos
        n.strokeColor = SKColor.red
        addChild(n)
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
