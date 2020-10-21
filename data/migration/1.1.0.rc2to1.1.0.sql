
-- make id free for depth min and max
UPDATE gn_imports.dict_fields
SET order_field = order_field + 2 
WHERE order_field >= 8 AND id_theme = (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='statement_info');
-- Prise en compte des nouveaux champs, champs supprimés et renommés de la synthèse
INSERT INTO gn_imports.dict_fields (name_field, fr_label, eng_label, desc_field, type_field, 
  synthese_field, mandatory, autogenerated, nomenclature, id_theme, order_field, display, comment
) VALUES
	('hour_min', 'Heure min', '', '', 'text', FALSE, FALSE, FALSE, FALSE, 
    (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='statement_info'), 4, TRUE, 
    'Correspondance champs standard: heureDebut'
  ),
  ('hour_max', 'Heure max', '', '', 'text', FALSE, FALSE, FALSE, FALSE, 
    (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='statement_info'), 5, TRUE, 
    'Correspondance champs standard: heureFin'
  ),
	('depth_min', 'Profondeur min', '', '', 'integer', TRUE, FALSE, FALSE, FALSE, 
    (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='statement_info'), 9, TRUE, 
    'Correspondance champs standard: profondeurMin'
  ),
	('depth_max', 'Profondeur max', '', '', 'integer', TRUE, FALSE, FALSE, FALSE, 
    (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='statement_info'), 10, TRUE, 
    'Correspondance champs standard: profondeurMax'
  ),
	('place_name', 'Nom du lieu', '', '', 'character varying(500)', TRUE, FALSE, FALSE, TRUE, 
    (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='statement_info'), 24, TRUE, 
    'Correspondance champs standard: nomLieu'
  ),
	('precision', 'Précision du pointage (m)', '', '', 'integer', TRUE, FALSE, FALSE, TRUE, 
    (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='statement_info'), 25, TRUE, 
    'Correspondance champs standard: precisionGeometrie'
  ),	
	('cd_hab', 'Code habitat', '', '', 'integer', TRUE, FALSE, FALSE, TRUE, 
    (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='statement_info'), 26, TRUE, 
    'Correspondance champs standard: CodeHabitatValue'
  ),
	('grp_method', 'Méthode de regroupement', '', '', 'character varying(255)', TRUE, FALSE, FALSE, TRUE, 
    (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='statement_info'), 27, TRUE, 
    'Correspondance champs standard: methodeRegroupement'
    ),

  ('additionnal_data', 'Champs additionnels', '', '', 'jsonb', TRUE, FALSE, FALSE, TRUE,
    (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='occurrence_sensitivity'), 16, 
    FALSE, 'Attributs additionnels'
  ), -- Ajouter un thème dédié à terme et prévoir un widget multiselect qui concatène les infos sous format jsonb ?
	('id_nomenclature_behaviour', 'Comportement', '', '', 'integer', TRUE, FALSE, FALSE, TRUE, 
    (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='occurrence_sensitivity'), 15, 
    TRUE, 'Correspondance champs standard: occComportement'
  ),
;

DELETE FROM gn_imports.dict_fields
WHERE name_field='id_nomenclature_obs_technique';

DELETE FROM gn_imports.dict_fields
WHERE name_field='sample_number_proof';


UPDATE gn_imports.dict_fields
SET fr_label='Existence d''une preuve'
WHERE name_field='id_nomenclature_exist_proof';

UPDATE gn_imports.dict_fields
SET name_field='id_nomenclature_obs_technique',
comment='Correspondance champs standard: obsTechnique'
WHERE name_field='id_nomenclature_obs_meth';

INSERT INTO gn_imports.cor_synthese_nomenclature (mnemonique, synthese_col) VALUES
('OCC_COMPORTEMENT', 'id_nomenclature_behaviour');

UPDATE gn_imports.cor_synthese_nomenclature
SET synthese_col='id_nomenclature_obs_technique'
WHERE mnemonique='METH_OBS';

DELETE FROM gn_imports.cor_synthese_nomenclature
WHERE mnemonique='TECHNIQUE_OBS';


INSERT INTO gn_imports.t_user_errors (error_type,"name",description,error_level) VALUES 
('Erreur d''incohérence','DEPTH_MIN_SUP_ALTI_MAX','profondeur min > profondeur max','ERROR')
,('Erreur de référentiel','CD_HAB_NOT_FOUND','Le cdHab indiqué n’est pas dans le référentiel HABREF ; la valeur de cdHab n’a pu être trouvée dans la version courante du référentiel.','ERROR')
;

UPDATE gn_imports.t_user_errors
SET error_type = 'Erreur d''incohérence' WHERE "name" = 'CD_NOM_NOT_FOUND';


-- rename name field id_nomenclature_bluring
UPDATE gn_imports.dict_fields 
SET fr_label = 'Floutage sur la donnée'
WHERE name_field = 'id_nomenclature_blurring';


UPDATE gn_imports.dict_fields 
SET comment = 'Correspondance champs standard: identifiantOrigine'
WHERE name_field = 'entity_source_pk_value';

UPDATE gn_imports.dict_fields 
SET comment = 'Correspondance champs standard: identifiantPermanent'
WHERE name_field = 'unique_id_sinp';

UPDATE gn_imports.dict_fields 
SET comment = 'Correspondance champs standard: versionTAXREF',
display = FALSE
WHERE name_field = 'meta_v_taxref';

UPDATE gn_imports.dict_fields 
SET comment = 'UUID du regroupement. Correspondance champs standard: identifiantRegroupementPermanent'
WHERE name_field = 'unique_id_sinp_grp';

UPDATE gn_imports.dict_fields 
SET comment = 'Correspondance champs standard: identiteObservateur. Format attendu : Nom Prénom (Organisme), Nom Prénom (Organisme)...'
WHERE name_field = 'observers';

UPDATE gn_imports.dict_fields 
SET comment = 'Correspondance champs standard: codeCommune. Code INSEE attendu'
WHERE name_field = 'codecommune';

UPDATE gn_imports.dict_fields 
SET comment = 'Correspondance champs standard: codeMaille. Code maille-10 MNHN attendu'
WHERE name_field = 'codemaille';

UPDATE gn_imports.dict_fields 
SET comment = 'Correspondance champs standard: codeDepartement. Code INSEE attendu'
WHERE name_field = 'codedepartement';

UPDATE gn_imports.dict_fields 
SET comment = 'Correspondance champs standard: codeDepartement. Code INSEE attendu'
WHERE name_field = 'codemaille';

UPDATE gn_imports.dict_fields 
SET comment = 'Correspondance champs standard: urlPreuveNumerique.'
WHERE name_field = 'digital_proof';

UPDATE gn_imports.dict_fields 
SET comment = 'Correspondance champs standard: nivVal. Validation producteur'
WHERE name_field = 'id_nomenclature_valid_status';

UPDATE gn_imports.dict_fields 
SET comment = 'Correspondance champs standard: validateur. Format attendu : Nom Prénom (Organisme), Nom Prénom (Organisme)...'
WHERE name_field = 'validator';

UPDATE gn_imports.dict_fields 
SET comment = 'Correspondance champs standard: DateCtrl (Validation producteur)'
WHERE name_field = 'meta_validation_date';

UPDATE gn_imports.dict_fields 
SET comment = 'Correspondance champs standard: DateCtrl (Validation producteur)'
WHERE name_field = 'meta_validation_date';

UPDATE gn_imports.dict_fields 
SET mandatory = FALSE
WHERE name_field = 'id_nomenclature_source_status';

UPDATE gn_imports.dict_fields 
SET comment = 'Fournir un id_role GeoNature'
WHERE name_field = 'id_digitiser';

UPDATE gn_imports.dict_fields
SET fr_label='Identifiant de l''auteur de la saisie (id_role dans l''instance cible)',
display=False
WHERE name_field='id_digitiser';

-- Remplacement de id_nomenclature_obs_meth vers id_nomenclature_obs_technique (nouveau) dans les mappings existants
UPDATE gn_imports.t_mappings_fields
SET target_field='id_nomenclature_obs_technique'
WHERE target_field='id_nomenclature_obs_meth';


	-- Ajout de la nomenclature comportement aux mappings SINP par défaut s'ils existent
-- Intégration du mapping de valeurs SINP (labels) par défaut pour les nomenclatures de la synthèse 
INSERT INTO gn_imports.t_mappings_values (id_mapping, source_value, id_target_value)
SELECT
m.id_mapping, 
n.label_default,
n.id_nomenclature
FROM gn_imports.t_mappings m, ref_nomenclatures.t_nomenclatures n
JOIN ref_nomenclatures.bib_nomenclatures_types bnt ON bnt.id_type=n.id_type 
WHERE m.mapping_label='Nomenclatures SINP (labels)' AND bnt.mnemonique='OCC_COMPORTEMENT';

INSERT INTO gn_imports.t_mappings_values (id_mapping, source_value, id_target_value)
SELECT
m.id_mapping,
n.cd_nomenclature,
n.id_nomenclature
FROM gn_imports.t_mappings m, ref_nomenclatures.t_nomenclatures n
JOIN ref_nomenclatures.bib_nomenclatures_types bnt ON bnt.id_type=n.id_type 
WHERE m.mapping_label='Nomenclatures SINP (codes)' AND bnt.mnemonique='OCC_COMPORTEMENT';

DELETE FROM gn_imports.t_mappings_fields
WHERE id_mapping = (SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature');

INSERT INTO gn_imports.t_mappings_fields (id_mapping, source_field, target_field, is_selected, is_added)
VALUES 
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'permid','unique_id_sinp',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'idsynthese','entity_source_pk_value',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'permidgrp','unique_id_sinp_grp',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), '','unique_id_sinp_generate',false,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), '','meta_create_date',false,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'vtaxref','meta_v_taxref',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), '','meta_update_date',false,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'datedebut','date_min',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'datefin','date_max',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'heuredebut','hour_min',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'heurefin','hour_max',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'altmin','altitude_min',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'altmax','altitude_max',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'profmin','depth_min',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'profmax','depth_max',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), '','altitudes_generate',false,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'x_centroid','longitude',false,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'y_centroid','latitude',false,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'observer','observers',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'obsdescr','comment_description',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'typinfgeo','id_nomenclature_info_geo_type',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'typGrp','id_nomenclature_grp_typ',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'nomcite','nom_cite',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'cdnom','cd_nom',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'obsmeth','id_nomenclature_obs_technique',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'ocstatbio','id_nomenclature_bio_status',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'ocetatbio','id_nomenclature_bio_condition',false,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'ocnat','id_nomenclature_naturalness',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'obsctx','comment_context',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'sensiniv','id_nomenclature_sensitivity',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'difnivprec','id_nomenclature_diffusion_level',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'deeflou','id_nomenclature_blurring',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'ocstade','id_nomenclature_life_stage',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'ocsex','id_nomenclature_sex',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'denbrtyp','id_nomenclature_type_count',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'objdenbr','id_nomenclature_obj_count',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'denbrmin','count_min',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'denbrmax','count_max',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'ocMethDet','id_nomenclature_determination_method',false,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'detminer','determiner',false,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'id_digitiser','id_digitiser',false,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'preuveoui','id_nomenclature_exist_proof',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'urlpreuv','digital_proof',false,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'preuvnonum','non_digital_proof',false,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'nivval','id_nomenclature_valid_status',false,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'validateur','validator',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'datectrl','meta_validation_date',false,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), '','validation_comment',false,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'natObjGeo','id_nomenclature_geo_object_nature',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'obstech','id_nomenclature_obs_technique',false,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'statobs','id_nomenclature_observation_status',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'statsource','id_nomenclature_source_status',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'refbiblio','reference_biblio',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'cdhab','cd_hab',true,false),

((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'geometry','WKT',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'gn_1_the_geom_point_2','the_geom_point',false,true),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'gn_1_the_geom_local_2','the_geom_local',false,true),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'gn_1_the_geom_4326_2','the_geom_4326',false,true),

((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'codecommune','codecommune',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'codemaille','codemaille',true,false),
((SELECT id_mapping FROM gn_imports.t_mappings WHERE mapping_label='Synthèse GeoNature'), 'codedepartement','codedepartement',true,false)

;