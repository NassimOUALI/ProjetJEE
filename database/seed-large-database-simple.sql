-- StudySync Large Test Database - Simplified Version
-- Faster execution with fewer joins and simpler logic
-- This script will DROP and RECREATE the database, then populate it with test data

-- Drop and recreate database
DROP DATABASE IF EXISTS studysync;
CREATE DATABASE studysync CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE studysync;

-- Create tables (DDL)
-- Note: Adjust these if your actual table structure differs

CREATE TABLE IF NOT EXISTS roles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS students (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    passwordHash VARCHAR(255) NOT NULL,
    dateInscription DATETIME NOT NULL,
    statut VARCHAR(50) NOT NULL DEFAULT 'ACTIVE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS student_roles (
    student_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    PRIMARY KEY (student_id, role_id),
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS subjects (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL UNIQUE,
    description VARCHAR(1000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS study_groups (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    description VARCHAR(1000),
    dateCreation DATETIME NOT NULL,
    estOuvert BOOLEAN NOT NULL DEFAULT TRUE,
    createur_id BIGINT NOT NULL,
    FOREIGN KEY (createur_id) REFERENCES students(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS group_members (
    group_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    PRIMARY KEY (group_id, student_id),
    FOREIGN KEY (group_id) REFERENCES study_groups(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS group_subjects (
    group_id BIGINT NOT NULL,
    subject_id BIGINT NOT NULL,
    PRIMARY KEY (group_id, subject_id),
    FOREIGN KEY (group_id) REFERENCES study_groups(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS study_sessions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    description VARCHAR(2000),
    heureDebut DATETIME NOT NULL,
    heureFin DATETIME NOT NULL,
    group_id BIGINT NOT NULL,
    organisateur_id BIGINT NOT NULL,
    FOREIGN KEY (group_id) REFERENCES study_groups(id) ON DELETE CASCADE,
    FOREIGN KEY (organisateur_id) REFERENCES students(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS session_participants (
    session_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    PRIMARY KEY (session_id, student_id),
    FOREIGN KEY (session_id) REFERENCES study_sessions(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS posts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    contenu VARCHAR(4000) NOT NULL,
    type VARCHAR(100) NOT NULL,
    datePublication DATETIME NOT NULL,
    auteur_id BIGINT NOT NULL,
    group_id BIGINT,
    session_id BIGINT,
    FOREIGN KEY (auteur_id) REFERENCES students(id) ON DELETE RESTRICT,
    FOREIGN KEY (group_id) REFERENCES study_groups(id) ON DELETE CASCADE,
    FOREIGN KEY (session_id) REFERENCES study_sessions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert Roles
INSERT INTO roles (id, nom) VALUES
(1, 'Student'),
(2, 'Admin'),
(3, 'Moderator');

-- Insert 50 Subjects
INSERT INTO subjects (nom, description) VALUES
('Mathematics', 'Algebra, Calculus, Statistics'),
('Physics', 'Mechanics, Thermodynamics'),
('Chemistry', 'Organic, Inorganic Chemistry'),
('Biology', 'Cell Biology, Genetics'),
('Computer Science', 'Programming, Algorithms'),
('History', 'World History'),
('Literature', 'English Literature'),
('Philosophy', 'Ethics, Logic'),
('Psychology', 'Cognitive Psychology'),
('Economics', 'Microeconomics, Macroeconomics'),
('Business', 'Management, Marketing'),
('Law', 'Constitutional Law'),
('Medicine', 'Anatomy, Physiology'),
('Engineering', 'Civil, Mechanical Engineering'),
('Architecture', 'Design, Construction'),
('Art', 'Painting, Sculpture'),
('Music', 'Theory, Composition'),
('Languages', 'French, Spanish'),
('Geography', 'Physical Geography'),
('Political Science', 'International Relations'),
('Sociology', 'Social Theory'),
('Anthropology', 'Cultural Anthropology'),
('Linguistics', 'Syntax, Semantics'),
('Astronomy', 'Astrophysics'),
('Geology', 'Mineralogy'),
('Environmental Science', 'Climate Change'),
('Public Health', 'Epidemiology'),
('Education', 'Pedagogy'),
('Journalism', 'News Writing'),
('Communication', 'Public Speaking'),
('Accounting', 'Financial Accounting'),
('Finance', 'Investment, Banking'),
('Marketing', 'Advertising'),
('Operations Management', 'Supply Chain'),
('Information Systems', 'Database, Networks'),
('Data Science', 'Machine Learning'),
('Cybersecurity', 'Network Security'),
('Software Engineering', 'Development'),
('Game Development', 'Game Design'),
('Web Development', 'Frontend, Backend'),
('Mobile Development', 'iOS, Android'),
('UI/UX Design', 'User Interface'),
('Graphic Design', 'Visual Communication'),
('Film Studies', 'Cinematography'),
('Theater', 'Acting'),
('Dance', 'Ballet'),
('Sports Science', 'Exercise Physiology'),
('Nutrition', 'Dietetics'),
('Agriculture', 'Crop Science'),
('Veterinary Science', 'Animal Medicine');

-- Insert 500 Students
INSERT INTO students (nom, prenom, email, passwordHash, dateInscription, statut)
SELECT 
    CONCAT('Student', n) as nom,
    CONCAT('First', n) as prenom,
    CONCAT('student', n, '@test.com') as email,
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy' as passwordHash,
    NOW() as dateInscription,
    'ACTIVE' as statut
FROM (
    SELECT a.N + b.N * 10 + c.N * 100 + 1 as n
    FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a
    CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
    CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) c
) numbers
WHERE n <= 500;

-- Assign Student role to all students
INSERT INTO student_roles (student_id, role_id)
SELECT id, 1 FROM students;

-- Insert 200 Study Groups
INSERT INTO study_groups (nom, description, estOuvert, dateCreation, createur_id)
SELECT 
    CONCAT('Study Group ', n) as nom,
    CONCAT('Description for Study Group ', n) as description,
    IF(n % 3 = 0, FALSE, TRUE) as estOuvert,
    NOW() as dateCreation,
    ((n - 1) % 500) + 1 as createur_id
FROM (
    SELECT a.N + b.N * 10 + c.N * 100 + 1 as n
    FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a
    CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
    CROSS JOIN (SELECT 0 AS N UNION SELECT 1) c
) numbers
WHERE n <= 200;

-- Insert Group Members (creators + 5-10 random members per group)
INSERT INTO group_members (group_id, student_id)
SELECT g.id, g.createur_id FROM study_groups g;

INSERT INTO group_members (group_id, student_id)
SELECT 
    g.id,
    ((g.id * 7 + n) % 500) + 1 as student_id
FROM study_groups g
CROSS JOIN (
    SELECT 1 as n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 
    UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
) members
WHERE ((g.id * 7 + n) % 12) < 10
  AND ((g.id * 7 + n) % 500) + 1 != g.createur_id
LIMIT 2000;

-- Insert Group-Subject relationships (1-3 subjects per group)
INSERT INTO group_subjects (group_id, subject_id)
SELECT 
    g.id,
    ((g.id * 3 + n) % 50) + 1 as subject_id
FROM study_groups g
CROSS JOIN (SELECT 1 as n UNION SELECT 2 UNION SELECT 3) subj
WHERE ((g.id * 3 + n) % 50) < 3
LIMIT 400;

-- Insert 1000 Study Sessions
INSERT INTO study_sessions (titre, description, heureDebut, heureFin, group_id, organisateur_id)
SELECT 
    CONCAT('Session ', n) as titre,
    CONCAT('Study session ', n, ' description') as description,
    DATE_ADD(NOW(), INTERVAL n DAY) as heureDebut,
    DATE_ADD(DATE_ADD(NOW(), INTERVAL n DAY), INTERVAL 2 HOUR) as heureFin,
    ((n - 1) % 200) + 1 as group_id,
    (SELECT student_id FROM group_members WHERE group_id = ((n - 1) % 200) + 1 LIMIT 1) as organisateur_id
FROM (
    SELECT a.N + b.N * 10 + c.N * 100 + d.N * 1000 + 1 as n
    FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a
    CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
    CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c
    CROSS JOIN (SELECT 0 AS N UNION SELECT 1) d
) numbers
WHERE n <= 1000;

-- Insert Session Participants (3-8 participants per session)
INSERT INTO session_participants (session_id, student_id)
SELECT 
    s.id,
    m.student_id
FROM study_sessions s
INNER JOIN group_members m ON s.group_id = m.group_id
WHERE ((s.id * 5 + m.student_id) % 8) < 7
LIMIT 5000;

-- Insert 2000 Posts
-- 1000 posts for groups
INSERT INTO posts (contenu, type, datePublication, auteur_id, group_id, session_id)
SELECT 
    CONCAT('Post ', n, ' for group ', g.id) as contenu,
    IF(n % 3 = 0, 'Resource', IF(n % 3 = 1, 'Announcement', 'Comment')) as type,
    DATE_SUB(NOW(), INTERVAL (n % 90) DAY) as datePublication,
    m.student_id as auteur_id,
    g.id as group_id,
    NULL as session_id
FROM study_groups g
INNER JOIN group_members m ON g.id = m.group_id
CROSS JOIN (
    SELECT a.N + b.N * 10 + 1 as n
    FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a
    CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
) numbers
WHERE ((g.id * 7 + m.student_id) % 5) = 0
  AND n <= 1000
LIMIT 1000;

-- 1000 posts for sessions
INSERT INTO posts (contenu, type, datePublication, auteur_id, group_id, session_id)
SELECT 
    CONCAT('Post ', n, ' for session ', s.id) as contenu,
    IF(n % 3 = 0, 'Resource', IF(n % 3 = 1, 'Announcement', 'Comment')) as type,
    DATE_SUB(NOW(), INTERVAL (n % 60) DAY) as datePublication,
    p.student_id as auteur_id,
    s.group_id as group_id,
    s.id as session_id
FROM study_sessions s
INNER JOIN session_participants p ON s.id = p.session_id
CROSS JOIN (
    SELECT a.N + b.N * 10 + 1 as n
    FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a
    CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
) numbers
WHERE ((s.id * 3 + p.student_id) % 4) = 0
  AND n <= 1000
LIMIT 1000;

-- Summary
SELECT '=== Data Summary ===' as Info;
SELECT 'Students' as Entity, COUNT(*) as Count FROM students
UNION ALL
SELECT 'Groups', COUNT(*) FROM study_groups
UNION ALL
SELECT 'Sessions', COUNT(*) FROM study_sessions
UNION ALL
SELECT 'Posts', COUNT(*) FROM posts
UNION ALL
SELECT 'Subjects', COUNT(*) FROM subjects
UNION ALL
SELECT 'Group Members', COUNT(*) FROM group_members
UNION ALL
SELECT 'Session Participants', COUNT(*) FROM session_participants
UNION ALL
SELECT 'Student Roles', COUNT(*) FROM student_roles;

