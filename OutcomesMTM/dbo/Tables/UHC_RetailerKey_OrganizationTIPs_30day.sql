﻿CREATE TABLE [dbo].[UHC_RetailerKey_OrganizationTIPs_30day] (
    [File Delivery Date]                                                           DATE           NULL,
    [Rank]                                                                         NVARCHAR (10)  NULL,
    [Organization Name]                                                            NVARCHAR (200) NULL,
    [Total Net-Effective Rate]                                                     NVARCHAR (10)  NULL,
    [Needs Refill NER]                                                             DECIMAL (5, 2) NULL,
    [Needs 90 Day Fill NER]                                                        DECIMAL (5, 2) NULL,
    [Needs Drug Therapy - Statin - Diabetes NER]                                   DECIMAL (5, 2) NULL,
    [Needs Drug Therapy - Statin - CVD NER]                                        DECIMAL (5, 2) NULL,
    [Suboptimal Drug - Low-Intensity Statin - CVD NER]                             DECIMAL (5, 2) NULL,
    [Needs Medication Synchronization NER]                                         DECIMAL (5, 2) NULL,
    [Adherence Monitoring NER]                                                     DECIMAL (5, 2) NULL,
    [Needs Refill]                                                                 NVARCHAR (255) NULL,
    [Needs Refill Opportunities]                                                   DECIMAL (18)   NULL,
    [Needs Refill opportunities w/ Aging Criteria]                                 DECIMAL (18)   NULL,
    [Needs Refill Completed]                                                       DECIMAL (18)   NULL,
    [Needs Refill Success]                                                         DECIMAL (18)   NULL,
    [Needs Refill Validated]                                                       DECIMAL (18)   NULL,
    [Needs Refill Count of Active TIPs Opportunities]                              DECIMAL (18)   NULL,
    [Needs Refill Completion %]                                                    DECIMAL (5, 2) NULL,
    [Needs Refill Success %]                                                       DECIMAL (5, 2) NULL,
    [Needs Refill Validation Rate %]                                               DECIMAL (5, 2) NULL,
    [Needs 90 Day Fill]                                                            NVARCHAR (255) NULL,
    [Needs 90 Day Fill Opportunities]                                              DECIMAL (18)   NULL,
    [Needs 90 Day Fill Opportunities w/ Aging Criteria]                            DECIMAL (18)   NULL,
    [Needs 90 Day Fill Completed]                                                  DECIMAL (18)   NULL,
    [Needs 90 Day Fill Success]                                                    DECIMAL (18)   NULL,
    [Needs 90 Day Fill Validated]                                                  DECIMAL (18)   NULL,
    [Needs 90 Day Fill Active TIPs opportunities]                                  DECIMAL (18)   NULL,
    [Needs 90 Day Fill Completion %]                                               DECIMAL (5, 2) NULL,
    [Needs 90 Day Fill Success %]                                                  DECIMAL (5, 2) NULL,
    [Needs 90 Day Fill Validation Rate %]                                          DECIMAL (5, 2) NULL,
    [Needs Drug Therapy - Statin - Diabetes]                                       NVARCHAR (255) NULL,
    [Needs Drug Therapy - Statin - Diabetes Opportunities]                         DECIMAL (18)   NULL,
    [Needs Drug Therapy - Statin - Diabetes Opportunities w/ Aging Criteria]       DECIMAL (18)   NULL,
    [Needs Drug Therapy - Statin - Diabetes Completed]                             DECIMAL (18)   NULL,
    [Needs Drug Therapy - Statin - Diabetes Success]                               DECIMAL (18)   NULL,
    [Needs Drug Therapy - Statin - Diabetes Validated]                             DECIMAL (18)   NULL,
    [Needs Drug Therapy - Statin - Diabetes Active TIPs Opportunities]             DECIMAL (18)   NULL,
    [Needs Drug Therapy - Statin - Diabetes Completion %]                          DECIMAL (5, 2) NULL,
    [Needs Drug Therapy - Statin - Diabetes Success %]                             DECIMAL (5, 2) NULL,
    [Needs Drug Therapy - Statin - Diabetes Validation Rate %]                     DECIMAL (5, 2) NULL,
    [Needs Drug Therapy - Statin - CVD]                                            NVARCHAR (255) NULL,
    [Needs Drug Therapy - Statin - CVD Opportunities]                              DECIMAL (18)   NULL,
    [Needs Drug Therapy - Statin - CVD Opportunities w/ Aging Criteria]            DECIMAL (18)   NULL,
    [Needs Drug Therapy - Statin - CVD Completed]                                  DECIMAL (18)   NULL,
    [Needs Drug Therapy - Statin - CVD Success]                                    DECIMAL (18)   NULL,
    [Needs Drug Therapy - Statin - CVD Validated]                                  DECIMAL (18)   NULL,
    [Needs Drug Therapy - Statin - CVD Active TIPs Opportunities]                  DECIMAL (18)   NULL,
    [Needs Drug Therapy - Statin - CVD Completion %]                               DECIMAL (5, 2) NULL,
    [Needs Drug Therapy - Statin - CVD Success %]                                  DECIMAL (5, 2) NULL,
    [Needs Drug Therapy - Statin - CVD Validation Rate %]                          DECIMAL (5, 2) NULL,
    [Suboptimal Drug - Low-Intensity Statin - CVD]                                 NVARCHAR (255) NULL,
    [Suboptimal Drug - Low-Intensity Statin - CVD Opportunities]                   DECIMAL (18)   NULL,
    [Suboptimal Drug - Low-Intensity Statin - CVD Opportunities w/ Aging Criteria] DECIMAL (18)   NULL,
    [Suboptimal Drug - Low-Intensity Statin - CVD Completed]                       DECIMAL (18)   NULL,
    [Suboptimal Drug - Low-Intensity Statin - CVD Success]                         DECIMAL (18)   NULL,
    [Suboptimal Drug - Low-Intensity Statin - CVD Validated]                       DECIMAL (18)   NULL,
    [Suboptimal Drug - Low-Intensity Statin - CVD Active TIPs Opportunities]       DECIMAL (18)   NULL,
    [Suboptimal Drug - Low-Intensity Statin - CVD Completion %]                    DECIMAL (5, 2) NULL,
    [Suboptimal Drug - Low-Intensity Statin - CVD Success %]                       DECIMAL (5, 2) NULL,
    [Suboptimal Drug - Low-Intensity Statin - CVD Validation Rate %]               DECIMAL (5, 2) NULL,
    [Needs Medication Synchronization]                                             NVARCHAR (255) NULL,
    [Needs Medication Synchronization Opportunities]                               DECIMAL (18)   NULL,
    [Needs Medication Synchronization Opportunities w/ Aging Criteria]             DECIMAL (18)   NULL,
    [Needs Medication Synchronization Completed]                                   DECIMAL (18)   NULL,
    [Needs Medication Synchronization Success]                                     DECIMAL (18)   NULL,
    [Needs Medication Synchronization Validated]                                   DECIMAL (18)   NULL,
    [Needs Medication Synchronization Active TIPs Opportunities]                   DECIMAL (18)   NULL,
    [Needs Medication Synchronization Completion %]                                DECIMAL (5, 2) NULL,
    [Needs Medication Synchronization Success %]                                   DECIMAL (5, 2) NULL,
    [Needs Medication Synchronization Validation Rate %]                           DECIMAL (5, 2) NULL,
    [Adherence Monitoring]                                                         NVARCHAR (255) NULL,
    [Adherence Monitoring Opportunities]                                           DECIMAL (18)   NULL,
    [Adherence Monitoring Opportunities w/ Aging Criteria]                         DECIMAL (18)   NULL,
    [Adherence Monitoring Completed]                                               DECIMAL (18)   NULL,
    [Adherence Monitoring Success]                                                 DECIMAL (18)   NULL,
    [Adherence Monitoring Validated]                                               DECIMAL (18)   NULL,
    [Adherence Monitoring Active TIPs Opportunities]                               DECIMAL (18)   NULL,
    [Adherence Monitoring Completion %]                                            DECIMAL (5, 2) NULL,
    [Adherence Monitoring Success %]                                               DECIMAL (5, 2) NULL,
    [Adherence Monitoring Validation Rate %]                                       DECIMAL (5, 2) NULL
);

