//
//  ViewController.swift
//  iRuler
//
//  Created by Sojourner Chua on 15/08/2020.
//  Copyright © 2020 Sojourner Chua. All rights reserved.
//
import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    //sets up an IBOutlet for sceneView
    @IBOutlet var sceneView: ARSCNView!
    //sets up an IBOutlet for select button
    @IBOutlet var selectButton: UIButton!
    //sets up an IBOutlet for the multipurpose label
    @IBOutlet var distanceLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
       // sceneView.showsStatistics = true
        
        
        self.setupScene()
        
        //changes the corner radius of label
        self.distanceLabel.layer.cornerRadius = 20
        //changes the corner radius of select button
        self.selectButton.layer.cornerRadius = 20
    }
    
    func setupScene()  {
          let scene = SCNScene()

          self.sceneView.delegate = self
       //   self.sceneView.showsStatistics = true
          self.sceneView.automaticallyUpdatesLighting = true
        // self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
          self.sceneView.scene = scene
          
      }
    
       override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneView.frame = view.bounds
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         
        // Create an AR session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func setupARSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        // prints the camera tracking quality
        print("State of camera: \(camera.trackingState)")
        
    }
    
    //clears the nodes
    func clearNodes(){
        if nodes.count > 0 {
            for node in nodes {
                node.removeFromParentNode()
            }
            nodes = []
        }
    }
    
    //
    
    var nodes: [SCNNode] = []
    static let shared = ViewController()
    var distance = 0.0
    var distanceInches = 0.0
    
    @IBAction func selectButton(_ sender: Any) {
            
            let tapLocation = self.sceneView.center// Get the center point, of the SceneView.
            let hitTestResults = sceneView.hitTest(tapLocation, types:.featurePoint) //handles hitTest
            let tapHaptic = UIImpactFeedbackGenerator() //handles the haptic feedback
        
        
            if let result = hitTestResults.first {
                //cleares nodes rendered when more than two nodes are rendered
                if nodes.count == 2{
                    clearNodes()
                }
                
                
                let position = SCNVector3.positionFrom(matrix: result.worldTransform)
                //
                let sphere = SphereNode(position:position)
               
                
                //code partially referenced from https://gorillalogic.com/blog/arkit-developer-tutorial-how-to-build-a-shoe-measuring-app/
                //adds a sphere node to the sceneView,
                sceneView.scene.rootNode.addChildNode(sphere)
                 let lastNode = nodes.last
                
                //adds sphere to the end of nodes[]
                nodes.append(sphere)
                //executes haptic feedback
               tapHaptic.impactOccurred()
                
               
        
                if lastNode != nil {
                    
                    //getting distance in cm
                   
                     distance = Double((lastNode!.position.distance(to: sphere.position)) * 100)
                    unitSelect(distance)
                   
                    //getting distance in inches
               
                     distanceInches = Double((lastNode!.position.distance(to: sphere.position)) * 39.37)
                    unitSelect(distanceInches)
                    }
                    
                    
                }
            }
    
    @IBOutlet weak var unitSelect: UISegmentedControl!
    @IBAction func unitSelect(_ sender: Any) {
        //if selectedsegment = cm
        if unitSelect.selectedSegmentIndex == 0{
            //print distance in cm
            distanceLabel.text = String(format: "Distance: %.2f cm", distance)
        }
        else if
            //if selectedsegment = inches
            unitSelect.selectedSegmentIndex == 1{
            //print distance in inches
            distanceLabel.text = String(format: "Distance: %.2f inches", distanceInches)
        }
    }
}
 
    
    
    

//code referenced from https://code.tutsplus.com/tutorials/code-a-measuring-app-with-arkit-placing-objects-in-the-scene--cms-30448
extension SCNVector3 {
    func distance(to destination: SCNVector3) -> CGFloat {
        let dx = destination.x - x
        let dy = destination.y - y
        let dz = destination.z - z
        //calculates distance between two 3d points
        return CGFloat(sqrt(dx*dx + dy*dy + dz*dz))
    }
    
    static func positionFrom(matrix: matrix_float4x4) -> SCNVector3 {
        let column = matrix.columns.3
        return SCNVector3(column.x, column.y, column.z)
    }
}
