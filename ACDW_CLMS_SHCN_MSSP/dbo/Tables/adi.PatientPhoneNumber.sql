CREATE TABLE [dbo].[adi.PatientPhoneNumber] (
    [MSSPPhoneKey]          INT          IDENTITY (1, 1) NOT NULL,
    [PatientPolicyIDNumber] VARCHAR (50) NULL,
    [PatientFirstName]      VARCHAR (50) NULL,
    [PatientLastName]       VARCHAR (50) NULL,
    [PatientHomePhone]      VARCHAR (15) NULL,
    [PatientMobileNumber]   VARCHAR (15) NULL
);

