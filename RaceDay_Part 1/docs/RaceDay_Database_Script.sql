CREATE DATABASE RaceDayDb;

USE RaceDayDb;

-- DROP TABLES

IF OBJECT_ID('Results', 'U') IS NOT NULL
    DROP TABLE Results;

IF OBJECT_ID('Enrolments', 'U') IS NOT NULL
    DROP TABLE Enrolments;

IF OBJECT_ID('Categories', 'U') IS NOT NULL
    DROP TABLE Categories;

IF OBJECT_ID('Events', 'U') IS NOT NULL
    DROP TABLE Events;

IF OBJECT_ID('Users', 'U') IS NOT NULL
    DROP TABLE Users;

IF OBJECT_ID('Roles', 'U') IS NOT NULL
    DROP TABLE Roles;

-- 1. ROLES TABLE

CREATE TABLE Roles( RoleId INT IDENTITY(1,1) PRIMARY KEY,
             RoleName VARCHAR(20) NOT NULL UNIQUE);

-- 2. USERS TABLE

CREATE TABLE Users(UserId INT IDENTITY(1,1) PRIMARY KEY,
                   RoleId INT NOT NULL,Email VARCHAR(150) NOT NULL UNIQUE,
                   PasswordHash VARCHAR(255) NOT NULL,
                   FirstName VARCHAR(100) NOT NULL,
                   LastName VARCHAR(100) NOT NULL,
                   PhoneNumber VARCHAR(20) NULL,
                   CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
                   CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleId) REFERENCES Roles(RoleId));

-- 3. EVENTS TABLE

CREATE TABLE Events(EventId INT IDENTITY(1,1) PRIMARY KEY,OrganiserId INT NOT NULL,
                    EventName VARCHAR(200) NOT NULL,
                    Description VARCHAR(500) NOT NULL,EventDate DATETIME2 NOT NULL,
                    Location VARCHAR(200) NOT NULL,
                    Distance DECIMAL(6,2) NOT NULL,
                    EventType VARCHAR(20) NOT NULL,
                    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(), CONSTRAINT FK_Events_Users
                    FOREIGN KEY (OrganiserId) REFERENCES Users(UserId),CONSTRAINT CK_Events_Distance
                    CHECK (Distance > 0),CONSTRAINT CK_Events_EventType
                    CHECK (EventType IN ('Run', 'Walk', 'Cycle')));

-- 4. CATEGORIES TABLE

CREATE TABLE Categories(CategoryId INT IDENTITY(1,1) PRIMARY KEY,
                        EventId INT NOT NULL,
                        CategoryName VARCHAR(100) NOT NULL,
                        AgeMin INT NULL,
                        AgeMax INT NULL,CONSTRAINT FK_Categories_Events FOREIGN KEY (EventId)
                        REFERENCES Events(EventId),
                       CONSTRAINT CK_Categories_AgeMin
                       CHECK (AgeMin IS NULL OR AgeMin >= 0),
                       CONSTRAINT CK_Categories_AgeMax
                      CHECK (AgeMax IS NULL OR AgeMax >= 0),
                      CONSTRAINT CK_Categories_AgeRange

            CHECK(AgeMin IS NULL
            OR AgeMax IS NULL
            OR AgeMax >= AgeMin));

-- 5. ENROLMENTS TABLE

CREATE TABLE Enrolments (EnrolmentId INT IDENTITY(1,1) PRIMARY KEY,
                         ParticipantId INT NOT NULL,
                         CategoryId INT NOT NULL,
                         EnrolmentDate DATETIME2 NOT NULL DEFAULT GETDATE(),
                         CONSTRAINT FK_Enrolments_Users FOREIGN KEY (ParticipantId)
                         REFERENCES Users(UserId),CONSTRAINT FK_Enrolments_Categories
                         FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryId),
                         CONSTRAINT UQ_Enrolments UNIQUE (ParticipantId, CategoryId));

-- 6. RESULTS TABLE

CREATE TABLE Results(ResultId INT IDENTITY(1,1) PRIMARY KEY, EnrolmentId INT NOT NULL,
                     FinishTime TIME NULL,Position INT NULL,
                     ResultStatus VARCHAR(20) NOT NULL DEFAULT 'Finished',
                     CONSTRAINT FK_Results_Enrolments FOREIGN KEY (EnrolmentId)
                     REFERENCES Enrolments(EnrolmentId),
                     CONSTRAINT UQ_Results_Enrolment UNIQUE (EnrolmentId),
                     CONSTRAINT CK_Results_Position CHECK (Position IS NULL OR Position > 0),

                   CONSTRAINT CK_Results_Status
                   CHECK (ResultStatus IN ('Finished', 'DNF', 'DNS', 'DQ')));

-- INSERT ROLES

INSERT INTO Roles (RoleName) VALUES
                  ('Organiser'),
                  ('Participant');

-- INSERT USERS

INSERT INTO Users(RoleId,Email,PasswordHash,FirstName,LastName,PhoneNumber) VALUES
                 (1,'sipho.dlamini@raceday.co.za','PasswordHash1','Sipho','Dlamini','0821234567'),
                 (1,'anika.vandermerwe@raceday.co.za','PasswordHash2','Anika','Van Der Merwe','0839876543'),
                 (2,'thabo.mokoena@gmail.com','PasswordHash3','Thabo','Mokoena','0711112222'),
                 (2,'sarah.jenkins@gmail.com','PasswordHash4','Sarah','Jenkins','0723334444');

-- INSERT EVENTS

INSERT INTO Events(OrganiserId,EventName,Description,EventDate,Location,Distance,EventType)VALUES
                  (1,'Comrades Marathon 2027','A long-distance road running event between Pietermaritzburg and Durban.','2027-06-13 05:30:00',
                     'Durban, KwaZulu-Natal',89.00,'Run'),
                  (2,'Cape Town Cycle Tour 2027','A cycling event around the Cape Peninsula.','2027-03-14 06:00:00',
                     'Cape Town, Western Cape',109.00,'Cycle'),
                  (1,'Soweto Marathon 2027','A road running event through Soweto.','2027-11-07 05:30:00',
                     'Soweto, Gauteng',42.20,'Run');

-- INSERT CATEGORIES

INSERT INTO Categories(EventId,CategoryName, AgeMin,AgeMax) VALUES
                       (1,'Open',20,39),
                       (1,'Veterans',40,49),
                       (2,'Main Race',18,75),
                       (2,'Short Route',12,80),
                       (3,'Full Marathon',20,70),
                       (3,'Half Marathon',16,75),
                       (3,'10km Community Run',10,85);


-- INSERT ENROLMENTS

INSERT INTO Enrolments(ParticipantId,CategoryId)VALUES
                      (3,1),
                      (3,5),
                      (4,3),
                      (4,6);

-- INSERT RESULTS

INSERT INTO Results(EnrolmentId,FinishTime,Position,ResultStatus)VALUES
                   (1,'06:45:12',412,'Finished'),
                   (3,'03:15:40',105,'Finished');

