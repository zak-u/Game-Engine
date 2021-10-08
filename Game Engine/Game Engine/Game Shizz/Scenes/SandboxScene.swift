import MetalKit

class SandboxScene: Scene{
    
    var debugCamera = DebugCamera()
    
   
    override func buildScene() {
        addCamera(debugCamera)
        debugCamera.position.z = 13
         
        addCubes()
           
    }
 
    func addCubes(){
            for y in -5..<5 {
                let posY = Float(y) + 0.5
                for x in -8..<8 {
                    let posX = Float(x) + 0.5
                    let cube = Cube()
                    cube.position.y = posY
                    cube.position.x = posX
                    cube.scale = SIMD3<Float>(0.3, 0.3, 0.3)
                    cube.setColor(ColorUtil.randomColor)
                    addChild(cube)
                }
            }
        }
//import MetalKit
//
//class SandboxScene: Scene{
//
//    var debugCamera = DebugCamera()
//
//    var cube = Cube()
//    override func buildScene() {
//        addCamera(debugCamera)
//        debugCamera.position.z = 5
//
//        cube.setColor(SIMD4<Float>(0.7,0.1,0.3,1))
//
//        addChild(cube)
//
//    }
//
//    override func update(deltaTime: Float) {
//            cube.rotation.x += deltaTime
//            cube.rotation.y += deltaTime
//            super.update(deltaTime: deltaTime)
//        }
//    override func update(deltaTime: Float) {
//// все ворочаются
////            for child in children{
////                child.rotation.z += 0.02
////            }
//        
//// передвигание первого прямоугольника влево и право c помощью стрелок
////        let child = children[0]
////        if(Keyboard.IsKeyPressed(.rightArrow)){
////            child.position.x += deltaTime
////        }
////
////        if(Keyboard.IsKeyPressed(.leftArrow)){
////            child.position.x -= deltaTime
////        }
//// передвигание первого прямоугольника влево  c помощью левой кнопки мыши
////        if (Mouse.IsMouseButtonPressed(button: .LEFT)){
////            children[0].position.x -= deltaTime
////        }
////координаты поцентру 0,0
////        print(Mouse.GetMouseViewportPosition())
//// координаты слева вверху 0,0
////        print(Mouse.GetMouseWindowPosition())
//        super.update(deltaTime: deltaTime)
//    }
}
