DECLARE @databaseName sysname 
DECLARE @backupStartDate datetime 
DECLARE @backup_set_id_start INT 
DECLARE @backup_set_id_end INT 
DECLARE @max_family int

-- set database to be used 
SET @databaseName = 'databasenaam'  

SELECT @backup_set_id_start = MAX(backup_set_id)  
FROM  msdb.dbo.backupset  
WHERE database_name = @databaseName AND type = 'D' 

SELECT @backup_set_id_end = MIN(backup_set_id)  
FROM  msdb.dbo.backupset  
WHERE database_name = @databaseName AND type = 'D' 
AND backup_set_id > @backup_set_id_start 

select  @max_family=max(family_sequence_number) 
FROM    msdb.dbo.backupset b, 
    msdb.dbo.backupmediafamily mf 
WHERE   b.media_set_id = mf.media_set_id 
AND     b.database_name = @databaseName 
AND     b.backup_set_id = @backup_set_id_start 

IF @backup_set_id_end IS NULL SET @backup_set_id_end = 999999999 

SELECT  backup_set_id, family_sequence_number,
    case mf.family_sequence_number 
        when 1 then 'RESTORE DATABASE ' + @databaseName + ' FROM DISK = ''' 
        else '                         , DISK = '''
    end 
        + mf.physical_device_name + 
    case mf.family_sequence_number
        when @max_family then ''' WITH REPLACE, NORECOVERY' 
        else ''''
    end
FROM    msdb.dbo.backupset b, 
    msdb.dbo.backupmediafamily mf 
WHERE   b.media_set_id = mf.media_set_id 
AND     b.database_name = @databaseName 
AND     b.backup_set_id = @backup_set_id_start 
UNION 
SELECT  backup_set_id, 1, 
    'RESTORE LOG ' + @databaseName + ' FROM DISK = ''' + mf.physical_device_name + ''' WITH REPLACE, NORECOVERY' 
FROM    msdb.dbo.backupset b, 
    msdb.dbo.backupmediafamily mf 
WHERE   b.media_set_id = mf.media_set_id 
AND     b.database_name = @databaseName 
AND     b.backup_set_id >= @backup_set_id_start AND b.backup_set_id < @backup_set_id_end 
AND     b.type = 'L' 
UNION 
SELECT  999999999 AS backup_set_id, 1, 
    'RESTORE DATABASE ' + @databaseName + ' WITH REPLACE, RECOVERY' 
ORDER BY backup_set_id, 2