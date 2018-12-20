import Vapor
// class for the ingredients
final class Ingredient : Content {
    var name: String
    var quantity: Double
    
    init(name: String, quantity: Double) {
        self.name = name
        self.quantity = quantity
    }
}

// class for JSON encoding - content provides this
final class Dish : Content {
    var uuid: String?
    var title: String
    var price: Double
    var description: String
    var course: String
    var ingredients: [Ingredient]
    
    init (title: String, price: Double, course: String, description: String, ingredients: [Ingredient] ) {
        self.uuid = UUID().uuidString

        self.title = title
        self.price = price
        self.description = description
        self.course = course
        self.ingredients = ingredients
    }
} // Dish

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    router.get("dish") { req -> [Dish] in
        var dishes: [Dish] = []
        var ingredients: [Ingredient] = []
        
        ingredients.append(Ingredient(name: "Beef", quantity: 1.0))
        ingredients.append(Ingredient(name: "Sauce", quantity: 15.0))

        dishes.append(Dish(title: "Spaghetti", price: 5.50, course: "Entree", description: "Spaghetti and meatballs", ingredients: ingredients))
        dishes.append(Dish(title: "Braised Lamb", price: 9.95, course: "Entree", description: "Braised Lamb Shanks", ingredients: ingredients))

        return dishes
    }
    
    router.post(Dish.self, at: "api/dish") {req, data -> Future<Dish> in
        
        // Returing this in future - i.e. async request
        return Future.map(on: req, { () -> Dish in
            data.uuid = UUID().uuidString
            return data
        })
    }

    // flatmap version - sends back future of future - ouch
    router.get("dishes") {req -> Future<[Dish]> in
        
        return getDishes (req: req)
    }

    func getDishes (req: Request) -> Future<[Dish]> {
        
        return Future.flatMap(on: req) { () -> EventLoopFuture<[Dish]> in
            var dishes: [Dish] = []
            var ingredients: [Ingredient] = []
            
            ingredients.append(Ingredient(name: "Beef", quantity: 1.0))
            ingredients.append(Ingredient(name: "Sauce", quantity: 15.0))
            
            dishes.append(Dish(title: "Spaghetti", price: 5.50, course: "Entree", description: "Spaghetti and meatballs", ingredients: ingredients))
            dishes.append(Dish(title: "Braised Lamb", price: 9.95, course: "Entree", description: "Braised Lamb Shanks", ingredients: ingredients))
            
            return Future.map(on: req, { () -> [Dish] in
                return dishes
            })
        }
    }

} // routes
