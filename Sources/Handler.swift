import PerfectLib
import PerfectHTTP
import PerfectMustache
import SQLite


struct IndexHandler: MustachePageHandler {
    
    func extendValuesForResponse(context contxt: MustacheWebEvaluationContext, collector: MustacheEvaluationOutputCollector) {
        var values = MustacheEvaluationContext.MapType()
        var ary = [Any]()
        
        let dbHandler = DB()
        let data = dbHandler.getList()
        
        for i in 0..<data.count {
            var thispost = [String: String]()
            thispost["title"] = data[i]["title"]
            thispost["synopsis"] = data[i]["synopsis"]
            thispost["titlesanitized"] = data[i]["title"]!.slugify()
            ary.append(thispost)
        }
        values["posts"] = ary
        
        contxt.extendValues(with: values)
        do {
            try contxt.requestCompleted(withCollector: collector)
        } catch {
            let response = contxt.webResponse
            response.status = .internalServerError
            response.appendBody(string: "\(error)")
            response.completed()
        }
    }
}

