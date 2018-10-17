local skynet = require "skynet"

local mysql = {
    mgr_handle = nil,
    sql_logger = nil,
    handle = nil
}

--sql查询
function mysql:query(sql)
    if not self.sql_handle then
        self.sql_handle = skynet.queryservice("srv_mysql_mgr")
        self.sql_logger = file_log("mysql")
        self.handle = skynet.call(self.sql_handle, "lua", "get_handle")
    end
    local query_result = skynet.call(self.handle, "lua", "query", sql)
    if not query_result then
        self.sql_logger:error("sql query %s, error nil", sql)
    else
        if query_result.errno then
            local pos = string.find(query_result.err, "Incorrect string", 1, true)
            if not pos then --过滤一些错误消息
                self.sql_logger:error("sql query %s, error %s", sql, query_result.err)
            end
        end
        return query_result
    end
end

return mysql
