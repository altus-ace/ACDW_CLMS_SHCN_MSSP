﻿CREATE TABLE [adi].[Steward_MSSPMembership_2021] (
    [MSSPMembershipKey]           INT           IDENTITY (1, 1) NOT NULL,
    [AlignmentType]               VARCHAR (50)  NULL,
    [AlignmentNPI]                VARCHAR (20)  NULL,
    [AlignmentPCPName]            VARCHAR (50)  NULL,
    [AlignmentChapter]            VARCHAR (50)  NULL,
    [AlignmentRegion]             VARCHAR (50)  NULL,
    [SMGOrAffiliate]              VARCHAR (50)  NULL,
    [PersistingBene]              VARCHAR (50)  NULL,
    [CurrentMBI]                  VARCHAR (50)  NULL,
    [YearNBR]                     VARCHAR (50)  NULL,
    [MedicareBeneficiaryID]       VARCHAR (50)  NULL,
    [HealthInsuranceClaimNBR]     VARCHAR (50)  NULL,
    [FirstNM]                     VARCHAR (50)  NULL,
    [LastNM]                      VARCHAR (50)  NULL,
    [SexCD]                       VARCHAR (10)  NULL,
    [BirthDTS]                    DATE          NULL,
    [DeathDTS]                    DATE          NULL,
    [CountyNM]                    VARCHAR (50)  NULL,
    [HomeStateCD]                 VARCHAR (50)  NULL,
    [CountyNBR]                   VARCHAR (50)  NULL,
    [VoluntaryAlignmentFLG]       VARCHAR (10)  NULL,
    [VoluntaryAlignmentTIN]       VARCHAR (20)  NULL,
    [VoluntaryAlignmentNPI]       VARCHAR (20)  NULL,
    [ClaimsBasedAssignmentFLG]    VARCHAR (10)  NULL,
    [ClaimBasedAssignmentStepFLG] VARCHAR (10)  NULL,
    [SrcFileName]                 VARCHAR (100) NULL,
    [CreateDate]                  DATETIME      DEFAULT (sysdatetime()) NULL,
    [CreateBy]                    VARCHAR (100) DEFAULT (suser_sname()) NULL,
    [OriginalFileName]            VARCHAR (100) NULL,
    [LastUpdatedBy]               VARCHAR (100) DEFAULT (suser_sname()) NULL,
    [LastUpdatedDate]             DATETIME      DEFAULT (sysdatetime()) NULL,
    [DataDate]                    DATE          NULL,
    [Status]                      CHAR (1)      CONSTRAINT [DF_SCHNStatus] DEFAULT ((0)) NULL,
    PRIMARY KEY CLUSTERED ([MSSPMembershipKey] ASC)
);

