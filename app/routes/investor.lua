--
-- Created by IntelliJ IDEA.
-- User: ouyanyu
-- Date: 2016-04-15
-- Time: 15:59
-- To change this template use File | Settings | File Templates.
--
local lor = require("lor.index")
local investor_model = require("app.model.investor")
local investor_router = lor:Router()

investor_router:get("/new", function(req, res, next)
    res:render("investor/new")
end)

return investor_router
