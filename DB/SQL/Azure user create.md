### Create SQL auth login from master

```sql
CREATE LOGIN <user> WITH PASSWORD = '<password>' 
```

### Select your db in the dropdown and create a user mapped to a login

```sql
CREATE USER <user> FOR LOGIN <database> WITH DEFAULT_SCHEMA = dbo;
```

### Add user to role(s) in db

```sql
ALTER ROLE db_owner ADD MEMBER <user>;
```