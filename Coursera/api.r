library(httr)
library(jsonlite)
oauth_endpoints("github")
myapp <-oauth_app("github",
                  key= "Ov23lihsAOp4XazzGcXP",
                  secret = "2d4480075e59e3251e5e7cb2ad47b6789d0c4cba")
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)

json1= content(req)
json2 = jsonlite::fromJSON(toJSON(json1))
json2[24,] #rownum of the datasharing repo