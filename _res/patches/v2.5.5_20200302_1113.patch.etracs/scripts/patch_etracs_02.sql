create index ix_receiptid on cashreceipt_void (receiptid)
go 
create index ix_txndate on cashreceipt_void (txndate)
go 
create index ix_postedby_objid on cashreceipt_void (postedby_objid)
go 
create unique index uix_receiptid on cashreceipt_void (receiptid) 
go 


drop index ix_item_fund_objid on cashreceiptitem 
go 
alter table cashreceiptitem alter column [item_fund_objid] varchar(100) NOT NULL 
go 
create index ix_item_fund_objid on cashreceiptitem (item_fund_objid)
go 


create index ix_refno  on cashreceiptpayment_noncash (refno) 
go 
create index ix_refdate on cashreceiptpayment_noncash (refdate) 
go 

DROP TABLE [dbo].[dbo.citizenship]
go 

DROP TABLE [dbo].[dbo.religion]
go 



UPDATE sys_usergroup_member SET usergroup_objid = 'FINANCIAL.MASTER' WHERE usergroup_objid = 'ACCOUNTING.MASTER'
GO 
UPDATE sys_usergroup_member SET usergroup_objid = 'FINANCIAL.REPORT' WHERE usergroup_objid = 'ACCOUNTING.REPORT'
GO 


if object_id('dbo.ztmp_fix_usergroupmember', 'U') IS NOT NULL 
  drop table dbo.ztmp_fix_usergroupmember; 
go 
select m.*, 1 as allowremove
into ztmp_fix_usergroupmember   
from ( 
	select user_objid, usergroup_objid, org_objid, count(*) as icount 
	from sys_usergroup_member 
	group by user_objid, usergroup_objid, org_objid
	having count(*) > 1 
)t1, sys_usergroup_member m 
where m.user_objid = t1.user_objid 
	and m.usergroup_objid = t1.usergroup_objid 
	and isnull(m.org_objid,'') = isnull(t1.org_objid,'') 
go 

update aa set 
	aa.allowremove = 0 
from ztmp_fix_usergroupmember aa, ( 
	select distinct 
		user_objid, usergroup_objid, org_objid, 
		(
			select top 1 objid from ztmp_fix_usergroupmember x
			where x.user_objid = m.user_objid and x.usergroup_objid = m.usergroup_objid 
				and isnull(x.org_objid,'') = isnull(m.org_objid,'') 
			order by x.objid 
		) as objid 
	from ztmp_fix_usergroupmember m 
)bb 
where aa.objid = bb.objid 
go 

delete from sys_usergroup_member where objid in (
	select objid from ztmp_fix_usergroupmember where allowremove=1 
)
go 

create unique index uix_user_usergroup_org on sys_usergroup_member (user_objid, usergroup_objid, org_objid) 
go 

delete from sys_usergroup_member where usergroup_objid in ('ACCOUNTING.MASTER', 'ACCOUNTING.REPORT')
GO 
delete from sys_usergroup where domain in ('ACCOUNTING')
GO 

delete from sys_usergroup_member where usergroup_objid in (
	'BPLS.MASTER_ENCODER', 'BPLS.LOB_ADMIN', 'BPLS.DATA_ADMIN'
)
go 
delete from sys_usergroup where domain='bpls' and role in ('MASTER_ENCODER','LOB_ADMIN','DATA_ADMIN')
GO 


delete from sys_rule_action_param where parentid not in (
	select objid from sys_rule_action where objid = sys_rule_action_param.parentid 
)
go 
create index ix_parentid on sys_rule_action_param (parentid) 
go 
alter table sys_rule_action_param add constraint fk_sys_rule_action_param_parentid 
	foreign key (parentid) references sys_rule_action (objid) 
go 

alter table sys_rule_action_param alter column actiondefparam_objid varchar(255) null 
go 

update aa set 
	aa.actiondefparam_objid = null 
from sys_rule_action_param aa, ( 
	select rap.objid  
	from sys_rule_action_param rap  
		left join sys_rule_actiondef_param ff on ff.objid = rap.actiondefparam_objid 
	where rap.actiondefparam_objid is not null 
		and ff.objid is null 
)bb 
where aa.objid = bb.objid 
go
create index ix_actiondefparam_objid on sys_rule_action_param (actiondefparam_objid) 
go 
alter table sys_rule_action_param add constraint fk_sys_rule_action_param_actiondefparam_objid 
	foreign key (actiondefparam_objid) references sys_rule_actiondef_param (objid) 
go 

delete from sys_rule_condition_constraint where parentid not in (
	select objid from sys_rule_condition 
	where objid = sys_rule_condition_constraint.parentid 
)
go 
create index ix_parentid on sys_rule_condition_constraint (parentid) 
go 
alter table sys_rule_condition_constraint add constraint fk_sys_rule_condition_constraint_parentid 
	foreign key (parentid) references sys_rule_condition (objid) 
go 


update aa set 
	aa.field_objid = null 
from sys_rule_condition_constraint aa, ( 
	select rcc.objid  
	from sys_rule_condition_constraint rcc 
		left join sys_rule_fact_field ff on ff.objid = rcc.field_objid 
	where rcc.field_objid is not null 
		and ff.objid is null 
)bb 
where aa.objid = bb.objid 
go 
create index ix_field_objid on sys_rule_condition_constraint (field_objid) 
go 
alter table sys_rule_condition_constraint add constraint fk_sys_rule_condition_constraint_field_objid
	foreign key (field_objid) references sys_rule_fact_field (objid) 
go 


delete from sys_rule_condition_var where parentid not in (
	select objid from sys_rule_condition 
	where objid = sys_rule_condition_var.parentid 
)
go 
create index ix_parentid on sys_rule_condition_var (parentid) 
go 
alter table sys_rule_condition_var add constraint fk_sys_rule_condition_var_parentid 
	foreign key (parentid) references sys_rule_condition (objid) 
go 


delete from sys_rule_condition where parentid not in (
	select objid from sys_rule 
	where objid = sys_rule_condition.parentid 
)
go 
create index ix_parentid on sys_rule_condition (parentid) 
go 
alter table sys_rule_condition add constraint fk_sys_rule_condition_parentid 
	foreign key (parentid) references sys_rule (objid) 
go 


delete from sys_rule where ruleset not in (
	select name from sys_ruleset 
	where name = sys_rule.ruleset 
)
go 
create index ix_ruleset on sys_rule (ruleset) 
go 
alter table sys_rule add constraint fk_sys_rule
	foreign key (ruleset) references sys_ruleset (name) 
go 


delete from sys_rule_fact_field where parentid not in (
	select objid from sys_rule_fact 
	where objid = sys_rule_fact_field.parentid 
)
go 
create index ix_parentid on sys_rule_fact_field (parentid) 
go 
alter table sys_rule_fact_field add constraint fk_sys_rule_fact_field_parentid 
	foreign key (parentid) references sys_rule_fact (objid) 
go 


delete from sys_rule_actiondef_param where parentid not in (
	select objid from sys_rule_actiondef 
	where objid = sys_rule_actiondef_param.parentid 
)
go 
create index ix_parentid on sys_rule_actiondef_param (parentid) 
go 
alter table sys_rule_actiondef_param add constraint fk_sys_rule_actiondef_param_parentid
	foreign key (parentid) references sys_rule_actiondef (objid) 
go 


delete from sys_ruleset_fact where rulefact not in (
	select objid from sys_rule_fact 
	where objid = sys_ruleset_fact.rulefact 
)
go 
create index ix_rulefact on sys_ruleset_fact (rulefact) 
go 
alter table sys_ruleset_fact add constraint fk_sys_ruleset_fact_rulefact
	foreign key (rulefact) references sys_rule_fact (objid) 
go 


delete from sys_ruleset_fact where ruleset not in (
	select name from sys_ruleset 
	where name = sys_ruleset_fact.ruleset 
)
go 
create index ix_ruleset on sys_ruleset_fact (ruleset) 
go 
alter table sys_ruleset_fact add constraint fk_sys_ruleset_fact_ruleset
	foreign key (ruleset) references sys_ruleset (name) 
go 

create unique index uix_ruleset_rulefact on sys_ruleset_fact (ruleset, rulefact)
go 

create unique index uix_ruleset_actiondef on sys_ruleset_actiondef (ruleset, actiondef)
go 

delete from sys_ruleset_actiondef where ruleset not in (
	select name from sys_ruleset 
	where name = sys_ruleset_actiondef.ruleset 
)
go 
create index ix_ruleset on sys_ruleset_actiondef (ruleset) 
go 
alter table sys_ruleset_actiondef add constraint fk_sys_ruleset_actiondef_ruleset
	foreign key (ruleset) references sys_ruleset (name) 
go 

delete from sys_ruleset_actiondef where actiondef not in (
	select objid from sys_rule_actiondef 
	where objid = sys_ruleset_actiondef.actiondef 
)
go 
create index ix_actiondef on sys_ruleset_actiondef (actiondef) 
go 
alter table sys_ruleset_actiondef add constraint fk_sys_ruleset_actiondef_actiondef
	foreign key (actiondef) references sys_rule_actiondef (objid)
go 

create unique index uix_ruleset_name on sys_rulegroup (ruleset, name)
go 

create index ix_ruleset on sys_rulegroup (ruleset) 
go 
alter table sys_rulegroup add constraint fk_sys_rulegroup_ruleset
	foreign key (ruleset) references sys_ruleset (name)
go 


if object_id('dbo.ztmp_lobattribute', 'U') IS NOT NULL 
  drop table dbo.ztmp_lobattribute; 
go 
select 
	t1.objid, 'DRAFT' as state, t1.objid as name, 
	(select top 1 description from lobattribute where objid = t1.objid and description is not null) as description 
into ztmp_lobattribute 
from ( 
	select objid, count(*) as icount 
	from lobattribute 
	group by objid 
	having count(*) > 1
)t1 
go 

delete from lobattribute where objid in (
	select objid from ztmp_lobattribute 
)
go 
insert into lobattribute (
	objid, state, name, description 
) 
select 
	objid, state, name, description 
from ztmp_lobattribute 
go 
drop table ztmp_lobattribute 
go 


alter table lobattribute add constraint pk_lobattribute primary key (objid) 
go 
create unique index uix_name on lobattribute (name) 
go 


if object_id('dbo.ztmp_lobattribute', 'U') IS NOT NULL 
  drop table dbo.ztmp_lobattribute; 
go 
select lobid, lobattributeid, count(*) as icount 
into ztmp_lobattribute
from lob_lobattribute 
group by lobid, lobattributeid
having count(*) > 1
go 

delete from lob_lobattribute where (
	select count(*) from ztmp_lobattribute 
	where lobid = lob_lobattribute.lobid 
		and lobattributeid = lob_lobattribute.lobattributeid
) > 0 
go 

insert into lob_lobattribute ( 
	lobid, lobattributeid 
) 
select 
	lobid, lobattributeid 
from ztmp_lobattribute
go 

drop table ztmp_lobattribute 
go 

alter table lob_lobattribute add constraint pk_lob_lobattribute primary key (lobid, lobattributeid)
go 
create index ix_lobid on lob_lobattribute (lobid) 
go 
create index ix_lobattributeid on lob_lobattribute (lobattributeid) 
go 

delete from lob_lobattribute where lobid not in (
	select objid from lob where objid = lob_lobattribute.lobid
)
go 
delete from lob_lobattribute where lobattributeid not in (
	select objid from lobattribute where objid = lob_lobattribute.lobattributeid
) 
go

alter table lob_lobattribute add constraint fk_lob_lobattribute_lobid 
	foreign key (lobid) references lob (objid)
go 
alter table lob_lobattribute add constraint fk_lob_lobattribute_lobattributeid
	foreign key (lobattributeid) references lobattribute (objid)
go 

alter table fundgroup alter column [title] varchar(100) NOT NULL 
go 
create index ix_title on fundgroup (title) 
go 


delete from entityjuridical where objid not in (
	select objid from entity 
	where objid = entityjuridical.objid
) 
go 
alter table entityjuridical add constraint fk_entityjuridical_objid
	foreign key (objid) references entity (objid)
go 

delete from entityindividual where objid not in (
	select objid from entity 
	where objid = entityindividual.objid
) 
go 
alter table entityjuridical add constraint fk_entityjuridical_objid
	foreign key (objid) references entity (objid)
go 

if object_id('dbo.ztmp_invalid_entityindividual', 'U') IS NOT NULL 
  drop table dbo.ztmp_invalid_entityindividual; 
go 
select ei.* 
into ztmp_invalid_entityindividual 
from entityindividual ei 
	left join entity e on e.objid = ei.objid
where e.objid is null 
go 
delete from entityindividual where objid in (
	select objid from ztmp_invalid_entityindividual 
)
go 

alter table entityindividual add constraint fk_entityindividual_objid
	foreign key (objid) references entity (objid)
go 

create index ix_address_objid on entity (address_objid)
go 

create unique index uix_controlno on remittance (controlno) 
go 
create index ix_dtposted on remittance (dtposted) 
go 
create index ix_collector_objid on remittance (collector_objid) 
go 
create index ix_collector_name on remittance (collector_name) 
go 
create index ix_liquidatingofficer_objid on remittance (liquidatingofficer_objid) 
go 
create index ix_liquidatingofficer_name on remittance (liquidatingofficer_name) 
go 
create index ix_controldate on remittance (controldate) 
go 
create index ix_collectionvoucherid on remittance (collectionvoucherid) 
go 

alter table collectionvoucher add constraint fk_collectionvoucher_depositvoucherid
	foreign key (depositvoucherid) references depositvoucher (objid) 
go 



alter table lob add psic_objid varchar(50) null 
go 
create index ix_psic_objid on lob (psic_objid) 
go 

