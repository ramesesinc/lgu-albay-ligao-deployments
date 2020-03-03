
CREATE TABLE [dbo].[account_incometarget] (
[objid] varchar(50) NOT NULL ,
[itemid] varchar(50) NOT NULL ,
[year] int NOT NULL ,
[target] decimal(16,2) NOT NULL ,
CONSTRAINT [pk_account_incometarget] PRIMARY KEY ([objid])
)
GO
CREATE INDEX [ix_itemid] ON [dbo].[account_incometarget] ([itemid] ASC) 
GO
CREATE INDEX [ix_year] ON [dbo].[account_incometarget] ([year] ASC) 
GO
alter table account_incometarget add CONSTRAINT [fk_account_incometarget_itemid] 
	FOREIGN KEY ([itemid]) REFERENCES [dbo].[account] ([objid]) 
go 


alter table account_maingroup alter column [title] varchar(255) NOT NULL
go 
alter table account_maingroup alter column [version] int NOT NULL
go 


drop index ix_name on af_allocation
go 
alter table af_allocation alter column [name] varchar(100) NOT NULL
go 
create index ix_name on af_allocation (name) 
go 


alter table af_control alter column [fund_objid] varchar(100) NULL 
go 
alter table af_control add constraint fk_af_control_fund_objid 
	foreign key (fund_objid) references fund (objid) 
go 


drop index ix_state on afrequest 
go 
alter table afrequest alter column [state] varchar(25) NOT NULL 
go 
create index ix_state on afrequest (state) 
go 
alter table afrequest add 
	[dtapproved] datetime NULL ,
	[approvedby_objid] varchar(50) NULL ,
	[approvedby_name] varchar(160) NULL 
go 


alter table afunit alter column [interval] int NULL
go 
alter table afunit drop constraint DF__afunit__interval__05F9A7A6
go 
alter table afunit add default 1 for [interval]
go 


alter table bankaccount alter column [fund_objid] varchar(100) NOT NULL 
go 
create index ix_fund_objid on bankaccount (fund_objid) 
go 
alter table bankaccount add constraint fk_bankaccount_fund_objid 
	foreign key (fund_objid) references fund (objid)
go 


alter table bankaccount_ledger alter column [objid] varchar(150) NOT NULL
go 

drop index ix_jevid on bankaccount_ledger 
go 
alter table bankaccount_ledger alter column [jevid] varchar(150) NOT NULL
go 
create index ix_jevid on bankaccount_ledger (jevid) 
go 

drop index ix_bankacctid on bankaccount_ledger 
go 
alter table bankaccount_ledger alter column [bankacctid] varchar(50) NOT NULL
go 
create index ix_bankacctid on bankaccount_ledger (bankacctid) 
go 

drop index ix_itemacctid on bankaccount_ledger
go 
alter table bankaccount_ledger alter column [itemacctid] varchar(50) NOT NULL
go 
create index ix_itemacctid on bankaccount_ledger (itemacctid) 
go 

alter table bankaccount_ledger alter column [dr] decimal(16,4) NOT NULL
go 
alter table bankaccount_ledger alter column [cr] decimal(16,4) NOT NULL
go 


drop index ix_batchcapture_collection_entry_parentid on batchcapture_collection_entry 
go 
alter table batchcapture_collection_entry alter column [parentid] varchar(50) NOT NULL
go 
create index ix_parentid on batchcapture_collection_entry (parentid) 
go 


drop index ix_batchcapture_collection_entry_item_parentid on batchcapture_collection_entry_item 
go 
alter table batchcapture_collection_entry_item alter column [parentid] varchar(50) NOT NULL
go 
create index ix_parentid on batchcapture_collection_entry_item (parentid) 
go 
alter table batchcapture_collection_entry_item add constraint fk_batchcapture_collection_entry_item_parentid 
	foreign key (parentid) references batchcapture_collection_entry (objid) 
go 


alter table batchcapture_collection_entry_item alter column [item_objid] varchar(50) NOT NULL 
go 
create index ix_item_objid on batchcapture_collection_entry_item (item_objid)
go 

drop index ix_batchcapture_collection_entry_item_item_code on batchcapture_collection_entry_item
go 
alter table batchcapture_collection_entry_item alter column [item_code] varchar(50) NOT NULL
go 
create index ix_item_code on batchcapture_collection_entry_item (item_code)
go 

alter table batchcapture_collection_entry_item alter column [item_title] varchar(255) NOT NULL
go 
alter table batchcapture_collection_entry_item alter column [fund_objid] varchar(100) NOT NULL
go 
alter table batchcapture_collection_entry_item alter column [fund_code] varchar(50) NOT NULL
go 
alter table batchcapture_collection_entry_item alter column [fund_title] varchar(255) NOT NULL
go 
alter table batchcapture_collection_entry_item alter column [amount] decimal(16,2) NOT NULL
go 

alter table batchcapture_collection_entry_item add constraint fk_batchcapture_collection_entry_item_item_objid 
	foreign key (item_objid) references itemaccount (objid) 
go 
alter table batchcapture_collection_entry_item add constraint fk_batchcapture_collection_entry_fund_objid 
	foreign key (fund_objid) references fund (objid) 
go 


CREATE TABLE [dbo].[billitem_txntype] (
[objid] varchar(50) NOT NULL ,
[title] varchar(150) NULL ,
[category] varchar(100) NULL ,
CONSTRAINT [pk_billitem_txntype] PRIMARY KEY ([objid])
)
GO
CREATE INDEX [ix_title] ON [dbo].[billitem_txntype] ([title] ASC) 
GO
CREATE INDEX [ix_category] ON [dbo].[billitem_txntype] ([category] ASC) 
GO


alter table lobclassification add constraint pk_lobclassification primary key (objid) 
go 
alter table lobclassification alter column state varchar(25) not null 
go 
create unique index uix_name on lobclassification (name) 
go 


alter table lob add constraint pk_lob primary key (objid) 
go 
alter table lob alter column state varchar(25) not null 
go 
alter table lob add ukey varchar(50) not null default ''
go 
update lob set ukey = convert(varchar(50), HashBytes('MD5', objid), 2) 
go 
create unique index uix_name_ukey on lob (name, ukey) 
go 
create index ix_name on lob (name)
go 

create index ix_classification_objid on lob (classification_objid) 
go 
alter table lob add constraint fk_lob_classification_objid 
	foreign key (classification_objid) references lobclassification (objid) 
go 



CREATE TABLE [dbo].[business_active_lob_history] (
[objid] varchar(50) NOT NULL ,
[businessid] varchar(50) NULL ,
[activeyear] int NULL ,
[lobid] varchar(50) NULL ,
[name] varchar(255) NULL ,
CONSTRAINT [pk_business_active_lob_history] PRIMARY KEY ([objid]) 
)
GO
CREATE INDEX [ix_businessid] ON [dbo].[business_active_lob_history] ([businessid] ASC) 
GO
CREATE INDEX [ix_activeyear] ON [dbo].[business_active_lob_history] ([activeyear] ASC) 
GO
CREATE INDEX [ix_lobid] ON [dbo].[business_active_lob_history] ([lobid] ASC) 
GO
alter table business_active_lob_history add CONSTRAINT [fk_business_active_lob_history_businessid] 
	FOREIGN KEY ([businessid]) REFERENCES [dbo].[business] ([objid]) 
go 
alter table business_active_lob_history add CONSTRAINT [fk_business_active_lob_history_lobid] 
	FOREIGN KEY ([lobid]) REFERENCES [dbo].[lob] ([objid]) 
go 


CREATE TABLE [dbo].[business_active_lob_history_forprocess] (
[businessid] varchar(50) NOT NULL ,
CONSTRAINT [pk_business_active_lob_history_forprocess] PRIMARY KEY ([businessid])
)
GO


CREATE TABLE [dbo].[business_application_task_lock] (
[refid] varchar(50) NOT NULL ,
[state] varchar(50) NOT NULL ,
CONSTRAINT [pk_business_application_task_lock] PRIMARY KEY ([refid], [state])
)
GO
CREATE INDEX [ix_refid] ON [dbo].[business_application_task_lock] ([refid] ASC) 
GO
alter table business_application_task_lock add CONSTRAINT [fk_business_application_task_lock_refid] 
	FOREIGN KEY ([refid]) REFERENCES [dbo].[business_application] ([objid]) 
go 


CREATE TABLE [dbo].[business_billitem_txntype] (
[objid] varchar(50) NOT NULL ,
[title] varchar(255) NULL ,
[category] varchar(50) NULL ,
[acctid] varchar(50) NULL ,
[feetype] varchar(50) NULL ,
[domain] varchar(100) NULL ,
[role] varchar(100) NULL ,
CONSTRAINT [pk_business_billitem_txntype] PRIMARY KEY ([objid])
)
GO
CREATE INDEX [ix_acctid] ON [dbo].[business_billitem_txntype] ([acctid] ASC) 
GO


CREATE TABLE [dbo].[business_closure] (
[objid] varchar(50) NOT NULL ,
[businessid] varchar(50) NOT NULL ,
[dtcreated] datetime NOT NULL ,
[createdby_objid] varchar(50) NOT NULL ,
[createdby_name] varchar(150) NOT NULL ,
[dtceased] date NOT NULL ,
[dtissued] datetime NOT NULL ,
[remarks] varchar(MAX) NULL ,
CONSTRAINT [pk_business_closure] PRIMARY KEY ([objid]) 
)
GO
CREATE UNIQUE INDEX [uix_businessid] ON [dbo].[business_closure] ([businessid] ASC) 
GO
CREATE INDEX [ix_dtcreated] ON [dbo].[business_closure] ([dtcreated] ASC) 
GO
CREATE INDEX [ix_createdby_objid] ON [dbo].[business_closure] ([createdby_objid] ASC) 
GO
CREATE INDEX [ix_dtceased] ON [dbo].[business_closure] ([dtceased] ASC) 
GO
CREATE INDEX [ix_dtissued] ON [dbo].[business_closure] ([dtissued] ASC) 
GO
alter table business_closure add CONSTRAINT [fk_business_closure_businessid] 
	FOREIGN KEY ([businessid]) REFERENCES [dbo].[business] ([objid]) 
go 


CREATE TABLE [dbo].[business_permit_lob] (
[objid] varchar(50) NOT NULL ,
[parentid] varchar(50) NULL ,
[lobid] varchar(50) NULL ,
[name] varchar(255) NOT NULL ,
[txndate] datetime NULL ,
CONSTRAINT [pk_business_permit_lob] PRIMARY KEY ([objid]) 
)
GO
CREATE INDEX [ix_parentid] ON [dbo].[business_permit_lob] ([parentid] ASC) 
GO
CREATE INDEX [ix_lobid] ON [dbo].[business_permit_lob] ([lobid] ASC) 
GO
CREATE INDEX [ix_name] ON [dbo].[business_permit_lob] ([name] ASC) 
GO
alter table business_permit_lob add CONSTRAINT [fk_business_permit_lob_lobid] 
	FOREIGN KEY ([lobid]) REFERENCES [dbo].[lob] ([objid]) 
go 
alter table business_permit_lob add CONSTRAINT [fk_business_permit_lob_parentid] 
	FOREIGN KEY ([parentid]) REFERENCES [dbo].[business_permit] ([objid]) 
go 


if object_id('dbo.ztmp_business_permit_lob', 'U') IS NOT NULL 
  drop table dbo.ztmp_business_permit_lob; 
go 
select 
	t1.permitid as parentid, t1.lobid, t1.name, max(t1.txndate) as txndate, sum(t1.iflag) as iflag 
into ztmp_business_permit_lob 
from ( 
	select 
		p.objid as permitid, al.lobid, al.name, a.txndate, 
		case when al.assessmenttype = 'RETIRE' then -1 else 1 end iflag
	from business_permit p 
		inner join business_application pa on pa.objid = p.applicationid 
		inner join business_application a on (a.business_objid = pa.business_objid and a.appyear = p.activeyear and a.txndate <= pa.txndate) 
		inner join business_application_lob al on al.applicationid = a.objid 
	where a.state = 'COMPLETED' 
)t1 
group by t1.permitid, t1.lobid, t1.name 
having sum(t1.iflag) > 0 
go 


insert into lob (
	objid, state, name, classification_objid 
) values (
	'LOB-e33a159:131926d357b:-625c', 'DRAFT', 'LPG RETAILER', 'RETAILER'
) 
go 

insert into lob (
	objid, state, name, classification_objid 
) values (
	'FBBL0000101', 'DRAFT', 'CONTRACTOR', 'CONTRACTOR'
) 
go 

insert into business_permit_lob (
	objid, parentid, lobid, name, txndate 
) 
select 
	('BPLOB-'+ convert(varchar(50), HashBytes('MD5', (parentid + lobid)), 2)) as objid, 
	parentid, lobid, name, txndate 
from ztmp_business_permit_lob z 
where z.lobid not in (select objid from lob where objid = z.lobid) 
go  

drop table dbo.ztmp_business_permit_lob
go 

update aa set 
	aa.permit_objid = bb.objid 
from business_application aa, ( 
	select objid, applicationid 
	from business_permit 
	where state = 'ACTIVE' 
)bb 
where aa.objid = bb.applicationid 
go 

alter table business_application add constraint fk_business_application_permit_objid 
	foreign key (permit_objid) references business_permit (objid) 
go 


CREATE TABLE [dbo].[cashbook_revolving_fund] (
[objid] varchar(50) NOT NULL ,
[state] varchar(25) NOT NULL ,
[dtfiled] datetime NOT NULL ,
[filedby_objid] varchar(50) NOT NULL ,
[filedby_name] varchar(150) NOT NULL ,
[issueto_objid] varchar(50) NOT NULL ,
[issueto_name] varchar(150) NOT NULL ,
[controldate] date NOT NULL ,
[amount] decimal(16,2) NOT NULL ,
[remarks] varchar(255) NOT NULL ,
[fund_objid] varchar(100) NOT NULL ,
[fund_title] varchar(255) NOT NULL 
)
GO
CREATE INDEX [ix_state] ON [dbo].[cashbook_revolving_fund] ([state] ASC) 
GO
CREATE INDEX [ix_dtfiled] ON [dbo].[cashbook_revolving_fund] ([dtfiled] ASC) 
GO
CREATE INDEX [ix_filedby_objid] ON [dbo].[cashbook_revolving_fund] ([filedby_objid] ASC) 
GO
CREATE INDEX [ix_filedby_name] ON [dbo].[cashbook_revolving_fund] ([filedby_name] ASC) 
GO
CREATE INDEX [ix_issueto_objid] ON [dbo].[cashbook_revolving_fund] ([issueto_objid] ASC) 
GO
CREATE INDEX [ix_issueto_name] ON [dbo].[cashbook_revolving_fund] ([issueto_name] ASC) 
GO
CREATE INDEX [ix_controldate] ON [dbo].[cashbook_revolving_fund] ([controldate] ASC) 
GO
CREATE INDEX [ix_fund_objid] ON [dbo].[cashbook_revolving_fund] ([fund_objid] ASC) 
GO
CREATE INDEX [ix_fund_title] ON [dbo].[cashbook_revolving_fund] ([fund_title] ASC) 
GO


CREATE TABLE [dbo].[cashreceipt_changelog] (
[objid] varchar(50) NOT NULL ,
[receiptid] varchar(50) NOT NULL ,
[dtfiled] datetime NOT NULL ,
[filedby_objid] varchar(50) NOT NULL ,
[filedby_name] varchar(150) NOT NULL ,
[action] varchar(255) NOT NULL ,
[remarks] varchar(255) NOT NULL ,
[oldvalue] varchar(MAX) NOT NULL ,
[newvalue] varchar(MAX) NOT NULL ,
CONSTRAINT [pk_cashreceipt_changelog] PRIMARY KEY ([objid]),
)
GO
CREATE INDEX [ix_receiptid] ON [dbo].[cashreceipt_changelog] ([receiptid] ASC) 
GO
CREATE INDEX [ix_dtfiled] ON [dbo].[cashreceipt_changelog] ([dtfiled] ASC) 
GO
CREATE INDEX [ix_filedby_objid] ON [dbo].[cashreceipt_changelog] ([filedby_objid] ASC) 
GO
CREATE INDEX [ix_filedby_name] ON [dbo].[cashreceipt_changelog] ([filedby_name] ASC) 
GO
CREATE INDEX [ix_action] ON [dbo].[cashreceipt_changelog] ([action] ASC) 
GO
alter table cashreceipt_changelog add CONSTRAINT [fk_cashreceipt_changelog_receiptid] 
	FOREIGN KEY ([receiptid]) REFERENCES [dbo].[cashreceipt] ([objid]) 
go 


CREATE TABLE [dbo].[cashreceipt_group] (
[objid] varchar(50) NOT NULL ,
[txndate] datetime NOT NULL ,
[controlid] varchar(50) NOT NULL ,
[amount] decimal(16,2) NOT NULL ,
[totalcash] decimal(16,2) NOT NULL ,
[totalnoncash] decimal(16,2) NOT NULL ,
[cashchange] decimal(16,2) NOT NULL ,
CONSTRAINT [pk_cashreceipt_group] PRIMARY KEY ([objid])
)
GO
CREATE INDEX [ix_txndate] ON [dbo].[cashreceipt_group] ([txndate] ASC) 
GO
CREATE INDEX [ix_controlid] ON [dbo].[cashreceipt_group] ([controlid] ASC) 
GO


CREATE TABLE [dbo].[cashreceipt_groupitem] (
[objid] varchar(50) NOT NULL ,
[parentid] varchar(50) NOT NULL ,
CONSTRAINT [pk_cashreceipt_groupitem] PRIMARY KEY ([objid]) 
)
GO
CREATE INDEX [ix_parentid] ON [dbo].[cashreceipt_groupitem] ([parentid] ASC) 
GO
alter table cashreceipt_groupitem add CONSTRAINT [fk_cashreceipt_groupitem_objid] 
	FOREIGN KEY ([objid]) REFERENCES [dbo].[cashreceipt] ([objid]) 
go 
alter table cashreceipt_groupitem add CONSTRAINT [fk_cashreceipt_groupitem_parentid] 
	FOREIGN KEY ([parentid]) REFERENCES [dbo].[cashreceipt_group] ([objid]) 
go 


CREATE TABLE [dbo].[cashreceipt_plugin] (
[objid] varchar(50) NOT NULL ,
[connection] varchar(150) NOT NULL ,
[servicename] varchar(255) NOT NULL ,
CONSTRAINT [pk_cashreceipt_plugin] PRIMARY KEY ([objid])
)
GO


alter table cashreceiptpayment_noncash alter column [account_fund_objid] varchar(100) NULL
go 


CREATE TABLE [dbo].[checkpayment_dishonored] (
[objid] varchar(50) NOT NULL ,
[checkpaymentid] varchar(50) NOT NULL ,
[dtfiled] datetime NOT NULL ,
[filedby_objid] varchar(50) NOT NULL ,
[filedby_name] varchar(150) NOT NULL ,
[remarks] varchar(255) NOT NULL ,
CONSTRAINT [pk_checkpayment_dishonored] PRIMARY KEY ([objid])
)
GO
CREATE INDEX [ix_checkpaymentid] ON [dbo].[checkpayment_dishonored] ([checkpaymentid] ASC) 
GO
CREATE INDEX [ix_dtfiled] ON [dbo].[checkpayment_dishonored] ([dtfiled] ASC) 
GO
CREATE INDEX [ix_filedby_objid] ON [dbo].[checkpayment_dishonored]
([filedby_objid] ASC) 
GO
CREATE INDEX [ix_filedby_name] ON [dbo].[checkpayment_dishonored]
([filedby_name] ASC) 
GO
alter table checkpayment_dishonored add CONSTRAINT [fk_checkpayment_dishonored_checkpaymentid] 
	FOREIGN KEY ([checkpaymentid]) REFERENCES [dbo].[checkpayment] ([objid]) 
go 


alter table collectiongroup_account alter column [account_title] varchar(255) NOT NULL 
go 
alter table collectiongroup_account alter column [sortorder] int NOT NULL 
go 


alter table collectiontype alter column [fund_objid] varchar(100) NULL 
go 
alter table collectiontype alter column [info] text NULL 
go 

alter table collectiontype_account alter column [defaultvalue] decimal(16,2) NULL
go 


drop index ix_parentid on collectionvoucher_fund 
go 
alter table collectionvoucher_fund alter column [parentid] varchar(50) NOT NULL
go 
create index ix_parentid on collectionvoucher_fund (parentid) 
go 


alter table creditmemo add issuereceipt int null 
go 

alter table creditmemoitem alter column [amount] decimal(16,2) NOT NULL
go 

alter table collectiontype add constraint fk_collectiontype_fund_objid 
	foreign key (fund_objid) references fund (objid) 
go 

alter table creditmemotype alter column [fund_objid] varchar(100) NULL 
go 
alter table creditmemotype add constraint fk_creditmemotype_fund_objid 
	foreign key (fund_objid) references fund (objid) 
go 


alter table deposit_fund_transfer alter column [fromdepositvoucherfundid] varchar(150) NOT NULL
go 
alter table deposit_fund_transfer alter column [todepositvoucherfundid] varchar(150) NOT NULL 
go 
alter table deposit_fund_transfer alter column [amount] decimal(16,4) NOT NULL
go 


drop index ix_state on depositvoucher_fund 
go 
alter table depositvoucher_fund alter column [state] varchar(20) NOT NULL 
go 
create index ix_state on depositvoucher_fund (state) 
go 

drop index ix_parentid on depositvoucher_fund 
go 
alter table depositvoucher_fund alter column [parentid] varchar(50) NOT NULL 
go 
create index ix_parentid on depositvoucher_fund (parentid) 
go 

drop index ix_fundid on depositvoucher_fund 
go 
alter table depositvoucher_fund alter column [fundid] varchar(100) NOT NULL 
go 
create index ix_fundid on depositvoucher_fund (fundid) 
go 


alter table depositvoucher_fund alter column [amount] decimal(16,4) NOT NULL 
go 
alter table depositvoucher_fund alter column [amountdeposited] decimal(16,4) NOT NULL 
go 

update depositvoucher_fund set totaldr = 0.0 where totaldr is null 
go 
alter table depositvoucher_fund alter column [totaldr] decimal(16,4) NOT NULL 
go 

update depositvoucher_fund set totalcr = 0.0 where totalcr is null 
go 
alter table depositvoucher_fund alter column [totalcr] decimal(16,4) NOT NULL 
go 


drop index ix_state on eftpayment
go 
alter table eftpayment alter column [state] varchar(50) NOT NULL 
go 
create index ix_state on eftpayment (state) 
go 

drop index ix_refno on eftpayment
go 
alter table eftpayment alter column [refno] varchar(50) NOT NULL 
go 
create index ix_refno on eftpayment (refno) 
go 

drop index ix_refdate on eftpayment
go 
alter table eftpayment alter column [refdate] date NOT NULL 
go 
create index ix_refdate on eftpayment (refdate) 
go 

alter table eftpayment alter column [amount] decimal(16,4) NOT NULL 
go 


drop index ix_bankacctid on eftpayment
go 
alter table eftpayment alter column [bankacctid] varchar(50) NOT NULL
go 
create index ix_bankacctid on eftpayment (bankacctid) 
go 

drop index ix_createdby_objid on eftpayment
go 
alter table eftpayment alter column [createdby_objid] varchar(50) NOT NULL 
go 
create index ix_createdby_objid on eftpayment (createdby_objid)
go 

alter table eftpayment alter column [createdby_name] varchar(255) NOT NULL 
go 


drop index ix_entityname on entity 
go 
alter table entity alter column [entityname] varchar(800) NOT NULL
go 
create index ix_entityname on entity (entityname) 
go 

alter table entity alter column [email] varchar(255) NULL 
go 

alter table entity add [state] varchar(25) NULL
go 
update entity set state = 'ACTIVE' where state IS NULL 
go 
alter table entity alter column [state] varchar(25) NOT NULL
go 
create index ix_state on entity (state) 
go 


CREATE TABLE [dbo].[entity_mapping] (
[objid] varchar(50) NOT NULL ,
[parent_objid] varchar(50) NOT NULL ,
[org_objid] varchar(50) NULL ,
CONSTRAINT [pk_entity_mapping] PRIMARY KEY ([objid])
)
GO
create index ix_parent_objid on entity_mapping (parent_objid)
go 
create index ix_org_objid on entity_mapping (org_objid)
go 


CREATE TABLE [dbo].[entityidcard] (
[objid] varchar(50) NOT NULL ,
[entityid] varchar(50) NOT NULL ,
[idtype] varchar(50) NOT NULL ,
[idno] varchar(25) NOT NULL ,
[expiry] varchar(50) NULL ,
CONSTRAINT [pk_entityidcard] PRIMARY KEY ([objid])
)
GO
CREATE UNIQUE INDEX [ux_entityidcard_entityid_idtype_idno] ON [dbo].[entityidcard]
([entityid] ASC, [idtype] ASC, [idno] ASC) 
GO
CREATE INDEX [FK_entityidcard_entity] ON [dbo].[entityidcard]
([entityid] ASC) 
GO

alter table entityprofile alter column [address] varchar(MAX) NULL
go 


alter table fundgroup alter column [title] varchar(100) NULL 
go 
alter table fundgroup alter column [indexno] int NULL 
go 


CREATE TABLE [dbo].[holiday] (
[objid] varchar(50) NOT NULL ,
[year] int NULL ,
[month] int NULL ,
[day] int NULL ,
[week] int NULL ,
[dow] int NULL ,
[name] varchar(255) NULL ,
CONSTRAINT [pk_holiday] PRIMARY KEY ([objid])
)
GO


alter table income_summary add 
	[refyear] int NULL ,
	[refmonth] int NULL ,
	[refqtr] int NULL ,
	[remittanceid] varchar(50) NOT NULL DEFAULT '' ,
	[remittancedate] date NULL ,
	[remittanceyear] int NULL ,
	[remittancemonth] int NULL ,
	[remittanceqtr] int NULL ,
	[liquidationid] varchar(50) NOT NULL DEFAULT '' ,
	[liquidationdate] date NULL ,
	[liquidationyear] int NULL ,
	[liquidationmonth] int NULL ,
	[liquidationqtr] int NULL 
go 
alter table income_summary drop constraint PK__income_s__020F08D576F68FE1 
go 
alter table income_summary add CONSTRAINT [pk_income_summary] 
	PRIMARY KEY ([refid], [refdate], [fundid], [acctid], [orgid], [remittanceid], [liquidationid])
go 

delete from income_summary where reftype in ('remittance','liquidation') 
go 


insert into income_summary ( 
	refid, refdate, refno, reftype, acctid, fundid, amount, 
	orgid, collectorid, refyear, refmonth, refqtr, 
	remittanceid, remittancedate, remittanceyear, remittancemonth, remittanceqtr, 
	liquidationid, liquidationdate, liquidationyear, liquidationmonth, liquidationqtr 
)
select 
	refid, refdate, refno, reftype, acctid, fundid, 
	sum(amount) as amount, orgid, collectorid, 
	year(refdate) as refyear, month(refdate) as refmonth, 
	case 
		when month(refdate) <= 3 then 1
		when month(refdate) <= 6 then 2
		when month(refdate) <= 9 then 3
		when month(refdate) <= 12 then 4
	end as refqtr, 
	remittanceid, remittancedate, 
	year(remittancedate) as remittanceyear, month(remittancedate) as remittancemonth, 
	case 
		when month(remittancedate) <= 3 then 1
		when month(remittancedate) <= 6 then 2
		when month(remittancedate) <= 9 then 3
		when month(remittancedate) <= 12 then 4
	end as remittanceqtr,
	refid as liquidationid, refdate as liquidationdate, 
	year(refdate) as liquidationyear, month(refdate) as liquidationmonth, 
	case 
		when month(refdate) <= 3 then 1
		when month(refdate) <= 6 then 2
		when month(refdate) <= 9 then 3
		when month(refdate) <= 12 then 4
	end as liquidationqtr  
from ( 

	select 
		cv.objid as refid, cv.controldate as refdate, cv.controlno as refno, 'liquidation' as reftype, 
		ci.item_objid as acctid, ci.item_fund_objid as fundid, sum(ci.amount) as amount, 
		c.org_objid as orgid, c.collector_objid as collectorid, c.remittanceid, r.controldate as remittancedate 
	from collectionvoucher cv 
		inner join remittance r on r.collectionvoucherid = cv.objid 
		inner join cashreceipt c on c.remittanceid = r.objid 
		inner join cashreceiptitem ci on ci.receiptid = c.objid
		left join cashreceipt_void v on v.receiptid = c.objid 
	where cv.state = 'POSTED' 
		and v.objid is null 
	group by 
		cv.objid, cv.controldate, cv.controlno, ci.item_objid, ci.item_fund_objid, 
		c.org_objid, c.collector_objid, c.remittanceid, r.controldate 

	union all 

	select 
		cv.objid as refid, cv.controldate as refdate, cv.controlno as refno, 'liquidation' as reftype, cs.refitem_objid as acctid, 
		(select top 1 item_fund_objid from cashreceiptitem where receiptid = c.objid and item_objid = cs.refitem_objid) as fundid, 
		-cs.amount as amount, c.org_objid as orgid, c.collector_objid as collectorid, c.remittanceid, r.controldate as remittancedate 
	from collectionvoucher cv 
		inner join remittance r on r.collectionvoucherid = cv.objid 
		inner join cashreceipt c on c.remittanceid = r.objid 
		inner join cashreceipt_share cs on cs.receiptid = c.objid
		left join cashreceipt_void v on v.receiptid = c.objid 
	where cv.state = 'POSTED' 
		and v.objid is null 

	union all 

	select 
		cv.objid as refid, cv.controldate as refdate, cv.controlno as refno, 'liquidation' as reftype, 
		ia.objid as acctid, ia.fund_objid as fundid, sum(cs.amount) as amount, 
		c.org_objid as orgid, c.collector_objid as collectorid, c.remittanceid, r.controldate as remittancedate 
	from collectionvoucher cv 
		inner join remittance r on r.collectionvoucherid = cv.objid 
		inner join cashreceipt c on c.remittanceid = r.objid 
		inner join cashreceipt_share cs on cs.receiptid = c.objid 
		inner join itemaccount ia on ia.objid = cs.payableitem_objid
		left join cashreceipt_void v on v.receiptid = c.objid 
	where cv.state = 'POSTED' 
		and v.objid is null 
	group by 
		cv.objid, cv.controldate, cv.controlno, ia.objid, ia.fund_objid,
		c.org_objid, c.collector_objid, c.remittanceid, r.controldate 
)t1 
group by 
	refid, refdate, refno, reftype, acctid, fundid, 
	orgid, collectorid, remittanceid, remittancedate 

go 


alter table itemaccount add [hidefromlookup] int NOT NULL DEFAULT 0
go 


DROP TABLE [dbo].[paymentorder]
GO 

CREATE TABLE [dbo].[paymentorder] (
[objid] varchar(50) NOT NULL ,
[txndate] datetime NULL ,
[payer_objid] varchar(50) NULL ,
[payer_name] varchar(MAX) NULL ,
[paidby] varchar(MAX) NULL ,
[paidbyaddress] varchar(150) NULL ,
[particulars] varchar(MAX) NULL ,
[amount] decimal(16,2) NULL ,
[txntype] varchar(50) NULL ,
[expirydate] date NULL ,
[refid] varchar(50) NULL ,
[refno] varchar(50) NULL ,
[info] varchar(MAX) NULL ,
[txntypename] varchar(255) NULL ,
[locationid] varchar(50) NULL ,
[origin] varchar(50) NULL ,
[issuedby_objid] varchar(50) NULL ,
[issuedby_name] varchar(150) NULL ,
[org_objid] varchar(50) NULL ,
[org_name] varchar(255) NULL ,
[items] text NULL ,
[collectiontypeid] varchar(50) NULL ,
[queueid] varchar(50) NULL ,
CONSTRAINT [pk_paymentorder] PRIMARY KEY ([objid])
)
GO
CREATE INDEX [ix_collectiontypeid] ON [dbo].[paymentorder]
([collectiontypeid] ASC) 
GO
CREATE INDEX [ix_locationid] ON [dbo].[paymentorder]
([locationid] ASC) 
GO
CREATE INDEX [ix_issuedby_objid] ON [dbo].[paymentorder]
([issuedby_objid] ASC) 
GO
CREATE INDEX [ix_issuedby_name] ON [dbo].[paymentorder]
([issuedby_name] ASC) 
GO
CREATE INDEX [ix_org_objid] ON [dbo].[paymentorder]
([org_objid] ASC) 
GO
CREATE INDEX [ix_org_name] ON [dbo].[paymentorder]
([org_name] ASC) 
GO



drop table sync_data_pending 
go 
drop table sync_data_forprocess
go 
drop table sync_data
go 

CREATE TABLE [dbo].[sync_data] (
[objid] varchar(50) NOT NULL ,
[parentid] varchar(50) NOT NULL ,
[refid] varchar(50) NOT NULL ,
[reftype] varchar(50) NOT NULL ,
[action] varchar(50) NOT NULL ,
[orgid] varchar(50) NULL ,
[remote_orgid] varchar(50) NULL ,
[remote_orgcode] varchar(20) NULL ,
[remote_orgclass] varchar(20) NULL ,
[dtfiled] datetime NOT NULL ,
[idx] int NOT NULL ,
[sender_objid] varchar(50) NULL ,
[sender_name] varchar(150) NULL ,
[refno] varchar(50) NULL ,
CONSTRAINT [pk_sync_data] PRIMARY KEY ([objid])
)
GO
CREATE INDEX [ix_sync_data_refid] ON [dbo].[sync_data]
([refid] ASC) 
GO
CREATE INDEX [ix_sync_data_reftype] ON [dbo].[sync_data]
([reftype] ASC) 
GO
CREATE INDEX [ix_sync_data_orgid] ON [dbo].[sync_data]
([orgid] ASC) 
GO
CREATE INDEX [ix_sync_data_dtfiled] ON [dbo].[sync_data]
([dtfiled] ASC) 
GO


CREATE TABLE [dbo].[sync_data_forprocess] (
[objid] varchar(50) NOT NULL ,
CONSTRAINT [pk_sync_data_forprocess] PRIMARY KEY ([objid]) ,
CONSTRAINT [fk_sync_data_forprocess_sync_data] FOREIGN KEY ([objid]) REFERENCES [dbo].[sync_data] ([objid]) 
)
GO

CREATE TABLE [dbo].[sync_data_pending] (
[objid] varchar(50) NOT NULL ,
[error] text NULL ,
[expirydate] datetime NULL ,
CONSTRAINT [pk_sync_data_pending] PRIMARY KEY ([objid]),
CONSTRAINT [fk_sync_data_pending_sync_data] FOREIGN KEY ([objid]) REFERENCES [dbo].[sync_data] ([objid]) 
)
GO
CREATE INDEX [ix_expirydate] ON [dbo].[sync_data_pending]
([expirydate] ASC) 
GO


drop table sys_report_admin
go
drop table sys_report_member
go
drop table sys_report
go
drop table sys_report_folder 
go


CREATE TABLE [dbo].[sys_report_folder] (
[objid] varchar(50) NOT NULL ,
[name] varchar(255) NULL ,
[title] varchar(255) NULL ,
[parentid] varchar(50) NULL ,
CONSTRAINT [pk_sys_report_folder] PRIMARY KEY ([objid])
)
GO

CREATE TABLE [dbo].[sys_report] (
[objid] varchar(50) NOT NULL ,
[folderid] varchar(50) NULL ,
[title] varchar(255) NULL ,
[filetype] varchar(25) NULL ,
[dtcreated] datetime NULL ,
[createdby_objid] varchar(50) NULL ,
[createdby_name] varchar(255) NULL ,
[datasetid] varchar(50) NULL ,
[template] varchar(MAX) NULL ,
[outputtype] varchar(50) NULL ,
[system] int NULL ,
CONSTRAINT [pk_sys_report] PRIMARY KEY ([objid]),
CONSTRAINT [fk_sys_report_datasetid] FOREIGN KEY ([datasetid]) REFERENCES [dbo].[sys_dataset] ([objid]) 
)
GO

CREATE INDEX [FK_sys_report_dataset] ON [dbo].[sys_report]
([datasetid] ASC) 
GO
CREATE INDEX [FK_sys_report_entry_folder] ON [dbo].[sys_report]
([folderid] ASC) 
GO

CREATE TABLE [dbo].[sys_report_member] (
[objid] varchar(50) NOT NULL ,
[reportfolderid] varchar(50) NULL ,
[userid] varchar(50) NULL ,
[usergroupid] varchar(50) NULL ,
[exclude] varchar(MAX) NULL ,
CONSTRAINT [pk_sys_report_member] PRIMARY KEY ([objid]),
CONSTRAINT [fk_sys_report_member_reportfolderid] FOREIGN KEY ([reportfolderid]) REFERENCES [dbo].[sys_report_folder] ([objid]) ,
CONSTRAINT [fk_sys_report_member_usergroupid] FOREIGN KEY ([usergroupid]) REFERENCES [dbo].[sys_usergroup] ([objid]) ,
CONSTRAINT [fk_sys_report_member_userid] FOREIGN KEY ([userid]) REFERENCES [dbo].[sys_user] ([objid]) 
)
GO

CREATE INDEX [FK_sys_report_member_folder] ON [dbo].[sys_report_member]
([reportfolderid] ASC) 
GO
CREATE INDEX [FK_sys_report_member_user] ON [dbo].[sys_report_member]
([userid] ASC) 
GO
CREATE INDEX [FK_sys_report_member_usergroup] ON [dbo].[sys_report_member]
([usergroupid] ASC) 
GO

CREATE TABLE [dbo].[sys_report_admin] (
[objid] varchar(50) NOT NULL ,
[userid] varchar(50) NULL ,
[reportfolderid] varchar(50) NULL ,
[exclude] varchar(MAX) NULL ,
CONSTRAINT [pk_sys_report_admin] PRIMARY KEY ([objid]),
CONSTRAINT [fk_sys_report_admin_reportfolderid] FOREIGN KEY ([reportfolderid]) REFERENCES [dbo].[sys_report_folder] ([objid]) ,
CONSTRAINT [fk_sys_report_admin_userid] FOREIGN KEY ([userid]) REFERENCES [dbo].[sys_user] ([objid]) ON DELETE NO ACTION ON UPDATE NO ACTION
)
GO

CREATE INDEX [FK_sys_report_admin_folder] ON [dbo].[sys_report_admin]
([reportfolderid] ASC) 
GO
CREATE INDEX [FK_sys_report_admin_user] ON [dbo].[sys_report_admin]
([userid] ASC) 
GO


alter table sys_rule_action_param alter column [actiondefparam_objid] varchar(255) NOT NULL
go 

alter table sys_rule_actiondef alter column [actionclass] varchar(255) NULL
go 

alter table sys_rule_actiondef_param alter column [objid] varchar(255) NOT NULL
go 

alter table sys_rule_condition_constraint alter column [field_objid] varchar(255) NULL
go 

alter table sys_rule_fact_field alter column [objid] varchar(255) NOT NULL
go 
