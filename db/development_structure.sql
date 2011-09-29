--
-- PostgreSQL database dump
--

-- Started on 2009-10-20 16:09:59 CEST

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 1553 (class 1259 OID 18247)
-- Dependencies: 6
-- Name: c_corpora; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE c_corpora (
    id integer NOT NULL,
    name text
);


--
-- TOC entry 1554 (class 1259 OID 18253)
-- Dependencies: 6
-- Name: c_korpus2000_sentences; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE c_korpus2000_sentences (
    id integer NOT NULL,
    sentence_id integer NOT NULL,
    preom integer NOT NULL,
    bop integer NOT NULL,
    eop integer NOT NULL,
    genre integer NOT NULL,
    agerel integer NOT NULL,
    medium integer NOT NULL,
    prody integer NOT NULL,
    aspect integer NOT NULL
);


--
-- TOC entry 1555 (class 1259 OID 18256)
-- Dependencies: 6 1554
-- Name: c_korpus2000_sentences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE c_korpus2000_sentences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 1957 (class 0 OID 0)
-- Dependencies: 1555
-- Name: c_korpus2000_sentences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE c_korpus2000_sentences_id_seq OWNED BY c_korpus2000_sentences.id;


--
-- TOC entry 1556 (class 1259 OID 18258)
-- Dependencies: 6
-- Name: c_lemma_unigrams; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE c_lemma_unigrams (
    pick_id integer NOT NULL,
    lemma_id integer NOT NULL,
    freq_p numeric NOT NULL
);


--
-- TOC entry 1557 (class 1259 OID 18264)
-- Dependencies: 6
-- Name: c_lemmas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE c_lemmas (
    chars text NOT NULL,
    id integer NOT NULL
);


--
-- TOC entry 1558 (class 1259 OID 18270)
-- Dependencies: 1557 6
-- Name: c_lemmas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE c_lemmas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 1960 (class 0 OID 0)
-- Dependencies: 1558
-- Name: c_lemmas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE c_lemmas_id_seq OWNED BY c_lemmas.id;


--
-- TOC entry 1559 (class 1259 OID 18272)
-- Dependencies: 6
-- Name: c_picks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE c_picks (
    id integer NOT NULL,
    name text NOT NULL,
    count integer NOT NULL
);


--
-- TOC entry 1560 (class 1259 OID 18278)
-- Dependencies: 6 1559
-- Name: c_picks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE c_picks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 1962 (class 0 OID 0)
-- Dependencies: 1560
-- Name: c_picks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE c_picks_id_seq OWNED BY c_picks.id;


--
-- TOC entry 1561 (class 1259 OID 18280)
-- Dependencies: 6
-- Name: c_pos_tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE c_pos_tags (
    id integer NOT NULL,
    name text NOT NULL
);


--
-- TOC entry 1562 (class 1259 OID 18286)
-- Dependencies: 1561 6
-- Name: c_pos_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE c_pos_tag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 1964 (class 0 OID 0)
-- Dependencies: 1562
-- Name: c_pos_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE c_pos_tag_id_seq OWNED BY c_pos_tags.id;


--
-- TOC entry 1563 (class 1259 OID 18288)
-- Dependencies: 6
-- Name: c_sentences; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE c_sentences (
    id integer NOT NULL,
    corpus_id integer NOT NULL
);


--
-- TOC entry 1564 (class 1259 OID 18291)
-- Dependencies: 1868 6
-- Name: c_tokens; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE c_tokens (
    sentence_id integer NOT NULL,
    "position" integer NOT NULL,
    pos_tags integer[] DEFAULT '{}'::integer[] NOT NULL,
    word_form_id integer NOT NULL,
    lemma_id integer
);


--
-- TOC entry 1565 (class 1259 OID 18298)
-- Dependencies: 6
-- Name: c_word_forms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE c_word_forms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 1566 (class 1259 OID 18300)
-- Dependencies: 1869 6
-- Name: c_word_forms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE c_word_forms (
    id integer DEFAULT nextval('c_word_forms_id_seq'::regclass) NOT NULL,
    chars text NOT NULL,
    lemma_id integer
);


--
-- TOC entry 1567 (class 1259 OID 18307)
-- Dependencies: 1553 6
-- Name: corpora_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE corpora_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 1968 (class 0 OID 0)
-- Dependencies: 1567
-- Name: corpora_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE corpora_id_seq OWNED BY c_corpora.id;


--
-- TOC entry 1568 (class 1259 OID 18309)
-- Dependencies: 6
-- Name: dn_feature_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dn_feature_types (
    id integer NOT NULL,
    name text NOT NULL
);


--
-- TOC entry 1569 (class 1259 OID 18315)
-- Dependencies: 1568 6
-- Name: dn_feature_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dn_feature_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 1970 (class 0 OID 0)
-- Dependencies: 1569
-- Name: dn_feature_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dn_feature_types_id_seq OWNED BY dn_feature_types.id;


--
-- TOC entry 1570 (class 1259 OID 18317)
-- Dependencies: 6
-- Name: dn_features; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dn_features (
    id integer NOT NULL,
    syn_set_id bigint NOT NULL,
    feature_type_id integer NOT NULL
);


--
-- TOC entry 1571 (class 1259 OID 18320)
-- Dependencies: 1570 6
-- Name: dn_features_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dn_features_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 1972 (class 0 OID 0)
-- Dependencies: 1571
-- Name: dn_features_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dn_features_id_seq OWNED BY dn_features.id;


--
-- TOC entry 1572 (class 1259 OID 18322)
-- Dependencies: 6
-- Name: dn_pos_tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dn_pos_tags (
    id integer NOT NULL,
    name text NOT NULL
);


--
-- TOC entry 1573 (class 1259 OID 18328)
-- Dependencies: 1572 6
-- Name: dn_pos_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dn_pos_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 1974 (class 0 OID 0)
-- Dependencies: 1573
-- Name: dn_pos_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dn_pos_tags_id_seq OWNED BY dn_pos_tags.id;


--
-- TOC entry 1574 (class 1259 OID 18330)
-- Dependencies: 6
-- Name: dn_relation_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dn_relation_types (
    id integer NOT NULL,
    name text NOT NULL,
    word_net_name text NOT NULL,
    reverse_id integer
);


--
-- TOC entry 1575 (class 1259 OID 18336)
-- Dependencies: 1574 6
-- Name: dn_relation_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dn_relation_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 1976 (class 0 OID 0)
-- Dependencies: 1575
-- Name: dn_relation_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dn_relation_types_id_seq OWNED BY dn_relation_types.id;


--
-- TOC entry 1576 (class 1259 OID 18338)
-- Dependencies: 1875 6
-- Name: dn_relations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dn_relations (
    id integer NOT NULL,
    relation_type_id integer NOT NULL,
    target_word_net_id text,
    syn_set_id bigint NOT NULL,
    taxonomic boolean,
    inheritance_comment text,
    target_syn_set_id bigint,
    CONSTRAINT word_net_or_syn_set CHECK ((((target_word_net_id IS NULL) OR (target_syn_set_id IS NULL)) AND (NOT ((target_word_net_id IS NULL) AND (target_syn_set_id IS NULL)))))
);


--
-- TOC entry 1577 (class 1259 OID 18345)
-- Dependencies: 6 1576
-- Name: dn_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dn_relations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 1978 (class 0 OID 0)
-- Dependencies: 1577
-- Name: dn_relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dn_relations_id_seq OWNED BY dn_relations.id;


--
-- TOC entry 1578 (class 1259 OID 18347)
-- Dependencies: 6
-- Name: dn_syn_sets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dn_syn_sets (
    id bigint NOT NULL,
    label text NOT NULL,
    gloss text,
    usage text
);


--
-- TOC entry 1579 (class 1259 OID 18353)
-- Dependencies: 6
-- Name: dn_word_parts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dn_word_parts (
    word_id bigint NOT NULL,
    part_of_word_id bigint NOT NULL
);


--
-- TOC entry 1584 (class 1259 OID 27635)
-- Dependencies: 6
-- Name: dn_word_senses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dn_word_senses (
    id integer NOT NULL,
    word_id bigint NOT NULL,
    syn_set_id bigint NOT NULL,
    register text NOT NULL,
    heading text,
    label_candidate boolean,
    ddo_id bigint
);


--
-- TOC entry 1583 (class 1259 OID 27633)
-- Dependencies: 6 1584
-- Name: dn_word_senses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dn_word_senses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 1982 (class 0 OID 0)
-- Dependencies: 1583
-- Name: dn_word_senses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dn_word_senses_id_seq OWNED BY dn_word_senses.id;


--
-- TOC entry 1580 (class 1259 OID 18364)
-- Dependencies: 6
-- Name: dn_words; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dn_words (
    id bigint NOT NULL,
    lemma text NOT NULL,
    pos_tag_id integer NOT NULL
);


--
-- TOC entry 1581 (class 1259 OID 18370)
-- Dependencies: 6
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- TOC entry 1582 (class 1259 OID 18373)
-- Dependencies: 1563 6
-- Name: sentences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sentences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 1985 (class 0 OID 0)
-- Dependencies: 1582
-- Name: sentences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sentences_id_seq OWNED BY c_sentences.id;


--
-- TOC entry 1862 (class 2604 OID 18375)
-- Dependencies: 1567 1553
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE c_corpora ALTER COLUMN id SET DEFAULT nextval('corpora_id_seq'::regclass);


--
-- TOC entry 1863 (class 2604 OID 18376)
-- Dependencies: 1555 1554
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE c_korpus2000_sentences ALTER COLUMN id SET DEFAULT nextval('c_korpus2000_sentences_id_seq'::regclass);


--
-- TOC entry 1864 (class 2604 OID 18377)
-- Dependencies: 1558 1557
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE c_lemmas ALTER COLUMN id SET DEFAULT nextval('c_lemmas_id_seq'::regclass);


--
-- TOC entry 1865 (class 2604 OID 18378)
-- Dependencies: 1560 1559
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE c_picks ALTER COLUMN id SET DEFAULT nextval('c_picks_id_seq'::regclass);


--
-- TOC entry 1866 (class 2604 OID 18379)
-- Dependencies: 1562 1561
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE c_pos_tags ALTER COLUMN id SET DEFAULT nextval('c_pos_tag_id_seq'::regclass);


--
-- TOC entry 1867 (class 2604 OID 18380)
-- Dependencies: 1582 1563
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE c_sentences ALTER COLUMN id SET DEFAULT nextval('sentences_id_seq'::regclass);


--
-- TOC entry 1870 (class 2604 OID 18381)
-- Dependencies: 1569 1568
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE dn_feature_types ALTER COLUMN id SET DEFAULT nextval('dn_feature_types_id_seq'::regclass);


--
-- TOC entry 1871 (class 2604 OID 18382)
-- Dependencies: 1571 1570
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE dn_features ALTER COLUMN id SET DEFAULT nextval('dn_features_id_seq'::regclass);


--
-- TOC entry 1872 (class 2604 OID 18383)
-- Dependencies: 1573 1572
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE dn_pos_tags ALTER COLUMN id SET DEFAULT nextval('dn_pos_tags_id_seq'::regclass);


--
-- TOC entry 1873 (class 2604 OID 18384)
-- Dependencies: 1575 1574
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE dn_relation_types ALTER COLUMN id SET DEFAULT nextval('dn_relation_types_id_seq'::regclass);


--
-- TOC entry 1874 (class 2604 OID 18385)
-- Dependencies: 1577 1576
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE dn_relations ALTER COLUMN id SET DEFAULT nextval('dn_relations_id_seq'::regclass);


--
-- TOC entry 1876 (class 2604 OID 27638)
-- Dependencies: 1584 1583 1584
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE dn_word_senses ALTER COLUMN id SET DEFAULT nextval('dn_word_senses_id_seq'::regclass);


--
-- TOC entry 1878 (class 2606 OID 18388)
-- Dependencies: 1553 1553
-- Name: c_corpora_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY c_corpora
    ADD CONSTRAINT c_corpora_id PRIMARY KEY (id);


--
-- TOC entry 1880 (class 2606 OID 18390)
-- Dependencies: 1554 1554
-- Name: c_korpus2000_sentences_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY c_korpus2000_sentences
    ADD CONSTRAINT c_korpus2000_sentences_id PRIMARY KEY (id);


--
-- TOC entry 1882 (class 2606 OID 18392)
-- Dependencies: 1556 1556 1556
-- Name: c_lemma_unigrams_pick_id_and_lemma_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY c_lemma_unigrams
    ADD CONSTRAINT c_lemma_unigrams_pick_id_and_lemma_id PRIMARY KEY (pick_id, lemma_id);


--
-- TOC entry 1885 (class 2606 OID 18394)
-- Dependencies: 1557 1557
-- Name: c_lemmas_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY c_lemmas
    ADD CONSTRAINT c_lemmas_id PRIMARY KEY (id);


--
-- TOC entry 1887 (class 2606 OID 18396)
-- Dependencies: 1559 1559
-- Name: c_picks_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY c_picks
    ADD CONSTRAINT c_picks_id PRIMARY KEY (id);


--
-- TOC entry 1889 (class 2606 OID 18398)
-- Dependencies: 1561 1561
-- Name: c_pos_tag_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY c_pos_tags
    ADD CONSTRAINT c_pos_tag_id PRIMARY KEY (id);


--
-- TOC entry 1891 (class 2606 OID 18400)
-- Dependencies: 1563 1563
-- Name: c_sentences_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY c_sentences
    ADD CONSTRAINT c_sentences_id PRIMARY KEY (id);


--
-- TOC entry 1895 (class 2606 OID 18402)
-- Dependencies: 1564 1564 1564
-- Name: c_tokens_sentence_id_and_position; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY c_tokens
    ADD CONSTRAINT c_tokens_sentence_id_and_position PRIMARY KEY (sentence_id, "position");


--
-- TOC entry 1899 (class 2606 OID 18404)
-- Dependencies: 1566 1566
-- Name: c_word_forms_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY c_word_forms
    ADD CONSTRAINT c_word_forms_id PRIMARY KEY (id);


--
-- TOC entry 1903 (class 2606 OID 18406)
-- Dependencies: 1568 1568
-- Name: dn_feature_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dn_feature_types
    ADD CONSTRAINT dn_feature_types_pkey PRIMARY KEY (id);


--
-- TOC entry 1905 (class 2606 OID 18408)
-- Dependencies: 1570 1570
-- Name: dn_features_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dn_features
    ADD CONSTRAINT dn_features_pkey PRIMARY KEY (id);


--
-- TOC entry 1910 (class 2606 OID 18410)
-- Dependencies: 1574 1574
-- Name: dn_relation_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dn_relation_types
    ADD CONSTRAINT dn_relation_types_pkey PRIMARY KEY (id);


--
-- TOC entry 1913 (class 2606 OID 18412)
-- Dependencies: 1576 1576
-- Name: dn_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dn_relations
    ADD CONSTRAINT dn_relations_pkey PRIMARY KEY (id);


--
-- TOC entry 1917 (class 2606 OID 18414)
-- Dependencies: 1578 1578
-- Name: dn_synsets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dn_syn_sets
    ADD CONSTRAINT dn_synsets_pkey PRIMARY KEY (id);


--
-- TOC entry 1919 (class 2606 OID 18416)
-- Dependencies: 1579 1579 1579
-- Name: dn_word_parts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dn_word_parts
    ADD CONSTRAINT dn_word_parts_pkey PRIMARY KEY (word_id, part_of_word_id);


--
-- TOC entry 1926 (class 2606 OID 27645)
-- Dependencies: 1584 1584
-- Name: dn_word_senses_heading_uniq; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dn_word_senses
    ADD CONSTRAINT dn_word_senses_heading_uniq UNIQUE (heading);


--
-- TOC entry 1928 (class 2606 OID 27643)
-- Dependencies: 1584 1584
-- Name: dn_word_senses_id_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dn_word_senses
    ADD CONSTRAINT dn_word_senses_id_pkey PRIMARY KEY (id);


--
-- TOC entry 1923 (class 2606 OID 18420)
-- Dependencies: 1580 1580
-- Name: dn_words_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dn_words
    ADD CONSTRAINT dn_words_pkey PRIMARY KEY (id);


--
-- TOC entry 1883 (class 1259 OID 18421)
-- Dependencies: 1557
-- Name: c_lemmas_chars; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX c_lemmas_chars ON c_lemmas USING btree (chars);


--
-- TOC entry 1892 (class 1259 OID 18422)
-- Dependencies: 1564
-- Name: c_tokens_lemma_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX c_tokens_lemma_id ON c_tokens USING btree (lemma_id);


--
-- TOC entry 1893 (class 1259 OID 18423)
-- Dependencies: 1564
-- Name: c_tokens_sentence_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX c_tokens_sentence_id ON c_tokens USING btree (sentence_id);


--
-- TOC entry 1896 (class 1259 OID 18424)
-- Dependencies: 1564
-- Name: c_tokens_word_form_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX c_tokens_word_form_id ON c_tokens USING btree (word_form_id);


--
-- TOC entry 1897 (class 1259 OID 18425)
-- Dependencies: 1566 1566
-- Name: c_word_forms_chars_and_lemma_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX c_word_forms_chars_and_lemma_id ON c_word_forms USING btree (chars, lemma_id);


--
-- TOC entry 1900 (class 1259 OID 18426)
-- Dependencies: 1566
-- Name: c_word_forms_lemma_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX c_word_forms_lemma_id ON c_word_forms USING btree (lemma_id);


--
-- TOC entry 1901 (class 1259 OID 18427)
-- Dependencies: 1568
-- Name: dn_feature_types_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX dn_feature_types_id_key ON dn_feature_types USING btree (id);


--
-- TOC entry 1906 (class 1259 OID 24650)
-- Dependencies: 1570
-- Name: dn_features_syn_set_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX dn_features_syn_set_id_key ON dn_features USING btree (syn_set_id);


--
-- TOC entry 1907 (class 1259 OID 18428)
-- Dependencies: 1572
-- Name: dn_pos_tags_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX dn_pos_tags_id_key ON dn_pos_tags USING btree (id);


--
-- TOC entry 1908 (class 1259 OID 18429)
-- Dependencies: 1574
-- Name: dn_relation_types_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX dn_relation_types_id_key ON dn_relation_types USING btree (id);


--
-- TOC entry 1911 (class 1259 OID 18430)
-- Dependencies: 1574
-- Name: dn_relation_types_reverse_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX dn_relation_types_reverse_id_key ON dn_relation_types USING btree (reverse_id);


--
-- TOC entry 1914 (class 1259 OID 24648)
-- Dependencies: 1576 1576
-- Name: dn_relations_syn_set_id_and_relation_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX dn_relations_syn_set_id_and_relation_type_id ON dn_relations USING btree (syn_set_id, relation_type_id);


--
-- TOC entry 1915 (class 1259 OID 18432)
-- Dependencies: 1578
-- Name: dn_syn_sets_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX dn_syn_sets_id_key ON dn_syn_sets USING btree (id);


--
-- TOC entry 1929 (class 1259 OID 27656)
-- Dependencies: 1584
-- Name: dn_word_senses_syn_set_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX dn_word_senses_syn_set_id ON dn_word_senses USING btree (syn_set_id);


--
-- TOC entry 1930 (class 1259 OID 27657)
-- Dependencies: 1584
-- Name: dn_word_senses_word_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX dn_word_senses_word_id_key ON dn_word_senses USING btree (word_id);


--
-- TOC entry 1920 (class 1259 OID 18437)
-- Dependencies: 1580
-- Name: dn_words_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX dn_words_id_key ON dn_words USING btree (id);


--
-- TOC entry 1921 (class 1259 OID 24649)
-- Dependencies: 1580
-- Name: dn_words_lemma_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX dn_words_lemma_key ON dn_words USING btree (lemma text_pattern_ops);


--
-- TOC entry 1924 (class 1259 OID 18439)
-- Dependencies: 1581
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- TOC entry 1931 (class 2606 OID 18440)
-- Dependencies: 1890 1563 1554
-- Name: c_korpus2000_sentences_sentence_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY c_korpus2000_sentences
    ADD CONSTRAINT c_korpus2000_sentences_sentence_id FOREIGN KEY (sentence_id) REFERENCES c_sentences(id);


--
-- TOC entry 1932 (class 2606 OID 18445)
-- Dependencies: 1557 1884 1556
-- Name: c_lemma_unigrams_lemma_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY c_lemma_unigrams
    ADD CONSTRAINT c_lemma_unigrams_lemma_id FOREIGN KEY (lemma_id) REFERENCES c_lemmas(id);


--
-- TOC entry 1933 (class 2606 OID 18450)
-- Dependencies: 1556 1886 1559
-- Name: c_lemma_unigrams_pick_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY c_lemma_unigrams
    ADD CONSTRAINT c_lemma_unigrams_pick_id FOREIGN KEY (pick_id) REFERENCES c_picks(id);


--
-- TOC entry 1934 (class 2606 OID 18455)
-- Dependencies: 1877 1553 1563
-- Name: c_sentences_corpus_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY c_sentences
    ADD CONSTRAINT c_sentences_corpus_id FOREIGN KEY (corpus_id) REFERENCES c_corpora(id);


--
-- TOC entry 1935 (class 2606 OID 18460)
-- Dependencies: 1884 1564 1557
-- Name: c_tokens_lemma_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY c_tokens
    ADD CONSTRAINT c_tokens_lemma_id FOREIGN KEY (lemma_id) REFERENCES c_lemmas(id);


--
-- TOC entry 1936 (class 2606 OID 18465)
-- Dependencies: 1563 1890 1564
-- Name: c_tokens_sentence_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY c_tokens
    ADD CONSTRAINT c_tokens_sentence_id FOREIGN KEY (sentence_id) REFERENCES c_sentences(id);


--
-- TOC entry 1937 (class 2606 OID 18470)
-- Dependencies: 1564 1566 1898
-- Name: c_tokens_word_form_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY c_tokens
    ADD CONSTRAINT c_tokens_word_form_id FOREIGN KEY (word_form_id) REFERENCES c_word_forms(id);


--
-- TOC entry 1938 (class 2606 OID 18475)
-- Dependencies: 1884 1557 1566
-- Name: c_word_forms_lemma_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY c_word_forms
    ADD CONSTRAINT c_word_forms_lemma_id FOREIGN KEY (lemma_id) REFERENCES c_lemmas(id);


--
-- TOC entry 1948 (class 2606 OID 27646)
-- Dependencies: 1578 1916 1584
-- Name: d_word_senses_syn_set_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dn_word_senses
    ADD CONSTRAINT d_word_senses_syn_set_id FOREIGN KEY (syn_set_id) REFERENCES dn_syn_sets(id);


--
-- TOC entry 1939 (class 2606 OID 18485)
-- Dependencies: 1902 1568 1570
-- Name: dn_features_feature_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dn_features
    ADD CONSTRAINT dn_features_feature_type_id FOREIGN KEY (feature_type_id) REFERENCES dn_feature_types(id);


--
-- TOC entry 1940 (class 2606 OID 18490)
-- Dependencies: 1570 1578 1916
-- Name: dn_features_syn_set_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dn_features
    ADD CONSTRAINT dn_features_syn_set_id FOREIGN KEY (syn_set_id) REFERENCES dn_syn_sets(id);


--
-- TOC entry 1941 (class 2606 OID 18495)
-- Dependencies: 1574 1574 1911
-- Name: dn_relation_types_reverse_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dn_relation_types
    ADD CONSTRAINT dn_relation_types_reverse_id FOREIGN KEY (reverse_id) REFERENCES dn_relation_types(reverse_id);


--
-- TOC entry 1942 (class 2606 OID 18500)
-- Dependencies: 1574 1576 1909
-- Name: dn_relations_relation_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dn_relations
    ADD CONSTRAINT dn_relations_relation_type_id FOREIGN KEY (relation_type_id) REFERENCES dn_relation_types(id);


--
-- TOC entry 1943 (class 2606 OID 18505)
-- Dependencies: 1916 1578 1576
-- Name: dn_relations_syn_set_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dn_relations
    ADD CONSTRAINT dn_relations_syn_set_id FOREIGN KEY (syn_set_id) REFERENCES dn_syn_sets(id);


--
-- TOC entry 1944 (class 2606 OID 18510)
-- Dependencies: 1578 1916 1576
-- Name: dn_relations_target_syn_set_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dn_relations
    ADD CONSTRAINT dn_relations_target_syn_set_id FOREIGN KEY (target_syn_set_id) REFERENCES dn_syn_sets(id);


--
-- TOC entry 1945 (class 2606 OID 18515)
-- Dependencies: 1580 1579 1922
-- Name: dn_word_parts_part_of_word_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dn_word_parts
    ADD CONSTRAINT dn_word_parts_part_of_word_id_fkey FOREIGN KEY (part_of_word_id) REFERENCES dn_words(id);


--
-- TOC entry 1946 (class 2606 OID 18520)
-- Dependencies: 1579 1922 1580
-- Name: dn_word_parts_word_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dn_word_parts
    ADD CONSTRAINT dn_word_parts_word_id_fkey FOREIGN KEY (word_id) REFERENCES dn_words(id);


--
-- TOC entry 1949 (class 2606 OID 27651)
-- Dependencies: 1922 1584 1580
-- Name: dn_word_senses_word_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dn_word_senses
    ADD CONSTRAINT dn_word_senses_word_id FOREIGN KEY (word_id) REFERENCES dn_words(id);


--
-- TOC entry 1947 (class 2606 OID 18531)
-- Dependencies: 1580 1907 1572
-- Name: dn_words_pos_tag_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dn_words
    ADD CONSTRAINT dn_words_pos_tag_id FOREIGN KEY (pos_tag_id) REFERENCES dn_pos_tags(id);


--
-- TOC entry 1954 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 1955 (class 0 OID 0)
-- Dependencies: 1553
-- Name: c_corpora; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE c_corpora FROM PUBLIC;
REVOKE ALL ON TABLE c_corpora FROM postgres;
GRANT ALL ON TABLE c_corpora TO postgres;
GRANT ALL ON TABLE c_corpora TO andreord;


--
-- TOC entry 1956 (class 0 OID 0)
-- Dependencies: 1554
-- Name: c_korpus2000_sentences; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE c_korpus2000_sentences FROM PUBLIC;
REVOKE ALL ON TABLE c_korpus2000_sentences FROM postgres;
GRANT ALL ON TABLE c_korpus2000_sentences TO postgres;
GRANT ALL ON TABLE c_korpus2000_sentences TO andreord;


--
-- TOC entry 1958 (class 0 OID 0)
-- Dependencies: 1556
-- Name: c_lemma_unigrams; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE c_lemma_unigrams FROM PUBLIC;
REVOKE ALL ON TABLE c_lemma_unigrams FROM postgres;
GRANT ALL ON TABLE c_lemma_unigrams TO postgres;
GRANT ALL ON TABLE c_lemma_unigrams TO andreord;


--
-- TOC entry 1959 (class 0 OID 0)
-- Dependencies: 1557
-- Name: c_lemmas; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE c_lemmas FROM PUBLIC;
REVOKE ALL ON TABLE c_lemmas FROM postgres;
GRANT ALL ON TABLE c_lemmas TO postgres;
GRANT ALL ON TABLE c_lemmas TO andreord;


--
-- TOC entry 1961 (class 0 OID 0)
-- Dependencies: 1559
-- Name: c_picks; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE c_picks FROM PUBLIC;
REVOKE ALL ON TABLE c_picks FROM postgres;
GRANT ALL ON TABLE c_picks TO postgres;
GRANT ALL ON TABLE c_picks TO andreord;


--
-- TOC entry 1963 (class 0 OID 0)
-- Dependencies: 1561
-- Name: c_pos_tags; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE c_pos_tags FROM PUBLIC;
REVOKE ALL ON TABLE c_pos_tags FROM postgres;
GRANT ALL ON TABLE c_pos_tags TO postgres;
GRANT ALL ON TABLE c_pos_tags TO andreord;


--
-- TOC entry 1965 (class 0 OID 0)
-- Dependencies: 1563
-- Name: c_sentences; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE c_sentences FROM PUBLIC;
REVOKE ALL ON TABLE c_sentences FROM postgres;
GRANT ALL ON TABLE c_sentences TO postgres;
GRANT ALL ON TABLE c_sentences TO andreord;


--
-- TOC entry 1966 (class 0 OID 0)
-- Dependencies: 1564
-- Name: c_tokens; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE c_tokens FROM PUBLIC;
REVOKE ALL ON TABLE c_tokens FROM postgres;
GRANT ALL ON TABLE c_tokens TO postgres;
GRANT ALL ON TABLE c_tokens TO andreord;


--
-- TOC entry 1967 (class 0 OID 0)
-- Dependencies: 1566
-- Name: c_word_forms; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE c_word_forms FROM PUBLIC;
REVOKE ALL ON TABLE c_word_forms FROM postgres;
GRANT ALL ON TABLE c_word_forms TO postgres;
GRANT ALL ON TABLE c_word_forms TO andreord;


--
-- TOC entry 1969 (class 0 OID 0)
-- Dependencies: 1568
-- Name: dn_feature_types; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE dn_feature_types FROM PUBLIC;
REVOKE ALL ON TABLE dn_feature_types FROM postgres;
GRANT ALL ON TABLE dn_feature_types TO postgres;
GRANT ALL ON TABLE dn_feature_types TO andreord;


--
-- TOC entry 1971 (class 0 OID 0)
-- Dependencies: 1570
-- Name: dn_features; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE dn_features FROM PUBLIC;
REVOKE ALL ON TABLE dn_features FROM postgres;
GRANT ALL ON TABLE dn_features TO postgres;
GRANT ALL ON TABLE dn_features TO andreord;


--
-- TOC entry 1973 (class 0 OID 0)
-- Dependencies: 1572
-- Name: dn_pos_tags; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE dn_pos_tags FROM PUBLIC;
REVOKE ALL ON TABLE dn_pos_tags FROM postgres;
GRANT ALL ON TABLE dn_pos_tags TO postgres;
GRANT ALL ON TABLE dn_pos_tags TO andreord;


--
-- TOC entry 1975 (class 0 OID 0)
-- Dependencies: 1574
-- Name: dn_relation_types; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE dn_relation_types FROM PUBLIC;
REVOKE ALL ON TABLE dn_relation_types FROM postgres;
GRANT ALL ON TABLE dn_relation_types TO postgres;
GRANT ALL ON TABLE dn_relation_types TO andreord;


--
-- TOC entry 1977 (class 0 OID 0)
-- Dependencies: 1576
-- Name: dn_relations; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE dn_relations FROM PUBLIC;
REVOKE ALL ON TABLE dn_relations FROM postgres;
GRANT ALL ON TABLE dn_relations TO postgres;
GRANT ALL ON TABLE dn_relations TO andreord;


--
-- TOC entry 1979 (class 0 OID 0)
-- Dependencies: 1578
-- Name: dn_syn_sets; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE dn_syn_sets FROM PUBLIC;
REVOKE ALL ON TABLE dn_syn_sets FROM postgres;
GRANT ALL ON TABLE dn_syn_sets TO postgres;
GRANT ALL ON TABLE dn_syn_sets TO andreord;


--
-- TOC entry 1980 (class 0 OID 0)
-- Dependencies: 1579
-- Name: dn_word_parts; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE dn_word_parts FROM PUBLIC;
REVOKE ALL ON TABLE dn_word_parts FROM postgres;
GRANT ALL ON TABLE dn_word_parts TO andreord;


--
-- TOC entry 1981 (class 0 OID 0)
-- Dependencies: 1584
-- Name: dn_word_senses; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE dn_word_senses FROM PUBLIC;
REVOKE ALL ON TABLE dn_word_senses FROM postgres;
GRANT ALL ON TABLE dn_word_senses TO postgres;
GRANT ALL ON TABLE dn_word_senses TO andreord;


--
-- TOC entry 1983 (class 0 OID 0)
-- Dependencies: 1580
-- Name: dn_words; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE dn_words FROM PUBLIC;
REVOKE ALL ON TABLE dn_words FROM postgres;
GRANT ALL ON TABLE dn_words TO postgres;
GRANT ALL ON TABLE dn_words TO andreord;


--
-- TOC entry 1984 (class 0 OID 0)
-- Dependencies: 1581
-- Name: schema_migrations; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE schema_migrations FROM PUBLIC;
REVOKE ALL ON TABLE schema_migrations FROM postgres;
GRANT ALL ON TABLE schema_migrations TO andreord;


-- Completed on 2009-10-20 16:09:59 CEST

--
-- PostgreSQL database dump complete
--

