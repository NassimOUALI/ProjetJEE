<%@ tag import="java.time.LocalDateTime,java.time.format.DateTimeFormatter" %>
<%@ attribute name="value" required="true" type="java.time.LocalDateTime" %>
<%@ variable name-given="formatted" scope="NESTED" %>
<%
    if (value != null) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM d, yyyy 'at' h:mm a");
        String formattedStr = value.format(formatter);
        jspContext.setAttribute("formatted", formattedStr);
    } else {
        jspContext.setAttribute("formatted", "");
    }
%>
${formatted}



