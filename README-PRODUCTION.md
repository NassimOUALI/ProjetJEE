# StudySync - Production Deployment Guide

## Production Configuration

### 1. Database Configuration

For production, update `hibernate.prod.cfg.xml` with your production database credentials:

```xml
<property name="hibernate.connection.url">jdbc:mysql://your-production-host:3306/studysync</property>
<property name="hibernate.connection.username">your-username</property>
<property name="hibernate.connection.password">your-password</property>
```

### 2. Using Production Configuration

To use the production Hibernate configuration, update `HibernateUtil.java`:

```java
configuration.configure("hibernate.prod.cfg.xml");
```

Or set the system property:
```bash
-Dhibernate.config.file=hibernate.prod.cfg.xml
```

### 3. Production Settings

The production configuration includes:
- **DDL Auto**: `validate` (no schema changes)
- **SQL Logging**: Disabled
- **Connection Pool**: C3P0 with optimized settings
  - Min pool size: 10
  - Max pool size: 50
  - Connection timeout: 300 seconds
- **Batch Processing**: Enabled for better performance

### 4. Logging

Logback is configured in `src/main/resources/logback.xml`:
- Logs to console and file
- Daily log rotation
- Separate error log file
- Configurable log levels

Log files are written to the `logs/` directory (configurable via `LOG_DIR` environment variable).

### 5. Security Checklist

- [ ] Change default database passwords
- [ ] Use SSL for database connections (`useSSL=true`)
- [ ] Configure proper CORS if needed
- [ ] Set up HTTPS for the web application
- [ ] Review and restrict file uploads if applicable
- [ ] Configure proper session timeout
- [ ] Set up proper error pages (404, 500)
- [ ] Enable CSRF protection (already implemented)

### 6. Performance Tuning

- Connection pool size should match your expected load
- Monitor database connection usage
- Consider enabling second-level cache for read-heavy operations
- Use database indexes for frequently queried columns

### 7. Deployment

1. Build the WAR file:
   ```bash
   mvn clean package
   ```

2. Deploy to your application server (Tomcat, etc.)

3. Set environment variables if needed:
   ```bash
   export LOG_DIR=/var/log/studysync
   export JAVA_OPTS="-Dhibernate.config.file=hibernate.prod.cfg.xml"
   ```

### 8. Monitoring

- Monitor application logs in `logs/studysync.log`
- Monitor error logs in `logs/error.log`
- Check database connection pool metrics
- Monitor application server resources

