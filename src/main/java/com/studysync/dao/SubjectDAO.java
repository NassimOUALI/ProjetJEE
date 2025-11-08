package com.studysync.dao;

import com.studysync.model.Subject;

public class SubjectDAO extends GenericDAO<Subject, Long> {
    public SubjectDAO() {
        super(Subject.class);
    }
}


