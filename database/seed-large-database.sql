-- StudySync Large Test Database Seed Script
-- This script creates a substantial amount of test data for performance testing
-- Run this after creating the tables with the DDL script

USE studysync;

-- Clear existing data (optional - comment out if you want to keep existing data)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE session_participants;
TRUNCATE TABLE group_members;
TRUNCATE TABLE group_subjects;
TRUNCATE TABLE posts;
TRUNCATE TABLE study_sessions;
TRUNCATE TABLE study_groups;
TRUNCATE TABLE subjects;
TRUNCATE TABLE students;
TRUNCATE TABLE roles;
SET FOREIGN_KEY_CHECKS = 1;

-- Insert Roles
INSERT INTO roles (id, nom, description) VALUES
(1, 'Student', 'Regular student role'),
(2, 'Admin', 'Administrator role'),
(3, 'Moderator', 'Group moderator role');

-- Insert Subjects (50 subjects)
INSERT INTO subjects (nom, description) VALUES
('Mathematics', 'Algebra, Calculus, Statistics'),
('Physics', 'Mechanics, Thermodynamics, Quantum Physics'),
('Chemistry', 'Organic, Inorganic, Physical Chemistry'),
('Biology', 'Cell Biology, Genetics, Ecology'),
('Computer Science', 'Programming, Algorithms, Data Structures'),
('History', 'World History, European History, American History'),
('Literature', 'English Literature, Poetry, Prose'),
('Philosophy', 'Ethics, Logic, Metaphysics'),
('Psychology', 'Cognitive, Behavioral, Social Psychology'),
('Economics', 'Microeconomics, Macroeconomics, Finance'),
('Business', 'Management, Marketing, Entrepreneurship'),
('Law', 'Constitutional Law, Criminal Law, Civil Law'),
('Medicine', 'Anatomy, Physiology, Pathology'),
('Engineering', 'Civil, Mechanical, Electrical Engineering'),
('Architecture', 'Design, Construction, Urban Planning'),
('Art', 'Painting, Sculpture, Digital Art'),
('Music', 'Theory, Composition, Performance'),
('Languages', 'French, Spanish, German, Chinese'),
('Geography', 'Physical, Human, Environmental Geography'),
('Political Science', 'International Relations, Public Policy'),
('Sociology', 'Social Theory, Research Methods'),
('Anthropology', 'Cultural, Physical, Archaeological'),
('Linguistics', 'Syntax, Semantics, Phonetics'),
('Astronomy', 'Astrophysics, Cosmology, Planetary Science'),
('Geology', 'Mineralogy, Petrology, Stratigraphy'),
('Environmental Science', 'Climate Change, Conservation'),
('Public Health', 'Epidemiology, Health Policy'),
('Education', 'Pedagogy, Curriculum Development'),
('Journalism', 'News Writing, Media Studies'),
('Communication', 'Public Speaking, Media Communication'),
('Accounting', 'Financial, Managerial, Auditing'),
('Finance', 'Investment, Banking, Risk Management'),
('Marketing', 'Advertising, Branding, Consumer Behavior'),
('Operations Management', 'Supply Chain, Logistics'),
('Information Systems', 'Database, Networks, Security'),
('Data Science', 'Machine Learning, Big Data Analytics'),
('Cybersecurity', 'Network Security, Cryptography'),
('Software Engineering', 'Development Methodologies, Testing'),
('Game Development', 'Game Design, Programming'),
('Web Development', 'Frontend, Backend, Full Stack'),
('Mobile Development', 'iOS, Android Development'),
('UI/UX Design', 'User Interface, User Experience'),
('Graphic Design', 'Visual Communication, Branding'),
('Film Studies', 'Cinematography, Film Theory'),
('Theater', 'Acting, Directing, Stage Design'),
('Dance', 'Ballet, Modern, Contemporary'),
('Sports Science', 'Exercise Physiology, Biomechanics'),
('Nutrition', 'Dietetics, Food Science'),
('Agriculture', 'Crop Science, Animal Husbandry'),
('Veterinary Science', 'Animal Medicine, Surgery');

-- Insert Students (500 students)
INSERT INTO students (nom, prenom, email, mot_de_passe, role_id)
SELECT 
    CONCAT('Student', n) as nom,
    CONCAT('FirstName', n) as prenom,
    CONCAT('student', n, '@studysync.test') as email,
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy' as mot_de_passe, -- password: "password"
    1 as role_id
FROM (
    SELECT @row := @row + 1 as n
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) t3,
         (SELECT @row := 0) r
) numbers
WHERE n <= 500;

-- Insert Study Groups (200 groups)
-- Each group has a creator and 5-15 members
SET @group_counter = 1;
SET @student_counter = 1;

INSERT INTO study_groups (nom, description, est_ouvert, createur_id)
SELECT 
    CONCAT('Study Group ', @group_counter := @group_counter + 1) as nom,
    CONCAT('This is a study group for ', 
           ELT(FLOOR(1 + RAND() * 50), 'Mathematics', 'Physics', 'Chemistry', 'Biology', 'Computer Science',
               'History', 'Literature', 'Philosophy', 'Psychology', 'Economics', 'Business', 'Law', 'Medicine',
               'Engineering', 'Architecture', 'Art', 'Music', 'Languages', 'Geography', 'Political Science',
               'Sociology', 'Anthropology', 'Linguistics', 'Astronomy', 'Geology', 'Environmental Science',
               'Public Health', 'Education', 'Journalism', 'Communication', 'Accounting', 'Finance', 'Marketing',
               'Operations Management', 'Information Systems', 'Data Science', 'Cybersecurity', 'Software Engineering',
               'Game Development', 'Web Development', 'Mobile Development', 'UI/UX Design', 'Graphic Design',
               'Film Studies', 'Theater', 'Dance', 'Sports Science', 'Nutrition', 'Agriculture', 'Veterinary Science'),
           '. Join us for collaborative learning!') as description,
    IF(RAND() > 0.3, TRUE, FALSE) as est_ouvert,
    MOD(@student_counter := @student_counter + 1, 500) + 1 as createur_id
FROM (
    SELECT @row := @row + 1 as n
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2) t3,
         (SELECT @row := 0) r
) numbers
WHERE n <= 200;

-- Reset counters for member assignments
SET @group_counter = 0;
SET @member_counter = 1;

-- Insert Group Members (each group has 5-15 members including creator)
INSERT INTO group_members (group_id, student_id)
SELECT DISTINCT
    g.id as group_id,
    s.id as student_id
FROM study_groups g
CROSS JOIN students s
WHERE s.id != g.createur_id
  AND s.id BETWEEN 1 AND 500
  AND (g.id * 7 + s.id) % 12 < 10  -- Random membership logic
  AND NOT EXISTS (
      SELECT 1 FROM group_members gm 
      WHERE gm.group_id = g.id AND gm.student_id = s.id
  )
LIMIT 2000;

-- Add creators as members of their groups
INSERT INTO group_members (group_id, student_id)
SELECT id, createur_id FROM study_groups
ON DUPLICATE KEY UPDATE group_id = group_id;

-- Insert Group-Subject relationships (each group has 1-3 subjects)
INSERT INTO group_subjects (group_id, subject_id)
SELECT 
    g.id as group_id,
    s.id as subject_id
FROM study_groups g
CROSS JOIN subjects s
WHERE (g.id * 3 + s.id) % 50 < 3  -- Random assignment
LIMIT 400;

-- Insert Study Sessions (1000 sessions across all groups)
INSERT INTO study_sessions (titre, description, heure_debut, heure_fin, group_id, organisateur_id)
SELECT 
    CONCAT('Session ', n, ' - ', g.nom) as titre,
    CONCAT('Study session for ', g.nom, '. We will cover important topics and practice problems.') as description,
    DATE_ADD(NOW(), INTERVAL n * 2 + FLOOR(RAND() * 30) DAY) as heure_debut,
    DATE_ADD(NOW(), INTERVAL n * 2 + FLOOR(RAND() * 30) DAY + 2 HOUR) as heure_fin,
    g.id as group_id,
    (SELECT student_id FROM group_members WHERE group_id = g.id ORDER BY RAND() LIMIT 1) as organisateur_id
FROM (
    SELECT @row := @row + 1 as n
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3,
         (SELECT 0 UNION SELECT 1) t4,
         (SELECT @row := 0) r
) numbers
CROSS JOIN study_groups g
WHERE n <= 1000
ORDER BY RAND()
LIMIT 1000;

-- Insert Session Participants (each session has 3-10 participants)
INSERT INTO session_participants (session_id, student_id)
SELECT DISTINCT
    s.id as session_id,
    m.student_id as student_id
FROM study_sessions s
INNER JOIN group_members m ON s.group_id = m.group_id
WHERE (s.id * 5 + m.student_id) % 8 < 7  -- Random participation
LIMIT 5000;

-- Insert Posts (2000 posts - for groups and sessions)
-- Posts for groups
INSERT INTO posts (contenu, type, date_publication, auteur_id, group_id, session_id)
SELECT 
    CONCAT('This is a post about ', 
           ELT(FLOOR(1 + RAND() * 10), 'homework', 'exam preparation', 'study materials', 
               'discussion', 'question', 'answer', 'resource sharing', 'announcement',
               'meeting notes', 'review')) as contenu,
    ELT(FLOOR(1 + RAND() * 3), 'Comment', 'Resource', 'Announcement') as type,
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 90) DAY) as date_publication,
    m.student_id as auteur_id,
    g.id as group_id,
    NULL as session_id
FROM study_groups g
INNER JOIN group_members m ON g.id = m.group_id
WHERE (g.id * 7 + m.student_id) % 5 = 0  -- Random post creation
LIMIT 1000;

-- Posts for sessions
INSERT INTO posts (contenu, type, date_publication, auteur_id, group_id, session_id)
SELECT 
    CONCAT('Session post: ', 
           ELT(FLOOR(1 + RAND() * 8), 'Questions before session', 'Materials needed', 
               'Session notes', 'Discussion', 'Follow-up questions',
               'Homework assignment', 'Review', 'Summary')) as contenu,
    ELT(FLOOR(1 + RAND() * 3), 'Comment', 'Resource', 'Announcement') as type,
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 60) DAY) as date_publication,
    p.student_id as auteur_id,
    s.group_id as group_id,
    s.id as session_id
FROM study_sessions s
INNER JOIN session_participants p ON s.id = p.session_id
WHERE (s.id * 3 + p.student_id) % 4 = 0  -- Random post creation
LIMIT 1000;

-- Display summary
SELECT 'Data Summary' as Info;
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
SELECT 'Session Participants', COUNT(*) FROM session_participants;

