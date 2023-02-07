
import Foundation

struct SubCategoryModel: Codable {

    var id          : Int?
    var name        : String?
    var description : String?
    var slug        : String?
    var parent      : Int?
    var list        : Bool?
    var type        : String?
    var value       : String?
    var otherValue  : String?
    var options     : [OptionsModel]?
    var childParent : Int?

    var idValue: Int {
        guard let idValue = id else {
            return 0
        }
        return idValue
    }
    
    var nameStr: String {
        guard let name = name else {
            return ""
        }
        return name
    }
    
    var valueStr: String {
        guard let valueStr = value else {
            return ""
        }
        return valueStr
    }
    
    var otherValueStr: String {
        guard let valueStr = otherValue else {
            return ""
        }
        return valueStr
    }
    
    var typeStr: String {
        guard let typeStr = type else {
            return ""
        }
        return typeStr
    }
    
    var isDropDown: Bool {
        return (options?.count ?? 0) > 0
    }
    
    var parentId: Int {
        guard let parentId = parent else {
            return 0
        }
        return parentId
    }
    
    var childParentId: Int {
        guard let childParentId = childParent else {
            return 0
        }
        return childParentId
    }
    
    init(id: Int, name: String, option: [OptionsModel]) {
        self.id = id
        self.name = name
        self.options = option
    }
}
