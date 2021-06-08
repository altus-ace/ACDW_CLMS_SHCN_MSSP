CREATE TABLE [lst].[z_List_HospitalProductLines] (
    [VisitType]      VARCHAR (25)   NULL,
    [ProductLine]    VARCHAR (50)   NULL,
    [ServiceLine]    VARCHAR (50)   NULL,
    [SubServiceLine] VARCHAR (50)   NULL,
    [MDCCode]        VARCHAR (255)  NULL,
    [DRGCode]        VARCHAR (255)  NULL,
    [ProcCode]       VARCHAR (1000) NULL,
    [DiagCode]       VARCHAR (1000) NULL,
    [ER_Flag]        INT            NULL,
    [Obv_Flag]       INT            NULL,
    [Surg_Flag]      INT            NULL
);

