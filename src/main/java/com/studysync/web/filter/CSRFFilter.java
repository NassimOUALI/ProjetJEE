package com.studysync.web.filter;

import com.studysync.util.CSRFTokenManager;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter(filterName = "CSRFFilter", urlPatterns = {"/*"})
public class CSRFFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) servletRequest;
        HttpServletResponse resp = (HttpServletResponse) servletResponse;

        // Skip CSRF check for GET requests and static resources
        if ("GET".equalsIgnoreCase(req.getMethod()) || req.getRequestURI().endsWith(".css") || 
            req.getRequestURI().endsWith(".js") || req.getRequestURI().endsWith(".png") ||
            req.getRequestURI().endsWith(".jpg") || req.getRequestURI().endsWith(".gif") ||
            req.getRequestURI().contains("/auth/logout")) {
            chain.doFilter(servletRequest, servletResponse);
            return;
        }
        
        // Skip CSRF check for login/register (these will validate themselves)
        if (req.getRequestURI().contains("/auth/login") || req.getRequestURI().contains("/auth/register")) {
            chain.doFilter(servletRequest, servletResponse);
            return;
        }

        // For POST/PUT/DELETE requests, validate CSRF token
        if ("POST".equalsIgnoreCase(req.getMethod()) || "PUT".equalsIgnoreCase(req.getMethod()) || 
            "DELETE".equalsIgnoreCase(req.getMethod())) {
            if (!CSRFTokenManager.isValidToken(req)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing CSRF token");
                return;
            }
        }

        chain.doFilter(servletRequest, servletResponse);
    }
}

