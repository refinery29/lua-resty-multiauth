local _M = {}

local function check_token(token)
    local authorized_tokens = {
        ["1af538baa9045a84c0e889f672baf83ff25"] = "Stakeout",
        ["1af538baa9045a84c0e889f672baf83ff24"] = "Runscope",
    }

    local token = string.sub(ngx.var.http_authorization, 7)

    if not authorized_tokens[token] then
        ngx.header.content_type = "text/html"
        ngx.status = ngx.HTTP_UNAUTHORIZED
        ngx.say("<h1>401 Unauthorized</h1>")

        return ngx.exit(ngx.HTTP_UNAUTHORIZED)
    end
end
_M.check_token = check_token
return _M
