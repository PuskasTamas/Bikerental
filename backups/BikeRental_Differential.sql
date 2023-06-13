USE [msdb]
GO
DECLARE @jobId BINARY(16)
BEGIN TRY
EXEC msdb.dbo.sp_add_job @job_name=N'BikeRental_Differential', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'@loginName', @job_id = @jobId OUTPUT
SELECT @jobId;
EXEC msdb.dbo.sp_add_jobserver @job_name=N'BikeRental_Differential', @server_name=N'@selectedServer';
USE [msdb];
EXEC msdb.dbo.sp_add_jobstep @job_name=N'BikeRental_Differential', @step_name=N'Differential_backup', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'@agent_diff', 
		@database_name=N'BikeRental', 
		@flags=0;
USE [msdb];
EXEC msdb.dbo.sp_update_job @job_name=N'BikeRental_Differential', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'@loginName', 
		@notify_email_operator_name=N'', 
		@notify_page_operator_name=N'';
USE [msdb];
DECLARE @schedule_id int;
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'BikeRental_Differential', @name=N'BikeRental_Differential', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=62, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=@date,
		@active_end_date=99991231, 
		@active_start_time=80000, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
SELECT @schedule_id;
END TRY
BEGIN CATCH
PRINT 'Job is exists'
END CATCH