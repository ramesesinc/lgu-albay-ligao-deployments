INSERT INTO sys_usergroup (objid, title, domain, userclass, orgclass, role) 
select * 
from ( 
	SELECT 
		'RULEMGMT.DEV' as objid, 'RULEMGMT DEVELOPER' as title, 
		'RULEMGMT' as domain, 'usergroup' as userclass, NULL as orgclass, 
		'DEV' as role
	union all 
	SELECT 
		'WORKFLOW.DEV' as objid, 'WORKFLOW DEVELOPER' as title, 
		'WORKFLOW' as domain, 'usergroup' as userclass, NULL as orgclass, 
		'DEV' as role
)t1
where t1.objid not in (select objid from sys_usergroup where objid = t1.objid)
;

update sys_usergroup_permission set usergroup_objid='RULEMGMT.DEV' where usergroup_objid = 'RULEMGMT.MASTER'
;
update sys_usergroup_member set usergroup_objid='RULEMGMT.DEV' where usergroup_objid = 'RULEMGMT.MASTER'
;
delete from sys_usergroup where objid = 'RULEMGMT.MASTER'
; 


update sys_usergroup_permission set usergroup_objid='WORKFLOW.DEV' where usergroup_objid = 'WORKFLOW.MASTER'
;
update sys_usergroup_member set usergroup_objid='WORKFLOW.DEV' where usergroup_objid = 'WORKFLOW.MASTER'
;
delete from sys_usergroup where objid = 'WORKFLOW.MASTER'
; 
