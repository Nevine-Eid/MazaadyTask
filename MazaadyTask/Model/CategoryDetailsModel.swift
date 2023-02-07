
import Foundation

struct CategoryDetailsModel: Codable {

    var id              : Int?
    var name            : String?
    var description     : String?
    var image           : String?
    var slug            : String?
    var children        : [CategoryDetailsModel]?
    var circleIcon      : String?
    var disableShipping : Int?
    var IsSelected      : Bool? = false

    var catId: Int {
        guard let id = id else {
            return 0
        }
        return id
    }
    
    var nameStr: String {
        guard let name = name else {
            return ""
        }
        return name
    }
    
    var isSelected: Bool {
        guard let isSelected = IsSelected else {
            return false
        }
        return isSelected
    }
    
    init(id: Int, name: String, children: [CategoryDetailsModel]) {
        self.id = id
        self.name = name
        self.children = children
    }
}
