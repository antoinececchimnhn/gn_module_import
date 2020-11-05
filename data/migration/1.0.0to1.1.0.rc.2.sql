 --------------
 --GN_IMPORTS--
 --------------



ALTER TABLE gn_imports.t_user_errors
ALTER COLUMN description TYPE text,
ADD COLUMN error_level character varying(25)
;

ALTER TABLE gn_imports.t_user_error_list
ADD COLUMN id_rows integer[],
ADD COLUMN comment text,
DROP COLUMN count_error;

ALTER TABLE gn_imports.t_imports
ADD COLUMN uuid_autogenerated boolean,
ADD COLUMN altitude_autogenerated boolean,
ADD COLUMN processing boolean DEFAULT FALSE,
ADD COLUMN in_error boolean DEFAULT FALSE
;

ALTER TABLE gn_imports.t_mappings
ADD COLUMN temporary boolean NOT NULL DEFAULT FALSE;

ALTER TABLE gn_imports.dict_fields
ADD COLUMN comment text;

INSERT INTO gn_imports.dict_fields (name_field, fr_label, eng_label, desc_field, type_field, 
  synthese_field, mandatory, autogenerated, nomenclature, id_theme, order_field, display, comment
) VALUES
  ('codecommune', 'Code commune', '', '', 'integer', FALSE, TRUE, FALSE, FALSE, 
    (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='statement_info'), 14, TRUE, NULL
  ),
('codemaille', 'Code maille', '', '', 'integer', FALSE, TRUE, FALSE, FALSE, 
  (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='statement_info'), 15, TRUE, NULL),
	('codedepartement', 'Code département', '', '', 'integer', FALSE, TRUE, FALSE, FALSE, 
  (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='statement_info'), 16, TRUE, NULL)
;



CREATE VIEW gn_imports.v_imports_errors AS 
SELECT 
id_user_error,
id_import,
error_type,
name AS error_name,
error_level,
description AS error_description,
column_error,
id_rows,
comment
FROM  gn_imports.t_user_error_list el 
JOIN gn_imports.t_user_errors ue on ue.id_error = el.id_error;
