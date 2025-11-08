package com.studysync.util;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class DateTimeUtil {
    public Date toDate(LocalDateTime ldt) {
        if (ldt == null) return null;
        return Date.from(ldt.atZone(ZoneId.systemDefault()).toInstant());
    }

    public String formatDateTime(LocalDateTime ldt) {
        if (ldt == null) return "";
        return ldt.toString().replace('T', ' ');
    }

    public String formatDate(LocalDateTime ldt) {
        if (ldt == null) return "";
        return ldt.toLocalDate().toString();
    }

    public String formatTime(LocalDateTime ldt) {
        if (ldt == null) return "";
        return ldt.toLocalTime().toString();
    }
}



