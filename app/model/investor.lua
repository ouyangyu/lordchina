--
-- Created by IntelliJ IDEA.
-- User: ouyanyu
-- Date: 2016-04-15
-- Time: 16:13
-- To change this template use File | Settings | File Templates.
--
local DB = require("app.libs.db")
local db = DB:new()

local investor_model = {}

-- 新建投资人
function investor_model:new(investor)
    return db:query("insert into investor() values(?,?,?,?,?,?,?)",
            {})
end

return investor_model