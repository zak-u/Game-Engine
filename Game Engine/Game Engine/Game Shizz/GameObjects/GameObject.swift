import MetalKit

class GameObject: Node {

    var modelConstants = ModelConstants()
    private var material = Material()
    
    var mesh: Mesh!
    
    init(meshType: MeshTypes) {
           mesh = MeshLibrary.Mesh(meshType)
       }
    
//    var time : Float = 0
    override func update(deltaTime: Float)  {
//        time += deltaTime
//        
//        
////        self.position.x = sin(time)
////        self.position.y = sin(time)
//        self.scale = SIMD3<Float>( repeating: cos(time))
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
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Less))
        
        //Vertex Shader
        renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.setVertexBytes(&modelConstants, length: ModelConstants.stride, index: 2)
    
        //Fragment Shader
        renderCommandEncoder.setFragmentBytes(&material, length: Material.stride, index: 1)
        
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: mesh.vertexCount)
    }
}

//Material Properties
extension GameObject {
    public func setColor(_ color: SIMD4<Float>){
        self.material.color = color
        self.material.useMaterialColor = true
    }
}
