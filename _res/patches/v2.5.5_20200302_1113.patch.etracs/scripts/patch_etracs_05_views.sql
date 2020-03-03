if object_id('dbo.vw_income_summary', 'V') IS NOT NULL 
  drop view dbo.vw_income_summary; 
go 
create view vw_income_summary as 
select 
  inc.*, fund.groupid as fundgroupid, 
  ia.objid as itemid, ia.code as itemcode, ia.title as itemtitle, ia.type as itemtype  
from income_summary inc 
  inner join fund on fund.objid = inc.fundid 
  inner join itemaccount ia on ia.objid = inc.acctid 

GO



if object_id('dbo.sys_user_role', 'V') IS NOT NULL 
  drop view dbo.sys_user_role; 
go 
create view sys_user_role AS 
select  
	u.objid AS objid, 
	u.lastname AS lastname, 
	u.firstname AS firstname, 
	u.middlename AS middlename, 
	u.username AS username,
	(u.lastname +', '+ u.firstname +(case when u.middlename is null then '' else (' '+ u.middlename) end)) AS name, 
	ug.role AS role, 
	ug.domain AS domain, 
	ugm.org_objid AS orgid, 
	u.txncode AS txncode, 
	u.jobtitle AS jobtitle, 
	ugm.objid AS usergroupmemberid, 
	ugm.usergroup_objid AS usergroup_objid,
	ugm.org_objid as respcenter_objid, 
	ugm.org_name as respcenter_name 
from sys_usergroup_member ugm 
	inner join sys_usergroup ug on ug.objid = ugm.usergroup_objid 
	inner join sys_user u on u.objid = ugm.user_objid 
go 

