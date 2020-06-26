drop table if exists sync_data_forprocess
;
drop table if exists sync_data_pending
;
drop table if exists sync_data
;

CREATE TABLE `syncdata_forsync` (
  `objid` varchar(50) NOT NULL,
  `reftype` varchar(100) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(100) NOT NULL,
  `orgid` varchar(25) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  `createdby_title` varchar(100) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_createdbyid` (`createdby_objid`),
  KEY `ix_reftype` (`reftype`) USING BTREE,
  KEY `ix_refno` (`refno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `syncdata` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `action` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `orgid` varchar(50) DEFAULT NULL,
  `remote_orgid` varchar(50) DEFAULT NULL,
  `remote_orgcode` varchar(20) DEFAULT NULL,
  `remote_orgclass` varchar(20) DEFAULT NULL,
  `sender_objid` varchar(50) DEFAULT NULL,
  `sender_name` varchar(150) DEFAULT NULL,
  `fileid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_reftype` (`reftype`),
  KEY `ix_refno` (`refno`),
  KEY `ix_orgid` (`orgid`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_fileid` (`fileid`),
  KEY `ix_refid` (`refid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `syncdata_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(255) NOT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `error` text,
  `idx` int(255) NOT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  CONSTRAINT `fk_syncdataitem_syncdata` FOREIGN KEY (`parentid`) REFERENCES `syncdata` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;



CREATE TABLE `syncdata_forprocess` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  CONSTRAINT `fk_syncdata_forprocess_syncdata_item` FOREIGN KEY (`objid`) REFERENCES `syncdata_item` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `syncdata_pending` (
  `objid` varchar(50) NOT NULL,
  `error` text,
  `expirydate` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_expirydate` (`expirydate`),
  CONSTRAINT `fk_syncdata_pending_syncdata` FOREIGN KEY (`objid`) REFERENCES `syncdata` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;




/* PREVTAXABILITY */
alter table faas_previous add prevtaxability varchar(10)
;


update faas_previous pf, faas f, rpu r set 
  pf.prevtaxability = case when r.taxable = 1 then 'TAXABLE' else 'EXEMPT' end 
where pf.prevfaasid = f.objid
and f.rpuid = r.objid 
and pf.prevtaxability is null 
;



/* 255-03020 */

alter table syncdata_item add async int default 0
;
alter table syncdata_item add dependedaction varchar(100)
;

create index ix_state on syncdata(state)
;
create index ix_state on syncdata_item(state)
;

create table syncdata_offline_org (
  orgid varchar(50) not null,
  expirydate datetime not null,
  primary key(orgid)
)
;




/*=======================================
*
*  QRRPA: Mixed-Use Support
*
=======================================*/

drop view if exists vw_rpu_assessment
;

create view vw_rpu_assessment as 
select 
  r.objid,
  r.rputype,
  dpc.objid as dominantclass_objid,
  dpc.code as dominantclass_code,
  dpc.name as dominantclass_name,
  dpc.orderno as dominantclass_orderno,
  ra.areasqm,
  ra.areaha,
  ra.marketvalue,
  ra.assesslevel,
  ra.assessedvalue,
  ra.taxable,
  au.code as actualuse_code, 
  au.name  as actualuse_name,
  auc.objid as actualuse_objid,
  auc.code as actualuse_classcode,
  auc.name as actualuse_classname,
  auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join landassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
  r.objid,
  r.rputype,
  dpc.objid as dominantclass_objid,
  dpc.code as dominantclass_code,
  dpc.name as dominantclass_name,
  dpc.orderno as dominantclass_orderno,
  ra.areasqm,
  ra.areaha,
  ra.marketvalue,
  ra.assesslevel,
  ra.assessedvalue,
  ra.taxable,
  au.code as actualuse_code, 
  au.name  as actualuse_name,
  auc.objid as actualuse_objid,
  auc.code as actualuse_classcode,
  auc.name as actualuse_classname,
  auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join bldgassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
  r.objid,
  r.rputype,
  dpc.objid as dominantclass_objid,
  dpc.code as dominantclass_code,
  dpc.name as dominantclass_name,
  dpc.orderno as dominantclass_orderno,
  ra.areasqm,
  ra.areaha,
  ra.marketvalue,
  ra.assesslevel,
  ra.assessedvalue,
  ra.taxable,
  au.code as actualuse_code, 
  au.name  as actualuse_name,
  auc.objid as actualuse_objid,
  auc.code as actualuse_classcode,
  auc.name as actualuse_classname,
  auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join machassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
  r.objid,
  r.rputype,
  dpc.objid as dominantclass_objid,
  dpc.code as dominantclass_code,
  dpc.name as dominantclass_name,
  dpc.orderno as dominantclass_orderno,
  ra.areasqm,
  ra.areaha,
  ra.marketvalue,
  ra.assesslevel,
  ra.assessedvalue,
  ra.taxable,
  au.code as actualuse_code, 
  au.name  as actualuse_name,
  auc.objid as actualuse_objid,
  auc.code as actualuse_classcode,
  auc.name as actualuse_classname,
  auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join planttreeassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
  r.objid,
  r.rputype,
  dpc.objid as dominantclass_objid,
  dpc.code as dominantclass_code,
  dpc.name as dominantclass_name,
  dpc.orderno as dominantclass_orderno,
  ra.areasqm,
  ra.areaha,
  ra.marketvalue,
  ra.assesslevel,
  ra.assessedvalue,
  ra.taxable,
  au.code as actualuse_code, 
  au.name  as actualuse_name,
  auc.objid as actualuse_objid,
  auc.code as actualuse_classcode,
  auc.name as actualuse_classname,
  auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join miscassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid
;


