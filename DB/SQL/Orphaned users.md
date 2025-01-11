### Get all orphaned users

```sql
EXEC sp_change_users_login 'REPORT' 
```

### Fix orphaned user

```sql
EXEC sp_change_users_login 'UPDATE_ONE','<user1>','<user1>'
```