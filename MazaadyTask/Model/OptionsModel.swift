
import Foundation

struct OptionsModel: Codable {

    var id     : Int?
    var name   : String?
    var slug   : String?
    var parent : Int?
    var child  : Bool?
    var IsSelected : Bool? = false
    
    var optionId: Int {
        guard let optionId = id else {
            return 0
        }
        return optionId
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
    
    var isHaveChild: Bool {
        guard let isHaveChild = child else {
            return false
        }
        return isHaveChild
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
        self.slug = name
        self.child = false
        self.IsSelected = false
    }

}
