//
//  GameScene.swift
//  Aerial Evasion
//
//  Created by Roy Chowthi on 8/21/20.
//  Copyright © 2020 Roy Chowthi. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation
import UnityAds


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    weak var viewController:GameViewController?
    var background: SKEmitterNode!
    var background2: SKEmitterNode!
    var background3: SKEffectNode!
    var cloud:SKSpriteNode!
    var cloud2:SKSpriteNode!
    var lightning: SKEffectNode!
    var player:SKSpriteNode!
    var buildings:SKSpriteNode!
    var playerscore:SKLabelNode!
    var winner:SKLabelNode!
    var loser:SKLabelNode!
    var bosshealth:SKLabelNode!
    var score: Int = 0{
        didSet{
            playerscore.text = "SCORE:\(score)"
        }
    }
    var possiblebuildings = ["pptbuilding.png", "pptbuilding2.png", "pptbuilding3.png"]
    var possiblebackgrounds = ["mybackground.jpg", "mybackground2.jpg", "mybackground3.jpg"]
    var possibleufos = ["ufosprite2.jpg", "ufosprite3.jpg"]
    var ufopod: SKSpriteNode!
    var missiles:SKSpriteNode!
    var mothership:SKSpriteNode!
    var thrust: SKEmitterNode!
    var ufo: SKSpriteNode!
    var vely:CGFloat = 0
    var velx:CGFloat = 0
    var gametimer:Timer!
    var gametimer2:Timer!
    var gametimer3:Timer!
    var gametimer4:Timer!
    var lightningtimer:Timer!
    var mothershiptimer:Timer!
    var bullets: SKSpriteNode!
    var bombs: SKSpriteNode!
    var laser: SKSpriteNode!
    var timer1:Int = 0
    var timer2:Int = 0
    var timer3:Int = 0
    var thrusting:Int = 0
    var firecheck:Int = 0
    var mothershiphealth:Int = 100{
        didSet{
            bosshealth.text = "BOSS HP:\(mothershiphealth)"
        }
    }
    let playerbit:UInt32 = 0x1 << 0
    let obstaclebit:UInt32 = 0x1 << 1
    let cloudbit:UInt32 = 0x1 << 3
    
    override func didMove(to view: SKView){
        
        
        backgroundColor = UIColor.black
        self.possiblebackgrounds = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: self.possiblebackgrounds) as! [String]
        let background = SKSpriteNode(imageNamed: self.possiblebackgrounds[0])
        background.position = CGPoint(x: 2, y: 100)
        background.size.width = self.size.width
        background.size.height = self.size.height
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = 1
        self.addChild(background)
    
        let background2 = SKSpriteNode(imageNamed:"black.jpg")
        background2.position = CGPoint(x:0, y :-560)
        background2.size.width = self.size.width
        background2.size.height = self.size.height/6
        background2.zPosition = 3
        self.addChild(background2)
        
        let background3 = SKSpriteNode(imageNamed:"black.jpg")
        background3.position = CGPoint(x:0, y :560)
        background3.size.width = self.size.width
        background3.size.height = self.size.height/6
        background3.zPosition = 3
        self.addChild(background3)
        
        bosshealth = SKLabelNode(text: "BOSS HP: 100")
        bosshealth.position = CGPoint(x:190, y:460)
        bosshealth.fontName = "AmericanTypewriter-bold"
        bosshealth.fontSize = 45
        bosshealth.fontColor = UIColor.white
        bosshealth.zPosition = 4
        bosshealth.isHidden = true
        mothershiphealth = 100
        self.addChild(bosshealth)
        
        playerscore = SKLabelNode(text: "SCORE: 0")
        playerscore.position = CGPoint(x: -220, y: 460)
        playerscore.fontName = "AmericanTypewriter-bold"
        playerscore.fontSize = 45
        playerscore.fontColor = UIColor.white
        playerscore.zPosition = 4
        playerscore.isHidden = false
        score = 0
        self.addChild(playerscore)
        
        loser = SKLabelNode(text: "YOU LOSE")
        loser.position = CGPoint(x: 0, y: 300)
        loser.fontName = "AmericanTypewriter-bold"
        loser.fontSize = 70
        loser.fontColor = UIColor.white
        loser.zPosition = 4
        loser.isHidden = true
        self.addChild(loser)
        
        winner = SKLabelNode(text: "YOU WIN")
        winner.position = CGPoint(x: 0, y: 300)
        winner.fontName = "AmericanTypewriter-bold"
        winner.fontSize = 70
        winner.fontColor = UIColor.white
        winner.zPosition = 4
        winner.isHidden = true
        self.addChild(winner)
       
        self.physicsWorld.contactDelegate = self
        player = SKSpriteNode(imageNamed: "jetsprite.png")
        player.name = "player"
        player.position = CGPoint(x: -250 , y: player.size.height / 2)
        player.zPosition = 3
        self.addChild(player)
        player.size.height = self.size.height/11
        player.size.width = self.size.width/5
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        player.physicsBody?.categoryBitMask = playerbit
        player.physicsBody?.contactTestBitMask = obstaclebit
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.isDynamic = true
        player.physicsBody?.usesPreciseCollisionDetection = true
        
        cloud = SKSpriteNode(imageNamed:"clouds.png" )
        cloud.position = CGPoint(x:400, y: 400)
        cloud.size.width = self.size.width/4
        cloud.size.height = self.size.height/9
        cloud.zPosition = 2
        cloud.physicsBody = SKPhysicsBody(rectangleOf: cloud.size)
        cloud.physicsBody?.density = 10000.0
        cloud.physicsBody?.restitution = 10000.0
        cloud.physicsBody?.angularDamping = 10000.0
        cloud.physicsBody?.categoryBitMask = 0
        cloud.physicsBody?.collisionBitMask = 0
        cloud.physicsBody?.isDynamic = true
        cloud.physicsBody?.velocity.dx = -200
        self.addChild(cloud)
        
        cloud2 = SKSpriteNode(imageNamed:"clouds.png" )
        cloud2.position = CGPoint(x:400, y: 300)
        cloud2.size.width = self.size.width/4
        cloud2.size.height = self.size.height/9
        cloud2.zPosition = 2
        cloud2.physicsBody = SKPhysicsBody(rectangleOf: cloud2.size)
        cloud2.physicsBody?.categoryBitMask = 0
        cloud2.physicsBody?.collisionBitMask = 0
        cloud2.physicsBody?.density = 10000.0
        cloud2.physicsBody?.restitution = 10000.0
        cloud2.physicsBody?.angularDamping = 10000.0
        cloud2.physicsBody?.isDynamic = true
        cloud2.physicsBody?.velocity.dx = -250
        self.addChild(cloud2)
        
        gametimer = Timer.scheduledTimer(timeInterval: 0.9 , target: self, selector: #selector(addufo), userInfo: nil , repeats: true)
        
        gametimer2 = Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(addmissile), userInfo: nil, repeats: true)
        
        gametimer3 = Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(addbuildings), userInfo: nil, repeats: true)
        
        gametimer4 = Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(addufopod), userInfo: nil, repeats: true)
        
        lightningtimer = Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(addlightning), userInfo: nil, repeats: true)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width, height: player.size.height/3))
        
        
        
        
    
    }
    @objc func addlightning(){
        let lightning = SKSpriteNode(imageNamed: "lightning.png")
        let lightningposition = GKRandomDistribution(lowestValue: -150, highestValue: 150)
        let position = CGFloat(lightningposition.nextInt())
        lightning.position = CGPoint(x:position, y: 200)
        lightning.size.width = self.size.width
        lightning.size.height = self.size.height/3
        lightning.zPosition = 2
        self.addChild(lightning)
        self.run(SKAction.playSoundFileNamed("lightningsound.wav", waitForCompletion: true))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            lightning.removeFromParent()
        }
            
    }
    
    @objc func addufo(){
        self.possibleufos =
            GKRandomSource.sharedRandom().arrayByShufflingObjects(in: self.possibleufos) as! [String]
        let ufo = SKSpriteNode(imageNamed: self.possibleufos[0])
        ufo.name = "ufo"
        let randomposition = GKRandomDistribution(lowestValue: 0, highestValue: 400)
        let position = CGFloat(randomposition.nextInt())
        ufo.position = CGPoint(x:330, y: position)
        ufo.size.width = self.size.width/5
        ufo.size.height = self.size.height/8
        ufo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ufo.size.width/2, height: ufo.size.height/2))
        ufo.physicsBody?.density = 10000.0
        ufo.physicsBody?.restitution = 10000.0
        ufo.physicsBody?.angularDamping = 10000.0
        ufo.physicsBody?.categoryBitMask = obstaclebit
        ufo.physicsBody?.contactTestBitMask = playerbit
        ufo.physicsBody?.collisionBitMask = 0
        ufo.physicsBody?.isDynamic = true
        ufo.physicsBody?.usesPreciseCollisionDetection = true
        ufo.zPosition = 2
        self.addChild(ufo)
        
        let animationDuration:TimeInterval = 3
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: -330, y:position), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        ufo.run(SKAction.sequence(actionArray))
        score = score + 20
        timer1 = timer1 + 1
        if(timer1 == 200){
            gametimer.invalidate()
        }
        
    }
    
    @objc func addufopod(){
        if(timer1 == 200){
            let ufopod = SKSpriteNode(imageNamed: "ufosprite.jpg")
            ufopod.name = "ufopod"
            let randomposition = GKRandomDistribution(lowestValue: 0, highestValue: 400)
            let position = CGFloat(randomposition.nextInt())
            ufopod.position = CGPoint(x:330, y: position)
            ufopod.size.width = self.size.width/10
            ufopod.size.height = self.size.height/20
            ufopod.physicsBody = SKPhysicsBody(rectangleOf: ufopod.size)
            ufopod.physicsBody?.density = 10000.0
            ufopod.physicsBody?.restitution = 10000.0
            ufopod.physicsBody?.angularDamping = 10000.0
            ufopod.physicsBody?.categoryBitMask = obstaclebit
            ufopod.physicsBody?.contactTestBitMask = playerbit
            ufopod.physicsBody?.collisionBitMask = 0
            ufopod.physicsBody?.isDynamic = true
            ufopod.physicsBody?.usesPreciseCollisionDetection = true
            ufopod.zPosition = 2
            self.addChild(ufopod)
            
            let animationDuration:TimeInterval = 2
            var actionArray = [SKAction]()
            actionArray.append(SKAction.move(to: CGPoint(x: -330, y:position), duration: animationDuration))
            actionArray.append(SKAction.removeFromParent())
            ufopod.run(SKAction.sequence(actionArray))
            score = score + 20
            timer2 = timer2 + 1
            if(timer2 == 200){
                gametimer4.invalidate()
            }
            
        }
    }
   
    @objc func addmissile(){
        if (timer2 >= 200)
        {
            missiles = SKSpriteNode(imageNamed:"missiles")
            missiles.name = "missiles"
            let randomposition = GKRandomDistribution(lowestValue: 0, highestValue: 310)
            let position2 = CGFloat(randomposition.nextInt())
            missiles.position = CGPoint(x:330, y: position2)
            missiles.size.width = self.size.width/6
            missiles.size.height = self.size.height/6
            missiles.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: missiles.size.width/3, height: missiles.size.height/6))
            missiles.physicsBody?.density = 10000.0
            missiles.physicsBody?.restitution = 10000.0
            missiles.physicsBody?.angularDamping = 10000.0
            missiles.physicsBody?.collisionBitMask = 0
            missiles.physicsBody?.categoryBitMask = obstaclebit
            missiles.physicsBody?.contactTestBitMask = playerbit
            missiles.physicsBody?.isDynamic = true
            missiles.physicsBody?.usesPreciseCollisionDetection = true
            missiles.zPosition = 2
            self.addChild(missiles)
            
          
            self.run(SKAction.playSoundFileNamed("missilesound.wav", waitForCompletion: false))
            let animationDuration2:TimeInterval = 1
            var actionArray2 = [SKAction]()
            actionArray2.append(SKAction.move(to: CGPoint(x: -330, y:position2), duration: animationDuration2))
            actionArray2.append(SKAction.removeFromParent())
            missiles.run(SKAction.sequence(actionArray2))
            score = score + 50
            timer2 = timer2 + 1
            if(timer2 == 500){
                self.gametimer2.invalidate()
             
            }
        }
    }
    
    
    @objc func addbuildings() {
            
        let animationDuration3:TimeInterval = 2
        var actionArray3 = [SKAction]()
        possiblebuildings = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possiblebuildings) as! [String]
        let buildings = SKSpriteNode(imageNamed: possiblebuildings[0])
        buildings.name = "buildings"
        buildings.position = CGPoint(x:330, y: -340)
        buildings.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:buildings.size.width, height: buildings.size.height))
        buildings.physicsBody?.density = 10000.0
        buildings.physicsBody?.restitution = 10000.0
        buildings.physicsBody?.angularDamping = 10000.0
        buildings.physicsBody?.collisionBitMask = 0
        buildings.physicsBody?.categoryBitMask = obstaclebit
        buildings.physicsBody?.contactTestBitMask = playerbit
        buildings.physicsBody?.isDynamic = true
        buildings.physicsBody?.usesPreciseCollisionDetection = true
        buildings.zPosition = 2
        self.run(SKAction.playSoundFileNamed("acceleratejetnoise.wav", waitForCompletion: false))
        self.addChild(buildings)
        actionArray3.append(SKAction.move(to: CGPoint(x: -330, y:buildings.position.y), duration: animationDuration3))
        actionArray3.append(SKAction.removeFromParent())
        buildings.run(SKAction.sequence(actionArray3))
            
        score = score + 100
        self.timer3 = self.timer3 + 1
        if(self.timer3 == 700){
            self.gametimer3.invalidate()
            self.lightningtimer.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                self.TheMotherShip()
                
                }
        }
}
    @objc func TheMotherShip() {
        bosshealth.isHidden = false
        mothership = SKSpriteNode(imageNamed:"mothership")
        mothership.name = "mothership"
        mothership.position = CGPoint(x:500, y: 100)
        mothership.size.width = self.size.width/0.5
        mothership.size.height = self.size.height/2
        mothership.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: mothership.size.width/5, height: mothership.size.height/5))
        mothership.physicsBody?.density = 10000.0
        mothership.physicsBody?.restitution = 10000.0
        mothership.physicsBody?.angularDamping = 10000.0
        mothership.physicsBody?.collisionBitMask = 0
        mothership.physicsBody?.categoryBitMask = obstaclebit
        mothership.physicsBody?.contactTestBitMask = playerbit
        mothership.physicsBody?.isDynamic = true
        mothership.physicsBody?.usesPreciseCollisionDetection = true
        mothership.zPosition = 2
        self.addChild(mothership)
          
        
        
        let animationDuration2:TimeInterval = 120
        var actionArray2 = [SKAction]()
        actionArray2.append(SKAction.move(to: CGPoint(x: 0, y:100), duration: animationDuration2))
        mothership.run(SKAction.sequence(actionArray2))
        
        mothershiptimer = Timer.scheduledTimer(timeInterval: 0.8, target:
            self, selector: #selector(mothershipweapon), userInfo: nil, repeats: true)
    }
    
    @objc func mothershipweapon(){
        let randomposition = GKRandomDistribution(lowestValue: -200, highestValue: 200)
        let position2 = CGFloat(randomposition.nextInt())
        laser = SKSpriteNode(imageNamed:"laser")
        laser.name = "mothershiplaser"
        laser.position = CGPoint(x:500 + position2, y: 100 + position2)
        laser.size.width = self.size.width/10
        laser.size.height = self.size.height/100
        laser.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: laser.size.width, height: laser.size.height))
        laser.physicsBody?.density = 10000.0
        laser.physicsBody?.restitution = 10000.0
        laser.physicsBody?.angularDamping = 10000.0
        laser.physicsBody?.collisionBitMask = 0
        laser.physicsBody?.categoryBitMask = obstaclebit
        laser.physicsBody?.contactTestBitMask = playerbit
        laser.physicsBody?.isDynamic = true
        laser.physicsBody?.usesPreciseCollisionDetection = true
        laser.zPosition = 2
        self.addChild(laser)
                 
        self.run(SKAction.playSoundFileNamed("mothershiplasersound.wav", waitForCompletion: false))
               
        let animationDuration2:TimeInterval = 1
        var actionArray2 = [SKAction]()
        actionArray2.append(SKAction.move(to: CGPoint(x: -500 + position2, y:100 + position2), duration: animationDuration2))
        actionArray2.append(SKAction.removeFromParent())
        laser.run(SKAction.sequence(actionArray2))
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstbody:SKPhysicsBody
        var secondbody: SKPhysicsBody
        
        if contact.bodyA.node?.name == "player"{
            Collision()
        }
        else if (contact.bodyA.node?.name == "bullets") && (contact.bodyB.node?.name == "ufo"){
            firstbody = contact.bodyA
            secondbody = contact.bodyB
            hitufo(bullets: firstbody.node as! SKSpriteNode, ufo: secondbody.node as! SKSpriteNode)
        }
        else if (contact.bodyA.node?.name == "bombs") && (contact.bodyB.node?.name == "buildings"){
            firstbody = contact.bodyA
            secondbody = contact.bodyB
            hitbuildings(bombs: firstbody.node as! SKSpriteNode, buildings: secondbody.node as! SKSpriteNode)
        }
        else if (contact.bodyA.node?.name == "bullets") && (contact.bodyB.node?.name == "missiles"){
            firstbody = contact.bodyA
            secondbody = contact.bodyB
            hitmissiles(bullets: firstbody.node as! SKSpriteNode, missiles: secondbody.node as! SKSpriteNode)
        }
        else if (contact.bodyA.node?.name == "bullets") && (contact.bodyB.node?.name == "ufopod"){
            firstbody = contact.bodyA
            secondbody = contact.bodyB
            hitufopod(bullets: firstbody.node as! SKSpriteNode, ufopod: secondbody.node as! SKSpriteNode)
        }
        else if (contact.bodyA.node?.name == "bullets") && (contact.bodyB.node?.name == "mothership"){
            shootmothership()
        }
        else if (contact.bodyA.node?.name == "bombs") && (contact.bodyB.node?.name == "mothership"){
            bombmothership()
        }
        
    }
    
    func hitufo(bullets: SKSpriteNode, ufo:  SKSpriteNode){
        self.run(SKAction.playSoundFileNamed("crash.wav", waitForCompletion: false))
        bullets.removeFromParent()
        ufo.removeFromParent()
        score = score + 100
    }
    
    func hitufopod(bullets:SKSpriteNode, ufopod: SKSpriteNode){
        self.run(SKAction.playSoundFileNamed("crash.wav", waitForCompletion: false))
        bullets.removeFromParent()
        ufopod.removeFromParent()
        score = score + 100
    }
    
    func hitbuildings(bombs:SKSpriteNode, buildings:SKSpriteNode){
        self.run(SKAction.playSoundFileNamed("crash.wav", waitForCompletion: false))
        bombs.removeFromParent()
        buildings.removeFromParent()
        score = score + 100
        
    }
    func hitmissiles(bullets: SKSpriteNode, missiles: SKSpriteNode){
        self.run(SKAction.playSoundFileNamed("crash.wav", waitForCompletion: false))
        bullets.removeFromParent()
        missiles.removeFromParent()
        score = score + 100
        
    }
    func shootmothership(){
        self.run(SKAction.playSoundFileNamed("crash.wav", waitForCompletion: false))
        bullets.removeFromParent()
        mothershiphealth = mothershiphealth - 5
        score = score + 500
        if(mothershiphealth <= 10){
            mothership.removeFromParent()
            self.winner.isHidden = false
            self.loser.isHidden = true
            self.mothershiptimer.invalidate()
        }
    }
    
    func bombmothership(){
        self.run(SKAction.playSoundFileNamed("crash.wav", waitForCompletion: false))
        bombs.removeFromParent()
        mothershiphealth = mothershiphealth - 10
        score = score + 500
        if(mothershiphealth <= 30){
            mothership.removeFromParent()
            self.winner.isHidden = false
            self.loser.isHidden = true
            self.mothershiptimer.invalidate()
        }
        
    }
    
    func Collision(){
        
        
        firecheck = 1
        self.run(SKAction.playSoundFileNamed("crash.wav", waitForCompletion: false))
        self.gametimer.invalidate()
        self.gametimer2.invalidate()
        self.gametimer3.invalidate()
        self.gametimer4.invalidate()
        self.lightningtimer.invalidate()
        player.removeFromParent()
        loser.isHidden = false
        winner.isHidden = true
        
    }
    
    func holder(){
        if firecheck == 0{
            bullets = SKSpriteNode(imageNamed:"bullets")
            bullets.name = "bullets"
            bullets.position = CGPoint(x:player.position.x + 160, y: player.position.y)
            bullets.size.width = self.size.width/10
            bullets.size.height = self.size.height/90
            bullets.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: bullets.size.width, height: bullets.size.height))
            bullets.zPosition = 3
            bullets.physicsBody?.velocity.dx = 500
            bullets.physicsBody?.categoryBitMask = playerbit
            bullets.physicsBody?.contactTestBitMask = obstaclebit
            bullets.physicsBody?.collisionBitMask = 0
            bullets.physicsBody?.usesPreciseCollisionDetection = true
            self.run(SKAction.playSoundFileNamed("gunshotnoise.wav", waitForCompletion: false))
            self.addChild(bullets)
        }
        
    }
    
    func bombsaway(){
        if firecheck == 0 {
            bombs = SKSpriteNode(imageNamed:"bombs")
            bombs.name = "bombs"
            bombs.position = CGPoint(x:player.position.x, y: player.position.y - 150)
            bombs.size.width = self.size.width/5
            bombs.size.height = self.size.height/10
            bombs.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: bombs.size.width, height: bombs.size.height))
            bombs.zPosition = 3
            bombs.physicsBody?.velocity.dy = -200
            bombs.physicsBody?.categoryBitMask = playerbit
            bombs.physicsBody?.contactTestBitMask = obstaclebit
            bombs.physicsBody?.collisionBitMask = 0
            bombs.physicsBody?.usesPreciseCollisionDetection = true
            let rotateAction = SKAction.rotate(toAngle: -.pi/2, duration:2)
            bombs.run(rotateAction)
            self.addChild(bombs)
        }
    }
  
    func control(velocity: Float){
        
        
        if velocity > 50{
          
            let rotateAction = SKAction.rotate(toAngle: .pi/10, duration:1)
            player.run(rotateAction)
        }
        if velocity > -50 && velocity < 50 {
            let rotateAction = SKAction.rotate(toAngle: 0, duration:1)
            player.run(rotateAction)
        }
        if velocity < -50 {
            let rotateAction = SKAction.rotate(toAngle: -.pi/10, duration:1)
            player.run(rotateAction)
        }
        
        vely = CGFloat(velocity)
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
    
        if player.position.y < -400 {
            player.position = CGPoint(x: -250 , y: player.size.height / 2 )
        }
        if player.position.y > 400 {
            vely = -2 * vely
        }
        
        player.physicsBody?.velocity.dy = vely
        if cloud.position.x < -300 {
            cloud.position = CGPoint(x: 400, y: 400)
        }
        if cloud2.position.x < -300 {
            cloud2.position = CGPoint(x: 400, y: 300)
            
        }
        cloud.physicsBody?.velocity.dx = -200
        cloud2.physicsBody?.velocity.dx = -250
        
         
         // Called before each frame is rendered
    }
}
