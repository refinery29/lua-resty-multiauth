local iputils = require("resty.iputils")
local token_access = require("token-access")
local oauth_access = require("oauth-access")

iputils.enable_lrucache()

local whitelist_ips = multiauth_ip_whitelist or {}

whitelist = iputils.parse_cidrs(whitelist_ips)

local token_auth = ngx.req.get_headers()["X-Token-Auth"]
ngx.log(ngx.ERR, "token is " .. token_auth)

if iputils.ip_in_cidrs(ngx.var.remote_addr, whitelist) then
  ngx.log(ngx.ERR, "Requestor " .. ngx.var.remote_addr .. " on whitelist")
elseif token_auth then
  ngx.log(ngx.ERR, "Checking auth header...")
  token_access.check_token(token_auth)
else
  ngx.log(ngx.ERR, "Validating oauth...")
  oauth_access.validate()
end
