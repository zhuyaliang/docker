/*
 * KingbaseES plugin
 * Bacth file for KingbaseES, it includes: 
 * 1 sys_dump and JDUMP
 * 2 Agent Server
 * 3 DTS  
 * Portions Copyright (c) 2005-2008, Basesoft Co. Ltd.
 *
 * IDENTIFICATION
 *    $Header: $
 */


SET log_min_messages TO 'error';


/*
 * KingbaseES Dump plugin. All sys_dump and JDUMP are saved in sys_dump schema.
 */
CREATE SCHEMA sys_dump AUTHORIZATION "@KINGBASE_SUPERUSERNAME@";

CREATE SEQUENCE sys_dump.sys_backupinfo_id;

CREATE TABLE sys_dump.sys_backupinfo(
	bk_id		INT DEFAULT nextval('SYS_DUMP.SYS_BACKUPINFO_ID') NOT NULL,
	user_name	NAME NOT NULL,
	ip_address	TEXT NOT NULL,
	db_name    	NAME NOT NULL,
	bk_type  	"CHAR" NOT NULL,
	bk_object  	TEXT NOT NULL,
 	bk_path    	TEXT NULL,
	bk_file    	TEXT NOT NULL,
	start_time	TIMESTAMP NOT NULL,
	end_time	TIMESTAMP NOT NULL,
	remark		TEXT);

CREATE UNIQUE INDEX sys_backupinfo_id_index ON sys_dump.sys_backupinfo(bk_id);

GRANT USAGE ON SCHEMA sys_dump TO PUBLIC;
GRANT ALL ON sys_dump.sys_backupinfo_id TO PUBLIC;
GRANT ALL ON sys_dump.sys_backupinfo TO PUBLIC;


/*
 * KingbaseES Agent Server plugin. All agent's tables are saved in sys_agent schema.
 */
CREATE SCHEMA sys_agent AUTHORIZATION "@KINGBASE_SUPERUSERNAME@";

CREATE SEQUENCE sys_agent.sys_operators_sequence
	INCREMENT  1
	MINVALUE 1
	NO MAXVALUE
	START 1
	CYCLE;
	  
CREATE TABLE sys_agent.sys_operators(
	id 		INT NOT NULL DEFAULT NEXTVAL('sys_agent.sys_operators_sequence'),
	name 	VARCHAR(100) NOT NULL UNIQUE,
	enabled	BOOLEAN NOT NULL,
	create_time TIMESTAMPTZ DEFAULT NOW(),
	modify_time TIMESTAMPTZ,
	lan_email_address   	VARCHAR(100),
	internet_email_address 	VARCHAR(100),
	lan_email_time   		TIMESTAMPTZ,
	internet_email_time   	TIMESTAMPTZ,
	netsend_address   		VARCHAR(100),
	last_netsend_time   	TIMESTAMPTZ,
	PRIMARY KEY(id)	
	);

CREATE SEQUENCE sys_agent.sys_alert_sequence
	INCREMENT  1
	MINVALUE 1
	NO MAXVALUE 
	START 1
	CYCLE;
    
CREATE TABLE sys_agent.sys_alerts(
	id   	INT DEFAULT nextval('sys_agent.sys_alert_sequence'),
	name	VARCHAR(100) NOT NULL UNIQUE,
	describe_info VARCHAR(1000),
	enabled   	BOOLEAN NOT NULL,
	event_id   	INT NULL,
	create_time	TIMESTAMPTZ DEFAULT NOW(),
	modify_time	TIMESTAMPTZ,
	last_occurrence_time	TIMESTAMPTZ,
	occurrence_count	INT DEFAULT 0,
	count_reset_time	TIMESTAMPTZ,
	PRIMARY KEY(id)
	);

CREATE SEQUENCE sys_agent.sys_jobs_sequence
	INCREMENT  1
	MINVALUE 1
	NO MAXVALUE	
	START 1
	CYCLE;
    
CREATE TABLE sys_agent.sys_jobs(
	id   	INT DEFAULT nextval('sys_agent.sys_jobs_sequence'),
	name   	VARCHAR(100) NOT NULL UNIQUE,
	describe_info VARCHAR(1000),
	type  	INT NOT NULL,
	enabled BOOLEAN NOT NULL,
	create_time TIMESTAMPTZ DEFAULT NOW(),
	modify_time	TIMESTAMPTZ,
	PRIMARY KEY(id)
	);

CREATE SEQUENCE sys_agent.sys_jobsteps_sequence
	INCREMENT  1
	MINVALUE 1
	NO MAXVALUE
	START 1
	CYCLE;
    
CREATE TABLE sys_agent.sys_jobsteps(
	id 			INT DEFAULT NEXTVAL('sys_agent.sys_jobsteps_sequence'),
	name		VARCHAR(100) NOT NULL,
	describe_info VARCHAR(1000) NULL,
	"LEVEL"  		INT NOT NULL,
	parent_id   INT NOT NULL,
	c_or_m_mark	INT NOT NULL,
	command_or_message	VARCHAR(8000) NULL,
	run_condition  	INT NOT NULL,
	database_name   VARCHAR(100) NULL,
	database_port   VARCHAR(10) NULL,
	database_user_name	VARCHAR(100) NULL,
	database_password   VARCHAR(100) NULL,
	retry_attempts   	INT NULL,
	retry_interval   	INT NULL,
	last_run_time   	TIMESTAMPTZ
	);

CREATE SEQUENCE sys_agent.sys_jobschedules_sequence
	INCREMENT 1
	MINVALUE 1
	NO MAXVALUE 
	START 1
	CYCLE;
    
CREATE TABLE sys_agent.sys_jobschedules(
	id   	INT DEFAULT NEXTVAL('sys_agent.sys_jobschedules_sequence'),	
	name   	VARCHAR(100) NOT NULL,
	job_id  INT NOT NULL,
	freq_type  	INT NOT NULL,
	alert_id	INT,
	one_start_time 	TIMESTAMPTZ,
	cycle_type  	INT,
	freq_day_interval	INT,
	freq_week_interval	INT,
	freq_month_interval	INT,
	freq_day_type  		INT,
	freq_day_start_time	TIME,
	freq_day_cycle_step INT,
	freq_day_cycle_unit INT,
	active_start_time	DATE,
	is_end  			BOOLEAN,
	active_end_time		DATE,
	PRIMARY KEY(id)
	);

CREATE TABLE sys_agent.sys_sub_jobschedules(
	job_id	INT NOT NULL,	
	data  	INT NOT NULL,	
	FOREIGN KEY(job_id ) REFERENCES sys_agent.sys_jobs(id)	
	);

CREATE TABLE sys_agent.sys_jobinform(
	job_id   INT NOT NULL,
	is_mail  BOOLEAN NOT NULL,
	mail_type  INT NULL,
	mail_operator_id	INT NULL,
	mail_condition  	INT NULL,
	is_message  		BOOLEAN NOT NULL,
	message_operator_id INT NULL,
	message_condition  	VARCHAR(100) NULL,
	is_beep 		BOOLEAN NULL,
	beep_count 		INT NULL,
	beep_condition 	INT NULL,
	FOREIGN KEY(job_id ) REFERENCES sys_agent.sys_jobs(id)
	);

CREATE TABLE sys_agent.sys_mail_server(
	mail_type  		INT NOT NULL,
	pop3_address	VARCHAR(100),
	pop3_port  		VARCHAR(10),
	smtp_address 	VARCHAR(100),
	smtp_port  		VARCHAR(10)
	);


/*
 * KingbaseES DTS plugin. All DTS tasks and settings are saved in sys_dts schema.
 */
CREATE SCHEMA sys_dts AUTHORIZATION "@KINGBASE_SUPERUSERNAME@";

CREATE SEQUENCE sys_dts.sys_task_sequence INCREMENT 1
    MINVALUE 0 NO MAXVALUE
    START 0 CYCLE;

CREATE TABLE sys_dts.sys_task (
    task_id INT NOT NULL DEFAULT NEXTVAL('sys_dts.sys_task_sequence'),
    task_name VARCHAR(80) UNIQUE,
    task_desc VARCHAR(300),
    time_create TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    time_modify TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    task_user VARCHAR(100), -- reserved.
    task_pass VARCHAR(100), -- reserved.
    PRIMARY KEY (task_id)
);

CREATE SEQUENCE sys_dts.sys_database_sequence INCREMENT 1
    MINVALUE 0 NO MAXVALUE
    START 0 CYCLE;

CREATE TABLE sys_dts.sys_database (
    db_id INT NOT NULL DEFAULT NEXTVAL('sys_dts.sys_database_sequence'),
    db_alias VARCHAR (100),
    db_name VARCHAR (100),
    db_type INT,
    server_ip VARCHAR(100) NOT NULL,
    server_port INT NOT NULL,
    db_user VARCHAR(100) NOT NULL,
    db_pass VARCHAR(100) NOT NULL,
    source_or_dest BOOLEAN NOT NULL,
    task_id INT NOT NULL,
    PRIMARY KEY (db_id),
    FOREIGN KEY (task_id) REFERENCES sys_dts.sys_task(task_id) ON DELETE CASCADE
);

CREATE SEQUENCE sys_dts.sys_schema_sequence INCREMENT 1
    MINVALUE 0 NO MAXVALUE
    START 0 CYCLE;

CREATE TABLE sys_dts.sys_schema (
    schema_id INT NOT NULL DEFAULT NEXTVAL('sys_dts.sys_schema_sequence'),
    schema_name VARCHAR (300),
    schema_type TINYINT,
    database_id INT NOT NULL,
    PRIMARY key (schema_id),
    FOREIGN KEY (database_id) REFERENCES sys_dts.sys_database(db_id) ON DELETE CASCADE
);

CREATE SEQUENCE sys_dts.sys_table_sequence INCREMENT 1
   MINVALUE 0 NO MAXVALUE
   START 0 CYCLE;

CREATE TABLE sys_dts.sys_table (
    table_id INT NOT NULL DEFAULT NEXTVAL('sys_dts.sys_table_sequence'),
    table_name VARCHAR (200),
    schema_id INT,
    src_id INT,
    transfer_type INT,
    PRIMARY key (table_id),
    FOREIGN KEY (schema_id) REFERENCES sys_dts.sys_schema(schema_id) ON DELETE CASCADE
);

CREATE SEQUENCE sys_dts.sys_column_sequence INCREMENT 1
    MINVALUE 0 NO MAXVALUE
    START 0 CYCLE;

CREATE TABLE sys_dts.SYS_COLUMN (
    column_id BIGINT NOT NULL DEFAULT NEXTVAL('sys_dts.sys_column_sequence'),
    column_name VARCHAR (200),
    ordinal_position INTEGER,
    if_import BOOLEAN,
    type_name VARCHAR(100), -- SQL type name
    type_id SMALLINT,       -- java.sql.type
    column_size INTEGER,
    key_order INTEGER,
    primary_key BOOLEAN,
    decimal_digits INTEGER,
    column_def TEXT,       -- default value
    is_null BOOLEAN,
    table_id INTEGER,
    PRIMARY key (column_id),
    FOREIGN KEY (table_id) REFERENCES sys_dts.sys_table(table_id) ON DELETE CASCADE
);

CREATE SEQUENCE sys_dts.sys_setting_sequence INCREMENT 1
    MINVALUE 0 NO MAXVALUE
    START 0 CYCLE;

CREATE TABLE sys_dts.sys_setting (
    setting_id INT NOT NULL DEFAULT NEXTVAL('sys_dts.SYS_SETTING_SEQUENCE'),
    batch_commit_number INT,
    connection_number INTEGER,
    if_log BOOLEAN DEFAULT TRUE,
    if_foreignkey BOOLEAN DEFAULT TRUE,
    if_default BOOLEAN DEFAULT TRUE,
    if_check BOOLEAN DEFAULT TRUE,
    if_notnull BOOLEAN DEFAULT TRUE,
    if_unique BOOLEAN DEFAULT TRUE,
    if_view BOOLEAN DEFAULT TRUE,
    if_index BOOLEAN DEFAULT FALSE,
    if_trigger BOOLEAN DEFAULT FALSE,
    if_procedure BOOLEAN DEFAULT FALSE,
    upper_table_name TINYINT,
    upper_column_name TINYINT,
    if_bulk_load TINYINT,
    transfer_type TINYINT,
    if_match_again BOOLEAN DEFAULT TRUE, -- reserved
                                         -- re-map data types of source/dest again?
    task_id INT ,
    PRIMARY key (setting_id),
    FOREIGN KEY (task_id) REFERENCES sys_dts.sys_task(task_id) ON DELETE CASCADE
);
