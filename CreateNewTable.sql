CREATE TABLE [dbo].[Education] (
    [EducationID] INT            IDENTITY (1, 1) NOT NULL,
    [UserID]      INT            NULL,
    [SchoolName]  NVARCHAR (255) NOT NULL,
    [Degree]      NVARCHAR (255) NOT NULL,
    [StartYear]   INT            NULL,
    [EndYear]     NVARCHAR (50)  NULL,
    [City]        NVARCHAR (255) NULL,
    [Description] TEXT           NULL,
    PRIMARY KEY CLUSTERED ([EducationID] ASC),
    CHECK ([StartYear]>=(1900)),
    CHECK ([EndYear]>=(1900))
);

CREATE TABLE [dbo].[Experience] (
    [ExperienceID]   INT            IDENTITY (1, 1) NOT NULL,
    [UserID]         INT            NULL,
    [CompanyName]    NVARCHAR (255) NOT NULL,
    [JobTitle]       NVARCHAR (255) NOT NULL,
    [EmploymentType] NVARCHAR (50)  NULL,
    [StartMonth]     INT            NULL,
    [StartYear]      INT            NULL,
    [EndMonth]       INT            NULL,
    [EndYear]        NVARCHAR (50)  NULL,
    [Location]       NVARCHAR (255) NULL,
    [Description]    TEXT           NULL,
    PRIMARY KEY CLUSTERED ([ExperienceID] ASC),
    CHECK ([EmploymentType]='Freelance' OR [EmploymentType]='Internship' OR [EmploymentType]='Contract' OR [EmploymentType]='Part-time' OR [EmploymentType]='Full-time'),
    CHECK ([StartMonth]>=(1) AND [StartMonth]<=(12)),
    CHECK ([StartYear]>=(1900)),
    CHECK ([EndMonth]>=(1) AND [EndMonth]<=(12)),
    CHECK ([EndYear]>=(1900))
);

CREATE TABLE [dbo].[Links] (
    [LinkID] INT            IDENTITY (1, 1) NOT NULL,
    [UserID] INT            NULL,
    [Label]  NVARCHAR (255) NOT NULL,
    [URL]    NVARCHAR (500) NOT NULL,
    PRIMARY KEY CLUSTERED ([LinkID] ASC)
);

CREATE TABLE [dbo].[Skills] (
    [SkillID]    INT             IDENTITY (1, 1) NOT NULL,
    [UserID]     INT             NULL,
    [SkillsText] NVARCHAR (1000) NOT NULL,
    PRIMARY KEY CLUSTERED ([SkillID] ASC)
);

CREATE TABLE [dbo].[UserDetail] (
    [DetailId]    INT           IDENTITY (1, 1) NOT NULL,
    [UserId]      INT           NOT NULL,
    [FullName]    VARCHAR (100) NOT NULL,
    [Email]       VARCHAR (50)  NOT NULL,
    [PhoneNumber] VARCHAR (20)  NOT NULL,
    [Summary]     TEXT          NOT NULL,
    [Country]     VARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([DetailId] ASC),
    FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId])
);

CREATE TABLE [dbo].[Users] (
    [UserId]    INT           IDENTITY (1, 1) NOT NULL,
    [firstname] VARCHAR (50)  NULL,
    [lastname]  VARCHAR (50)  NULL,
    [email]     VARCHAR (50)  NULL,
    [password]  VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([UserId] ASC)
);

