--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: activity_logs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE activity_logs (
    id integer NOT NULL,
    actor_id integer,
    action character varying(255),
    activity text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    target_id integer,
    "desc" character varying(255)
);


--
-- Name: activity_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE activity_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activity_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE activity_logs_id_seq OWNED BY activity_logs.id;


--
-- Name: attempt_details; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE attempt_details (
    id integer NOT NULL,
    attempt_id integer,
    question_id integer,
    option_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_input character varying(255),
    marked boolean
);


--
-- Name: attempt_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE attempt_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attempt_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE attempt_details_id_seq OWNED BY attempt_details.id;


--
-- Name: attempts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE attempts (
    id integer NOT NULL,
    user_id integer,
    quiz_id integer,
    completed boolean DEFAULT false,
    current_question_id integer,
    is_current boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    current_section_id integer,
    "current_time" integer,
    score double precision,
    report hstore
);


--
-- Name: attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE attempts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE attempts_id_seq OWNED BY attempts.id;


--
-- Name: cart_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cart_items (
    id integer NOT NULL,
    quiz_id integer,
    package_id integer,
    cart_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cart_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cart_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cart_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cart_items_id_seq OWNED BY cart_items.id;


--
-- Name: carts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE carts (
    id integer NOT NULL,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: carts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE carts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: carts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE carts_id_seq OWNED BY carts.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    code character varying(255),
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    section_type_id integer,
    slug character varying(255)
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: dictionaries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dictionaries (
    id integer NOT NULL,
    word character varying(255),
    meaning text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: dictionaries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dictionaries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dictionaries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dictionaries_id_seq OWNED BY dictionaries.id;


--
-- Name: offer_codes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE offer_codes (
    id integer NOT NULL,
    code character varying(255),
    "desc" text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: offer_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE offer_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offer_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE offer_codes_id_seq OWNED BY offer_codes.id;


--
-- Name: offer_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE offer_items (
    id integer NOT NULL,
    offer_id integer,
    quiz_id integer,
    package_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: offer_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE offer_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offer_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE offer_items_id_seq OWNED BY offer_items.id;


--
-- Name: offer_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE offer_users (
    id integer NOT NULL,
    offer_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: offer_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE offer_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offer_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE offer_users_id_seq OWNED BY offer_users.id;


--
-- Name: offers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE offers (
    id integer NOT NULL,
    offer_code_id integer,
    title character varying(255),
    "desc" text,
    start timestamp without time zone,
    stop timestamp without time zone,
    global boolean DEFAULT true NOT NULL,
    active boolean DEFAULT false NOT NULL,
    credits integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: offers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE offers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE offers_id_seq OWNED BY offers.id;


--
-- Name: options; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE options (
    id integer NOT NULL,
    content text,
    correct boolean,
    question_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    sequence_no integer
);


--
-- Name: options_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE options_id_seq OWNED BY options.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE orders (
    id integer NOT NULL,
    "responseCode" integer,
    "responseDescription" text,
    cart_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE orders_id_seq OWNED BY orders.id;


--
-- Name: package_quizzes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE package_quizzes (
    id integer NOT NULL,
    package_id integer,
    quiz_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: package_quizzes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE package_quizzes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: package_quizzes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE package_quizzes_id_seq OWNED BY package_quizzes.id;


--
-- Name: packages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE packages (
    id integer NOT NULL,
    name character varying(255),
    "desc" text,
    price numeric,
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug character varying(255)
);


--
-- Name: packages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE packages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE packages_id_seq OWNED BY packages.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE questions (
    id integer NOT NULL,
    sequence_no integer,
    instruction text,
    passage text,
    que_text text,
    sol_text text,
    option_set_count integer,
    que_image text,
    sol_image text,
    di_location character varying(255),
    quantity_a text,
    quantity_b text,
    type_id integer,
    topic_id integer,
    section_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE questions_id_seq OWNED BY questions.id;


--
-- Name: quiz_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE quiz_types (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug character varying(255)
);


--
-- Name: quiz_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE quiz_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quiz_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE quiz_types_id_seq OWNED BY quiz_types.id;


--
-- Name: quiz_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE quiz_users (
    id integer NOT NULL,
    quiz_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: quiz_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE quiz_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quiz_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE quiz_users_id_seq OWNED BY quiz_users.id;


--
-- Name: quizzes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE quizzes (
    id integer NOT NULL,
    name character varying(255),
    "desc" text,
    random boolean,
    quiz_type_id integer,
    category_id integer,
    topic_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    timed boolean,
    price numeric(10,2) DEFAULT 0.0,
    published boolean DEFAULT false,
    publisher_id integer,
    published_at timestamp without time zone,
    approved boolean DEFAULT false,
    approver_id integer,
    approved_at timestamp without time zone,
    slug character varying(255)
);


--
-- Name: quizzes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE quizzes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quizzes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE quizzes_id_seq OWNED BY quizzes.id;


--
-- Name: role_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE role_users (
    id integer NOT NULL,
    role_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: role_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE role_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: role_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE role_users_id_seq OWNED BY role_users.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: scaled_scores; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE scaled_scores (
    id integer NOT NULL,
    value integer,
    verbal_score integer,
    quant_score integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: scaled_scores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE scaled_scores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scaled_scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE scaled_scores_id_seq OWNED BY scaled_scores.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: section_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE section_types (
    id integer NOT NULL,
    name character varying(255),
    instruction text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug character varying(255)
);


--
-- Name: section_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE section_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: section_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE section_types_id_seq OWNED BY section_types.id;


--
-- Name: sections; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sections (
    id integer NOT NULL,
    name character varying(255),
    sequence_no integer,
    quiz_id integer,
    section_type_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    display_text text,
    slug character varying(255)
);


--
-- Name: sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sections_id_seq OWNED BY sections.id;


--
-- Name: topics; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE topics (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug character varying(255),
    section_type_id integer
);


--
-- Name: topics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE topics_id_seq OWNED BY topics.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE transactions (
    id integer NOT NULL,
    action character varying(255),
    "responseCode" integer,
    "responseDescription" character varying(255),
    ipaddress character varying(255),
    order_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transactions_id_seq OWNED BY transactions.id;


--
-- Name: types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE types (
    id integer NOT NULL,
    category_id integer,
    code character varying(255),
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug character varying(255)
);


--
-- Name: types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE types_id_seq OWNED BY types.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying(255),
    full_name character varying(255) DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    profile_image character varying(255),
    credits integer DEFAULT 0
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: visits; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE visits (
    id integer NOT NULL,
    attempt_id integer,
    question_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    start integer,
    "end" integer
);


--
-- Name: visits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE visits_id_seq OWNED BY visits.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY activity_logs ALTER COLUMN id SET DEFAULT nextval('activity_logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY attempt_details ALTER COLUMN id SET DEFAULT nextval('attempt_details_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY attempts ALTER COLUMN id SET DEFAULT nextval('attempts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cart_items ALTER COLUMN id SET DEFAULT nextval('cart_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY carts ALTER COLUMN id SET DEFAULT nextval('carts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY dictionaries ALTER COLUMN id SET DEFAULT nextval('dictionaries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY offer_codes ALTER COLUMN id SET DEFAULT nextval('offer_codes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY offer_items ALTER COLUMN id SET DEFAULT nextval('offer_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY offer_users ALTER COLUMN id SET DEFAULT nextval('offer_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY offers ALTER COLUMN id SET DEFAULT nextval('offers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY options ALTER COLUMN id SET DEFAULT nextval('options_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders ALTER COLUMN id SET DEFAULT nextval('orders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY package_quizzes ALTER COLUMN id SET DEFAULT nextval('package_quizzes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY packages ALTER COLUMN id SET DEFAULT nextval('packages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY questions ALTER COLUMN id SET DEFAULT nextval('questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY quiz_types ALTER COLUMN id SET DEFAULT nextval('quiz_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY quiz_users ALTER COLUMN id SET DEFAULT nextval('quiz_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY quizzes ALTER COLUMN id SET DEFAULT nextval('quizzes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY role_users ALTER COLUMN id SET DEFAULT nextval('role_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY scaled_scores ALTER COLUMN id SET DEFAULT nextval('scaled_scores_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY section_types ALTER COLUMN id SET DEFAULT nextval('section_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sections ALTER COLUMN id SET DEFAULT nextval('sections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY topics ALTER COLUMN id SET DEFAULT nextval('topics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions ALTER COLUMN id SET DEFAULT nextval('transactions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY types ALTER COLUMN id SET DEFAULT nextval('types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY visits ALTER COLUMN id SET DEFAULT nextval('visits_id_seq'::regclass);


--
-- Name: activity_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activity_logs
    ADD CONSTRAINT activity_logs_pkey PRIMARY KEY (id);


--
-- Name: attempt_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY attempt_details
    ADD CONSTRAINT attempt_details_pkey PRIMARY KEY (id);


--
-- Name: attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY attempts
    ADD CONSTRAINT attempts_pkey PRIMARY KEY (id);


--
-- Name: cart_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cart_items
    ADD CONSTRAINT cart_items_pkey PRIMARY KEY (id);


--
-- Name: carts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: dictionaries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dictionaries
    ADD CONSTRAINT dictionaries_pkey PRIMARY KEY (id);


--
-- Name: offer_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY offer_codes
    ADD CONSTRAINT offer_codes_pkey PRIMARY KEY (id);


--
-- Name: offer_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY offer_items
    ADD CONSTRAINT offer_items_pkey PRIMARY KEY (id);


--
-- Name: offer_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY offer_users
    ADD CONSTRAINT offer_users_pkey PRIMARY KEY (id);


--
-- Name: offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (id);


--
-- Name: options_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY options
    ADD CONSTRAINT options_pkey PRIMARY KEY (id);


--
-- Name: orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: package_quizzes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY package_quizzes
    ADD CONSTRAINT package_quizzes_pkey PRIMARY KEY (id);


--
-- Name: packages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY packages
    ADD CONSTRAINT packages_pkey PRIMARY KEY (id);


--
-- Name: questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: quiz_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY quiz_types
    ADD CONSTRAINT quiz_types_pkey PRIMARY KEY (id);


--
-- Name: quiz_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY quiz_users
    ADD CONSTRAINT quiz_users_pkey PRIMARY KEY (id);


--
-- Name: quizzes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY quizzes
    ADD CONSTRAINT quizzes_pkey PRIMARY KEY (id);


--
-- Name: role_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY role_users
    ADD CONSTRAINT role_users_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: scaled_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY scaled_scores
    ADD CONSTRAINT scaled_scores_pkey PRIMARY KEY (id);


--
-- Name: section_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY section_types
    ADD CONSTRAINT section_types_pkey PRIMARY KEY (id);


--
-- Name: sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- Name: topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY types
    ADD CONSTRAINT types_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY visits
    ADD CONSTRAINT visits_pkey PRIMARY KEY (id);


--
-- Name: attempts_report; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX attempts_report ON attempts USING gin (report);


--
-- Name: index_attempts_on_quiz_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_attempts_on_quiz_id ON attempts USING btree (quiz_id);


--
-- Name: index_attempts_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_attempts_on_user_id ON attempts USING btree (user_id);


--
-- Name: index_attempts_on_user_id_and_quiz_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_attempts_on_user_id_and_quiz_id ON attempts USING btree (user_id, quiz_id);


--
-- Name: index_cart_items_on_cart_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cart_items_on_cart_id ON cart_items USING btree (cart_id);


--
-- Name: index_cart_items_on_package_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cart_items_on_package_id ON cart_items USING btree (package_id);


--
-- Name: index_cart_items_on_quiz_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cart_items_on_quiz_id ON cart_items USING btree (quiz_id);


--
-- Name: index_carts_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_carts_on_user_id ON carts USING btree (user_id);


--
-- Name: index_categories_on_section_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categories_on_section_type_id ON categories USING btree (section_type_id);


--
-- Name: index_categories_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categories_on_slug ON categories USING btree (slug);


--
-- Name: index_offer_items_on_offer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_offer_items_on_offer_id ON offer_items USING btree (offer_id);


--
-- Name: index_offer_items_on_package_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_offer_items_on_package_id ON offer_items USING btree (package_id);


--
-- Name: index_offer_items_on_quiz_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_offer_items_on_quiz_id ON offer_items USING btree (quiz_id);


--
-- Name: index_offer_users_on_offer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_offer_users_on_offer_id ON offer_users USING btree (offer_id);


--
-- Name: index_offer_users_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_offer_users_on_user_id ON offer_users USING btree (user_id);


--
-- Name: index_offers_on_offer_code_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_offers_on_offer_code_id ON offers USING btree (offer_code_id);


--
-- Name: index_options_on_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_options_on_question_id ON options USING btree (question_id);


--
-- Name: index_package_quizzes_on_package_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_package_quizzes_on_package_id ON package_quizzes USING btree (package_id);


--
-- Name: index_package_quizzes_on_quiz_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_package_quizzes_on_quiz_id ON package_quizzes USING btree (quiz_id);


--
-- Name: index_packages_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_packages_on_slug ON packages USING btree (slug);


--
-- Name: index_questions_on_section_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_section_id ON questions USING btree (section_id);


--
-- Name: index_questions_on_topic_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_topic_id ON questions USING btree (topic_id);


--
-- Name: index_questions_on_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_type_id ON questions USING btree (type_id);


--
-- Name: index_quiz_types_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_quiz_types_on_slug ON quiz_types USING btree (slug);


--
-- Name: index_quiz_users_on_quiz_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_quiz_users_on_quiz_id ON quiz_users USING btree (quiz_id);


--
-- Name: index_quiz_users_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_quiz_users_on_user_id ON quiz_users USING btree (user_id);


--
-- Name: index_quizzes_on_approver_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_quizzes_on_approver_id ON quizzes USING btree (approver_id);


--
-- Name: index_quizzes_on_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_quizzes_on_category_id ON quizzes USING btree (category_id);


--
-- Name: index_quizzes_on_publisher_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_quizzes_on_publisher_id ON quizzes USING btree (publisher_id);


--
-- Name: index_quizzes_on_quiz_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_quizzes_on_quiz_type_id ON quizzes USING btree (quiz_type_id);


--
-- Name: index_quizzes_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_quizzes_on_slug ON quizzes USING btree (slug);


--
-- Name: index_quizzes_on_topic_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_quizzes_on_topic_id ON quizzes USING btree (topic_id);


--
-- Name: index_role_users_on_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_role_users_on_role_id ON role_users USING btree (role_id);


--
-- Name: index_role_users_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_role_users_on_user_id ON role_users USING btree (user_id);


--
-- Name: index_section_types_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_section_types_on_slug ON section_types USING btree (slug);


--
-- Name: index_sections_on_quiz_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sections_on_quiz_id ON sections USING btree (quiz_id);


--
-- Name: index_sections_on_section_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sections_on_section_type_id ON sections USING btree (section_type_id);


--
-- Name: index_sections_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sections_on_slug ON sections USING btree (slug);


--
-- Name: index_topics_on_section_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_topics_on_section_type_id ON topics USING btree (section_type_id);


--
-- Name: index_topics_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_topics_on_slug ON topics USING btree (slug);


--
-- Name: index_transactions_on_order_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_transactions_on_order_id ON transactions USING btree (order_id);


--
-- Name: index_transactions_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_transactions_on_user_id ON transactions USING btree (user_id);


--
-- Name: index_types_on_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_types_on_category_id ON types USING btree (category_id);


--
-- Name: index_types_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_types_on_slug ON types USING btree (slug);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20121111180407');

INSERT INTO schema_migrations (version) VALUES ('20121112204243');

INSERT INTO schema_migrations (version) VALUES ('20121112204547');

INSERT INTO schema_migrations (version) VALUES ('20121205233455');

INSERT INTO schema_migrations (version) VALUES ('20121205235212');

INSERT INTO schema_migrations (version) VALUES ('20121206001253');

INSERT INTO schema_migrations (version) VALUES ('20121206012300');

INSERT INTO schema_migrations (version) VALUES ('20121206013744');

INSERT INTO schema_migrations (version) VALUES ('20121206091147');

INSERT INTO schema_migrations (version) VALUES ('20121206112152');

INSERT INTO schema_migrations (version) VALUES ('20121207232627');

INSERT INTO schema_migrations (version) VALUES ('20121208005931');

INSERT INTO schema_migrations (version) VALUES ('20121216192517');

INSERT INTO schema_migrations (version) VALUES ('20121217231343');

INSERT INTO schema_migrations (version) VALUES ('20121220222528');

INSERT INTO schema_migrations (version) VALUES ('20121221065229');

INSERT INTO schema_migrations (version) VALUES ('20121221215447');

INSERT INTO schema_migrations (version) VALUES ('20121222180113');

INSERT INTO schema_migrations (version) VALUES ('20121225224309');

INSERT INTO schema_migrations (version) VALUES ('20121227113044');

INSERT INTO schema_migrations (version) VALUES ('20121227113216');

INSERT INTO schema_migrations (version) VALUES ('20130101195215');

INSERT INTO schema_migrations (version) VALUES ('20130102125713');

INSERT INTO schema_migrations (version) VALUES ('20130102131246');

INSERT INTO schema_migrations (version) VALUES ('20130107191645');

INSERT INTO schema_migrations (version) VALUES ('20130109220635');

INSERT INTO schema_migrations (version) VALUES ('20130110172903');

INSERT INTO schema_migrations (version) VALUES ('20130111164433');

INSERT INTO schema_migrations (version) VALUES ('20130111171611');

INSERT INTO schema_migrations (version) VALUES ('20130111172007');

INSERT INTO schema_migrations (version) VALUES ('20130112000323');

INSERT INTO schema_migrations (version) VALUES ('20130112000405');

INSERT INTO schema_migrations (version) VALUES ('20130112000418');

INSERT INTO schema_migrations (version) VALUES ('20130112074053');

INSERT INTO schema_migrations (version) VALUES ('20130112094520');

INSERT INTO schema_migrations (version) VALUES ('20130112183246');

INSERT INTO schema_migrations (version) VALUES ('20130112183956');

INSERT INTO schema_migrations (version) VALUES ('20130115102326');

INSERT INTO schema_migrations (version) VALUES ('20130119094552');

INSERT INTO schema_migrations (version) VALUES ('20130120201643');

INSERT INTO schema_migrations (version) VALUES ('20130122181334');

INSERT INTO schema_migrations (version) VALUES ('20130122191725');

INSERT INTO schema_migrations (version) VALUES ('20130122195815');

INSERT INTO schema_migrations (version) VALUES ('20130122200106');

INSERT INTO schema_migrations (version) VALUES ('20130122201245');

INSERT INTO schema_migrations (version) VALUES ('20130124103136');

INSERT INTO schema_migrations (version) VALUES ('20130124103205');

INSERT INTO schema_migrations (version) VALUES ('20130124103820');

INSERT INTO schema_migrations (version) VALUES ('20130124103847');

INSERT INTO schema_migrations (version) VALUES ('20130125223704');

INSERT INTO schema_migrations (version) VALUES ('20130127065706');

INSERT INTO schema_migrations (version) VALUES ('20130127142507');

INSERT INTO schema_migrations (version) VALUES ('20130127142907');

INSERT INTO schema_migrations (version) VALUES ('20130127144155');

INSERT INTO schema_migrations (version) VALUES ('20130127144813');

INSERT INTO schema_migrations (version) VALUES ('20130129100743');

INSERT INTO schema_migrations (version) VALUES ('20130203154706');

INSERT INTO schema_migrations (version) VALUES ('20130205180303');

INSERT INTO schema_migrations (version) VALUES ('20130208120336');

INSERT INTO schema_migrations (version) VALUES ('20130208212447');

INSERT INTO schema_migrations (version) VALUES ('20130208213101');

INSERT INTO schema_migrations (version) VALUES ('20130209182543');