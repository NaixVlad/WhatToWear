//
//  ViewController.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 20.07.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//



import UIKit
import ForecastIO
import SceneKit
import CoreLocation
import ASHorizontalScrollView
import SceneKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var sceneView: SCNView!
    
    @IBOutlet weak var bottomContainerView: UIView!
    
    @IBOutlet weak var poweredByDarkSkyButton: UIButton!

    
    var hourlyForecastScrollView: ASHorizontalScrollView!
    var hourlyForecastData = [DataPoint]()
    var cityNameButton: UIButton!
    
    var character: Character!
    var scene = SCNScene()
    
    override func  viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCityButton()
        if character.sex != Settings.shared.characterSex {
            character.node.removeFromParentNode()
            character.changeSex()
            scene.rootNode.addChildNode(character.node)
            
            character.idle()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initViews()

        let location = LocationServices.shared.selectedLocation.location
        let latitude = location.latitude
        let longitude = location.longitude
        
        let clientServices = ClientServices.shared
        let excludeFields: [Forecast.Field] = [.minutely, .daily, .flags, .alerts]
        clientServices.getForecast(latitude: latitude, longitude: longitude, excludeFields: excludeFields) { result in
            switch result {
            case .success(let forecast, _):

                DispatchQueue.main.async {
                    self.hourlyForecastData = (forecast.hourly?.data)!
                    
                    self.writeViews()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        initCityButton()
        
        scene = SCNScene(named: "art.scnassets/Scene.scn")!
        setupEnviroment()
        
        let sex = Settings.shared.characterSex
        character = Character(sex: sex)
        scene.rootNode.addChildNode(character.node)
        character.idle()
        
    }
    
    
    func initCityButton() {
        cityNameButton = UIButton(type: .system)

        cityNameButton.frame = CGRect(x: 0, y: 0, width: 200, height: 44)
        cityNameButton.addTarget(self, action: #selector(cityNameButtonAction(_:)), for: .touchUpInside)
        self.navigationItem.titleView = cityNameButton
    }
    
    func setupCityButton() {
        
        let place = LocationServices.shared.selectedLocation
        
        if place.type == .autodetection {
            cityNameButton.setImage(#imageLiteral(resourceName: "geolocationSmall"), for: .normal)
            
            LocationServices.shared.getCurrentLocationAddress(completion: { (address, error) in
                
                if let a = address, let city = a["City"] as? String {
                    self.cityNameButton.setTitle(city, for: .normal)
                }
            })
            
        } else {
            let loc = place.location as? Location
            cityNameButton.setImage(#imageLiteral(resourceName: "Change City Button"), for: .normal)
            cityNameButton.setTitle(loc?.title, for: .normal)
        }
    }
    
    
    func initViews() {
        
        let width = bottomContainerView.frame.width
        let height = bottomContainerView.frame.height - poweredByDarkSkyButton.frame.height
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        
        hourlyForecastScrollView = ASHorizontalScrollView(frame: rect)
        self.bottomContainerView.addSubview(hourlyForecastScrollView)
        
    }
    
    func makeView(text: String, icon: UIImage, temperature: Float) -> UIView {
        
        let viewRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = UIView(frame: viewRect)
        
        let labelRect = CGRect(x: 0, y: 0, width: 100, height: 20)
        let label = UILabel(frame: labelRect)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = text
        view.addSubview(label)
        
        let iconRect = CGRect(x: 0, y: 20, width: 100, height: 60)
        let iconView = UIImageView(frame: iconRect)
        iconView.contentMode = .scaleAspectFit
        iconView.image = icon
        view.addSubview(iconView)
        
        let temperatureLabelRect = CGRect(x: 0, y: 80, width: 100, height: 20)
        let temperatureLabel = UILabel(frame: temperatureLabelRect)
        temperatureLabel.textAlignment = .center
        temperatureLabel.textColor = UIColor.white
        temperatureLabel.text = "\(Int(temperature))"
        view.addSubview(temperatureLabel)
        
        return view
        
    }
    
    func writeViews() {
        
        for i in 0..<hourlyForecastData.count {
            let data = hourlyForecastData[i]

            var hour = data.time.getHour()
            if i == 0 {
                hour = "Сейчас"
            }
            
            let icon = data.icon?.getImage()
            let temperature = data.temperature
            
            let view = makeView(text: hour!, icon: icon!, temperature: temperature!)
            self.hourlyForecastScrollView.addItem(view)
        
        }
        
        
    }
    
    //MARK: SceneKit
    
    /*func setupCamera() {
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
        
    }*/
    
    func setupEnviroment() {

        sceneView.scene = scene
        //sceneView.allowsCameraControl = true
        sceneView.showsStatistics = true
        sceneView.backgroundColor = UIColor.lightGray
        
    }
    /*
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
        
        
    }*/
    
    
    @objc func cityNameButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "showPlaces", sender: nil)
    }
    
    @IBAction func poweredByDarkSkyButtonAction(_ sender: Any) {
        
        ClientServices.shared.redirectToDarkSky()
        
    }
    
    

}

