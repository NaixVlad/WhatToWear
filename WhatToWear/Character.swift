//
//  Character.swift
//  WhatsToWear
//
//  Created by Vladislav Andreev on 17.07.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import Foundation
import SceneKit

class Character {
    
    var sex: Sex {
        didSet {
            
            let scene = chooseScene(sex: sex)
            self.node = scene.rootNode.childNodes[0]
            
        }
    }
    
    var node = SCNNode() //main node
    
    var hair = SCNNode()
    var eyes = SCNNode()
    var tops = SCNNode()
    var body = SCNNode()
    var bottoms = SCNNode()
    var shoes = SCNNode()
    
    private var walkAnimation = CAAnimation()
    private var idleAnimation = CAAnimation()
    
    init(sex: Sex) {
        self.sex = sex
        let scene = chooseScene(sex: sex)
        self.node = scene.rootNode.childNodes[0]
        setupAnimations()
        
    }
    
    
    
    func setupAnimations() {
        walkAnimation = CAAnimation.animationWithSceneNamed("art.scnassets/walk.dae")!
        idleAnimation = CAAnimation.animationWithSceneNamed("art.scnassets/idle.dae")!
    }
    
    func walk() {
        node.addAnimation(walkAnimation, forKey: "walk")
    }
    
    func idle() {
        node.addAnimation(idleAnimation, forKey: "idle")
    }
    
    func changeSex() {
        switch self.sex {
        case .male:
            self.sex = .female
        case .female:
            self.sex = .male
        }
    }
    
    private func chooseScene(sex: Sex) -> SCNScene {
        let characterScene: SCNScene
        switch sex {
        case .male:
            characterScene = SCNScene(named: "art.scnassets/Male.scn")!
            
        case .female:
            characterScene = SCNScene(named: "art.scnassets/girl.scn")!
        }
        
        return characterScene
        
    }
    
}
