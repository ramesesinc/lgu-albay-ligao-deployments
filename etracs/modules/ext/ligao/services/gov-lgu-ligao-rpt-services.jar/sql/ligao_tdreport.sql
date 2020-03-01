[getStandardLandAssessment]
SELECT 
	pc.code AS classcode, pc.name AS classification, 
	lspc.code as specificcode, lspc.name as specificclass,  
	case when lal.objid is not null then lal.code else ptl.code end AS actualusecode,
	case when lal.objid is not null then lal.name else ptl.name end AS actualuse,
	SUM(case when pc.name = 'AGRICULTURAL' then r.areaha else r.areasqm end ) AS area,
	case when pc.name = 'AGRICULTURAL' then 'HA' else 'SQM' end as areatype,
	r.assesslevel,
	SUM(r.marketvalue) AS marketvalue,
	SUM(r.assessedvalue) AS assessedvalue,
	SUM(r.areasqm) AS areasqm,
	SUM(r.areaha) AS areaha 
FROM faas f
	INNER JOIN rpu_assessment r ON f.rpuid = r.rpuid
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	LEFT JOIN landdetail ld on r.rpuid=ld.landrpuid 
	LEFT JOIN lcuvspecificclass spc ON ld.specificclass_objid=spc.objid 
	left join landspecificclass lspc on spc.landspecificclass_objid = lspc.objid 
	LEFT JOIN landassesslevel lal ON r.actualuse_objid = lal.objid 
	LEFT JOIN planttreeassesslevel ptl ON r.actualuse_objid = ptl.objid 
WHERE f.objid = $P{faasid} 
GROUP BY 
	pc.code, pc.name, lspc.code, lspc.name, 
	case when lal.objid is not null then lal.code else ptl.code end,
	case when lal.objid is not null then lal.name else ptl.name end,
	r.assesslevel 
