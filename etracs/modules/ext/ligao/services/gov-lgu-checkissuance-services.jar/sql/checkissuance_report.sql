[getIssuedCheckListing]
select
	cb.stubno, ci.checkno, ci.checkdate, ci.payee_name,
	ci.amount, ci.particulars, cb.bankaccount_fund_code,
	cb.bankaccount_fund_title, cb.bankaccount_bank_code,
	cb.bankaccount_bank_name, ci.gross, ci.retention,
	ci.tax, ci.office, ci.fpp, ci.acctcode, ci.alobs, ci.voucher
from checkissuance ci
inner join checkbook cb on ci.checkbook_objid = cb.objid
where ci.checkdate >= $P{startdate}
and ci.checkdate < $P{enddate}
and cb.bankaccount_fund_objid like $P{fundid}
order by checkdate desc, checkno
