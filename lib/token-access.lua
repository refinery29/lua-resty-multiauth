local _M = {}

local authorized_tokens = multiauth_authorized_tokens or {}

local function check_token(raw_token)

    local token = string.sub(raw_token, 7)
    ngx.log(ngx.ERR, "cleaned token is " .. token)

    if not authorized_tokens[token] then
        ngx.header.content_type = "text/html"
        ngx.status = ngx.HTTP_UNAUTHORIZED
        ngx.say("<h1>401 Unauthorized</h1>")

        return ngx.exit(ngx.HTTP_UNAUTHORIZED)
    end
end
_M.check_token = check_token
return _M
