//
//  SphereNode.swift
//  iRuler
//
//  Created by Sojourner Chua on 17/08/2020.
//  Copyright © 2020 Sojourner Chua. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class SphereNode: SCNNode {
    
    //initialising properties of sphere
    init(position: SCNVector3) {
           super.init()
           
           let material = SCNMaterial()
           let sphereGeometry = SCNSphere(radius: 0.003)
           material.diffuse.contents = UIColor.yellow
           material.lightingModel = .physicallyBased
           sphereGeometry.materials = [material]
           self.geometry = sphereGeometry
           self.position = position
       }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) not implemented")
       }
}
