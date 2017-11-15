<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%!   
//http://stackoverflow.com/a/18030465/1845894
String getClientIpAddr(HttpServletRequest request) {
       String ip = request.getHeader("X-Forwarded-For");
       if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
           ip = request.getHeader("Proxy-Client-IP");
       }
       if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
           ip = request.getHeader("WL-Proxy-Client-IP");
       }
       if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
           ip = request.getHeader("HTTP_CLIENT_IP");
       }
       if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
           ip = request.getHeader("HTTP_X_FORWARDED_FOR");
       }
       if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
           ip = request.getRemoteAddr();
       }
       return ip;
}
	
//http://stackoverflow.com/a/18030465/1845894
String getClientBrowser(HttpServletRequest request) {
    final String browserDetails = request.getHeader("User-Agent");
    final String user = browserDetails.toLowerCase();

    String browser = "";

    //===============Browser===========================
    if (user.contains("msie")) {
        String substring = browserDetails.substring(browserDetails.indexOf("MSIE")).split(";")[0];
        browser = substring.split(" ")[0].replace("MSIE", "IE") + "-" + substring.split(" ")[1];
    } else if (user.contains("safari") && user.contains("version")) {
        browser = (browserDetails.substring(browserDetails.indexOf("Safari")).split(" ")[0]).split(
                "/")[0] + "-" + (browserDetails.substring(
                browserDetails.indexOf("Version")).split(" ")[0]).split("/")[1];
    } else if (user.contains("opr") || user.contains("opera")) {
        if (user.contains("opera"))
            browser = (browserDetails.substring(browserDetails.indexOf("Opera")).split(" ")[0]).split(
                    "/")[0] + "-" + (browserDetails.substring(
                    browserDetails.indexOf("Version")).split(" ")[0]).split("/")[1];
        else if (user.contains("opr"))
            browser = ((browserDetails.substring(browserDetails.indexOf("OPR")).split(" ")[0]).replace("/",
                                                                                                       "-")).replace(
                    "OPR", "Opera");
    } else if (user.contains("chrome")) {
        browser = (browserDetails.substring(browserDetails.indexOf("Chrome")).split(" ")[0]).replace("/", "-");
    } else if ((user.indexOf("mozilla/7.0") > -1) || (user.indexOf("netscape6") != -1) || (user.indexOf(
            "mozilla/4.7") != -1) || (user.indexOf("mozilla/4.78") != -1) || (user.indexOf(
            "mozilla/4.08") != -1) || (user.indexOf("mozilla/3") != -1)) {
        //browser=(userAgent.substring(userAgent.indexOf("MSIE")).split(" ")[0]).replace("/", "-");
        browser = "Netscape-?";

    } else if (user.contains("firefox")) {
        browser = (browserDetails.substring(browserDetails.indexOf("Firefox")).split(" ")[0]).replace("/", "-");
    } else if (user.contains("rv")) {
        browser = "IE";
    } else {
        browser = "UnKnown, More-Info: " + browserDetails;
    }

    return browser;
}
%>