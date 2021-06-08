CREATE VIEW adw.vw_Dashboard_CMActivities
AS

SELECT 'Appointments'		AS ActivityType
	,ClientKey				AS ClientKey
	,DATEPART(ww, [AppointmentCreatedDate]) AS Wk
    ,DATEADD(dd, - (DATEPART(dw, [AppointmentCreatedDate]) - 1), [AppointmentCreatedDate]) WkStart
    ,DATEADD(dd, 7 - (DATEPART(dw, [AppointmentCreatedDate])), [AppointmentCreatedDate]) WkEnd
    ,'Appointments'			AS KPIType
    ,[AppointmentStatus]	AS KPIStatus
    ,count(DISTINCT ClientMemberKey) AS CntMembers
FROM [adw].[MbrAppointments]
GROUP BY ClientKey				
	,DATEPART(ww, [AppointmentCreatedDate])
    ,DATEADD(dd, - (DATEPART(dw, [AppointmentCreatedDate]) - 1), [AppointmentCreatedDate])
    ,DATEADD(dd, 7 - (DATEPART(dw, [AppointmentCreatedDate])), [AppointmentCreatedDate])
    ,[AppointmentStatus]
--ORDER BY DATEPART(ww, [AppointmentCreatedDate])
--    ,DATEADD(dd, - (DATEPART(dw, [AppointmentCreatedDate]) - 1), [AppointmentCreatedDate])
--    ,DATEADD(dd, 7 - (DATEPART(dw, [AppointmentCreatedDate])), [AppointmentCreatedDate])
--    ,[AppointmentStatus]
UNION
SELECT 'Programs'			AS ActivityType
	,ClientKey				AS ClientKey
	,DATEPART(ww, [CreatedDate]) AS Wk
    ,DATEADD(dd, - (DATEPART(dw, [CreatedDate]) - 1), [CreatedDate]) WkStart
    ,DATEADD(dd, 7 - (DATEPART(dw, [CreatedDate])), [CreatedDate]) WkEnd
    ,[ProgramName]			AS KPIType
    ,[ProgramStatus]		AS KPIStatus
    ,count(DISTINCT ClientMemberKey) AS CntMembers
FROM [adw].[MbrProgramEnrollments]
--WHERE 
GROUP BY ClientKey				
	,DATEPART(ww, [CreatedDate])
    ,DATEADD(dd, - (DATEPART(dw, [CreatedDate]) - 1), [CreatedDate])
    ,DATEADD(dd, 7 - (DATEPART(dw, [CreatedDate])), [CreatedDate])
    ,[ProgramName]
    ,[ProgramStatus]
--ORDER BY DATEPART(ww, [CreatedDate])
--    ,DATEADD(dd, - (DATEPART(dw, [CreatedDate]) - 1), [CreatedDate])
--    ,DATEADD(dd, 7 - (DATEPART(dw, [CreatedDate])), [CreatedDate])
--    ,[ProgramName]
--    ,[ProgramStatus]
UNION
SELECT 'CareActivities'				AS ActivityType
	,ClientKey						AS ClientKey
	,DATEPART(ww,ActivityCreatedDate) as Wk
    ,DATEADD(dd, -(DATEPART(dw, ActivityCreatedDate)-1), ActivityCreatedDate) WkStart
    ,DATEADD(dd, 7-(DATEPART(dw, ActivityCreatedDate)), ActivityCreatedDate) WkEnd
    ,CareActivityTypeName			AS KPIType
	,ActivityOutcome				AS KPIStatus
    ,count(DISTINCT ClientMemberKey) AS CntMembers
	FROM [adw].[mbrActivities]
--WHERE CareActivityTypeName in ('Health Risk Assessment','Assessment')
GROUP BY ClientKey				
	,DATEPART(ww,ActivityCreatedDate)
    ,DATEADD(dd, -(DATEPART(dw, ActivityCreatedDate)-1), ActivityCreatedDate) 
    ,DATEADD(dd, 7-(DATEPART(dw, ActivityCreatedDate)), ActivityCreatedDate)
    ,CareActivityTypeName 
	,ActivityOutcome
--ORDER BY DATEPART(ww,ActivityCreatedDate)
--    ,DATEADD(dd, -(DATEPART(dw, ActivityCreatedDate)-1), ActivityCreatedDate) 
--    ,DATEADD(dd, 7-(DATEPART(dw, ActivityCreatedDate)), ActivityCreatedDate)
--    ,CareActivityTypeName
--	,ActivityOutcome

--SELECT DISTINCT CareActivityTypeName
--	FROM [adw].[mbrActivities]

/***
SELECT * FROM adw.vw_Dashboard_CMActivities
***/