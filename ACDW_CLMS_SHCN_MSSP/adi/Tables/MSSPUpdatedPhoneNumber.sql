CREATE TABLE [adi].[MSSPUpdatedPhoneNumber] (
    [MSSPUpdatedPhoneNumberKey] INT           IDENTITY (1, 1) NOT NULL,
    [SrcFileName]               VARCHAR (100) NOT NULL,
    [CreateDate]                DATETIME      DEFAULT (sysdatetime()) NOT NULL,
    [CreateBy]                  VARCHAR (100) DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]           DATETIME      DEFAULT (sysdatetime()) NOT NULL,
    [LastUpdatedBy]             VARCHAR (100) DEFAULT (suser_sname()) NOT NULL,
    [DataDate]                  DATE          NOT NULL,
    [MedicareBeneficiaryID]     VARCHAR (50)  NULL,
    [FirstName]                 VARCHAR (50)  NULL,
    [LastName]                  VARCHAR (50)  NULL,
    [BirthDTS]                  DATE          NULL,
    [PhoneNBR]                  VARCHAR (12)  NULL,
    [Status]                    CHAR (1)      NULL,
    PRIMARY KEY CLUSTERED ([MSSPUpdatedPhoneNumberKey] ASC)
);

