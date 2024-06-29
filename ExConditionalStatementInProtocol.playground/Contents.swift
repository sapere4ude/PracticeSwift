import Foundation

protocol Dirvable {
    func drive()
}

class Car {
    func drive() {
        print("차를 운전합니다.")
    }
}

class Bicycle {
    func drive() {
        print("자전거를 탑니다.")
    }
}

func activateVehicle(_ vehicle: Any) {
    if vehicle is Car {
        (vehicle as! Car).drive()
    } else if vehicle is Bicycle {
        (vehicle as! Bicycle).drive()
    }
}

let car = Car()
let bicycle = Bicycle()

activateVehicle(car)
activateVehicle(bicycle)


