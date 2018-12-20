import Vapor

// class for JSON encoding - content provides this
final class Dish : Content {
    var title: String
    var price: Double
    var description: String
    var course: String
    
    init (title: String, price: Double, course: String, description: String ) {
        self.title = title
        self.price = price
        self.description = description
        self.course = course
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
        
        dishes.append(Dish(title: "Spaghetti", price: 5.50, course: "Entree", description: "Spaghetti and meatballs"))
        dishes.append(Dish(title: "Braised Lamb", price: 9.95, course: "Entree", description: "Braised Lamb Shanks"))

        return dishes
    }
    
    router.post(Dish.self, at: "api/dish") {req, data -> String in
        
        return "Put in a dish"
    }
 }
