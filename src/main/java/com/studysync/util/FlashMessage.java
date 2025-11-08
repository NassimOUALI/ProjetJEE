package com.studysync.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class FlashMessage {
    public static final String FLASH_SUCCESS = "flashSuccess";
    public static final String FLASH_ERROR = "flashError";

    public static void setSuccess(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute(FLASH_SUCCESS, message);
    }

    public static void setError(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute(FLASH_ERROR, message);
    }

    public static String getSuccess(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        String message = (String) session.getAttribute(FLASH_SUCCESS);
        if (message != null) {
            session.removeAttribute(FLASH_SUCCESS);
        }
        return message;
    }

    public static String getError(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        String message = (String) session.getAttribute(FLASH_ERROR);
        if (message != null) {
            session.removeAttribute(FLASH_ERROR);
        }
        return message;
    }
}



