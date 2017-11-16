local iputils = require("resty.iputils")
local token_access = require("token-access")
local oauth_access = require("oauth-access")

iputils.enable_lrucache()

local whitelist_ips = multiauth_ip_whitelist or {}

whitelist = iputils.parse_cidrs(whitelist_ips)

local header_token_auth = ngx.var.http_x_token_auth
local query_string_token_auth = ngx.var.arg_x_token_auth

if iputils.ip_in_cidrs(ngx.var.remote_addr, whitelist) then
  ngx.log(ngx.ERR, "Requestor " .. ngx.var.remote_addr .. " on whitelist")
elseif header_token_auth or query_string_token_auth then
  ngx.log(ngx.ERR, "Checking auth header...")
  token_access.check_token(token_auth, query_string_token_auth)
else
  ngx.log(ngx.ERR, "Validating oauth...")
  oauth_access.validate()
end
