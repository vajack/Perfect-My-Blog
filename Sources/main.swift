import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectMustache


let server = HTTPServer()

server.documentRoot = "./webroot"


var routs = Routes()

var dbHandler = DB()
dbHandler.create()
dbHandler.populate()

routs.add(method: .get, uri: "/", handler: {
    request, response in
    
    mustacheRequest(request: request, response: response, handler: IndexHandler(), templatePath: request.documentRoot + "/index.mustache")
})

server.addRoutes(routs)

server.serverPort = 8181

do {
    try server.start()
}catch PerfectError.networkError(let err, let msg){
    print("Network error thrown: \(err) \(msg)")
}
