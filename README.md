StudySync — Group Study Planner (JEE + Hibernate + JSP)

Prerequisites
- Java 11+
- Maven 3.8+
- Apache Tomcat 9 (e.g., `C:\Users\lenovo\Desktop\IT\Files\apache-tomcat-9.0.111-windows-x64`)

Build
1. mvn clean package
2. Deploy `target/studysync.war` to Tomcat `webapps/`

Run (Dev, H2)
- Default config uses H2 (file DB at `~/studysync`). No setup required.

Switch to MySQL
1. Ensure MySQL is running and a database exists, e.g., `studysync`.
2. Update `src/main/resources/hibernate.cfg.xml` with:
   - driver: `com.mysql.cj.jdbc.Driver`
   - url: `jdbc:mysql://localhost:3306/studysync?useSSL=false&serverTimezone=UTC`
   - username/password: your credentials
   - dialect: `org.hibernate.dialect.MySQL8Dialect`

Example MySQL hibernate.cfg.xml
```xml
<hibernate-configuration>
  <session-factory>
    <property name="hibernate.connection.driver_class">com.mysql.cj.jdbc.Driver</property>
    <property name="hibernate.connection.url">jdbc:mysql://localhost:3306/studysync?useSSL=false&amp;serverTimezone=UTC</property>
    <property name="hibernate.connection.username">root</property>
    <property name="hibernate.connection.password">password</property>
    <property name="hibernate.dialect">org.hibernate.dialect.MySQL8Dialect</property>
    <property name="hibernate.hbm2ddl.auto">update</property>
    <property name="hibernate.show_sql">true</property>
    <property name="hibernate.format_sql">true</property>
  </session-factory>
 </hibernate-configuration>
```

JDBC Driver
- Maven already declares `mysql-connector-j:8.4.0`. If offline, copy the jar from `C:\Users\lenovo\Desktop\IT\Files\mysql-connector-j-8.4.0` into Tomcat `lib/` and rebuild if necessary.

URLs
- `/` Home
- `/auth/login`, `/auth/register`, `/auth/logout`
- `/dashboard` (protected)
- `/groups/*`, `/sessions/*`, `/posts/*`, `/profile/edit` (protected)

Notes
- Authentication uses session attribute `user`.
- Entities are registered via `HibernateUtil.addAnnotatedClass(...)`.

