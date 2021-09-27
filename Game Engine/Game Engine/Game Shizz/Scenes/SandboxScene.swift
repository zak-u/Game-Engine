import MetalKit

class SandboxScene: Scene{
  
    override func buildScene() {
            let count: Int = 5
            for y in -count..<count{
                for x in -count..<count{
                    let player = Player()
                    player.position.y = Float(Float(y) + 0.5) / Float(count)
                    player.position.x = Float(Float(x) + 0.5) / Float(count)
                    player.scale = SIMD3<Float>(0.1, 0.1, 0.1)
                    addChild(player)
                }
            }
    }
    
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
