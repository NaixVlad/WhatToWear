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
    
    init(sex: Sex, temperature: Temperature) {
        self.sex = sex
        
        let scene = chooseScene(sex: sex)
        
        self.node = scene.rootNode.childNodes[0]
        
        hair = scene.rootNode.childNode(withName: "Hair", recursively: true)
        eyes = scene.rootNode.childNode(withName: "Eyes", recursively: true)
        body = scene.rootNode.childNode(withName: "Body", recursively: true)
        tops = scene.rootNode.childNode(withName: "Tops", recursively: true)
        bottoms = scene.rootNode.childNode(withName: "Bottoms", recursively: true)
        shoes = scene.rootNode.childNode(withName: "Shoes", recursively: true)

        setupAnimations()
        
    }
    
    var sex: Sex {
        didSet {
            
            let scene = chooseScene(sex: sex)
            self.node = scene.rootNode.childNodes[0]
            
        }
    }
    
    var node = SCNNode() //main node
    
    var hair: SCNNode?
    var eyes: SCNNode?
    var body: SCNNode?
    var tops: SCNNode?
    var bottoms: SCNNode?
    var shoes: SCNNode?
    
    private var walkAnimation = CAAnimation()
    private var idleAnimation = CAAnimation()
    
    
    func setupAnimations() {
        walkAnimation = CAAnimation.animationWithSceneNamed("art.scnassets/models/walk.dae")!
        idleAnimation = CAAnimation.animationWithSceneNamed("art.scnassets/models/idle.dae")!
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
            characterScene = SCNScene(named: "art.scnassets/models/Male.scn")!
            
        case .female:
            characterScene = SCNScene(named: "art.scnassets/models/girl.scn")!
        }
        
        return characterScene
        
    }
    
}
