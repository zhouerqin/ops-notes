<%@ page contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%

String scheme = request.getScheme();
String serverName = request.getServerName();
int serverPort = request.getServerPort();
String requestURI = request.getRequestURI();
String queryString = request.getQueryString();
String method = request.getMethod();
String protocol = request.getProtocol();
String remoteAddr = request.getRemoteAddr();
int remotePort = request.getRemotePort();

String hostname = "";
try {
    hostname = InetAddress.getLocalHost().getHostName();
} catch (Exception e) {
    hostname = "unknown";
}

out.println("Hostname: " + hostname);
out.println("IP: " + remoteAddr);
out.println("Port: " + remotePort);
out.println();
out.println(method + " " + requestURI + (queryString != null ? "?" + queryString : "") + " " + protocol);
out.println("Host: " + serverName + (serverPort != 80 && serverPort != 443 ? ":" + serverPort : ""));
out.println();
out.println("Headers:");
Enumeration<String> headerNames = request.getHeaderNames();
while (headerNames.hasMoreElements()) {
    String name = headerNames.nextElement();
    String value = request.getHeader(name);
    out.println("  " + name + ": " + value);
}

%>