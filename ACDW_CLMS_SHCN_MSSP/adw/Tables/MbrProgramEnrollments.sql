CREATE TABLE [adw].[MbrProgramEnrollments] (
    [mbrProgramEnrollmentKey] INT           IDENTITY (1, 1) NOT NULL,
    [ClientMemberKey]         VARCHAR (50)  NOT NULL,
    [ClientKey]               INT           NOT NULL,
    [ProgramName]             VARCHAR (100) NOT NULL,
    [EnrollmentStartDate]     DATE          NULL,
    [EnrollmentStopDate]      DATE          NULL,
    [PlanStartDate]           DATE          NULL,
    [PlanStopDate]            DATE          NULL,
    [ProgramStatus]           VARCHAR (100) NULL,
    [UpdateOnDate]            DATE          NULL,
    [SrcFileName]             VARCHAR (100) NOT NULL,
    [LoadDate]                DATE          NOT NULL,
    [CreatedDate]             DATETIME      CONSTRAINT [DF_MbrProgEnrol_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]               VARCHAR (50)  CONSTRAINT [DF_MbrProgEnrol_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]         DATETIME      CONSTRAINT [DF_MbrProgEnrol_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]           VARCHAR (50)  CONSTRAINT [DF_MbrProgEnrol_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [Status]                  INT           NULL,
    PRIMARY KEY CLUSTERED ([mbrProgramEnrollmentKey] ASC)
);


GO
CREATE STATISTICS [_dta_stat_1670349065_2_5_6]
    ON [adw].[MbrProgramEnrollments]([ClientMemberKey], [EnrollmentStartDate], [EnrollmentStopDate]);


GO
CREATE STATISTICS [_dta_stat_1670349065_4_5_6]
    ON [adw].[MbrProgramEnrollments]([ProgramName], [EnrollmentStartDate], [EnrollmentStopDate]);


GO
CREATE STATISTICS [_dta_stat_1670349065_6_2_4]
    ON [adw].[MbrProgramEnrollments]([EnrollmentStopDate], [ClientMemberKey], [ProgramName]);


GO
CREATE STATISTICS [_dta_stat_1670349065_2_4_5_6]
    ON [adw].[MbrProgramEnrollments]([ClientMemberKey], [ProgramName], [EnrollmentStartDate], [EnrollmentStopDate]);

