### Get active connections from a specific database

```sql
USE master
SELECT * FROM sys.sysprocesses WHERE dbid = DB_ID('<database>')
```

### Get all active connections from all databases

```sql
USE master
SELECT spid, loginame, hostname, program_name, login_time, dbid FROM sys.sysprocesses WHERE dbid NOT IN (DB_ID('master'),DB_ID('model'),DB_ID('msdb'),DB_ID('tempdb'))
```