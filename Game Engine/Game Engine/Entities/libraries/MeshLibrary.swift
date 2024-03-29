import MetalKit

enum MeshTypes {
    case Triangle_Custom
    case Quad_Custom
    case Cube_Custom
    
    case Cruiser
}

class MeshLibrary: Library<MeshTypes, Mesh> {
    
    private var _library: [MeshTypes:Mesh] = [:]
    
    override func fillLibrary() {
        _library.updateValue(Triangle_CustomMesh(), forKey: .Triangle_Custom)
        _library.updateValue(Quad_CustomMesh(), forKey: .Quad_Custom)
        _library.updateValue(Cube_CustomMesh(), forKey: .Cube_Custom)
        
        _library.updateValue(ModelMesh(modelName: "cruiser"), forKey: .Cruiser)
    }
    
    override subscript(_ type: MeshTypes)->Mesh {
        return _library[type]!
    }
    
}

protocol Mesh {
//    var vertexCount: Int! { get }
    func setInstanceCount(_ count: Int)
    func drawPrimitives(_ renderCommandEncoder: MTLRenderCommandEncoder)
}

class ModelMesh: Mesh {
    private var _meshes: [Any]!
    private var _instanceCount: Int = 1
    
    init(modelName: String) {
        loadModel(modelName: modelName)
    }
    
    func loadModel(modelName: String) {
        guard let assetURL = Bundle.main.url(forResource: modelName, withExtension: "obj") else {
            fatalError("Asset \(modelName) does not exist.")
        }
        
        let descriptor = MTKModelIOVertexDescriptorFromMetal(Graphics.VertexDescriptors[.Basic])
        (descriptor.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition
        (descriptor.attributes[1] as! MDLVertexAttribute).name = MDLVertexAttributeColor
        (descriptor.attributes[2] as! MDLVertexAttribute).name = MDLVertexAttributeTextureCoordinate

        let bufferAllocator = MTKMeshBufferAllocator(device: Engine.Device)
        let asset: MDLAsset = MDLAsset(url: assetURL,
                                       vertexDescriptor: descriptor,
                                       bufferAllocator: bufferAllocator)
        do{
            self._meshes = try MTKMesh.newMeshes(asset: asset,
                                                 device: Engine.Device).metalKitMeshes
        } catch {
            print("ERROR::LOADING_MESH::__\(modelName)__::\(error)")
        }
    }
    
    func setInstanceCount(_ count: Int) {
        self._instanceCount = count
    }
    
    func drawPrimitives(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        guard let meshes = self._meshes as? [MTKMesh] else { return }
        for mesh in meshes {
            for vertexBuffer in mesh.vertexBuffers {
                renderCommandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 0)
                for submesh in mesh.submeshes {
                    renderCommandEncoder.drawIndexedPrimitives(type: submesh.primitiveType,
                                                               indexCount: submesh.indexCount,
                                                               indexType: submesh.indexType,
                                                               indexBuffer: submesh.indexBuffer.buffer,
                                                               indexBufferOffset: submesh.indexBuffer.offset,
                                                               instanceCount: self._instanceCount)
                }
            }
        }
    }
}

class CustomMesh: Mesh {
    private var _vertices: [Vertex] = []
    private var _vertexBuffer: MTLBuffer!
    private var _instanceCount: Int = 1
    var vertexCount: Int! {
        return _vertices.count
    }
    
    init() {
        createVertices()
        createBuffers()
    }
    
    func createVertices(){ }
    
    func createBuffers(){
        _vertexBuffer = Engine.Device.makeBuffer(bytes: _vertices,
                                                length: Vertex.stride(vertexCount),
                                                options: [])
    }
    
    func addVertex(position:  SIMD3<Float>,
                   color:  SIMD4<Float> =  SIMD4<Float>(1,0,1,1),
                   textureCoordinate: SIMD2<Float> = SIMD2<Float>(0,0)) {
        _vertices.append(Vertex(position: position, color: color,textureCoordinate: textureCoordinate))
    }
    
    func setInstanceCount(_ count: Int) {
        self._instanceCount = count
    }
    
    func drawPrimitives(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setVertexBuffer(_vertexBuffer, offset: 0,
                                             index: 0)
        
        renderCommandEncoder.drawPrimitives(type: .triangle,
                                            vertexStart: 0,
                                            vertexCount: vertexCount,
                                            instanceCount: _instanceCount)
    }
}

class Triangle_CustomMesh: CustomMesh {
    override func createVertices() {
        addVertex(position:  SIMD3<Float>( 0, 1,0), color:  SIMD4<Float>(1,0,0,1))
        addVertex(position:  SIMD3<Float>(-1,-1,0), color:  SIMD4<Float>(0,1,0,1))
        addVertex(position:  SIMD3<Float>( 1,-1,0), color:  SIMD4<Float>(0,0,1,1))
    }
}

class Quad_CustomMesh: CustomMesh {
    override func createVertices() {
        addVertex(position:  SIMD3<Float>( 1, 1,0), color:  SIMD4<Float>(1,0,0,1), textureCoordinate: SIMD2<Float>(1,0)) //Top Right
        addVertex(position:  SIMD3<Float>(-1, 1,0), color:  SIMD4<Float>(0,1,0,1), textureCoordinate: SIMD2<Float>(0,0)) //Top Left
        addVertex(position:  SIMD3<Float>(-1,-1,0), color:  SIMD4<Float>(0,0,1,1), textureCoordinate: SIMD2<Float>(0,1)) //Bottom Left

        addVertex(position:  SIMD3<Float>( 1, 1,0), color:  SIMD4<Float>(1,0,0,1), textureCoordinate: SIMD2<Float>(1,0)) //Top Right
        addVertex(position:  SIMD3<Float>(-1,-1,0), color:  SIMD4<Float>(0,0,1,1), textureCoordinate: SIMD2<Float>(0,1)) //Bottom Left
        addVertex(position:  SIMD3<Float>( 1,-1,0), color:  SIMD4<Float>(1,0,1,1), textureCoordinate: SIMD2<Float>(1,1)) //Bottom Right
    }
}

class Cube_CustomMesh: CustomMesh {
    override func createVertices() {
        //Left
        addVertex(position:  SIMD3<Float>(-1.0,-1.0,-1.0), color:  SIMD4<Float>(1.0, 0.5, 0.0, 1.0))
        addVertex(position:  SIMD3<Float>(-1.0,-1.0, 1.0), color:  SIMD4<Float>(0.0, 1.0, 0.5, 1.0))
        addVertex(position:  SIMD3<Float>(-1.0, 1.0, 1.0), color:  SIMD4<Float>(0.0, 0.5, 1.0, 1.0))
        addVertex(position:  SIMD3<Float>(-1.0,-1.0,-1.0), color:  SIMD4<Float>(1.0, 1.0, 0.0, 1.0))
        addVertex(position:  SIMD3<Float>(-1.0, 1.0, 1.0), color:  SIMD4<Float>(0.0, 1.0, 1.0, 1.0))
        addVertex(position:  SIMD3<Float>(-1.0, 1.0,-1.0), color:  SIMD4<Float>(1.0, 0.0, 1.0, 1.0))
        
        //RIGHT
        addVertex(position:  SIMD3<Float>( 1.0, 1.0, 1.0), color:  SIMD4<Float>(1.0, 0.0, 0.5, 1.0))
        addVertex(position:  SIMD3<Float>( 1.0,-1.0,-1.0), color:  SIMD4<Float>(0.0, 1.0, 0.0, 1.0))
        addVertex(position:  SIMD3<Float>( 1.0, 1.0,-1.0), color:  SIMD4<Float>(0.0, 0.5, 1.0, 1.0))
        addVertex(position:  SIMD3<Float>( 1.0,-1.0,-1.0), color:  SIMD4<Float>(1.0, 1.0, 0.0, 1.0))
        addVertex(position:  SIMD3<Float>( 1.0, 1.0, 1.0), color:  SIMD4<Float>(0.0, 1.0, 1.0, 1.0))
        addVertex(position:  SIMD3<Float>( 1.0,-1.0, 1.0), color:  SIMD4<Float>(1.0, 0.5, 1.0, 1.0))
        
        //TOP
        addVertex(position:  SIMD3<Float>( 1.0, 1.0, 1.0), color:  SIMD4<Float>(1.0, 0.0, 0.0, 1.0))
        addVertex(position:  SIMD3<Float>( 1.0, 1.0,-1.0), color:  SIMD4<Float>(0.0, 1.0, 0.0, 1.0))
        addVertex(position:  SIMD3<Float>(-1.0, 1.0,-1.0), color:  SIMD4<Float>(0.0, 0.0, 1.0, 1.0))
        addVertex(position:  SIMD3<Float>( 1.0, 1.0, 1.0), color:  SIMD4<Float>(1.0, 1.0, 0.0, 1.0))
        addVertex(position:  SIMD3<Float>(-1.0, 1.0,-1.0), color:  SIMD4<Float>(0.5, 1.0, 1.0, 1.0))
        addVertex(position:  SIMD3<Float>(-1.0, 1.0, 1.0), color:  SIMD4<Float>(1.0, 0.0, 1.0, 1.0))
        
        //BOTTOM
        addVertex(position:  SIMD3<Float>( 1.0,-1.0, 1.0), color:  SIMD4<Float>(1.0, 0.5, 0.0, 1.0))
        addVertex(position:  SIMD3<Float>(-1.0,-1.0,-1.0), color:  SIMD4<Float>(0.5, 1.0, 0.0, 1.0))
        addVertex(position:  SIMD3<Float>( 1.0,-1.0,-1.0), color:  SIMD4<Float>(0.0, 0.0, 1.0, 1.0))
        addVertex(position:  SIMD3<Float>( 1.0,-1.0, 1.0), color:  SIMD4<Float>(1.0, 1.0, 0.5, 1.0))
        addVertex(position:  SIMD3<Float>(-1.0,-1.0, 1.0), color:  SIMD4<Float>(0.0, 1.0, 1.0, 1.0))
        addVertex(position:  SIMD3<Float>(-1.0,-1.0,-1.0), color:  SIMD4<Float>(1.0, 0.5, 1.0, 1.0))
        
        //BACK
        addVertex(position:  SIMD3<Float>( 1.0, 1.0,-1.0), color:  SIMD4<Float>(1.0, 0.5, 0.0, 1.0))
        addVertex(position:  SIMD3<Float>(-1.0,-1.0,-1.0), color:  SIMD4<Float>(0.5, 1.0, 0.0, 1.0))
        addVertex(position:  SIMD3<Float>(-1.0, 1.0,-1.0), color:  SIMD4<Float>(0.0, 0.0, 1.0, 1.0))
        addVertex(position:  SIMD3<Float>( 1.0, 1.0,-1.0), color:  SIMD4<Float>(1.0, 1.0, 0.0, 1.0))
        addVertex(position:  SIMD3<Float>( 1.0,-1.0,-1.0), color:  SIMD4<Float>(0.0, 1.0, 1.0, 1.0))
        addVertex(position:  SIMD3<Float>(-1.0,-1.0,-1.0), color:  SIMD4<Float>(1.0, 0.5, 1.0, 1.0))
        
        //FRONT
        addVertex(position:  SIMD3<Float>(-1.0, 1.0, 1.0), color:  SIMD4<Float>(1.0, 0.5, 0.0, 1.0))
        addVertex(position:  SIMD3<Float>(-1.0,-1.0, 1.0), color:  SIMD4<Float>(0.0, 1.0, 0.0, 1.0))
        addVertex(position:  SIMD3<Float>( 1.0,-1.0, 1.0), color:  SIMD4<Float>(0.5, 0.0, 1.0, 1.0))
        addVertex(position:  SIMD3<Float>( 1.0, 1.0, 1.0), color:  SIMD4<Float>(1.0, 1.0, 0.5, 1.0))
        addVertex(position:  SIMD3<Float>(-1.0, 1.0, 1.0), color:  SIMD4<Float>(0.0, 1.0, 1.0, 1.0))
        addVertex(position:  SIMD3<Float>( 1.0,-1.0, 1.0), color:  SIMD4<Float>(1.0, 0.0, 1.0, 1.0))
    }

}
