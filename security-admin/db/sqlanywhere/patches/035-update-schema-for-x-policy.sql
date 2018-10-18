
-- Licensed to the Apache Software Foundation (ASF) under one or more
-- contributor license agreements.  See the NOTICE file distributed with
-- this work for additional information regarding copyright ownership.
-- The ASF licenses this file to You under the Apache License, Version 2.0
-- (the "License"); you may not use this file except in compliance with
-- the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
GO
create table dbo.x_policy_ref_resource (
	id bigint IDENTITY NOT NULL,
	guid varchar(1024) DEFAULT NULL NULL,
	create_time datetime DEFAULT NULL NULL,
	update_time datetime DEFAULT NULL NULL,
	added_by_id bigint DEFAULT NULL NULL,
	upd_by_id bigint DEFAULT NULL NULL,
	policy_id bigint NOT NULL,
	resource_def_id bigint NOT NULL,
	resource_name varchar(4000) DEFAULT NULL NULL,
	CONSTRAINT x_policy_ref_res_PK_id PRIMARY KEY CLUSTERED(id),
	CONSTRAINT x_p_ref_res_UK_polId_resDefId UNIQUE NONCLUSTERED (policy_id, resource_def_id)
)
GO

create table dbo.x_policy_ref_access_type (
        id bigint IDENTITY NOT NULL,
        guid varchar(1024) DEFAULT NULL NULL,
        create_time datetime DEFAULT NULL NULL,
        update_time datetime DEFAULT NULL NULL,
        added_by_id bigint DEFAULT NULL NULL,
        upd_by_id bigint DEFAULT NULL NULL,
        policy_id bigint NOT NULL,
        access_def_id bigint NOT NULL,
        access_type_name varchar(4000) DEFAULT NULL NULL,
        CONSTRAINT x_policy_ref_acc_PK_id PRIMARY KEY CLUSTERED(id),
		CONSTRAINT x_p_ref_acc_UK_polId_accDefId UNIQUE NONCLUSTERED (policy_id, access_def_id)
)
GO

create table dbo.x_policy_ref_condition (
        id bigint IDENTITY NOT NULL,
        guid varchar(1024) DEFAULT NULL NULL,
        create_time datetime DEFAULT NULL NULL,
        update_time datetime DEFAULT NULL NULL,
        added_by_id bigint DEFAULT NULL NULL,
        upd_by_id bigint DEFAULT NULL NULL,
        policy_id bigint NOT NULL,
        condition_def_id bigint NOT NULL,
        condition_name varchar(4000) DEFAULT NULL NULL,
        CONSTRAINT x_policy_ref_cond_PK_id PRIMARY KEY CLUSTERED(id),
		CONSTRAINT x_p_ref_cond_UK_polId_cDefId UNIQUE NONCLUSTERED (policy_id, condition_def_id)
)
GO

create table dbo.x_policy_ref_datamask_type (
        id bigint IDENTITY NOT NULL,
        guid varchar(1024) DEFAULT NULL NULL,
        create_time datetime DEFAULT NULL NULL,
        update_time datetime DEFAULT NULL NULL,
        added_by_id bigint DEFAULT NULL NULL,
        upd_by_id bigint DEFAULT NULL NULL,
        policy_id bigint NOT NULL,
        datamask_def_id bigint NOT NULL,
        datamask_type_name varchar(4000) DEFAULT NULL NULL,
        CONSTRAINT x_policy_ref_dmk_PK_id PRIMARY KEY CLUSTERED(id),
		CONSTRAINT x_p_ref_dmk_UK_polId_dDefId UNIQUE NONCLUSTERED (policy_id, datamask_def_id)
)
GO

create table dbo.x_policy_ref_user (
        id bigint IDENTITY NOT NULL,
        guid varchar(1024) DEFAULT NULL NULL,
        create_time datetime DEFAULT NULL NULL,
        update_time datetime DEFAULT NULL NULL,
        added_by_id bigint DEFAULT NULL NULL,
        upd_by_id bigint DEFAULT NULL NULL,
        policy_id bigint NOT NULL,
        user_id bigint NOT NULL,
        user_name varchar(4000) DEFAULT NULL NULL,
        CONSTRAINT x_policy_ref_user_PK_id PRIMARY KEY CLUSTERED(id),
		CONSTRAINT x_p_ref_usr_UK_polId_userId UNIQUE NONCLUSTERED (policy_id, user_id)
)
GO

create table dbo.x_policy_ref_group (
        id bigint IDENTITY NOT NULL,
        guid varchar(1024) DEFAULT NULL NULL,
        create_time datetime DEFAULT NULL NULL,
        update_time datetime DEFAULT NULL NULL,
        added_by_id bigint DEFAULT NULL NULL,
        upd_by_id bigint DEFAULT NULL NULL,
        policy_id bigint NOT NULL,
        group_id bigint NOT NULL,
        group_name varchar(4000) DEFAULT NULL NULL,
        CONSTRAINT x_policy_ref_group_PK_id PRIMARY KEY CLUSTERED(id),
		CONSTRAINT x_p_ref_grp_UK_polId_grpId UNIQUE NONCLUSTERED (policy_id, group_id)
)
GO

IF NOT EXISTS(select * from SYS.SYSCOLUMNS where tname = 'x_policy' and cname='policy_text') THEN
	ALTER TABLE dbo.x_policy ADD (policy_text text DEFAULT NULL NULL);
END IF;
GO

IF EXISTS (
    SELECT  1
    FROM    sysobjects
    WHERE   NAME = 'removeForeignKeyConstraint'
    AND     TYPE = 'P'
)
BEGIN
    drop procedure dbo.removeForeignKeyConstraint
END
GO

CREATE PROCEDURE dbo.removeForeignKeyConstraint (IN table_name varchar(100))
AS
BEGIN
        DECLARE @stmt VARCHAR(300)
        DECLARE cur CURSOR FOR
                select 'alter table dbo.' + table_name + ' drop constraint ' + role
                from SYS.SYSFOREIGNKEYS
                where foreign_creator ='dbo' and foreign_tname = table_name

        OPEN cur WITH HOLD
                fetch cur into @stmt
                if (@@sqlstatus = 2)
                BEGIN
                        close cur
                        DEALLOCATE CURSOR cur
                END

                WHILE (@@sqlstatus = 0)
                BEGIN

                        execute(@stmt)
                        fetch cur into @stmt
                END
        close cur
        DEALLOCATE CURSOR cur

END
GO

call dbo.removeForeignKeyConstraint('x_policy_item')
GO

call dbo.removeForeignKeyConstraint('x_policy_item_access')
GO

call dbo.removeForeignKeyConstraint('x_policy_item_condition')
GO

call dbo.removeForeignKeyConstraint('x_policy_item_datamask')
GO

call dbo.removeForeignKeyConstraint('x_policy_item_group_perm')
GO

call dbo.removeForeignKeyConstraint('x_policy_item_user_perm')
GO

call dbo.removeForeignKeyConstraint('x_policy_item_rowfilter')
GO

call dbo.removeForeignKeyConstraint('x_policy_resource')
GO

call dbo.removeForeignKeyConstraint('x_policy_resource_map')
GO


exit
