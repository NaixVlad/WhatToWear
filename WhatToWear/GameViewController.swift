//
//  GameViewController.swift
//  Test
//
//  Created by Vladislav Andreev on 07.07.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import CoreLocation

class GameViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var sceneView: SCNView!
    
    @IBOutlet weak var viewBottom: UIView!
    
    @IBOutlet weak var sexSwitch: UISegmentedControl!
    var scene = SCNScene()

    
    var character = Character(sex: .female)
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //locationManager.delegate = self
        // Ask for Authorisation from the User.
        //self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        //self.locationManager.requestWhenInUseAuthorization()
        
        /*if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            //locationManager.startUpdatingLocation()
        } else {
            print("location manager not allowed")
        }*/
        
        //print(self.locationManager.location ?? "location empty")
        // create a new scene
        scene = SCNScene(named: "art.scnassets/Scene.scn")!
        //let scene = SCNScene(named: "art.scnassets/girl.dae")!
        
        //setupCamera()
        //setupLight()
        //setupFloor()
        setupEnviroment()
        //character = character(sex: .male)
        scene.rootNode.addChildNode(character.node)
        // retrieve the ship node
        //let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!

       

        
        
    }
    
    func setupCamera() {
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        //cameraNode.camera?.usesOrthographicProjection = true
        //cameraNode.camera?.orthographicScale = 1
        
        // place the camera
        cameraNode.position = SCNVector3(x: 40, y: 40, z: 140)
    }
    
    func setupLight() {
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 20, z: 20)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
    }
    
    func setupFloor() {
        // set up the floor physics body
        let floorGeo = SCNFloor()
        let floorMaterial = SCNMaterial()
        floorMaterial.diffuse.contents = UIColor.green
        floorMaterial.specular.contents = UIColor.black
        floorGeo.firstMaterial = floorMaterial
        let floorNode = SCNNode(geometry: floorGeo)
        
        floorNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.static,
                                               shape: SCNPhysicsShape(geometry: floorGeo, options: nil))
        scene.rootNode.addChildNode(floorNode)
        
    }
    
    func setupEnviroment() {
        
        // set the scene to the view
        sceneView.scene = scene
        
        // allows the user to manipulate the camera
        sceneView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // configure the view
        sceneView.backgroundColor = UIColor.lightGray
        
    }
    
    @IBAction func walkAction(_ sender: UIButton) {
        
        character.walk()
        
    }
    
    @IBAction func idleAction(_ sender: UIButton) {
        
        character.idle()
        
    }
    
    
    @IBAction func happyIdleAction(_ sender: Any) {
    }
    
    @IBAction func sadIdle(_ sender: UIButton) {
    }
    
    @IBAction func sexValueChanged(_ sender: UISegmentedControl) {
        character.node.removeFromParentNode()
        character.changeSex()
        scene.rootNode.addChildNode(character.node)
        
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}


// MARK: -  extension to CAAnimation from Apple's Fox project

