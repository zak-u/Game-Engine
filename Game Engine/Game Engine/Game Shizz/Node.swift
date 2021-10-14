import MetalKit

class Node {
    var name:String = "Node"
    
    var position : SIMD3<Float> = SIMD3<Float>(0,0,0)
    var scale:  SIMD3<Float> =  SIMD3<Float>(1,1,1)
    var rotation:  SIMD3<Float> =  SIMD3<Float>(0,0,0)
    
    var modelMatrix : matrix_float4x4{
        var modelMatrix = matrix_identity_float4x4
        modelMatrix.translate(direction : position)
        modelMatrix.rotate(angle: rotation.x, axis: X_AXIS)
        modelMatrix.rotate(angle: rotation.y, axis: Y_AXIS)
        modelMatrix.rotate(angle: rotation.z, axis: Z_AXIS)
        modelMatrix.scale(axis: scale)
        
     
        return modelMatrix
    }
    
    var children : [Node] = []
    
    init(name:String = "Node"){
        self.name = name
        
    }
    
    func addChild(_ chaild: Node){
        children.append(chaild)
    }
    
    func update(deltaTime: Float){
            for child in children{
                child.update(deltaTime: deltaTime)
            }
        
        }
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder){
        renderCommandEncoder.pushDebugGroup("Rendering \(name)")
        for child in children {
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
        
        if let renderable = self as? Renderable {
            renderable.doRender(renderCommandEncoder)
        }
        renderCommandEncoder.popDebugGroup()
    }
    
}
