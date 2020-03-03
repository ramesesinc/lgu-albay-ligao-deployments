USE eor
go 

CREATE TABLE eor_payment_error (
  objid varchar(50) NOT NULL,
  txndate datetime NOT NULL,
  txntype varchar(50) NOT NULL,
  paymentrefid varchar(50) NOT NULL,
  errmsg varchar(max) NOT NULL,
  errdetail varchar(max),
  constraint pk_eor_payment_error PRIMARY KEY (objid)
) 
go 
create index ix_txndate on eor_payment_error (txndate) 
go 
create index ix_txntype on eor_payment_error (txntype) 
go 
create index ix_paymentrefid on eor_payment_error (paymentrefid) 
go 


CREATE TABLE eor_paymentorder_paid (
  objid varchar(50) NOT NULL,
  txndate datetime NULL,
  txntype varchar(50) NULL,
  txntypename varchar(100) NULL,
  payer_objid varchar(50) NULL,
  payer_name varchar(max) null,
  paidby varchar(max) null,
  paidbyaddress varchar(150) NULL,
  particulars text,
  amount decimal(16,2) NULL,
  expirydate date NULL,
  refid varchar(50) NULL,
  refno varchar(50) NULL,
  info varchar(max) null,
  origin varchar(100) NULL,
  controlno varchar(50) NULL,
  locationid varchar(25) NULL,
  items varchar(max) null,
  state varchar(10) NULL,
  email varchar(255) NULL,
  mobileno varchar(50) NULL,
  constraint pk_eor_paymentorder_paid PRIMARY KEY (objid) 
) 
go 
create index ix_txndate on eor_paymentorder_paid (txndate) 
go 
create index ix_txntype on eor_paymentorder_paid (txntype) 
go 
create index ix_payer_objid on eor_paymentorder_paid (payer_objid) 
go 
create index ix_expirydate on eor_paymentorder_paid (expirydate) 
go 
create index ix_refid on eor_paymentorder_paid (refid) 
go 
create index ix_refno on eor_paymentorder_paid (refno) 
go 
create index ix_controlno on eor_paymentorder_paid (controlno) 
go 
create index ix_locationid on eor_paymentorder_paid (locationid) 
go 


CREATE TABLE eor_paymentorder_cancelled (
  objid varchar(50) NOT NULL,
  txndate datetime NULL,
  txntype varchar(50) NULL,
  txntypename varchar(100) NULL,
  payer_objid varchar(50) NULL,
  payer_name varchar(max) null,
  paidby varchar(max) null,
  paidbyaddress varchar(150) NULL,
  particulars text,
  amount decimal(16,2) NULL,
  expirydate date NULL,
  refid varchar(50) NULL,
  refno varchar(50) NULL,
  info varchar(max) null,
  origin varchar(100) NULL,
  controlno varchar(50) NULL,
  locationid varchar(25) NULL,
  items varchar(max) null,
  state varchar(10) NULL,
  email varchar(255) NULL,
  mobileno varchar(50) NULL,
  constraint pk_eor_paymentorder_cancelled PRIMARY KEY (objid) 
) 
go 
create index ix_txndate on eor_paymentorder_cancelled (txndate) 
go 
create index ix_txntype on eor_paymentorder_cancelled (txntype) 
go 
create index ix_payer_objid on eor_paymentorder_cancelled (payer_objid) 
go 
create index ix_expirydate on eor_paymentorder_cancelled (expirydate) 
go 
create index ix_refid on eor_paymentorder_cancelled (refid) 
go 
create index ix_refno on eor_paymentorder_cancelled (refno) 
go 
create index ix_controlno on eor_paymentorder_cancelled (controlno) 
go 
create index ix_locationid on eor_paymentorder_cancelled (locationid) 
go 

insert into eor_paymentorder_paid ( 
	objid, txndate, txntype, txntypename, payer_objid, payer_name, paidby, paidbyaddress, 
	particulars, amount, expirydate, refid, refno, info, origin, controlno, locationid, 
	items, state, email 
) 
select 
	po.objid, po.txndate, po.txntype, po.txntypename, po.payer_objid, po.payer_name, po.paidby, po.paidbyaddress, 
	po.particulars, po.amount, po.expirydate, po.refid, po.refno, po.info, po.origin, po.controlno, po.locationid, 
	po.items, po.state, po.email 
from eor, eor_paymentorder po 
where eor.paymentrefid = po.objid 
; 

delete from eor_paymentorder where objid in (select objid from eor_paymentorder_paid); 
delete from eor_paymentorder where objid in (select objid from eor_paymentorder_cancelled); 
