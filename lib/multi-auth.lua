local iputils = require("resty.iputils")
local token_access = require("token-access")
local oauth_access = require("oauth-access")

iputils.enable_lrucache()

local whitelist_ips = multiauth_ip_whitelist or {}

whitelist = iputils.parse_cidrs(whitelist_ips)

if iputils.ip_in_cidrs(ngx.var.remote_addr, whitelist) then
  ngx.log(ngx.ERR, "Requestor " .. ngx.var.remote_addr .. " on whitelist")
elseif ngx.var["http_authorization"] then
  ngx.log(ngx.ERR, "Checking auth header...")
  token_access.check_token(ngx.var.http_authorization)
else
  ngx.log(ngx.ERR, "Validating oauth...")
  oauth_access.validate()
end

