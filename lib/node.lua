local Class = require "lib.hump.class"

local Node = Class {
	init = function(self, name, parent)
		self.name = name
		self.parent = parent
	end,

	getParent = function(self)
		assert(self.parent, "This node is orphan")
		return self.parent
	end
}

return Node
