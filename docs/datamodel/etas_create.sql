-- Created by Redgate Data Modeler (https://datamodeler.redgate-platform.com)
-- Last modification date: 2026-05-15 07:58:10.408

-- tables
-- Table: app_user
CREATE TABLE app_user (
    id serial  NOT NULL,
    first_name varchar(100)  NOT NULL,
    middle_name varchar(100)  NULL,
    last_name varchar(100)  NOT NULL,
    email varchar(255)  NOT NULL,
    password varchar(255)  NOT NULL,
    user_status varchar(20)  NOT NULL,
    user_role char(1)  NOT NULL,
    CONSTRAINT AK_0 UNIQUE (email) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT app_user_pk PRIMARY KEY (id)
);

-- Table: commission_calculation
CREATE TABLE commission_calculation (
    id serial  NOT NULL,
    commission_rate_id int  NOT NULL,
    calculated_fee numeric(12,2)  NOT NULL,
    vat_amount numeric(12,2)  NOT NULL,
    total_fee numeric(12,2)  NOT NULL,
    calculation_date date  NOT NULL DEFAULT current_date,
    sales_report_id int  NOT NULL,
    CONSTRAINT commission_calculation_pk PRIMARY KEY (id)
);

-- Table: commission_rate
CREATE TABLE commission_rate (
    id serial  NOT NULL,
    seller_id integer  NOT NULL,
    fee_per_transaction numeric(10,4)  NULL,
    fee_percent numeric(5,2)  NULL,
    includes_vat boolean  NOT NULL DEFAULT true,
    valid_from date  NOT NULL,
    valid_to date  NULL,
    product_type_id int  NOT NULL,
    CONSTRAINT commission_rate_pk PRIMARY KEY (id)
);

-- Table: invoice
CREATE TABLE invoice (
    id serial  NOT NULL,
    seller_id integer  NOT NULL,
    period varchar(20)  NOT NULL,
    number varchar(100)  NULL,
    amount numeric(12,2)  NOT NULL,
    issued_on date  NULL,
    calculated_fee numeric(12,2)  NOT NULL,
    notes varchar(2000)  NULL,
    CONSTRAINT AK_4 UNIQUE (seller_id, period) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT invoice_pk PRIMARY KEY (id)
);

-- Table: product_type
CREATE TABLE product_type (
    id serial  NOT NULL,
    product_type_name varchar(100)  NOT NULL,
    CONSTRAINT product_type_pk PRIMARY KEY (id)
);

-- Table: region
CREATE TABLE region (
    id serial  NOT NULL,
    region_name varchar(20)  NOT NULL,
    sequence_number int  NOT NULL,
    CONSTRAINT region_pk PRIMARY KEY (id)
);

-- Table: role
CREATE TABLE role (
    id serial  NOT NULL,
    code varchar(5)  NOT NULL,
    seller_role_name varchar(100)  NOT NULL,
    CONSTRAINT AK_2 UNIQUE (code) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT contact_role_pk PRIMARY KEY (id)
);

-- Table: sales_report
CREATE TABLE sales_report (
    id serial  NOT NULL,
    seller_id int  NOT NULL,
    department_name varchar(255)  NOT NULL,
    department_id varchar(50)  NULL,
    payment_channel varchar(100)  NULL,
    product_type varchar(100)  NOT NULL,
    transaction_count integer  NOT NULL,
    sales_amount numeric(12,2)  NULL,
    fee_sum int  NOT NULL,
    period varchar(20)  NOT NULL,
    region varchar(100)  NULL,
    created_at timestamp  NOT NULL DEFAULT now(),
    CONSTRAINT sales_report_row_pk PRIMARY KEY (id)
);

-- Table: seller
CREATE TABLE seller (
    id serial  NOT NULL,
    company_name varchar(255)  NOT NULL,
    org_id int  NOT NULL,
    contract_start date  NULL,
    contract_end date  NULL,
    notes varchar(2000)  NULL,
    status varchar(10)  NOT NULL,
    created_at timestamp  NOT NULL DEFAULT now(),
    created_by int  NOT NULL,
    CONSTRAINT AK_1 UNIQUE (org_id) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT agent_pk PRIMARY KEY (id)
);

-- Table: seller_contact
CREATE TABLE seller_contact (
    id serial  NOT NULL,
    seller_id integer  NOT NULL,
    first_name varchar(100)  NOT NULL,
    middle_name varchar(100)  NULL,
    last_name varchar(100)  NOT NULL,
    phone varchar(50)  NULL,
    email varchar(255)  NOT NULL,
    CONSTRAINT agent_contact_pk PRIMARY KEY (id)
);

-- Table: seller_region
CREATE TABLE seller_region (
    id serial  NOT NULL,
    seller_id integer  NOT NULL,
    region_id int  NOT NULL,
    sales_point_count integer  NOT NULL DEFAULT 0,
    CONSTRAINT agent_region_pk PRIMARY KEY (id)
);

-- Table: seller_role
CREATE TABLE seller_role (
    id serial  NOT NULL,
    seller_contact_id int  NOT NULL,
    seller_role_id int  NOT NULL,
    CONSTRAINT agent_contact_role_pk PRIMARY KEY (id)
);

-- Table: vat_setting
CREATE TABLE vat_setting (
    id serial  NOT NULL,
    vat_rate numeric(5,2)  NOT NULL,
    updated_at timestamp  NOT NULL DEFAULT now(),
    updated_by varchar(200)  NOT NULL,
    CONSTRAINT vat_setting_pk PRIMARY KEY (id)
);

-- foreign keys
-- Reference: FK_0 (table: seller_contact)
ALTER TABLE seller_contact ADD CONSTRAINT FK_0
    FOREIGN KEY (seller_id)
    REFERENCES seller (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_3 (table: seller_region)
ALTER TABLE seller_region ADD CONSTRAINT FK_3
    FOREIGN KEY (seller_id)
    REFERENCES seller (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_4 (table: commission_rate)
ALTER TABLE commission_rate ADD CONSTRAINT FK_4
    FOREIGN KEY (seller_id)
    REFERENCES seller (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_8 (table: invoice)
ALTER TABLE invoice ADD CONSTRAINT FK_8
    FOREIGN KEY (seller_id)
    REFERENCES seller (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: agent_app_user (table: seller)
ALTER TABLE seller ADD CONSTRAINT agent_app_user
    FOREIGN KEY (created_by)
    REFERENCES app_user (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: agent_region_region (table: seller_region)
ALTER TABLE seller_region ADD CONSTRAINT agent_region_region
    FOREIGN KEY (region_id)
    REFERENCES region (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: agent_role_agent_contact (table: seller_role)
ALTER TABLE seller_role ADD CONSTRAINT agent_role_agent_contact
    FOREIGN KEY (seller_contact_id)
    REFERENCES seller_contact (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: agent_role_role (table: seller_role)
ALTER TABLE seller_role ADD CONSTRAINT agent_role_role
    FOREIGN KEY (seller_role_id)
    REFERENCES role (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: commission_calculation_commission_rate (table: commission_calculation)
ALTER TABLE commission_calculation ADD CONSTRAINT commission_calculation_commission_rate
    FOREIGN KEY (commission_rate_id)
    REFERENCES commission_rate (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: commission_calculation_sales_report (table: commission_calculation)
ALTER TABLE commission_calculation ADD CONSTRAINT commission_calculation_sales_report
    FOREIGN KEY (sales_report_id)
    REFERENCES sales_report (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: commission_rate_product_type (table: commission_rate)
ALTER TABLE commission_rate ADD CONSTRAINT commission_rate_product_type
    FOREIGN KEY (product_type_id)
    REFERENCES product_type (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: sales_report_seller (table: sales_report)
ALTER TABLE sales_report ADD CONSTRAINT sales_report_seller
    FOREIGN KEY (seller_id)
    REFERENCES seller (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

