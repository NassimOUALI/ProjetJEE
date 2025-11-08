package com.studysync.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.security.SecureRandom;
import java.util.Base64;

public class CSRFTokenManager {
    private static final String CSRF_TOKEN_NAME = "csrfToken";
    private static final SecureRandom random = new SecureRandom();

    public static String generateToken(HttpServletRequest request) {
        HttpSession session = request.getSession(true);
        String token = (String) session.getAttribute(CSRF_TOKEN_NAME);
        if (token == null) {
            byte[] bytes = new byte[32];
            random.nextBytes(bytes);
            token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
            session.setAttribute(CSRF_TOKEN_NAME, token);
        }
        return token;
    }

    public static String getToken(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (String) session.getAttribute(CSRF_TOKEN_NAME);
    }

    public static boolean isValidToken(HttpServletRequest request) {
        String sessionToken = getToken(request);
        if (sessionToken == null) return false;
        String requestToken = request.getParameter(CSRF_TOKEN_NAME);
        return sessionToken.equals(requestToken);
    }
}



