--
-- Created by IntelliJ IDEA.
-- User: ouyanyu
-- Date: 2016-04-14
-- Time: 17:39
-- To change this template use File | Settings | File Templates.
--
local DB = require("app.libs.db")
local db = DB:new()

local dict_model = {}


-- return dict, err
function dict_model:query_dict(parent_value,value)
    local res, err =  db:query("select * from dict where parent_value=? and value=? limit 1", {parent_value,value})
    if not res or err or type(res) ~= "table" or #res ~=1 then
        return nil, err or "error"
    end

    return res[1], err
end



-- return sort, err
function dict_model:query_max_sort(parent_value)
    local res, err =  db:query("select max(sort) sort from dict where parent_value=?", {parent_value})
    if not res or err then
        return nil, err or "error"
    end

    return res[1], err
end


-- create dict
function dict_model:create(name, value, parent_value, sort)
    return db:query("insert into dict(name, value, parent_value, sort) values(?,?,?,?)",
        {name, value, parent_value, sort})
end

-- 创建父类
function dict_model:new_parent(name, value, sort)
    return db:query("insert into dict(name, value, sort) values(?,?,?)",
        {name, value, sort})
end

function dict_model:new(name, value, parent_value, sort)
    return db:query("insert into dict(name, value, parent_value, sort) values(?,?,?,?)",
        {name, value, parent_value, sort})
end
return dict_model

