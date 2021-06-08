CREATE TABLE [dbo].[Excluded the Blues] (
    [Account_Name__Account_Name]            NVARCHAR (100) NOT NULL,
    [Account_Type]                          NVARCHAR (50)  NOT NULL,
    [Provider_NPI_b__c_]                    INT            NOT NULL,
    [Last_Name_b_]                          NVARCHAR (50)  NOT NULL,
    [First_Name_b_]                         NVARCHAR (50)  NOT NULL,
    [Health_Plans]                          NVARCHAR (50)  NOT NULL,
    [Effective_Date]                        DATETIME2 (7)  NOT NULL,
    [Term_Date]                             NVARCHAR (50)  NULL,
    [Provider_NPI_from_the_membership_file] INT            NULL,
    [In_Mssp_Roster]                        NVARCHAR (50)  NOT NULL
);

