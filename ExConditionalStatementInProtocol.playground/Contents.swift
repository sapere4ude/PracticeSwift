import Foundation

protocol Drivable {
    func drive()
}

class Car: Drivable {
    func drive() {
        print("차를 운전합니다.")
    }
}

class Bicycle: Drivable {
    func drive() {
        print("자전거를 탑니다.")
    }
}

func activateVehicle(_ vehicle: Any) {
    if let drivableVehicle = vehicle as? Drivable {
        drivableVehicle.drive()
    }
}

let car = Car()
let bicycle = Bicycle()

activateVehicle(car)
activateVehicle(bicycle)


