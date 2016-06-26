CREATE TABLE job_stats_master (
    id bigserial,
    job_reference character varying(255),
    employer_id integer,
    user_token character varying(1000),
    user_ip character varying(100),
    user_zip character varying(100),
    user_agent character varying(3000),
    url_referrer character varying(3000),
    page_url character varying(3000),
    source character varying(100),
    action integer,
    created_at timestamp without time zone,
    cpc numeric(9,3) DEFAULT 0.0 NOT NULL,
    duplicate boolean DEFAULT false NOT NULL,
    fingerprint character varying(512),
    email character varying(1000),
    mobile_email_apply boolean,
    device integer,
    country character varying(512),
    country_matched boolean,
    job_seeker_id character varying(512),
    applicant_status integer,
    organic boolean DEFAULT false,
    price numeric(9,3),
    paid boolean DEFAULT false,
    meta character varying,
    params character varying(2000),
    job_group_id integer,
    global_action integer,
    external_id character varying(100),
    analytic_source character varying,
    associated_click_id bigint,
    country_id integer,
    user_ip_inet inet,
    feed_updated_at timestamp without time zone,
    campaign_id integer
);

ALTER TABLE job_stats_master OWNER TO postgres;
ALTER TABLE ONLY job_stats_master ADD CONSTRAINT job_stats_master_new_pkey PRIMARY KEY (id);

INSERT INTO job_stats_master ( job_reference, employer_id, user_token, user_ip, user_zip, user_agent, url_referrer, page_url, source, action, created_at,
    cpc, duplicate, fingerprint, email, mobile_email_apply, device, country, country_matched, job_seeker_id, applicant_status, organic, price, paid, meta,
	params, job_group_id, global_action, external_id, analytic_source, associated_click_id, country_id, feed_updated_at, campaign_id	)
SELECT
    (select string_agg(md5(j::text),'') from generate_series(1,4) gs(j)),
    random() * 10000000,
    (select string_agg(md5(j::text),'') from generate_series(1,25) gs(j)),
    (select string_agg(md5(j::text),'') from generate_series(1,3) gs(j)),
    (select string_agg(md5(j::text),'') from generate_series(1,2) gs(j)),
    (select string_agg(md5(j::text),'') from generate_series(1,85) gs(j)),
    (select string_agg(md5(j::text),'') from generate_series(1,85) gs(j)),
    (select string_agg(md5(j::text),'') from generate_series(1,85) gs(j)),
    (select string_agg(md5(j::text),'') from generate_series(1,2) gs(j)),
    random() * 10000000,
    now(),
    (random() * 1000)::numeric(10,2),
    random()::int::boolean,
    (select string_agg(md5(j::text),'') from generate_series(1,8) gs(j)),
    (select string_agg(md5(j::text),'') from generate_series(1,30) gs(j)),
    random()::int::boolean,
    random() * 10000000,
    (select string_agg(md5(j::text),'') from generate_series(1,5) gs(j)),
    random()::int::boolean,
    (select string_agg(md5(j::text),'') from generate_series(1,8) gs(j)),
    random() * 10000000,
    random()::int::boolean,
    (random() * 1000)::numeric(10,2),
    random()::int::boolean,
    (select string_agg(md5(j::text),'') from generate_series(1,7) gs(j)),
    (select string_agg(md5(j::text),'') from generate_series(1,53) gs(j)),
    random() * 10000000,
    random() * 10000000,
    (select string_agg(md5(j::text),'') from generate_series(1,3) gs(j)),
    (select string_agg(md5(j::text),'') from generate_series(1,10) gs(j)),
    random() * 10000000,
    random() * 10000000,
    now(),
    random() * 10000000
FROM generate_series(1,6000000) as gs(i);

CREATE INDEX job_stats_master_created_at ON job_stats_master USING btree (created_at);
CREATE INDEX job_stats_master_employer_id_and_created_at ON job_stats_master USING btree (employer_id, created_at);
CREATE INDEX job_stats_master_employer_id_and_source ON job_stats_master USING btree (employer_id, source);
CREATE INDEX job_stats_master_global_action ON job_stats_master USING btree (global_action);
CREATE INDEX job_stats_master_job_group_id ON job_stats_master USING btree (job_group_id);
CREATE INDEX job_stats_master_job_reference ON job_stats_master USING btree (job_reference);
CREATE INDEX job_stats_master_job_seeker_id ON job_stats_master USING btree (job_seeker_id);
CREATE INDEX job_stats_master_source_created_at_key ON job_stats_master USING btree (source, created_at);
CREATE INDEX job_stats_master_source_job_reference ON job_stats_master USING btree (source, job_reference) WHERE (source IS NOT NULL);
CREATE INDEX job_stats_master_user_token_created_at_key ON job_stats_master USING btree (user_token, created_at);
