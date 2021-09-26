import MetalKit

class GameObject: Node {

    var modelConstants = ModelConstants()
    
    var mesh: Mesh!
    
    init(meshType: MeshTypes) {
           mesh = MeshLibrary.Mesh(meshType)
       }
    
    var time : Float = 0
    func update(deltaTime: Float)  {
        time += deltaTime
        
        
//        self.position.x = sin(time)
//        self.position.y = sin(time)
        self.scale = SIMD3<Float>( repeating: cos(time))
//        self.rotation.z = cos(time)
        
        updateModelConstants()
    }
    
    private func updateModelConstants(){
            modelConstants.modelMatrix = self.modelMatrix
        }
}

extension GameObject: Renderable{
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        //        renderCommandEncoder.setTriangleFillMode(.lines)
        renderCommandEncoder.setVertexBytes(&modelConstants, length: ModelConstants.stride, index: 1)
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
        renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: mesh.vertexCount)
    }
}
