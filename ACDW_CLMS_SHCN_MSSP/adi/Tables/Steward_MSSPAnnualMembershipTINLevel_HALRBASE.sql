﻿CREATE TABLE [adi].[Steward_MSSPAnnualMembershipTINLevel_HALRBASE] (
    [MSSPAnnualMembershipTINLKey] INT           IDENTITY (1, 1) NOT NULL,
    [SrcFileName]                 VARCHAR (100) NULL,
    [CreateDate]                  DATETIME      DEFAULT (sysdatetime()) NULL,
    [CreateBy]                    VARCHAR (100) DEFAULT (suser_sname()) NULL,
    [OriginalFileName]            VARCHAR (100) NULL,
    [LastUpdatedBy]               VARCHAR (100) NULL,
    [LastUpdatedDate]             DATETIME      NULL,
    [DataDate]                    DATE          NULL,
    [YearNBR]                     VARCHAR (50)  NULL,
    [MedicareBeneficiaryID]       VARCHAR (50)  NULL,
    [HealthInsuranceClaimNBR]     VARCHAR (50)  NULL,
    [FirstNM]                     VARCHAR (20)  NULL,
    [LastNM]                      VARCHAR (50)  NULL,
    [SexCD]                       VARCHAR (10)  NULL,
    [BirthDTS]                    DATE          NULL,
    [DeathDTS]                    DATE          NULL,
    [TIN]                         VARCHAR (50)  NULL,
    [PrimaryCareServicesCNT]      VARCHAR (10)  NULL,
    [EDWLastModifiedDTS]          DATE          NULL,
    [FileNM]                      VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([MSSPAnnualMembershipTINLKey] ASC)
);

