--
-- Created by IntelliJ IDEA.
-- User: ouyanyu
-- Date: 2016-04-14
-- Time: 17:58
-- To change this template use File | Settings | File Templates.
--
local lor = require("lor.index")
local dict_model = require("app.model.dict")
local dict_router = lor:Router()


local function save_new(arr,parent_value)
    local return_arr = {}
    for di,dv in pairs(arr) do
        local result, err = dict_model:new(dv.name,dv.value,parent_value,di)
        if not result or err then
            table.insert(return_arr,{msg=dv.name,success=dv.value,i=di,p=parent_value})
        end
    end
    return return_arr
end


-- 创建一条词典，创建最高层级的，parent_value可不传，name 和 value必须填写
dict_router:post("/create",function(req, res, next)
    local sort = req.body.sort
    local name = req.body.name
    local value = req.body.value
    local parent_value = req.body.parent_value
    -- 参数不能为空，sort可以
    if not value or not name or name == "" then
        return res:json({
            success = false,
            msg = "参数不得为空."
        })
    end

    if not parent_value then
        parent_value = ""
    end

    -- 当sort为空，获取最大的
    if not sort then
        local result, err = dict_model:query_max_sort(parent_value)
        if not result or err then
            sort = 1
        else
            sort = result["sort"]+1
        end
    end
    -- 查看是否存在，value不能重复
    local result, err = dict_model:query_dict(parent_value,value)
    local isExist = false
    if result and not err then
        isExist = true
    end
    if isExist == true then
        return res:json({
            success = false,
            msg = "值已经被占用，请选用其他."
        })
    else
        local result, err = dict_model:create(name, value, parent_value, sort)
        if result and not err then
            return res:json({
                success = true,
                msg = "添加成功."
            })
        else
            return res:json({
                success = false,
                msg = "添加失败."
            })
        end
    end
end)

-- new parent dict
dict_router:get("/newParent", function(req, res, next)
    dict_array = {
        {name='行业',value=10000},
        {name='投资阶段',value=20000},
        {name='投资领域',value=30000},
    }
    return_arr = {}
    for di,dv in pairs(dict_array) do
        local result, err = dict_model:new_parent(dv.name,dv.value,di)
        if not result or err then
            table.insert(return_arr,{msg=dv.name,success=dv.value})
        end

    end
    return res:json(return_arr)

end)

-- new dict
dict_router:get("/:parant_value/new", function(req, res, next)
    local parant_value = req.params.parant_value
    local invest_arr = {{name='行业',value=10001},{name='投资',value=10002},{name='中介',value=10003},{name='金融',value=10004},{name='创业',value=10005},{name='实创',value=10006},{name='产业投资',value=10007},{name='媒体',value=10008},{name='其他',value=10009} }
    local invest_stag_arr = {
        {name='种子轮',value=20001},
        {name='天使轮',value=20002},
        {name='A轮',value=20003},
        {name='B轮',value=20004},
        {name='C轮',value=20005},
        {name='D轮',value=20006},
        {name='E轮',value=20007},
        {name='F轮及以后',value=20008},
        {name='并购',value=20009 },
        {name='新三板挂牌',value=20010}
    }
    local invest_filed_arr = {
        {name='电子商务',value=30001},
        {name='O2O',value=30002},
        {name='游戏',value=30003},
        {name='旅游',value=30004},
        {name='在线教育',value=30005},
        {name='互联网金融',value=30006},
        {name='互联网保险',value=30007},
        {name='社交',value=30008},
        {name='娱乐',value=30009 },
        {name='医疗健康',value=30010},
        {name='餐饮',value=30011},
        {name='汽车交通',value=30012},
        {name='企业服务',value=30013},
        {name='B2B',value=30014},
        {name='智能硬件',value=30015},
        {name='通信及IT',value=30016},
        {name='房产',value=30017},
        {name='文化艺术',value=30018},
    }
    local return_arr = {}
    if parant_value == "10000" then
        return_arr = save_new(invest_arr,parant_value)
    elseif parant_value == "20000" then
        return_arr = save_new(invest_stag_arr,parant_value)
    elseif parant_value == "30000" then
        return_arr = save_new(invest_filed_arr,parant_value)
    end
    return res:json(return_arr)

end)

-- dict relation stop

return dict_router

