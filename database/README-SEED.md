# Database Seed Scripts

## Overview

These scripts generate large amounts of test data for performance testing and pagination verification.

## Files

1. **seed-large-database.sql** - Full-featured version with more realistic data
2. **seed-large-database-simple.sql** - Simplified, faster version

## Expected Data Volume

After running either script, you should have:

- **500 Students** (all with password: "password")
- **200 Study Groups** (with creators and members)
- **1000 Study Sessions** (distributed across groups)
- **2000 Posts** (1000 for groups, 1000 for sessions)
- **50 Subjects**
- **~2000 Group Memberships** (5-10 members per group)
- **~5000 Session Participants** (3-8 participants per session)

## Usage

### Option 1: Using MySQL Command Line

```bash
mysql -u root -p studysync < database/seed-large-database-simple.sql
```

### Option 2: Using MySQL Workbench or phpMyAdmin

1. Open the SQL script file
2. Select the `studysync` database
3. Execute the script

### Option 3: Using mysql client

```bash
mysql -u root -p
```

Then:
```sql
USE studysync;
SOURCE database/seed-large-database-simple.sql;
```

## Performance Testing

After seeding, you can test:

1. **Pagination**: Groups list should show 10 groups per page (20 pages total)
2. **Posts Pagination**: Each group/session should paginate posts (10 per page)
3. **Dashboard Performance**: Loading dashboard with many sessions
4. **Group View**: Viewing groups with many sessions and posts

## Test Accounts

All students use the same password: **password**

You can log in with:
- Email: `student1@test.com` (or `student1@studysync.test` for full version)
- Password: `password`

## Notes

- The simplified version (`seed-large-database-simple.sql`) executes faster
- The full version (`seed-large-database.sql`) has more realistic content
- Both generate the same volume of data
- Execution time: ~30-60 seconds depending on your system

## Clearing Data

To start fresh, you can truncate all tables:

```sql
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
```

Or drop and recreate the database:

```sql
DROP DATABASE IF EXISTS studysync;
CREATE DATABASE studysync;
-- Then run your DDL script to create tables
-- Then run the seed script
```

