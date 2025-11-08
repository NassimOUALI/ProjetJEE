package com.studysync.web.filter;

import com.studysync.util.FlashMessage;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@WebFilter(filterName = "FlashMessageFilter", urlPatterns = {"/*"})
public class FlashMessageFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) servletRequest;
        String flashSuccess = FlashMessage.getSuccess(req);
        String flashError = FlashMessage.getError(req);
        if (flashSuccess != null) {
            req.setAttribute("flashSuccess", flashSuccess);
        }
        if (flashError != null) {
            req.setAttribute("flashError", flashError);
        }
        chain.doFilter(servletRequest, servletResponse);
    }
}

