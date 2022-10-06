create table specialty_list (specialty varchar);

CREATE TABLE IF NOT EXISTS location
(
    location_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    address_1 character varying(50) ENCODE lzo,
    address_2 character varying(50) ENCODE lzo,
    city character varying(50) ENCODE lzo,
    state character varying(2) ENCODE lzo,
    zip character varying(9) ENCODE lzo,
    county character varying(100) ENCODE lzo,
    location_source_value character varying(100) ENCODE lzo,
    country_concept_id numeric(38,0) ENCODE az64,
    country_source_value character varying(80) ENCODE lzo,
    latitude double precision,
    longitude double precision
)
DISTSTYLE AUTO;

ALTER TABLE location
ADD CONSTRAINT location_pkey
PRIMARY KEY(location_id);

CREATE TABLE IF NOT EXISTS care_site
(
    care_site_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    care_site_name character varying(255) ENCODE lzo,
    place_of_service_concept_id numeric(38,0) ENCODE az64,
    location_id numeric(38,0) ENCODE az64,
    care_site_source_value character varying(100) ENCODE lzo,
    place_of_service_source_value character varying(50) ENCODE lzo
)
DISTSTYLE AUTO;

ALTER TABLE care_site
ADD CONSTRAINT care_site_pkey
PRIMARY KEY(care_site_id);

ALTER TABLE care_site
ADD CONSTRAINT care_site_location_id_fkey
FOREIGN KEY(location_id) REFERENCES location(location_id);

CREATE TABLE IF NOT EXISTS cdm_source
(
    cdm_source_name character varying(255) NOT NULL ENCODE lzo,
    cdm_source_abbreviation character varying(25) NOT NULL ENCODE lzo,
    cdm_holder character varying(255) NOT NULL ENCODE lzo,
    source_description character varying(1000) ENCODE lzo,
    source_documentation_reference character varying(255) ENCODE lzo,
    cdm_etl_reference character varying(255) ENCODE lzo,
    source_release_date date NOT NULL ENCODE az64,
    cdm_release_date date NOT NULL ENCODE az64,
    cdm_version character varying(10) ENCODE lzo,
    cdm_version_concept_id numeric(38,0) ENCODE az64,
    vocabulary_version character varying(20) ENCODE lzo
)
DISTSTYLE AUTO;

CREATE TABLE IF NOT EXISTS cohort
(
    cohort_definition_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    subject_id numeric(38,0) NOT NULL ENCODE az64,
    cohort_start_date date NOT NULL ENCODE az64,
    cohort_end_date date NOT NULL ENCODE az64
)
DISTSTYLE AUTO;

ALTER TABLE cohort
ADD CONSTRAINT cohort_pkey
PRIMARY KEY(cohort_definition_id);

CREATE TABLE IF NOT EXISTS cohort_definition
(
    cohort_definition_id numeric(38,0) NOT NULL ENCODE az64,
    cohort_definition_name character varying(255) NOT NULL ENCODE lzo,
    cohort_definition_description character varying(65535) ENCODE lzo,
    definition_type_concept_id numeric(38,0) NOT NULL ENCODE az64,
    cohort_definition_syntax character varying(65535) ENCODE lzo,
    subject_concept_id numeric(38,0) NOT NULL ENCODE az64,
    cohort_initiation_date date ENCODE az64
)
DISTSTYLE AUTO;

CREATE TABLE IF NOT EXISTS concept
(
    concept_id numeric(38,0) NOT NULL ENCODE az64,
    concept_name character varying(1024) NOT NULL ENCODE lzo,
    domain_id character varying(20) NOT NULL ENCODE lzo,
    vocabulary_id character varying(20) NOT NULL ENCODE lzo,
    concept_class_id character varying(20) NOT NULL ENCODE lzo,
    standard_concept character varying(1) ENCODE lzo,
    concept_code character varying(50) NOT NULL ENCODE lzo,
    valid_start_date date NOT NULL ENCODE az64,
    valid_end_date date NOT NULL ENCODE az64,
    invalid_reason character varying(1) ENCODE lzo
)
DISTSTYLE AUTO;

CREATE TABLE IF NOT EXISTS concept_ancestor
(
    ancestor_concept_id numeric(38,0) NOT NULL ENCODE az64,
    descendant_concept_id numeric(38,0) NOT NULL ENCODE az64,
    min_levels_of_separation numeric(38,0) NOT NULL ENCODE az64,
    max_levels_of_separation numeric(38,0) NOT NULL ENCODE az64
)
DISTSTYLE AUTO;

CREATE TABLE IF NOT EXISTS concept_class
(
    concept_class_id character varying(20) NOT NULL ENCODE lzo,
    concept_class_name character varying(255) NOT NULL ENCODE lzo,
    concept_class_concept_id numeric(38,0) NOT NULL ENCODE az64
)
DISTSTYLE AUTO;

CREATE TABLE IF NOT EXISTS concept_relationship
(
    concept_id_1 numeric(38,0) NOT NULL ENCODE az64,
    concept_id_2 numeric(38,0) NOT NULL ENCODE az64,
    relationship_id character varying(20) NOT NULL ENCODE lzo,
    valid_start_date date NOT NULL ENCODE az64,
    valid_end_date date NOT NULL ENCODE az64,
    invalid_reason character varying(1) ENCODE lzo
)
DISTSTYLE AUTO;

CREATE TABLE IF NOT EXISTS concept_synonym
(
    concept_id numeric(38,0) NOT NULL ENCODE az64,
    concept_synonym_name character varying(2048) NOT NULL ENCODE lzo,
    language_concept_id numeric(38,0) NOT NULL ENCODE az64
)
DISTSTYLE AUTO;

CREATE TABLE IF NOT EXISTS provider
(
    provider_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    provider_name character varying(255) ENCODE lzo,
    npi character varying(20) ENCODE lzo,
    dea character varying(20) ENCODE lzo,
    specialty_concept_id numeric(38,0) ENCODE az64,
    care_site_id numeric(38,0) ENCODE az64,
    year_of_birth numeric(38,0) ENCODE az64,
    gender_concept_id numeric(38,0) ENCODE az64,
    provider_source_value character varying(100) ENCODE lzo,
    specialty_source_value character varying(125) ENCODE lzo,
    specialty_source_concept_id numeric(38,0) ENCODE az64,
    gender_source_value character varying(50) ENCODE lzo,
    gender_source_concept_id numeric(38,0) ENCODE az64,
    load_row_id character varying(100) ENCODE lzo,
    load_table_name character varying(255) ENCODE lzo,
    dupcount numeric(38,0) NOT NULL ENCODE az64
)
DISTSTYLE AUTO;

ALTER TABLE provider
ADD CONSTRAINT provider_pkey
PRIMARY KEY(provider_id);

ALTER TABLE provider
ADD CONSTRAINT provider_care_site_id_fkey
FOREIGN KEY(care_site_id) REFERENCES care_site(care_site_id);

CREATE TABLE IF NOT EXISTS person
(
    person_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    gender_concept_id numeric(38,0) NOT NULL ENCODE az64,
    year_of_birth numeric(38,0) NOT NULL ENCODE az64,
    month_of_birth numeric(38,0) ENCODE az64,
    day_of_birth numeric(38,0) ENCODE az64,
    birth_datetime timestamp without time zone ENCODE az64,
    race_concept_id numeric(38,0) NOT NULL ENCODE az64,
    ethnicity_concept_id numeric(38,0) NOT NULL ENCODE az64,
    location_id numeric(38,0) ENCODE az64,
    provider_id numeric(38,0) ENCODE az64,
    care_site_id numeric(38,0) ENCODE az64,
    person_source_value character varying(100) ENCODE lzo,
    gender_source_value character varying(50) ENCODE lzo,
    gender_source_concept_id numeric(38,0) ENCODE az64,
    race_source_value character varying(50) ENCODE lzo,
    race_source_concept_id numeric(38,0) ENCODE az64,
    ethnicity_source_value character varying(50) ENCODE lzo,
    ethnicity_source_concept_id numeric(38,0) ENCODE az64,
    anon_ims_pat_id character varying(16) ENCODE lzo
)
DISTSTYLE AUTO;

ALTER TABLE person
ADD CONSTRAINT person_pkey
PRIMARY KEY(person_id);

ALTER TABLE person
ADD CONSTRAINT person_care_site_id_fkey
FOREIGN KEY(care_site_id) REFERENCES care_site(care_site_id);

ALTER TABLE person
ADD CONSTRAINT person_location_id_fkey
FOREIGN KEY(location_id) REFERENCES location(location_id);

ALTER TABLE person
ADD CONSTRAINT person_provider_id_fkey
FOREIGN KEY(provider_id) REFERENCES provider(provider_id);

CREATE TABLE IF NOT EXISTS condition_era
(
    condition_era_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    person_id numeric(38,0) NOT NULL ENCODE az64,
    condition_concept_id numeric(38,0) NOT NULL ENCODE az64,
    condition_era_start_date date NOT NULL ENCODE az64,
    condition_era_end_date date NOT NULL ENCODE az64,
    condition_occurrence_count numeric(38,0) ENCODE az64
)
DISTSTYLE AUTO;

ALTER TABLE condition_era
ADD CONSTRAINT condition_era_pkey
PRIMARY KEY(condition_era_id);

ALTER TABLE condition_era
ADD CONSTRAINT condition_era_person_id_fkey
FOREIGN KEY(person_id) REFERENCES person(person_id);

CREATE TABLE IF NOT EXISTS visit_occurrence
(
    visit_occurrence_id numeric(38,0) NOT NULL ENCODE az64,
    person_id numeric(38,0) NOT NULL ENCODE az64,
    visit_concept_id numeric(38,0) NOT NULL ENCODE az64,
    visit_start_date date NOT NULL ENCODE az64,
    visit_start_datetime timestamp without time zone ENCODE az64,
    visit_end_date date NOT NULL ENCODE az64,
    visit_end_datetime timestamp without time zone ENCODE az64,
    visit_type_concept_id numeric(38,0) NOT NULL ENCODE az64,
    provider_id numeric(38,0) ENCODE az64,
    care_site_id numeric(38,0) ENCODE az64,
    visit_source_value character varying(200) ENCODE lzo,
    visit_source_concept_id numeric(38,0) ENCODE az64,
    admitted_from_concept_id numeric(38,0) ENCODE az64,
    admitted_from_source_value character varying(200) ENCODE lzo,
    discharged_to_concept_id numeric(38,0) ENCODE az64,
    discharged_to_source_value character varying(200) ENCODE lzo,
    preceding_visit_occurrence_id numeric(38,0) ENCODE az64
)
DISTSTYLE AUTO;

ALTER TABLE visit_occurrence
ADD CONSTRAINT visit_occurrence_pkey
PRIMARY KEY(visit_occurrence_id);

ALTER TABLE visit_occurrence
ADD CONSTRAINT visit_occurrence_care_site_id_fkey
FOREIGN KEY(care_site_id) REFERENCES care_site(care_site_id);

ALTER TABLE visit_occurrence
ADD CONSTRAINT visit_occurrence_person_id_fkey
FOREIGN KEY(person_id) REFERENCES person(person_id);

ALTER TABLE visit_occurrence
ADD CONSTRAINT visit_occurrence_provider_id_fkey
FOREIGN KEY(provider_id) REFERENCES provider(provider_id);

CREATE TABLE IF NOT EXISTS condition_occurrence
(
    condition_occurrence_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    person_id numeric(38,0) NOT NULL ENCODE az64,
    condition_concept_id numeric(38,0) NOT NULL ENCODE az64,
    condition_start_date date NOT NULL ENCODE az64,
    condition_start_datetime timestamp without time zone ENCODE az64,
    condition_end_date date ENCODE az64,
    condition_end_datetime timestamp without time zone ENCODE az64,
    condition_type_concept_id numeric(38,0) NOT NULL ENCODE az64,
    stop_reason character varying(20) ENCODE lzo,
    provider_id numeric(38,0) ENCODE az64,
    visit_occurrence_id numeric(38,0) ENCODE az64,
    visit_detail_id numeric(38,0) ENCODE az64,
    condition_source_value character varying(650) ENCODE lzo,
    condition_source_concept_id numeric(38,0) ENCODE az64,
    condition_status_source_value character varying(50) ENCODE lzo,
    condition_status_concept_id numeric(38,0) ENCODE az64
)
DISTSTYLE AUTO;

ALTER TABLE condition_occurrence
ADD CONSTRAINT condition_occurrence_pkey
PRIMARY KEY(condition_occurrence_id);

ALTER TABLE condition_occurrence
ADD CONSTRAINT condition_occurrence_person_id_fkey
FOREIGN KEY(person_id) REFERENCES person(person_id);

ALTER TABLE condition_occurrence
ADD CONSTRAINT condition_occurrence_provider_id_fkey
FOREIGN KEY(provider_id) REFERENCES provider(provider_id);

ALTER TABLE condition_occurrence
ADD CONSTRAINT condition_occurrence_visit_occurrence_id_fkey
FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence(visit_occurrence_id);

CREATE TABLE IF NOT EXISTS cost
(
    cost_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    cost_event_id numeric(38,0) NOT NULL ENCODE az64,
    cost_domain_id character varying(20) NOT NULL ENCODE lzo,
    cost_type_concept_id numeric(38,0) NOT NULL ENCODE az64,
    currency_concept_id numeric(38,0) ENCODE az64,
    total_charge double precision,
    total_cost double precision,
    total_paid double precision,
    paid_by_payer double precision,
    paid_by_patient double precision,
    paid_patient_copay double precision,
    paid_patient_coinsurance double precision,
    paid_patient_deductible double precision,
    paid_by_primary double precision,
    paid_ingredient_cost double precision,
    paid_dispensing_fee double precision,
    payer_plan_period_id numeric(38,0) ENCODE az64,
    amount_allowed double precision,
    revenue_code_concept_id numeric(38,0) ENCODE az64,
    revenue_code_source_value character varying(50) ENCODE lzo,
    drg_concept_id numeric(38,0) ENCODE az64,
    drg_source_value character varying(5) ENCODE lzo
)
DISTSTYLE AUTO;

ALTER TABLE cost
ADD CONSTRAINT cost_pkey
PRIMARY KEY(cost_id);

CREATE TABLE IF NOT EXISTS death
(
    person_id numeric(38,0) NOT NULL ENCODE az64,
    death_date date NOT NULL ENCODE az64,
    death_datetime timestamp without time zone ENCODE az64,
    death_type_concept_id numeric(38,0) NOT NULL ENCODE az64,
    cause_concept_id numeric(38,0) ENCODE az64,
    cause_source_value character varying(50) ENCODE lzo,
    cause_source_concept_id numeric(38,0) ENCODE az64
)
DISTSTYLE AUTO;

ALTER TABLE death
ADD CONSTRAINT death_person_id_fkey
FOREIGN KEY(person_id) REFERENCES person(person_id);

CREATE TABLE IF NOT EXISTS device_exposure
(
    device_exposure_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    person_id numeric(38,0) NOT NULL ENCODE az64,
    device_concept_id numeric(38,0) NOT NULL ENCODE az64,
    device_exposure_start_date date NOT NULL ENCODE az64,
    device_exposure_start_datetime timestamp without time zone ENCODE az64,
    device_exposure_end_date date ENCODE az64,
    device_exposure_end_datetime timestamp without time zone ENCODE az64,
    device_type_concept_id numeric(38,0) NOT NULL ENCODE az64,
    unique_device_id character varying(255) ENCODE lzo,
    production_id character varying(255) ENCODE lzo,
    quantity numeric(38,0) ENCODE az64,
    provider_id numeric(38,0) ENCODE az64,
    visit_occurrence_id numeric(38,0) ENCODE az64,
    visit_detail_id numeric(38,0) ENCODE az64,
    device_source_value character varying(650) ENCODE lzo,
    device_source_concept_id numeric(38,0) ENCODE az64,
    unit_concept_id numeric(38,0) ENCODE az64,
    unit_source_value character varying(50) ENCODE lzo,
    unit_source_concept_id numeric(38,0) ENCODE az64
)
DISTSTYLE AUTO;

ALTER TABLE device_exposure
ADD CONSTRAINT device_exposure_pkey
PRIMARY KEY(device_exposure_id);

ALTER TABLE device_exposure
ADD CONSTRAINT device_exposure_person_id_fkey
FOREIGN KEY(person_id) REFERENCES person(person_id);

ALTER TABLE device_exposure
ADD CONSTRAINT device_exposure_provider_id_fkey
FOREIGN KEY(provider_id) REFERENCES provider(provider_id);

ALTER TABLE device_exposure
ADD CONSTRAINT device_exposure_visit_occurrence_id_fkey
FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence(visit_occurrence_id);

CREATE TABLE IF NOT EXISTS domain
(
    domain_id character varying(20) NOT NULL ENCODE lzo,
    domain_name character varying(255) NOT NULL ENCODE lzo,
    domain_concept_id numeric(38,0) NOT NULL ENCODE az64
)
DISTSTYLE AUTO;

CREATE TABLE IF NOT EXISTS dose_era
(
    dose_era_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    person_id numeric(38,0) NOT NULL ENCODE az64,
    drug_concept_id numeric(38,0) NOT NULL ENCODE az64,
    unit_concept_id numeric(38,0) NOT NULL ENCODE az64,
    dose_value numeric(38,12) NOT NULL ENCODE az64,
    dose_era_start_date date NOT NULL ENCODE az64,
    dose_era_end_date date NOT NULL ENCODE az64
)
DISTSTYLE AUTO;

ALTER TABLE dose_era
ADD CONSTRAINT dose_era_pkey
PRIMARY KEY(dose_era_id);

ALTER TABLE dose_era
ADD CONSTRAINT dose_era_person_id_fkey
FOREIGN KEY(person_id) REFERENCES person(person_id);

CREATE TABLE IF NOT EXISTS drug_era
(
    drug_era_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    person_id numeric(38,0) NOT NULL ENCODE az64,
    drug_concept_id numeric(38,0) NOT NULL ENCODE az64,
    drug_era_start_date date NOT NULL ENCODE az64,
    drug_era_end_date date NOT NULL ENCODE az64,
    drug_exposure_count numeric(38,0) ENCODE az64,
    gap_days numeric(38,0) ENCODE az64
)
DISTSTYLE AUTO;

ALTER TABLE drug_era
ADD CONSTRAINT drug_era_pkey
PRIMARY KEY(drug_era_id);

ALTER TABLE drug_era
ADD CONSTRAINT drug_era_person_id_fkey
FOREIGN KEY(person_id) REFERENCES person(person_id);

CREATE TABLE IF NOT EXISTS drug_exposure
(
    drug_exposure_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    person_id numeric(38,0) NOT NULL ENCODE az64,
    drug_concept_id numeric(38,0) NOT NULL ENCODE az64,
    drug_exposure_start_date date NOT NULL ENCODE az64,
    drug_exposure_start_datetime timestamp without time zone ENCODE az64,
    drug_exposure_end_date date ENCODE az64,
    drug_exposure_end_datetime timestamp without time zone ENCODE az64,
    verbatim_end_date date ENCODE az64,
    drug_type_concept_id numeric(38,0) NOT NULL ENCODE az64,
    stop_reason character varying(50) ENCODE lzo,
    refills numeric(38,0) ENCODE az64,
    quantity numeric(38,5) ENCODE az64,
    days_supply numeric(38,0) ENCODE az64,
    sig character varying(500) ENCODE lzo,
    route_concept_id numeric(38,0) ENCODE az64,
    lot_number character varying(250) ENCODE lzo,
    provider_id numeric(38,0) ENCODE az64,
    visit_occurrence_id numeric(38,0) ENCODE az64,
    visit_detail_id numeric(38,0) ENCODE az64,
    drug_source_value character varying(650) ENCODE lzo,
    drug_source_concept_id numeric(38,0) ENCODE az64,
    route_source_value character varying(300) ENCODE lzo,
    dose_unit_source_value character varying(250) ENCODE lzo
)
DISTSTYLE AUTO;

ALTER TABLE drug_exposure
ADD CONSTRAINT drug_exposure_pkey
PRIMARY KEY(drug_exposure_id);

ALTER TABLE drug_exposure
ADD CONSTRAINT drug_exposure_person_id_fkey
FOREIGN KEY(person_id) REFERENCES person(person_id);

ALTER TABLE drug_exposure
ADD CONSTRAINT drug_exposure_provider_id_fkey
FOREIGN KEY(provider_id) REFERENCES provider(provider_id);

ALTER TABLE drug_exposure
ADD CONSTRAINT drug_exposure_visit_occurrence_id_fkey
FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence(visit_occurrence_id);

CREATE TABLE IF NOT EXISTS drug_strength
(
    drug_concept_id numeric(38,0) NOT NULL ENCODE az64,
    ingredient_concept_id numeric(38,0) NOT NULL ENCODE az64,
    amount_value numeric(18,5) ENCODE az64,
    amount_unit_concept_id numeric(38,0) ENCODE az64,
    numerator_value numeric(38,5) ENCODE az64,
    numerator_unit_concept_id numeric(38,0) ENCODE az64,
    denominator_value numeric(18,5) ENCODE az64,
    denominator_unit_concept_id numeric(38,0) ENCODE az64,
    box_size numeric(38,0) ENCODE az64,
    valid_start_date date NOT NULL ENCODE az64,
    valid_end_date date NOT NULL ENCODE az64,
    invalid_reason character varying(1) ENCODE lzo
)
DISTSTYLE AUTO;

CREATE TABLE IF NOT EXISTS episode
(
    episode_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    person_id numeric(38,0) NOT NULL ENCODE az64,
    episode_concept_id numeric(38,0) NOT NULL ENCODE az64,
    episode_start_date date NOT NULL ENCODE az64,
    episode_start_datetime timestamp without time zone ENCODE az64,
    episode_end_date date ENCODE az64,
    episode_end_datetime timestamp without time zone ENCODE az64,
    episode_parent_id numeric(38,0) ENCODE az64,
    episode_number numeric(38,0) ENCODE az64,
    episode_object_concept_id numeric(38,0) NOT NULL ENCODE az64,
    episode_type_concept_id numeric(38,0) NOT NULL ENCODE az64,
    episode_source_value character varying(50) ENCODE lzo,
    episode_source_concept_id numeric(38,0) ENCODE az64
)
DISTSTYLE AUTO;

CREATE TABLE IF NOT EXISTS episode_event
(
    episode_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    event_id numeric(38,0) NOT NULL ENCODE az64,
    episode_event_field_concept_id numeric(38,0) NOT NULL ENCODE az64
)
DISTSTYLE AUTO;

CREATE TABLE IF NOT EXISTS fact_relationship
(
    domain_concept_id_1 numeric(38,0) NOT NULL ENCODE az64,
    fact_id_1 numeric(38,0) NOT NULL ENCODE az64,
    domain_concept_id_2 numeric(38,0) NOT NULL ENCODE az64,
    fact_id_2 numeric(38,0) NOT NULL ENCODE az64,
    relationship_concept_id numeric(38,0) NOT NULL ENCODE az64
)
DISTSTYLE AUTO;

CREATE TABLE IF NOT EXISTS measurement
(
    measurement_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    person_id numeric(38,0) NOT NULL ENCODE az64,
    measurement_concept_id numeric(38,0) NOT NULL ENCODE az64,
    measurement_date date NOT NULL ENCODE az64,
    measurement_datetime timestamp without time zone ENCODE az64,
    measurement_time timestamp without time zone ENCODE az64,
    measurement_type_concept_id numeric(38,0) NOT NULL ENCODE az64,
    operator_concept_id numeric(38,0) ENCODE az64,
    value_as_number numeric(38,19) ENCODE az64,
    value_as_concept_id numeric(38,0) ENCODE az64,
    unit_concept_id numeric(38,0) ENCODE az64,
    range_low numeric(25,5) ENCODE az64,
    range_high numeric(25,5) ENCODE az64,
    provider_id numeric(38,0) ENCODE az64,
    visit_occurrence_id numeric(38,0) ENCODE az64,
    visit_detail_id numeric(38,0) ENCODE az64,
    measurement_source_value character varying(650) ENCODE lzo,
    measurement_source_concept_id numeric(38,0) ENCODE az64,
    unit_source_value character varying(300) ENCODE lzo,
    unit_source_concept_id numeric(38,0) ENCODE az64,
    value_source_value character varying(650) ENCODE lzo,
    measurement_event_id numeric(38,0) ENCODE az64,
    meas_event_field_concept_id numeric(38,0) ENCODE az64
)
DISTSTYLE AUTO;

ALTER TABLE measurement
ADD CONSTRAINT measurement_pkey
PRIMARY KEY(measurement_id);

ALTER TABLE measurement
ADD CONSTRAINT measurement_person_id_fkey
FOREIGN KEY(person_id) REFERENCES person(person_id);

ALTER TABLE measurement
ADD CONSTRAINT measurement_provider_id_fkey
FOREIGN KEY(provider_id) REFERENCES provider(provider_id);

ALTER TABLE measurement
ADD CONSTRAINT measurement_visit_occurrence_id_fkey
FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence(visit_occurrence_id);

CREATE TABLE IF NOT EXISTS metadata
(
    metadata_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    metadata_concept_id numeric(38,0) NOT NULL ENCODE az64,
    metadata_type_concept_id numeric(38,0) NOT NULL ENCODE az64,
    name character varying(250) NOT NULL ENCODE lzo,
    value_as_string character varying(512) ENCODE lzo,
    value_as_concept_id numeric(38,0) ENCODE az64,
    value_as_number double precision,
    metadata_date date ENCODE az64,
    metadata_datetime timestamp without time zone ENCODE az64
)
DISTSTYLE AUTO;

CREATE TABLE IF NOT EXISTS note
(
    note_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    person_id numeric(38,0) NOT NULL ENCODE az64,
    note_date date NOT NULL ENCODE az64,
    note_datetime timestamp without time zone ENCODE az64,
    note_type_concept_id numeric(38,0) NOT NULL ENCODE az64,
    note_class_concept_id numeric(38,0) NOT NULL ENCODE az64,
    note_title character varying(250) ENCODE lzo,
    note_text character varying(100) NOT NULL ENCODE lzo,
    encoding_concept_id numeric(38,0) NOT NULL ENCODE az64,
    language_concept_id numeric(38,0) NOT NULL ENCODE az64,
    provider_id numeric(38,0) ENCODE az64,
    visit_occurrence_id numeric(38,0) ENCODE az64,
    visit_detail_id numeric(38,0) ENCODE az64,
    note_source_value character varying(250) ENCODE lzo,
    note_event_id numeric(38,0) ENCODE az64,
    note_event_field_concept_id numeric(38,0) ENCODE az64,
    table_name character varying(128) ENCODE lzo,
    field_name character varying(128) ENCODE lzo,
    load_row_id character varying(100) ENCODE lzo
)
DISTSTYLE AUTO;

ALTER TABLE note
ADD CONSTRAINT note_pkey
PRIMARY KEY(note_id);

ALTER TABLE note
ADD CONSTRAINT note_person_id_fkey
FOREIGN KEY(person_id) REFERENCES person(person_id);

ALTER TABLE note
ADD CONSTRAINT note_provider_id_fkey
FOREIGN KEY(provider_id) REFERENCES provider(provider_id);

ALTER TABLE note
ADD CONSTRAINT note_visit_occurrence_id_fkey
FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence(visit_occurrence_id);

CREATE TABLE IF NOT EXISTS note_nlp
(
    note_nlp_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    note_id numeric(38,0) NOT NULL ENCODE az64,
    section_concept_id numeric(38,0) ENCODE az64,
    snippet character varying(250) ENCODE lzo,
    "offset" character varying(50) ENCODE lzo,
    lexical_variant character varying(250) NOT NULL ENCODE lzo,
    note_nlp_concept_id numeric(38,0) ENCODE az64,
    note_nlp_source_concept_id numeric(38,0) ENCODE az64,
    nlp_system character varying(250) ENCODE lzo,
    nlp_date date NOT NULL ENCODE az64,
    nlp_datetime timestamp without time zone ENCODE az64,
    term_exists character varying(1) ENCODE lzo,
    term_temporal character varying(50) ENCODE lzo,
    term_modifiers character varying(2000) ENCODE lzo,
    table_name character varying(128) ENCODE lzo,
    field_name character varying(128) ENCODE lzo,
    load_row_id character varying(100) ENCODE lzo
)
DISTSTYLE AUTO;

ALTER TABLE note_nlp
ADD CONSTRAINT note_nlp_pkey
PRIMARY KEY(note_nlp_id);

ALTER TABLE note_nlp
ADD CONSTRAINT note_nlp_note_id_fkey
FOREIGN KEY(note_id) REFERENCES note(note_id);

CREATE TABLE IF NOT EXISTS observation
(
    observation_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    person_id numeric(38,0) ENCODE az64,
    observation_concept_id numeric(38,0) ENCODE az64,
    observation_date date ENCODE az64,
    observation_datetime timestamp without time zone ENCODE az64,
    observation_type_concept_id numeric(38,0) ENCODE az64,
    value_as_number numeric(38,19) ENCODE az64,
    value_as_string character varying(650) ENCODE lzo,
    value_as_concept_id numeric(38,0) ENCODE az64,
    qualifier_concept_id numeric(38,0) ENCODE az64,
    unit_concept_id numeric(38,0) ENCODE az64,
    provider_id numeric(38,0) ENCODE az64,
    visit_occurrence_id numeric(38,0) ENCODE az64,
    visit_detail_id numeric(38,0) ENCODE az64,
    observation_source_value character varying(650) ENCODE lzo,
    observation_source_concept_id numeric(38,0) ENCODE az64,
    unit_source_value character varying(300) ENCODE lzo,
    qualifier_source_value character varying(300) ENCODE lzo,
    value_source_value character varying(650) ENCODE lzo,
    observation_event_id numeric(38,0) ENCODE az64,
    obs_event_field_concept_id numeric(38,0) ENCODE az64
)
DISTSTYLE AUTO;

ALTER TABLE observation
ADD CONSTRAINT observation_pkey
PRIMARY KEY(observation_id);

ALTER TABLE observation
ADD CONSTRAINT observation_person_id_fkey
FOREIGN KEY(person_id) REFERENCES person(person_id);

ALTER TABLE observation
ADD CONSTRAINT observation_provider_id_fkey
FOREIGN KEY(provider_id) REFERENCES provider(provider_id);

ALTER TABLE observation
ADD CONSTRAINT observation_visit_occurrence_id_fkey
FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence(visit_occurrence_id);

CREATE TABLE IF NOT EXISTS observation_period
(
    observation_period_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    person_id numeric(38,0) NOT NULL ENCODE az64,
    observation_period_start_date date NOT NULL ENCODE az64,
    observation_period_end_date date NOT NULL ENCODE az64,
    period_type_concept_id numeric(38,0) NOT NULL ENCODE az64
)
DISTSTYLE AUTO;

ALTER TABLE observation_period
ADD CONSTRAINT observation_period_pkey
PRIMARY KEY(observation_period_id);

ALTER TABLE observation_period
ADD CONSTRAINT observation_period_person_id_fkey
FOREIGN KEY(person_id) REFERENCES person(person_id);

CREATE TABLE IF NOT EXISTS payer_plan_period
(
    payer_plan_period_id numeric(38,0) NOT NULL ENCODE az64,
    person_id numeric(38,0) NOT NULL ENCODE az64,
    payer_plan_period_start_date date NOT NULL ENCODE az64,
    payer_plan_period_end_date date NOT NULL ENCODE az64,
    payer_concept_id numeric(38,0) ENCODE az64,
    payer_source_value character varying(100) ENCODE lzo,
    payer_source_concept_id numeric(38,0) ENCODE az64,
    plan_concept_id numeric(38,0) ENCODE az64,
    plan_source_value character varying(100) ENCODE lzo,
    plan_source_concept_id numeric(38,0) ENCODE az64,
    sponsor_concept_id numeric(38,0) ENCODE az64,
    sponsor_source_value character varying(50) ENCODE lzo,
    sponsor_source_concept_id numeric(38,0) ENCODE az64,
    family_source_value character varying(50) ENCODE lzo,
    stop_reason_concept_id numeric(38,0) ENCODE az64,
    stop_reason_source_value character varying(50) ENCODE lzo,
    stop_reason_source_concept_id numeric(38,0) ENCODE az64
)
DISTSTYLE AUTO;

CREATE TABLE IF NOT EXISTS procedure_occurrence
(
    procedure_occurrence_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    person_id numeric(38,0) NOT NULL ENCODE az64,
    procedure_concept_id numeric(38,0) NOT NULL ENCODE az64,
    procedure_date date NOT NULL ENCODE az64,
    procedure_datetime timestamp without time zone ENCODE az64,
    procedure_end_date date ENCODE az64,
    procedure_end_datetime timestamp without time zone ENCODE az64,
    procedure_type_concept_id numeric(38,0) NOT NULL ENCODE az64,
    modifier_concept_id numeric(38,0) ENCODE az64,
    quantity numeric(38,0) ENCODE az64,
    provider_id numeric(38,0) ENCODE az64,
    visit_occurrence_id numeric(38,0) ENCODE az64,
    visit_detail_id numeric(38,0) ENCODE az64,
    procedure_source_value character varying(650) ENCODE lzo,
    procedure_source_concept_id numeric(38,0) ENCODE az64,
    modifier_source_value character varying(50) ENCODE lzo
)
DISTSTYLE AUTO;

ALTER TABLE procedure_occurrence
ADD CONSTRAINT procedure_occurrence_pkey
PRIMARY KEY(procedure_occurrence_id);

ALTER TABLE procedure_occurrence
ADD CONSTRAINT procedure_occurrence_person_id_fkey
FOREIGN KEY(person_id) REFERENCES person(person_id);

ALTER TABLE procedure_occurrence
ADD CONSTRAINT procedure_occurrence_provider_id_fkey
FOREIGN KEY(provider_id) REFERENCES provider(provider_id);

ALTER TABLE procedure_occurrence
ADD CONSTRAINT procedure_occurrence_visit_occurrence_id_fkey
FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence(visit_occurrence_id);

CREATE TABLE IF NOT EXISTS relationship
(
    relationship_id character varying(20) NOT NULL ENCODE lzo,
    relationship_name character varying(255) NOT NULL ENCODE lzo,
    is_hierarchical character varying(1) NOT NULL ENCODE lzo,
    defines_ancestry character varying(1) NOT NULL ENCODE lzo,
    reverse_relationship_id character varying(20) NOT NULL ENCODE lzo,
    relationship_concept_id numeric(38,0) NOT NULL ENCODE az64
)
DISTSTYLE AUTO;

CREATE TABLE IF NOT EXISTS source_to_concept_map
(
    source_code character varying(255) NOT NULL ENCODE lzo,
    source_concept_id numeric(38,0) NOT NULL DEFAULT 0 ENCODE az64,
    source_vocabulary_id character varying(50) NOT NULL ENCODE lzo,
    source_code_description character varying(1024) ENCODE lzo,
    target_concept_id numeric(38,0) NOT NULL DEFAULT 0 ENCODE az64,
    target_vocabulary_id character varying(50) NOT NULL ENCODE lzo,
    valid_start_date date NOT NULL ENCODE az64,
    valid_end_date date NOT NULL ENCODE az64,
    invalid_reason character varying(1) ENCODE lzo
)
DISTSTYLE AUTO;

CREATE TABLE IF NOT EXISTS specimen
(
    specimen_id bigint NOT NULL ENCODE az64 IDENTITY(1,1),
    person_id numeric(38,0) NOT NULL ENCODE az64,
    specimen_concept_id numeric(38,0) NOT NULL ENCODE az64,
    specimen_type_concept_id numeric(38,0) NOT NULL ENCODE az64,
    specimen_date date NOT NULL ENCODE az64,
    specimen_datetime timestamp without time zone ENCODE az64,
    quantity numeric(38,5) ENCODE az64,
    unit_concept_id numeric(38,0) ENCODE az64,
    anatomic_site_concept_id numeric(38,0) ENCODE az64,
    disease_status_concept_id numeric(38,0) ENCODE az64,
    specimen_source_id character varying(50) ENCODE lzo,
    specimen_source_value character varying(650) ENCODE lzo,
    unit_source_value character varying(50) ENCODE lzo,
    anatomic_site_source_value character varying(50) ENCODE lzo,
    disease_status_source_value character varying(50) ENCODE lzo
)
DISTSTYLE AUTO;

ALTER TABLE specimen
ADD CONSTRAINT specimen_pkey
PRIMARY KEY(specimen_id);

ALTER TABLE specimen
ADD CONSTRAINT specimen_person_id_fkey
FOREIGN KEY(person_id) REFERENCES person(person_id);

CREATE TABLE IF NOT EXISTS visit_detail
(
    visit_detail_id numeric(38,0) NOT NULL ENCODE az64,
    person_id numeric(38,0) NOT NULL ENCODE az64,
    visit_detail_concept_id numeric(38,0) NOT NULL ENCODE az64,
    visit_detail_start_date date NOT NULL ENCODE az64,
    visit_detail_start_datetime timestamp without time zone ENCODE az64,
    visit_detail_end_date date NOT NULL ENCODE az64,
    visit_detail_end_datetime timestamp without time zone ENCODE az64,
    visit_detail_type_concept_id numeric(38,0) NOT NULL ENCODE az64,
    provider_id numeric(38,0) ENCODE az64,
    care_site_id numeric(38,0) ENCODE az64,
    admitted_from_concept_id numeric(38,0) ENCODE az64,
    discharged_to_concept_id numeric(38,0) ENCODE az64,
    preceding_visit_detail_id numeric(38,0) ENCODE az64,
    visit_detail_source_value character varying(200) ENCODE lzo,
    visit_detail_source_concept_id numeric(38,0) ENCODE az64,
    admitted_from_source_value character varying(50) ENCODE lzo,
    discharged_to_source_value character varying(50) ENCODE lzo,
    parent_visit_detail_id numeric(38,0) ENCODE az64,
    visit_occurrence_id numeric(38,0) NOT NULL ENCODE az64
)
DISTSTYLE AUTO;

ALTER TABLE visit_detail
ADD CONSTRAINT visit_detail_f_pkey
PRIMARY KEY(visit_detail_id);

ALTER TABLE visit_detail
ADD CONSTRAINT visit_detail_f_care_site_id_fkey
FOREIGN KEY(care_site_id) REFERENCES care_site(care_site_id);

ALTER TABLE visit_detail
ADD CONSTRAINT visit_detail_f_person_id_fkey
FOREIGN KEY(person_id) REFERENCES person(person_id);

ALTER TABLE visit_detail
ADD CONSTRAINT visit_detail_f_provider_id_fkey
FOREIGN KEY(provider_id) REFERENCES provider(provider_id);

ALTER TABLE visit_detail
ADD CONSTRAINT visit_detail_f_visit_occurrence_id_fkey
FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence(visit_occurrence_id);

CREATE TABLE IF NOT EXISTS vocabulary
(
    vocabulary_id character varying(20) NOT NULL ENCODE lzo,
    vocabulary_name character varying(255) NOT NULL ENCODE lzo,
    vocabulary_reference character varying(255) NOT NULL ENCODE lzo,
    vocabulary_version character varying(255) ENCODE lzo,
    vocabulary_concept_id numeric(38,0) NOT NULL ENCODE az64
)
DISTSTYLE AUTO;