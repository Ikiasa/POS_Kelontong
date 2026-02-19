--
-- PostgreSQL database dump
--

\restrict 8fFDnUCw8UFg93rvKE8ASGKaZrnyil3f2LUgUDsTIMp9LZY6Zkp65rzrFLo7mcq

-- Dumped from database version 15.15
-- Dumped by pg_dump version 15.15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.accounts (
    id bigint NOT NULL,
    code character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone,
    CONSTRAINT accounts_type_check CHECK (((type)::text = ANY ((ARRAY['asset'::character varying, 'liability'::character varying, 'equity'::character varying, 'revenue'::character varying, 'expense'::character varying])::text[])))
);


ALTER TABLE public.accounts OWNER TO bihadmin;

--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_id_seq OWNER TO bihadmin;

--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: ai_insights; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.ai_insights (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    type character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    explanation text NOT NULL,
    suggestion_data json NOT NULL,
    estimated_impact numeric(15,2),
    status character varying(255) DEFAULT 'pending'::character varying NOT NULL,
    approved_at timestamp(0) without time zone,
    applied_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.ai_insights OWNER TO bihadmin;

--
-- Name: ai_insights_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.ai_insights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ai_insights_id_seq OWNER TO bihadmin;

--
-- Name: ai_insights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.ai_insights_id_seq OWNED BY public.ai_insights.id;


--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.audit_logs (
    id bigint NOT NULL,
    user_id bigint,
    action character varying(255) NOT NULL,
    target_type character varying(255),
    target_id bigint,
    old_values json,
    new_values json,
    ip_address character varying(255),
    user_agent character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.audit_logs OWNER TO bihadmin;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.audit_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.audit_logs_id_seq OWNER TO bihadmin;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: budgets; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.budgets (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    category_name character varying(255) NOT NULL,
    amount_limit numeric(15,2) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    notes text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.budgets OWNER TO bihadmin;

--
-- Name: budgets_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.budgets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.budgets_id_seq OWNER TO bihadmin;

--
-- Name: budgets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.budgets_id_seq OWNED BY public.budgets.id;


--
-- Name: business_health_scores; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.business_health_scores (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    score integer NOT NULL,
    breakdown json NOT NULL,
    explanation text,
    calculated_at date NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.business_health_scores OWNER TO bihadmin;

--
-- Name: business_health_scores_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.business_health_scores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.business_health_scores_id_seq OWNER TO bihadmin;

--
-- Name: business_health_scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.business_health_scores_id_seq OWNED BY public.business_health_scores.id;


--
-- Name: cache; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.cache (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    expiration integer NOT NULL
);


ALTER TABLE public.cache OWNER TO bihadmin;

--
-- Name: cache_locks; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.cache_locks (
    key character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    expiration integer NOT NULL
);


ALTER TABLE public.cache_locks OWNER TO bihadmin;

--
-- Name: cash_drawers; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.cash_drawers (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    user_id bigint NOT NULL,
    opening_balance numeric(15,2) NOT NULL,
    closing_balance numeric(15,2),
    expected_balance numeric(15,2),
    variance numeric(15,2),
    notes text,
    opened_at timestamp(0) without time zone NOT NULL,
    closed_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.cash_drawers OWNER TO bihadmin;

--
-- Name: cash_drawers_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.cash_drawers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cash_drawers_id_seq OWNER TO bihadmin;

--
-- Name: cash_drawers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.cash_drawers_id_seq OWNED BY public.cash_drawers.id;


--
-- Name: cashflow_projections; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.cashflow_projections (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    projection_date date NOT NULL,
    projected_incoming numeric(15,2) NOT NULL,
    projected_outgoing numeric(15,2) NOT NULL,
    net_balance numeric(15,2) NOT NULL,
    source_data json NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.cashflow_projections OWNER TO bihadmin;

--
-- Name: cashflow_projections_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.cashflow_projections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cashflow_projections_id_seq OWNER TO bihadmin;

--
-- Name: cashflow_projections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.cashflow_projections_id_seq OWNED BY public.cashflow_projections.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.categories OWNER TO bihadmin;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_id_seq OWNER TO bihadmin;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: competitor_prices; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.competitor_prices (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    competitor_name character varying(255) NOT NULL,
    price numeric(15,2) NOT NULL,
    checked_at timestamp(0) without time zone NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.competitor_prices OWNER TO bihadmin;

--
-- Name: competitor_prices_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.competitor_prices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.competitor_prices_id_seq OWNER TO bihadmin;

--
-- Name: competitor_prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.competitor_prices_id_seq OWNED BY public.competitor_prices.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.customers (
    id bigint NOT NULL,
    store_id bigint,
    name character varying(255) NOT NULL,
    phone character varying(255) NOT NULL,
    email character varying(255),
    points_balance integer DEFAULT 0 NOT NULL,
    tier character varying(255) DEFAULT 'silver'::character varying NOT NULL,
    last_visit_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.customers OWNER TO bihadmin;

--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_id_seq OWNER TO bihadmin;

--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- Name: employee_risk_scores; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.employee_risk_scores (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    user_id bigint NOT NULL,
    risk_score numeric(5,2) NOT NULL,
    risk_level character varying(255) NOT NULL,
    indicators json NOT NULL,
    metadata json,
    calculated_at timestamp(0) without time zone NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.employee_risk_scores OWNER TO bihadmin;

--
-- Name: employee_risk_scores_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.employee_risk_scores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_risk_scores_id_seq OWNER TO bihadmin;

--
-- Name: employee_risk_scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.employee_risk_scores_id_seq OWNED BY public.employee_risk_scores.id;


--
-- Name: failed_jobs; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.failed_jobs OWNER TO bihadmin;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.failed_jobs_id_seq OWNER TO bihadmin;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;


--
-- Name: fraud_alerts; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.fraud_alerts (
    id bigint NOT NULL,
    reference_id character varying(255),
    model_type character varying(255),
    rule_name character varying(255) NOT NULL,
    description text NOT NULL,
    severity character varying(255) DEFAULT 'medium'::character varying NOT NULL,
    user_id bigint,
    resolved boolean DEFAULT false NOT NULL,
    resolved_at timestamp(0) without time zone,
    resolved_by bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.fraud_alerts OWNER TO bihadmin;

--
-- Name: fraud_alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.fraud_alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fraud_alerts_id_seq OWNER TO bihadmin;

--
-- Name: fraud_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.fraud_alerts_id_seq OWNED BY public.fraud_alerts.id;


--
-- Name: installments; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.installments (
    id bigint NOT NULL,
    transaction_id uuid NOT NULL,
    installment_number integer NOT NULL,
    due_date date NOT NULL,
    amount numeric(15,2) NOT NULL,
    paid_amount numeric(15,2) DEFAULT '0'::numeric NOT NULL,
    status character varying(255) DEFAULT 'pending'::character varying NOT NULL,
    paid_at timestamp(0) without time zone,
    notes character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.installments OWNER TO bihadmin;

--
-- Name: installments_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.installments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.installments_id_seq OWNER TO bihadmin;

--
-- Name: installments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.installments_id_seq OWNED BY public.installments.id;


--
-- Name: inventory_valuations; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.inventory_valuations (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    total_value numeric(15,2) NOT NULL,
    total_items integer NOT NULL,
    valuation_date date NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.inventory_valuations OWNER TO bihadmin;

--
-- Name: inventory_valuations_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.inventory_valuations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inventory_valuations_id_seq OWNER TO bihadmin;

--
-- Name: inventory_valuations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.inventory_valuations_id_seq OWNED BY public.inventory_valuations.id;


--
-- Name: job_batches; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.job_batches (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    total_jobs integer NOT NULL,
    pending_jobs integer NOT NULL,
    failed_jobs integer NOT NULL,
    failed_job_ids text NOT NULL,
    options text,
    cancelled_at integer,
    created_at integer NOT NULL,
    finished_at integer
);


ALTER TABLE public.job_batches OWNER TO bihadmin;

--
-- Name: jobs; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.jobs (
    id bigint NOT NULL,
    queue character varying(255) NOT NULL,
    payload text NOT NULL,
    attempts smallint NOT NULL,
    reserved_at integer,
    available_at integer NOT NULL,
    created_at integer NOT NULL
);


ALTER TABLE public.jobs OWNER TO bihadmin;

--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.jobs_id_seq OWNER TO bihadmin;

--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: journal_entries; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.journal_entries (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    user_id bigint,
    reference_number character varying(255) NOT NULL,
    transaction_date date NOT NULL,
    description character varying(255) NOT NULL,
    reference_type character varying(255),
    reference_id character varying(255) NOT NULL,
    is_posted boolean DEFAULT false NOT NULL,
    posted_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


ALTER TABLE public.journal_entries OWNER TO bihadmin;

--
-- Name: journal_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.journal_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.journal_entries_id_seq OWNER TO bihadmin;

--
-- Name: journal_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.journal_entries_id_seq OWNED BY public.journal_entries.id;


--
-- Name: journal_items; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.journal_items (
    id bigint NOT NULL,
    journal_entry_id bigint NOT NULL,
    account_code character varying(255) NOT NULL,
    account_name character varying(255) NOT NULL,
    debit numeric(15,2) DEFAULT '0'::numeric NOT NULL,
    credit numeric(15,2) DEFAULT '0'::numeric NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.journal_items OWNER TO bihadmin;

--
-- Name: journal_items_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.journal_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.journal_items_id_seq OWNER TO bihadmin;

--
-- Name: journal_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.journal_items_id_seq OWNED BY public.journal_items.id;


--
-- Name: loyalty_logs; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.loyalty_logs (
    id bigint NOT NULL,
    customer_id bigint NOT NULL,
    transaction_id uuid,
    points integer NOT NULL,
    type character varying(255) NOT NULL,
    description character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.loyalty_logs OWNER TO bihadmin;

--
-- Name: loyalty_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.loyalty_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.loyalty_logs_id_seq OWNER TO bihadmin;

--
-- Name: loyalty_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.loyalty_logs_id_seq OWNED BY public.loyalty_logs.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO bihadmin;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.migrations_id_seq OWNER TO bihadmin;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


ALTER TABLE public.password_reset_tokens OWNER TO bihadmin;

--
-- Name: price_tiers; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.price_tiers (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    store_id bigint,
    tier_name character varying(255) NOT NULL,
    price numeric(15,2) NOT NULL,
    min_quantity integer DEFAULT 1 NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.price_tiers OWNER TO bihadmin;

--
-- Name: price_tiers_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.price_tiers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.price_tiers_id_seq OWNER TO bihadmin;

--
-- Name: price_tiers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.price_tiers_id_seq OWNED BY public.price_tiers.id;


--
-- Name: product_batches; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.product_batches (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    product_id bigint NOT NULL,
    batch_number character varying(255) NOT NULL,
    expiry_date date,
    cost_price numeric(15,2) NOT NULL,
    initial_quantity integer NOT NULL,
    current_quantity integer NOT NULL,
    received_at timestamp(0) without time zone NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.product_batches OWNER TO bihadmin;

--
-- Name: product_batches_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.product_batches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_batches_id_seq OWNER TO bihadmin;

--
-- Name: product_batches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.product_batches_id_seq OWNED BY public.product_batches.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    store_id bigint,
    category_id bigint,
    name character varying(255) NOT NULL,
    barcode character varying(255),
    price numeric(15,2) NOT NULL,
    cost_price numeric(15,2) DEFAULT '0'::numeric NOT NULL,
    stock integer DEFAULT 0 NOT NULL,
    image character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    lead_time_days integer DEFAULT 7 NOT NULL,
    safety_stock integer DEFAULT 10 NOT NULL,
    last_sold_at timestamp(0) without time zone,
    supplier_id bigint
);


ALTER TABLE public.products OWNER TO bihadmin;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_id_seq OWNER TO bihadmin;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: profit_risk_scores; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.profit_risk_scores (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    user_id bigint,
    risk_score integer NOT NULL,
    indicators json NOT NULL,
    metadata json,
    calculated_at date NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.profit_risk_scores OWNER TO bihadmin;

--
-- Name: profit_risk_scores_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.profit_risk_scores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.profit_risk_scores_id_seq OWNER TO bihadmin;

--
-- Name: profit_risk_scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.profit_risk_scores_id_seq OWNED BY public.profit_risk_scores.id;


--
-- Name: promotions; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.promotions (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    value numeric(15,2) NOT NULL,
    start_date timestamp(0) without time zone NOT NULL,
    end_date timestamp(0) without time zone NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    product_id bigint,
    category_id bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.promotions OWNER TO bihadmin;

--
-- Name: promotions_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.promotions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.promotions_id_seq OWNER TO bihadmin;

--
-- Name: promotions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.promotions_id_seq OWNED BY public.promotions.id;


--
-- Name: purchase_order_items; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.purchase_order_items (
    id bigint NOT NULL,
    purchase_order_id bigint NOT NULL,
    product_id bigint NOT NULL,
    quantity integer NOT NULL,
    unit_cost numeric(15,2) NOT NULL,
    total_cost numeric(15,2) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.purchase_order_items OWNER TO bihadmin;

--
-- Name: purchase_order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.purchase_order_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_order_items_id_seq OWNER TO bihadmin;

--
-- Name: purchase_order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.purchase_order_items_id_seq OWNED BY public.purchase_order_items.id;


--
-- Name: purchase_orders; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.purchase_orders (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    supplier_id bigint NOT NULL,
    user_id bigint,
    po_number character varying(255) NOT NULL,
    total_amount numeric(15,2) NOT NULL,
    status character varying(255) DEFAULT 'suggested'::character varying NOT NULL,
    ordered_at timestamp(0) without time zone,
    expected_at timestamp(0) without time zone,
    received_at timestamp(0) without time zone,
    notes text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.purchase_orders OWNER TO bihadmin;

--
-- Name: purchase_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.purchase_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_orders_id_seq OWNER TO bihadmin;

--
-- Name: purchase_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.purchase_orders_id_seq OWNED BY public.purchase_orders.id;


--
-- Name: return_items; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.return_items (
    id bigint NOT NULL,
    return_transaction_id uuid NOT NULL,
    product_id bigint NOT NULL,
    quantity integer NOT NULL,
    refund_price numeric(15,2) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.return_items OWNER TO bihadmin;

--
-- Name: return_items_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.return_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.return_items_id_seq OWNER TO bihadmin;

--
-- Name: return_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.return_items_id_seq OWNED BY public.return_items.id;


--
-- Name: return_transactions; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.return_transactions (
    id uuid NOT NULL,
    transaction_id uuid NOT NULL,
    store_id bigint NOT NULL,
    user_id bigint NOT NULL,
    total_refunded numeric(15,2) NOT NULL,
    payment_method character varying(255) NOT NULL,
    reason text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.return_transactions OWNER TO bihadmin;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.sessions (
    id character varying(255) NOT NULL,
    user_id bigint,
    ip_address character varying(45),
    user_agent text,
    payload text NOT NULL,
    last_activity integer NOT NULL
);


ALTER TABLE public.sessions OWNER TO bihadmin;

--
-- Name: stock_movements; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.stock_movements (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    product_id bigint NOT NULL,
    user_id bigint,
    reference_type character varying(255) NOT NULL,
    reference_id character varying(255) NOT NULL,
    quantity integer NOT NULL,
    after_stock integer NOT NULL,
    notes character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    before_stock integer DEFAULT 0 NOT NULL,
    type character varying(255),
    batch_id bigint
);


ALTER TABLE public.stock_movements OWNER TO bihadmin;

--
-- Name: stock_movements_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.stock_movements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_movements_id_seq OWNER TO bihadmin;

--
-- Name: stock_movements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.stock_movements_id_seq OWNED BY public.stock_movements.id;


--
-- Name: stock_opname_items; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.stock_opname_items (
    id bigint NOT NULL,
    stock_opname_id bigint NOT NULL,
    product_id bigint NOT NULL,
    system_stock integer NOT NULL,
    physical_stock integer NOT NULL,
    difference integer NOT NULL,
    notes text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.stock_opname_items OWNER TO bihadmin;

--
-- Name: stock_opname_items_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.stock_opname_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_opname_items_id_seq OWNER TO bihadmin;

--
-- Name: stock_opname_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.stock_opname_items_id_seq OWNED BY public.stock_opname_items.id;


--
-- Name: stock_opnames; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.stock_opnames (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    user_id bigint,
    reference_number character varying(255) NOT NULL,
    opname_date date NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    notes text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.stock_opnames OWNER TO bihadmin;

--
-- Name: stock_opnames_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.stock_opnames_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_opnames_id_seq OWNER TO bihadmin;

--
-- Name: stock_opnames_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.stock_opnames_id_seq OWNED BY public.stock_opnames.id;


--
-- Name: stock_transfer_items; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.stock_transfer_items (
    id bigint NOT NULL,
    stock_transfer_id bigint NOT NULL,
    product_id bigint NOT NULL,
    request_quantity integer NOT NULL,
    shipped_quantity integer,
    received_quantity integer,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.stock_transfer_items OWNER TO bihadmin;

--
-- Name: stock_transfer_items_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.stock_transfer_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_transfer_items_id_seq OWNER TO bihadmin;

--
-- Name: stock_transfer_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.stock_transfer_items_id_seq OWNED BY public.stock_transfer_items.id;


--
-- Name: stock_transfers; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.stock_transfers (
    id bigint NOT NULL,
    transfer_number character varying(255) NOT NULL,
    source_store_id bigint NOT NULL,
    dest_store_id bigint NOT NULL,
    created_by bigint NOT NULL,
    received_by bigint,
    status character varying(255) DEFAULT 'pending'::character varying NOT NULL,
    shipped_at timestamp(0) without time zone,
    received_at timestamp(0) without time zone,
    notes text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.stock_transfers OWNER TO bihadmin;

--
-- Name: stock_transfers_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.stock_transfers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_transfers_id_seq OWNER TO bihadmin;

--
-- Name: stock_transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.stock_transfers_id_seq OWNED BY public.stock_transfers.id;


--
-- Name: store_wallets; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.store_wallets (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    provider character varying(255) NOT NULL,
    balance numeric(15,2) DEFAULT '0'::numeric NOT NULL,
    last_reconciled_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.store_wallets OWNER TO bihadmin;

--
-- Name: store_wallets_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.store_wallets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.store_wallets_id_seq OWNER TO bihadmin;

--
-- Name: store_wallets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.store_wallets_id_seq OWNED BY public.store_wallets.id;


--
-- Name: stores; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.stores (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    address character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.stores OWNER TO bihadmin;

--
-- Name: stores_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.stores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stores_id_seq OWNER TO bihadmin;

--
-- Name: stores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.stores_id_seq OWNED BY public.stores.id;


--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.suppliers (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    contact_person character varying(255),
    phone character varying(255),
    email character varying(255),
    address text,
    default_lead_time_days integer DEFAULT 3 NOT NULL,
    minimum_order_value numeric(15,2) DEFAULT '0'::numeric NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.suppliers OWNER TO bihadmin;

--
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.suppliers_id_seq OWNER TO bihadmin;

--
-- Name: suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;


--
-- Name: system_alerts; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.system_alerts (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    type character varying(255) NOT NULL,
    message text NOT NULL,
    severity character varying(255) NOT NULL,
    metadata json,
    read_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT system_alerts_severity_check CHECK (((severity)::text = ANY ((ARRAY['info'::character varying, 'warning'::character varying, 'critical'::character varying])::text[])))
);


ALTER TABLE public.system_alerts OWNER TO bihadmin;

--
-- Name: system_alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.system_alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.system_alerts_id_seq OWNER TO bihadmin;

--
-- Name: system_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.system_alerts_id_seq OWNED BY public.system_alerts.id;


--
-- Name: transaction_items; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.transaction_items (
    id bigint NOT NULL,
    transaction_id uuid NOT NULL,
    product_id bigint NOT NULL,
    product_name character varying(255) NOT NULL,
    price numeric(15,2) NOT NULL,
    cost_price numeric(15,2) DEFAULT '0'::numeric NOT NULL,
    quantity integer NOT NULL,
    total numeric(15,2) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    batch_id bigint
);


ALTER TABLE public.transaction_items OWNER TO bihadmin;

--
-- Name: transaction_items_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.transaction_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transaction_items_id_seq OWNER TO bihadmin;

--
-- Name: transaction_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.transaction_items_id_seq OWNED BY public.transaction_items.id;


--
-- Name: transaction_payments; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.transaction_payments (
    id bigint NOT NULL,
    transaction_id uuid NOT NULL,
    method character varying(255) NOT NULL,
    amount numeric(15,2) NOT NULL,
    reference_number character varying(255),
    metadata json,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.transaction_payments OWNER TO bihadmin;

--
-- Name: transaction_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.transaction_payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transaction_payments_id_seq OWNER TO bihadmin;

--
-- Name: transaction_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.transaction_payments_id_seq OWNED BY public.transaction_payments.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.transactions (
    id uuid NOT NULL,
    store_id bigint NOT NULL,
    user_id bigint NOT NULL,
    invoice_number character varying(255) NOT NULL,
    subtotal numeric(15,2) NOT NULL,
    tax numeric(15,2) DEFAULT '0'::numeric NOT NULL,
    discount numeric(15,2) DEFAULT '0'::numeric NOT NULL,
    grand_total numeric(15,2) NOT NULL,
    cash_received numeric(15,2),
    change_amount numeric(15,2),
    payment_method character varying(255) NOT NULL,
    status character varying(255) DEFAULT 'completed'::character varying NOT NULL,
    notes character varying(255),
    transaction_date timestamp(0) without time zone NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    customer_id bigint,
    points_earned integer DEFAULT 0 NOT NULL,
    points_redeemed integer DEFAULT 0 NOT NULL,
    service_charge numeric(15,2) DEFAULT '0'::numeric NOT NULL,
    payment_details json
);


ALTER TABLE public.transactions OWNER TO bihadmin;

--
-- Name: users; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    store_id bigint,
    role character varying(255) DEFAULT 'cashier'::character varying NOT NULL,
    deleted_at timestamp(0) without time zone
);


ALTER TABLE public.users OWNER TO bihadmin;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO bihadmin;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: whatsapp_logs; Type: TABLE; Schema: public; Owner: bihadmin
--

CREATE TABLE public.whatsapp_logs (
    id bigint NOT NULL,
    customer_id bigint,
    phone character varying(255) NOT NULL,
    message text NOT NULL,
    type character varying(255) NOT NULL,
    status character varying(255) DEFAULT 'queued'::character varying NOT NULL,
    sent_at timestamp(0) without time zone,
    error_message text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.whatsapp_logs OWNER TO bihadmin;

--
-- Name: whatsapp_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: bihadmin
--

CREATE SEQUENCE public.whatsapp_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.whatsapp_logs_id_seq OWNER TO bihadmin;

--
-- Name: whatsapp_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bihadmin
--

ALTER SEQUENCE public.whatsapp_logs_id_seq OWNED BY public.whatsapp_logs.id;


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: ai_insights id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.ai_insights ALTER COLUMN id SET DEFAULT nextval('public.ai_insights_id_seq'::regclass);


--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Name: budgets id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.budgets ALTER COLUMN id SET DEFAULT nextval('public.budgets_id_seq'::regclass);


--
-- Name: business_health_scores id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.business_health_scores ALTER COLUMN id SET DEFAULT nextval('public.business_health_scores_id_seq'::regclass);


--
-- Name: cash_drawers id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.cash_drawers ALTER COLUMN id SET DEFAULT nextval('public.cash_drawers_id_seq'::regclass);


--
-- Name: cashflow_projections id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.cashflow_projections ALTER COLUMN id SET DEFAULT nextval('public.cashflow_projections_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: competitor_prices id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.competitor_prices ALTER COLUMN id SET DEFAULT nextval('public.competitor_prices_id_seq'::regclass);


--
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- Name: employee_risk_scores id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.employee_risk_scores ALTER COLUMN id SET DEFAULT nextval('public.employee_risk_scores_id_seq'::regclass);


--
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- Name: fraud_alerts id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.fraud_alerts ALTER COLUMN id SET DEFAULT nextval('public.fraud_alerts_id_seq'::regclass);


--
-- Name: installments id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.installments ALTER COLUMN id SET DEFAULT nextval('public.installments_id_seq'::regclass);


--
-- Name: inventory_valuations id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.inventory_valuations ALTER COLUMN id SET DEFAULT nextval('public.inventory_valuations_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: journal_entries id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.journal_entries ALTER COLUMN id SET DEFAULT nextval('public.journal_entries_id_seq'::regclass);


--
-- Name: journal_items id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.journal_items ALTER COLUMN id SET DEFAULT nextval('public.journal_items_id_seq'::regclass);


--
-- Name: loyalty_logs id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.loyalty_logs ALTER COLUMN id SET DEFAULT nextval('public.loyalty_logs_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: price_tiers id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.price_tiers ALTER COLUMN id SET DEFAULT nextval('public.price_tiers_id_seq'::regclass);


--
-- Name: product_batches id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.product_batches ALTER COLUMN id SET DEFAULT nextval('public.product_batches_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: profit_risk_scores id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.profit_risk_scores ALTER COLUMN id SET DEFAULT nextval('public.profit_risk_scores_id_seq'::regclass);


--
-- Name: promotions id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.promotions ALTER COLUMN id SET DEFAULT nextval('public.promotions_id_seq'::regclass);


--
-- Name: purchase_order_items id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.purchase_order_items ALTER COLUMN id SET DEFAULT nextval('public.purchase_order_items_id_seq'::regclass);


--
-- Name: purchase_orders id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.purchase_orders ALTER COLUMN id SET DEFAULT nextval('public.purchase_orders_id_seq'::regclass);


--
-- Name: return_items id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.return_items ALTER COLUMN id SET DEFAULT nextval('public.return_items_id_seq'::regclass);


--
-- Name: stock_movements id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_movements ALTER COLUMN id SET DEFAULT nextval('public.stock_movements_id_seq'::regclass);


--
-- Name: stock_opname_items id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_opname_items ALTER COLUMN id SET DEFAULT nextval('public.stock_opname_items_id_seq'::regclass);


--
-- Name: stock_opnames id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_opnames ALTER COLUMN id SET DEFAULT nextval('public.stock_opnames_id_seq'::regclass);


--
-- Name: stock_transfer_items id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_transfer_items ALTER COLUMN id SET DEFAULT nextval('public.stock_transfer_items_id_seq'::regclass);


--
-- Name: stock_transfers id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_transfers ALTER COLUMN id SET DEFAULT nextval('public.stock_transfers_id_seq'::regclass);


--
-- Name: store_wallets id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.store_wallets ALTER COLUMN id SET DEFAULT nextval('public.store_wallets_id_seq'::regclass);


--
-- Name: stores id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stores ALTER COLUMN id SET DEFAULT nextval('public.stores_id_seq'::regclass);


--
-- Name: suppliers id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);


--
-- Name: system_alerts id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.system_alerts ALTER COLUMN id SET DEFAULT nextval('public.system_alerts_id_seq'::regclass);


--
-- Name: transaction_items id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.transaction_items ALTER COLUMN id SET DEFAULT nextval('public.transaction_items_id_seq'::regclass);


--
-- Name: transaction_payments id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.transaction_payments ALTER COLUMN id SET DEFAULT nextval('public.transaction_payments_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: whatsapp_logs id; Type: DEFAULT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.whatsapp_logs ALTER COLUMN id SET DEFAULT nextval('public.whatsapp_logs_id_seq'::regclass);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.accounts (id, code, name, type, description, is_active, created_at, updated_at, deleted_at) FROM stdin;
1	1-1001	Kas Tunai	asset	Uang tunai di tangan	t	2026-02-17 01:34:37	2026-02-17 01:34:37	\N
2	1-1002	Bank BCA	asset	Rekening Bank operasional	t	2026-02-17 01:34:37	2026-02-17 01:34:37	\N
3	1-1003	Piutang Usaha	asset	Tagihan ke pelanggan	t	2026-02-17 01:34:37	2026-02-17 01:34:37	\N
4	1-1004	Persediaan Barang	asset	Nilai stok barang dagang	t	2026-02-17 01:34:37	2026-02-17 01:34:37	\N
5	1-1005	Perlengkapan Toko	asset	Barang habis pakai toko	t	2026-02-17 01:34:37	2026-02-17 01:34:37	\N
6	2-2001	Hutang Usaha	liability	Tagihan dari supplier	t	2026-02-17 01:34:37	2026-02-17 01:34:37	\N
7	2-2002	Hutang Pajak	liability	Pajak yang belum disetor	t	2026-02-17 01:34:37	2026-02-17 01:34:37	\N
8	3-3001	Modal Pemilik	equity	Investasi awal pemilik	t	2026-02-17 01:34:37	2026-02-17 01:34:37	\N
9	3-3002	Laba Ditahan	equity	Akumulasi laba rugi tahun lalu	t	2026-02-17 01:34:37	2026-02-17 01:34:37	\N
10	4-4001	Penjualan Barang	revenue	Pendapatan dari penjualan produk	t	2026-02-17 01:34:37	2026-02-17 01:34:37	\N
11	4-4002	Pendapatan Jasa	revenue	Pendapatan dari layanan/service	t	2026-02-17 01:34:37	2026-02-17 01:34:37	\N
12	4-4003	Pendapatan Lain-lain	revenue	Pendapatan non-operasional	t	2026-02-17 01:34:37	2026-02-17 01:34:37	\N
13	5-5001	Harga Pokok Penjualan	expense	Biaya modal barang yang terjual	t	2026-02-17 01:34:37	2026-02-17 01:34:37	\N
14	5-5002	Beban Gaji	expense	Gaji karyawan	t	2026-02-17 01:34:37	2026-02-17 01:34:37	\N
15	5-5003	Beban Sewa	expense	Sewa tempat usaha	t	2026-02-17 01:34:37	2026-02-17 01:34:37	\N
16	5-5004	Beban Listrik & Air	expense	Tagihan utilitas bulanan	t	2026-02-17 01:34:37	2026-02-17 01:34:37	\N
17	5-5005	Beban Operasional Lain	expense	Pengeluaran kecil harian	t	2026-02-17 01:34:37	2026-02-17 01:34:37	\N
\.


--
-- Data for Name: ai_insights; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.ai_insights (id, store_id, type, title, description, explanation, suggestion_data, estimated_impact, status, approved_at, applied_at, created_at, updated_at) FROM stdin;
2	1	bundle	Saran Bundling: Indomie Goreng + Telur Ayam (Butir)	Item ini sering dibeli bersamaan.	Pelanggan membeli kedua item ini bersamaan sebanyak 6 kali baru-baru ini. Buat paket bundling untuk meningkatkan nilai transaksi rata-rata.	{"p1":11,"p2":12,"bundle_price":4750}	25000.00	pending	\N	\N	2026-02-16 19:58:19	2026-02-17 05:52:57
3	1	trend_decline	Tren Menurun: Kopi Kapal Api 165g	Penjualan produk ini turun secara signifikan.	Produk ini terjual 2 unit minggu ini, dibandingkan dengan 10 minggu lalu (turun ~80%).	{"product_id":14,"current_sales":2,"previous_sales":10}	-20000.00	pending	\N	\N	2026-02-16 20:01:20	2026-02-17 05:52:57
1	1	discount	Cuci Gudang: Payung Pelangi (Seasonal)	Stok untuk Payung Pelangi (Seasonal) tidak bergerak.	Anda memiliki 60 unit stok tetapi hanya terjual 0 dalam 30 hari terakhir. Pertimbangkan diskon 15% untuk membebaskan modal.	{"product_id":10,"current_price":"45000.00","suggested_price":38250}	-10000.00	pending	\N	\N	2026-02-16 19:57:38	2026-02-17 05:03:57
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.audit_logs (id, user_id, action, target_type, target_id, old_values, new_values, ip_address, user_agent, created_at, updated_at) FROM stdin;
1	1	price_override	\N	\N	\N	{"store_id":2,"product_id":1,"old_price":3500,"new_price":3000}	\N	\N	2026-02-16 19:43:30	2026-02-16 19:43:30
2	1	price_override	\N	\N	\N	{"store_id":2,"product_id":1,"old_price":3500,"new_price":3000}	\N	\N	2026-02-16 19:43:40	2026-02-16 19:43:40
3	2	void	App\\Models\\Transaction	36	{"status":"completed"}	{"status":"voided"}	\N	\N	2026-02-08 19:53:18	2026-02-16 19:53:18
4	2	void	App\\Models\\Transaction	49	{"status":"completed"}	{"status":"voided"}	\N	\N	2026-02-14 19:53:18	2026-02-16 19:53:18
5	2	void	App\\Models\\Transaction	28	{"status":"completed"}	{"status":"voided"}	\N	\N	2026-02-14 19:53:18	2026-02-16 19:53:18
6	2	void	App\\Models\\Transaction	41	{"status":"completed"}	{"status":"voided"}	\N	\N	2026-01-31 19:53:18	2026-02-16 19:53:18
7	2	void	App\\Models\\Transaction	39	{"status":"completed"}	{"status":"voided"}	\N	\N	2026-02-02 19:53:18	2026-02-16 19:53:18
8	2	void	App\\Models\\Transaction	57	{"status":"completed"}	{"status":"voided"}	\N	\N	2026-02-14 19:53:18	2026-02-16 19:53:18
9	2	update	App\\Models\\Product	10	{"price":50000}	{"price":35000}	\N	\N	2026-02-02 19:53:18	2026-02-16 19:53:18
10	2	update	App\\Models\\Product	3	{"price":50000}	{"price":35000}	\N	\N	2026-02-15 19:53:18	2026-02-16 19:53:18
11	2	update	App\\Models\\Product	9	{"price":50000}	{"price":35000}	\N	\N	2026-01-28 19:53:18	2026-02-16 19:53:18
12	2	update	App\\Models\\Product	5	{"price":50000}	{"price":35000}	\N	\N	2026-02-08 19:53:18	2026-02-16 19:53:18
13	2	void	App\\Models\\Transaction	69	{"status":"completed"}	{"status":"voided"}	\N	\N	2026-01-29 19:53:53	2026-02-16 19:53:53
14	2	void	App\\Models\\Transaction	56	{"status":"completed"}	{"status":"voided"}	\N	\N	2026-02-01 19:53:53	2026-02-16 19:53:53
15	2	void	App\\Models\\Transaction	7	{"status":"completed"}	{"status":"voided"}	\N	\N	2026-02-12 19:53:53	2026-02-16 19:53:53
16	2	void	App\\Models\\Transaction	83	{"status":"completed"}	{"status":"voided"}	\N	\N	2026-02-01 19:53:53	2026-02-16 19:53:53
17	2	void	App\\Models\\Transaction	51	{"status":"completed"}	{"status":"voided"}	\N	\N	2026-02-14 19:53:53	2026-02-16 19:53:53
18	2	void	App\\Models\\Transaction	82	{"status":"completed"}	{"status":"voided"}	\N	\N	2026-02-04 19:53:53	2026-02-16 19:53:53
19	2	update	App\\Models\\Product	4	{"price":50000}	{"price":35000}	\N	\N	2026-01-29 19:53:53	2026-02-16 19:53:53
20	2	update	App\\Models\\Product	9	{"price":50000}	{"price":35000}	\N	\N	2026-02-13 19:53:53	2026-02-16 19:53:53
21	2	update	App\\Models\\Product	10	{"price":50000}	{"price":35000}	\N	\N	2026-01-24 19:53:53	2026-02-16 19:53:53
22	2	update	App\\Models\\Product	10	{"price":50000}	{"price":35000}	\N	\N	2026-02-13 19:53:53	2026-02-16 19:53:53
\.


--
-- Data for Name: budgets; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.budgets (id, store_id, category_name, amount_limit, start_date, end_date, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: business_health_scores; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.business_health_scores (id, store_id, score, breakdown, explanation, calculated_at, created_at, updated_at) FROM stdin;
1	1	43	{"margin_trend":22.692307692307693,"stock_turnover":3.982300884955752,"dead_stock":0,"cashflow":85,"receivables":100,"expense_ratio":100}	Profit margins are below threshold. High volume of slow-moving inventory detected.	2026-02-16	2026-02-16 20:28:18	2026-02-16 20:28:18
2	1	43	{"margin_trend":22.692307692307693,"stock_turnover":3.982300884955752,"dead_stock":0,"cashflow":85,"receivables":100,"expense_ratio":100}	Profit margins are below threshold. High volume of slow-moving inventory detected.	2026-02-16	2026-02-16 20:28:43	2026-02-16 20:28:43
\.


--
-- Data for Name: cache; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.cache (key, value, expiration) FROM stdin;
\.


--
-- Data for Name: cache_locks; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.cache_locks (key, owner, expiration) FROM stdin;
\.


--
-- Data for Name: cash_drawers; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.cash_drawers (id, store_id, user_id, opening_balance, closing_balance, expected_balance, variance, notes, opened_at, closed_at, created_at, updated_at) FROM stdin;
1	1	2	500000.00	1250000.00	1350000.00	-100000.00	\N	2026-02-14 19:53:18	2026-02-14 23:53:18	2026-02-16 19:53:18	2026-02-16 19:53:18
2	1	2	500000.00	1250000.00	1350000.00	-100000.00	\N	2026-02-14 19:53:53	2026-02-14 23:53:53	2026-02-16 19:53:53	2026-02-16 19:53:53
4	1	8	152000.00	256000.00	327935.00	-71935.00	\N	2026-02-17 05:45:43	2026-02-17 05:52:10	2026-02-17 05:45:43	2026-02-17 05:52:10
\.


--
-- Data for Name: cashflow_projections; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.cashflow_projections (id, store_id, projection_date, projected_incoming, projected_outgoing, net_balance, source_data, created_at, updated_at) FROM stdin;
18	1	2026-03-05	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
28	1	2026-03-15	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
29	1	2026-03-16	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
1	1	2026-02-16	14444.44	50000.00	-35555.56	{"sales_forecast":14444.44,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-16 23:57:45
8	1	2026-02-23	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
9	1	2026-02-24	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
19	1	2026-03-06	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
20	1	2026-03-07	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
30	1	2026-03-17	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
31	1	2026-03-18	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-17 00:00:57	2026-02-17 05:52:57
2	1	2026-02-17	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
3	1	2026-02-18	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
4	1	2026-02-19	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
5	1	2026-02-20	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
6	1	2026-02-21	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
7	1	2026-02-22	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
10	1	2026-02-25	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
11	1	2026-02-26	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
12	1	2026-02-27	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
13	1	2026-02-28	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
14	1	2026-03-01	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
15	1	2026-03-02	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
16	1	2026-03-03	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
17	1	2026-03-04	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
21	1	2026-03-08	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
22	1	2026-03-09	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
23	1	2026-03-10	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
24	1	2026-03-11	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
25	1	2026-03-12	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
26	1	2026-03-13	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
27	1	2026-03-14	48564.61	50000.00	-1435.39	{"sales_forecast":48564.61,"installments":0,"purchase_orders":0,"fixed_expenses":50000}	2026-02-16 19:49:57	2026-02-17 05:52:57
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.categories (id, name, created_at, updated_at) FROM stdin;
1	Groceries	2026-02-16 19:43:29	2026-02-16 19:43:29
2	Groceries	2026-02-16 19:43:39	2026-02-16 19:43:39
3	Sembako	2026-02-16 20:41:06	2026-02-16 20:41:06
4	Minuman	2026-02-16 20:41:06	2026-02-16 20:41:06
5	Snack	2026-02-16 20:41:06	2026-02-16 20:41:06
6	Sabun & Diterjen	2026-02-16 20:41:06	2026-02-16 20:41:06
7	Rokok	2026-02-16 20:41:06	2026-02-16 20:41:06
8	Bumbu	2026-02-16 20:41:06	2026-02-16 20:41:06
\.


--
-- Data for Name: competitor_prices; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.competitor_prices (id, product_id, competitor_name, price, checked_at, created_at, updated_at) FROM stdin;
1	17	Indomaret	34000.00	2026-02-16 19:53:27	2026-02-16 20:03:27	2026-02-16 20:03:27
2	18	Alfamart	78000.00	2026-02-16 19:58:27	2026-02-16 20:03:27	2026-02-16 20:03:27
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.customers (id, store_id, name, phone, email, points_balance, tier, last_visit_at, created_at, updated_at) FROM stdin;
1	3	Budiman	08548490558	\N	1	silver	\N	2026-02-16 20:41:06	2026-02-16 20:41:06
2	3	Siti	08385576858	\N	372	silver	\N	2026-02-16 20:41:06	2026-02-16 20:41:06
3	3	Agus	08922286108	\N	45	silver	\N	2026-02-16 20:41:06	2026-02-16 20:41:06
4	3	Wati	08158829642	\N	321	silver	\N	2026-02-16 20:41:06	2026-02-16 20:41:06
5	3	Joko	08547438820	\N	462	silver	\N	2026-02-16 20:41:06	2026-02-16 20:41:06
6	3	Ani	08727671812	\N	92	silver	\N	2026-02-16 20:41:06	2026-02-16 20:41:06
7	3	Budi	08205637159	\N	435	silver	\N	2026-02-16 20:41:06	2026-02-16 20:41:06
8	3	Rina	08104140575	\N	225	silver	\N	2026-02-16 20:41:06	2026-02-16 20:41:06
9	3	Eko	08349733453	\N	401	silver	\N	2026-02-16 20:41:06	2026-02-16 20:41:06
10	3	Sari	08501469734	\N	445	silver	\N	2026-02-16 20:41:06	2026-02-16 20:41:06
11	3	Budiman	08432183268	\N	88	silver	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
12	3	Siti	08272036095	\N	103	silver	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
13	3	Agus	08321709717	\N	469	silver	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
14	3	Wati	08941723131	\N	211	silver	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
15	3	Joko	08732038091	\N	190	silver	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
16	3	Ani	08473041378	\N	267	silver	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
17	3	Budi	08807362367	\N	33	silver	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
18	3	Rina	08258719516	\N	311	silver	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
19	3	Eko	08752918543	\N	213	silver	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
20	3	Sari	08705065724	\N	46	silver	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
\.


--
-- Data for Name: employee_risk_scores; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.employee_risk_scores (id, store_id, user_id, risk_score, risk_level, indicators, metadata, calculated_at, created_at, updated_at) FROM stdin;
1	1	2	85.00	critical	{"voids":{"count":12,"score":20},"discounts":{"avg":0,"score":0},"price_edits":{"count":8,"score":20},"variance":{"amount":200000,"score":30},"late_closings":{"count":2,"score":15}}	{"calculation_version":"1.0","period":"30d"}	2026-02-16 00:00:00	2026-02-16 19:53:53	2026-02-16 19:53:53
\.


--
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
\.


--
-- Data for Name: fraud_alerts; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.fraud_alerts (id, reference_id, model_type, rule_name, description, severity, user_id, resolved, resolved_at, resolved_by, created_at, updated_at) FROM stdin;
1	1	App\\Models\\EmployeeRiskScore	High Employee Risk	Employee Siti Kasir flagged as critical risk (Score: 85). Significant patterns in variance	critical	2	f	\N	\N	2026-02-16 19:53:53	2026-02-16 19:53:53
\.


--
-- Data for Name: installments; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.installments (id, transaction_id, installment_number, due_date, amount, paid_amount, status, paid_at, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: inventory_valuations; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.inventory_valuations (id, store_id, total_value, total_items, valuation_date, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: job_batches; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.job_batches (id, name, total_jobs, pending_jobs, failed_jobs, failed_job_ids, options, cancelled_at, created_at, finished_at) FROM stdin;
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.jobs (id, queue, payload, attempts, reserved_at, available_at, created_at) FROM stdin;
1	default	{"uuid":"a44a843c-a766-4d6b-a71e-29546e76e720","displayName":"App\\\\Jobs\\\\CalculateBusinessIntelligence","job":"Illuminate\\\\Queue\\\\CallQueuedHandler@call","maxTries":null,"maxExceptions":null,"failOnTimeout":false,"backoff":null,"timeout":null,"retryUntil":null,"data":{"commandName":"App\\\\Jobs\\\\CalculateBusinessIntelligence","command":"O:38:\\"App\\\\Jobs\\\\CalculateBusinessIntelligence\\":0:{}","batchId":null},"createdAt":1771271021,"delay":null}	0	\N	1771271021	1771271021
\.


--
-- Data for Name: journal_entries; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.journal_entries (id, store_id, user_id, reference_number, transaction_date, description, reference_type, reference_id, is_posted, posted_at, created_at, updated_at, deleted_at) FROM stdin;
2	3	\N	JE-INV-GUUBFP3N	2026-02-16	Sale Invoice #INV-GUUBFP3N	App\\Models\\Transaction	0	t	2026-02-16 20:41:31	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
3	3	\N	JE-INV-EFYDX5CF	2026-02-16	Sale Invoice #INV-EFYDX5CF	App\\Models\\Transaction	0	t	2026-02-16 20:41:31	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
4	3	\N	JE-INV-T1QDDXCM	2026-02-16	Sale Invoice #INV-T1QDDXCM	App\\Models\\Transaction	0	t	2026-02-16 20:41:31	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
5	3	\N	JE-INV-FKFPXWJB	2026-02-16	Sale Invoice #INV-FKFPXWJB	App\\Models\\Transaction	0	t	2026-02-16 20:41:31	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
6	3	\N	JE-INV-XUD9RDUB	2026-02-16	Sale Invoice #INV-XUD9RDUB	App\\Models\\Transaction	0	t	2026-02-16 20:41:31	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
7	3	\N	JE-INV-UF1NSARI	2026-02-16	Sale Invoice #INV-UF1NSARI	App\\Models\\Transaction	0	t	2026-02-16 20:41:31	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
8	3	\N	JE-INV-KKYIM5MO	2026-02-16	Sale Invoice #INV-KKYIM5MO	App\\Models\\Transaction	0	t	2026-02-16 20:41:31	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
9	3	\N	JE-INV-VGKCR6ML	2026-02-16	Sale Invoice #INV-VGKCR6ML	App\\Models\\Transaction	0	t	2026-02-16 20:41:31	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
10	3	\N	JE-INV-O1XMDUYJ	2026-02-16	Sale Invoice #INV-O1XMDUYJ	App\\Models\\Transaction	0	t	2026-02-16 20:41:31	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
11	3	\N	JE-INV-EOCXY1TF	2026-02-16	Sale Invoice #INV-EOCXY1TF	App\\Models\\Transaction	0	t	2026-02-16 20:41:31	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
12	3	\N	JE-INV-XWGHNHT4	2026-02-16	Sale Invoice #INV-XWGHNHT4	App\\Models\\Transaction	0	t	2026-02-16 20:41:31	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
13	3	\N	JE-INV-EDAZWZBY	2026-02-16	Sale Invoice #INV-EDAZWZBY	App\\Models\\Transaction	0	t	2026-02-16 20:41:31	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
14	3	\N	JE-INV-7SVUSF5X	2026-02-16	Sale Invoice #INV-7SVUSF5X	App\\Models\\Transaction	0	t	2026-02-16 20:41:31	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
15	3	\N	JE-INV-GUG6WSRU	2026-02-16	Sale Invoice #INV-GUG6WSRU	App\\Models\\Transaction	0	t	2026-02-16 20:41:31	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
16	3	\N	JE-INV-WOWQYFIK	2026-02-16	Sale Invoice #INV-WOWQYFIK	App\\Models\\Transaction	0	t	2026-02-16 20:41:31	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
17	3	\N	JE-INV-ZTS0FQNV	2026-02-16	Sale Invoice #INV-ZTS0FQNV	App\\Models\\Transaction	0	t	2026-02-16 20:41:31	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
18	3	\N	JE-INV-OZY5H490	2026-02-16	Sale Invoice #INV-OZY5H490	App\\Models\\Transaction	0	t	2026-02-16 20:41:31	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
19	3	\N	JE-INV-4VAAXIOL	2026-02-16	Sale Invoice #INV-4VAAXIOL	App\\Models\\Transaction	0	t	2026-02-16 20:41:31	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
20	3	\N	JE-INV-T4OCE4JJ	2026-02-16	Sale Invoice #INV-T4OCE4JJ	App\\Models\\Transaction	0	t	2026-02-16 20:41:31	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
21	3	\N	JE-INV-LQCAUXSC	2026-02-16	Sale Invoice #INV-LQCAUXSC	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
22	3	\N	JE-INV-XJNL12EI	2026-02-16	Sale Invoice #INV-XJNL12EI	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
23	3	\N	JE-INV-KFCZWNF9	2026-02-16	Sale Invoice #INV-KFCZWNF9	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
24	3	\N	JE-INV-LBRNGFEH	2026-02-16	Sale Invoice #INV-LBRNGFEH	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
25	3	\N	JE-INV-UZIVVFSW	2026-02-16	Sale Invoice #INV-UZIVVFSW	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
26	3	\N	JE-INV-A0KJPHLE	2026-02-16	Sale Invoice #INV-A0KJPHLE	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
27	3	\N	JE-INV-VMWFWHOE	2026-02-16	Sale Invoice #INV-VMWFWHOE	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
28	3	\N	JE-INV-6D6JBLG0	2026-02-16	Sale Invoice #INV-6D6JBLG0	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
29	3	\N	JE-INV-NIWW51CA	2026-02-16	Sale Invoice #INV-NIWW51CA	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
30	3	\N	JE-INV-1SSGOHX9	2026-02-16	Sale Invoice #INV-1SSGOHX9	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
31	3	\N	JE-INV-PMKSMIXK	2026-02-16	Sale Invoice #INV-PMKSMIXK	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
32	3	\N	JE-INV-MVZMKXVY	2026-02-16	Sale Invoice #INV-MVZMKXVY	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
33	3	\N	JE-INV-FTKMIQUQ	2026-02-16	Sale Invoice #INV-FTKMIQUQ	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
34	3	\N	JE-INV-WPDQGJ5E	2026-02-16	Sale Invoice #INV-WPDQGJ5E	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
35	3	\N	JE-INV-M9YYRAX0	2026-02-16	Sale Invoice #INV-M9YYRAX0	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
36	3	\N	JE-INV-ZECRKSH0	2026-02-16	Sale Invoice #INV-ZECRKSH0	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
37	3	\N	JE-INV-52FSQBNK	2026-02-16	Sale Invoice #INV-52FSQBNK	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
38	3	\N	JE-INV-HVHT9LLM	2026-02-16	Sale Invoice #INV-HVHT9LLM	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
39	3	\N	JE-INV-RFBRPCUV	2026-02-16	Sale Invoice #INV-RFBRPCUV	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
40	3	\N	JE-INV-GKBRMZJ1	2026-02-16	Sale Invoice #INV-GKBRMZJ1	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
41	3	\N	JE-INV-FGCUNSZO	2026-02-16	Sale Invoice #INV-FGCUNSZO	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
42	3	\N	JE-INV-DKXMEGYJ	2026-02-16	Sale Invoice #INV-DKXMEGYJ	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
43	3	\N	JE-INV-RK2C4ZVS	2026-02-16	Sale Invoice #INV-RK2C4ZVS	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
44	3	\N	JE-INV-DSNTRA7V	2026-02-16	Sale Invoice #INV-DSNTRA7V	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
45	3	\N	JE-INV-X6GN1QMP	2026-02-16	Sale Invoice #INV-X6GN1QMP	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
46	3	\N	JE-INV-W4MOYUQF	2026-02-16	Sale Invoice #INV-W4MOYUQF	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
47	3	\N	JE-INV-IICJZIG5	2026-02-16	Sale Invoice #INV-IICJZIG5	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
48	3	\N	JE-INV-O7DE43QY	2026-02-16	Sale Invoice #INV-O7DE43QY	App\\Models\\Transaction	0	t	2026-02-16 20:41:32	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
49	3	\N	JE-INV-IMXYFMJA	2026-02-16	Sale Invoice #INV-IMXYFMJA	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
50	3	\N	JE-INV-2DCMSQIQ	2026-02-16	Sale Invoice #INV-2DCMSQIQ	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
51	3	\N	JE-INV-0WWT4ISA	2026-02-16	Sale Invoice #INV-0WWT4ISA	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
52	3	\N	JE-INV-WJ7WZUUC	2026-02-16	Sale Invoice #INV-WJ7WZUUC	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
53	3	\N	JE-INV-5AFEOOQ8	2026-02-16	Sale Invoice #INV-5AFEOOQ8	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
54	3	\N	JE-INV-RS9CLXVD	2026-02-16	Sale Invoice #INV-RS9CLXVD	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
55	3	\N	JE-INV-8FHXT1KA	2026-02-16	Sale Invoice #INV-8FHXT1KA	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
56	3	\N	JE-INV-VNUWAJWP	2026-02-16	Sale Invoice #INV-VNUWAJWP	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
57	3	\N	JE-INV-BJHQWZLE	2026-02-16	Sale Invoice #INV-BJHQWZLE	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
58	3	\N	JE-INV-8AMUP4AY	2026-02-16	Sale Invoice #INV-8AMUP4AY	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
59	3	\N	JE-INV-BXUCYFBB	2026-02-16	Sale Invoice #INV-BXUCYFBB	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
60	3	\N	JE-INV-IRKYLO07	2026-02-16	Sale Invoice #INV-IRKYLO07	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
61	3	\N	JE-INV-O2E06XBX	2026-02-16	Sale Invoice #INV-O2E06XBX	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
62	3	\N	JE-INV-BURMJOXS	2026-02-16	Sale Invoice #INV-BURMJOXS	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
63	3	\N	JE-INV-SX2ZKYSK	2026-02-16	Sale Invoice #INV-SX2ZKYSK	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
64	3	\N	JE-INV-CD73PMDD	2026-02-16	Sale Invoice #INV-CD73PMDD	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
65	3	\N	JE-INV-5OMZFGSU	2026-02-16	Sale Invoice #INV-5OMZFGSU	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
66	3	\N	JE-INV-HZD6V62W	2026-02-16	Sale Invoice #INV-HZD6V62W	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
67	3	\N	JE-INV-FIBYF4E1	2026-02-16	Sale Invoice #INV-FIBYF4E1	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
68	3	\N	JE-INV-IYYJSX88	2026-02-16	Sale Invoice #INV-IYYJSX88	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
69	3	\N	JE-INV-KTUBDIKB	2026-02-16	Sale Invoice #INV-KTUBDIKB	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
70	3	\N	JE-INV-A4LK6X1K	2026-02-16	Sale Invoice #INV-A4LK6X1K	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
71	3	\N	JE-INV-5BKCJEOG	2026-02-16	Sale Invoice #INV-5BKCJEOG	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
72	3	\N	JE-INV-H5NWETBG	2026-02-16	Sale Invoice #INV-H5NWETBG	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
73	3	\N	JE-INV-8W2U5VDU	2026-02-16	Sale Invoice #INV-8W2U5VDU	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
74	3	\N	JE-INV-7MYGR3CX	2026-02-16	Sale Invoice #INV-7MYGR3CX	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
75	3	\N	JE-INV-PAT8LSEG	2026-02-16	Sale Invoice #INV-PAT8LSEG	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
76	3	\N	JE-INV-6YU8KXAU	2026-02-16	Sale Invoice #INV-6YU8KXAU	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
77	3	\N	JE-INV-8DQSTD3S	2026-02-16	Sale Invoice #INV-8DQSTD3S	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
78	3	\N	JE-INV-6FZF4YIN	2026-02-16	Sale Invoice #INV-6FZF4YIN	App\\Models\\Transaction	0	t	2026-02-16 20:41:33	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
79	3	\N	JE-INV-MYIVBRVH	2026-02-16	Sale Invoice #INV-MYIVBRVH	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
80	3	\N	JE-INV-VWA9OE7V	2026-02-16	Sale Invoice #INV-VWA9OE7V	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
81	3	\N	JE-INV-W9UN0FBZ	2026-02-16	Sale Invoice #INV-W9UN0FBZ	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
82	3	\N	JE-INV-QA3BH2OD	2026-02-16	Sale Invoice #INV-QA3BH2OD	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
83	3	\N	JE-INV-12EO8FWU	2026-02-16	Sale Invoice #INV-12EO8FWU	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
84	3	\N	JE-INV-B3KBPCHI	2026-02-16	Sale Invoice #INV-B3KBPCHI	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
85	3	\N	JE-INV-D2WITTXQ	2026-02-16	Sale Invoice #INV-D2WITTXQ	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
86	3	\N	JE-INV-B41ZRGFW	2026-02-16	Sale Invoice #INV-B41ZRGFW	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
87	3	\N	JE-INV-NECDC5DF	2026-02-16	Sale Invoice #INV-NECDC5DF	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
88	3	\N	JE-INV-XY3NPNGZ	2026-02-16	Sale Invoice #INV-XY3NPNGZ	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
89	3	\N	JE-INV-FWFXLRU7	2026-02-16	Sale Invoice #INV-FWFXLRU7	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
90	3	\N	JE-INV-B1CDZZTW	2026-02-16	Sale Invoice #INV-B1CDZZTW	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
91	3	\N	JE-INV-ELYFJBL6	2026-02-16	Sale Invoice #INV-ELYFJBL6	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
92	3	\N	JE-INV-RY8IOPWT	2026-02-16	Sale Invoice #INV-RY8IOPWT	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
93	3	\N	JE-INV-FUFEPPJ2	2026-02-16	Sale Invoice #INV-FUFEPPJ2	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
94	3	\N	JE-INV-RV8GGR7F	2026-02-16	Sale Invoice #INV-RV8GGR7F	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
95	3	\N	JE-INV-L9GBDB7V	2026-02-16	Sale Invoice #INV-L9GBDB7V	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
96	3	\N	JE-INV-WFHYSTYN	2026-02-16	Sale Invoice #INV-WFHYSTYN	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
97	3	\N	JE-INV-EGOKEF4M	2026-02-16	Sale Invoice #INV-EGOKEF4M	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
98	3	\N	JE-INV-3F2ELRKF	2026-02-16	Sale Invoice #INV-3F2ELRKF	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
99	3	\N	JE-INV-AZHYIELV	2026-02-16	Sale Invoice #INV-AZHYIELV	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
100	3	\N	JE-INV-CWW6LLJG	2026-02-16	Sale Invoice #INV-CWW6LLJG	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
101	3	\N	JE-INV-H1NJCOFS	2026-02-16	Sale Invoice #INV-H1NJCOFS	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
102	3	\N	JE-INV-HFBOAIY3	2026-02-16	Sale Invoice #INV-HFBOAIY3	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
103	3	\N	JE-INV-H7CGFQUO	2026-02-16	Sale Invoice #INV-H7CGFQUO	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
104	3	\N	JE-INV-MWRZDBWB	2026-02-16	Sale Invoice #INV-MWRZDBWB	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
105	3	\N	JE-INV-FRLDX13G	2026-02-16	Sale Invoice #INV-FRLDX13G	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
106	3	\N	JE-INV-PHTQUYTM	2026-02-16	Sale Invoice #INV-PHTQUYTM	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
107	3	\N	JE-INV-O0FQMVJD	2026-02-16	Sale Invoice #INV-O0FQMVJD	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
108	3	\N	JE-INV-OG4WIVFZ	2026-02-16	Sale Invoice #INV-OG4WIVFZ	App\\Models\\Transaction	0	t	2026-02-16 20:41:34	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
109	3	\N	JE-INV-ZAWTXVSF	2026-02-16	Sale Invoice #INV-ZAWTXVSF	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
110	3	\N	JE-INV-H5H1IL5E	2026-02-16	Sale Invoice #INV-H5H1IL5E	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
111	3	\N	JE-INV-7RRVX9XH	2026-02-16	Sale Invoice #INV-7RRVX9XH	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
112	3	\N	JE-INV-TX63EWRR	2026-02-16	Sale Invoice #INV-TX63EWRR	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
113	3	\N	JE-INV-N9BBU68M	2026-02-16	Sale Invoice #INV-N9BBU68M	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
114	3	\N	JE-INV-RSHRQ3FF	2026-02-16	Sale Invoice #INV-RSHRQ3FF	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
115	3	\N	JE-INV-LIOISH1Y	2026-02-16	Sale Invoice #INV-LIOISH1Y	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
116	3	\N	JE-INV-QAQMNEEC	2026-02-16	Sale Invoice #INV-QAQMNEEC	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
117	3	\N	JE-INV-GETHL1A0	2026-02-16	Sale Invoice #INV-GETHL1A0	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
118	3	\N	JE-INV-DSREB2ZO	2026-02-16	Sale Invoice #INV-DSREB2ZO	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
119	3	\N	JE-INV-ACMDHPZS	2026-02-16	Sale Invoice #INV-ACMDHPZS	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
120	3	\N	JE-INV-HWWYWIOM	2026-02-16	Sale Invoice #INV-HWWYWIOM	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
121	3	\N	JE-INV-NWCFKISV	2026-02-16	Sale Invoice #INV-NWCFKISV	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
122	3	\N	JE-INV-VMVTVCKI	2026-02-16	Sale Invoice #INV-VMVTVCKI	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
123	3	\N	JE-INV-6C92MJQS	2026-02-16	Sale Invoice #INV-6C92MJQS	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
124	3	\N	JE-INV-SJFRCM9N	2026-02-16	Sale Invoice #INV-SJFRCM9N	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
125	3	\N	JE-INV-2BP54C0L	2026-02-16	Sale Invoice #INV-2BP54C0L	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
126	3	\N	JE-INV-WSBOTNB7	2026-02-16	Sale Invoice #INV-WSBOTNB7	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
127	3	\N	JE-INV-AZZUMUPS	2026-02-16	Sale Invoice #INV-AZZUMUPS	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
128	3	\N	JE-INV-HZV7RMKS	2026-02-16	Sale Invoice #INV-HZV7RMKS	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
129	3	\N	JE-INV-7NFVBEPK	2026-02-16	Sale Invoice #INV-7NFVBEPK	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
130	3	\N	JE-INV-WDVWZQWP	2026-02-16	Sale Invoice #INV-WDVWZQWP	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
131	3	\N	JE-INV-8SEJG5GX	2026-02-16	Sale Invoice #INV-8SEJG5GX	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
132	3	\N	JE-INV-ZMZONG4P	2026-02-16	Sale Invoice #INV-ZMZONG4P	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
133	3	\N	JE-INV-UC7BXVS7	2026-02-16	Sale Invoice #INV-UC7BXVS7	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
134	3	\N	JE-INV-PUXKG5LT	2026-02-16	Sale Invoice #INV-PUXKG5LT	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
135	3	\N	JE-INV-CRXCIRZT	2026-02-16	Sale Invoice #INV-CRXCIRZT	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
136	3	\N	JE-INV-SBR9KJLB	2026-02-16	Sale Invoice #INV-SBR9KJLB	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
137	3	\N	JE-INV-CONGQ5M4	2026-02-16	Sale Invoice #INV-CONGQ5M4	App\\Models\\Transaction	0	t	2026-02-16 20:41:35	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
138	3	\N	JE-INV-QTGTNVCG	2026-02-16	Sale Invoice #INV-QTGTNVCG	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
139	3	\N	JE-INV-ZAI05PBZ	2026-02-16	Sale Invoice #INV-ZAI05PBZ	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
140	3	\N	JE-INV-VM03NN2G	2026-02-16	Sale Invoice #INV-VM03NN2G	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
141	3	\N	JE-INV-SBJJVNJN	2026-02-16	Sale Invoice #INV-SBJJVNJN	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
142	3	\N	JE-INV-XFIE7XCT	2026-02-16	Sale Invoice #INV-XFIE7XCT	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
143	3	\N	JE-INV-YVYPRLO4	2026-02-16	Sale Invoice #INV-YVYPRLO4	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
144	3	\N	JE-INV-EUJYQLF2	2026-02-16	Sale Invoice #INV-EUJYQLF2	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
145	3	\N	JE-INV-LXOKD6JQ	2026-02-16	Sale Invoice #INV-LXOKD6JQ	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
146	3	\N	JE-INV-VWVDCUN1	2026-02-16	Sale Invoice #INV-VWVDCUN1	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
147	3	\N	JE-INV-DD4MCJRD	2026-02-16	Sale Invoice #INV-DD4MCJRD	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
148	3	\N	JE-INV-4G8I6KUO	2026-02-16	Sale Invoice #INV-4G8I6KUO	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
149	3	\N	JE-INV-JEN3ETUO	2026-02-16	Sale Invoice #INV-JEN3ETUO	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
150	3	\N	JE-INV-RMOLFOKZ	2026-02-16	Sale Invoice #INV-RMOLFOKZ	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
151	3	\N	JE-INV-T9EVZKTB	2026-02-16	Sale Invoice #INV-T9EVZKTB	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
152	3	\N	JE-INV-E01NOH0I	2026-02-16	Sale Invoice #INV-E01NOH0I	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
153	3	\N	JE-INV-SDAS4FHK	2026-02-16	Sale Invoice #INV-SDAS4FHK	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
154	3	\N	JE-INV-OF7MR2VG	2026-02-16	Sale Invoice #INV-OF7MR2VG	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
155	3	\N	JE-INV-6HJTJBNX	2026-02-16	Sale Invoice #INV-6HJTJBNX	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
156	3	\N	JE-INV-R5ZMEX6Y	2026-02-16	Sale Invoice #INV-R5ZMEX6Y	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
157	3	\N	JE-INV-CIAMHFG4	2026-02-16	Sale Invoice #INV-CIAMHFG4	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
158	3	\N	JE-INV-G1482LKR	2026-02-16	Sale Invoice #INV-G1482LKR	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
159	3	\N	JE-INV-OUTNLYNP	2026-02-16	Sale Invoice #INV-OUTNLYNP	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
160	3	\N	JE-INV-JJXBUQ5C	2026-02-16	Sale Invoice #INV-JJXBUQ5C	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
161	3	\N	JE-INV-NFSE5JZZ	2026-02-16	Sale Invoice #INV-NFSE5JZZ	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
162	3	\N	JE-INV-BKRGU1OG	2026-02-16	Sale Invoice #INV-BKRGU1OG	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
163	3	\N	JE-INV-ODQSFFTD	2026-02-16	Sale Invoice #INV-ODQSFFTD	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
164	3	\N	JE-INV-MDGHSYZH	2026-02-16	Sale Invoice #INV-MDGHSYZH	App\\Models\\Transaction	0	t	2026-02-16 20:41:36	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
165	3	\N	JE-INV-5LNKAGVD	2026-02-16	Sale Invoice #INV-5LNKAGVD	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
166	3	\N	JE-INV-4JZ0JPNI	2026-02-16	Sale Invoice #INV-4JZ0JPNI	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
167	3	\N	JE-INV-DMUG7AIM	2026-02-16	Sale Invoice #INV-DMUG7AIM	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
168	3	\N	JE-INV-6NAFGWSQ	2026-02-16	Sale Invoice #INV-6NAFGWSQ	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
169	3	\N	JE-INV-ATOFHV9X	2026-02-16	Sale Invoice #INV-ATOFHV9X	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
170	3	\N	JE-INV-XAYGYNEN	2026-02-16	Sale Invoice #INV-XAYGYNEN	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
171	3	\N	JE-INV-BB44DRV6	2026-02-16	Sale Invoice #INV-BB44DRV6	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
172	3	\N	JE-INV-LPU1PZCC	2026-02-16	Sale Invoice #INV-LPU1PZCC	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
173	3	\N	JE-INV-65VLYSUE	2026-02-16	Sale Invoice #INV-65VLYSUE	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
174	3	\N	JE-INV-Q0SWJVZD	2026-02-16	Sale Invoice #INV-Q0SWJVZD	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
175	3	\N	JE-INV-CK2UFNO4	2026-02-16	Sale Invoice #INV-CK2UFNO4	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
176	3	\N	JE-INV-VWN6AWFS	2026-02-16	Sale Invoice #INV-VWN6AWFS	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
177	3	\N	JE-INV-ZLX7LOP4	2026-02-16	Sale Invoice #INV-ZLX7LOP4	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
178	3	\N	JE-INV-JOQNWJXC	2026-02-16	Sale Invoice #INV-JOQNWJXC	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
179	3	\N	JE-INV-EOJA80J0	2026-02-16	Sale Invoice #INV-EOJA80J0	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
180	3	\N	JE-INV-D2CSSCAQ	2026-02-16	Sale Invoice #INV-D2CSSCAQ	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
181	3	\N	JE-INV-VPUXXUOD	2026-02-16	Sale Invoice #INV-VPUXXUOD	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
182	3	\N	JE-INV-YPSP6TFH	2026-02-16	Sale Invoice #INV-YPSP6TFH	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
183	3	\N	JE-INV-E2P1ARWK	2026-02-16	Sale Invoice #INV-E2P1ARWK	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
184	3	\N	JE-INV-DQXBYCFQ	2026-02-16	Sale Invoice #INV-DQXBYCFQ	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
185	3	\N	JE-INV-J67SFKZJ	2026-02-16	Sale Invoice #INV-J67SFKZJ	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
186	3	\N	JE-INV-VEE2SVGI	2026-02-16	Sale Invoice #INV-VEE2SVGI	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
187	3	\N	JE-INV-OIHLLR0U	2026-02-16	Sale Invoice #INV-OIHLLR0U	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
188	3	\N	JE-INV-5WJIPA8R	2026-02-16	Sale Invoice #INV-5WJIPA8R	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
189	3	\N	JE-INV-2XE3RRJE	2026-02-16	Sale Invoice #INV-2XE3RRJE	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
190	3	\N	JE-INV-T8U523MZ	2026-02-16	Sale Invoice #INV-T8U523MZ	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
191	3	\N	JE-INV-OJUVLSHX	2026-02-16	Sale Invoice #INV-OJUVLSHX	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
192	3	\N	JE-INV-ABP5FY6A	2026-02-16	Sale Invoice #INV-ABP5FY6A	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
193	3	\N	JE-INV-NHDTDTED	2026-02-16	Sale Invoice #INV-NHDTDTED	App\\Models\\Transaction	0	t	2026-02-16 20:41:37	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
194	3	\N	JE-INV-BTODEURL	2026-02-16	Sale Invoice #INV-BTODEURL	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
195	3	\N	JE-INV-TPHYFBWU	2026-02-16	Sale Invoice #INV-TPHYFBWU	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
196	3	\N	JE-INV-O9MMGDG7	2026-02-16	Sale Invoice #INV-O9MMGDG7	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
197	3	\N	JE-INV-BUYPZFI4	2026-02-16	Sale Invoice #INV-BUYPZFI4	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
198	3	\N	JE-INV-2EXZSIAH	2026-02-16	Sale Invoice #INV-2EXZSIAH	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
199	3	\N	JE-INV-JKGVHRW3	2026-02-16	Sale Invoice #INV-JKGVHRW3	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
200	3	\N	JE-INV-I2V6F5GO	2026-02-16	Sale Invoice #INV-I2V6F5GO	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
201	3	\N	JE-INV-CCJUNUAZ	2026-02-16	Sale Invoice #INV-CCJUNUAZ	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
202	3	\N	JE-INV-IPAMMHIB	2026-02-16	Sale Invoice #INV-IPAMMHIB	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
203	3	\N	JE-INV-YSBGAQR3	2026-02-16	Sale Invoice #INV-YSBGAQR3	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
204	3	\N	JE-INV-CJAWFGNE	2026-02-16	Sale Invoice #INV-CJAWFGNE	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
205	3	\N	JE-INV-CAMSTUSS	2026-02-16	Sale Invoice #INV-CAMSTUSS	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
206	3	\N	JE-INV-KIWJIZH1	2026-02-16	Sale Invoice #INV-KIWJIZH1	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
207	3	\N	JE-INV-INUZBT0E	2026-02-16	Sale Invoice #INV-INUZBT0E	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
208	3	\N	JE-INV-EBCN0CTI	2026-02-16	Sale Invoice #INV-EBCN0CTI	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
209	3	\N	JE-INV-KFQWANUP	2026-02-16	Sale Invoice #INV-KFQWANUP	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
210	3	\N	JE-INV-9RHMQJNK	2026-02-16	Sale Invoice #INV-9RHMQJNK	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
211	3	\N	JE-INV-IQMSJFXQ	2026-02-16	Sale Invoice #INV-IQMSJFXQ	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
212	3	\N	JE-INV-T15R8L29	2026-02-16	Sale Invoice #INV-T15R8L29	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
213	3	\N	JE-INV-T7A76SW0	2026-02-16	Sale Invoice #INV-T7A76SW0	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
214	3	\N	JE-INV-VTRC1PDE	2026-02-16	Sale Invoice #INV-VTRC1PDE	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
215	3	\N	JE-INV-S0PWNJRU	2026-02-16	Sale Invoice #INV-S0PWNJRU	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
216	3	\N	JE-INV-4ZHVPUME	2026-02-16	Sale Invoice #INV-4ZHVPUME	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
217	3	\N	JE-INV-WVYCY3I1	2026-02-16	Sale Invoice #INV-WVYCY3I1	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
218	3	\N	JE-INV-OTMVDOGK	2026-02-16	Sale Invoice #INV-OTMVDOGK	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
219	3	\N	JE-INV-5EO9SVI9	2026-02-16	Sale Invoice #INV-5EO9SVI9	App\\Models\\Transaction	0	t	2026-02-16 20:41:38	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
220	3	\N	JE-INV-MHKTMHU1	2026-02-16	Sale Invoice #INV-MHKTMHU1	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
221	3	\N	JE-INV-8HOKHKS5	2026-02-16	Sale Invoice #INV-8HOKHKS5	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
222	3	\N	JE-INV-6ZKM5OAK	2026-02-16	Sale Invoice #INV-6ZKM5OAK	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
223	3	\N	JE-INV-0N1JCKYQ	2026-02-16	Sale Invoice #INV-0N1JCKYQ	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
224	3	\N	JE-INV-RWGSN913	2026-02-16	Sale Invoice #INV-RWGSN913	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
225	3	\N	JE-INV-V9OEDHWY	2026-02-16	Sale Invoice #INV-V9OEDHWY	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
226	3	\N	JE-INV-VCQRDCDV	2026-02-16	Sale Invoice #INV-VCQRDCDV	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
227	3	\N	JE-INV-SI25UISX	2026-02-16	Sale Invoice #INV-SI25UISX	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
228	3	\N	JE-INV-DZPYFXA9	2026-02-16	Sale Invoice #INV-DZPYFXA9	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
229	3	\N	JE-INV-NUSQFBUW	2026-02-16	Sale Invoice #INV-NUSQFBUW	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
230	3	\N	JE-INV-FBCINPC2	2026-02-16	Sale Invoice #INV-FBCINPC2	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
231	3	\N	JE-INV-HKNT4XKX	2026-02-16	Sale Invoice #INV-HKNT4XKX	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
232	3	\N	JE-INV-DDXONATC	2026-02-16	Sale Invoice #INV-DDXONATC	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
233	3	\N	JE-INV-PAQDLEJX	2026-02-16	Sale Invoice #INV-PAQDLEJX	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
234	3	\N	JE-INV-TWDIUSVQ	2026-02-16	Sale Invoice #INV-TWDIUSVQ	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
235	3	\N	JE-INV-I3HIZPGW	2026-02-16	Sale Invoice #INV-I3HIZPGW	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
236	3	\N	JE-INV-EVZQLKSW	2026-02-16	Sale Invoice #INV-EVZQLKSW	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
237	3	\N	JE-INV-P5FS4U15	2026-02-16	Sale Invoice #INV-P5FS4U15	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
238	3	\N	JE-INV-NIAQG47H	2026-02-16	Sale Invoice #INV-NIAQG47H	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
239	3	\N	JE-INV-JTHBC1MO	2026-02-16	Sale Invoice #INV-JTHBC1MO	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
240	3	\N	JE-INV-0SBPKIZS	2026-02-16	Sale Invoice #INV-0SBPKIZS	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
241	3	\N	JE-INV-XJOYRWKG	2026-02-16	Sale Invoice #INV-XJOYRWKG	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
242	3	\N	JE-INV-IMLQHMJX	2026-02-16	Sale Invoice #INV-IMLQHMJX	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
243	3	\N	JE-INV-LRE1KEPY	2026-02-16	Sale Invoice #INV-LRE1KEPY	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
244	3	\N	JE-INV-MXIJUZLD	2026-02-16	Sale Invoice #INV-MXIJUZLD	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
245	3	\N	JE-INV-OJ7PSUOA	2026-02-16	Sale Invoice #INV-OJ7PSUOA	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
246	3	\N	JE-INV-SHC4JIA2	2026-02-16	Sale Invoice #INV-SHC4JIA2	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
247	3	\N	JE-INV-N8J5AHVD	2026-02-16	Sale Invoice #INV-N8J5AHVD	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
248	3	\N	JE-INV-N3EKLVGE	2026-02-16	Sale Invoice #INV-N3EKLVGE	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
249	3	\N	JE-INV-RKJGX89F	2026-02-16	Sale Invoice #INV-RKJGX89F	App\\Models\\Transaction	0	t	2026-02-16 20:41:39	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
250	3	\N	JE-INV-AAEN6RGD	2026-02-16	Sale Invoice #INV-AAEN6RGD	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
251	3	\N	JE-INV-VSJ8VJLV	2026-02-16	Sale Invoice #INV-VSJ8VJLV	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
252	3	\N	JE-INV-Y6BCRJE0	2026-02-16	Sale Invoice #INV-Y6BCRJE0	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
253	3	\N	JE-INV-EITF2TSD	2026-02-16	Sale Invoice #INV-EITF2TSD	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
254	3	\N	JE-INV-Y0NAQOO8	2026-02-16	Sale Invoice #INV-Y0NAQOO8	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
255	3	\N	JE-INV-VN0SKOUF	2026-02-16	Sale Invoice #INV-VN0SKOUF	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
256	3	\N	JE-INV-ROA6IKUP	2026-02-16	Sale Invoice #INV-ROA6IKUP	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
257	3	\N	JE-INV-OENT4GQC	2026-02-16	Sale Invoice #INV-OENT4GQC	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
258	3	\N	JE-INV-F0JBLZMU	2026-02-16	Sale Invoice #INV-F0JBLZMU	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
259	3	\N	JE-INV-VFLGMIPF	2026-02-16	Sale Invoice #INV-VFLGMIPF	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
260	3	\N	JE-INV-1BG2NGOW	2026-02-16	Sale Invoice #INV-1BG2NGOW	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
261	3	\N	JE-INV-BXHSPXZ2	2026-02-16	Sale Invoice #INV-BXHSPXZ2	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
262	3	\N	JE-INV-A7P7OYXQ	2026-02-16	Sale Invoice #INV-A7P7OYXQ	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
263	3	\N	JE-INV-GO7NNGSW	2026-02-16	Sale Invoice #INV-GO7NNGSW	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
264	3	\N	JE-INV-CEDESXO9	2026-02-16	Sale Invoice #INV-CEDESXO9	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
265	3	\N	JE-INV-RJSI8PRS	2026-02-16	Sale Invoice #INV-RJSI8PRS	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
266	3	\N	JE-INV-TVHAZPAB	2026-02-16	Sale Invoice #INV-TVHAZPAB	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
267	3	\N	JE-INV-YY802MYR	2026-02-16	Sale Invoice #INV-YY802MYR	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
268	3	\N	JE-INV-B1ZOZV96	2026-02-16	Sale Invoice #INV-B1ZOZV96	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
269	3	\N	JE-INV-L3GOHPBC	2026-02-16	Sale Invoice #INV-L3GOHPBC	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
270	3	\N	JE-INV-BA0KQKY0	2026-02-16	Sale Invoice #INV-BA0KQKY0	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
271	3	\N	JE-INV-M6EPIIVY	2026-02-16	Sale Invoice #INV-M6EPIIVY	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
272	3	\N	JE-INV-NIYBSIYY	2026-02-16	Sale Invoice #INV-NIYBSIYY	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
273	3	\N	JE-INV-QLLHK9T6	2026-02-16	Sale Invoice #INV-QLLHK9T6	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
274	3	\N	JE-INV-EES9YQAC	2026-02-16	Sale Invoice #INV-EES9YQAC	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
275	3	\N	JE-INV-LUU7ALRA	2026-02-16	Sale Invoice #INV-LUU7ALRA	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
276	3	\N	JE-INV-SLCKSTOF	2026-02-16	Sale Invoice #INV-SLCKSTOF	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
277	3	\N	JE-INV-E7CH6EJ1	2026-02-16	Sale Invoice #INV-E7CH6EJ1	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
278	3	\N	JE-INV-FCRA5YES	2026-02-16	Sale Invoice #INV-FCRA5YES	App\\Models\\Transaction	0	t	2026-02-16 20:41:40	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
279	3	\N	JE-INV-IZVDKFC7	2026-02-16	Sale Invoice #INV-IZVDKFC7	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
280	3	\N	JE-INV-DKFTXASY	2026-02-16	Sale Invoice #INV-DKFTXASY	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
281	3	\N	JE-INV-LYFGKNHS	2026-02-16	Sale Invoice #INV-LYFGKNHS	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
282	3	\N	JE-INV-YXG9YSXC	2026-02-16	Sale Invoice #INV-YXG9YSXC	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
283	3	\N	JE-INV-MXFMXRLO	2026-02-16	Sale Invoice #INV-MXFMXRLO	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
284	3	\N	JE-INV-LO5C4WG6	2026-02-16	Sale Invoice #INV-LO5C4WG6	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
285	3	\N	JE-INV-SVEFNWJI	2026-02-16	Sale Invoice #INV-SVEFNWJI	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
286	3	\N	JE-INV-V4VN5JJV	2026-02-16	Sale Invoice #INV-V4VN5JJV	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
287	3	\N	JE-INV-1CQK3WMK	2026-02-16	Sale Invoice #INV-1CQK3WMK	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
288	3	\N	JE-INV-C1UELFLE	2026-02-16	Sale Invoice #INV-C1UELFLE	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
289	3	\N	JE-INV-MAMDWN36	2026-02-16	Sale Invoice #INV-MAMDWN36	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
290	3	\N	JE-INV-8E59LQMZ	2026-02-16	Sale Invoice #INV-8E59LQMZ	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
291	3	\N	JE-INV-UNIHZGQX	2026-02-16	Sale Invoice #INV-UNIHZGQX	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
292	3	\N	JE-INV-RZGEHNAU	2026-02-16	Sale Invoice #INV-RZGEHNAU	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
293	3	\N	JE-INV-TEIQOJFX	2026-02-16	Sale Invoice #INV-TEIQOJFX	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
294	3	\N	JE-INV-FX6A7POD	2026-02-16	Sale Invoice #INV-FX6A7POD	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
295	3	\N	JE-INV-BMX4M7IO	2026-02-16	Sale Invoice #INV-BMX4M7IO	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
296	3	\N	JE-INV-PX0QKNZW	2026-02-16	Sale Invoice #INV-PX0QKNZW	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
297	3	\N	JE-INV-VFHEPCSW	2026-02-16	Sale Invoice #INV-VFHEPCSW	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
298	3	\N	JE-INV-ZJFY1IXI	2026-02-16	Sale Invoice #INV-ZJFY1IXI	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
299	3	\N	JE-INV-MMSKODJB	2026-02-16	Sale Invoice #INV-MMSKODJB	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
300	3	\N	JE-INV-QFLHORVL	2026-02-16	Sale Invoice #INV-QFLHORVL	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
301	3	\N	JE-INV-N4JPZXXG	2026-02-16	Sale Invoice #INV-N4JPZXXG	App\\Models\\Transaction	0	t	2026-02-16 20:41:41	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
302	1	8	JE-INV-260217-0001	2026-02-17	Sale Invoice #INV-260217-0001	App\\Models\\Transaction	0	t	2026-02-17 04:46:32	2026-02-17 04:46:32	2026-02-17 04:46:32	\N
303	1	8	JE-INV-260217-0002	2026-02-17	Sale Invoice #INV-260217-0002	App\\Models\\Transaction	0	t	2026-02-17 04:47:03	2026-02-17 04:47:03	2026-02-17 04:47:03	\N
304	1	8	JE-INV-260217-0003	2026-02-17	Sale Invoice #INV-260217-0003	App\\Models\\Transaction	0	t	2026-02-17 04:48:58	2026-02-17 04:48:58	2026-02-17 04:48:58	\N
305	1	8	JE-INV-260217-0004	2026-02-17	Sale Invoice #INV-260217-0004	App\\Models\\Transaction	0	t	2026-02-17 05:04:13	2026-02-17 05:04:13	2026-02-17 05:04:13	\N
306	1	8	JE-INV-260217-0005	2026-02-17	Sale Invoice #INV-260217-0005	App\\Models\\Transaction	0	t	2026-02-17 05:45:52	2026-02-17 05:45:52	2026-02-17 05:45:52	\N
307	1	8	JE-INV-260217-0006	2026-02-17	Sale Invoice #INV-260217-0006	App\\Models\\Transaction	0	t	2026-02-17 05:52:46	2026-02-17 05:52:46	2026-02-17 05:52:46	\N
308	1	8	JE-INV-260217-0007	2026-02-17	Sale Invoice #INV-260217-0007	App\\Models\\Transaction	0	t	2026-02-17 05:54:09	2026-02-17 05:54:09	2026-02-17 05:54:09	\N
\.


--
-- Data for Name: journal_items; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.journal_items (id, journal_entry_id, account_code, account_name, debit, credit, created_at, updated_at) FROM stdin;
1	2	1100	Cash	123424.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
2	2	4000	Sales Revenue	0.00	106400.00	2026-02-16 20:41:31	2026-02-16 20:41:31
3	2	2100	Tax Payable (PPN)	0.00	11704.00	2026-02-16 20:41:31	2026-02-16 20:41:31
4	2	4100	Service Income	0.00	5320.00	2026-02-16 20:41:31	2026-02-16 20:41:31
5	2	5000	Cost of Goods Sold	92361.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
6	2	1300	Inventory	0.00	92361.00	2026-02-16 20:41:31	2026-02-16 20:41:31
7	3	1100	Cash	128876.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
8	3	4000	Sales Revenue	0.00	111100.00	2026-02-16 20:41:31	2026-02-16 20:41:31
9	3	2100	Tax Payable (PPN)	0.00	12221.00	2026-02-16 20:41:31	2026-02-16 20:41:31
10	3	4100	Service Income	0.00	5555.00	2026-02-16 20:41:31	2026-02-16 20:41:31
11	3	5000	Cost of Goods Sold	96410.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
12	3	1300	Inventory	0.00	96410.00	2026-02-16 20:41:31	2026-02-16 20:41:31
13	4	1100	Cash	52896.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
14	4	1120	E	79344.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
15	4	4000	Sales Revenue	0.00	114000.00	2026-02-16 20:41:31	2026-02-16 20:41:31
16	4	2100	Tax Payable (PPN)	0.00	12540.00	2026-02-16 20:41:31	2026-02-16 20:41:31
17	4	4100	Service Income	0.00	5700.00	2026-02-16 20:41:31	2026-02-16 20:41:31
18	4	5000	Cost of Goods Sold	98976.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
19	4	1300	Inventory	0.00	98976.00	2026-02-16 20:41:31	2026-02-16 20:41:31
20	5	1100	Cash	286752.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
21	5	4000	Sales Revenue	0.00	247200.00	2026-02-16 20:41:31	2026-02-16 20:41:31
22	5	2100	Tax Payable (PPN)	0.00	27192.00	2026-02-16 20:41:31	2026-02-16 20:41:31
23	5	4100	Service Income	0.00	12360.00	2026-02-16 20:41:31	2026-02-16 20:41:31
24	5	5000	Cost of Goods Sold	214627.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
25	5	1300	Inventory	0.00	214627.00	2026-02-16 20:41:31	2026-02-16 20:41:31
26	6	1100	Cash	65053.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
27	6	1120	E	97579.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
28	6	4000	Sales Revenue	0.00	140200.00	2026-02-16 20:41:31	2026-02-16 20:41:31
29	6	2100	Tax Payable (PPN)	0.00	15422.00	2026-02-16 20:41:31	2026-02-16 20:41:31
30	6	4100	Service Income	0.00	7010.00	2026-02-16 20:41:31	2026-02-16 20:41:31
31	6	5000	Cost of Goods Sold	121738.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
32	6	1300	Inventory	0.00	121738.00	2026-02-16 20:41:31	2026-02-16 20:41:31
33	7	1100	Cash	62779.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
34	7	1120	E	94169.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
35	7	4000	Sales Revenue	0.00	135300.00	2026-02-16 20:41:31	2026-02-16 20:41:31
36	7	2100	Tax Payable (PPN)	0.00	14883.00	2026-02-16 20:41:31	2026-02-16 20:41:31
37	7	4100	Service Income	0.00	6765.00	2026-02-16 20:41:31	2026-02-16 20:41:31
38	7	5000	Cost of Goods Sold	117385.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
39	7	1300	Inventory	0.00	117385.00	2026-02-16 20:41:31	2026-02-16 20:41:31
40	8	1120	E	92684.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
41	8	4000	Sales Revenue	0.00	79900.00	2026-02-16 20:41:31	2026-02-16 20:41:31
42	8	2100	Tax Payable (PPN)	0.00	8789.00	2026-02-16 20:41:31	2026-02-16 20:41:31
43	8	4100	Service Income	0.00	3995.00	2026-02-16 20:41:31	2026-02-16 20:41:31
44	8	5000	Cost of Goods Sold	69262.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
45	8	1300	Inventory	0.00	69262.00	2026-02-16 20:41:31	2026-02-16 20:41:31
46	9	1100	Cash	86304.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
47	9	4000	Sales Revenue	0.00	74400.00	2026-02-16 20:41:31	2026-02-16 20:41:31
48	9	2100	Tax Payable (PPN)	0.00	8184.00	2026-02-16 20:41:31	2026-02-16 20:41:31
49	9	4100	Service Income	0.00	3720.00	2026-02-16 20:41:31	2026-02-16 20:41:31
50	9	5000	Cost of Goods Sold	64593.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
51	9	1300	Inventory	0.00	64593.00	2026-02-16 20:41:31	2026-02-16 20:41:31
52	10	1120	E	25056.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
53	10	4000	Sales Revenue	0.00	21600.00	2026-02-16 20:41:31	2026-02-16 20:41:31
54	10	2100	Tax Payable (PPN)	0.00	2376.00	2026-02-16 20:41:31	2026-02-16 20:41:31
55	10	4100	Service Income	0.00	1080.00	2026-02-16 20:41:31	2026-02-16 20:41:31
56	10	5000	Cost of Goods Sold	18579.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
57	10	1300	Inventory	0.00	18579.00	2026-02-16 20:41:31	2026-02-16 20:41:31
58	11	1100	Cash	21692.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
59	11	4000	Sales Revenue	0.00	18700.00	2026-02-16 20:41:31	2026-02-16 20:41:31
60	11	2100	Tax Payable (PPN)	0.00	2057.00	2026-02-16 20:41:31	2026-02-16 20:41:31
61	11	4100	Service Income	0.00	935.00	2026-02-16 20:41:31	2026-02-16 20:41:31
62	11	5000	Cost of Goods Sold	16186.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
63	11	1300	Inventory	0.00	16186.00	2026-02-16 20:41:31	2026-02-16 20:41:31
64	12	1100	Cash	31204.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
65	12	4000	Sales Revenue	0.00	26900.00	2026-02-16 20:41:31	2026-02-16 20:41:31
66	12	2100	Tax Payable (PPN)	0.00	2959.00	2026-02-16 20:41:31	2026-02-16 20:41:31
67	12	4100	Service Income	0.00	1345.00	2026-02-16 20:41:31	2026-02-16 20:41:31
68	12	5000	Cost of Goods Sold	23370.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
69	12	1300	Inventory	0.00	23370.00	2026-02-16 20:41:31	2026-02-16 20:41:31
70	13	1100	Cash	25938.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
71	13	1120	E	38906.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
72	13	4000	Sales Revenue	0.00	55900.00	2026-02-16 20:41:31	2026-02-16 20:41:31
73	13	2100	Tax Payable (PPN)	0.00	6149.00	2026-02-16 20:41:31	2026-02-16 20:41:31
74	13	4100	Service Income	0.00	2795.00	2026-02-16 20:41:31	2026-02-16 20:41:31
75	13	5000	Cost of Goods Sold	48535.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
76	13	1300	Inventory	0.00	48535.00	2026-02-16 20:41:31	2026-02-16 20:41:31
77	14	1100	Cash	81386.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
78	14	1120	E	122078.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
79	14	4000	Sales Revenue	0.00	175400.00	2026-02-16 20:41:31	2026-02-16 20:41:31
80	14	2100	Tax Payable (PPN)	0.00	19294.00	2026-02-16 20:41:31	2026-02-16 20:41:31
81	14	4100	Service Income	0.00	8770.00	2026-02-16 20:41:31	2026-02-16 20:41:31
82	14	5000	Cost of Goods Sold	152343.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
83	14	1300	Inventory	0.00	152343.00	2026-02-16 20:41:31	2026-02-16 20:41:31
84	15	1100	Cash	58371.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
85	15	1120	E	87557.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
86	15	4000	Sales Revenue	0.00	125800.00	2026-02-16 20:41:31	2026-02-16 20:41:31
87	15	2100	Tax Payable (PPN)	0.00	13838.00	2026-02-16 20:41:31	2026-02-16 20:41:31
88	15	4100	Service Income	0.00	6290.00	2026-02-16 20:41:31	2026-02-16 20:41:31
89	15	5000	Cost of Goods Sold	108989.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
90	15	1300	Inventory	0.00	108989.00	2026-02-16 20:41:31	2026-02-16 20:41:31
91	16	1100	Cash	59253.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
92	16	1120	E	88879.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
93	16	4000	Sales Revenue	0.00	127700.00	2026-02-16 20:41:31	2026-02-16 20:41:31
94	16	2100	Tax Payable (PPN)	0.00	14047.00	2026-02-16 20:41:31	2026-02-16 20:41:31
95	16	4100	Service Income	0.00	6385.00	2026-02-16 20:41:31	2026-02-16 20:41:31
96	16	5000	Cost of Goods Sold	110689.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
97	16	1300	Inventory	0.00	110689.00	2026-02-16 20:41:31	2026-02-16 20:41:31
98	17	1120	E	186992.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
99	17	4000	Sales Revenue	0.00	161200.00	2026-02-16 20:41:31	2026-02-16 20:41:31
100	17	2100	Tax Payable (PPN)	0.00	17732.00	2026-02-16 20:41:31	2026-02-16 20:41:31
101	17	4100	Service Income	0.00	8060.00	2026-02-16 20:41:31	2026-02-16 20:41:31
102	17	5000	Cost of Goods Sold	139798.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
103	17	1300	Inventory	0.00	139798.00	2026-02-16 20:41:31	2026-02-16 20:41:31
104	18	1100	Cash	157157.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
105	18	1120	E	235735.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
106	18	4000	Sales Revenue	0.00	338700.00	2026-02-16 20:41:31	2026-02-16 20:41:31
107	18	2100	Tax Payable (PPN)	0.00	37257.00	2026-02-16 20:41:31	2026-02-16 20:41:31
108	18	4100	Service Income	0.00	16935.00	2026-02-16 20:41:31	2026-02-16 20:41:31
109	18	5000	Cost of Goods Sold	294052.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
110	18	1300	Inventory	0.00	294052.00	2026-02-16 20:41:31	2026-02-16 20:41:31
111	19	1100	Cash	63684.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
112	19	4000	Sales Revenue	0.00	54900.00	2026-02-16 20:41:31	2026-02-16 20:41:31
113	19	2100	Tax Payable (PPN)	0.00	6039.00	2026-02-16 20:41:31	2026-02-16 20:41:31
114	19	4100	Service Income	0.00	2745.00	2026-02-16 20:41:31	2026-02-16 20:41:31
115	19	5000	Cost of Goods Sold	47605.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
116	19	1300	Inventory	0.00	47605.00	2026-02-16 20:41:31	2026-02-16 20:41:31
117	20	1100	Cash	160776.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
118	20	4000	Sales Revenue	0.00	138600.00	2026-02-16 20:41:31	2026-02-16 20:41:31
119	20	2100	Tax Payable (PPN)	0.00	15246.00	2026-02-16 20:41:31	2026-02-16 20:41:31
120	20	4100	Service Income	0.00	6930.00	2026-02-16 20:41:31	2026-02-16 20:41:31
121	20	5000	Cost of Goods Sold	120351.00	0.00	2026-02-16 20:41:31	2026-02-16 20:41:31
122	20	1300	Inventory	0.00	120351.00	2026-02-16 20:41:31	2026-02-16 20:41:31
123	21	1100	Cash	66027.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
124	21	1120	E	99041.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
125	21	4000	Sales Revenue	0.00	142300.00	2026-02-16 20:41:32	2026-02-16 20:41:32
126	21	2100	Tax Payable (PPN)	0.00	15653.00	2026-02-16 20:41:32	2026-02-16 20:41:32
127	21	4100	Service Income	0.00	7115.00	2026-02-16 20:41:32	2026-02-16 20:41:32
128	21	5000	Cost of Goods Sold	123400.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
129	21	1300	Inventory	0.00	123400.00	2026-02-16 20:41:32	2026-02-16 20:41:32
130	22	1100	Cash	37120.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
131	22	1120	E	55680.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
132	22	4000	Sales Revenue	0.00	80000.00	2026-02-16 20:41:32	2026-02-16 20:41:32
133	22	2100	Tax Payable (PPN)	0.00	8800.00	2026-02-16 20:41:32	2026-02-16 20:41:32
134	22	4100	Service Income	0.00	4000.00	2026-02-16 20:41:32	2026-02-16 20:41:32
135	22	5000	Cost of Goods Sold	69341.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
136	22	1300	Inventory	0.00	69341.00	2026-02-16 20:41:32	2026-02-16 20:41:32
137	23	1100	Cash	13920.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
138	23	1120	E	20880.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
139	23	4000	Sales Revenue	0.00	30000.00	2026-02-16 20:41:32	2026-02-16 20:41:32
140	23	2100	Tax Payable (PPN)	0.00	3300.00	2026-02-16 20:41:32	2026-02-16 20:41:32
141	23	4100	Service Income	0.00	1500.00	2026-02-16 20:41:32	2026-02-16 20:41:32
142	23	5000	Cost of Goods Sold	26037.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
143	23	1300	Inventory	0.00	26037.00	2026-02-16 20:41:32	2026-02-16 20:41:32
144	24	1120	E	147436.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
145	24	4000	Sales Revenue	0.00	127100.00	2026-02-16 20:41:32	2026-02-16 20:41:32
146	24	2100	Tax Payable (PPN)	0.00	13981.00	2026-02-16 20:41:32	2026-02-16 20:41:32
147	24	4100	Service Income	0.00	6355.00	2026-02-16 20:41:32	2026-02-16 20:41:32
148	24	5000	Cost of Goods Sold	110227.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
149	24	1300	Inventory	0.00	110227.00	2026-02-16 20:41:32	2026-02-16 20:41:32
150	25	1100	Cash	156020.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
151	25	4000	Sales Revenue	0.00	134500.00	2026-02-16 20:41:32	2026-02-16 20:41:32
152	25	2100	Tax Payable (PPN)	0.00	14795.00	2026-02-16 20:41:32	2026-02-16 20:41:32
153	25	4100	Service Income	0.00	6725.00	2026-02-16 20:41:32	2026-02-16 20:41:32
154	25	5000	Cost of Goods Sold	116863.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
155	25	1300	Inventory	0.00	116863.00	2026-02-16 20:41:32	2026-02-16 20:41:32
156	26	1120	E	105792.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
157	26	4000	Sales Revenue	0.00	91200.00	2026-02-16 20:41:32	2026-02-16 20:41:32
158	26	2100	Tax Payable (PPN)	0.00	10032.00	2026-02-16 20:41:32	2026-02-16 20:41:32
159	26	4100	Service Income	0.00	4560.00	2026-02-16 20:41:32	2026-02-16 20:41:32
160	26	5000	Cost of Goods Sold	79173.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
161	26	1300	Inventory	0.00	79173.00	2026-02-16 20:41:32	2026-02-16 20:41:32
162	27	1120	E	206712.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
163	27	4000	Sales Revenue	0.00	178200.00	2026-02-16 20:41:32	2026-02-16 20:41:32
164	27	2100	Tax Payable (PPN)	0.00	19602.00	2026-02-16 20:41:32	2026-02-16 20:41:32
165	27	4100	Service Income	0.00	8910.00	2026-02-16 20:41:32	2026-02-16 20:41:32
166	27	5000	Cost of Goods Sold	154653.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
167	27	1300	Inventory	0.00	154653.00	2026-02-16 20:41:32	2026-02-16 20:41:32
168	28	1120	E	14616.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
169	28	4000	Sales Revenue	0.00	12600.00	2026-02-16 20:41:32	2026-02-16 20:41:32
170	28	2100	Tax Payable (PPN)	0.00	1386.00	2026-02-16 20:41:32	2026-02-16 20:41:32
171	28	4100	Service Income	0.00	630.00	2026-02-16 20:41:32	2026-02-16 20:41:32
172	28	5000	Cost of Goods Sold	10851.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
173	28	1300	Inventory	0.00	10851.00	2026-02-16 20:41:32	2026-02-16 20:41:32
174	29	1100	Cash	29789.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
175	29	1120	E	44683.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
176	29	4000	Sales Revenue	0.00	64200.00	2026-02-16 20:41:32	2026-02-16 20:41:32
177	29	2100	Tax Payable (PPN)	0.00	7062.00	2026-02-16 20:41:32	2026-02-16 20:41:32
178	29	4100	Service Income	0.00	3210.00	2026-02-16 20:41:32	2026-02-16 20:41:32
179	29	5000	Cost of Goods Sold	55677.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
180	29	1300	Inventory	0.00	55677.00	2026-02-16 20:41:32	2026-02-16 20:41:32
181	30	1100	Cash	23942.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
182	30	1120	E	35914.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
183	30	4000	Sales Revenue	0.00	51600.00	2026-02-16 20:41:32	2026-02-16 20:41:32
184	30	2100	Tax Payable (PPN)	0.00	5676.00	2026-02-16 20:41:32	2026-02-16 20:41:32
185	30	4100	Service Income	0.00	2580.00	2026-02-16 20:41:32	2026-02-16 20:41:32
186	30	5000	Cost of Goods Sold	44655.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
187	30	1300	Inventory	0.00	44655.00	2026-02-16 20:41:32	2026-02-16 20:41:32
188	31	1120	E	261464.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
189	31	4000	Sales Revenue	0.00	225400.00	2026-02-16 20:41:32	2026-02-16 20:41:32
190	31	2100	Tax Payable (PPN)	0.00	24794.00	2026-02-16 20:41:32	2026-02-16 20:41:32
191	31	4100	Service Income	0.00	11270.00	2026-02-16 20:41:32	2026-02-16 20:41:32
192	31	5000	Cost of Goods Sold	195751.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
193	31	1300	Inventory	0.00	195751.00	2026-02-16 20:41:32	2026-02-16 20:41:32
194	32	1120	E	195228.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
195	32	4000	Sales Revenue	0.00	168300.00	2026-02-16 20:41:32	2026-02-16 20:41:32
196	32	2100	Tax Payable (PPN)	0.00	18513.00	2026-02-16 20:41:32	2026-02-16 20:41:32
197	32	4100	Service Income	0.00	8415.00	2026-02-16 20:41:32	2026-02-16 20:41:32
198	32	5000	Cost of Goods Sold	146057.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
199	32	1300	Inventory	0.00	146057.00	2026-02-16 20:41:32	2026-02-16 20:41:32
200	33	1100	Cash	134444.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
201	33	4000	Sales Revenue	0.00	115900.00	2026-02-16 20:41:32	2026-02-16 20:41:32
202	33	2100	Tax Payable (PPN)	0.00	12749.00	2026-02-16 20:41:32	2026-02-16 20:41:32
203	33	4100	Service Income	0.00	5795.00	2026-02-16 20:41:32	2026-02-16 20:41:32
204	33	5000	Cost of Goods Sold	100447.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
205	33	1300	Inventory	0.00	100447.00	2026-02-16 20:41:32	2026-02-16 20:41:32
206	34	1120	E	197200.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
207	34	4000	Sales Revenue	0.00	170000.00	2026-02-16 20:41:32	2026-02-16 20:41:32
208	34	2100	Tax Payable (PPN)	0.00	18700.00	2026-02-16 20:41:32	2026-02-16 20:41:32
209	34	4100	Service Income	0.00	8500.00	2026-02-16 20:41:32	2026-02-16 20:41:32
210	34	5000	Cost of Goods Sold	147461.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
211	34	1300	Inventory	0.00	147461.00	2026-02-16 20:41:32	2026-02-16 20:41:32
212	35	1100	Cash	22272.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
213	35	1120	E	33408.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
214	35	4000	Sales Revenue	0.00	48000.00	2026-02-16 20:41:32	2026-02-16 20:41:32
215	35	2100	Tax Payable (PPN)	0.00	5280.00	2026-02-16 20:41:32	2026-02-16 20:41:32
216	35	4100	Service Income	0.00	2400.00	2026-02-16 20:41:32	2026-02-16 20:41:32
217	35	5000	Cost of Goods Sold	41716.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
218	35	1300	Inventory	0.00	41716.00	2026-02-16 20:41:32	2026-02-16 20:41:32
219	36	1120	E	89436.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
220	36	4000	Sales Revenue	0.00	77100.00	2026-02-16 20:41:32	2026-02-16 20:41:32
221	36	2100	Tax Payable (PPN)	0.00	8481.00	2026-02-16 20:41:32	2026-02-16 20:41:32
222	36	4100	Service Income	0.00	3855.00	2026-02-16 20:41:32	2026-02-16 20:41:32
223	36	5000	Cost of Goods Sold	66850.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
224	36	1300	Inventory	0.00	66850.00	2026-02-16 20:41:32	2026-02-16 20:41:32
225	37	1120	E	146160.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
226	37	4000	Sales Revenue	0.00	126000.00	2026-02-16 20:41:32	2026-02-16 20:41:32
227	37	2100	Tax Payable (PPN)	0.00	13860.00	2026-02-16 20:41:32	2026-02-16 20:41:32
228	37	4100	Service Income	0.00	6300.00	2026-02-16 20:41:32	2026-02-16 20:41:32
229	37	5000	Cost of Goods Sold	109375.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
230	37	1300	Inventory	0.00	109375.00	2026-02-16 20:41:32	2026-02-16 20:41:32
231	38	1100	Cash	107323.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
232	38	1120	E	160985.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
233	38	4000	Sales Revenue	0.00	231300.00	2026-02-16 20:41:32	2026-02-16 20:41:32
234	38	2100	Tax Payable (PPN)	0.00	25443.00	2026-02-16 20:41:32	2026-02-16 20:41:32
235	38	4100	Service Income	0.00	11565.00	2026-02-16 20:41:32	2026-02-16 20:41:32
236	38	5000	Cost of Goods Sold	200919.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
237	38	1300	Inventory	0.00	200919.00	2026-02-16 20:41:32	2026-02-16 20:41:32
238	39	1120	E	88160.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
239	39	4000	Sales Revenue	0.00	76000.00	2026-02-16 20:41:32	2026-02-16 20:41:32
240	39	2100	Tax Payable (PPN)	0.00	8360.00	2026-02-16 20:41:32	2026-02-16 20:41:32
241	39	4100	Service Income	0.00	3800.00	2026-02-16 20:41:32	2026-02-16 20:41:32
242	39	5000	Cost of Goods Sold	65843.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
243	39	1300	Inventory	0.00	65843.00	2026-02-16 20:41:32	2026-02-16 20:41:32
244	40	1100	Cash	55262.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
245	40	1120	E	82894.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
246	40	4000	Sales Revenue	0.00	119100.00	2026-02-16 20:41:32	2026-02-16 20:41:32
247	40	2100	Tax Payable (PPN)	0.00	13101.00	2026-02-16 20:41:32	2026-02-16 20:41:32
248	40	4100	Service Income	0.00	5955.00	2026-02-16 20:41:32	2026-02-16 20:41:32
249	40	5000	Cost of Goods Sold	103428.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
250	40	1300	Inventory	0.00	103428.00	2026-02-16 20:41:32	2026-02-16 20:41:32
251	41	1100	Cash	117021.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
252	41	1120	E	175531.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
253	41	4000	Sales Revenue	0.00	252200.00	2026-02-16 20:41:32	2026-02-16 20:41:32
254	41	2100	Tax Payable (PPN)	0.00	27742.00	2026-02-16 20:41:32	2026-02-16 20:41:32
255	41	4100	Service Income	0.00	12610.00	2026-02-16 20:41:32	2026-02-16 20:41:32
256	41	5000	Cost of Goods Sold	218719.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
257	41	1300	Inventory	0.00	218719.00	2026-02-16 20:41:32	2026-02-16 20:41:32
258	42	1120	E	198824.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
259	42	4000	Sales Revenue	0.00	171400.00	2026-02-16 20:41:32	2026-02-16 20:41:32
260	42	2100	Tax Payable (PPN)	0.00	18854.00	2026-02-16 20:41:32	2026-02-16 20:41:32
261	42	4100	Service Income	0.00	8570.00	2026-02-16 20:41:32	2026-02-16 20:41:32
262	42	5000	Cost of Goods Sold	148771.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
263	42	1300	Inventory	0.00	148771.00	2026-02-16 20:41:32	2026-02-16 20:41:32
264	43	1100	Cash	254272.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
265	43	4000	Sales Revenue	0.00	219200.00	2026-02-16 20:41:32	2026-02-16 20:41:32
266	43	2100	Tax Payable (PPN)	0.00	24112.00	2026-02-16 20:41:32	2026-02-16 20:41:32
267	43	4100	Service Income	0.00	10960.00	2026-02-16 20:41:32	2026-02-16 20:41:32
268	43	5000	Cost of Goods Sold	190292.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
269	43	1300	Inventory	0.00	190292.00	2026-02-16 20:41:32	2026-02-16 20:41:32
270	44	1100	Cash	179568.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
271	44	4000	Sales Revenue	0.00	154800.00	2026-02-16 20:41:32	2026-02-16 20:41:32
272	44	2100	Tax Payable (PPN)	0.00	17028.00	2026-02-16 20:41:32	2026-02-16 20:41:32
273	44	4100	Service Income	0.00	7740.00	2026-02-16 20:41:32	2026-02-16 20:41:32
274	44	5000	Cost of Goods Sold	134381.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
275	44	1300	Inventory	0.00	134381.00	2026-02-16 20:41:32	2026-02-16 20:41:32
276	45	1100	Cash	304036.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
277	45	4000	Sales Revenue	0.00	262100.00	2026-02-16 20:41:32	2026-02-16 20:41:32
278	45	2100	Tax Payable (PPN)	0.00	28831.00	2026-02-16 20:41:32	2026-02-16 20:41:32
279	45	4100	Service Income	0.00	13105.00	2026-02-16 20:41:32	2026-02-16 20:41:32
280	45	5000	Cost of Goods Sold	227529.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
281	45	1300	Inventory	0.00	227529.00	2026-02-16 20:41:32	2026-02-16 20:41:32
282	46	1100	Cash	51040.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
283	46	1120	E	76560.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
284	46	4000	Sales Revenue	0.00	110000.00	2026-02-16 20:41:32	2026-02-16 20:41:32
285	46	2100	Tax Payable (PPN)	0.00	12100.00	2026-02-16 20:41:32	2026-02-16 20:41:32
286	46	4100	Service Income	0.00	5500.00	2026-02-16 20:41:32	2026-02-16 20:41:32
287	46	5000	Cost of Goods Sold	95520.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
288	46	1300	Inventory	0.00	95520.00	2026-02-16 20:41:32	2026-02-16 20:41:32
289	47	1100	Cash	92986.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
290	47	1120	E	139478.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
291	47	4000	Sales Revenue	0.00	200400.00	2026-02-16 20:41:32	2026-02-16 20:41:32
292	47	2100	Tax Payable (PPN)	0.00	22044.00	2026-02-16 20:41:32	2026-02-16 20:41:32
293	47	4100	Service Income	0.00	10020.00	2026-02-16 20:41:32	2026-02-16 20:41:32
294	47	5000	Cost of Goods Sold	174106.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
295	47	1300	Inventory	0.00	174106.00	2026-02-16 20:41:32	2026-02-16 20:41:32
296	48	1100	Cash	126858.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
297	48	1120	E	190286.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
298	48	4000	Sales Revenue	0.00	273400.00	2026-02-16 20:41:32	2026-02-16 20:41:32
299	48	2100	Tax Payable (PPN)	0.00	30074.00	2026-02-16 20:41:32	2026-02-16 20:41:32
300	48	4100	Service Income	0.00	13670.00	2026-02-16 20:41:32	2026-02-16 20:41:32
301	48	5000	Cost of Goods Sold	237532.00	0.00	2026-02-16 20:41:32	2026-02-16 20:41:32
302	48	1300	Inventory	0.00	237532.00	2026-02-16 20:41:32	2026-02-16 20:41:32
303	49	1120	E	421080.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
304	49	4000	Sales Revenue	0.00	363000.00	2026-02-16 20:41:33	2026-02-16 20:41:33
305	49	2100	Tax Payable (PPN)	0.00	39930.00	2026-02-16 20:41:33	2026-02-16 20:41:33
306	49	4100	Service Income	0.00	18150.00	2026-02-16 20:41:33	2026-02-16 20:41:33
307	49	5000	Cost of Goods Sold	315472.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
308	49	1300	Inventory	0.00	315472.00	2026-02-16 20:41:33	2026-02-16 20:41:33
309	50	1100	Cash	109643.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
310	50	1120	E	164465.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
311	50	4000	Sales Revenue	0.00	236300.00	2026-02-16 20:41:33	2026-02-16 20:41:33
312	50	2100	Tax Payable (PPN)	0.00	25993.00	2026-02-16 20:41:33	2026-02-16 20:41:33
313	50	4100	Service Income	0.00	11815.00	2026-02-16 20:41:33	2026-02-16 20:41:33
314	50	5000	Cost of Goods Sold	204731.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
315	50	1300	Inventory	0.00	204731.00	2026-02-16 20:41:33	2026-02-16 20:41:33
316	51	1100	Cash	52618.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
317	51	1120	E	78926.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
318	51	4000	Sales Revenue	0.00	113400.00	2026-02-16 20:41:33	2026-02-16 20:41:33
319	51	2100	Tax Payable (PPN)	0.00	12474.00	2026-02-16 20:41:33	2026-02-16 20:41:33
320	51	4100	Service Income	0.00	5670.00	2026-02-16 20:41:33	2026-02-16 20:41:33
321	51	5000	Cost of Goods Sold	98526.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
322	51	1300	Inventory	0.00	98526.00	2026-02-16 20:41:33	2026-02-16 20:41:33
323	52	1120	E	426300.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
324	52	4000	Sales Revenue	0.00	367500.00	2026-02-16 20:41:33	2026-02-16 20:41:33
325	52	2100	Tax Payable (PPN)	0.00	40425.00	2026-02-16 20:41:33	2026-02-16 20:41:33
326	52	4100	Service Income	0.00	18375.00	2026-02-16 20:41:33	2026-02-16 20:41:33
327	52	5000	Cost of Goods Sold	319027.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
328	52	1300	Inventory	0.00	319027.00	2026-02-16 20:41:33	2026-02-16 20:41:33
329	53	1120	E	122728.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
330	53	4000	Sales Revenue	0.00	105800.00	2026-02-16 20:41:33	2026-02-16 20:41:33
331	53	2100	Tax Payable (PPN)	0.00	11638.00	2026-02-16 20:41:33	2026-02-16 20:41:33
332	53	4100	Service Income	0.00	5290.00	2026-02-16 20:41:33	2026-02-16 20:41:33
333	53	5000	Cost of Goods Sold	91750.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
334	53	1300	Inventory	0.00	91750.00	2026-02-16 20:41:33	2026-02-16 20:41:33
335	54	1100	Cash	28118.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
336	54	1120	E	42178.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
337	54	4000	Sales Revenue	0.00	60600.00	2026-02-16 20:41:33	2026-02-16 20:41:33
338	54	2100	Tax Payable (PPN)	0.00	6666.00	2026-02-16 20:41:33	2026-02-16 20:41:33
339	54	4100	Service Income	0.00	3030.00	2026-02-16 20:41:33	2026-02-16 20:41:33
340	54	5000	Cost of Goods Sold	52665.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
341	54	1300	Inventory	0.00	52665.00	2026-02-16 20:41:33	2026-02-16 20:41:33
342	55	1100	Cash	102312.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
343	55	4000	Sales Revenue	0.00	88200.00	2026-02-16 20:41:33	2026-02-16 20:41:33
344	55	2100	Tax Payable (PPN)	0.00	9702.00	2026-02-16 20:41:33	2026-02-16 20:41:33
345	55	4100	Service Income	0.00	4410.00	2026-02-16 20:41:33	2026-02-16 20:41:33
346	55	5000	Cost of Goods Sold	76403.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
347	55	1300	Inventory	0.00	76403.00	2026-02-16 20:41:33	2026-02-16 20:41:33
348	56	1100	Cash	85051.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
349	56	1120	E	127577.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
350	56	4000	Sales Revenue	0.00	183300.00	2026-02-16 20:41:33	2026-02-16 20:41:33
351	56	2100	Tax Payable (PPN)	0.00	20163.00	2026-02-16 20:41:33	2026-02-16 20:41:33
352	56	4100	Service Income	0.00	9165.00	2026-02-16 20:41:33	2026-02-16 20:41:33
353	56	5000	Cost of Goods Sold	159190.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
354	56	1300	Inventory	0.00	159190.00	2026-02-16 20:41:33	2026-02-16 20:41:33
355	57	1120	E	188848.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
356	57	4000	Sales Revenue	0.00	162800.00	2026-02-16 20:41:33	2026-02-16 20:41:33
357	57	2100	Tax Payable (PPN)	0.00	17908.00	2026-02-16 20:41:33	2026-02-16 20:41:33
358	57	4100	Service Income	0.00	8140.00	2026-02-16 20:41:33	2026-02-16 20:41:33
359	57	5000	Cost of Goods Sold	141316.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
360	57	1300	Inventory	0.00	141316.00	2026-02-16 20:41:33	2026-02-16 20:41:33
361	58	1100	Cash	98275.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
362	58	1120	E	147413.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
363	58	4000	Sales Revenue	0.00	211800.00	2026-02-16 20:41:33	2026-02-16 20:41:33
364	58	2100	Tax Payable (PPN)	0.00	23298.00	2026-02-16 20:41:33	2026-02-16 20:41:33
365	58	4100	Service Income	0.00	10590.00	2026-02-16 20:41:33	2026-02-16 20:41:33
366	58	5000	Cost of Goods Sold	184038.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
367	58	1300	Inventory	0.00	184038.00	2026-02-16 20:41:33	2026-02-16 20:41:33
368	59	1120	E	37584.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
369	59	4000	Sales Revenue	0.00	32400.00	2026-02-16 20:41:33	2026-02-16 20:41:33
370	59	2100	Tax Payable (PPN)	0.00	3564.00	2026-02-16 20:41:33	2026-02-16 20:41:33
371	59	4100	Service Income	0.00	1620.00	2026-02-16 20:41:33	2026-02-16 20:41:33
372	59	5000	Cost of Goods Sold	28060.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
373	59	1300	Inventory	0.00	28060.00	2026-02-16 20:41:33	2026-02-16 20:41:33
374	60	1120	E	124932.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
375	60	4000	Sales Revenue	0.00	107700.00	2026-02-16 20:41:33	2026-02-16 20:41:33
376	60	2100	Tax Payable (PPN)	0.00	11847.00	2026-02-16 20:41:33	2026-02-16 20:41:33
377	60	4100	Service Income	0.00	5385.00	2026-02-16 20:41:33	2026-02-16 20:41:33
378	60	5000	Cost of Goods Sold	93453.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
379	60	1300	Inventory	0.00	93453.00	2026-02-16 20:41:33	2026-02-16 20:41:33
380	61	1100	Cash	33060.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
381	61	4000	Sales Revenue	0.00	28500.00	2026-02-16 20:41:33	2026-02-16 20:41:33
382	61	2100	Tax Payable (PPN)	0.00	3135.00	2026-02-16 20:41:33	2026-02-16 20:41:33
383	61	4100	Service Income	0.00	1425.00	2026-02-16 20:41:33	2026-02-16 20:41:33
384	61	5000	Cost of Goods Sold	24573.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
385	61	1300	Inventory	0.00	24573.00	2026-02-16 20:41:33	2026-02-16 20:41:33
386	62	1100	Cash	166924.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
387	62	4000	Sales Revenue	0.00	143900.00	2026-02-16 20:41:33	2026-02-16 20:41:33
388	62	2100	Tax Payable (PPN)	0.00	15829.00	2026-02-16 20:41:33	2026-02-16 20:41:33
389	62	4100	Service Income	0.00	7195.00	2026-02-16 20:41:33	2026-02-16 20:41:33
390	62	5000	Cost of Goods Sold	124807.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
391	62	1300	Inventory	0.00	124807.00	2026-02-16 20:41:33	2026-02-16 20:41:33
392	63	1120	E	232928.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
393	63	4000	Sales Revenue	0.00	200800.00	2026-02-16 20:41:33	2026-02-16 20:41:33
394	63	2100	Tax Payable (PPN)	0.00	22088.00	2026-02-16 20:41:33	2026-02-16 20:41:33
395	63	4100	Service Income	0.00	10040.00	2026-02-16 20:41:33	2026-02-16 20:41:33
396	63	5000	Cost of Goods Sold	174241.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
397	63	1300	Inventory	0.00	174241.00	2026-02-16 20:41:33	2026-02-16 20:41:33
398	64	1100	Cash	6682.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
399	64	1120	E	10022.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
400	64	4000	Sales Revenue	0.00	14400.00	2026-02-16 20:41:33	2026-02-16 20:41:33
401	64	2100	Tax Payable (PPN)	0.00	1584.00	2026-02-16 20:41:33	2026-02-16 20:41:33
402	64	4100	Service Income	0.00	720.00	2026-02-16 20:41:33	2026-02-16 20:41:33
403	64	5000	Cost of Goods Sold	12386.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
404	64	1300	Inventory	0.00	12386.00	2026-02-16 20:41:33	2026-02-16 20:41:33
405	65	1100	Cash	124004.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
406	65	4000	Sales Revenue	0.00	106900.00	2026-02-16 20:41:33	2026-02-16 20:41:33
407	65	2100	Tax Payable (PPN)	0.00	11759.00	2026-02-16 20:41:33	2026-02-16 20:41:33
408	65	4100	Service Income	0.00	5345.00	2026-02-16 20:41:33	2026-02-16 20:41:33
409	65	5000	Cost of Goods Sold	92868.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
410	65	1300	Inventory	0.00	92868.00	2026-02-16 20:41:33	2026-02-16 20:41:33
411	66	1100	Cash	89691.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
412	66	1120	E	134537.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
413	66	4000	Sales Revenue	0.00	193300.00	2026-02-16 20:41:33	2026-02-16 20:41:33
414	66	2100	Tax Payable (PPN)	0.00	21263.00	2026-02-16 20:41:33	2026-02-16 20:41:33
415	66	4100	Service Income	0.00	9665.00	2026-02-16 20:41:33	2026-02-16 20:41:33
416	66	5000	Cost of Goods Sold	167626.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
417	66	1300	Inventory	0.00	167626.00	2026-02-16 20:41:33	2026-02-16 20:41:33
418	67	1100	Cash	151496.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
419	67	4000	Sales Revenue	0.00	130600.00	2026-02-16 20:41:33	2026-02-16 20:41:33
420	67	2100	Tax Payable (PPN)	0.00	14366.00	2026-02-16 20:41:33	2026-02-16 20:41:33
421	67	4100	Service Income	0.00	6530.00	2026-02-16 20:41:33	2026-02-16 20:41:33
422	67	5000	Cost of Goods Sold	113405.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
423	67	1300	Inventory	0.00	113405.00	2026-02-16 20:41:33	2026-02-16 20:41:33
424	68	1100	Cash	46214.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
425	68	1120	E	69322.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
426	68	4000	Sales Revenue	0.00	99600.00	2026-02-16 20:41:33	2026-02-16 20:41:33
427	68	2100	Tax Payable (PPN)	0.00	10956.00	2026-02-16 20:41:33	2026-02-16 20:41:33
428	68	4100	Service Income	0.00	4980.00	2026-02-16 20:41:33	2026-02-16 20:41:33
429	68	5000	Cost of Goods Sold	86400.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
430	68	1300	Inventory	0.00	86400.00	2026-02-16 20:41:33	2026-02-16 20:41:33
431	69	1100	Cash	86072.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
432	69	1120	E	129108.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
433	69	4000	Sales Revenue	0.00	185500.00	2026-02-16 20:41:33	2026-02-16 20:41:33
434	69	2100	Tax Payable (PPN)	0.00	20405.00	2026-02-16 20:41:33	2026-02-16 20:41:33
435	69	4100	Service Income	0.00	9275.00	2026-02-16 20:41:33	2026-02-16 20:41:33
436	69	5000	Cost of Goods Sold	161099.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
437	69	1300	Inventory	0.00	161099.00	2026-02-16 20:41:33	2026-02-16 20:41:33
438	70	1100	Cash	38976.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
439	70	1120	E	58464.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
440	70	4000	Sales Revenue	0.00	84000.00	2026-02-16 20:41:33	2026-02-16 20:41:33
441	70	2100	Tax Payable (PPN)	0.00	9240.00	2026-02-16 20:41:33	2026-02-16 20:41:33
442	70	4100	Service Income	0.00	4200.00	2026-02-16 20:41:33	2026-02-16 20:41:33
443	70	5000	Cost of Goods Sold	72984.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
444	70	1300	Inventory	0.00	72984.00	2026-02-16 20:41:33	2026-02-16 20:41:33
445	71	1120	E	97440.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
446	71	4000	Sales Revenue	0.00	84000.00	2026-02-16 20:41:33	2026-02-16 20:41:33
447	71	2100	Tax Payable (PPN)	0.00	9240.00	2026-02-16 20:41:33	2026-02-16 20:41:33
448	71	4100	Service Income	0.00	4200.00	2026-02-16 20:41:33	2026-02-16 20:41:33
449	71	5000	Cost of Goods Sold	72860.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
450	71	1300	Inventory	0.00	72860.00	2026-02-16 20:41:33	2026-02-16 20:41:33
451	72	1100	Cash	16426.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
452	72	1120	E	24638.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
453	72	4000	Sales Revenue	0.00	35400.00	2026-02-16 20:41:33	2026-02-16 20:41:33
454	72	2100	Tax Payable (PPN)	0.00	3894.00	2026-02-16 20:41:33	2026-02-16 20:41:33
455	72	4100	Service Income	0.00	1770.00	2026-02-16 20:41:33	2026-02-16 20:41:33
456	72	5000	Cost of Goods Sold	30723.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
457	72	1300	Inventory	0.00	30723.00	2026-02-16 20:41:33	2026-02-16 20:41:33
458	73	1120	E	284664.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
459	73	4000	Sales Revenue	0.00	245400.00	2026-02-16 20:41:33	2026-02-16 20:41:33
460	73	2100	Tax Payable (PPN)	0.00	26994.00	2026-02-16 20:41:33	2026-02-16 20:41:33
461	73	4100	Service Income	0.00	12270.00	2026-02-16 20:41:33	2026-02-16 20:41:33
462	73	5000	Cost of Goods Sold	213021.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
463	73	1300	Inventory	0.00	213021.00	2026-02-16 20:41:33	2026-02-16 20:41:33
464	74	1100	Cash	17284.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
465	74	4000	Sales Revenue	0.00	14900.00	2026-02-16 20:41:33	2026-02-16 20:41:33
466	74	2100	Tax Payable (PPN)	0.00	1639.00	2026-02-16 20:41:33	2026-02-16 20:41:33
467	74	4100	Service Income	0.00	745.00	2026-02-16 20:41:33	2026-02-16 20:41:33
468	74	5000	Cost of Goods Sold	12880.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
469	74	1300	Inventory	0.00	12880.00	2026-02-16 20:41:33	2026-02-16 20:41:33
470	75	1120	E	59392.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
471	75	4000	Sales Revenue	0.00	51200.00	2026-02-16 20:41:33	2026-02-16 20:41:33
472	75	2100	Tax Payable (PPN)	0.00	5632.00	2026-02-16 20:41:33	2026-02-16 20:41:33
473	75	4100	Service Income	0.00	2560.00	2026-02-16 20:41:33	2026-02-16 20:41:33
474	75	5000	Cost of Goods Sold	44461.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
475	75	1300	Inventory	0.00	44461.00	2026-02-16 20:41:33	2026-02-16 20:41:33
476	76	1120	E	152424.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
477	76	4000	Sales Revenue	0.00	131400.00	2026-02-16 20:41:33	2026-02-16 20:41:33
478	76	2100	Tax Payable (PPN)	0.00	14454.00	2026-02-16 20:41:33	2026-02-16 20:41:33
479	76	4100	Service Income	0.00	6570.00	2026-02-16 20:41:33	2026-02-16 20:41:33
480	76	5000	Cost of Goods Sold	114138.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
481	76	1300	Inventory	0.00	114138.00	2026-02-16 20:41:33	2026-02-16 20:41:33
482	77	1120	E	190356.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
483	77	4000	Sales Revenue	0.00	164100.00	2026-02-16 20:41:33	2026-02-16 20:41:33
484	77	2100	Tax Payable (PPN)	0.00	18051.00	2026-02-16 20:41:33	2026-02-16 20:41:33
485	77	4100	Service Income	0.00	8205.00	2026-02-16 20:41:33	2026-02-16 20:41:33
486	77	5000	Cost of Goods Sold	142572.00	0.00	2026-02-16 20:41:33	2026-02-16 20:41:33
487	77	1300	Inventory	0.00	142572.00	2026-02-16 20:41:33	2026-02-16 20:41:33
488	78	1100	Cash	545200.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
489	78	4000	Sales Revenue	0.00	470000.00	2026-02-16 20:41:34	2026-02-16 20:41:34
490	78	2100	Tax Payable (PPN)	0.00	51700.00	2026-02-16 20:41:34	2026-02-16 20:41:34
491	78	4100	Service Income	0.00	23500.00	2026-02-16 20:41:34	2026-02-16 20:41:34
492	78	5000	Cost of Goods Sold	408434.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
493	78	1300	Inventory	0.00	408434.00	2026-02-16 20:41:34	2026-02-16 20:41:34
494	79	1100	Cash	7192.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
495	79	4000	Sales Revenue	0.00	6200.00	2026-02-16 20:41:34	2026-02-16 20:41:34
496	79	2100	Tax Payable (PPN)	0.00	682.00	2026-02-16 20:41:34	2026-02-16 20:41:34
497	79	4100	Service Income	0.00	310.00	2026-02-16 20:41:34	2026-02-16 20:41:34
498	79	5000	Cost of Goods Sold	5381.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
499	79	1300	Inventory	0.00	5381.00	2026-02-16 20:41:34	2026-02-16 20:41:34
500	80	1100	Cash	214832.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
501	80	4000	Sales Revenue	0.00	185200.00	2026-02-16 20:41:34	2026-02-16 20:41:34
502	80	2100	Tax Payable (PPN)	0.00	20372.00	2026-02-16 20:41:34	2026-02-16 20:41:34
503	80	4100	Service Income	0.00	9260.00	2026-02-16 20:41:34	2026-02-16 20:41:34
504	80	5000	Cost of Goods Sold	160932.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
505	80	1300	Inventory	0.00	160932.00	2026-02-16 20:41:34	2026-02-16 20:41:34
506	81	1100	Cash	112056.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
507	81	4000	Sales Revenue	0.00	96600.00	2026-02-16 20:41:34	2026-02-16 20:41:34
508	81	2100	Tax Payable (PPN)	0.00	10626.00	2026-02-16 20:41:34	2026-02-16 20:41:34
509	81	4100	Service Income	0.00	4830.00	2026-02-16 20:41:34	2026-02-16 20:41:34
510	81	5000	Cost of Goods Sold	83886.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
511	81	1300	Inventory	0.00	83886.00	2026-02-16 20:41:34	2026-02-16 20:41:34
512	82	1100	Cash	79344.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
513	82	1120	E	119016.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
514	82	4000	Sales Revenue	0.00	171000.00	2026-02-16 20:41:34	2026-02-16 20:41:34
515	82	2100	Tax Payable (PPN)	0.00	18810.00	2026-02-16 20:41:34	2026-02-16 20:41:34
516	82	4100	Service Income	0.00	8550.00	2026-02-16 20:41:34	2026-02-16 20:41:34
517	82	5000	Cost of Goods Sold	148467.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
518	82	1300	Inventory	0.00	148467.00	2026-02-16 20:41:34	2026-02-16 20:41:34
519	83	1100	Cash	3712.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
520	83	4000	Sales Revenue	0.00	3200.00	2026-02-16 20:41:34	2026-02-16 20:41:34
521	83	2100	Tax Payable (PPN)	0.00	352.00	2026-02-16 20:41:34	2026-02-16 20:41:34
522	83	4100	Service Income	0.00	160.00	2026-02-16 20:41:34	2026-02-16 20:41:34
523	83	5000	Cost of Goods Sold	2735.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
524	83	1300	Inventory	0.00	2735.00	2026-02-16 20:41:34	2026-02-16 20:41:34
525	84	1100	Cash	4640.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
526	84	4000	Sales Revenue	0.00	4000.00	2026-02-16 20:41:34	2026-02-16 20:41:34
527	84	2100	Tax Payable (PPN)	0.00	440.00	2026-02-16 20:41:34	2026-02-16 20:41:34
528	84	4100	Service Income	0.00	200.00	2026-02-16 20:41:34	2026-02-16 20:41:34
529	84	5000	Cost of Goods Sold	3439.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
530	84	1300	Inventory	0.00	3439.00	2026-02-16 20:41:34	2026-02-16 20:41:34
531	85	1100	Cash	251140.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
532	85	4000	Sales Revenue	0.00	216500.00	2026-02-16 20:41:34	2026-02-16 20:41:34
533	85	2100	Tax Payable (PPN)	0.00	23815.00	2026-02-16 20:41:34	2026-02-16 20:41:34
534	85	4100	Service Income	0.00	10825.00	2026-02-16 20:41:34	2026-02-16 20:41:34
535	85	5000	Cost of Goods Sold	187913.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
536	85	1300	Inventory	0.00	187913.00	2026-02-16 20:41:34	2026-02-16 20:41:34
537	86	1100	Cash	426764.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
538	86	4000	Sales Revenue	0.00	367900.00	2026-02-16 20:41:34	2026-02-16 20:41:34
539	86	2100	Tax Payable (PPN)	0.00	40469.00	2026-02-16 20:41:34	2026-02-16 20:41:34
540	86	4100	Service Income	0.00	18395.00	2026-02-16 20:41:34	2026-02-16 20:41:34
541	86	5000	Cost of Goods Sold	319345.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
542	86	1300	Inventory	0.00	319345.00	2026-02-16 20:41:34	2026-02-16 20:41:34
543	87	1100	Cash	251604.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
544	87	4000	Sales Revenue	0.00	216900.00	2026-02-16 20:41:34	2026-02-16 20:41:34
545	87	2100	Tax Payable (PPN)	0.00	23859.00	2026-02-16 20:41:34	2026-02-16 20:41:34
546	87	4100	Service Income	0.00	10845.00	2026-02-16 20:41:34	2026-02-16 20:41:34
547	87	5000	Cost of Goods Sold	188423.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
548	87	1300	Inventory	0.00	188423.00	2026-02-16 20:41:34	2026-02-16 20:41:34
549	88	1100	Cash	116974.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
550	88	1120	E	175462.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
551	88	4000	Sales Revenue	0.00	252100.00	2026-02-16 20:41:34	2026-02-16 20:41:34
552	88	2100	Tax Payable (PPN)	0.00	27731.00	2026-02-16 20:41:34	2026-02-16 20:41:34
553	88	4100	Service Income	0.00	12605.00	2026-02-16 20:41:34	2026-02-16 20:41:34
554	88	5000	Cost of Goods Sold	218723.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
555	88	1300	Inventory	0.00	218723.00	2026-02-16 20:41:34	2026-02-16 20:41:34
556	89	1100	Cash	21390.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
557	89	1120	E	32086.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
558	89	4000	Sales Revenue	0.00	46100.00	2026-02-16 20:41:34	2026-02-16 20:41:34
559	89	2100	Tax Payable (PPN)	0.00	5071.00	2026-02-16 20:41:34	2026-02-16 20:41:34
560	89	4100	Service Income	0.00	2305.00	2026-02-16 20:41:34	2026-02-16 20:41:34
561	89	5000	Cost of Goods Sold	39932.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
562	89	1300	Inventory	0.00	39932.00	2026-02-16 20:41:34	2026-02-16 20:41:34
563	90	1100	Cash	63475.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
564	90	1120	E	95213.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
565	90	4000	Sales Revenue	0.00	136800.00	2026-02-16 20:41:34	2026-02-16 20:41:34
566	90	2100	Tax Payable (PPN)	0.00	15048.00	2026-02-16 20:41:34	2026-02-16 20:41:34
567	90	4100	Service Income	0.00	6840.00	2026-02-16 20:41:34	2026-02-16 20:41:34
568	90	5000	Cost of Goods Sold	118791.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
569	90	1300	Inventory	0.00	118791.00	2026-02-16 20:41:34	2026-02-16 20:41:34
570	91	1100	Cash	218196.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
571	91	4000	Sales Revenue	0.00	188100.00	2026-02-16 20:41:34	2026-02-16 20:41:34
572	91	2100	Tax Payable (PPN)	0.00	20691.00	2026-02-16 20:41:34	2026-02-16 20:41:34
573	91	4100	Service Income	0.00	9405.00	2026-02-16 20:41:34	2026-02-16 20:41:34
574	91	5000	Cost of Goods Sold	163106.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
575	91	1300	Inventory	0.00	163106.00	2026-02-16 20:41:34	2026-02-16 20:41:34
576	92	1120	E	190008.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
577	92	4000	Sales Revenue	0.00	163800.00	2026-02-16 20:41:34	2026-02-16 20:41:34
578	92	2100	Tax Payable (PPN)	0.00	18018.00	2026-02-16 20:41:34	2026-02-16 20:41:34
579	92	4100	Service Income	0.00	8190.00	2026-02-16 20:41:34	2026-02-16 20:41:34
580	92	5000	Cost of Goods Sold	142275.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
581	92	1300	Inventory	0.00	142275.00	2026-02-16 20:41:34	2026-02-16 20:41:34
582	93	1100	Cash	38976.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
583	93	1120	E	58464.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
584	93	4000	Sales Revenue	0.00	84000.00	2026-02-16 20:41:34	2026-02-16 20:41:34
585	93	2100	Tax Payable (PPN)	0.00	9240.00	2026-02-16 20:41:34	2026-02-16 20:41:34
586	93	4100	Service Income	0.00	4200.00	2026-02-16 20:41:34	2026-02-16 20:41:34
587	93	5000	Cost of Goods Sold	72984.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
588	93	1300	Inventory	0.00	72984.00	2026-02-16 20:41:34	2026-02-16 20:41:34
589	94	1100	Cash	54520.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
590	94	4000	Sales Revenue	0.00	47000.00	2026-02-16 20:41:34	2026-02-16 20:41:34
591	94	2100	Tax Payable (PPN)	0.00	5170.00	2026-02-16 20:41:34	2026-02-16 20:41:34
592	94	4100	Service Income	0.00	2350.00	2026-02-16 20:41:34	2026-02-16 20:41:34
593	94	5000	Cost of Goods Sold	40645.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
594	94	1300	Inventory	0.00	40645.00	2026-02-16 20:41:34	2026-02-16 20:41:34
595	95	1100	Cash	210540.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
596	95	4000	Sales Revenue	0.00	181500.00	2026-02-16 20:41:34	2026-02-16 20:41:34
597	95	2100	Tax Payable (PPN)	0.00	19965.00	2026-02-16 20:41:34	2026-02-16 20:41:34
598	95	4100	Service Income	0.00	9075.00	2026-02-16 20:41:34	2026-02-16 20:41:34
599	95	5000	Cost of Goods Sold	157456.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
600	95	1300	Inventory	0.00	157456.00	2026-02-16 20:41:34	2026-02-16 20:41:34
601	96	1100	Cash	131126.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
602	96	1120	E	196690.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
603	96	4000	Sales Revenue	0.00	282600.00	2026-02-16 20:41:34	2026-02-16 20:41:34
604	96	2100	Tax Payable (PPN)	0.00	31086.00	2026-02-16 20:41:34	2026-02-16 20:41:34
605	96	4100	Service Income	0.00	14130.00	2026-02-16 20:41:34	2026-02-16 20:41:34
606	96	5000	Cost of Goods Sold	245358.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
607	96	1300	Inventory	0.00	245358.00	2026-02-16 20:41:34	2026-02-16 20:41:34
608	97	1100	Cash	41064.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
609	97	4000	Sales Revenue	0.00	35400.00	2026-02-16 20:41:34	2026-02-16 20:41:34
610	97	2100	Tax Payable (PPN)	0.00	3894.00	2026-02-16 20:41:34	2026-02-16 20:41:34
611	97	4100	Service Income	0.00	1770.00	2026-02-16 20:41:34	2026-02-16 20:41:34
612	97	5000	Cost of Goods Sold	30754.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
613	97	1300	Inventory	0.00	30754.00	2026-02-16 20:41:34	2026-02-16 20:41:34
614	98	1100	Cash	156948.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
615	98	4000	Sales Revenue	0.00	135300.00	2026-02-16 20:41:34	2026-02-16 20:41:34
616	98	2100	Tax Payable (PPN)	0.00	14883.00	2026-02-16 20:41:34	2026-02-16 20:41:34
617	98	4100	Service Income	0.00	6765.00	2026-02-16 20:41:34	2026-02-16 20:41:34
618	98	5000	Cost of Goods Sold	117487.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
619	98	1300	Inventory	0.00	117487.00	2026-02-16 20:41:34	2026-02-16 20:41:34
620	99	1100	Cash	98948.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
621	99	4000	Sales Revenue	0.00	85300.00	2026-02-16 20:41:34	2026-02-16 20:41:34
622	99	2100	Tax Payable (PPN)	0.00	9383.00	2026-02-16 20:41:34	2026-02-16 20:41:34
623	99	4100	Service Income	0.00	4265.00	2026-02-16 20:41:34	2026-02-16 20:41:34
624	99	5000	Cost of Goods Sold	74015.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
625	99	1300	Inventory	0.00	74015.00	2026-02-16 20:41:34	2026-02-16 20:41:34
626	100	1100	Cash	104864.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
627	100	4000	Sales Revenue	0.00	90400.00	2026-02-16 20:41:34	2026-02-16 20:41:34
628	100	2100	Tax Payable (PPN)	0.00	9944.00	2026-02-16 20:41:34	2026-02-16 20:41:34
629	100	4100	Service Income	0.00	4520.00	2026-02-16 20:41:34	2026-02-16 20:41:34
630	100	5000	Cost of Goods Sold	78426.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
631	100	1300	Inventory	0.00	78426.00	2026-02-16 20:41:34	2026-02-16 20:41:34
632	101	1100	Cash	113100.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
633	101	4000	Sales Revenue	0.00	97500.00	2026-02-16 20:41:34	2026-02-16 20:41:34
634	101	2100	Tax Payable (PPN)	0.00	10725.00	2026-02-16 20:41:34	2026-02-16 20:41:34
635	101	4100	Service Income	0.00	4875.00	2026-02-16 20:41:34	2026-02-16 20:41:34
636	101	5000	Cost of Goods Sold	84687.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
637	101	1300	Inventory	0.00	84687.00	2026-02-16 20:41:34	2026-02-16 20:41:34
638	102	1120	E	116464.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
639	102	4000	Sales Revenue	0.00	100400.00	2026-02-16 20:41:34	2026-02-16 20:41:34
640	102	2100	Tax Payable (PPN)	0.00	11044.00	2026-02-16 20:41:34	2026-02-16 20:41:34
641	102	4100	Service Income	0.00	5020.00	2026-02-16 20:41:34	2026-02-16 20:41:34
642	102	5000	Cost of Goods Sold	87252.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
643	102	1300	Inventory	0.00	87252.00	2026-02-16 20:41:34	2026-02-16 20:41:34
644	103	1100	Cash	21854.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
645	103	1120	E	32782.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
646	103	4000	Sales Revenue	0.00	47100.00	2026-02-16 20:41:34	2026-02-16 20:41:34
647	103	2100	Tax Payable (PPN)	0.00	5181.00	2026-02-16 20:41:34	2026-02-16 20:41:34
648	103	4100	Service Income	0.00	2355.00	2026-02-16 20:41:34	2026-02-16 20:41:34
649	103	5000	Cost of Goods Sold	40775.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
650	103	1300	Inventory	0.00	40775.00	2026-02-16 20:41:34	2026-02-16 20:41:34
651	104	1100	Cash	40832.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
652	104	4000	Sales Revenue	0.00	35200.00	2026-02-16 20:41:34	2026-02-16 20:41:34
653	104	2100	Tax Payable (PPN)	0.00	3872.00	2026-02-16 20:41:34	2026-02-16 20:41:34
654	104	4100	Service Income	0.00	1760.00	2026-02-16 20:41:34	2026-02-16 20:41:34
655	104	5000	Cost of Goods Sold	30521.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
656	104	1300	Inventory	0.00	30521.00	2026-02-16 20:41:34	2026-02-16 20:41:34
657	105	1100	Cash	69600.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
658	105	1120	E	104400.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
659	105	4000	Sales Revenue	0.00	150000.00	2026-02-16 20:41:34	2026-02-16 20:41:34
660	105	2100	Tax Payable (PPN)	0.00	16500.00	2026-02-16 20:41:34	2026-02-16 20:41:34
661	105	4100	Service Income	0.00	7500.00	2026-02-16 20:41:34	2026-02-16 20:41:34
662	105	5000	Cost of Goods Sold	130365.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
663	105	1300	Inventory	0.00	130365.00	2026-02-16 20:41:34	2026-02-16 20:41:34
664	106	1100	Cash	22272.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
665	106	1120	E	33408.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
666	106	4000	Sales Revenue	0.00	48000.00	2026-02-16 20:41:34	2026-02-16 20:41:34
667	106	2100	Tax Payable (PPN)	0.00	5280.00	2026-02-16 20:41:34	2026-02-16 20:41:34
668	106	4100	Service Income	0.00	2400.00	2026-02-16 20:41:34	2026-02-16 20:41:34
669	106	5000	Cost of Goods Sold	41716.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
670	106	1300	Inventory	0.00	41716.00	2026-02-16 20:41:34	2026-02-16 20:41:34
671	107	1100	Cash	134142.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
672	107	1120	E	201214.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
673	107	4000	Sales Revenue	0.00	289100.00	2026-02-16 20:41:34	2026-02-16 20:41:34
674	107	2100	Tax Payable (PPN)	0.00	31801.00	2026-02-16 20:41:34	2026-02-16 20:41:34
675	107	4100	Service Income	0.00	14455.00	2026-02-16 20:41:34	2026-02-16 20:41:34
676	107	5000	Cost of Goods Sold	250993.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
677	107	1300	Inventory	0.00	250993.00	2026-02-16 20:41:34	2026-02-16 20:41:34
678	108	1120	E	64960.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
679	108	4000	Sales Revenue	0.00	56000.00	2026-02-16 20:41:34	2026-02-16 20:41:34
680	108	2100	Tax Payable (PPN)	0.00	6160.00	2026-02-16 20:41:34	2026-02-16 20:41:34
681	108	4100	Service Income	0.00	2800.00	2026-02-16 20:41:34	2026-02-16 20:41:34
682	108	5000	Cost of Goods Sold	48656.00	0.00	2026-02-16 20:41:34	2026-02-16 20:41:34
683	108	1300	Inventory	0.00	48656.00	2026-02-16 20:41:34	2026-02-16 20:41:34
684	109	1120	E	285244.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
685	109	4000	Sales Revenue	0.00	245900.00	2026-02-16 20:41:35	2026-02-16 20:41:35
686	109	2100	Tax Payable (PPN)	0.00	27049.00	2026-02-16 20:41:35	2026-02-16 20:41:35
687	109	4100	Service Income	0.00	12295.00	2026-02-16 20:41:35	2026-02-16 20:41:35
688	109	5000	Cost of Goods Sold	213568.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
689	109	1300	Inventory	0.00	213568.00	2026-02-16 20:41:35	2026-02-16 20:41:35
690	110	1100	Cash	3712.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
691	110	1120	E	5568.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
692	110	4000	Sales Revenue	0.00	8000.00	2026-02-16 20:41:35	2026-02-16 20:41:35
693	110	2100	Tax Payable (PPN)	0.00	880.00	2026-02-16 20:41:35	2026-02-16 20:41:35
694	110	4100	Service Income	0.00	400.00	2026-02-16 20:41:35	2026-02-16 20:41:35
695	110	5000	Cost of Goods Sold	6878.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
696	110	1300	Inventory	0.00	6878.00	2026-02-16 20:41:35	2026-02-16 20:41:35
697	111	1120	E	143608.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
698	111	4000	Sales Revenue	0.00	123800.00	2026-02-16 20:41:35	2026-02-16 20:41:35
699	111	2100	Tax Payable (PPN)	0.00	13618.00	2026-02-16 20:41:35	2026-02-16 20:41:35
700	111	4100	Service Income	0.00	6190.00	2026-02-16 20:41:35	2026-02-16 20:41:35
701	111	5000	Cost of Goods Sold	107506.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
702	111	1300	Inventory	0.00	107506.00	2026-02-16 20:41:35	2026-02-16 20:41:35
703	112	1120	E	69020.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
704	112	4000	Sales Revenue	0.00	59500.00	2026-02-16 20:41:35	2026-02-16 20:41:35
705	112	2100	Tax Payable (PPN)	0.00	6545.00	2026-02-16 20:41:35	2026-02-16 20:41:35
706	112	4100	Service Income	0.00	2975.00	2026-02-16 20:41:35	2026-02-16 20:41:35
707	112	5000	Cost of Goods Sold	51519.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
708	112	1300	Inventory	0.00	51519.00	2026-02-16 20:41:35	2026-02-16 20:41:35
709	113	1100	Cash	52896.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
710	113	4000	Sales Revenue	0.00	45600.00	2026-02-16 20:41:35	2026-02-16 20:41:35
711	113	2100	Tax Payable (PPN)	0.00	5016.00	2026-02-16 20:41:35	2026-02-16 20:41:35
712	113	4100	Service Income	0.00	2280.00	2026-02-16 20:41:35	2026-02-16 20:41:35
713	113	5000	Cost of Goods Sold	39597.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
714	113	1300	Inventory	0.00	39597.00	2026-02-16 20:41:35	2026-02-16 20:41:35
715	114	1100	Cash	177364.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
716	114	4000	Sales Revenue	0.00	152900.00	2026-02-16 20:41:35	2026-02-16 20:41:35
717	114	2100	Tax Payable (PPN)	0.00	16819.00	2026-02-16 20:41:35	2026-02-16 20:41:35
718	114	4100	Service Income	0.00	7645.00	2026-02-16 20:41:35	2026-02-16 20:41:35
719	114	5000	Cost of Goods Sold	132660.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
720	114	1300	Inventory	0.00	132660.00	2026-02-16 20:41:35	2026-02-16 20:41:35
721	115	1100	Cash	25474.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
722	115	1120	E	38210.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
723	115	4000	Sales Revenue	0.00	54900.00	2026-02-16 20:41:35	2026-02-16 20:41:35
724	115	2100	Tax Payable (PPN)	0.00	6039.00	2026-02-16 20:41:35	2026-02-16 20:41:35
725	115	4100	Service Income	0.00	2745.00	2026-02-16 20:41:35	2026-02-16 20:41:35
726	115	5000	Cost of Goods Sold	47610.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
727	115	1300	Inventory	0.00	47610.00	2026-02-16 20:41:35	2026-02-16 20:41:35
728	116	1100	Cash	60784.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
729	116	4000	Sales Revenue	0.00	52400.00	2026-02-16 20:41:35	2026-02-16 20:41:35
730	116	2100	Tax Payable (PPN)	0.00	5764.00	2026-02-16 20:41:35	2026-02-16 20:41:35
731	116	4100	Service Income	0.00	2620.00	2026-02-16 20:41:35	2026-02-16 20:41:35
732	116	5000	Cost of Goods Sold	45464.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
733	116	1300	Inventory	0.00	45464.00	2026-02-16 20:41:35	2026-02-16 20:41:35
734	117	1100	Cash	126811.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
735	117	1120	E	190217.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
736	117	4000	Sales Revenue	0.00	273300.00	2026-02-16 20:41:35	2026-02-16 20:41:35
737	117	2100	Tax Payable (PPN)	0.00	30063.00	2026-02-16 20:41:35	2026-02-16 20:41:35
738	117	4100	Service Income	0.00	13665.00	2026-02-16 20:41:35	2026-02-16 20:41:35
739	117	5000	Cost of Goods Sold	237148.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
740	117	1300	Inventory	0.00	237148.00	2026-02-16 20:41:35	2026-02-16 20:41:35
741	118	1120	E	77604.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
742	118	4000	Sales Revenue	0.00	66900.00	2026-02-16 20:41:35	2026-02-16 20:41:35
743	118	2100	Tax Payable (PPN)	0.00	7359.00	2026-02-16 20:41:35	2026-02-16 20:41:35
744	118	4100	Service Income	0.00	3345.00	2026-02-16 20:41:35	2026-02-16 20:41:35
745	118	5000	Cost of Goods Sold	58044.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
746	118	1300	Inventory	0.00	58044.00	2026-02-16 20:41:35	2026-02-16 20:41:35
747	119	1100	Cash	115722.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
748	119	1120	E	173582.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
749	119	4000	Sales Revenue	0.00	249400.00	2026-02-16 20:41:35	2026-02-16 20:41:35
750	119	2100	Tax Payable (PPN)	0.00	27434.00	2026-02-16 20:41:35	2026-02-16 20:41:35
751	119	4100	Service Income	0.00	12470.00	2026-02-16 20:41:35	2026-02-16 20:41:35
752	119	5000	Cost of Goods Sold	216488.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
753	119	1300	Inventory	0.00	216488.00	2026-02-16 20:41:35	2026-02-16 20:41:35
754	120	1120	E	255200.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
755	120	4000	Sales Revenue	0.00	220000.00	2026-02-16 20:41:35	2026-02-16 20:41:35
756	120	2100	Tax Payable (PPN)	0.00	24200.00	2026-02-16 20:41:35	2026-02-16 20:41:35
757	120	4100	Service Income	0.00	11000.00	2026-02-16 20:41:35	2026-02-16 20:41:35
758	120	5000	Cost of Goods Sold	191026.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
759	120	1300	Inventory	0.00	191026.00	2026-02-16 20:41:35	2026-02-16 20:41:35
760	121	1120	E	288260.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
761	121	4000	Sales Revenue	0.00	248500.00	2026-02-16 20:41:35	2026-02-16 20:41:35
762	121	2100	Tax Payable (PPN)	0.00	27335.00	2026-02-16 20:41:35	2026-02-16 20:41:35
763	121	4100	Service Income	0.00	12425.00	2026-02-16 20:41:35	2026-02-16 20:41:35
764	121	5000	Cost of Goods Sold	215620.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
765	121	1300	Inventory	0.00	215620.00	2026-02-16 20:41:35	2026-02-16 20:41:35
766	122	1100	Cash	252068.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
767	122	4000	Sales Revenue	0.00	217300.00	2026-02-16 20:41:35	2026-02-16 20:41:35
768	122	2100	Tax Payable (PPN)	0.00	23903.00	2026-02-16 20:41:35	2026-02-16 20:41:35
769	122	4100	Service Income	0.00	10865.00	2026-02-16 20:41:35	2026-02-16 20:41:35
770	122	5000	Cost of Goods Sold	188662.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
771	122	1300	Inventory	0.00	188662.00	2026-02-16 20:41:35	2026-02-16 20:41:35
772	123	1120	E	163444.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
773	123	4000	Sales Revenue	0.00	140900.00	2026-02-16 20:41:35	2026-02-16 20:41:35
774	123	2100	Tax Payable (PPN)	0.00	15499.00	2026-02-16 20:41:35	2026-02-16 20:41:35
775	123	4100	Service Income	0.00	7045.00	2026-02-16 20:41:35	2026-02-16 20:41:35
776	123	5000	Cost of Goods Sold	121969.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
777	123	1300	Inventory	0.00	121969.00	2026-02-16 20:41:35	2026-02-16 20:41:35
778	124	1100	Cash	334080.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
779	124	4000	Sales Revenue	0.00	288000.00	2026-02-16 20:41:35	2026-02-16 20:41:35
780	124	2100	Tax Payable (PPN)	0.00	31680.00	2026-02-16 20:41:35	2026-02-16 20:41:35
781	124	4100	Service Income	0.00	14400.00	2026-02-16 20:41:35	2026-02-16 20:41:35
782	124	5000	Cost of Goods Sold	250088.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
783	124	1300	Inventory	0.00	250088.00	2026-02-16 20:41:35	2026-02-16 20:41:35
784	125	1120	E	93960.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
785	125	4000	Sales Revenue	0.00	81000.00	2026-02-16 20:41:35	2026-02-16 20:41:35
786	125	2100	Tax Payable (PPN)	0.00	8910.00	2026-02-16 20:41:35	2026-02-16 20:41:35
787	125	4100	Service Income	0.00	4050.00	2026-02-16 20:41:35	2026-02-16 20:41:35
788	125	5000	Cost of Goods Sold	70274.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
789	125	1300	Inventory	0.00	70274.00	2026-02-16 20:41:35	2026-02-16 20:41:35
790	126	1120	E	196272.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
791	126	4000	Sales Revenue	0.00	169200.00	2026-02-16 20:41:35	2026-02-16 20:41:35
792	126	2100	Tax Payable (PPN)	0.00	18612.00	2026-02-16 20:41:35	2026-02-16 20:41:35
793	126	4100	Service Income	0.00	8460.00	2026-02-16 20:41:35	2026-02-16 20:41:35
794	126	5000	Cost of Goods Sold	146804.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
795	126	1300	Inventory	0.00	146804.00	2026-02-16 20:41:35	2026-02-16 20:41:35
796	127	1120	E	201724.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
797	127	4000	Sales Revenue	0.00	173900.00	2026-02-16 20:41:35	2026-02-16 20:41:35
798	127	2100	Tax Payable (PPN)	0.00	19129.00	2026-02-16 20:41:35	2026-02-16 20:41:35
799	127	4100	Service Income	0.00	8695.00	2026-02-16 20:41:35	2026-02-16 20:41:35
800	127	5000	Cost of Goods Sold	150866.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
801	127	1300	Inventory	0.00	150866.00	2026-02-16 20:41:35	2026-02-16 20:41:35
802	128	1120	E	486040.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
803	128	4000	Sales Revenue	0.00	419000.00	2026-02-16 20:41:35	2026-02-16 20:41:35
804	128	2100	Tax Payable (PPN)	0.00	46090.00	2026-02-16 20:41:35	2026-02-16 20:41:35
805	128	4100	Service Income	0.00	20950.00	2026-02-16 20:41:35	2026-02-16 20:41:35
806	128	5000	Cost of Goods Sold	363749.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
807	128	1300	Inventory	0.00	363749.00	2026-02-16 20:41:35	2026-02-16 20:41:35
808	129	1100	Cash	24267.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
809	129	1120	E	36401.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
810	129	4000	Sales Revenue	0.00	52300.00	2026-02-16 20:41:35	2026-02-16 20:41:35
811	129	2100	Tax Payable (PPN)	0.00	5753.00	2026-02-16 20:41:35	2026-02-16 20:41:35
812	129	4100	Service Income	0.00	2615.00	2026-02-16 20:41:35	2026-02-16 20:41:35
813	129	5000	Cost of Goods Sold	45402.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
814	129	1300	Inventory	0.00	45402.00	2026-02-16 20:41:35	2026-02-16 20:41:35
815	130	1120	E	238612.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
816	130	4000	Sales Revenue	0.00	205700.00	2026-02-16 20:41:35	2026-02-16 20:41:35
817	130	2100	Tax Payable (PPN)	0.00	22627.00	2026-02-16 20:41:35	2026-02-16 20:41:35
818	130	4100	Service Income	0.00	10285.00	2026-02-16 20:41:35	2026-02-16 20:41:35
819	130	5000	Cost of Goods Sold	178380.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
820	130	1300	Inventory	0.00	178380.00	2026-02-16 20:41:35	2026-02-16 20:41:35
821	131	1100	Cash	205436.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
822	131	4000	Sales Revenue	0.00	177100.00	2026-02-16 20:41:35	2026-02-16 20:41:35
823	131	2100	Tax Payable (PPN)	0.00	19481.00	2026-02-16 20:41:35	2026-02-16 20:41:35
824	131	4100	Service Income	0.00	8855.00	2026-02-16 20:41:35	2026-02-16 20:41:35
825	131	5000	Cost of Goods Sold	153563.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
826	131	1300	Inventory	0.00	153563.00	2026-02-16 20:41:35	2026-02-16 20:41:35
827	132	1120	E	128296.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
828	132	4000	Sales Revenue	0.00	110600.00	2026-02-16 20:41:35	2026-02-16 20:41:35
829	132	2100	Tax Payable (PPN)	0.00	12166.00	2026-02-16 20:41:35	2026-02-16 20:41:35
830	132	4100	Service Income	0.00	5530.00	2026-02-16 20:41:35	2026-02-16 20:41:35
831	132	5000	Cost of Goods Sold	95991.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
832	132	1300	Inventory	0.00	95991.00	2026-02-16 20:41:35	2026-02-16 20:41:35
833	133	1100	Cash	63452.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
834	133	4000	Sales Revenue	0.00	54700.00	2026-02-16 20:41:35	2026-02-16 20:41:35
835	133	2100	Tax Payable (PPN)	0.00	6017.00	2026-02-16 20:41:35	2026-02-16 20:41:35
836	133	4100	Service Income	0.00	2735.00	2026-02-16 20:41:35	2026-02-16 20:41:35
837	133	5000	Cost of Goods Sold	47524.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
838	133	1300	Inventory	0.00	47524.00	2026-02-16 20:41:35	2026-02-16 20:41:35
839	134	1100	Cash	22272.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
840	134	1120	E	33408.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
841	134	4000	Sales Revenue	0.00	48000.00	2026-02-16 20:41:35	2026-02-16 20:41:35
842	134	2100	Tax Payable (PPN)	0.00	5280.00	2026-02-16 20:41:35	2026-02-16 20:41:35
843	134	4100	Service Income	0.00	2400.00	2026-02-16 20:41:35	2026-02-16 20:41:35
844	134	5000	Cost of Goods Sold	41716.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
845	134	1300	Inventory	0.00	41716.00	2026-02-16 20:41:35	2026-02-16 20:41:35
846	135	1100	Cash	149454.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
847	135	1120	E	224182.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
848	135	4000	Sales Revenue	0.00	322100.00	2026-02-16 20:41:35	2026-02-16 20:41:35
849	135	2100	Tax Payable (PPN)	0.00	35431.00	2026-02-16 20:41:35	2026-02-16 20:41:35
850	135	4100	Service Income	0.00	16105.00	2026-02-16 20:41:35	2026-02-16 20:41:35
851	135	5000	Cost of Goods Sold	279696.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
852	135	1300	Inventory	0.00	279696.00	2026-02-16 20:41:35	2026-02-16 20:41:35
853	136	1100	Cash	39440.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
854	136	4000	Sales Revenue	0.00	34000.00	2026-02-16 20:41:35	2026-02-16 20:41:35
855	136	2100	Tax Payable (PPN)	0.00	3740.00	2026-02-16 20:41:35	2026-02-16 20:41:35
856	136	4100	Service Income	0.00	1700.00	2026-02-16 20:41:35	2026-02-16 20:41:35
857	136	5000	Cost of Goods Sold	29457.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
858	136	1300	Inventory	0.00	29457.00	2026-02-16 20:41:35	2026-02-16 20:41:35
859	137	1100	Cash	231420.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
860	137	4000	Sales Revenue	0.00	199500.00	2026-02-16 20:41:35	2026-02-16 20:41:35
861	137	2100	Tax Payable (PPN)	0.00	21945.00	2026-02-16 20:41:35	2026-02-16 20:41:35
862	137	4100	Service Income	0.00	9975.00	2026-02-16 20:41:35	2026-02-16 20:41:35
863	137	5000	Cost of Goods Sold	173218.00	0.00	2026-02-16 20:41:35	2026-02-16 20:41:35
864	137	1300	Inventory	0.00	173218.00	2026-02-16 20:41:35	2026-02-16 20:41:35
865	138	1120	E	277240.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
866	138	4000	Sales Revenue	0.00	239000.00	2026-02-16 20:41:36	2026-02-16 20:41:36
867	138	2100	Tax Payable (PPN)	0.00	26290.00	2026-02-16 20:41:36	2026-02-16 20:41:36
868	138	4100	Service Income	0.00	11950.00	2026-02-16 20:41:36	2026-02-16 20:41:36
869	138	5000	Cost of Goods Sold	207505.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
870	138	1300	Inventory	0.00	207505.00	2026-02-16 20:41:36	2026-02-16 20:41:36
871	139	1100	Cash	175276.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
872	139	4000	Sales Revenue	0.00	151100.00	2026-02-16 20:41:36	2026-02-16 20:41:36
873	139	2100	Tax Payable (PPN)	0.00	16621.00	2026-02-16 20:41:36	2026-02-16 20:41:36
874	139	4100	Service Income	0.00	7555.00	2026-02-16 20:41:36	2026-02-16 20:41:36
875	139	5000	Cost of Goods Sold	131051.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
876	139	1300	Inventory	0.00	131051.00	2026-02-16 20:41:36	2026-02-16 20:41:36
877	140	1100	Cash	134792.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
878	140	1120	E	202188.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
879	140	4000	Sales Revenue	0.00	290500.00	2026-02-16 20:41:36	2026-02-16 20:41:36
880	140	2100	Tax Payable (PPN)	0.00	31955.00	2026-02-16 20:41:36	2026-02-16 20:41:36
881	140	4100	Service Income	0.00	14525.00	2026-02-16 20:41:36	2026-02-16 20:41:36
882	140	5000	Cost of Goods Sold	252213.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
883	140	1300	Inventory	0.00	252213.00	2026-02-16 20:41:36	2026-02-16 20:41:36
884	141	1100	Cash	150336.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
885	141	4000	Sales Revenue	0.00	129600.00	2026-02-16 20:41:36	2026-02-16 20:41:36
886	141	2100	Tax Payable (PPN)	0.00	14256.00	2026-02-16 20:41:36	2026-02-16 20:41:36
887	141	4100	Service Income	0.00	6480.00	2026-02-16 20:41:36	2026-02-16 20:41:36
888	141	5000	Cost of Goods Sold	112446.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
889	141	1300	Inventory	0.00	112446.00	2026-02-16 20:41:36	2026-02-16 20:41:36
890	142	1100	Cash	185600.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
891	142	4000	Sales Revenue	0.00	160000.00	2026-02-16 20:41:36	2026-02-16 20:41:36
892	142	2100	Tax Payable (PPN)	0.00	17600.00	2026-02-16 20:41:36	2026-02-16 20:41:36
893	142	4100	Service Income	0.00	8000.00	2026-02-16 20:41:36	2026-02-16 20:41:36
894	142	5000	Cost of Goods Sold	138895.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
895	142	1300	Inventory	0.00	138895.00	2026-02-16 20:41:36	2026-02-16 20:41:36
896	143	1100	Cash	39904.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
897	143	4000	Sales Revenue	0.00	34400.00	2026-02-16 20:41:36	2026-02-16 20:41:36
898	143	2100	Tax Payable (PPN)	0.00	3784.00	2026-02-16 20:41:36	2026-02-16 20:41:36
899	143	4100	Service Income	0.00	1720.00	2026-02-16 20:41:36	2026-02-16 20:41:36
900	143	5000	Cost of Goods Sold	29770.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
901	143	1300	Inventory	0.00	29770.00	2026-02-16 20:41:36	2026-02-16 20:41:36
902	144	1100	Cash	441032.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
903	144	4000	Sales Revenue	0.00	380200.00	2026-02-16 20:41:36	2026-02-16 20:41:36
904	144	2100	Tax Payable (PPN)	0.00	41822.00	2026-02-16 20:41:36	2026-02-16 20:41:36
905	144	4100	Service Income	0.00	19010.00	2026-02-16 20:41:36	2026-02-16 20:41:36
906	144	5000	Cost of Goods Sold	330269.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
907	144	1300	Inventory	0.00	330269.00	2026-02-16 20:41:36	2026-02-16 20:41:36
908	145	1120	E	170984.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
909	145	4000	Sales Revenue	0.00	147400.00	2026-02-16 20:41:36	2026-02-16 20:41:36
910	145	2100	Tax Payable (PPN)	0.00	16214.00	2026-02-16 20:41:36	2026-02-16 20:41:36
911	145	4100	Service Income	0.00	7370.00	2026-02-16 20:41:36	2026-02-16 20:41:36
912	145	5000	Cost of Goods Sold	127973.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
913	145	1300	Inventory	0.00	127973.00	2026-02-16 20:41:36	2026-02-16 20:41:36
914	146	1120	E	104632.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
915	146	4000	Sales Revenue	0.00	90200.00	2026-02-16 20:41:36	2026-02-16 20:41:36
916	146	2100	Tax Payable (PPN)	0.00	9922.00	2026-02-16 20:41:36	2026-02-16 20:41:36
917	146	4100	Service Income	0.00	4510.00	2026-02-16 20:41:36	2026-02-16 20:41:36
918	146	5000	Cost of Goods Sold	78189.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
919	146	1300	Inventory	0.00	78189.00	2026-02-16 20:41:36	2026-02-16 20:41:36
920	147	1100	Cash	2970.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
921	147	1120	E	4454.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
922	147	4000	Sales Revenue	0.00	6400.00	2026-02-16 20:41:36	2026-02-16 20:41:36
923	147	2100	Tax Payable (PPN)	0.00	704.00	2026-02-16 20:41:36	2026-02-16 20:41:36
924	147	4100	Service Income	0.00	320.00	2026-02-16 20:41:36	2026-02-16 20:41:36
925	147	5000	Cost of Goods Sold	5470.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
926	147	1300	Inventory	0.00	5470.00	2026-02-16 20:41:36	2026-02-16 20:41:36
927	148	1100	Cash	49880.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
928	148	4000	Sales Revenue	0.00	43000.00	2026-02-16 20:41:36	2026-02-16 20:41:36
929	148	2100	Tax Payable (PPN)	0.00	4730.00	2026-02-16 20:41:36	2026-02-16 20:41:36
930	148	4100	Service Income	0.00	2150.00	2026-02-16 20:41:36	2026-02-16 20:41:36
931	148	5000	Cost of Goods Sold	37308.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
932	148	1300	Inventory	0.00	37308.00	2026-02-16 20:41:36	2026-02-16 20:41:36
933	149	1120	E	118088.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
934	149	4000	Sales Revenue	0.00	101800.00	2026-02-16 20:41:36	2026-02-16 20:41:36
935	149	2100	Tax Payable (PPN)	0.00	11198.00	2026-02-16 20:41:36	2026-02-16 20:41:36
936	149	4100	Service Income	0.00	5090.00	2026-02-16 20:41:36	2026-02-16 20:41:36
937	149	5000	Cost of Goods Sold	88242.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
938	149	1300	Inventory	0.00	88242.00	2026-02-16 20:41:36	2026-02-16 20:41:36
939	150	1100	Cash	58325.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
940	150	1120	E	87487.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
941	150	4000	Sales Revenue	0.00	125700.00	2026-02-16 20:41:36	2026-02-16 20:41:36
942	150	2100	Tax Payable (PPN)	0.00	13827.00	2026-02-16 20:41:36	2026-02-16 20:41:36
943	150	4100	Service Income	0.00	6285.00	2026-02-16 20:41:36	2026-02-16 20:41:36
944	150	5000	Cost of Goods Sold	109086.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
945	150	1300	Inventory	0.00	109086.00	2026-02-16 20:41:36	2026-02-16 20:41:36
946	151	1100	Cash	102962.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
947	151	1120	E	154442.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
948	151	4000	Sales Revenue	0.00	221900.00	2026-02-16 20:41:36	2026-02-16 20:41:36
949	151	2100	Tax Payable (PPN)	0.00	24409.00	2026-02-16 20:41:36	2026-02-16 20:41:36
950	151	4100	Service Income	0.00	11095.00	2026-02-16 20:41:36	2026-02-16 20:41:36
951	151	5000	Cost of Goods Sold	192746.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
952	151	1300	Inventory	0.00	192746.00	2026-02-16 20:41:36	2026-02-16 20:41:36
953	152	1100	Cash	56144.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
954	152	1120	E	84216.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
955	152	4000	Sales Revenue	0.00	121000.00	2026-02-16 20:41:36	2026-02-16 20:41:36
956	152	2100	Tax Payable (PPN)	0.00	13310.00	2026-02-16 20:41:36	2026-02-16 20:41:36
957	152	4100	Service Income	0.00	6050.00	2026-02-16 20:41:36	2026-02-16 20:41:36
958	152	5000	Cost of Goods Sold	104933.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
959	152	1300	Inventory	0.00	104933.00	2026-02-16 20:41:36	2026-02-16 20:41:36
960	153	1100	Cash	51968.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
961	153	4000	Sales Revenue	0.00	44800.00	2026-02-16 20:41:36	2026-02-16 20:41:36
962	153	2100	Tax Payable (PPN)	0.00	4928.00	2026-02-16 20:41:36	2026-02-16 20:41:36
963	153	4100	Service Income	0.00	2240.00	2026-02-16 20:41:36	2026-02-16 20:41:36
964	153	5000	Cost of Goods Sold	38800.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
965	153	1300	Inventory	0.00	38800.00	2026-02-16 20:41:36	2026-02-16 20:41:36
966	154	1120	E	191052.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
967	154	4000	Sales Revenue	0.00	164700.00	2026-02-16 20:41:36	2026-02-16 20:41:36
968	154	2100	Tax Payable (PPN)	0.00	18117.00	2026-02-16 20:41:36	2026-02-16 20:41:36
969	154	4100	Service Income	0.00	8235.00	2026-02-16 20:41:36	2026-02-16 20:41:36
970	154	5000	Cost of Goods Sold	143099.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
971	154	1300	Inventory	0.00	143099.00	2026-02-16 20:41:36	2026-02-16 20:41:36
972	155	1100	Cash	113216.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
973	155	4000	Sales Revenue	0.00	97600.00	2026-02-16 20:41:36	2026-02-16 20:41:36
974	155	2100	Tax Payable (PPN)	0.00	10736.00	2026-02-16 20:41:36	2026-02-16 20:41:36
975	155	4100	Service Income	0.00	4880.00	2026-02-16 20:41:36	2026-02-16 20:41:36
976	155	5000	Cost of Goods Sold	84651.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
977	155	1300	Inventory	0.00	84651.00	2026-02-16 20:41:36	2026-02-16 20:41:36
978	156	1120	E	275616.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
979	156	4000	Sales Revenue	0.00	237600.00	2026-02-16 20:41:36	2026-02-16 20:41:36
980	156	2100	Tax Payable (PPN)	0.00	26136.00	2026-02-16 20:41:36	2026-02-16 20:41:36
981	156	4100	Service Income	0.00	11880.00	2026-02-16 20:41:36	2026-02-16 20:41:36
982	156	5000	Cost of Goods Sold	206109.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
983	156	1300	Inventory	0.00	206109.00	2026-02-16 20:41:36	2026-02-16 20:41:36
984	157	1100	Cash	327120.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
985	157	4000	Sales Revenue	0.00	282000.00	2026-02-16 20:41:36	2026-02-16 20:41:36
986	157	2100	Tax Payable (PPN)	0.00	31020.00	2026-02-16 20:41:36	2026-02-16 20:41:36
987	157	4100	Service Income	0.00	14100.00	2026-02-16 20:41:36	2026-02-16 20:41:36
988	157	5000	Cost of Goods Sold	244705.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
989	157	1300	Inventory	0.00	244705.00	2026-02-16 20:41:36	2026-02-16 20:41:36
990	158	1100	Cash	156554.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
991	158	1120	E	234830.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
992	158	4000	Sales Revenue	0.00	337400.00	2026-02-16 20:41:36	2026-02-16 20:41:36
993	158	2100	Tax Payable (PPN)	0.00	37114.00	2026-02-16 20:41:36	2026-02-16 20:41:36
994	158	4100	Service Income	0.00	16870.00	2026-02-16 20:41:36	2026-02-16 20:41:36
995	158	5000	Cost of Goods Sold	293002.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
996	158	1300	Inventory	0.00	293002.00	2026-02-16 20:41:36	2026-02-16 20:41:36
997	159	1100	Cash	56608.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
998	159	1120	E	84912.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
999	159	4000	Sales Revenue	0.00	122000.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1000	159	2100	Tax Payable (PPN)	0.00	13420.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1001	159	4100	Service Income	0.00	6100.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1002	159	5000	Cost of Goods Sold	105856.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1003	159	1300	Inventory	0.00	105856.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1004	160	1100	Cash	23339.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1005	160	1120	E	35009.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1006	160	4000	Sales Revenue	0.00	50300.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1007	160	2100	Tax Payable (PPN)	0.00	5533.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1008	160	4100	Service Income	0.00	2515.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1009	160	5000	Cost of Goods Sold	43526.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1010	160	1300	Inventory	0.00	43526.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1011	161	1100	Cash	317028.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1012	161	4000	Sales Revenue	0.00	273300.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1013	161	2100	Tax Payable (PPN)	0.00	30063.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1014	161	4100	Service Income	0.00	13665.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1015	161	5000	Cost of Goods Sold	237373.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1016	161	1300	Inventory	0.00	237373.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1017	162	1120	E	166112.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1018	162	4000	Sales Revenue	0.00	143200.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1019	162	2100	Tax Payable (PPN)	0.00	15752.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1020	162	4100	Service Income	0.00	7160.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1021	162	5000	Cost of Goods Sold	124232.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1022	162	1300	Inventory	0.00	124232.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1023	163	1120	E	231072.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1024	163	4000	Sales Revenue	0.00	199200.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1025	163	2100	Tax Payable (PPN)	0.00	21912.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1026	163	4100	Service Income	0.00	9960.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1027	163	5000	Cost of Goods Sold	173016.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1028	163	1300	Inventory	0.00	173016.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1029	164	1100	Cash	231420.00	0.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1030	164	4000	Sales Revenue	0.00	199500.00	2026-02-16 20:41:36	2026-02-16 20:41:36
1031	164	2100	Tax Payable (PPN)	0.00	21945.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1032	164	4100	Service Income	0.00	9975.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1033	164	5000	Cost of Goods Sold	173099.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1034	164	1300	Inventory	0.00	173099.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1035	165	1100	Cash	292900.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1036	165	4000	Sales Revenue	0.00	252500.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1037	165	2100	Tax Payable (PPN)	0.00	27775.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1038	165	4100	Service Income	0.00	12625.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1039	165	5000	Cost of Goods Sold	219123.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1040	165	1300	Inventory	0.00	219123.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1041	166	1120	E	238264.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1042	166	4000	Sales Revenue	0.00	205400.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1043	166	2100	Tax Payable (PPN)	0.00	22594.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1044	166	4100	Service Income	0.00	10270.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1045	166	5000	Cost of Goods Sold	178536.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1046	166	1300	Inventory	0.00	178536.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1047	167	1120	E	35728.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1048	167	4000	Sales Revenue	0.00	30800.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1049	167	2100	Tax Payable (PPN)	0.00	3388.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1050	167	4100	Service Income	0.00	1540.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1051	167	5000	Cost of Goods Sold	26722.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1052	167	1300	Inventory	0.00	26722.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1053	168	1100	Cash	21437.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1054	168	1120	E	32155.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1055	168	4000	Sales Revenue	0.00	46200.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1056	168	2100	Tax Payable (PPN)	0.00	5082.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1057	168	4100	Service Income	0.00	2310.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1058	168	5000	Cost of Goods Sold	40117.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1059	168	1300	Inventory	0.00	40117.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1060	169	1100	Cash	257984.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1061	169	4000	Sales Revenue	0.00	222400.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1062	169	2100	Tax Payable (PPN)	0.00	24464.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1063	169	4100	Service Income	0.00	11120.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1064	169	5000	Cost of Goods Sold	193166.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1065	169	1300	Inventory	0.00	193166.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1066	170	1100	Cash	189196.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1067	170	4000	Sales Revenue	0.00	163100.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1068	170	2100	Tax Payable (PPN)	0.00	17941.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1069	170	4100	Service Income	0.00	8155.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1070	170	5000	Cost of Goods Sold	141544.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1071	170	1300	Inventory	0.00	141544.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1072	171	1100	Cash	60784.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1073	171	1120	E	91176.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1074	171	4000	Sales Revenue	0.00	131000.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1075	171	2100	Tax Payable (PPN)	0.00	14410.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1076	171	4100	Service Income	0.00	6550.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1077	171	5000	Cost of Goods Sold	113600.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1078	171	1300	Inventory	0.00	113600.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1079	172	1100	Cash	100734.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1080	172	1120	E	151102.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1081	172	4000	Sales Revenue	0.00	217100.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1082	172	2100	Tax Payable (PPN)	0.00	23881.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1083	172	4100	Service Income	0.00	10855.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1084	172	5000	Cost of Goods Sold	188360.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1085	172	1300	Inventory	0.00	188360.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1086	173	1100	Cash	31320.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1087	173	1120	E	46980.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1088	173	4000	Sales Revenue	0.00	67500.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1089	173	2100	Tax Payable (PPN)	0.00	7425.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1090	173	4100	Service Income	0.00	3375.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1091	173	5000	Cost of Goods Sold	58650.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1092	173	1300	Inventory	0.00	58650.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1093	174	1120	E	164604.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1094	174	4000	Sales Revenue	0.00	141900.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1095	174	2100	Tax Payable (PPN)	0.00	15609.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1096	174	4100	Service Income	0.00	7095.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1097	174	5000	Cost of Goods Sold	123099.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1098	174	1300	Inventory	0.00	123099.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1099	175	1100	Cash	310300.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1100	175	4000	Sales Revenue	0.00	267500.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1101	175	2100	Tax Payable (PPN)	0.00	29425.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1102	175	4100	Service Income	0.00	13375.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1103	175	5000	Cost of Goods Sold	232249.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1104	175	1300	Inventory	0.00	232249.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1105	176	1100	Cash	238148.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1106	176	4000	Sales Revenue	0.00	205300.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1107	176	2100	Tax Payable (PPN)	0.00	22583.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1108	176	4100	Service Income	0.00	10265.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1109	176	5000	Cost of Goods Sold	178333.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1110	176	1300	Inventory	0.00	178333.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1111	177	1100	Cash	59392.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1112	177	4000	Sales Revenue	0.00	51200.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1113	177	2100	Tax Payable (PPN)	0.00	5632.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1114	177	4100	Service Income	0.00	2560.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1115	177	5000	Cost of Goods Sold	44461.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1116	177	1300	Inventory	0.00	44461.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1117	178	1120	E	136416.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1118	178	4000	Sales Revenue	0.00	117600.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1119	178	2100	Tax Payable (PPN)	0.00	12936.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1120	178	4100	Service Income	0.00	5880.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1121	178	5000	Cost of Goods Sold	102112.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1122	178	1300	Inventory	0.00	102112.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1123	179	1120	E	114840.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1124	179	4000	Sales Revenue	0.00	99000.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1125	179	2100	Tax Payable (PPN)	0.00	10890.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1126	179	4100	Service Income	0.00	4950.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1127	179	5000	Cost of Goods Sold	85826.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1128	179	1300	Inventory	0.00	85826.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1129	180	1120	E	43616.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1130	180	4000	Sales Revenue	0.00	37600.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1131	180	2100	Tax Payable (PPN)	0.00	4136.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1132	180	4100	Service Income	0.00	1880.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1133	180	5000	Cost of Goods Sold	32665.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1134	180	1300	Inventory	0.00	32665.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1135	181	1120	E	242904.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1136	181	4000	Sales Revenue	0.00	209400.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1137	181	2100	Tax Payable (PPN)	0.00	23034.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1138	181	4100	Service Income	0.00	10470.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1139	181	5000	Cost of Goods Sold	181858.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1140	181	1300	Inventory	0.00	181858.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1141	182	1100	Cash	19952.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1142	182	1120	E	29928.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1143	182	4000	Sales Revenue	0.00	43000.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1144	182	2100	Tax Payable (PPN)	0.00	4730.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1145	182	4100	Service Income	0.00	2150.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1146	182	5000	Cost of Goods Sold	37308.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1147	182	1300	Inventory	0.00	37308.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1148	183	1100	Cash	91130.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1149	183	1120	E	136694.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1150	183	4000	Sales Revenue	0.00	196400.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1151	183	2100	Tax Payable (PPN)	0.00	21604.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1152	183	4100	Service Income	0.00	9820.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1153	183	5000	Cost of Goods Sold	170184.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1154	183	1300	Inventory	0.00	170184.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1155	184	1100	Cash	137994.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1156	184	1120	E	206990.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1157	184	4000	Sales Revenue	0.00	297400.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1158	184	2100	Tax Payable (PPN)	0.00	32714.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1159	184	4100	Service Income	0.00	14870.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1160	184	5000	Cost of Goods Sold	258229.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1161	184	1300	Inventory	0.00	258229.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1162	185	1100	Cash	106534.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1163	185	1120	E	159802.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1164	185	4000	Sales Revenue	0.00	229600.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1165	185	2100	Tax Payable (PPN)	0.00	25256.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1166	185	4100	Service Income	0.00	11480.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1167	185	5000	Cost of Goods Sold	199219.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1168	185	1300	Inventory	0.00	199219.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1169	186	1100	Cash	76328.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1170	186	1120	E	114492.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1171	186	4000	Sales Revenue	0.00	164500.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1172	186	2100	Tax Payable (PPN)	0.00	18095.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1173	186	4100	Service Income	0.00	8225.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1174	186	5000	Cost of Goods Sold	142552.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1175	186	1300	Inventory	0.00	142552.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1176	187	1100	Cash	28397.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1177	187	1120	E	42595.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1178	187	4000	Sales Revenue	0.00	61200.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1179	187	2100	Tax Payable (PPN)	0.00	6732.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1180	187	4100	Service Income	0.00	3060.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1181	187	5000	Cost of Goods Sold	53040.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1182	187	1300	Inventory	0.00	53040.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1183	188	1100	Cash	241628.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1184	188	4000	Sales Revenue	0.00	208300.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1185	188	2100	Tax Payable (PPN)	0.00	22913.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1186	188	4100	Service Income	0.00	10415.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1187	188	5000	Cost of Goods Sold	180734.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1188	188	1300	Inventory	0.00	180734.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1189	189	1100	Cash	16658.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1190	189	1120	E	24986.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1191	189	4000	Sales Revenue	0.00	35900.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1192	189	2100	Tax Payable (PPN)	0.00	3949.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1193	189	4100	Service Income	0.00	1795.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1194	189	5000	Cost of Goods Sold	31151.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1195	189	1300	Inventory	0.00	31151.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1196	190	1100	Cash	99760.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1197	190	4000	Sales Revenue	0.00	86000.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1198	190	2100	Tax Payable (PPN)	0.00	9460.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1199	190	4100	Service Income	0.00	4300.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1200	190	5000	Cost of Goods Sold	74616.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1201	190	1300	Inventory	0.00	74616.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1202	191	1100	Cash	207524.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1203	191	4000	Sales Revenue	0.00	178900.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1204	191	2100	Tax Payable (PPN)	0.00	19679.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1205	191	4100	Service Income	0.00	8945.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1206	191	5000	Cost of Goods Sold	155249.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1207	191	1300	Inventory	0.00	155249.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1208	192	1100	Cash	199520.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1209	192	4000	Sales Revenue	0.00	172000.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1210	192	2100	Tax Payable (PPN)	0.00	18920.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1211	192	4100	Service Income	0.00	8600.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1212	192	5000	Cost of Goods Sold	149379.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1213	192	1300	Inventory	0.00	149379.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1214	193	1120	E	197316.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1215	193	4000	Sales Revenue	0.00	170100.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1216	193	2100	Tax Payable (PPN)	0.00	18711.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1217	193	4100	Service Income	0.00	8505.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1218	193	5000	Cost of Goods Sold	147789.00	0.00	2026-02-16 20:41:37	2026-02-16 20:41:37
1219	193	1300	Inventory	0.00	147789.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1220	194	1100	Cash	252184.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1221	194	4000	Sales Revenue	0.00	217400.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1222	194	2100	Tax Payable (PPN)	0.00	23914.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1223	194	4100	Service Income	0.00	10870.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1224	194	5000	Cost of Goods Sold	188731.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1225	194	1300	Inventory	0.00	188731.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1226	195	1100	Cash	13920.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1227	195	1120	E	20880.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1228	195	4000	Sales Revenue	0.00	30000.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1229	195	2100	Tax Payable (PPN)	0.00	3300.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1230	195	4100	Service Income	0.00	1500.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1231	195	5000	Cost of Goods Sold	26037.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1232	195	1300	Inventory	0.00	26037.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1233	196	1100	Cash	115350.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1234	196	1120	E	173026.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1235	196	4000	Sales Revenue	0.00	248600.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1236	196	2100	Tax Payable (PPN)	0.00	27346.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1237	196	4100	Service Income	0.00	12430.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1238	196	5000	Cost of Goods Sold	216040.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1239	196	1300	Inventory	0.00	216040.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1240	197	1100	Cash	52896.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1241	197	1120	E	79344.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1242	197	4000	Sales Revenue	0.00	114000.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1243	197	2100	Tax Payable (PPN)	0.00	12540.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1244	197	4100	Service Income	0.00	5700.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1245	197	5000	Cost of Goods Sold	98976.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1246	197	1300	Inventory	0.00	98976.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1247	198	1100	Cash	13224.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1248	198	1120	E	19836.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1249	198	4000	Sales Revenue	0.00	28500.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1250	198	2100	Tax Payable (PPN)	0.00	3135.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1251	198	4100	Service Income	0.00	1425.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1252	198	5000	Cost of Goods Sold	24573.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1253	198	1300	Inventory	0.00	24573.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1254	199	1100	Cash	46910.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1255	199	1120	E	70366.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1256	199	4000	Sales Revenue	0.00	101100.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1257	199	2100	Tax Payable (PPN)	0.00	11121.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1258	199	4100	Service Income	0.00	5055.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1259	199	5000	Cost of Goods Sold	87658.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1260	199	1300	Inventory	0.00	87658.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1261	200	1120	E	286520.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1262	200	4000	Sales Revenue	0.00	247000.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1263	200	2100	Tax Payable (PPN)	0.00	27170.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1264	200	4100	Service Income	0.00	12350.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1265	200	5000	Cost of Goods Sold	214382.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1266	200	1300	Inventory	0.00	214382.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1267	201	1120	E	314592.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1268	201	4000	Sales Revenue	0.00	271200.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1269	201	2100	Tax Payable (PPN)	0.00	29832.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1270	201	4100	Service Income	0.00	13560.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1271	201	5000	Cost of Goods Sold	235659.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1272	201	1300	Inventory	0.00	235659.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1273	202	1100	Cash	92243.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1274	202	1120	E	138365.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1275	202	4000	Sales Revenue	0.00	198800.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1276	202	2100	Tax Payable (PPN)	0.00	21868.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1277	202	4100	Service Income	0.00	9940.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1278	202	5000	Cost of Goods Sold	172661.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1279	202	1300	Inventory	0.00	172661.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1280	203	1100	Cash	23200.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1281	203	1120	E	34800.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1282	203	4000	Sales Revenue	0.00	50000.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1283	203	2100	Tax Payable (PPN)	0.00	5500.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1284	203	4100	Service Income	0.00	2500.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1285	203	5000	Cost of Goods Sold	43410.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1286	203	1300	Inventory	0.00	43410.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1287	204	1100	Cash	85098.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1288	204	1120	E	127646.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1289	204	4000	Sales Revenue	0.00	183400.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1290	204	2100	Tax Payable (PPN)	0.00	20174.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1291	204	4100	Service Income	0.00	9170.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1292	204	5000	Cost of Goods Sold	159250.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1293	204	1300	Inventory	0.00	159250.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1294	205	1120	E	226780.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1295	205	4000	Sales Revenue	0.00	195500.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1296	205	2100	Tax Payable (PPN)	0.00	21505.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1297	205	4100	Service Income	0.00	9775.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1298	205	5000	Cost of Goods Sold	169874.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1299	205	1300	Inventory	0.00	169874.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1300	206	1120	E	380364.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1301	206	4000	Sales Revenue	0.00	327900.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1302	206	2100	Tax Payable (PPN)	0.00	36069.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1303	206	4100	Service Income	0.00	16395.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1304	206	5000	Cost of Goods Sold	284691.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1305	206	1300	Inventory	0.00	284691.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1306	207	1100	Cash	125628.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1307	207	4000	Sales Revenue	0.00	108300.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1308	207	2100	Tax Payable (PPN)	0.00	11913.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1309	207	4100	Service Income	0.00	5415.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1310	207	5000	Cost of Goods Sold	93918.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1311	207	1300	Inventory	0.00	93918.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1312	208	1100	Cash	157992.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1313	208	4000	Sales Revenue	0.00	136200.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1314	208	2100	Tax Payable (PPN)	0.00	14982.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1315	208	4100	Service Income	0.00	6810.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1316	208	5000	Cost of Goods Sold	118132.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1317	208	1300	Inventory	0.00	118132.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1318	209	1100	Cash	71178.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1319	209	1120	E	106766.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1320	209	4000	Sales Revenue	0.00	153400.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1321	209	2100	Tax Payable (PPN)	0.00	16874.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1322	209	4100	Service Income	0.00	7670.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1323	209	5000	Cost of Goods Sold	133120.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1324	209	1300	Inventory	0.00	133120.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1325	210	1100	Cash	95584.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1326	210	4000	Sales Revenue	0.00	82400.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1327	210	2100	Tax Payable (PPN)	0.00	9064.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1328	210	4100	Service Income	0.00	4120.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1329	210	5000	Cost of Goods Sold	71460.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1330	210	1300	Inventory	0.00	71460.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1331	211	1100	Cash	77117.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1332	211	1120	E	115675.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1333	211	4000	Sales Revenue	0.00	166200.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1334	211	2100	Tax Payable (PPN)	0.00	18282.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1335	211	4100	Service Income	0.00	8310.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1336	211	5000	Cost of Goods Sold	144205.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1337	211	1300	Inventory	0.00	144205.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1338	212	1100	Cash	28118.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1339	212	1120	E	42178.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1340	212	4000	Sales Revenue	0.00	60600.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1341	212	2100	Tax Payable (PPN)	0.00	6666.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1342	212	4100	Service Income	0.00	3030.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1343	212	5000	Cost of Goods Sold	52665.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1344	212	1300	Inventory	0.00	52665.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1345	213	1120	E	134792.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1346	213	4000	Sales Revenue	0.00	116200.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1347	213	2100	Tax Payable (PPN)	0.00	12782.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1348	213	4100	Service Income	0.00	5810.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1349	213	5000	Cost of Goods Sold	100939.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1350	213	1300	Inventory	0.00	100939.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1351	214	1120	E	345332.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1352	214	4000	Sales Revenue	0.00	297700.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1353	214	2100	Tax Payable (PPN)	0.00	32747.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1354	214	4100	Service Income	0.00	14885.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1355	214	5000	Cost of Goods Sold	258388.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1356	214	1300	Inventory	0.00	258388.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1357	215	1100	Cash	8352.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1358	215	4000	Sales Revenue	0.00	7200.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1359	215	2100	Tax Payable (PPN)	0.00	792.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1360	215	4100	Service Income	0.00	360.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1361	215	5000	Cost of Goods Sold	6193.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1362	215	1300	Inventory	0.00	6193.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1363	216	1120	E	183396.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1364	216	4000	Sales Revenue	0.00	158100.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1365	216	2100	Tax Payable (PPN)	0.00	17391.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1366	216	4100	Service Income	0.00	7905.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1367	216	5000	Cost of Goods Sold	137217.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1368	216	1300	Inventory	0.00	137217.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1369	217	1120	E	53592.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1370	217	4000	Sales Revenue	0.00	46200.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1371	217	2100	Tax Payable (PPN)	0.00	5082.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1372	217	4100	Service Income	0.00	2310.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1373	217	5000	Cost of Goods Sold	40117.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1374	217	1300	Inventory	0.00	40117.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1375	218	1100	Cash	27933.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1376	218	1120	E	41899.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1377	218	4000	Sales Revenue	0.00	60200.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1378	218	2100	Tax Payable (PPN)	0.00	6622.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1379	218	4100	Service Income	0.00	3010.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1380	218	5000	Cost of Goods Sold	52114.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1381	218	1300	Inventory	0.00	52114.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1382	219	1100	Cash	128876.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1383	219	4000	Sales Revenue	0.00	111100.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1384	219	2100	Tax Payable (PPN)	0.00	12221.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1385	219	4100	Service Income	0.00	5555.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1386	219	5000	Cost of Goods Sold	96420.00	0.00	2026-02-16 20:41:38	2026-02-16 20:41:38
1387	219	1300	Inventory	0.00	96420.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1388	220	1100	Cash	448224.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1389	220	4000	Sales Revenue	0.00	386400.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1390	220	2100	Tax Payable (PPN)	0.00	42504.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1391	220	4100	Service Income	0.00	19320.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1392	220	5000	Cost of Goods Sold	335602.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1393	220	1300	Inventory	0.00	335602.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1394	221	1100	Cash	104632.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1395	221	4000	Sales Revenue	0.00	90200.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1396	221	2100	Tax Payable (PPN)	0.00	9922.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1397	221	4100	Service Income	0.00	4510.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1398	221	5000	Cost of Goods Sold	78368.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1399	221	1300	Inventory	0.00	78368.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1400	222	1100	Cash	31181.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1401	222	1120	E	46771.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1402	222	4000	Sales Revenue	0.00	67200.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1403	222	2100	Tax Payable (PPN)	0.00	7392.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1404	222	4100	Service Income	0.00	3360.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1405	222	5000	Cost of Goods Sold	58200.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1406	222	1300	Inventory	0.00	58200.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1407	223	1120	E	179568.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1408	223	4000	Sales Revenue	0.00	154800.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1409	223	2100	Tax Payable (PPN)	0.00	17028.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1410	223	4100	Service Income	0.00	7740.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1411	223	5000	Cost of Goods Sold	134394.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1412	223	1300	Inventory	0.00	134394.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1413	224	1120	E	271788.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1414	224	4000	Sales Revenue	0.00	234300.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1415	224	2100	Tax Payable (PPN)	0.00	25773.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1416	224	4100	Service Income	0.00	11715.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1417	224	5000	Cost of Goods Sold	203406.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1418	224	1300	Inventory	0.00	203406.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1419	225	1100	Cash	51156.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1420	225	4000	Sales Revenue	0.00	44100.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1421	225	2100	Tax Payable (PPN)	0.00	4851.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1422	225	4100	Service Income	0.00	2205.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1423	225	5000	Cost of Goods Sold	38145.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1424	225	1300	Inventory	0.00	38145.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1425	226	1100	Cash	23432.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1426	226	4000	Sales Revenue	0.00	20200.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1427	226	2100	Tax Payable (PPN)	0.00	2222.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1428	226	4100	Service Income	0.00	1010.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1429	226	5000	Cost of Goods Sold	17555.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1430	226	1300	Inventory	0.00	17555.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1431	227	1120	E	60204.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1432	227	4000	Sales Revenue	0.00	51900.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1433	227	2100	Tax Payable (PPN)	0.00	5709.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1434	227	4100	Service Income	0.00	2595.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1435	227	5000	Cost of Goods Sold	44833.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1436	227	1300	Inventory	0.00	44833.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1437	228	1100	Cash	83613.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1438	228	1120	E	125419.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1439	228	4000	Sales Revenue	0.00	180200.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1440	228	2100	Tax Payable (PPN)	0.00	19822.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1441	228	4100	Service Income	0.00	9010.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1442	228	5000	Cost of Goods Sold	156452.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1443	228	1300	Inventory	0.00	156452.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1444	229	1100	Cash	65076.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1445	229	4000	Sales Revenue	0.00	56100.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1446	229	2100	Tax Payable (PPN)	0.00	6171.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1447	229	4100	Service Income	0.00	2805.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1448	229	5000	Cost of Goods Sold	48558.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1449	229	1300	Inventory	0.00	48558.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1450	230	1100	Cash	109388.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1451	230	4000	Sales Revenue	0.00	94300.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1452	230	2100	Tax Payable (PPN)	0.00	10373.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1453	230	4100	Service Income	0.00	4715.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1454	230	5000	Cost of Goods Sold	81820.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1455	230	1300	Inventory	0.00	81820.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1456	231	1100	Cash	166228.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1457	231	4000	Sales Revenue	0.00	143300.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1458	231	2100	Tax Payable (PPN)	0.00	15763.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1459	231	4100	Service Income	0.00	7165.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1460	231	5000	Cost of Goods Sold	124483.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1461	231	1300	Inventory	0.00	124483.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1462	232	1120	E	283852.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1463	232	4000	Sales Revenue	0.00	244700.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1464	232	2100	Tax Payable (PPN)	0.00	26917.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1465	232	4100	Service Income	0.00	12235.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1466	232	5000	Cost of Goods Sold	212517.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1467	232	1300	Inventory	0.00	212517.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1468	233	1100	Cash	340924.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1469	233	4000	Sales Revenue	0.00	293900.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1470	233	2100	Tax Payable (PPN)	0.00	32329.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1471	233	4100	Service Income	0.00	14695.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1472	233	5000	Cost of Goods Sold	254972.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1473	233	1300	Inventory	0.00	254972.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1474	234	1100	Cash	99528.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1475	234	4000	Sales Revenue	0.00	85800.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1476	234	2100	Tax Payable (PPN)	0.00	9438.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1477	234	4100	Service Income	0.00	4290.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1478	234	5000	Cost of Goods Sold	74343.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1479	234	1300	Inventory	0.00	74343.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1480	235	1100	Cash	129920.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1481	235	4000	Sales Revenue	0.00	112000.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1482	235	2100	Tax Payable (PPN)	0.00	12320.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1483	235	4100	Service Income	0.00	5600.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1484	235	5000	Cost of Goods Sold	97228.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1485	235	1300	Inventory	0.00	97228.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1486	236	1100	Cash	134374.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1487	236	1120	E	201562.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1488	236	4000	Sales Revenue	0.00	289600.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1489	236	2100	Tax Payable (PPN)	0.00	31856.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1490	236	4100	Service Income	0.00	14480.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1491	236	5000	Cost of Goods Sold	251465.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1492	236	1300	Inventory	0.00	251465.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1493	237	1120	E	4176.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1494	237	4000	Sales Revenue	0.00	3600.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1495	237	2100	Tax Payable (PPN)	0.00	396.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1496	237	4100	Service Income	0.00	180.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1497	237	5000	Cost of Goods Sold	3033.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1498	237	1300	Inventory	0.00	3033.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1499	238	1120	E	158688.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1500	238	4000	Sales Revenue	0.00	136800.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1501	238	2100	Tax Payable (PPN)	0.00	15048.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1502	238	4100	Service Income	0.00	6840.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1503	238	5000	Cost of Goods Sold	118791.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1504	238	1300	Inventory	0.00	118791.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1505	239	1100	Cash	219008.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1506	239	4000	Sales Revenue	0.00	188800.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1507	239	2100	Tax Payable (PPN)	0.00	20768.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1508	239	4100	Service Income	0.00	9440.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1509	239	5000	Cost of Goods Sold	163975.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1510	239	1300	Inventory	0.00	163975.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1511	240	1100	Cash	314012.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1512	240	4000	Sales Revenue	0.00	270700.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1513	240	2100	Tax Payable (PPN)	0.00	29777.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1514	240	4100	Service Income	0.00	13535.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1515	240	5000	Cost of Goods Sold	235006.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1516	240	1300	Inventory	0.00	235006.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1517	241	1100	Cash	23200.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1518	241	1120	E	34800.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1519	241	4000	Sales Revenue	0.00	50000.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1520	241	2100	Tax Payable (PPN)	0.00	5500.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1521	241	4100	Service Income	0.00	2500.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1522	241	5000	Cost of Goods Sold	43455.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1523	241	1300	Inventory	0.00	43455.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1524	242	1100	Cash	99644.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1525	242	4000	Sales Revenue	0.00	85900.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1526	242	2100	Tax Payable (PPN)	0.00	9449.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1527	242	4100	Service Income	0.00	4295.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1528	242	5000	Cost of Goods Sold	74318.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1529	242	1300	Inventory	0.00	74318.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1530	243	1120	E	140940.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1531	243	4000	Sales Revenue	0.00	121500.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1532	243	2100	Tax Payable (PPN)	0.00	13365.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1533	243	4100	Service Income	0.00	6075.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1534	243	5000	Cost of Goods Sold	105411.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1535	243	1300	Inventory	0.00	105411.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1536	244	1100	Cash	231304.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1537	244	4000	Sales Revenue	0.00	199400.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1538	244	2100	Tax Payable (PPN)	0.00	21934.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1539	244	4100	Service Income	0.00	9970.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1540	244	5000	Cost of Goods Sold	172840.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1541	244	1300	Inventory	0.00	172840.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1542	245	1100	Cash	106070.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1543	245	1120	E	159106.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1544	245	4000	Sales Revenue	0.00	228600.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1545	245	2100	Tax Payable (PPN)	0.00	25146.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1546	245	4100	Service Income	0.00	11430.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1547	245	5000	Cost of Goods Sold	198445.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1548	245	1300	Inventory	0.00	198445.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1549	246	1100	Cash	75400.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1550	246	4000	Sales Revenue	0.00	65000.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1551	246	2100	Tax Payable (PPN)	0.00	7150.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1552	246	4100	Service Income	0.00	3250.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1553	246	5000	Cost of Goods Sold	56316.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1554	246	1300	Inventory	0.00	56316.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1555	247	1100	Cash	35171.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1556	247	1120	E	52757.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1557	247	4000	Sales Revenue	0.00	75800.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1558	247	2100	Tax Payable (PPN)	0.00	8338.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1559	247	4100	Service Income	0.00	3790.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1560	247	5000	Cost of Goods Sold	65641.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1561	247	1300	Inventory	0.00	65641.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1562	248	1120	E	175044.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1563	248	4000	Sales Revenue	0.00	150900.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1564	248	2100	Tax Payable (PPN)	0.00	16599.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1565	248	4100	Service Income	0.00	7545.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1566	248	5000	Cost of Goods Sold	131046.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1567	248	1300	Inventory	0.00	131046.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1568	249	1100	Cash	61248.00	0.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1569	249	4000	Sales Revenue	0.00	52800.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1570	249	2100	Tax Payable (PPN)	0.00	5808.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1571	249	4100	Service Income	0.00	2640.00	2026-02-16 20:41:39	2026-02-16 20:41:39
1572	249	5000	Cost of Goods Sold	45888.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1573	249	1300	Inventory	0.00	45888.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1574	250	1100	Cash	83010.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1575	250	1120	E	124514.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1576	250	4000	Sales Revenue	0.00	178900.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1577	250	2100	Tax Payable (PPN)	0.00	19679.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1578	250	4100	Service Income	0.00	8945.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1579	250	5000	Cost of Goods Sold	155364.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1580	250	1300	Inventory	0.00	155364.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1581	251	1100	Cash	76003.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1582	251	1120	E	114005.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1583	251	4000	Sales Revenue	0.00	163800.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1584	251	2100	Tax Payable (PPN)	0.00	18018.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1585	251	4100	Service Income	0.00	8190.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1586	251	5000	Cost of Goods Sold	142045.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1587	251	1300	Inventory	0.00	142045.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1588	252	1100	Cash	53592.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1589	252	4000	Sales Revenue	0.00	46200.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1590	252	2100	Tax Payable (PPN)	0.00	5082.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1591	252	4100	Service Income	0.00	2310.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1592	252	5000	Cost of Goods Sold	40083.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1593	252	1300	Inventory	0.00	40083.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1594	253	1100	Cash	231420.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1595	253	4000	Sales Revenue	0.00	199500.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1596	253	2100	Tax Payable (PPN)	0.00	21945.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1597	253	4100	Service Income	0.00	9975.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1598	253	5000	Cost of Goods Sold	173054.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1599	253	1300	Inventory	0.00	173054.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1600	254	1100	Cash	171587.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1601	254	1120	E	257381.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1602	254	4000	Sales Revenue	0.00	369800.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1603	254	2100	Tax Payable (PPN)	0.00	40678.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1604	254	4100	Service Income	0.00	18490.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1605	254	5000	Cost of Goods Sold	321095.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1606	254	1300	Inventory	0.00	321095.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1607	255	1120	E	38628.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1608	255	4000	Sales Revenue	0.00	33300.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1609	255	2100	Tax Payable (PPN)	0.00	3663.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1610	255	4100	Service Income	0.00	1665.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1611	255	5000	Cost of Goods Sold	28858.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1612	255	1300	Inventory	0.00	28858.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1613	256	1100	Cash	63290.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1614	256	1120	E	94934.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1615	256	4000	Sales Revenue	0.00	136400.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1616	256	2100	Tax Payable (PPN)	0.00	15004.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1617	256	4100	Service Income	0.00	6820.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1618	256	5000	Cost of Goods Sold	118419.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1619	256	1300	Inventory	0.00	118419.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1620	257	1120	E	90944.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1621	257	4000	Sales Revenue	0.00	78400.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1622	257	2100	Tax Payable (PPN)	0.00	8624.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1623	257	4100	Service Income	0.00	3920.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1624	257	5000	Cost of Goods Sold	68024.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1625	257	1300	Inventory	0.00	68024.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1626	258	1100	Cash	139710.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1627	258	1120	E	209566.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1628	258	4000	Sales Revenue	0.00	301100.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1629	258	2100	Tax Payable (PPN)	0.00	33121.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1630	258	4100	Service Income	0.00	15055.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1631	258	5000	Cost of Goods Sold	261559.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1632	258	1300	Inventory	0.00	261559.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1633	259	1100	Cash	10254.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1634	259	1120	E	15382.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1635	259	4000	Sales Revenue	0.00	22100.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1636	259	2100	Tax Payable (PPN)	0.00	2431.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1637	259	4100	Service Income	0.00	1105.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1638	259	5000	Cost of Goods Sold	19130.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1639	259	1300	Inventory	0.00	19130.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1640	260	1100	Cash	135766.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1641	260	1120	E	203650.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1642	260	4000	Sales Revenue	0.00	292600.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1643	260	2100	Tax Payable (PPN)	0.00	32186.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1644	260	4100	Service Income	0.00	14630.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1645	260	5000	Cost of Goods Sold	253939.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1646	260	1300	Inventory	0.00	253939.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1647	261	1100	Cash	145696.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1648	261	4000	Sales Revenue	0.00	125600.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1649	261	2100	Tax Payable (PPN)	0.00	13816.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1650	261	4100	Service Income	0.00	6280.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1651	261	5000	Cost of Goods Sold	108964.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1652	261	1300	Inventory	0.00	108964.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1653	262	1100	Cash	178060.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1654	262	4000	Sales Revenue	0.00	153500.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1655	262	2100	Tax Payable (PPN)	0.00	16885.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1656	262	4100	Service Income	0.00	7675.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1657	262	5000	Cost of Goods Sold	133290.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1658	262	1300	Inventory	0.00	133290.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1659	263	1120	E	174928.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1660	263	4000	Sales Revenue	0.00	150800.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1661	263	2100	Tax Payable (PPN)	0.00	16588.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1662	263	4100	Service Income	0.00	7540.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1663	263	5000	Cost of Goods Sold	130899.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1664	263	1300	Inventory	0.00	130899.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1665	264	1100	Cash	21994.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1666	264	1120	E	32990.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1667	264	4000	Sales Revenue	0.00	47400.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1668	264	2100	Tax Payable (PPN)	0.00	5214.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1669	264	4100	Service Income	0.00	2370.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1670	264	5000	Cost of Goods Sold	41128.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1671	264	1300	Inventory	0.00	41128.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1672	265	1120	E	383612.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1673	265	4000	Sales Revenue	0.00	330700.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1674	265	2100	Tax Payable (PPN)	0.00	36377.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1675	265	4100	Service Income	0.00	16535.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1676	265	5000	Cost of Goods Sold	287182.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1677	265	1300	Inventory	0.00	287182.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1678	266	1100	Cash	229680.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1679	266	4000	Sales Revenue	0.00	198000.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1680	266	2100	Tax Payable (PPN)	0.00	21780.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1681	266	4100	Service Income	0.00	9900.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1682	266	5000	Cost of Goods Sold	172010.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1683	266	1300	Inventory	0.00	172010.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1684	267	1100	Cash	196272.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1685	267	4000	Sales Revenue	0.00	169200.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1686	267	2100	Tax Payable (PPN)	0.00	18612.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1687	267	4100	Service Income	0.00	8460.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1688	267	5000	Cost of Goods Sold	146874.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1689	267	1300	Inventory	0.00	146874.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1690	268	1120	E	97208.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1691	268	4000	Sales Revenue	0.00	83800.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1692	268	2100	Tax Payable (PPN)	0.00	9218.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1693	268	4100	Service Income	0.00	4190.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1694	268	5000	Cost of Goods Sold	72724.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1695	268	1300	Inventory	0.00	72724.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1696	269	1100	Cash	29139.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1697	269	1120	E	43709.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1698	269	4000	Sales Revenue	0.00	62800.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1699	269	2100	Tax Payable (PPN)	0.00	6908.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1700	269	4100	Service Income	0.00	3140.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1701	269	5000	Cost of Goods Sold	54485.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1702	269	1300	Inventory	0.00	54485.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1703	270	1100	Cash	160312.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1704	270	4000	Sales Revenue	0.00	138200.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1705	270	2100	Tax Payable (PPN)	0.00	15202.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1706	270	4100	Service Income	0.00	6910.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1707	270	5000	Cost of Goods Sold	119833.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1708	270	1300	Inventory	0.00	119833.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1709	271	1120	E	305892.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1710	271	4000	Sales Revenue	0.00	263700.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1711	271	2100	Tax Payable (PPN)	0.00	29007.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1712	271	4100	Service Income	0.00	13185.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1713	271	5000	Cost of Goods Sold	228922.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1714	271	1300	Inventory	0.00	228922.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1715	272	1120	E	46980.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1716	272	4000	Sales Revenue	0.00	40500.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1717	272	2100	Tax Payable (PPN)	0.00	4455.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1718	272	4100	Service Income	0.00	2025.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1719	272	5000	Cost of Goods Sold	35137.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1720	272	1300	Inventory	0.00	35137.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1721	273	1100	Cash	130152.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1722	273	1120	E	195228.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1723	273	4000	Sales Revenue	0.00	280500.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1724	273	2100	Tax Payable (PPN)	0.00	30855.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1725	273	4100	Service Income	0.00	14025.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1726	273	5000	Cost of Goods Sold	243747.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1727	273	1300	Inventory	0.00	243747.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1728	274	1100	Cash	197316.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1729	274	4000	Sales Revenue	0.00	170100.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1730	274	2100	Tax Payable (PPN)	0.00	18711.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1731	274	4100	Service Income	0.00	8505.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1732	274	5000	Cost of Goods Sold	147789.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1733	274	1300	Inventory	0.00	147789.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1734	275	1100	Cash	37166.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1735	275	1120	E	55750.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1736	275	4000	Sales Revenue	0.00	80100.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1737	275	2100	Tax Payable (PPN)	0.00	8811.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1738	275	4100	Service Income	0.00	4005.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1739	275	5000	Cost of Goods Sold	69363.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1740	275	1300	Inventory	0.00	69363.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1741	276	1120	E	203464.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1742	276	4000	Sales Revenue	0.00	175400.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1743	276	2100	Tax Payable (PPN)	0.00	19294.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1744	276	4100	Service Income	0.00	8770.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1745	276	5000	Cost of Goods Sold	152374.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1746	276	1300	Inventory	0.00	152374.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1747	277	1120	E	467248.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1748	277	4000	Sales Revenue	0.00	402800.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1749	277	2100	Tax Payable (PPN)	0.00	44308.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1750	277	4100	Service Income	0.00	20140.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1751	277	5000	Cost of Goods Sold	349895.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1752	277	1300	Inventory	0.00	349895.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1753	278	1100	Cash	97440.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1754	278	4000	Sales Revenue	0.00	84000.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1755	278	2100	Tax Payable (PPN)	0.00	9240.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1756	278	4100	Service Income	0.00	4200.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1757	278	5000	Cost of Goods Sold	72984.00	0.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1758	278	1300	Inventory	0.00	72984.00	2026-02-16 20:41:40	2026-02-16 20:41:40
1759	279	1100	Cash	53499.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1760	279	1120	E	80249.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1761	279	4000	Sales Revenue	0.00	115300.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1762	279	2100	Tax Payable (PPN)	0.00	12683.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1763	279	4100	Service Income	0.00	5765.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1764	279	5000	Cost of Goods Sold	100021.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1765	279	1300	Inventory	0.00	100021.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1766	280	1120	E	334312.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1767	280	4000	Sales Revenue	0.00	288200.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1768	280	2100	Tax Payable (PPN)	0.00	31702.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1769	280	4100	Service Income	0.00	14410.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1770	280	5000	Cost of Goods Sold	250264.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1771	280	1300	Inventory	0.00	250264.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1772	281	1120	E	161588.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1773	281	4000	Sales Revenue	0.00	139300.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1774	281	2100	Tax Payable (PPN)	0.00	15323.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1775	281	4100	Service Income	0.00	6965.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1776	281	5000	Cost of Goods Sold	121005.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1777	281	1300	Inventory	0.00	121005.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1778	282	1100	Cash	20462.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1779	282	1120	E	30694.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1780	282	4000	Sales Revenue	0.00	44100.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1781	282	2100	Tax Payable (PPN)	0.00	4851.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1782	282	4100	Service Income	0.00	2205.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1783	282	5000	Cost of Goods Sold	38145.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1784	282	1300	Inventory	0.00	38145.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1785	283	1100	Cash	352176.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1786	283	4000	Sales Revenue	0.00	303600.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1787	283	2100	Tax Payable (PPN)	0.00	33396.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1788	283	4100	Service Income	0.00	15180.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1789	283	5000	Cost of Goods Sold	263664.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1790	283	1300	Inventory	0.00	263664.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1791	284	1100	Cash	191632.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1792	284	4000	Sales Revenue	0.00	165200.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1793	284	2100	Tax Payable (PPN)	0.00	18172.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1794	284	4100	Service Income	0.00	8260.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1795	284	5000	Cost of Goods Sold	143461.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1796	284	1300	Inventory	0.00	143461.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1797	285	1120	E	98136.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1798	285	4000	Sales Revenue	0.00	84600.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1799	285	2100	Tax Payable (PPN)	0.00	9306.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1800	285	4100	Service Income	0.00	4230.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1801	285	5000	Cost of Goods Sold	73299.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1802	285	1300	Inventory	0.00	73299.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1803	286	1100	Cash	280604.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1804	286	4000	Sales Revenue	0.00	241900.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1805	286	2100	Tax Payable (PPN)	0.00	26609.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1806	286	4100	Service Income	0.00	12095.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1807	286	5000	Cost of Goods Sold	210166.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1808	286	1300	Inventory	0.00	210166.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1809	287	1120	E	43268.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1810	287	4000	Sales Revenue	0.00	37300.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1811	287	2100	Tax Payable (PPN)	0.00	4103.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1812	287	4100	Service Income	0.00	1865.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1813	287	5000	Cost of Goods Sold	32382.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1814	287	1300	Inventory	0.00	32382.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1815	288	1100	Cash	88346.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1816	288	1120	E	132518.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1817	288	4000	Sales Revenue	0.00	190400.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1818	288	2100	Tax Payable (PPN)	0.00	20944.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1819	288	4100	Service Income	0.00	9520.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1820	288	5000	Cost of Goods Sold	165292.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1821	288	1300	Inventory	0.00	165292.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1822	289	1120	E	316448.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1823	289	4000	Sales Revenue	0.00	272800.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1824	289	2100	Tax Payable (PPN)	0.00	30008.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1825	289	4100	Service Income	0.00	13640.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1826	289	5000	Cost of Goods Sold	236963.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1827	289	1300	Inventory	0.00	236963.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1828	290	1100	Cash	169035.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1829	290	1120	E	253553.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1830	290	4000	Sales Revenue	0.00	364300.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1831	290	2100	Tax Payable (PPN)	0.00	40073.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1832	290	4100	Service Income	0.00	18215.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1833	290	5000	Cost of Goods Sold	316577.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1834	290	1300	Inventory	0.00	316577.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1835	291	1100	Cash	53778.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1836	291	1120	E	80666.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1837	291	4000	Sales Revenue	0.00	115900.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1838	291	2100	Tax Payable (PPN)	0.00	12749.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1839	291	4100	Service Income	0.00	5795.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1840	291	5000	Cost of Goods Sold	100329.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1841	291	1300	Inventory	0.00	100329.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1842	292	1100	Cash	85747.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1843	292	1120	E	128621.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1844	292	4000	Sales Revenue	0.00	184800.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1845	292	2100	Tax Payable (PPN)	0.00	20328.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1846	292	4100	Service Income	0.00	9240.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1847	292	5000	Cost of Goods Sold	160385.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1848	292	1300	Inventory	0.00	160385.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1849	293	1120	E	189080.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1850	293	4000	Sales Revenue	0.00	163000.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1851	293	2100	Tax Payable (PPN)	0.00	17930.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1852	293	4100	Service Income	0.00	8150.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1853	293	5000	Cost of Goods Sold	141475.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1854	293	1300	Inventory	0.00	141475.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1855	294	1100	Cash	128064.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1856	294	4000	Sales Revenue	0.00	110400.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1857	294	2100	Tax Payable (PPN)	0.00	12144.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1858	294	4100	Service Income	0.00	5520.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1859	294	5000	Cost of Goods Sold	95704.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1860	294	1300	Inventory	0.00	95704.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1861	295	1120	E	305312.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1862	295	4000	Sales Revenue	0.00	263200.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1863	295	2100	Tax Payable (PPN)	0.00	28952.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1864	295	4100	Service Income	0.00	13160.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1865	295	5000	Cost of Goods Sold	228492.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1866	295	1300	Inventory	0.00	228492.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1867	296	1120	E	74472.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1868	296	4000	Sales Revenue	0.00	64200.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1869	296	2100	Tax Payable (PPN)	0.00	7062.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1870	296	4100	Service Income	0.00	3210.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1871	296	5000	Cost of Goods Sold	55677.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1872	296	1300	Inventory	0.00	55677.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1873	297	1120	E	100920.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1874	297	4000	Sales Revenue	0.00	87000.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1875	297	2100	Tax Payable (PPN)	0.00	9570.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1876	297	4100	Service Income	0.00	4350.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1877	297	5000	Cost of Goods Sold	75514.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1878	297	1300	Inventory	0.00	75514.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1879	298	1120	E	256824.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1880	298	4000	Sales Revenue	0.00	221400.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1881	298	2100	Tax Payable (PPN)	0.00	24354.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1882	298	4100	Service Income	0.00	11070.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1883	298	5000	Cost of Goods Sold	192196.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1884	298	1300	Inventory	0.00	192196.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1885	299	1100	Cash	41760.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1886	299	1120	E	62640.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1887	299	4000	Sales Revenue	0.00	90000.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1888	299	2100	Tax Payable (PPN)	0.00	9900.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1889	299	4100	Service Income	0.00	4500.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1890	299	5000	Cost of Goods Sold	78178.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1891	299	1300	Inventory	0.00	78178.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1892	300	1100	Cash	50530.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1893	300	1120	E	75794.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1894	300	4000	Sales Revenue	0.00	108900.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1895	300	2100	Tax Payable (PPN)	0.00	11979.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1896	300	4100	Service Income	0.00	5445.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1897	300	5000	Cost of Goods Sold	94236.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1898	300	1300	Inventory	0.00	94236.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1899	301	1120	E	93728.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1900	301	4000	Sales Revenue	0.00	80800.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1901	301	2100	Tax Payable (PPN)	0.00	8888.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1902	301	4100	Service Income	0.00	4040.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1903	301	5000	Cost of Goods Sold	70118.00	0.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1904	301	1300	Inventory	0.00	70118.00	2026-02-16 20:41:41	2026-02-16 20:41:41
1905	302	1100	Cash	1387500.00	0.00	2026-02-17 04:46:32	2026-02-17 04:46:32
1906	302	4000	Sales Revenue	0.00	1250000.00	2026-02-17 04:46:32	2026-02-17 04:46:32
1907	302	2100	Tax Payable (PPN)	0.00	137500.00	2026-02-17 04:46:32	2026-02-17 04:46:32
1908	302	5000	Cost of Goods Sold	900000.00	0.00	2026-02-17 04:46:32	2026-02-17 04:46:32
1909	302	1300	Inventory	0.00	900000.00	2026-02-17 04:46:32	2026-02-17 04:46:32
1910	303	1100	Cash	843600.00	0.00	2026-02-17 04:47:03	2026-02-17 04:47:03
1911	303	4000	Sales Revenue	0.00	760000.00	2026-02-17 04:47:03	2026-02-17 04:47:03
1912	303	2100	Tax Payable (PPN)	0.00	83600.00	2026-02-17 04:47:03	2026-02-17 04:47:03
1913	303	5000	Cost of Goods Sold	640000.00	0.00	2026-02-17 04:47:03	2026-02-17 04:47:03
1914	303	1300	Inventory	0.00	640000.00	2026-02-17 04:47:03	2026-02-17 04:47:03
1915	304	1100	Cash	126540.00	0.00	2026-02-17 04:48:58	2026-02-17 04:48:58
1916	304	4000	Sales Revenue	0.00	114000.00	2026-02-17 04:48:58	2026-02-17 04:48:58
1917	304	2100	Tax Payable (PPN)	0.00	12540.00	2026-02-17 04:48:58	2026-02-17 04:48:58
1918	304	5000	Cost of Goods Sold	96000.00	0.00	2026-02-17 04:48:58	2026-02-17 04:48:58
1919	304	1300	Inventory	0.00	96000.00	2026-02-17 04:48:58	2026-02-17 04:48:58
1920	305	1100	Cash	498390.00	0.00	2026-02-17 05:04:13	2026-02-17 05:04:13
1921	305	4000	Sales Revenue	0.00	449000.00	2026-02-17 05:04:13	2026-02-17 05:04:13
1922	305	2100	Tax Payable (PPN)	0.00	49390.00	2026-02-17 05:04:13	2026-02-17 05:04:13
1923	305	5000	Cost of Goods Sold	338100.00	0.00	2026-02-17 05:04:13	2026-02-17 05:04:13
1924	305	1300	Inventory	0.00	338100.00	2026-02-17 05:04:13	2026-02-17 05:04:13
1925	306	1100	Cash	175935.00	0.00	2026-02-17 05:45:52	2026-02-17 05:45:52
1926	306	4000	Sales Revenue	0.00	158500.00	2026-02-17 05:45:52	2026-02-17 05:45:52
1927	306	2100	Tax Payable (PPN)	0.00	17435.00	2026-02-17 05:45:52	2026-02-17 05:45:52
1928	306	5000	Cost of Goods Sold	129800.00	0.00	2026-02-17 05:45:52	2026-02-17 05:45:52
1929	306	1300	Inventory	0.00	129800.00	2026-02-17 05:45:52	2026-02-17 05:45:52
1930	307	1100	Cash	38850.00	0.00	2026-02-17 05:52:46	2026-02-17 05:52:46
1931	307	4000	Sales Revenue	0.00	35000.00	2026-02-17 05:52:46	2026-02-17 05:52:46
1932	307	2100	Tax Payable (PPN)	0.00	3850.00	2026-02-17 05:52:46	2026-02-17 05:52:46
1933	307	5000	Cost of Goods Sold	28000.00	0.00	2026-02-17 05:52:46	2026-02-17 05:52:46
1934	307	1300	Inventory	0.00	28000.00	2026-02-17 05:52:46	2026-02-17 05:52:46
1935	308	1100	Cash	219780.00	0.00	2026-02-17 05:54:09	2026-02-17 05:54:09
1936	308	4000	Sales Revenue	0.00	198000.00	2026-02-17 05:54:09	2026-02-17 05:54:09
1937	308	2100	Tax Payable (PPN)	0.00	21780.00	2026-02-17 05:54:09	2026-02-17 05:54:09
1938	308	5000	Cost of Goods Sold	158400.00	0.00	2026-02-17 05:54:09	2026-02-17 05:54:09
1939	308	1300	Inventory	0.00	158400.00	2026-02-17 05:54:09	2026-02-17 05:54:09
\.


--
-- Data for Name: loyalty_logs; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.loyalty_logs (id, customer_id, transaction_id, points, type, description, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.migrations (id, migration, batch) FROM stdin;
1	0001_01_01_000000_create_users_table	1
2	0001_01_01_000001_create_cache_table	1
3	0001_01_01_000001_hardening	1
4	0001_01_01_000002_create_jobs_table	1
5	2026_02_16_185044_create_stock_movements_table	1
6	2026_02_16_185046_create_journal_entries_table	1
7	2026_02_16_185048_create_audit_logs_table	1
8	2026_02_16_185302_change_reference_id_to_string_in_hardening_tables	1
9	2026_02_16_185444_change_reference_id_to_string_in_hardening_tables	1
10	2026_02_16_185624_add_analytics_fields_to_products_table	1
11	2026_02_16_185914_create_cash_drawers_table	1
12	2026_02_16_185916_create_installments_table	1
13	2026_02_16_185918_create_budgets_table	1
14	2026_02_16_190233_create_stock_transfers_table	1
15	2026_02_16_190235_create_price_tiers_table	1
16	2026_02_16_190552_create_customers_table	1
17	2026_02_16_190554_create_loyalty_logs_table	1
18	2026_02_16_190557_create_whatsapp_logs_table	1
19	2026_02_16_190559_add_customer_and_points_to_transactions_table	1
20	2026_02_16_190924_create_fraud_alerts_table	1
21	2026_02_16_191156_create_product_batches_table	1
22	2026_02_16_191158_create_inventory_valuations_table	1
23	2026_02_16_193752_create_business_health_scores_table	1
24	2026_02_16_193818_create_profit_risk_scores_table	1
25	2026_02_16_194440_create_suppliers_table	2
26	2026_02_16_194447_create_purchase_orders_table	2
27	2026_02_16_194448_create_purchase_order_items_table	2
28	2026_02_16_194507_add_supplier_id_to_products_table	2
29	2026_02_16_194836_create_cashflow_projections_table	3
30	2026_02_16_195046_create_employee_risk_scores_table	4
31	2026_02_16_195426_create_a_i_insights_table	5
32	2026_02_16_200130_create_competitor_prices_table	6
33	2026_02_16_200440_create_system_alerts_table	7
34	2026_02_16_203439_add_digital_payment_fields_to_transactions_table	8
35	2026_02_16_203511_create_store_wallets_table	8
36	2026_02_16_203511_create_transaction_payments_table	8
37	2026_02_16_204559_create_promotions_table	9
38	2026_02_16_204601_create_stock_opnames_table	9
39	2026_02_17_013213_create_accounts_table	10
40	2026_02_17_014100_add_role_to_users_table	11
41	2026_02_17_112000_refactor_stock_movements_table	12
42	2026_02_17_112001_create_return_tables	13
43	2026_02_17_112600_add_soft_deletes_to_users_table	14
45	2026_02_17_052042_add_cost_price_to_transaction_items_table	15
46	2026_02_17_115100_create_product_batches_table	15
47	2026_02_17_055613_add_image_to_products_table	16
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.password_reset_tokens (email, token, created_at) FROM stdin;
\.


--
-- Data for Name: price_tiers; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.price_tiers (id, product_id, store_id, tier_name, price, min_quantity, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: product_batches; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.product_batches (id, store_id, product_id, batch_number, expiry_date, cost_price, initial_quantity, current_quantity, received_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.products (id, store_id, category_id, name, barcode, price, cost_price, stock, image, created_at, updated_at, lead_time_days, safety_stock, last_sold_at, supplier_id) FROM stdin;
1	2	1	Indomie Fried	GJn684tKKS	3500.00	2800.00	100	\N	2026-02-16 19:43:29	2026-02-16 19:43:29	7	10	2026-02-16 19:43:29	\N
2	2	1	Mineral Water	zSt9q0J9dL	5000.00	2000.00	50	\N	2026-02-16 19:43:30	2026-02-16 19:43:30	7	10	2026-02-16 19:43:30	\N
3	2	1	Cooking Oil 1L	s7oK4URaJf	18000.00	17500.00	20	\N	2026-02-16 19:43:30	2026-02-16 19:43:30	7	10	2026-02-16 19:43:30	\N
4	2	1	Slow Moving Item	Gj20zXrpPa	50000.00	45000.00	5	\N	2026-02-16 19:43:30	2026-02-16 19:43:30	7	10	2025-11-08 19:43:30	\N
5	2	2	Indomie Fried	kEcXGEv0ZS	3500.00	2800.00	100	\N	2026-02-16 19:43:40	2026-02-16 19:43:40	7	10	2026-02-16 19:43:40	\N
6	2	2	Mineral Water	UiZfIaxDYT	5000.00	2000.00	50	\N	2026-02-16 19:43:40	2026-02-16 19:43:40	7	10	2026-02-16 19:43:40	\N
7	2	2	Cooking Oil 1L	ByEQaUPycn	18000.00	17500.00	20	\N	2026-02-16 19:43:40	2026-02-16 19:43:40	7	10	2026-02-16 19:43:40	\N
8	2	2	Slow Moving Item	ZkXUH7SU1q	50000.00	45000.00	5	\N	2026-02-16 19:43:40	2026-02-16 19:43:40	7	10	2025-11-08 19:43:40	\N
16	1	\N	Pajangan Antik	888000552	250000.00	180000.00	0	\N	2026-02-16 20:03:27	2026-02-17 04:46:32	7	10	\N	\N
11	1	\N	Indomie Goreng	888000331	3000.00	2500.00	199	\N	2026-02-16 19:56:09	2026-02-17 05:04:13	7	10	\N	\N
14	1	\N	Kopi Kapal Api 165g	888000444	12500.00	10000.00	49	\N	2026-02-16 19:59:11	2026-02-17 05:04:13	7	10	\N	\N
10	1	\N	Payung Pelangi (Seasonal)	888000222	45000.00	30000.00	53	\N	2026-02-16 19:56:09	2026-02-17 05:45:52	7	10	\N	\N
17	1	\N	Minyak Goreng 2L	888000553	38000.00	32000.00	16	\N	2026-02-16 20:03:27	2026-02-17 05:45:52	7	10	\N	\N
15	1	\N	Aqua 600ml	888000551	3500.00	2800.00	134	\N	2026-02-16 20:02:35	2026-02-17 05:52:46	7	10	\N	\N
12	1	\N	Telur Ayam (Butir)	888000332	2000.00	1600.00	400	\N	2026-02-16 19:56:09	2026-02-17 05:54:09	7	10	\N	\N
9	1	\N	Beras Anak Raja 5kg	888000111	75000.00	60000.00	100	\N	2026-02-16 19:56:09	2026-02-16 19:59:05	7	10	\N	\N
18	1	1	Beras Pandan Wangi 5kg	888000554	72000.00	65000.00	22	\N	2026-02-16 20:03:27	2026-02-17 05:58:57	7	10	\N	\N
19	3	3	Beras Cianjur Kecil	SEM118019	16900.00	14663.00	87	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
20	3	3	Minyak Goreng Bimoli Kecil	SEM934380	14100.00	12189.00	30	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
21	3	3	Minyak Goreng Bimoli Sedang	SEM504217	50900.00	44194.00	132	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
22	3	3	Minyak Goreng Bimoli Besar	SEM416129	41800.00	36267.00	73	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
23	3	3	Gula Pasir Gulaku Kecil	SEM269659	34900.00	30293.00	40	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
24	3	3	Gula Pasir Gulaku Sedang	SEM407181	56600.00	49201.00	170	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
25	3	3	Telur Ayam Kecil	SEM937676	35800.00	31083.00	141	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
26	3	4	Aqua 600ml Kecil	MIN139670	48500.00	42110.00	49	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
27	3	4	Teh Pucuk Harum Kecil	MIN642015	34100.00	29579.00	129	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
28	3	4	Kopi Kapal Api Kecil	MIN583803	43400.00	37664.00	170	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
29	3	4	Kopi Kapal Api Sedang	MIN833465	28100.00	24359.00	111	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
30	3	4	Susu Indomilk Kecil	MIN461859	33900.00	29405.00	47	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
31	3	4	Susu Indomilk Sedang	MIN842456	57000.00	49556.00	158	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
32	3	4	Susu Indomilk Besar	MIN858659	38600.00	33486.00	190	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
33	3	5	Indomie Goreng Kecil	SNA559390	53500.00	46493.00	154	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
34	3	5	Indomie Goreng Sedang	SNA305712	21300.00	18445.00	117	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
35	3	5	Sarimi Kecil	SNA627603	41900.00	36432.00	89	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
36	3	5	Chitato Kecil	SNA116338	30100.00	26134.00	135	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
37	3	5	Chitato Sedang	SNA699507	1200.00	1011.00	129	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
38	3	5	Taro Kecil	SNA917211	38800.00	33672.00	83	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
39	3	5	Taro Sedang	SNA529863	41200.00	35768.00	148	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
40	3	5	Taro Besar	SNA389915	41800.00	36322.00	99	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
41	3	5	Chocolatos Kecil	SNA910901	10400.00	8962.00	146	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
42	3	6	Rinso Anti Noda Kecil	SAB666702	16300.00	14136.00	181	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
43	3	6	Rinso Anti Noda Sedang	SAB901094	46000.00	39965.00	42	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
44	3	6	Rinso Anti Noda Besar	SAB917911	41900.00	36371.00	30	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
45	3	6	Sunlight Kecil	SAB746489	17400.00	15088.00	191	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
46	3	6	Sunlight Sedang	SAB979225	26000.00	22583.00	84	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
47	3	6	Sunlight Besar	SAB495776	47400.00	41133.00	39	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
48	3	6	Lifebuoy Kecil	SAB698870	41900.00	36377.00	23	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
49	3	6	Lifebuoy Sedang	SAB413023	13500.00	11676.00	88	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
50	3	6	Pepsodent Kecil	SAB104458	23100.00	20047.00	100	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
51	3	6	Pepsodent Sedang	SAB317575	38300.00	33286.00	47	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
52	3	6	Pepsodent Besar	SAB545098	7300.00	6287.00	23	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
53	3	7	Sampoerna Mild Kecil	ROK524712	17700.00	15382.00	34	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
54	3	7	Sampoerna Mild Sedang	ROK484703	29500.00	25591.00	40	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
55	3	7	Sampoerna Mild Besar	ROK486114	17500.00	15133.00	148	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
56	3	7	Gudang Garam Filter Kecil	ROK182466	53600.00	46537.00	190	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
57	3	7	Djarum Super Kecil	ROK891751	43300.00	37575.00	79	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
58	3	8	Masako Sapi Kecil	BUM867611	54700.00	47533.00	95	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
59	3	8	Masako Sapi Sedang	BUM436002	38800.00	33691.00	38	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
60	3	8	Masako Sapi Besar	BUM463185	2700.00	2283.00	183	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
61	3	8	Royco Ayam Kecil	BUM473726	31400.00	27255.00	193	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
62	3	8	Kecap Bango Kecil	BUM895880	19700.00	17047.00	32	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
63	3	8	Kecap Bango Sedang	BUM111597	34400.00	29856.00	45	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
64	3	8	Saus ABC Kecil	BUM960485	12000.00	10367.00	88	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
65	3	8	Saus ABC Sedang	BUM442449	53200.00	46203.00	21	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	7	10	\N	\N
66	3	3	Beras Cianjur Kecil	SEM764624	3200.00	2735.00	59	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
67	3	3	Beras Cianjur Sedang	SEM154893	48000.00	41716.00	103	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
68	3	3	Minyak Goreng Bimoli Kecil	SEM881643	2200.00	1910.00	122	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
69	3	3	Minyak Goreng Bimoli Sedang	SEM157532	52800.00	45888.00	120	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
70	3	3	Gula Pasir Gulaku Kecil	SEM885026	11800.00	10241.00	128	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
71	3	3	Gula Pasir Gulaku Sedang	SEM731019	22400.00	19400.00	40	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
72	3	3	Gula Pasir Gulaku Besar	SEM234245	21600.00	18761.00	150	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
73	3	3	Telur Ayam Kecil	SEM644285	35400.00	30754.00	40	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
74	3	3	Telur Ayam Sedang	SEM770945	6200.00	5381.00	136	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
75	3	4	Aqua 600ml Kecil	MIN178511	57000.00	49488.00	42	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
76	3	4	Aqua 600ml Sedang	MIN818272	17200.00	14885.00	22	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
77	3	4	Aqua 600ml Besar	MIN525038	45600.00	39597.00	103	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
78	3	4	Teh Pucuk Harum Kecil	MIN845534	14700.00	12715.00	157	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
79	3	4	Kopi Kapal Api Kecil	MIN507547	3400.00	2944.00	163	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
80	3	4	Kopi Kapal Api Sedang	MIN776337	45100.00	39184.00	134	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
81	3	4	Kopi Kapal Api Besar	MIN773875	21400.00	18559.00	117	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
82	3	4	Susu Indomilk Kecil	MIN144915	15400.00	13361.00	46	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
83	3	4	Susu Indomilk Sedang	MIN724555	1200.00	1011.00	20	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
84	3	4	Susu Indomilk Besar	MIN314803	9500.00	8191.00	102	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
85	3	5	Indomie Goreng Kecil	SNA459973	16200.00	14030.00	193	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
86	3	5	Sarimi Kecil	SNA904249	46200.00	40117.00	140	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
87	3	5	Sarimi Sedang	SNA222271	51200.00	44461.00	108	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
88	3	5	Chitato Kecil	SNA127213	18700.00	16186.00	29	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
89	3	5	Taro Kecil	SNA251590	56400.00	48958.00	117	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
90	3	5	Taro Sedang	SNA712335	56700.00	49263.00	171	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
91	3	5	Chocolatos Kecil	SNA281076	37400.00	32505.00	79	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
92	3	5	Chocolatos Sedang	SNA955101	54700.00	47524.00	92	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
93	3	6	Rinso Anti Noda Kecil	SAB772367	30400.00	26391.00	40	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
94	3	6	Rinso Anti Noda Sedang	SAB219641	22500.00	19550.00	146	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
95	3	6	Rinso Anti Noda Besar	SAB395932	14900.00	12880.00	39	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
96	3	6	Sunlight Kecil	SAB986513	50000.00	43455.00	109	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
97	3	6	Sunlight Sedang	SAB690130	37600.00	32665.00	43	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
98	3	6	Sunlight Besar	SAB248799	8800.00	7622.00	71	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
99	3	6	Lifebuoy Kecil	SAB615455	4000.00	3439.00	182	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
100	3	6	Pepsodent Kecil	SAB215570	7200.00	6193.00	52	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
101	3	6	Pepsodent Sedang	SAB200833	36100.00	31369.00	30	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
102	3	6	Pepsodent Besar	SAB520090	43000.00	37308.00	164	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
103	3	7	Sampoerna Mild Kecil	ROK846418	37100.00	32210.00	86	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
104	3	7	Sampoerna Mild Sedang	ROK288859	35900.00	31151.00	111	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
105	3	7	Gudang Garam Filter Kecil	ROK559939	22300.00	19348.00	185	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
106	3	7	Djarum Super Kecil	ROK589261	49900.00	43380.00	156	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
107	3	8	Masako Sapi Kecil	BUM152423	10000.00	8679.00	198	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
108	3	8	Masako Sapi Sedang	BUM412735	23200.00	20132.00	165	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
109	3	8	Masako Sapi Besar	BUM984261	28000.00	24328.00	41	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
110	3	8	Royco Ayam Kecil	BUM497022	39200.00	34012.00	97	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
111	3	8	Royco Ayam Sedang	BUM935714	20200.00	17555.00	30	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
112	3	8	Kecap Bango Kecil	BUM931506	40500.00	35137.00	146	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
113	3	8	Saus ABC Kecil	BUM676570	27100.00	23550.00	161	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
114	3	8	Saus ABC Sedang	BUM368349	41900.00	36362.00	178	\N	2026-02-16 20:41:31	2026-02-16 20:41:31	7	10	\N	\N
\.


--
-- Data for Name: profit_risk_scores; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.profit_risk_scores (id, store_id, user_id, risk_score, indicators, metadata, calculated_at, created_at, updated_at) FROM stdin;
1	1	\N	0	{"low_margin_items":0,"negative_margin_sales":0,"discount_leakage":0,"void_patterns":0,"price_overrides":0}	\N	2026-02-16	2026-02-16 20:28:43	2026-02-16 20:28:43
\.


--
-- Data for Name: promotions; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.promotions (id, store_id, name, type, value, start_date, end_date, is_active, product_id, category_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: purchase_order_items; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.purchase_order_items (id, purchase_order_id, product_id, quantity, unit_cost, total_cost, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: purchase_orders; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.purchase_orders (id, store_id, supplier_id, user_id, po_number, total_amount, status, ordered_at, expected_at, received_at, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: return_items; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.return_items (id, return_transaction_id, product_id, quantity, refund_price, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: return_transactions; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.return_transactions (id, transaction_id, store_id, user_id, total_refunded, payment_method, reason, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.sessions (id, user_id, ip_address, user_agent, payload, last_activity) FROM stdin;
pycpl2Gb5iVeV9qYicmniMBXmqsYuVg1uCR9VU9y	\N	127.0.0.1	Go-http-client/1.1	YTozOntzOjY6Il90b2tlbiI7czo0MDoiWUNOSU1FNmF4MUxzZk84aWw3Q1JyY1VLZE55V0ZoTE1Md29vaHBBYSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjc6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1771301734
PUKgD0FkUQ0J0quaQCwWkVsbtJEDall3Z4ISdna6	\N	127.0.0.1	Go-http-client/1.1	YToyOntzOjY6Il90b2tlbiI7czo0MDoiS1Z2MTlocEZVa2JjZnNYMXg4QzIwWHNYQjlXaktQMmRmR2d3OFpIciI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1771301689
22CS9lZ56lsdCLvB1cgBJpamZmuWicO2cCYB5hNh	\N	127.0.0.1	Go-http-client/1.1	YTozOntzOjY6Il90b2tlbiI7czo0MDoidU00YUhHeGhzSWxHWU9zekhiVFVRVnRBWlo4UmYwM1dUR0lKRnE4aSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzM6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9kZWJ1Zy1zdG9jayI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1771301690
lLtKXIenmgkvQJILPIRYDADvCQ5EG8Z5sPmyFm87	\N	127.0.0.1	Go-http-client/1.1	YTozOntzOjY6Il90b2tlbiI7czo0MDoiTTlnczJRM3hWVzJDeXF2YTdMSDBqSTFHUTZ5RXdUWjdmS2lBOHFkbCI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czoyMToiaHR0cDovLzEyNy4wLjAuMTo4MDAwIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1771301733
E9mssZhSj8kjM4XsSP0j8zRFPK3BZV8eJLbPkPE0	\N	127.0.0.1	Go-http-client/1.1	YToyOntzOjY6Il90b2tlbiI7czo0MDoiY0gyTGFoa1ZSazdaaFNyUEpVZkRIS1lHckRUWnVSS29rVTVtMktJdCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1771301734
bJAk868F9UnF3K4sI5embado0ZnDDEGjErfH3X2v	\N	127.0.0.1	Go-http-client/1.1	YTo0OntzOjY6Il90b2tlbiI7czo0MDoiQzZpelVaQWd2WEhMZnU0RXZLWlBIWG4zcTl0MTJKRUE4RmcwT3pxRCI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo0NToiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3Byb2R1Y3RzP3NlYXJjaD1JbmRvbWllIjt9czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9wcm9kdWN0cz9zZWFyY2g9SW5kb21pZSI7czo1OiJyb3V0ZSI7czoxNDoicHJvZHVjdHMuaW5kZXgiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1771301734
QQJkPH3P7Th6JXu8hfjxjaCvRjdEMvi1A4jkkSy2	8	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	YTo1OntzOjY6Il90b2tlbiI7czo0MDoiRHg1d0d6RTA2MVdmT09ZVHY3V1phRGhhdUczTGhlZ1d4dUtWV241ayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjk6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9iYWNrdXBzIjtzOjU6InJvdXRlIjtzOjEzOiJiYWNrdXBzLmluZGV4Ijt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czozOiJ1cmwiO2E6MDp7fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjg7fQ==	1771308293
QZCi7j23izGLLe5w8JTZ3Ej50ZBynEesJRbWcHf9	8	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	YTo1OntzOjY6Il90b2tlbiI7czo0MDoiaWdDWFF3WmtrSVdzZW9DWU40QWs5VVBUcG8xYkVsV0doRUxrenVSYiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9wcm9kdWN0cyI7czo1OiJyb3V0ZSI7czoxNDoicHJvZHVjdHMuaW5kZXgiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjM6InVybCI7YTowOnt9czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6ODt9	1771312776
\.


--
-- Data for Name: stock_movements; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.stock_movements (id, store_id, product_id, user_id, reference_type, reference_id, quantity, after_stock, notes, created_at, updated_at, before_stock, type, batch_id) FROM stdin;
1	1	16	8	sale	fbf581b7-886b-4c62-b8a0-d226c2ce616e	-5	0	Sale #INV-260217-0001 	2026-02-17 04:46:32	2026-02-17 04:46:32	5	sale	\N
2	1	17	8	sale	55161f9e-74f9-4c27-8d03-c7df4993026f	-20	20	Sale #INV-260217-0002 	2026-02-17 04:47:03	2026-02-17 04:47:03	40	sale	\N
3	1	17	8	sale	8e629cc1-d0b0-424d-8cce-528fb0bf3a70	-3	17	Sale #INV-260217-0003 	2026-02-17 04:48:58	2026-02-17 04:48:58	20	sale	\N
4	1	18	8	sale	1339ec0e-6d13-4a4b-a81f-a0ebe168b96d	-2	23	Sale #INV-260217-0004 (No Batch)	2026-02-17 05:04:13	2026-02-17 05:04:13	25	sale	\N
5	1	15	8	sale	1339ec0e-6d13-4a4b-a81f-a0ebe168b96d	-5	145	Sale #INV-260217-0004 (No Batch)	2026-02-17 05:04:13	2026-02-17 05:04:13	150	sale	\N
6	1	11	8	sale	1339ec0e-6d13-4a4b-a81f-a0ebe168b96d	-1	199	Sale #INV-260217-0004 (No Batch)	2026-02-17 05:04:13	2026-02-17 05:04:13	200	sale	\N
7	1	12	8	sale	1339ec0e-6d13-4a4b-a81f-a0ebe168b96d	-1	499	Sale #INV-260217-0004 (No Batch)	2026-02-17 05:04:13	2026-02-17 05:04:13	500	sale	\N
8	1	14	8	sale	1339ec0e-6d13-4a4b-a81f-a0ebe168b96d	-1	49	Sale #INV-260217-0004 (No Batch)	2026-02-17 05:04:13	2026-02-17 05:04:13	50	sale	\N
9	1	10	8	sale	1339ec0e-6d13-4a4b-a81f-a0ebe168b96d	-6	54	Sale #INV-260217-0004 (No Batch)	2026-02-17 05:04:13	2026-02-17 05:04:13	60	sale	\N
10	1	10	8	sale	96b2b416-9c8e-4e57-b30c-84e4a967c0f8	-1	53	Sale #INV-260217-0005 (No Batch)	2026-02-17 05:45:52	2026-02-17 05:45:52	54	sale	\N
11	1	18	8	sale	96b2b416-9c8e-4e57-b30c-84e4a967c0f8	-1	22	Sale #INV-260217-0005 (No Batch)	2026-02-17 05:45:52	2026-02-17 05:45:52	23	sale	\N
12	1	15	8	sale	96b2b416-9c8e-4e57-b30c-84e4a967c0f8	-1	144	Sale #INV-260217-0005 (No Batch)	2026-02-17 05:45:52	2026-02-17 05:45:52	145	sale	\N
13	1	17	8	sale	96b2b416-9c8e-4e57-b30c-84e4a967c0f8	-1	16	Sale #INV-260217-0005 (No Batch)	2026-02-17 05:45:52	2026-02-17 05:45:52	17	sale	\N
14	1	15	8	sale	9867497a-8976-4bc9-a365-12bdc617275c	-10	134	Sale #INV-260217-0006 (No Batch)	2026-02-17 05:52:46	2026-02-17 05:52:46	144	sale	\N
15	1	12	8	sale	0051a42c-f274-4092-9a17-fdf8de9cb2e5	-99	400	Sale #INV-260217-0007 (No Batch)	2026-02-17 05:54:09	2026-02-17 05:54:09	499	sale	\N
\.


--
-- Data for Name: stock_opname_items; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.stock_opname_items (id, stock_opname_id, product_id, system_stock, physical_stock, difference, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: stock_opnames; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.stock_opnames (id, store_id, user_id, reference_number, opname_date, status, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: stock_transfer_items; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.stock_transfer_items (id, stock_transfer_id, product_id, request_quantity, shipped_quantity, received_quantity, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: stock_transfers; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.stock_transfers (id, transfer_number, source_store_id, dest_store_id, created_by, received_by, status, shipped_at, received_at, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: store_wallets; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.store_wallets (id, store_id, provider, balance, last_reconciled_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: stores; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.stores (id, name, address, created_at, updated_at) FROM stdin;
1	Main Store	\N	2026-02-16 19:43:28	2026-02-16 19:43:28
2	Main Kelontong	Jakarta	2026-02-16 19:43:29	2026-02-16 19:43:29
3	Kelontong Madura Barokah	Jl. Raya Margonda No. 12	2026-02-16 20:41:06	2026-02-16 20:41:06
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.suppliers (id, name, contact_person, phone, email, address, default_lead_time_days, minimum_order_value, created_at, updated_at) FROM stdin;
1	PT Sumber Makmur	Budi	\N	\N	\N	5	1000000.00	2026-02-16 19:46:40	2026-02-16 19:46:40
2	Agen Sembako Jaya	Siti	\N	\N	\N	2	500000.00	2026-02-16 19:46:40	2026-02-16 19:46:40
\.


--
-- Data for Name: system_alerts; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.system_alerts (id, store_id, type, message, severity, metadata, read_at, created_at, updated_at) FROM stdin;
1	1	sales_target	GOAL: Daily sales target of Rp 5,000,000 reached! 🎉	info	\N	\N	2026-02-16 18:06:06	2026-02-16 20:06:06
2	1	cash_variance	CRITICAL: High cash variance detected in Morning Shift (Rp -75,000).	critical	\N	\N	2026-02-16 15:06:06	2026-02-16 20:06:06
3	1	low_stock	WARNING: 'Aqua 600ml' is running low (8 units left).	warning	\N	\N	2026-02-16 19:36:06	2026-02-16 20:06:06
4	1	cash_variance	CRITICAL: High cash variance detected for Store Admin (Rp -71,935).	critical	{"drawer_id":4,"variance":-71935}	\N	2026-02-17 05:52:10	2026-02-17 05:52:10
\.


--
-- Data for Name: transaction_items; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.transaction_items (id, transaction_id, product_id, product_name, price, cost_price, quantity, total, created_at, updated_at, batch_id) FROM stdin;
1	e19775f2-4c09-4a3d-a52e-e4d775764841	3	Cooking Oil 1L	18000.00	17500.00	1	18000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
2	e19775f2-4c09-4a3d-a52e-e4d775764841	4	Slow Moving Item	50000.00	45000.00	1	50000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
3	8fdb74d9-3039-4230-8da4-ed607ab0a3de	4	Slow Moving Item	50000.00	45000.00	1	50000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
4	8fdb74d9-3039-4230-8da4-ed607ab0a3de	2	Mineral Water	5000.00	2000.00	3	15000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
5	8fdb74d9-3039-4230-8da4-ed607ab0a3de	1	Indomie Fried	3500.00	2800.00	3	10500.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
6	67f7d382-fb06-46b0-ac42-2cdf052163a6	2	Mineral Water	5000.00	2000.00	3	15000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
7	1bd5ae39-c836-4837-9562-17bd1f678fae	1	Indomie Fried	3500.00	2800.00	1	3500.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
8	3fe2fdd9-d026-420a-8541-d4fc3a64f9af	3	Cooking Oil 1L	18000.00	17500.00	2	36000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
9	3fe2fdd9-d026-420a-8541-d4fc3a64f9af	2	Mineral Water	5000.00	2000.00	2	10000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
10	3fe2fdd9-d026-420a-8541-d4fc3a64f9af	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
11	d935a3b7-79e3-4b37-ac8a-9cb441950553	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
12	d935a3b7-79e3-4b37-ac8a-9cb441950553	1	Indomie Fried	3500.00	2800.00	1	3500.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
13	d935a3b7-79e3-4b37-ac8a-9cb441950553	2	Mineral Water	5000.00	2000.00	3	15000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
14	d935a3b7-79e3-4b37-ac8a-9cb441950553	3	Cooking Oil 1L	18000.00	17500.00	3	54000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
15	896f95d8-6cb4-4f50-93bd-3fa9d2cb9e8c	2	Mineral Water	5000.00	2000.00	2	10000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
16	c8eb6c8b-fb01-4864-8e3e-4106f7247be4	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
17	c8eb6c8b-fb01-4864-8e3e-4106f7247be4	1	Indomie Fried	3500.00	2800.00	1	3500.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
18	c8eb6c8b-fb01-4864-8e3e-4106f7247be4	2	Mineral Water	5000.00	2000.00	1	5000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
19	c8eb6c8b-fb01-4864-8e3e-4106f7247be4	3	Cooking Oil 1L	18000.00	17500.00	3	54000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
20	4ecf7b26-0467-4290-8177-523d0b92f378	3	Cooking Oil 1L	18000.00	17500.00	3	54000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
21	4ecf7b26-0467-4290-8177-523d0b92f378	1	Indomie Fried	3500.00	2800.00	1	3500.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
22	4ecf7b26-0467-4290-8177-523d0b92f378	4	Slow Moving Item	50000.00	45000.00	3	150000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
23	4ecf7b26-0467-4290-8177-523d0b92f378	2	Mineral Water	5000.00	2000.00	2	10000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
24	e414a2e1-a60e-4b63-a70a-30b2d9f84574	3	Cooking Oil 1L	18000.00	17500.00	3	54000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
25	e414a2e1-a60e-4b63-a70a-30b2d9f84574	1	Indomie Fried	3500.00	2800.00	1	3500.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
26	e414a2e1-a60e-4b63-a70a-30b2d9f84574	2	Mineral Water	5000.00	2000.00	3	15000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
27	e414a2e1-a60e-4b63-a70a-30b2d9f84574	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
28	910ed1a1-84a4-435f-9a29-ddb7f1e5b142	4	Slow Moving Item	50000.00	45000.00	1	50000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
29	910ed1a1-84a4-435f-9a29-ddb7f1e5b142	1	Indomie Fried	3500.00	2800.00	2	7000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
30	910ed1a1-84a4-435f-9a29-ddb7f1e5b142	2	Mineral Water	5000.00	2000.00	1	5000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
31	910ed1a1-84a4-435f-9a29-ddb7f1e5b142	3	Cooking Oil 1L	18000.00	17500.00	1	18000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
32	47562087-9dc9-4664-b4b1-6ee46e0f36ec	2	Mineral Water	5000.00	2000.00	3	15000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
33	47562087-9dc9-4664-b4b1-6ee46e0f36ec	3	Cooking Oil 1L	18000.00	17500.00	1	18000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
34	47562087-9dc9-4664-b4b1-6ee46e0f36ec	1	Indomie Fried	3500.00	2800.00	2	7000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
35	47562087-9dc9-4664-b4b1-6ee46e0f36ec	4	Slow Moving Item	50000.00	45000.00	3	150000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
36	0e26c949-70e8-46d5-b61b-4953f5514d85	3	Cooking Oil 1L	18000.00	17500.00	3	54000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
37	0e26c949-70e8-46d5-b61b-4953f5514d85	1	Indomie Fried	3500.00	2800.00	2	7000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
38	0e26c949-70e8-46d5-b61b-4953f5514d85	4	Slow Moving Item	50000.00	45000.00	3	150000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
39	0e26c949-70e8-46d5-b61b-4953f5514d85	2	Mineral Water	5000.00	2000.00	1	5000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
40	930c072b-eae1-41e1-b35d-8b9a363f9bdd	2	Mineral Water	5000.00	2000.00	3	15000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
41	930c072b-eae1-41e1-b35d-8b9a363f9bdd	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
42	9e262acc-de56-4e2d-b538-d7d2cf727594	3	Cooking Oil 1L	18000.00	17500.00	3	54000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
43	9e262acc-de56-4e2d-b538-d7d2cf727594	1	Indomie Fried	3500.00	2800.00	2	7000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
44	9e262acc-de56-4e2d-b538-d7d2cf727594	2	Mineral Water	5000.00	2000.00	3	15000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
45	9e262acc-de56-4e2d-b538-d7d2cf727594	4	Slow Moving Item	50000.00	45000.00	1	50000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
46	a1f49d61-ff2e-4ed4-8ef2-08924f175006	2	Mineral Water	5000.00	2000.00	3	15000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
47	b6f4cf8e-2d74-420b-b194-216af81f9843	4	Slow Moving Item	50000.00	45000.00	1	50000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
48	b6f4cf8e-2d74-420b-b194-216af81f9843	2	Mineral Water	5000.00	2000.00	3	15000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
49	b6f4cf8e-2d74-420b-b194-216af81f9843	1	Indomie Fried	3500.00	2800.00	3	10500.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
50	b6f4cf8e-2d74-420b-b194-216af81f9843	3	Cooking Oil 1L	18000.00	17500.00	3	54000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
51	ef777660-08ce-416f-b271-5410ca8245fb	1	Indomie Fried	3500.00	2800.00	3	10500.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
52	ef777660-08ce-416f-b271-5410ca8245fb	2	Mineral Water	5000.00	2000.00	3	15000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
53	ef777660-08ce-416f-b271-5410ca8245fb	4	Slow Moving Item	50000.00	45000.00	1	50000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
54	ef777660-08ce-416f-b271-5410ca8245fb	3	Cooking Oil 1L	18000.00	17500.00	3	54000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
55	777a3290-96d4-4527-8c85-7356375f88cc	4	Slow Moving Item	50000.00	45000.00	1	50000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
56	777a3290-96d4-4527-8c85-7356375f88cc	1	Indomie Fried	3500.00	2800.00	2	7000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
57	777a3290-96d4-4527-8c85-7356375f88cc	3	Cooking Oil 1L	18000.00	17500.00	2	36000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
58	e43e2d56-582b-4183-8f90-f8b41c9ba1ae	1	Indomie Fried	3500.00	2800.00	1	3500.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
59	e43e2d56-582b-4183-8f90-f8b41c9ba1ae	2	Mineral Water	5000.00	2000.00	2	10000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
60	e43e2d56-582b-4183-8f90-f8b41c9ba1ae	3	Cooking Oil 1L	18000.00	17500.00	3	54000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
61	e43e2d56-582b-4183-8f90-f8b41c9ba1ae	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
62	99e684bc-7482-4612-9b81-40f091524d2e	1	Indomie Fried	3500.00	2800.00	1	3500.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
63	99e684bc-7482-4612-9b81-40f091524d2e	4	Slow Moving Item	50000.00	45000.00	3	150000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
64	99e684bc-7482-4612-9b81-40f091524d2e	3	Cooking Oil 1L	18000.00	17500.00	1	18000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
65	99e684bc-7482-4612-9b81-40f091524d2e	2	Mineral Water	5000.00	2000.00	3	15000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
66	9ce5a8f4-5a9f-47e5-a6c6-a35923a8077f	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
67	9ce5a8f4-5a9f-47e5-a6c6-a35923a8077f	1	Indomie Fried	3500.00	2800.00	3	10500.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
68	9ce5a8f4-5a9f-47e5-a6c6-a35923a8077f	2	Mineral Water	5000.00	2000.00	2	10000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
69	2fe9bb7a-aff8-4726-b0e9-7318fca0e9c2	3	Cooking Oil 1L	18000.00	17500.00	1	18000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
70	2fe9bb7a-aff8-4726-b0e9-7318fca0e9c2	2	Mineral Water	5000.00	2000.00	1	5000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
71	2fe9bb7a-aff8-4726-b0e9-7318fca0e9c2	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
72	2fe9bb7a-aff8-4726-b0e9-7318fca0e9c2	1	Indomie Fried	3500.00	2800.00	1	3500.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
73	f5a94489-123f-4735-8e1f-5011c3053ef0	3	Cooking Oil 1L	18000.00	17500.00	1	18000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
74	3865d84f-6e17-40eb-b36b-d7c3433ca0fa	4	Slow Moving Item	50000.00	45000.00	1	50000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
75	3865d84f-6e17-40eb-b36b-d7c3433ca0fa	2	Mineral Water	5000.00	2000.00	3	15000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
76	3865d84f-6e17-40eb-b36b-d7c3433ca0fa	3	Cooking Oil 1L	18000.00	17500.00	2	36000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
77	3865d84f-6e17-40eb-b36b-d7c3433ca0fa	1	Indomie Fried	3500.00	2800.00	3	10500.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
78	3d9cf173-44cc-4cba-a5b9-03a316ef5b3c	3	Cooking Oil 1L	18000.00	17500.00	3	54000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
79	3d9cf173-44cc-4cba-a5b9-03a316ef5b3c	1	Indomie Fried	3500.00	2800.00	1	3500.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
80	1d23af7f-6aad-43a0-a732-dbeb04301c18	4	Slow Moving Item	50000.00	45000.00	1	50000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
81	a2fda4b0-c347-4f85-a97b-dac3038ac8ff	3	Cooking Oil 1L	18000.00	17500.00	3	54000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
82	a2fda4b0-c347-4f85-a97b-dac3038ac8ff	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
83	a2fda4b0-c347-4f85-a97b-dac3038ac8ff	1	Indomie Fried	3500.00	2800.00	3	10500.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
84	c4aee52a-1a09-4b85-baaa-731d94b44198	1	Indomie Fried	3500.00	2800.00	3	10500.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
85	c4aee52a-1a09-4b85-baaa-731d94b44198	4	Slow Moving Item	50000.00	45000.00	1	50000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
86	c4aee52a-1a09-4b85-baaa-731d94b44198	2	Mineral Water	5000.00	2000.00	2	10000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
87	c4aee52a-1a09-4b85-baaa-731d94b44198	3	Cooking Oil 1L	18000.00	17500.00	1	18000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
88	9b317cd1-c671-4c9f-bd63-ec5d6cee4c84	1	Indomie Fried	3500.00	2800.00	3	10500.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
89	9b317cd1-c671-4c9f-bd63-ec5d6cee4c84	2	Mineral Water	5000.00	2000.00	1	5000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
90	9b317cd1-c671-4c9f-bd63-ec5d6cee4c84	4	Slow Moving Item	50000.00	45000.00	1	50000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
91	9b317cd1-c671-4c9f-bd63-ec5d6cee4c84	3	Cooking Oil 1L	18000.00	17500.00	1	18000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
92	c520da17-9d33-4efa-9f67-3f5fde72e632	3	Cooking Oil 1L	18000.00	17500.00	1	18000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
93	c520da17-9d33-4efa-9f67-3f5fde72e632	4	Slow Moving Item	50000.00	45000.00	1	50000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
94	c520da17-9d33-4efa-9f67-3f5fde72e632	1	Indomie Fried	3500.00	2800.00	2	7000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
95	c520da17-9d33-4efa-9f67-3f5fde72e632	2	Mineral Water	5000.00	2000.00	2	10000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
96	3893b580-4d8e-4273-a9c8-f261b13da3a0	2	Mineral Water	5000.00	2000.00	2	10000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
97	a993ec25-32ef-43ff-8007-d8127a028d34	1	Indomie Fried	3500.00	2800.00	2	7000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
98	a41c8f44-0d4f-4414-b0fe-13a0a3113e04	4	Slow Moving Item	50000.00	45000.00	1	50000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
99	a41c8f44-0d4f-4414-b0fe-13a0a3113e04	3	Cooking Oil 1L	18000.00	17500.00	2	36000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
100	795fb205-e5e2-41f4-924e-3bd9513954a6	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
101	795fb205-e5e2-41f4-924e-3bd9513954a6	3	Cooking Oil 1L	18000.00	17500.00	3	54000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
102	795fb205-e5e2-41f4-924e-3bd9513954a6	2	Mineral Water	5000.00	2000.00	2	10000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
103	40b0bc5e-ddac-485a-a776-1df532ad5687	3	Cooking Oil 1L	18000.00	17500.00	3	54000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
104	40b0bc5e-ddac-485a-a776-1df532ad5687	2	Mineral Water	5000.00	2000.00	2	10000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
105	85e3961f-c8ee-4bad-a5ee-3f59da48857c	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
106	85e3961f-c8ee-4bad-a5ee-3f59da48857c	1	Indomie Fried	3500.00	2800.00	1	3500.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
107	1168e0a6-b698-40e3-b2fd-c39976621990	3	Cooking Oil 1L	18000.00	17500.00	2	36000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
108	1168e0a6-b698-40e3-b2fd-c39976621990	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
109	1168e0a6-b698-40e3-b2fd-c39976621990	1	Indomie Fried	3500.00	2800.00	2	7000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
110	1168e0a6-b698-40e3-b2fd-c39976621990	2	Mineral Water	5000.00	2000.00	1	5000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
111	46bd4af5-f0cb-4a65-b8e5-fb2019f2394a	2	Mineral Water	5000.00	2000.00	3	15000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
112	46bd4af5-f0cb-4a65-b8e5-fb2019f2394a	3	Cooking Oil 1L	18000.00	17500.00	1	18000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
113	46bd4af5-f0cb-4a65-b8e5-fb2019f2394a	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
114	46bd4af5-f0cb-4a65-b8e5-fb2019f2394a	1	Indomie Fried	3500.00	2800.00	3	10500.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
115	f92fd45b-d265-45d6-b121-c71d95c1fce2	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
116	f92fd45b-d265-45d6-b121-c71d95c1fce2	3	Cooking Oil 1L	18000.00	17500.00	1	18000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
117	f92fd45b-d265-45d6-b121-c71d95c1fce2	2	Mineral Water	5000.00	2000.00	2	10000.00	2026-02-16 19:43:30	2026-02-16 19:43:30	\N
118	4a1399c7-fb76-4cfa-ae76-87908f95a347	7	Cooking Oil 1L	18000.00	17500.00	1	18000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
119	4a1399c7-fb76-4cfa-ae76-87908f95a347	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
120	c7589117-6882-428b-93ed-0fe0f7b93eaa	1	Indomie Fried	3500.00	2800.00	1	3500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
121	6af2bc44-a64f-4e9d-857b-28e7043547f6	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
122	3476ef29-57c5-4ecf-a824-831ca6a7f54b	2	Mineral Water	5000.00	2000.00	3	15000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
123	3476ef29-57c5-4ecf-a824-831ca6a7f54b	1	Indomie Fried	3500.00	2800.00	3	10500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
124	3476ef29-57c5-4ecf-a824-831ca6a7f54b	5	Indomie Fried	3500.00	2800.00	2	7000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
125	3476ef29-57c5-4ecf-a824-831ca6a7f54b	8	Slow Moving Item	50000.00	45000.00	1	50000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
126	480e397a-990b-442a-a007-85331a069aee	1	Indomie Fried	3500.00	2800.00	1	3500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
127	480e397a-990b-442a-a007-85331a069aee	3	Cooking Oil 1L	18000.00	17500.00	1	18000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
128	9f420fea-97a9-4c81-8501-afcc9daf7fc7	6	Mineral Water	5000.00	2000.00	1	5000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
129	9f420fea-97a9-4c81-8501-afcc9daf7fc7	3	Cooking Oil 1L	18000.00	17500.00	2	36000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
130	9f420fea-97a9-4c81-8501-afcc9daf7fc7	1	Indomie Fried	3500.00	2800.00	2	7000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
131	9f420fea-97a9-4c81-8501-afcc9daf7fc7	2	Mineral Water	5000.00	2000.00	3	15000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
132	b328802c-76eb-4401-9bee-6fbf09971eb0	7	Cooking Oil 1L	18000.00	17500.00	1	18000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
133	b328802c-76eb-4401-9bee-6fbf09971eb0	3	Cooking Oil 1L	18000.00	17500.00	3	54000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
134	b328802c-76eb-4401-9bee-6fbf09971eb0	2	Mineral Water	5000.00	2000.00	3	15000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
135	b328802c-76eb-4401-9bee-6fbf09971eb0	8	Slow Moving Item	50000.00	45000.00	1	50000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
136	b328802c-76eb-4401-9bee-6fbf09971eb0	1	Indomie Fried	3500.00	2800.00	1	3500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
137	7c047853-25a3-4e64-8e9c-d3d02fded9cd	5	Indomie Fried	3500.00	2800.00	2	7000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
138	7c047853-25a3-4e64-8e9c-d3d02fded9cd	4	Slow Moving Item	50000.00	45000.00	3	150000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
139	76a79014-5c29-45eb-93e4-51423aab86ff	3	Cooking Oil 1L	18000.00	17500.00	3	54000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
140	76a79014-5c29-45eb-93e4-51423aab86ff	7	Cooking Oil 1L	18000.00	17500.00	3	54000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
141	76a79014-5c29-45eb-93e4-51423aab86ff	4	Slow Moving Item	50000.00	45000.00	3	150000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
142	69474cb0-83f7-48c9-982e-bd48245d0713	4	Slow Moving Item	50000.00	45000.00	3	150000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
143	69474cb0-83f7-48c9-982e-bd48245d0713	5	Indomie Fried	3500.00	2800.00	3	10500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
144	e092acc9-87ce-4e23-9cfd-62edf8424923	8	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
145	e092acc9-87ce-4e23-9cfd-62edf8424923	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
146	e092acc9-87ce-4e23-9cfd-62edf8424923	6	Mineral Water	5000.00	2000.00	2	10000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
147	e092acc9-87ce-4e23-9cfd-62edf8424923	1	Indomie Fried	3500.00	2800.00	3	10500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
148	e092acc9-87ce-4e23-9cfd-62edf8424923	7	Cooking Oil 1L	18000.00	17500.00	1	18000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
149	0c5f1629-1d6b-4b98-ad71-e00b32a9a7e8	1	Indomie Fried	3500.00	2800.00	2	7000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
150	0c5f1629-1d6b-4b98-ad71-e00b32a9a7e8	5	Indomie Fried	3500.00	2800.00	1	3500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
151	0c5f1629-1d6b-4b98-ad71-e00b32a9a7e8	2	Mineral Water	5000.00	2000.00	1	5000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
152	0c5f1629-1d6b-4b98-ad71-e00b32a9a7e8	8	Slow Moving Item	50000.00	45000.00	3	150000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
153	0c5f1629-1d6b-4b98-ad71-e00b32a9a7e8	3	Cooking Oil 1L	18000.00	17500.00	2	36000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
154	909e636d-a723-4e65-bb49-d45ec7379325	2	Mineral Water	5000.00	2000.00	2	10000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
155	909e636d-a723-4e65-bb49-d45ec7379325	7	Cooking Oil 1L	18000.00	17500.00	1	18000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
156	47e7bd48-0ad2-4b3d-84d5-577daf099a92	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
157	47e7bd48-0ad2-4b3d-84d5-577daf099a92	1	Indomie Fried	3500.00	2800.00	3	10500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
158	47e7bd48-0ad2-4b3d-84d5-577daf099a92	3	Cooking Oil 1L	18000.00	17500.00	1	18000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
159	32d1ed78-1d65-41aa-8184-5c89a77a19f7	4	Slow Moving Item	50000.00	45000.00	3	150000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
160	32d1ed78-1d65-41aa-8184-5c89a77a19f7	5	Indomie Fried	3500.00	2800.00	2	7000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
161	32d1ed78-1d65-41aa-8184-5c89a77a19f7	6	Mineral Water	5000.00	2000.00	1	5000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
162	32d1ed78-1d65-41aa-8184-5c89a77a19f7	7	Cooking Oil 1L	18000.00	17500.00	1	18000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
163	090f1737-2f97-45d9-a3e2-0817ba0eecf1	2	Mineral Water	5000.00	2000.00	2	10000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
164	090f1737-2f97-45d9-a3e2-0817ba0eecf1	5	Indomie Fried	3500.00	2800.00	3	10500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
165	090f1737-2f97-45d9-a3e2-0817ba0eecf1	7	Cooking Oil 1L	18000.00	17500.00	2	36000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
166	090f1737-2f97-45d9-a3e2-0817ba0eecf1	6	Mineral Water	5000.00	2000.00	3	15000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
167	4dbb9ad6-b45c-49db-b7b5-a285aef4547c	3	Cooking Oil 1L	18000.00	17500.00	1	18000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
168	4dbb9ad6-b45c-49db-b7b5-a285aef4547c	8	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
169	4dbb9ad6-b45c-49db-b7b5-a285aef4547c	5	Indomie Fried	3500.00	2800.00	2	7000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
170	4dbb9ad6-b45c-49db-b7b5-a285aef4547c	6	Mineral Water	5000.00	2000.00	1	5000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
171	7e2f1399-3c2e-40c9-9b6f-abf333767a29	7	Cooking Oil 1L	18000.00	17500.00	1	18000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
172	7e2f1399-3c2e-40c9-9b6f-abf333767a29	4	Slow Moving Item	50000.00	45000.00	1	50000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
173	7e2f1399-3c2e-40c9-9b6f-abf333767a29	1	Indomie Fried	3500.00	2800.00	3	10500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
174	7e2f1399-3c2e-40c9-9b6f-abf333767a29	5	Indomie Fried	3500.00	2800.00	3	10500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
175	e51532b6-4470-4077-8e9b-510f5fe12065	7	Cooking Oil 1L	18000.00	17500.00	2	36000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
176	e51532b6-4470-4077-8e9b-510f5fe12065	6	Mineral Water	5000.00	2000.00	1	5000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
177	e51532b6-4470-4077-8e9b-510f5fe12065	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
178	e51532b6-4470-4077-8e9b-510f5fe12065	3	Cooking Oil 1L	18000.00	17500.00	2	36000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
179	48e3ba53-e77d-4943-a936-dc1cb0aa8bd0	2	Mineral Water	5000.00	2000.00	3	15000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
180	48e3ba53-e77d-4943-a936-dc1cb0aa8bd0	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
181	48e3ba53-e77d-4943-a936-dc1cb0aa8bd0	1	Indomie Fried	3500.00	2800.00	2	7000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
182	cd592b0b-1847-47de-9ed8-76d9f8b8ebd3	6	Mineral Water	5000.00	2000.00	1	5000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
183	cd592b0b-1847-47de-9ed8-76d9f8b8ebd3	8	Slow Moving Item	50000.00	45000.00	1	50000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
184	61fac846-88de-42c6-be5c-ae89af43e49d	8	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
185	61fac846-88de-42c6-be5c-ae89af43e49d	1	Indomie Fried	3500.00	2800.00	1	3500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
186	21eb245e-1e9a-42c3-ad68-0852c5e91b65	6	Mineral Water	5000.00	2000.00	1	5000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
187	de718915-795c-484a-8652-a161a0301cc9	2	Mineral Water	5000.00	2000.00	3	15000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
188	34b3c1ca-97f6-46df-918c-edee8a7c8491	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
189	34b3c1ca-97f6-46df-918c-edee8a7c8491	1	Indomie Fried	3500.00	2800.00	3	10500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
190	34b3c1ca-97f6-46df-918c-edee8a7c8491	5	Indomie Fried	3500.00	2800.00	1	3500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
191	34b3c1ca-97f6-46df-918c-edee8a7c8491	2	Mineral Water	5000.00	2000.00	2	10000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
192	34b3c1ca-97f6-46df-918c-edee8a7c8491	8	Slow Moving Item	50000.00	45000.00	1	50000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
193	6eb493c6-1989-4c59-b0cd-cb88b75f3880	5	Indomie Fried	3500.00	2800.00	1	3500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
194	6eb493c6-1989-4c59-b0cd-cb88b75f3880	7	Cooking Oil 1L	18000.00	17500.00	2	36000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
195	bc1a285b-2630-4e16-b3fd-e742d1ee8ed1	5	Indomie Fried	3500.00	2800.00	3	10500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
196	bc1a285b-2630-4e16-b3fd-e742d1ee8ed1	2	Mineral Water	5000.00	2000.00	1	5000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
197	bc1a285b-2630-4e16-b3fd-e742d1ee8ed1	3	Cooking Oil 1L	18000.00	17500.00	3	54000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
198	d24826f8-0579-45d9-9289-7f962f29a35c	2	Mineral Water	5000.00	2000.00	2	10000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
199	d24826f8-0579-45d9-9289-7f962f29a35c	4	Slow Moving Item	50000.00	45000.00	3	150000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
200	d24826f8-0579-45d9-9289-7f962f29a35c	1	Indomie Fried	3500.00	2800.00	1	3500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
201	d24826f8-0579-45d9-9289-7f962f29a35c	5	Indomie Fried	3500.00	2800.00	1	3500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
202	392c8a5a-aed7-4dad-a144-3f96161e011a	3	Cooking Oil 1L	18000.00	17500.00	2	36000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
203	392c8a5a-aed7-4dad-a144-3f96161e011a	1	Indomie Fried	3500.00	2800.00	3	10500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
204	17845fc6-0ee1-477e-8be8-6fce95d8fe38	6	Mineral Water	5000.00	2000.00	3	15000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
205	17845fc6-0ee1-477e-8be8-6fce95d8fe38	5	Indomie Fried	3500.00	2800.00	3	10500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
206	17845fc6-0ee1-477e-8be8-6fce95d8fe38	4	Slow Moving Item	50000.00	45000.00	3	150000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
207	17845fc6-0ee1-477e-8be8-6fce95d8fe38	8	Slow Moving Item	50000.00	45000.00	3	150000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
208	7adf56b4-fe7c-4ab9-a76c-e0847340042c	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
209	7adf56b4-fe7c-4ab9-a76c-e0847340042c	5	Indomie Fried	3500.00	2800.00	2	7000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
210	7adf56b4-fe7c-4ab9-a76c-e0847340042c	7	Cooking Oil 1L	18000.00	17500.00	2	36000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
211	7adf56b4-fe7c-4ab9-a76c-e0847340042c	1	Indomie Fried	3500.00	2800.00	2	7000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
212	028c7c54-8250-4eeb-86e2-76b2f7126101	8	Slow Moving Item	50000.00	45000.00	3	150000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
213	bd767d99-cc96-478d-984f-7eae3b6af74d	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
214	bd767d99-cc96-478d-984f-7eae3b6af74d	7	Cooking Oil 1L	18000.00	17500.00	2	36000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
215	bd767d99-cc96-478d-984f-7eae3b6af74d	8	Slow Moving Item	50000.00	45000.00	3	150000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
216	bd767d99-cc96-478d-984f-7eae3b6af74d	2	Mineral Water	5000.00	2000.00	2	10000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
217	0a46dc37-ba75-4a61-a0f1-5aab9204beee	3	Cooking Oil 1L	18000.00	17500.00	1	18000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
218	0a46dc37-ba75-4a61-a0f1-5aab9204beee	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
219	0a46dc37-ba75-4a61-a0f1-5aab9204beee	6	Mineral Water	5000.00	2000.00	3	15000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
220	0a46dc37-ba75-4a61-a0f1-5aab9204beee	1	Indomie Fried	3500.00	2800.00	2	7000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
221	e9387f4b-4bb9-4bd9-a14c-58820b48bfe9	1	Indomie Fried	3500.00	2800.00	3	10500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
222	e9387f4b-4bb9-4bd9-a14c-58820b48bfe9	7	Cooking Oil 1L	18000.00	17500.00	2	36000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
223	fe83f2a3-bb3e-443f-8896-bc0293b5be1e	4	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
224	96ad07f0-504c-4ac6-bfb3-2f247be0e925	4	Slow Moving Item	50000.00	45000.00	3	150000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
225	96ad07f0-504c-4ac6-bfb3-2f247be0e925	7	Cooking Oil 1L	18000.00	17500.00	3	54000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
226	96ad07f0-504c-4ac6-bfb3-2f247be0e925	5	Indomie Fried	3500.00	2800.00	2	7000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
227	96ad07f0-504c-4ac6-bfb3-2f247be0e925	6	Mineral Water	5000.00	2000.00	2	10000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
228	39eee413-657b-4835-bdfb-b3b072342e2d	3	Cooking Oil 1L	18000.00	17500.00	2	36000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
229	39918064-a463-4197-9908-f7dd2d085a7d	1	Indomie Fried	3500.00	2800.00	1	3500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
230	39918064-a463-4197-9908-f7dd2d085a7d	2	Mineral Water	5000.00	2000.00	2	10000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
231	789c5c48-4016-468d-972d-6b089e039e3e	6	Mineral Water	5000.00	2000.00	2	10000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
232	789c5c48-4016-468d-972d-6b089e039e3e	3	Cooking Oil 1L	18000.00	17500.00	3	54000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
233	789c5c48-4016-468d-972d-6b089e039e3e	5	Indomie Fried	3500.00	2800.00	1	3500.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
234	789c5c48-4016-468d-972d-6b089e039e3e	8	Slow Moving Item	50000.00	45000.00	2	100000.00	2026-02-16 19:43:40	2026-02-16 19:43:40	\N
235	a4b2698b-355a-4e5e-b576-145d82b9e568	9	Beras Anak Raja 5kg	65000.00	60000.00	1	65000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
236	b5166ea4-8bc1-4e8f-ac34-f51b375e369a	9	Beras Anak Raja 5kg	65000.00	60000.00	1	65000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
237	0fdd5b59-734e-4f24-b393-187ad611801f	9	Beras Anak Raja 5kg	65000.00	60000.00	1	65000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
238	f2ffdc94-4c49-49b6-b826-ef134f1e3149	9	Beras Anak Raja 5kg	65000.00	60000.00	1	65000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
239	ec6348a0-655b-43fb-b984-043fb530f61f	9	Beras Anak Raja 5kg	65000.00	60000.00	1	65000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
240	11efdb24-ad1c-4004-9455-37274108c749	9	Beras Anak Raja 5kg	65000.00	60000.00	1	65000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
241	7ba0a887-206b-4e2a-a24d-b0cdc87fbd3c	9	Beras Anak Raja 5kg	65000.00	60000.00	1	65000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
242	726ce1d6-7e12-42af-aaa6-e208feb9a513	9	Beras Anak Raja 5kg	65000.00	60000.00	1	65000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
243	92b71709-6fe5-4ad5-a9fb-64a56fbe6ded	9	Beras Anak Raja 5kg	65000.00	60000.00	1	65000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
244	2c09d976-01d2-4643-ae7c-70e28a00b67d	9	Beras Anak Raja 5kg	65000.00	60000.00	1	65000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
245	d7e78646-3900-4d49-b8d7-6a422c25f1c9	9	Beras Anak Raja 5kg	65000.00	60000.00	1	65000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
246	018ac2e9-9141-43cb-8dfb-694a46cf0ae1	9	Beras Anak Raja 5kg	65000.00	60000.00	1	65000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
247	f9f3579a-78f5-4c76-88c7-f743ee5ed0af	9	Beras Anak Raja 5kg	65000.00	60000.00	1	65000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
248	1c6929b6-4dee-4707-b11e-433ddcf44a6c	9	Beras Anak Raja 5kg	65000.00	60000.00	1	65000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
249	046cfe40-2a4d-4e32-a76b-37a21b3f5a10	11	Indomie Goreng	3000.00	2500.00	1	3000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
250	046cfe40-2a4d-4e32-a76b-37a21b3f5a10	12	Telur Ayam (Butir)	2000.00	1600.00	1	2000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
251	20a93432-b1ca-445a-9ed9-770b95393e4f	11	Indomie Goreng	3000.00	2500.00	1	3000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
252	20a93432-b1ca-445a-9ed9-770b95393e4f	12	Telur Ayam (Butir)	2000.00	1600.00	1	2000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
253	56832812-dcd1-4068-8410-482121f97812	11	Indomie Goreng	3000.00	2500.00	1	3000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
254	56832812-dcd1-4068-8410-482121f97812	12	Telur Ayam (Butir)	2000.00	1600.00	1	2000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
255	f8ee2591-4a80-4209-8de3-88c0b9a8372d	11	Indomie Goreng	3000.00	2500.00	1	3000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
256	f8ee2591-4a80-4209-8de3-88c0b9a8372d	12	Telur Ayam (Butir)	2000.00	1600.00	1	2000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
257	5eaa3d3e-3945-44de-a24b-d0964a301e48	11	Indomie Goreng	3000.00	2500.00	1	3000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
258	5eaa3d3e-3945-44de-a24b-d0964a301e48	12	Telur Ayam (Butir)	2000.00	1600.00	1	2000.00	2026-02-16 19:56:09	2026-02-16 19:56:09	\N
259	632796d2-ff9e-4028-a821-7815eca85603	14	Kopi Kapal Api 165g	12500.00	10000.00	2	25000.00	2026-02-16 19:59:11	2026-02-16 19:59:11	\N
260	f929ed8c-5254-4e44-b25a-32b49c90afb2	14	Kopi Kapal Api 165g	12500.00	10000.00	2	25000.00	2026-02-16 19:59:11	2026-02-16 19:59:11	\N
261	fc24bf0f-77e9-4f41-ad4c-2c75adf02320	14	Kopi Kapal Api 165g	12500.00	10000.00	2	25000.00	2026-02-16 19:59:11	2026-02-16 19:59:11	\N
262	bd39c505-3017-44b5-b88f-5ef5ec762523	14	Kopi Kapal Api 165g	12500.00	10000.00	2	25000.00	2026-02-16 19:59:11	2026-02-16 19:59:11	\N
263	e4a4e0f3-46de-4b86-8695-2c850f1767c5	14	Kopi Kapal Api 165g	12500.00	10000.00	2	25000.00	2026-02-16 19:59:11	2026-02-16 19:59:11	\N
264	c0fc9684-ab0d-4796-abf2-a27f31fd59e5	14	Kopi Kapal Api 165g	12500.00	10000.00	1	12500.00	2026-02-16 19:59:11	2026-02-16 19:59:11	\N
1075	fbf581b7-886b-4c62-b8a0-d226c2ce616e	16	Pajangan Antik	250000.00	180000.00	5	1250000.00	2026-02-17 04:46:32	2026-02-17 04:46:32	\N
266	0ced3e3d-dee9-4f02-9019-bf78ce8d237e	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-25 20:03:27	2026-02-16 20:03:27	\N
267	00c2dc66-976d-4ea4-9656-e1a38f5e3859	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-18 20:03:27	2026-02-16 20:03:27	\N
268	2addd6a6-7556-44f7-8381-de9e27dbd241	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-31 20:03:27	2026-02-16 20:03:27	\N
269	1ffde618-10b1-440b-9a07-1931bcba2304	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-15 20:03:27	2026-02-16 20:03:27	\N
270	570e4667-e767-4936-a915-e4566bdb3ae4	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-01 20:03:27	2026-02-16 20:03:27	\N
271	eaa24753-24be-4114-8d7f-4ea9e1793c4c	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-09 20:03:27	2026-02-16 20:03:27	\N
272	d1606108-c1d0-45c6-93a9-cf255445e5a7	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-25 20:03:27	2026-02-16 20:03:27	\N
273	a2a4b0e2-178d-48f5-a46f-157c6d8f4914	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-28 20:03:27	2026-02-16 20:03:27	\N
274	73f4e714-112c-4dc3-95cc-972ab67ba2fd	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-09 20:03:27	2026-02-16 20:03:27	\N
275	3966fa1a-8f1a-4f15-8dc3-3ddc70687d32	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-15 20:03:27	2026-02-16 20:03:27	\N
276	0f0be040-55f8-499c-b5d3-fe95f1e630f5	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-28 20:03:27	2026-02-16 20:03:27	\N
277	a53e8fc8-2cba-40e1-8a72-be490bca225b	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-25 20:03:27	2026-02-16 20:03:27	\N
278	d52b4652-75ab-4abd-ac65-46de6a486433	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-04 20:03:27	2026-02-16 20:03:27	\N
279	eea617a1-acd0-450c-9e68-da7175fed81d	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-07 20:03:27	2026-02-16 20:03:27	\N
280	ad9979ab-36f0-4b8f-bbc0-cb9dc645b1c1	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-10 20:03:27	2026-02-16 20:03:27	\N
281	60bd654c-2689-4c8a-986c-140f9e56ffdf	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-10 20:03:27	2026-02-16 20:03:27	\N
282	d1d38a49-df7b-4731-8a89-ce7f28bc2f64	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-01 20:03:27	2026-02-16 20:03:27	\N
283	23836234-7d35-45d8-9e37-e3d5a049611d	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-23 20:03:27	2026-02-16 20:03:27	\N
284	0227b536-cdd3-4ebf-920b-d09e59dae02b	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-27 20:03:27	2026-02-16 20:03:27	\N
285	df350a1f-525d-49a8-86d9-68cf252a0c83	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-27 20:03:27	2026-02-16 20:03:27	\N
286	409167f2-bece-450a-b1f0-32c21f2a7d34	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-08 20:03:27	2026-02-16 20:03:27	\N
287	c52a0218-2ca8-4968-b357-38551e59e162	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-28 20:03:27	2026-02-16 20:03:27	\N
288	1292fb71-60d7-4b49-8264-ac906c808f64	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-04 20:03:27	2026-02-16 20:03:27	\N
289	de50dc71-8be7-4cce-8a79-553b74665f74	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-23 20:03:27	2026-02-16 20:03:27	\N
290	3d14bac8-8322-4949-9c11-c590a6db489e	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-24 20:03:27	2026-02-16 20:03:27	\N
291	c3fbaf57-9384-47cd-acb8-2c1619210b5d	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-29 20:03:27	2026-02-16 20:03:27	\N
292	eb630bfb-80d9-4861-b3da-5cb694223e42	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-09 20:03:27	2026-02-16 20:03:27	\N
293	73d8fcea-95cf-44cc-9fe5-4bd8a1821bad	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-01 20:03:27	2026-02-16 20:03:27	\N
294	61441ffe-6f5e-40ef-83a4-1b6bffd6695b	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-30 20:03:27	2026-02-16 20:03:27	\N
295	cd2e9e8f-8f65-468f-a3c2-adf663f0fdc7	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-22 20:03:27	2026-02-16 20:03:27	\N
296	456d7861-6dab-479d-8ad6-adf56fc5319b	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-25 20:03:27	2026-02-16 20:03:27	\N
297	cf9b7d3c-9357-4cdd-95a6-b6f962438dad	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-09 20:03:27	2026-02-16 20:03:27	\N
298	44abbbfc-9a16-4fb1-84c8-45a938cc9676	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-13 20:03:27	2026-02-16 20:03:27	\N
299	e2c032e7-9a54-4841-a9ce-2cde47ad44d2	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-22 20:03:27	2026-02-16 20:03:27	\N
300	75ccb778-b220-441e-a2f3-60bd61ef3550	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-14 20:03:27	2026-02-16 20:03:27	\N
301	cad8c90c-eb07-4df7-8f64-a961dd57c084	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-11 20:03:27	2026-02-16 20:03:27	\N
302	619b0358-a446-4d28-88b8-fc1fa7740c32	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-07 20:03:27	2026-02-16 20:03:27	\N
303	e3cc4f3f-dbf9-4361-83d5-61444c5bc609	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-29 20:03:27	2026-02-16 20:03:27	\N
304	3c4ba28e-ff21-4b69-b6c1-24d955e2e51b	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-02 20:03:27	2026-02-16 20:03:27	\N
305	f4d85df5-8d3f-4f45-bd8c-8924b5f56c61	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-25 20:03:27	2026-02-16 20:03:27	\N
306	defc3740-1842-41ac-bce4-7b2c702c8cb5	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-29 20:03:27	2026-02-16 20:03:27	\N
307	6f0a2e33-2286-48e9-8e31-7eaefaf731dc	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-05 20:03:27	2026-02-16 20:03:27	\N
308	989edd7f-aabd-46d3-a923-739aa304344c	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-07 20:03:27	2026-02-16 20:03:27	\N
309	b702cbb0-a354-49c6-9a89-03524ecf2273	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-08 20:03:27	2026-02-16 20:03:27	\N
310	8898e4a6-fc42-4555-b269-49d417a48a9a	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-23 20:03:27	2026-02-16 20:03:27	\N
311	18adfba2-cad8-41e8-bcd9-2030ea57f8a3	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-01 20:03:27	2026-02-16 20:03:27	\N
312	1a6a5c67-9c11-4d7b-acee-20a13676e222	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-10 20:03:27	2026-02-16 20:03:27	\N
313	f7541033-6ac9-4089-b186-1d2eb336e75c	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-18 20:03:27	2026-02-16 20:03:27	\N
314	df7f98fe-01eb-41ea-a471-a0b6c329fe5f	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-07 20:03:27	2026-02-16 20:03:27	\N
315	98645c09-004f-4b51-a41e-2a4f263e6c7f	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-19 20:03:27	2026-02-16 20:03:27	\N
316	418f43b6-c6f8-49e1-8803-c7b30cc1af56	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-28 20:03:27	2026-02-16 20:03:27	\N
317	24954a8b-3074-4ba1-bc77-208e9790036e	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-05 20:03:27	2026-02-16 20:03:27	\N
318	dab40fb4-1fc2-412b-af3b-333ed53b5d89	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-28 20:03:27	2026-02-16 20:03:27	\N
319	5f36d179-e34a-4fb3-ad5d-a062f153846f	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-11 20:03:27	2026-02-16 20:03:27	\N
320	3490bc1c-096d-4fce-81d9-d0c9cd5c4109	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-20 20:03:27	2026-02-16 20:03:27	\N
321	ca83d3ff-4de9-4430-86be-4a4e46b5ffbc	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-01 20:03:27	2026-02-16 20:03:27	\N
322	f8785a48-5614-4c05-9a62-c96c9ec000ca	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-28 20:03:27	2026-02-16 20:03:27	\N
323	07ac07b9-bf28-4023-b7d6-a92d47ec0121	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-11 20:03:27	2026-02-16 20:03:27	\N
324	97ff7199-4a1c-4d81-8eb5-fa20f7e3a074	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-14 20:03:27	2026-02-16 20:03:27	\N
325	c178aad7-1c4a-40b4-9e50-a8bebb8abfc4	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-09 20:03:27	2026-02-16 20:03:27	\N
326	b381d743-d2e6-46ac-80a6-bc946e659aeb	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-30 20:03:27	2026-02-16 20:03:27	\N
327	0f127203-e0a0-43e4-a7d0-b544538c8489	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-13 20:03:27	2026-02-16 20:03:27	\N
328	c464d4c3-a01f-4ded-9aed-cf4c0e6d6d5f	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-01-30 20:03:27	2026-02-16 20:03:27	\N
329	c7270c11-112f-4435-b4fa-1f74d14b8b90	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-01 20:03:27	2026-02-16 20:03:27	\N
330	d0aa740a-4e24-44a8-b66a-906a1720cb57	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-07 20:03:27	2026-02-16 20:03:27	\N
331	5e477cb6-c92b-4ba7-8845-26bb80c8f377	40	Taro Besar	41800.00	36322.00	2	83600.00	2026-02-16 20:41:07	2026-02-16 20:41:07	\N
332	5e477cb6-c92b-4ba7-8845-26bb80c8f377	46	Sunlight Sedang	26000.00	22583.00	1	26000.00	2026-02-16 20:41:07	2026-02-16 20:41:07	\N
333	188cd4d8-50a2-460b-b4bb-bed8626be723	87	Sarimi Sedang	51200.00	44461.00	2	102400.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
334	188cd4d8-50a2-460b-b4bb-bed8626be723	99	Lifebuoy Kecil	4000.00	3439.00	1	4000.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
335	cb553fda-654c-44ca-a53d-a562a9f97a86	95	Rinso Anti Noda Besar	14900.00	12880.00	2	29800.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
336	cb553fda-654c-44ca-a53d-a562a9f97a86	113	Saus ABC Kecil	27100.00	23550.00	3	81300.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
337	faaba627-bd2d-4f00-a4f7-9cfb273ae334	75	Aqua 600ml Kecil	57000.00	49488.00	2	114000.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
338	d0f196f5-50c5-47c1-b342-a028214b898c	90	Taro Sedang	56700.00	49263.00	1	56700.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
339	d0f196f5-50c5-47c1-b342-a028214b898c	98	Sunlight Besar	8800.00	7622.00	1	8800.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
340	d0f196f5-50c5-47c1-b342-a028214b898c	109	Masako Sapi Besar	28000.00	24328.00	2	56000.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
341	d0f196f5-50c5-47c1-b342-a028214b898c	114	Saus ABC Sedang	41900.00	36362.00	3	125700.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
342	5767af0c-6ffe-4218-8a74-722e5c2ca4d4	73	Telur Ayam Kecil	35400.00	30754.00	3	106200.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
343	5767af0c-6ffe-4218-8a74-722e5c2ca4d4	99	Lifebuoy Kecil	4000.00	3439.00	1	4000.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
344	5767af0c-6ffe-4218-8a74-722e5c2ca4d4	107	Masako Sapi Kecil	10000.00	8679.00	3	30000.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
345	ab61a75b-fd98-4929-99b6-273a4b851b07	72	Gula Pasir Gulaku Besar	21600.00	18761.00	2	43200.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
346	ab61a75b-fd98-4929-99b6-273a4b851b07	100	Pepsodent Kecil	7200.00	6193.00	1	7200.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
347	ab61a75b-fd98-4929-99b6-273a4b851b07	102	Pepsodent Besar	43000.00	37308.00	1	43000.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
348	ab61a75b-fd98-4929-99b6-273a4b851b07	114	Saus ABC Sedang	41900.00	36362.00	1	41900.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
349	f7aec63d-c73c-4e93-b29c-26b25a211d8b	77	Aqua 600ml Besar	45600.00	39597.00	1	45600.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
350	f7aec63d-c73c-4e93-b29c-26b25a211d8b	99	Lifebuoy Kecil	4000.00	3439.00	3	12000.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
351	f7aec63d-c73c-4e93-b29c-26b25a211d8b	105	Gudang Garam Filter Kecil	22300.00	19348.00	1	22300.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
352	755ebeb1-2656-4022-938e-c61a14915526	87	Sarimi Sedang	51200.00	44461.00	1	51200.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
353	755ebeb1-2656-4022-938e-c61a14915526	108	Masako Sapi Sedang	23200.00	20132.00	1	23200.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
354	816b3fb4-aaa1-46f5-9262-36eb97b13f82	100	Pepsodent Kecil	7200.00	6193.00	3	21600.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
355	889c3bd5-762e-4364-8c48-9539ddca6f7d	88	Chitato Kecil	18700.00	16186.00	1	18700.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
356	0cc86d72-b836-44b5-a45c-3cd282ae99e7	68	Minyak Goreng Bimoli Kecil	2200.00	1910.00	2	4400.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
357	0cc86d72-b836-44b5-a45c-3cd282ae99e7	94	Rinso Anti Noda Sedang	22500.00	19550.00	1	22500.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
358	fa636cf3-838c-4c5c-8cf6-a3439c778710	83	Susu Indomilk Sedang	1200.00	1011.00	1	1200.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
359	fa636cf3-838c-4c5c-8cf6-a3439c778710	92	Chocolatos Sedang	54700.00	47524.00	1	54700.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
360	3b2d9651-9ae3-48ad-bd2e-0e2d81c96f1a	75	Aqua 600ml Kecil	57000.00	49488.00	1	57000.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
361	3b2d9651-9ae3-48ad-bd2e-0e2d81c96f1a	86	Sarimi Kecil	46200.00	40117.00	1	46200.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
362	3b2d9651-9ae3-48ad-bd2e-0e2d81c96f1a	101	Pepsodent Sedang	36100.00	31369.00	2	72200.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
363	04341657-1a51-47da-8cf8-268a2ca3044f	66	Beras Cianjur Kecil	3200.00	2735.00	3	9600.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
364	04341657-1a51-47da-8cf8-268a2ca3044f	85	Indomie Goreng Kecil	16200.00	14030.00	2	32400.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
365	04341657-1a51-47da-8cf8-268a2ca3044f	114	Saus ABC Sedang	41900.00	36362.00	2	83800.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
366	0df71fe4-a912-4b64-9bba-e30c3ac575b2	66	Beras Cianjur Kecil	3200.00	2735.00	3	9600.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
367	0df71fe4-a912-4b64-9bba-e30c3ac575b2	103	Sampoerna Mild Kecil	37100.00	32210.00	1	37100.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
368	0df71fe4-a912-4b64-9bba-e30c3ac575b2	112	Kecap Bango Kecil	40500.00	35137.00	2	81000.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
369	3bd0d3f6-e532-4350-9e2a-957f9f004625	71	Gula Pasir Gulaku Sedang	22400.00	19400.00	2	44800.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
370	3bd0d3f6-e532-4350-9e2a-957f9f004625	104	Sampoerna Mild Sedang	35900.00	31151.00	2	71800.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
371	3bd0d3f6-e532-4350-9e2a-957f9f004625	105	Gudang Garam Filter Kecil	22300.00	19348.00	2	44600.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
372	1dae35b1-efb8-4eed-9fff-0009f2304ba0	75	Aqua 600ml Kecil	57000.00	49488.00	3	171000.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
373	1dae35b1-efb8-4eed-9fff-0009f2304ba0	89	Taro Kecil	56400.00	48958.00	1	56400.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
374	1dae35b1-efb8-4eed-9fff-0009f2304ba0	103	Sampoerna Mild Kecil	37100.00	32210.00	3	111300.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
375	b1f17b11-c2de-4202-9a98-fedf9bfb66ea	79	Kopi Kapal Api Kecil	3400.00	2944.00	3	10200.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
376	b1f17b11-c2de-4202-9a98-fedf9bfb66ea	98	Sunlight Besar	8800.00	7622.00	1	8800.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
377	b1f17b11-c2de-4202-9a98-fedf9bfb66ea	104	Sampoerna Mild Sedang	35900.00	31151.00	1	35900.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
378	17dffab7-7e57-4943-a1a4-ac0155c886ad	86	Sarimi Kecil	46200.00	40117.00	3	138600.00	2026-02-16 20:41:31	2026-02-16 20:41:31	\N
379	bd6a0fa7-54b9-49c2-9c98-a6a908c86173	74	Telur Ayam Sedang	6200.00	5381.00	3	18600.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
380	bd6a0fa7-54b9-49c2-9c98-a6a908c86173	88	Chitato Kecil	18700.00	16186.00	3	56100.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
381	bd6a0fa7-54b9-49c2-9c98-a6a908c86173	96	Sunlight Kecil	50000.00	43455.00	1	50000.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
382	bd6a0fa7-54b9-49c2-9c98-a6a908c86173	98	Sunlight Besar	8800.00	7622.00	2	17600.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
383	7ac302c2-21b2-437a-aeb2-20b896acf23f	77	Aqua 600ml Besar	45600.00	39597.00	1	45600.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
384	7ac302c2-21b2-437a-aeb2-20b896acf23f	98	Sunlight Besar	8800.00	7622.00	3	26400.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
385	7ac302c2-21b2-437a-aeb2-20b896acf23f	99	Lifebuoy Kecil	4000.00	3439.00	2	8000.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
386	5e939f2c-bac1-4dc0-b193-e268992f13cb	107	Masako Sapi Kecil	10000.00	8679.00	3	30000.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
387	f5c565c6-c6f0-43c6-bcba-5d31dc1e74e5	84	Susu Indomilk Besar	9500.00	8191.00	1	9500.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
388	f5c565c6-c6f0-43c6-bcba-5d31dc1e74e5	110	Royco Ayam Kecil	39200.00	34012.00	3	117600.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
389	fa7d76f1-7196-4693-96fb-63566ef5c487	91	Chocolatos Kecil	37400.00	32505.00	3	112200.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
390	fa7d76f1-7196-4693-96fb-63566ef5c487	105	Gudang Garam Filter Kecil	22300.00	19348.00	1	22300.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
391	2aec118f-a4cd-476e-96f3-59db5bd5f835	93	Rinso Anti Noda Kecil	30400.00	26391.00	3	91200.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
392	29db4e77-8f4a-4c60-a083-9654af68ec3c	75	Aqua 600ml Kecil	57000.00	49488.00	2	114000.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
393	29db4e77-8f4a-4c60-a083-9654af68ec3c	81	Kopi Kapal Api Besar	21400.00	18559.00	3	64200.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
394	d4e58079-8a25-4de8-a5c6-9b5c96451dda	66	Beras Cianjur Kecil	3200.00	2735.00	2	6400.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
395	d4e58079-8a25-4de8-a5c6-9b5c96451dda	74	Telur Ayam Sedang	6200.00	5381.00	1	6200.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
396	6c48321b-02ee-41bd-bd7e-e9a4b7c38942	81	Kopi Kapal Api Besar	21400.00	18559.00	3	64200.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
397	d9e14ae3-1fe7-4959-8201-c8f731050404	76	Aqua 600ml Sedang	17200.00	14885.00	3	51600.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
398	630ad66f-5123-4dba-bde8-b4bc36f02dca	89	Taro Kecil	56400.00	48958.00	2	112800.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
399	630ad66f-5123-4dba-bde8-b4bc36f02dca	91	Chocolatos Kecil	37400.00	32505.00	1	37400.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
400	630ad66f-5123-4dba-bde8-b4bc36f02dca	97	Sunlight Sedang	37600.00	32665.00	2	75200.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
401	f7857d14-155f-4fc0-95e0-ed248941a8e1	76	Aqua 600ml Sedang	17200.00	14885.00	1	17200.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
402	f7857d14-155f-4fc0-95e0-ed248941a8e1	79	Kopi Kapal Api Kecil	3400.00	2944.00	2	6800.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
403	f7857d14-155f-4fc0-95e0-ed248941a8e1	87	Sarimi Sedang	51200.00	44461.00	2	102400.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
404	f7857d14-155f-4fc0-95e0-ed248941a8e1	114	Saus ABC Sedang	41900.00	36362.00	1	41900.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
405	3de2cbbe-e4d5-48c3-b158-0773a0b08bb5	78	Teh Pucuk Harum Kecil	14700.00	12715.00	3	44100.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
406	3de2cbbe-e4d5-48c3-b158-0773a0b08bb5	104	Sampoerna Mild Sedang	35900.00	31151.00	2	71800.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
407	aac15ebc-08ec-4ede-999e-9c9511964d88	99	Lifebuoy Kecil	4000.00	3439.00	3	12000.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
408	aac15ebc-08ec-4ede-999e-9c9511964d88	103	Sampoerna Mild Kecil	37100.00	32210.00	2	74200.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
409	aac15ebc-08ec-4ede-999e-9c9511964d88	114	Saus ABC Sedang	41900.00	36362.00	2	83800.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
410	52841860-26e7-4f66-b7ae-20f2168eaa4f	67	Beras Cianjur Sedang	48000.00	41716.00	1	48000.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
411	a39240f9-16d8-44ba-86e0-59afd1a78973	79	Kopi Kapal Api Kecil	3400.00	2944.00	1	3400.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
412	a39240f9-16d8-44ba-86e0-59afd1a78973	84	Susu Indomilk Besar	9500.00	8191.00	2	19000.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
413	a39240f9-16d8-44ba-86e0-59afd1a78973	92	Chocolatos Sedang	54700.00	47524.00	1	54700.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
414	93a336ba-a29f-42fc-9ed3-c08939fc2d73	86	Sarimi Kecil	46200.00	40117.00	1	46200.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
415	93a336ba-a29f-42fc-9ed3-c08939fc2d73	98	Sunlight Besar	8800.00	7622.00	1	8800.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
416	93a336ba-a29f-42fc-9ed3-c08939fc2d73	102	Pepsodent Besar	43000.00	37308.00	1	43000.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
417	93a336ba-a29f-42fc-9ed3-c08939fc2d73	109	Masako Sapi Besar	28000.00	24328.00	1	28000.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
418	a0750e4f-2683-4a49-b738-6a629470b050	85	Indomie Goreng Kecil	16200.00	14030.00	1	16200.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
419	a0750e4f-2683-4a49-b738-6a629470b050	86	Sarimi Kecil	46200.00	40117.00	1	46200.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
420	a0750e4f-2683-4a49-b738-6a629470b050	101	Pepsodent Sedang	36100.00	31369.00	3	108300.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
421	a0750e4f-2683-4a49-b738-6a629470b050	111	Royco Ayam Sedang	20200.00	17555.00	3	60600.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
422	b46e0d85-9c45-447a-987e-c2a72a5cc776	82	Susu Indomilk Kecil	15400.00	13361.00	3	46200.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
423	b46e0d85-9c45-447a-987e-c2a72a5cc776	95	Rinso Anti Noda Besar	14900.00	12880.00	2	29800.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
424	21d3a652-cca7-4048-bf86-c9738d1adb2b	72	Gula Pasir Gulaku Besar	21600.00	18761.00	2	43200.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
425	21d3a652-cca7-4048-bf86-c9738d1adb2b	80	Kopi Kapal Api Sedang	45100.00	39184.00	1	45100.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
426	21d3a652-cca7-4048-bf86-c9738d1adb2b	82	Susu Indomilk Kecil	15400.00	13361.00	2	30800.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
427	ca16cd09-eb8d-4830-95b0-a2755a9e5191	81	Kopi Kapal Api Besar	21400.00	18559.00	3	64200.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
428	ca16cd09-eb8d-4830-95b0-a2755a9e5191	88	Chitato Kecil	18700.00	16186.00	2	37400.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
429	ca16cd09-eb8d-4830-95b0-a2755a9e5191	108	Masako Sapi Sedang	23200.00	20132.00	3	69600.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
430	ca16cd09-eb8d-4830-95b0-a2755a9e5191	112	Kecap Bango Kecil	40500.00	35137.00	2	81000.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
431	5753e2c1-f568-4d53-bae5-cfc21b2e130e	70	Gula Pasir Gulaku Kecil	11800.00	10241.00	3	35400.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
432	5753e2c1-f568-4d53-bae5-cfc21b2e130e	89	Taro Kecil	56400.00	48958.00	2	112800.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
433	5753e2c1-f568-4d53-bae5-cfc21b2e130e	108	Masako Sapi Sedang	23200.00	20132.00	1	23200.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
434	f2deae93-e1b9-424b-96dc-79ec953e4c81	80	Kopi Kapal Api Sedang	45100.00	39184.00	2	90200.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
435	f2deae93-e1b9-424b-96dc-79ec953e4c81	102	Pepsodent Besar	43000.00	37308.00	3	129000.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
436	f47251c6-0d4a-4c9c-8a40-89877ab7e2f0	85	Indomie Goreng Kecil	16200.00	14030.00	1	16200.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
437	f47251c6-0d4a-4c9c-8a40-89877ab7e2f0	86	Sarimi Kecil	46200.00	40117.00	3	138600.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
438	140f2a61-36d7-4511-afde-b9cc4ca91309	72	Gula Pasir Gulaku Besar	21600.00	18761.00	3	64800.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
439	140f2a61-36d7-4511-afde-b9cc4ca91309	102	Pepsodent Besar	43000.00	37308.00	2	86000.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
440	140f2a61-36d7-4511-afde-b9cc4ca91309	103	Sampoerna Mild Kecil	37100.00	32210.00	3	111300.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
441	ca18d04f-a862-4049-bf62-527e91adff1e	73	Telur Ayam Kecil	35400.00	30754.00	2	70800.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
442	ca18d04f-a862-4049-bf62-527e91adff1e	110	Royco Ayam Kecil	39200.00	34012.00	1	39200.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
443	91fe449f-c6b3-4662-b746-169a7064592d	67	Beras Cianjur Sedang	48000.00	41716.00	3	144000.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
444	91fe449f-c6b3-4662-b746-169a7064592d	89	Taro Kecil	56400.00	48958.00	1	56400.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
445	d9296d04-1239-4ef7-80f3-5604f24cea1e	74	Telur Ayam Sedang	6200.00	5381.00	2	12400.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
446	d9296d04-1239-4ef7-80f3-5604f24cea1e	103	Sampoerna Mild Kecil	37100.00	32210.00	3	111300.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
447	d9296d04-1239-4ef7-80f3-5604f24cea1e	106	Djarum Super Kecil	49900.00	43380.00	3	149700.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
448	1c70a1a3-bb8b-41e4-bf2f-7da6f978c13b	69	Minyak Goreng Bimoli Sedang	52800.00	45888.00	3	158400.00	2026-02-16 20:41:32	2026-02-16 20:41:32	\N
449	1c70a1a3-bb8b-41e4-bf2f-7da6f978c13b	91	Chocolatos Kecil	37400.00	32505.00	3	112200.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
450	1c70a1a3-bb8b-41e4-bf2f-7da6f978c13b	101	Pepsodent Sedang	36100.00	31369.00	2	72200.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
451	1c70a1a3-bb8b-41e4-bf2f-7da6f978c13b	111	Royco Ayam Sedang	20200.00	17555.00	1	20200.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
452	71c38cdb-0ed2-42a7-8f88-25ae6d7fd22d	71	Gula Pasir Gulaku Sedang	22400.00	19400.00	1	22400.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
453	71c38cdb-0ed2-42a7-8f88-25ae6d7fd22d	76	Aqua 600ml Sedang	17200.00	14885.00	3	51600.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
454	71c38cdb-0ed2-42a7-8f88-25ae6d7fd22d	95	Rinso Anti Noda Besar	14900.00	12880.00	3	44700.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
455	71c38cdb-0ed2-42a7-8f88-25ae6d7fd22d	110	Royco Ayam Kecil	39200.00	34012.00	3	117600.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
456	68beb82e-0973-4324-880c-7b04bed64302	90	Taro Sedang	56700.00	49263.00	2	113400.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
457	402dbb8a-c672-412c-bc05-048ce9968925	70	Gula Pasir Gulaku Kecil	11800.00	10241.00	3	35400.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
458	402dbb8a-c672-412c-bc05-048ce9968925	73	Telur Ayam Kecil	35400.00	30754.00	1	35400.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
459	402dbb8a-c672-412c-bc05-048ce9968925	75	Aqua 600ml Kecil	57000.00	49488.00	3	171000.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
460	402dbb8a-c672-412c-bc05-048ce9968925	114	Saus ABC Sedang	41900.00	36362.00	3	125700.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
461	b9388272-3e90-41f3-b7f3-813ed5c7c11d	94	Rinso Anti Noda Sedang	22500.00	19550.00	2	45000.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
462	b9388272-3e90-41f3-b7f3-813ed5c7c11d	100	Pepsodent Kecil	7200.00	6193.00	2	14400.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
463	b9388272-3e90-41f3-b7f3-813ed5c7c11d	108	Masako Sapi Sedang	23200.00	20132.00	2	46400.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
464	673f8872-9fb2-424d-a5d1-21c1eed8253b	111	Royco Ayam Sedang	20200.00	17555.00	3	60600.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
465	1c192a8b-d9db-4b86-9edd-95837eef4030	88	Chitato Kecil	18700.00	16186.00	2	37400.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
466	1c192a8b-d9db-4b86-9edd-95837eef4030	95	Rinso Anti Noda Besar	14900.00	12880.00	1	14900.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
467	1c192a8b-d9db-4b86-9edd-95837eef4030	104	Sampoerna Mild Sedang	35900.00	31151.00	1	35900.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
468	ba93216c-6d7c-4011-b459-ed06f394edbe	67	Beras Cianjur Sedang	48000.00	41716.00	1	48000.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
469	ba93216c-6d7c-4011-b459-ed06f394edbe	68	Minyak Goreng Bimoli Kecil	2200.00	1910.00	2	4400.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
470	ba93216c-6d7c-4011-b459-ed06f394edbe	106	Djarum Super Kecil	49900.00	43380.00	1	49900.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
471	ba93216c-6d7c-4011-b459-ed06f394edbe	112	Kecap Bango Kecil	40500.00	35137.00	2	81000.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
472	9a8a681a-d77c-4994-85c6-90b4e4440afd	80	Kopi Kapal Api Sedang	45100.00	39184.00	1	45100.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
473	9a8a681a-d77c-4994-85c6-90b4e4440afd	104	Sampoerna Mild Sedang	35900.00	31151.00	3	107700.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
474	9a8a681a-d77c-4994-85c6-90b4e4440afd	107	Masako Sapi Kecil	10000.00	8679.00	1	10000.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
475	c14f59a5-2136-4f10-8235-91e7f1b0f546	69	Minyak Goreng Bimoli Sedang	52800.00	45888.00	2	105600.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
476	c14f59a5-2136-4f10-8235-91e7f1b0f546	73	Telur Ayam Kecil	35400.00	30754.00	3	106200.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
477	0b3402c7-5d73-48f4-a15b-315d2a534d17	85	Indomie Goreng Kecil	16200.00	14030.00	2	32400.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
478	9357d77b-a00d-4560-92ad-31c0ac320f6f	104	Sampoerna Mild Sedang	35900.00	31151.00	3	107700.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
479	573e34bf-258d-44d5-a54e-d7856b68ede0	84	Susu Indomilk Besar	9500.00	8191.00	3	28500.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
480	25be66d7-9581-489f-83b1-febcdc470f35	66	Beras Cianjur Kecil	3200.00	2735.00	1	3200.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
481	25be66d7-9581-489f-83b1-febcdc470f35	67	Beras Cianjur Sedang	48000.00	41716.00	2	96000.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
482	25be66d7-9581-489f-83b1-febcdc470f35	95	Rinso Anti Noda Besar	14900.00	12880.00	3	44700.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
483	670b4ab2-f567-48fd-aadb-e33164ff68b6	77	Aqua 600ml Besar	45600.00	39597.00	3	136800.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
484	670b4ab2-f567-48fd-aadb-e33164ff68b6	93	Rinso Anti Noda Kecil	30400.00	26391.00	1	30400.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
485	670b4ab2-f567-48fd-aadb-e33164ff68b6	98	Sunlight Besar	8800.00	7622.00	3	26400.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
486	670b4ab2-f567-48fd-aadb-e33164ff68b6	100	Pepsodent Kecil	7200.00	6193.00	1	7200.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
487	88cd91ff-4ffc-43d8-b9c4-c43c4f79e36c	100	Pepsodent Kecil	7200.00	6193.00	2	14400.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
488	51a3d4f3-03b8-4298-982c-0e5e012d1179	75	Aqua 600ml Kecil	57000.00	49488.00	1	57000.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
489	51a3d4f3-03b8-4298-982c-0e5e012d1179	106	Djarum Super Kecil	49900.00	43380.00	1	49900.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
490	5eae991a-2fe4-4ac2-ae66-aa1d3ac50f4b	71	Gula Pasir Gulaku Sedang	22400.00	19400.00	1	22400.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
491	5eae991a-2fe4-4ac2-ae66-aa1d3ac50f4b	81	Kopi Kapal Api Besar	21400.00	18559.00	2	42800.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
492	5eae991a-2fe4-4ac2-ae66-aa1d3ac50f4b	83	Susu Indomilk Sedang	1200.00	1011.00	2	2400.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
493	5eae991a-2fe4-4ac2-ae66-aa1d3ac50f4b	114	Saus ABC Sedang	41900.00	36362.00	3	125700.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
494	9b80e947-3300-4a6b-a549-5e1ecc09ffbe	73	Telur Ayam Kecil	35400.00	30754.00	3	106200.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
495	9b80e947-3300-4a6b-a549-5e1ecc09ffbe	83	Susu Indomilk Sedang	1200.00	1011.00	1	1200.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
496	9b80e947-3300-4a6b-a549-5e1ecc09ffbe	108	Masako Sapi Sedang	23200.00	20132.00	1	23200.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
497	f4e4ebea-d755-4011-8e7a-dc3e496ff736	70	Gula Pasir Gulaku Kecil	11800.00	10241.00	3	35400.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
498	f4e4ebea-d755-4011-8e7a-dc3e496ff736	81	Kopi Kapal Api Besar	21400.00	18559.00	3	64200.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
499	5b2640ff-c500-4039-82aa-acfd0606e5e8	73	Telur Ayam Kecil	35400.00	30754.00	1	35400.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
500	5b2640ff-c500-4039-82aa-acfd0606e5e8	75	Aqua 600ml Kecil	57000.00	49488.00	2	114000.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
501	5b2640ff-c500-4039-82aa-acfd0606e5e8	101	Pepsodent Sedang	36100.00	31369.00	1	36100.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
502	b2db0df6-777d-4845-9d5a-641cf11af0ab	109	Masako Sapi Besar	28000.00	24328.00	3	84000.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
503	1262f0eb-2d22-4a19-b4e6-a3f7a7b539e8	95	Rinso Anti Noda Besar	14900.00	12880.00	2	29800.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
504	1262f0eb-2d22-4a19-b4e6-a3f7a7b539e8	113	Saus ABC Kecil	27100.00	23550.00	2	54200.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
505	b379a906-50c7-4e01-a884-a23b38538452	70	Gula Pasir Gulaku Kecil	11800.00	10241.00	3	35400.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
506	ba115e9e-e7e3-4f3a-b924-74b4cf455b0c	71	Gula Pasir Gulaku Sedang	22400.00	19400.00	2	44800.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
507	ba115e9e-e7e3-4f3a-b924-74b4cf455b0c	92	Chocolatos Sedang	54700.00	47524.00	2	109400.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
508	ba115e9e-e7e3-4f3a-b924-74b4cf455b0c	93	Rinso Anti Noda Kecil	30400.00	26391.00	3	91200.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
509	49ef21c7-0f33-4c80-8e37-ecfc37284e48	95	Rinso Anti Noda Besar	14900.00	12880.00	1	14900.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
510	4cc66a87-bb46-4a42-924e-8aa7b38d9c84	87	Sarimi Sedang	51200.00	44461.00	1	51200.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
511	c93aaf29-db26-4eaf-a902-7c22011c86ae	74	Telur Ayam Sedang	6200.00	5381.00	3	18600.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
512	c93aaf29-db26-4eaf-a902-7c22011c86ae	97	Sunlight Sedang	37600.00	32665.00	3	112800.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
513	27a02e4e-1e1d-42a7-a589-08e3e0621897	92	Chocolatos Sedang	54700.00	47524.00	3	164100.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
514	3869e47e-4e65-4df2-8571-b130e3a6a5dd	92	Chocolatos Sedang	54700.00	47524.00	3	164100.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
515	3869e47e-4e65-4df2-8571-b130e3a6a5dd	101	Pepsodent Sedang	36100.00	31369.00	2	72200.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
516	3869e47e-4e65-4df2-8571-b130e3a6a5dd	106	Djarum Super Kecil	49900.00	43380.00	3	149700.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
517	3869e47e-4e65-4df2-8571-b130e3a6a5dd	109	Masako Sapi Besar	28000.00	24328.00	3	84000.00	2026-02-16 20:41:33	2026-02-16 20:41:33	\N
518	0084ad8c-2c77-403f-945e-687d0dbd2c94	74	Telur Ayam Sedang	6200.00	5381.00	1	6200.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
519	f0726e45-9a56-4283-80e5-303855703739	80	Kopi Kapal Api Sedang	45100.00	39184.00	3	135300.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
520	f0726e45-9a56-4283-80e5-303855703739	106	Djarum Super Kecil	49900.00	43380.00	1	49900.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
521	5bd2cfbd-60c4-4598-9559-4c1b5fdd7c64	92	Chocolatos Sedang	54700.00	47524.00	1	54700.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
522	5bd2cfbd-60c4-4598-9559-4c1b5fdd7c64	114	Saus ABC Sedang	41900.00	36362.00	1	41900.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
523	44bc517f-73b2-48b1-8814-04ae7a9bc140	76	Aqua 600ml Sedang	17200.00	14885.00	1	17200.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
524	44bc517f-73b2-48b1-8814-04ae7a9bc140	91	Chocolatos Kecil	37400.00	32505.00	2	74800.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
525	44bc517f-73b2-48b1-8814-04ae7a9bc140	103	Sampoerna Mild Kecil	37100.00	32210.00	1	37100.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
526	44bc517f-73b2-48b1-8814-04ae7a9bc140	114	Saus ABC Sedang	41900.00	36362.00	1	41900.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
527	9ab2fac5-26a6-4532-b374-b420d8a59dd8	66	Beras Cianjur Kecil	3200.00	2735.00	1	3200.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
528	319cfc37-a843-415b-a3ca-671d1b2fee7f	99	Lifebuoy Kecil	4000.00	3439.00	1	4000.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
529	a85b793d-0b06-44f7-8c03-aef42c83d2e6	81	Kopi Kapal Api Besar	21400.00	18559.00	1	21400.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
530	a85b793d-0b06-44f7-8c03-aef42c83d2e6	103	Sampoerna Mild Kecil	37100.00	32210.00	3	111300.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
531	a85b793d-0b06-44f7-8c03-aef42c83d2e6	114	Saus ABC Sedang	41900.00	36362.00	2	83800.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
532	d4c38f8b-beef-4e9b-b047-ae41669173fa	71	Gula Pasir Gulaku Sedang	22400.00	19400.00	3	67200.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
533	d4c38f8b-beef-4e9b-b047-ae41669173fa	80	Kopi Kapal Api Sedang	45100.00	39184.00	3	135300.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
534	d4c38f8b-beef-4e9b-b047-ae41669173fa	93	Rinso Anti Noda Kecil	30400.00	26391.00	3	91200.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
535	d4c38f8b-beef-4e9b-b047-ae41669173fa	103	Sampoerna Mild Kecil	37100.00	32210.00	2	74200.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
536	d4c42702-5b8a-4bfc-9487-11c4b165b2af	73	Telur Ayam Kecil	35400.00	30754.00	1	35400.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
537	d4c42702-5b8a-4bfc-9487-11c4b165b2af	80	Kopi Kapal Api Sedang	45100.00	39184.00	3	135300.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
538	d4c42702-5b8a-4bfc-9487-11c4b165b2af	86	Sarimi Kecil	46200.00	40117.00	1	46200.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
539	573071ac-6b8e-46c2-8a24-a5a268514fa2	102	Pepsodent Besar	43000.00	37308.00	2	86000.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
540	573071ac-6b8e-46c2-8a24-a5a268514fa2	105	Gudang Garam Filter Kecil	22300.00	19348.00	2	44600.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
541	573071ac-6b8e-46c2-8a24-a5a268514fa2	112	Kecap Bango Kecil	40500.00	35137.00	3	121500.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
542	fa36c357-80b5-474c-8c4f-6a9e61d2a5af	84	Susu Indomilk Besar	9500.00	8191.00	2	19000.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
543	fa36c357-80b5-474c-8c4f-6a9e61d2a5af	113	Saus ABC Kecil	27100.00	23550.00	1	27100.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
544	9c102d66-244b-4cb0-be80-e6015358c9fa	77	Aqua 600ml Besar	45600.00	39597.00	3	136800.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
545	e6f20d82-cd87-4b16-baf4-84f904690f7b	66	Beras Cianjur Kecil	3200.00	2735.00	3	9600.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
546	e6f20d82-cd87-4b16-baf4-84f904690f7b	72	Gula Pasir Gulaku Besar	21600.00	18761.00	1	21600.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
547	e6f20d82-cd87-4b16-baf4-84f904690f7b	78	Teh Pucuk Harum Kecil	14700.00	12715.00	3	44100.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
548	e6f20d82-cd87-4b16-baf4-84f904690f7b	97	Sunlight Sedang	37600.00	32665.00	3	112800.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
549	b1e132b3-d7b9-4087-975c-a0541babdd64	69	Minyak Goreng Bimoli Sedang	52800.00	45888.00	2	105600.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
550	b1e132b3-d7b9-4087-975c-a0541babdd64	75	Aqua 600ml Kecil	57000.00	49488.00	1	57000.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
551	b1e132b3-d7b9-4087-975c-a0541babdd64	83	Susu Indomilk Sedang	1200.00	1011.00	1	1200.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
552	52bb003f-f071-4912-b25b-8e0edbf15fa5	109	Masako Sapi Besar	28000.00	24328.00	3	84000.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
553	dc05ab3e-09d2-4e1f-95c4-b377810ee858	76	Aqua 600ml Sedang	17200.00	14885.00	1	17200.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
554	dc05ab3e-09d2-4e1f-95c4-b377810ee858	95	Rinso Anti Noda Besar	14900.00	12880.00	2	29800.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
555	bf4dc0af-63b2-46dd-994a-06424729c944	77	Aqua 600ml Besar	45600.00	39597.00	2	91200.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
556	bf4dc0af-63b2-46dd-994a-06424729c944	78	Teh Pucuk Harum Kecil	14700.00	12715.00	3	44100.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
557	bf4dc0af-63b2-46dd-994a-06424729c944	86	Sarimi Kecil	46200.00	40117.00	1	46200.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
558	8d40426f-c6b4-487e-aa2d-7221519b6dbe	85	Indomie Goreng Kecil	16200.00	14030.00	3	48600.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
559	8d40426f-c6b4-487e-aa2d-7221519b6dbe	90	Taro Sedang	56700.00	49263.00	3	170100.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
560	8d40426f-c6b4-487e-aa2d-7221519b6dbe	104	Sampoerna Mild Sedang	35900.00	31151.00	1	35900.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
561	8d40426f-c6b4-487e-aa2d-7221519b6dbe	109	Masako Sapi Besar	28000.00	24328.00	1	28000.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
562	eda548ed-f927-46cb-830b-83b20ccd8022	73	Telur Ayam Kecil	35400.00	30754.00	1	35400.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
563	9ecd10b4-041c-425a-b796-31b40fa03863	77	Aqua 600ml Besar	45600.00	39597.00	1	45600.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
564	9ecd10b4-041c-425a-b796-31b40fa03863	91	Chocolatos Kecil	37400.00	32505.00	2	74800.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
565	9ecd10b4-041c-425a-b796-31b40fa03863	95	Rinso Anti Noda Besar	14900.00	12880.00	1	14900.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
566	abff2755-8130-4d9c-8dc4-f38e0e966a64	68	Minyak Goreng Bimoli Kecil	2200.00	1910.00	3	6600.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
567	abff2755-8130-4d9c-8dc4-f38e0e966a64	70	Gula Pasir Gulaku Kecil	11800.00	10241.00	1	11800.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
568	abff2755-8130-4d9c-8dc4-f38e0e966a64	105	Gudang Garam Filter Kecil	22300.00	19348.00	3	66900.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
569	61b00242-a837-4a18-abdd-dd07d383d530	76	Aqua 600ml Sedang	17200.00	14885.00	2	34400.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
570	61b00242-a837-4a18-abdd-dd07d383d530	109	Masako Sapi Besar	28000.00	24328.00	2	56000.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
571	012ec076-3007-4f41-926b-6bcc33aa7e3d	94	Rinso Anti Noda Sedang	22500.00	19550.00	3	67500.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
572	012ec076-3007-4f41-926b-6bcc33aa7e3d	107	Masako Sapi Kecil	10000.00	8679.00	3	30000.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
573	a8fd022b-8fc2-4f84-b2af-bfe672bd0764	67	Beras Cianjur Sedang	48000.00	41716.00	2	96000.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
574	a8fd022b-8fc2-4f84-b2af-bfe672bd0764	68	Minyak Goreng Bimoli Kecil	2200.00	1910.00	2	4400.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
575	b6484477-3a80-49e5-8cb6-097a7e846159	78	Teh Pucuk Harum Kecil	14700.00	12715.00	1	14700.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
576	b6484477-3a80-49e5-8cb6-097a7e846159	85	Indomie Goreng Kecil	16200.00	14030.00	2	32400.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
577	8693f9a6-8fd1-48ee-8382-ec04f236363b	100	Pepsodent Kecil	7200.00	6193.00	1	7200.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
578	8693f9a6-8fd1-48ee-8382-ec04f236363b	109	Masako Sapi Besar	28000.00	24328.00	1	28000.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
579	902b7857-f135-422f-9ed8-d6feb1695f26	96	Sunlight Kecil	50000.00	43455.00	3	150000.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
580	f922cded-c77d-41af-8436-e70baf9c879e	67	Beras Cianjur Sedang	48000.00	41716.00	1	48000.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
581	6b783b0f-3b49-4a65-9c9c-b2410fceb2f4	86	Sarimi Kecil	46200.00	40117.00	3	138600.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
582	6b783b0f-3b49-4a65-9c9c-b2410fceb2f4	103	Sampoerna Mild Kecil	37100.00	32210.00	3	111300.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
583	6b783b0f-3b49-4a65-9c9c-b2410fceb2f4	110	Royco Ayam Kecil	39200.00	34012.00	1	39200.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
584	eb7fcbd5-5f3d-4718-9135-a41dba47f598	109	Masako Sapi Besar	28000.00	24328.00	2	56000.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
585	372a3b10-9ab2-44a2-9275-fa2502bfbffd	75	Aqua 600ml Kecil	57000.00	49488.00	2	114000.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
586	372a3b10-9ab2-44a2-9275-fa2502bfbffd	79	Kopi Kapal Api Kecil	3400.00	2944.00	3	10200.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
587	372a3b10-9ab2-44a2-9275-fa2502bfbffd	111	Royco Ayam Sedang	20200.00	17555.00	2	40400.00	2026-02-16 20:41:34	2026-02-16 20:41:34	\N
588	372a3b10-9ab2-44a2-9275-fa2502bfbffd	113	Saus ABC Kecil	27100.00	23550.00	3	81300.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
589	2c3843e3-b93f-4839-9dd4-f5d18b952da8	99	Lifebuoy Kecil	4000.00	3439.00	2	8000.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
590	4d390ca9-ab3c-492f-97e5-d59520c61260	73	Telur Ayam Kecil	35400.00	30754.00	3	106200.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
591	4d390ca9-ab3c-492f-97e5-d59520c61260	98	Sunlight Besar	8800.00	7622.00	2	17600.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
592	e0245869-a089-49f9-93a6-1d0acc533390	84	Susu Indomilk Besar	9500.00	8191.00	2	19000.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
593	e0245869-a089-49f9-93a6-1d0acc533390	112	Kecap Bango Kecil	40500.00	35137.00	1	40500.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
594	68886fa9-980a-46d7-a9f4-52c364a61014	77	Aqua 600ml Besar	45600.00	39597.00	1	45600.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
595	9ad4664c-c878-4d1d-9bdb-f032e106db12	102	Pepsodent Besar	43000.00	37308.00	2	86000.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
596	9ad4664c-c878-4d1d-9bdb-f032e106db12	105	Gudang Garam Filter Kecil	22300.00	19348.00	3	66900.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
597	b6dec020-a18d-493d-b0d0-e39c7c7e73ea	85	Indomie Goreng Kecil	16200.00	14030.00	2	32400.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
598	b6dec020-a18d-493d-b0d0-e39c7c7e73ea	94	Rinso Anti Noda Sedang	22500.00	19550.00	1	22500.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
599	e8e84890-a48d-47fe-8dc0-0452a67a625e	74	Telur Ayam Sedang	6200.00	5381.00	1	6200.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
600	e8e84890-a48d-47fe-8dc0-0452a67a625e	82	Susu Indomilk Kecil	15400.00	13361.00	3	46200.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
601	c2c17b7c-308c-4f0b-b7b7-2a48b44f9020	67	Beras Cianjur Sedang	48000.00	41716.00	1	48000.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
602	c2c17b7c-308c-4f0b-b7b7-2a48b44f9020	88	Chitato Kecil	18700.00	16186.00	3	56100.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
603	c2c17b7c-308c-4f0b-b7b7-2a48b44f9020	89	Taro Kecil	56400.00	48958.00	3	169200.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
604	eaf4ecf0-bb64-42f0-bc88-c629b421342c	105	Gudang Garam Filter Kecil	22300.00	19348.00	3	66900.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
605	90a4b29f-8fb6-4af0-b3cb-b87344cdf3a2	75	Aqua 600ml Kecil	57000.00	49488.00	3	171000.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
606	90a4b29f-8fb6-4af0-b3cb-b87344cdf3a2	110	Royco Ayam Kecil	39200.00	34012.00	2	78400.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
607	d72e46af-bc79-447f-b58c-8deb6f576cd0	67	Beras Cianjur Sedang	48000.00	41716.00	2	96000.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
608	d72e46af-bc79-447f-b58c-8deb6f576cd0	70	Gula Pasir Gulaku Kecil	11800.00	10241.00	2	23600.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
609	d72e46af-bc79-447f-b58c-8deb6f576cd0	86	Sarimi Kecil	46200.00	40117.00	2	92400.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
610	d72e46af-bc79-447f-b58c-8deb6f576cd0	99	Lifebuoy Kecil	4000.00	3439.00	2	8000.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
611	8b531270-8c24-41df-934e-bf642dbc85b8	85	Indomie Goreng Kecil	16200.00	14030.00	3	48600.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
612	8b531270-8c24-41df-934e-bf642dbc85b8	94	Rinso Anti Noda Sedang	22500.00	19550.00	3	67500.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
613	8b531270-8c24-41df-934e-bf642dbc85b8	102	Pepsodent Besar	43000.00	37308.00	2	86000.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
614	8b531270-8c24-41df-934e-bf642dbc85b8	108	Masako Sapi Sedang	23200.00	20132.00	2	46400.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
615	cf5a03ec-3d18-40d8-9268-b30fe10fba44	72	Gula Pasir Gulaku Besar	21600.00	18761.00	2	43200.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
616	cf5a03ec-3d18-40d8-9268-b30fe10fba44	103	Sampoerna Mild Kecil	37100.00	32210.00	1	37100.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
617	cf5a03ec-3d18-40d8-9268-b30fe10fba44	109	Masako Sapi Besar	28000.00	24328.00	2	56000.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
618	cf5a03ec-3d18-40d8-9268-b30fe10fba44	112	Kecap Bango Kecil	40500.00	35137.00	2	81000.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
619	5fc397ed-cd75-4f0e-9c64-af4486862e69	66	Beras Cianjur Kecil	3200.00	2735.00	3	9600.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
620	5fc397ed-cd75-4f0e-9c64-af4486862e69	95	Rinso Anti Noda Besar	14900.00	12880.00	3	44700.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
621	5fc397ed-cd75-4f0e-9c64-af4486862e69	100	Pepsodent Kecil	7200.00	6193.00	2	14400.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
622	5fc397ed-cd75-4f0e-9c64-af4486862e69	101	Pepsodent Sedang	36100.00	31369.00	2	72200.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
623	1292bd85-1b11-4fbb-9819-dccd17187f39	69	Minyak Goreng Bimoli Sedang	52800.00	45888.00	2	105600.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
624	1292bd85-1b11-4fbb-9819-dccd17187f39	89	Taro Kecil	56400.00	48958.00	2	112800.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
625	1292bd85-1b11-4fbb-9819-dccd17187f39	108	Masako Sapi Sedang	23200.00	20132.00	3	69600.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
626	9a8b6a9c-153a-41ae-a4e9-2a2ac543452a	112	Kecap Bango Kecil	40500.00	35137.00	2	81000.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
627	6168162f-13e8-4121-9d8b-f2f8de4631c6	70	Gula Pasir Gulaku Kecil	11800.00	10241.00	3	35400.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
628	6168162f-13e8-4121-9d8b-f2f8de4631c6	81	Kopi Kapal Api Besar	21400.00	18559.00	3	64200.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
629	6168162f-13e8-4121-9d8b-f2f8de4631c6	93	Rinso Anti Noda Kecil	30400.00	26391.00	2	60800.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
630	6168162f-13e8-4121-9d8b-f2f8de4631c6	98	Sunlight Besar	8800.00	7622.00	1	8800.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
631	41bb4ccb-76b5-4468-b57b-7f042f292803	75	Aqua 600ml Kecil	57000.00	49488.00	1	57000.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
632	41bb4ccb-76b5-4468-b57b-7f042f292803	95	Rinso Anti Noda Besar	14900.00	12880.00	3	44700.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
633	41bb4ccb-76b5-4468-b57b-7f042f292803	101	Pepsodent Sedang	36100.00	31369.00	2	72200.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
634	eaa6d66c-0403-47d6-a718-d56e77b3532d	75	Aqua 600ml Kecil	57000.00	49488.00	2	114000.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
635	eaa6d66c-0403-47d6-a718-d56e77b3532d	88	Chitato Kecil	18700.00	16186.00	2	37400.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
636	eaa6d66c-0403-47d6-a718-d56e77b3532d	96	Sunlight Kecil	50000.00	43455.00	3	150000.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
637	eaa6d66c-0403-47d6-a718-d56e77b3532d	110	Royco Ayam Kecil	39200.00	34012.00	3	117600.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
638	2b670aba-39aa-43e5-a1e1-d2c653939ec7	83	Susu Indomilk Sedang	1200.00	1011.00	2	2400.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
639	2b670aba-39aa-43e5-a1e1-d2c653939ec7	106	Djarum Super Kecil	49900.00	43380.00	1	49900.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
640	8e0032f7-30da-41d2-a09b-087b9fa72a01	84	Susu Indomilk Besar	9500.00	8191.00	3	28500.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
641	8e0032f7-30da-41d2-a09b-087b9fa72a01	102	Pepsodent Besar	43000.00	37308.00	3	129000.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
642	8e0032f7-30da-41d2-a09b-087b9fa72a01	109	Masako Sapi Besar	28000.00	24328.00	1	28000.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
643	8e0032f7-30da-41d2-a09b-087b9fa72a01	111	Royco Ayam Sedang	20200.00	17555.00	1	20200.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
644	1df1fc5e-040e-4906-b876-624bb9a8b57b	68	Minyak Goreng Bimoli Kecil	2200.00	1910.00	1	2200.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
645	1df1fc5e-040e-4906-b876-624bb9a8b57b	71	Gula Pasir Gulaku Sedang	22400.00	19400.00	3	67200.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
646	1df1fc5e-040e-4906-b876-624bb9a8b57b	104	Sampoerna Mild Sedang	35900.00	31151.00	3	107700.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
647	872a4a7f-cb1a-49f1-a523-414e3f71bcd7	68	Minyak Goreng Bimoli Kecil	2200.00	1910.00	2	4400.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
648	872a4a7f-cb1a-49f1-a523-414e3f71bcd7	102	Pepsodent Besar	43000.00	37308.00	2	86000.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
649	872a4a7f-cb1a-49f1-a523-414e3f71bcd7	111	Royco Ayam Sedang	20200.00	17555.00	1	20200.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
650	bcf057b7-d1a8-4668-b13e-09123991d9b3	92	Chocolatos Sedang	54700.00	47524.00	1	54700.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
651	c786161e-b934-4608-aeec-cfb60f649faf	67	Beras Cianjur Sedang	48000.00	41716.00	1	48000.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
652	0e80dffc-a496-47a3-9719-37f21704887a	67	Beras Cianjur Sedang	48000.00	41716.00	2	96000.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
653	0e80dffc-a496-47a3-9719-37f21704887a	68	Minyak Goreng Bimoli Kecil	2200.00	1910.00	2	4400.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
654	0e80dffc-a496-47a3-9719-37f21704887a	76	Aqua 600ml Sedang	17200.00	14885.00	3	51600.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
655	0e80dffc-a496-47a3-9719-37f21704887a	90	Taro Sedang	56700.00	49263.00	3	170100.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
656	08966db7-4bbf-43f8-9c88-9db67951da5f	66	Beras Cianjur Kecil	3200.00	2735.00	1	3200.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
657	08966db7-4bbf-43f8-9c88-9db67951da5f	82	Susu Indomilk Kecil	15400.00	13361.00	2	30800.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
658	882b98ee-d441-4eb8-9899-ab5f48d40095	97	Sunlight Sedang	37600.00	32665.00	1	37600.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
659	882b98ee-d441-4eb8-9899-ab5f48d40095	104	Sampoerna Mild Sedang	35900.00	31151.00	3	107700.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
660	882b98ee-d441-4eb8-9899-ab5f48d40095	113	Saus ABC Kecil	27100.00	23550.00	2	54200.00	2026-02-16 20:41:35	2026-02-16 20:41:35	\N
661	3f65b885-52e5-41f4-990f-20790d1f514a	95	Rinso Anti Noda Besar	14900.00	12880.00	1	14900.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
662	3f65b885-52e5-41f4-990f-20790d1f514a	97	Sunlight Sedang	37600.00	32665.00	3	112800.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
663	3f65b885-52e5-41f4-990f-20790d1f514a	103	Sampoerna Mild Kecil	37100.00	32210.00	3	111300.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
664	9cfc4602-47a6-46dd-aaa5-df172548f889	68	Minyak Goreng Bimoli Kecil	2200.00	1910.00	1	2200.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
665	9cfc4602-47a6-46dd-aaa5-df172548f889	74	Telur Ayam Sedang	6200.00	5381.00	2	12400.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
666	9cfc4602-47a6-46dd-aaa5-df172548f889	78	Teh Pucuk Harum Kecil	14700.00	12715.00	3	44100.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
667	9cfc4602-47a6-46dd-aaa5-df172548f889	86	Sarimi Kecil	46200.00	40117.00	2	92400.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
668	e8f55dc4-bdea-4e13-aa87-1a73840b99f8	78	Teh Pucuk Harum Kecil	14700.00	12715.00	3	44100.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
669	e8f55dc4-bdea-4e13-aa87-1a73840b99f8	96	Sunlight Kecil	50000.00	43455.00	2	100000.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
670	e8f55dc4-bdea-4e13-aa87-1a73840b99f8	101	Pepsodent Sedang	36100.00	31369.00	2	72200.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
671	e8f55dc4-bdea-4e13-aa87-1a73840b99f8	103	Sampoerna Mild Kecil	37100.00	32210.00	2	74200.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
672	9693b3de-60cd-4d8f-bdbb-e49326750f07	74	Telur Ayam Sedang	6200.00	5381.00	2	12400.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
673	9693b3de-60cd-4d8f-bdbb-e49326750f07	97	Sunlight Sedang	37600.00	32665.00	2	75200.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
674	9693b3de-60cd-4d8f-bdbb-e49326750f07	99	Lifebuoy Kecil	4000.00	3439.00	3	12000.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
675	9693b3de-60cd-4d8f-bdbb-e49326750f07	107	Masako Sapi Kecil	10000.00	8679.00	3	30000.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
676	8f2482f4-83a0-49f4-906a-dee0656b7556	73	Telur Ayam Kecil	35400.00	30754.00	2	70800.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
677	8f2482f4-83a0-49f4-906a-dee0656b7556	90	Taro Sedang	56700.00	49263.00	1	56700.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
678	8f2482f4-83a0-49f4-906a-dee0656b7556	95	Rinso Anti Noda Besar	14900.00	12880.00	1	14900.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
679	8f2482f4-83a0-49f4-906a-dee0656b7556	98	Sunlight Besar	8800.00	7622.00	2	17600.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
680	91afe97a-4ea6-43d4-9637-9db715571221	76	Aqua 600ml Sedang	17200.00	14885.00	2	34400.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
681	443a7f86-9d92-4c58-a3e5-05860f8aa8bb	69	Minyak Goreng Bimoli Sedang	52800.00	45888.00	3	158400.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
682	443a7f86-9d92-4c58-a3e5-05860f8aa8bb	76	Aqua 600ml Sedang	17200.00	14885.00	1	17200.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
683	443a7f86-9d92-4c58-a3e5-05860f8aa8bb	77	Aqua 600ml Besar	45600.00	39597.00	2	91200.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
684	443a7f86-9d92-4c58-a3e5-05860f8aa8bb	90	Taro Sedang	56700.00	49263.00	2	113400.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
685	a6690e6e-c4db-495f-a553-ec8d4d4625a4	86	Sarimi Kecil	46200.00	40117.00	3	138600.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
686	a6690e6e-c4db-495f-a553-ec8d4d4625a4	98	Sunlight Besar	8800.00	7622.00	1	8800.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
687	e156cc7d-cef9-49ff-9470-2510d73b88d7	78	Teh Pucuk Harum Kecil	14700.00	12715.00	2	29400.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
688	e156cc7d-cef9-49ff-9470-2510d73b88d7	82	Susu Indomilk Kecil	15400.00	13361.00	2	30800.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
689	e156cc7d-cef9-49ff-9470-2510d73b88d7	107	Masako Sapi Kecil	10000.00	8679.00	3	30000.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
690	e1c74394-678f-4e31-acb1-fe90f62caf5c	66	Beras Cianjur Kecil	3200.00	2735.00	2	6400.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
691	dd3aef88-b443-4e11-966a-44dabc6fc98a	102	Pepsodent Besar	43000.00	37308.00	1	43000.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
692	b937ff03-2a1f-41b4-a268-bc43b293e3de	79	Kopi Kapal Api Kecil	3400.00	2944.00	2	6800.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
693	b937ff03-2a1f-41b4-a268-bc43b293e3de	85	Indomie Goreng Kecil	16200.00	14030.00	3	48600.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
694	b937ff03-2a1f-41b4-a268-bc43b293e3de	108	Masako Sapi Sedang	23200.00	20132.00	2	46400.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
695	a33e7b7c-8990-4caf-af53-e40e53ca0489	114	Saus ABC Sedang	41900.00	36362.00	3	125700.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
696	ccfd956c-57ca-4ebb-ae7c-88f7f00b21c8	73	Telur Ayam Kecil	35400.00	30754.00	3	106200.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
697	ccfd956c-57ca-4ebb-ae7c-88f7f00b21c8	79	Kopi Kapal Api Kecil	3400.00	2944.00	1	3400.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
698	ccfd956c-57ca-4ebb-ae7c-88f7f00b21c8	97	Sunlight Sedang	37600.00	32665.00	2	75200.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
699	ccfd956c-57ca-4ebb-ae7c-88f7f00b21c8	103	Sampoerna Mild Kecil	37100.00	32210.00	1	37100.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
700	a954dd38-8436-4f6d-bdae-5d133c931aae	93	Rinso Anti Noda Kecil	30400.00	26391.00	3	91200.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
701	a954dd38-8436-4f6d-bdae-5d133c931aae	95	Rinso Anti Noda Besar	14900.00	12880.00	2	29800.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
702	7e547f2e-13a6-4053-9300-316b3cd70e23	71	Gula Pasir Gulaku Sedang	22400.00	19400.00	2	44800.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
703	a6302bd1-b609-4e39-9f28-aef1efff14b5	67	Beras Cianjur Sedang	48000.00	41716.00	2	96000.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
704	a6302bd1-b609-4e39-9f28-aef1efff14b5	86	Sarimi Kecil	46200.00	40117.00	1	46200.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
705	a6302bd1-b609-4e39-9f28-aef1efff14b5	94	Rinso Anti Noda Sedang	22500.00	19550.00	1	22500.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
706	8ca6d724-c5db-45be-aeb1-a182c13a5df0	66	Beras Cianjur Kecil	3200.00	2735.00	2	6400.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
707	8ca6d724-c5db-45be-aeb1-a182c13a5df0	70	Gula Pasir Gulaku Kecil	11800.00	10241.00	2	23600.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
708	8ca6d724-c5db-45be-aeb1-a182c13a5df0	96	Sunlight Kecil	50000.00	43455.00	1	50000.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
709	8ca6d724-c5db-45be-aeb1-a182c13a5df0	98	Sunlight Besar	8800.00	7622.00	2	17600.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
710	add2ef6e-6f45-44d5-b202-356c86cf9842	71	Gula Pasir Gulaku Sedang	22400.00	19400.00	3	67200.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
711	add2ef6e-6f45-44d5-b202-356c86cf9842	84	Susu Indomilk Besar	9500.00	8191.00	2	19000.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
712	add2ef6e-6f45-44d5-b202-356c86cf9842	91	Chocolatos Kecil	37400.00	32505.00	3	112200.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
713	add2ef6e-6f45-44d5-b202-356c86cf9842	110	Royco Ayam Kecil	39200.00	34012.00	1	39200.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
714	4f51fb27-da3a-4efc-98cd-b9279233f57f	85	Indomie Goreng Kecil	16200.00	14030.00	3	48600.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
715	4f51fb27-da3a-4efc-98cd-b9279233f57f	101	Pepsodent Sedang	36100.00	31369.00	1	36100.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
716	4f51fb27-da3a-4efc-98cd-b9279233f57f	102	Pepsodent Besar	43000.00	37308.00	2	86000.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
717	4f51fb27-da3a-4efc-98cd-b9279233f57f	103	Sampoerna Mild Kecil	37100.00	32210.00	3	111300.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
718	321a1991-ae75-4afb-8cce-fb0adc219cf5	78	Teh Pucuk Harum Kecil	14700.00	12715.00	3	44100.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
719	321a1991-ae75-4afb-8cce-fb0adc219cf5	82	Susu Indomilk Kecil	15400.00	13361.00	2	30800.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
720	321a1991-ae75-4afb-8cce-fb0adc219cf5	97	Sunlight Sedang	37600.00	32665.00	3	112800.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
721	321a1991-ae75-4afb-8cce-fb0adc219cf5	106	Djarum Super Kecil	49900.00	43380.00	3	149700.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
722	40b2b249-158c-426c-8419-1d03b0e3a631	68	Minyak Goreng Bimoli Kecil	2200.00	1910.00	2	4400.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
723	40b2b249-158c-426c-8419-1d03b0e3a631	110	Royco Ayam Kecil	39200.00	34012.00	3	117600.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
724	09e7cc38-8d12-4060-af02-5607d574ee79	74	Telur Ayam Sedang	6200.00	5381.00	1	6200.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
725	09e7cc38-8d12-4060-af02-5607d574ee79	78	Teh Pucuk Harum Kecil	14700.00	12715.00	3	44100.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
726	1ecf4177-369f-4e05-b99b-15d25c9cf9bc	78	Teh Pucuk Harum Kecil	14700.00	12715.00	1	14700.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
727	1ecf4177-369f-4e05-b99b-15d25c9cf9bc	92	Chocolatos Sedang	54700.00	47524.00	3	164100.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
728	1ecf4177-369f-4e05-b99b-15d25c9cf9bc	101	Pepsodent Sedang	36100.00	31369.00	2	72200.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
729	1ecf4177-369f-4e05-b99b-15d25c9cf9bc	105	Gudang Garam Filter Kecil	22300.00	19348.00	1	22300.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
730	c2dd7efe-095c-4b16-9b1f-3ce706cb2a56	74	Telur Ayam Sedang	6200.00	5381.00	1	6200.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
731	c2dd7efe-095c-4b16-9b1f-3ce706cb2a56	84	Susu Indomilk Besar	9500.00	8191.00	1	9500.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
732	c2dd7efe-095c-4b16-9b1f-3ce706cb2a56	85	Indomie Goreng Kecil	16200.00	14030.00	1	16200.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
733	c2dd7efe-095c-4b16-9b1f-3ce706cb2a56	103	Sampoerna Mild Kecil	37100.00	32210.00	3	111300.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
734	99bfea05-7d69-4405-ac58-216446dc46d9	86	Sarimi Kecil	46200.00	40117.00	3	138600.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
735	99bfea05-7d69-4405-ac58-216446dc46d9	111	Royco Ayam Sedang	20200.00	17555.00	3	60600.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
736	e8383984-c30b-45d9-b456-059485c57a8a	83	Susu Indomilk Sedang	1200.00	1011.00	1	1200.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
737	e8383984-c30b-45d9-b456-059485c57a8a	97	Sunlight Sedang	37600.00	32665.00	1	37600.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
738	e8383984-c30b-45d9-b456-059485c57a8a	110	Royco Ayam Kecil	39200.00	34012.00	1	39200.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
739	e8383984-c30b-45d9-b456-059485c57a8a	112	Kecap Bango Kecil	40500.00	35137.00	3	121500.00	2026-02-16 20:41:36	2026-02-16 20:41:36	\N
740	9ec35e35-0f86-416a-8d84-b9126f8cca86	87	Sarimi Sedang	51200.00	44461.00	3	153600.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
741	9ec35e35-0f86-416a-8d84-b9126f8cca86	95	Rinso Anti Noda Besar	14900.00	12880.00	3	44700.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
742	9ec35e35-0f86-416a-8d84-b9126f8cca86	113	Saus ABC Kecil	27100.00	23550.00	2	54200.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
743	d14ca86b-00ce-46f0-836e-4baa61126563	69	Minyak Goreng Bimoli Sedang	52800.00	45888.00	2	105600.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
744	d14ca86b-00ce-46f0-836e-4baa61126563	106	Djarum Super Kecil	49900.00	43380.00	2	99800.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
745	ecfd457c-a9da-4a9d-b166-a8b119e22512	82	Susu Indomilk Kecil	15400.00	13361.00	2	30800.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
746	bf6c3576-a761-41e4-8634-ea30dae54eb9	86	Sarimi Kecil	46200.00	40117.00	1	46200.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
747	77661bf5-52ef-4c86-b2dd-44bb9352e38b	80	Kopi Kapal Api Sedang	45100.00	39184.00	1	45100.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
748	77661bf5-52ef-4c86-b2dd-44bb9352e38b	90	Taro Sedang	56700.00	49263.00	3	170100.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
749	77661bf5-52ef-4c86-b2dd-44bb9352e38b	100	Pepsodent Kecil	7200.00	6193.00	1	7200.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
750	6913e216-5e43-429a-b666-ac4301b6911c	71	Gula Pasir Gulaku Sedang	22400.00	19400.00	2	44800.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
751	6913e216-5e43-429a-b666-ac4301b6911c	77	Aqua 600ml Besar	45600.00	39597.00	2	91200.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
752	6913e216-5e43-429a-b666-ac4301b6911c	113	Saus ABC Kecil	27100.00	23550.00	1	27100.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
753	f3cf17f6-15a5-4775-a10c-ac1020b2f419	84	Susu Indomilk Besar	9500.00	8191.00	3	28500.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
754	f3cf17f6-15a5-4775-a10c-ac1020b2f419	111	Royco Ayam Sedang	20200.00	17555.00	3	60600.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
755	f3cf17f6-15a5-4775-a10c-ac1020b2f419	114	Saus ABC Sedang	41900.00	36362.00	1	41900.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
756	7bc46921-2dde-426d-8ba4-678a1858532b	71	Gula Pasir Gulaku Sedang	22400.00	19400.00	2	44800.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
757	7bc46921-2dde-426d-8ba4-678a1858532b	92	Chocolatos Sedang	54700.00	47524.00	1	54700.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
758	7bc46921-2dde-426d-8ba4-678a1858532b	110	Royco Ayam Kecil	39200.00	34012.00	3	117600.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
759	52aa32c3-2532-465e-a07c-e9e6ded2c029	94	Rinso Anti Noda Sedang	22500.00	19550.00	3	67500.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
760	3eee2abe-3422-4de6-93ac-01af96978b4a	84	Susu Indomilk Besar	9500.00	8191.00	3	28500.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
761	3eee2abe-3422-4de6-93ac-01af96978b4a	90	Taro Sedang	56700.00	49263.00	2	113400.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
762	299ef771-2ad3-4236-8e56-535a4671154c	73	Telur Ayam Kecil	35400.00	30754.00	2	70800.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
763	299ef771-2ad3-4236-8e56-535a4671154c	97	Sunlight Sedang	37600.00	32665.00	2	75200.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
764	299ef771-2ad3-4236-8e56-535a4671154c	112	Kecap Bango Kecil	40500.00	35137.00	3	121500.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
765	c4ef6536-c759-4750-889b-86d093308ebb	72	Gula Pasir Gulaku Besar	21600.00	18761.00	1	21600.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
766	c4ef6536-c759-4750-889b-86d093308ebb	87	Sarimi Sedang	51200.00	44461.00	2	102400.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
767	c4ef6536-c759-4750-889b-86d093308ebb	113	Saus ABC Kecil	27100.00	23550.00	3	81300.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
768	95e50fd1-eb30-47bc-a994-ebab966b7010	87	Sarimi Sedang	51200.00	44461.00	1	51200.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
769	63cba2a6-10d9-45d5-a11b-c29dbb1f361b	67	Beras Cianjur Sedang	48000.00	41716.00	1	48000.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
770	63cba2a6-10d9-45d5-a11b-c29dbb1f361b	108	Masako Sapi Sedang	23200.00	20132.00	3	69600.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
771	ffe930cd-cffd-4e60-9ca2-8a08fc1f5a16	78	Teh Pucuk Harum Kecil	14700.00	12715.00	2	29400.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
772	ffe930cd-cffd-4e60-9ca2-8a08fc1f5a16	108	Masako Sapi Sedang	23200.00	20132.00	3	69600.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
773	79bf03e7-527e-447f-8302-7abf7e0152ca	97	Sunlight Sedang	37600.00	32665.00	1	37600.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
774	f922b262-bb30-4aa5-a362-a5b86ba600f2	70	Gula Pasir Gulaku Kecil	11800.00	10241.00	2	23600.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
775	f922b262-bb30-4aa5-a362-a5b86ba600f2	102	Pepsodent Besar	43000.00	37308.00	2	86000.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
776	f922b262-bb30-4aa5-a362-a5b86ba600f2	106	Djarum Super Kecil	49900.00	43380.00	2	99800.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
777	98926479-995d-423d-9ce5-52fcfc1a0783	102	Pepsodent Besar	43000.00	37308.00	1	43000.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
778	4216c01e-f011-409d-9697-95bbab3a0f70	71	Gula Pasir Gulaku Sedang	22400.00	19400.00	3	67200.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
779	4216c01e-f011-409d-9697-95bbab3a0f70	72	Gula Pasir Gulaku Besar	21600.00	18761.00	2	43200.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
780	4216c01e-f011-409d-9697-95bbab3a0f70	85	Indomie Goreng Kecil	16200.00	14030.00	3	48600.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
781	4216c01e-f011-409d-9697-95bbab3a0f70	88	Chitato Kecil	18700.00	16186.00	2	37400.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
782	736fb7e1-ada7-44c3-beed-f48acdb133d4	81	Kopi Kapal Api Besar	21400.00	18559.00	3	64200.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
783	736fb7e1-ada7-44c3-beed-f48acdb133d4	90	Taro Sedang	56700.00	49263.00	2	113400.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
784	736fb7e1-ada7-44c3-beed-f48acdb133d4	97	Sunlight Sedang	37600.00	32665.00	2	75200.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
785	736fb7e1-ada7-44c3-beed-f48acdb133d4	105	Gudang Garam Filter Kecil	22300.00	19348.00	2	44600.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
786	ce24dd7e-99eb-4895-a5fa-5cc80e4e4cf4	73	Telur Ayam Kecil	35400.00	30754.00	3	106200.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
787	ce24dd7e-99eb-4895-a5fa-5cc80e4e4cf4	76	Aqua 600ml Sedang	17200.00	14885.00	3	51600.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
788	ce24dd7e-99eb-4895-a5fa-5cc80e4e4cf4	104	Sampoerna Mild Sedang	35900.00	31151.00	2	71800.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
789	118f8065-3a5d-49de-86fa-e670ff64bfe3	81	Kopi Kapal Api Besar	21400.00	18559.00	3	64200.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
790	118f8065-3a5d-49de-86fa-e670ff64bfe3	84	Susu Indomilk Besar	9500.00	8191.00	3	28500.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
791	118f8065-3a5d-49de-86fa-e670ff64bfe3	104	Sampoerna Mild Sedang	35900.00	31151.00	2	71800.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
792	32d85914-5fd2-4fc9-ac33-37eb478e79b9	85	Indomie Goreng Kecil	16200.00	14030.00	2	32400.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
793	32d85914-5fd2-4fc9-ac33-37eb478e79b9	98	Sunlight Besar	8800.00	7622.00	1	8800.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
794	32d85914-5fd2-4fc9-ac33-37eb478e79b9	107	Masako Sapi Kecil	10000.00	8679.00	2	20000.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
795	56f7f7e8-e154-4fa1-9374-a5198a1ced32	69	Minyak Goreng Bimoli Sedang	52800.00	45888.00	1	52800.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
796	56f7f7e8-e154-4fa1-9374-a5198a1ced32	95	Rinso Anti Noda Besar	14900.00	12880.00	2	29800.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
797	56f7f7e8-e154-4fa1-9374-a5198a1ced32	114	Saus ABC Sedang	41900.00	36362.00	3	125700.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
798	bdba88e6-dcb0-499c-9f28-2a81c3940f45	104	Sampoerna Mild Sedang	35900.00	31151.00	1	35900.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
799	a66992e5-e3e0-466c-a185-1b7722921735	102	Pepsodent Besar	43000.00	37308.00	2	86000.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
800	b405e841-0115-43cc-8c65-99345c2e48db	70	Gula Pasir Gulaku Kecil	11800.00	10241.00	1	11800.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
801	b405e841-0115-43cc-8c65-99345c2e48db	77	Aqua 600ml Besar	45600.00	39597.00	1	45600.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
802	b405e841-0115-43cc-8c65-99345c2e48db	112	Kecap Bango Kecil	40500.00	35137.00	3	121500.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
803	0b2dd5e8-04ef-4233-b6a1-ac1ca2f2b277	66	Beras Cianjur Kecil	3200.00	2735.00	2	6400.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
804	0b2dd5e8-04ef-4233-b6a1-ac1ca2f2b277	67	Beras Cianjur Sedang	48000.00	41716.00	3	144000.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
805	0b2dd5e8-04ef-4233-b6a1-ac1ca2f2b277	72	Gula Pasir Gulaku Besar	21600.00	18761.00	1	21600.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
806	d458822e-f0b8-4273-8cc1-ffb0784d9a35	90	Taro Sedang	56700.00	49263.00	3	170100.00	2026-02-16 20:41:37	2026-02-16 20:41:37	\N
807	a79ce322-349b-4d46-be93-eec40c315c63	69	Minyak Goreng Bimoli Sedang	52800.00	45888.00	1	52800.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
808	a79ce322-349b-4d46-be93-eec40c315c63	73	Telur Ayam Kecil	35400.00	30754.00	3	106200.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
809	a79ce322-349b-4d46-be93-eec40c315c63	99	Lifebuoy Kecil	4000.00	3439.00	3	12000.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
810	a79ce322-349b-4d46-be93-eec40c315c63	108	Masako Sapi Sedang	23200.00	20132.00	2	46400.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
811	9e0ef86b-485c-477b-85b8-efd4030ebc64	107	Masako Sapi Kecil	10000.00	8679.00	3	30000.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
812	9615de99-8c1e-4a91-b177-ed5273aa2a34	73	Telur Ayam Kecil	35400.00	30754.00	1	35400.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
813	9615de99-8c1e-4a91-b177-ed5273aa2a34	90	Taro Sedang	56700.00	49263.00	2	113400.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
814	9615de99-8c1e-4a91-b177-ed5273aa2a34	106	Djarum Super Kecil	49900.00	43380.00	2	99800.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
815	b8987741-eb62-48bc-a5cf-406843e558bc	75	Aqua 600ml Kecil	57000.00	49488.00	2	114000.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
816	01fa55a7-1d6d-4615-a487-f36d8eecfd03	84	Susu Indomilk Besar	9500.00	8191.00	3	28500.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
817	7994d293-d4f9-49a3-922c-2bb38d0e5231	88	Chitato Kecil	18700.00	16186.00	3	56100.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
818	7994d293-d4f9-49a3-922c-2bb38d0e5231	94	Rinso Anti Noda Sedang	22500.00	19550.00	2	45000.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
819	e6ac1e5c-b9d3-45d3-afb5-db1ffd4e9d6e	68	Minyak Goreng Bimoli Kecil	2200.00	1910.00	1	2200.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
820	e6ac1e5c-b9d3-45d3-afb5-db1ffd4e9d6e	83	Susu Indomilk Sedang	1200.00	1011.00	3	3600.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
821	e6ac1e5c-b9d3-45d3-afb5-db1ffd4e9d6e	91	Chocolatos Kecil	37400.00	32505.00	3	112200.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
822	e6ac1e5c-b9d3-45d3-afb5-db1ffd4e9d6e	102	Pepsodent Besar	43000.00	37308.00	3	129000.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
823	942d1999-2686-418b-8725-6a2577a65f92	69	Minyak Goreng Bimoli Sedang	52800.00	45888.00	3	158400.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
824	942d1999-2686-418b-8725-6a2577a65f92	97	Sunlight Sedang	37600.00	32665.00	3	112800.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
825	b7890def-eb0e-4da0-ad60-4da728e71d63	74	Telur Ayam Sedang	6200.00	5381.00	1	6200.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
826	b7890def-eb0e-4da0-ad60-4da728e71d63	103	Sampoerna Mild Kecil	37100.00	32210.00	3	111300.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
827	b7890def-eb0e-4da0-ad60-4da728e71d63	113	Saus ABC Kecil	27100.00	23550.00	3	81300.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
828	d63bd6f8-1fa0-41fa-9965-512477bc89be	72	Gula Pasir Gulaku Besar	21600.00	18761.00	2	43200.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
829	d63bd6f8-1fa0-41fa-9965-512477bc89be	79	Kopi Kapal Api Kecil	3400.00	2944.00	2	6800.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
830	fa8bf67b-964d-4dc7-bc8f-d8672c4295f7	68	Minyak Goreng Bimoli Kecil	2200.00	1910.00	3	6600.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
831	fa8bf67b-964d-4dc7-bc8f-d8672c4295f7	86	Sarimi Kecil	46200.00	40117.00	2	92400.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
832	fa8bf67b-964d-4dc7-bc8f-d8672c4295f7	89	Taro Kecil	56400.00	48958.00	1	56400.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
833	fa8bf67b-964d-4dc7-bc8f-d8672c4295f7	109	Masako Sapi Besar	28000.00	24328.00	1	28000.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
834	995b51ae-bfb4-4dc1-9c9a-d300c57f8eac	69	Minyak Goreng Bimoli Sedang	52800.00	45888.00	3	158400.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
835	995b51ae-bfb4-4dc1-9c9a-d300c57f8eac	103	Sampoerna Mild Kecil	37100.00	32210.00	1	37100.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
836	a938fea0-97a9-4b18-9ea7-06b53a306fee	75	Aqua 600ml Kecil	57000.00	49488.00	3	171000.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
837	a938fea0-97a9-4b18-9ea7-06b53a306fee	77	Aqua 600ml Besar	45600.00	39597.00	1	45600.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
838	a938fea0-97a9-4b18-9ea7-06b53a306fee	103	Sampoerna Mild Kecil	37100.00	32210.00	3	111300.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
839	90d9e660-704a-40da-9d07-a39f9ba8997c	76	Aqua 600ml Sedang	17200.00	14885.00	3	51600.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
840	90d9e660-704a-40da-9d07-a39f9ba8997c	90	Taro Sedang	56700.00	49263.00	1	56700.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
841	ab4cd8ae-5408-421a-998f-6225cc1aa6db	71	Gula Pasir Gulaku Sedang	22400.00	19400.00	1	22400.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
842	ab4cd8ae-5408-421a-998f-6225cc1aa6db	95	Rinso Anti Noda Besar	14900.00	12880.00	1	14900.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
843	ab4cd8ae-5408-421a-998f-6225cc1aa6db	104	Sampoerna Mild Sedang	35900.00	31151.00	2	71800.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
844	ab4cd8ae-5408-421a-998f-6225cc1aa6db	113	Saus ABC Kecil	27100.00	23550.00	1	27100.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
845	bb6ab572-5b4d-41a7-87c0-3194bb82d3f1	108	Masako Sapi Sedang	23200.00	20132.00	3	69600.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
846	bb6ab572-5b4d-41a7-87c0-3194bb82d3f1	114	Saus ABC Sedang	41900.00	36362.00	2	83800.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
847	55e818c1-bf27-456e-bb22-4a405cc49655	67	Beras Cianjur Sedang	48000.00	41716.00	1	48000.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
848	55e818c1-bf27-456e-bb22-4a405cc49655	98	Sunlight Besar	8800.00	7622.00	3	26400.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
849	55e818c1-bf27-456e-bb22-4a405cc49655	99	Lifebuoy Kecil	4000.00	3439.00	2	8000.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
850	0c7b090a-f93a-4444-ba60-1c8a77f3f18f	98	Sunlight Besar	8800.00	7622.00	2	17600.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
851	0c7b090a-f93a-4444-ba60-1c8a77f3f18f	112	Kecap Bango Kecil	40500.00	35137.00	3	121500.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
852	0c7b090a-f93a-4444-ba60-1c8a77f3f18f	113	Saus ABC Kecil	27100.00	23550.00	1	27100.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
853	2781a08a-96bb-4b2b-a212-368272a46873	111	Royco Ayam Sedang	20200.00	17555.00	3	60600.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
854	a95ee628-3417-4489-bd23-edae96d54e72	79	Kopi Kapal Api Kecil	3400.00	2944.00	1	3400.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
855	a95ee628-3417-4489-bd23-edae96d54e72	97	Sunlight Sedang	37600.00	32665.00	3	112800.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
856	d5071524-8b0a-4685-a410-f725dd3e8706	71	Gula Pasir Gulaku Sedang	22400.00	19400.00	2	44800.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
857	d5071524-8b0a-4685-a410-f725dd3e8706	80	Kopi Kapal Api Sedang	45100.00	39184.00	3	135300.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
858	d5071524-8b0a-4685-a410-f725dd3e8706	110	Royco Ayam Kecil	39200.00	34012.00	3	117600.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
859	f616be7c-0a16-4bc7-93a6-dede170f9759	100	Pepsodent Kecil	7200.00	6193.00	1	7200.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
860	3260eea4-eac1-42a7-ace0-ddefc87b0d7e	93	Rinso Anti Noda Kecil	30400.00	26391.00	3	91200.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
861	3260eea4-eac1-42a7-ace0-ddefc87b0d7e	105	Gudang Garam Filter Kecil	22300.00	19348.00	3	66900.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
862	4a59c7ba-9b2d-43dc-98ae-c148265686a4	86	Sarimi Kecil	46200.00	40117.00	1	46200.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
863	cd8f86a1-3c3e-4d37-869a-ab8b2e40db1b	71	Gula Pasir Gulaku Sedang	22400.00	19400.00	1	22400.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
864	cd8f86a1-3c3e-4d37-869a-ab8b2e40db1b	76	Aqua 600ml Sedang	17200.00	14885.00	2	34400.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
865	cd8f86a1-3c3e-4d37-869a-ab8b2e40db1b	79	Kopi Kapal Api Kecil	3400.00	2944.00	1	3400.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
866	2ef661f1-76df-430f-81f4-820862dadbed	86	Sarimi Kecil	46200.00	40117.00	2	92400.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
867	2ef661f1-76df-430f-81f4-820862dadbed	88	Chitato Kecil	18700.00	16186.00	1	18700.00	2026-02-16 20:41:38	2026-02-16 20:41:38	\N
868	0fb317e1-7b3a-468a-82bd-8d3d8bc6a217	69	Minyak Goreng Bimoli Sedang	52800.00	45888.00	3	158400.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
869	0fb317e1-7b3a-468a-82bd-8d3d8bc6a217	81	Kopi Kapal Api Besar	21400.00	18559.00	1	21400.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
870	0fb317e1-7b3a-468a-82bd-8d3d8bc6a217	89	Taro Kecil	56400.00	48958.00	3	169200.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
871	0fb317e1-7b3a-468a-82bd-8d3d8bc6a217	91	Chocolatos Kecil	37400.00	32505.00	1	37400.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
872	727caa62-013a-485a-8d6d-e0c51aa61473	80	Kopi Kapal Api Sedang	45100.00	39184.00	2	90200.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
873	a5879b4a-cf34-46b5-ad07-90c592949d9a	71	Gula Pasir Gulaku Sedang	22400.00	19400.00	3	67200.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
874	cf6fb3cd-c653-4326-b6b7-88d6c4c28f9b	83	Susu Indomilk Sedang	1200.00	1011.00	1	1200.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
875	cf6fb3cd-c653-4326-b6b7-88d6c4c28f9b	87	Sarimi Sedang	51200.00	44461.00	3	153600.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
876	3ed44ab0-2a5d-4a01-a5ee-f834661802d9	97	Sunlight Sedang	37600.00	32665.00	3	112800.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
877	3ed44ab0-2a5d-4a01-a5ee-f834661802d9	112	Kecap Bango Kecil	40500.00	35137.00	3	121500.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
878	4fa88121-4abb-4063-b858-5822a394aff5	78	Teh Pucuk Harum Kecil	14700.00	12715.00	3	44100.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
879	ad68e5e5-fed1-45d7-8c59-8aedf23d50b1	111	Royco Ayam Sedang	20200.00	17555.00	1	20200.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
880	b9a955ba-84ea-4c66-9d2d-d8e126088270	95	Rinso Anti Noda Besar	14900.00	12880.00	3	44700.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
881	b9a955ba-84ea-4c66-9d2d-d8e126088270	100	Pepsodent Kecil	7200.00	6193.00	1	7200.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
882	2cfc2236-89c4-4011-bc08-5ae57653b9c0	72	Gula Pasir Gulaku Besar	21600.00	18761.00	2	43200.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
883	2cfc2236-89c4-4011-bc08-5ae57653b9c0	109	Masako Sapi Besar	28000.00	24328.00	2	56000.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
884	2cfc2236-89c4-4011-bc08-5ae57653b9c0	112	Kecap Bango Kecil	40500.00	35137.00	2	81000.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
885	f1b769d2-f458-4509-878d-8a962ea00668	88	Chitato Kecil	18700.00	16186.00	3	56100.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
886	d2ab7468-becb-4a12-947a-1bbeaf16f048	82	Susu Indomilk Kecil	15400.00	13361.00	1	15400.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
887	d2ab7468-becb-4a12-947a-1bbeaf16f048	102	Pepsodent Besar	43000.00	37308.00	1	43000.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
888	d2ab7468-becb-4a12-947a-1bbeaf16f048	104	Sampoerna Mild Sedang	35900.00	31151.00	1	35900.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
889	225aafff-4b82-42ab-bbe7-15174202a14e	73	Telur Ayam Kecil	35400.00	30754.00	1	35400.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
890	225aafff-4b82-42ab-bbe7-15174202a14e	79	Kopi Kapal Api Kecil	3400.00	2944.00	2	6800.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
891	225aafff-4b82-42ab-bbe7-15174202a14e	87	Sarimi Sedang	51200.00	44461.00	1	51200.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
892	225aafff-4b82-42ab-bbe7-15174202a14e	106	Djarum Super Kecil	49900.00	43380.00	1	49900.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
893	3ae1d235-b61d-411a-8940-4b03bfb044a8	73	Telur Ayam Kecil	35400.00	30754.00	1	35400.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
894	3ae1d235-b61d-411a-8940-4b03bfb044a8	97	Sunlight Sedang	37600.00	32665.00	3	112800.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
895	3ae1d235-b61d-411a-8940-4b03bfb044a8	103	Sampoerna Mild Kecil	37100.00	32210.00	2	74200.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
896	3ae1d235-b61d-411a-8940-4b03bfb044a8	105	Gudang Garam Filter Kecil	22300.00	19348.00	1	22300.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
897	b0b0ff12-ad8f-4634-a44c-7594c9984832	97	Sunlight Sedang	37600.00	32665.00	3	112800.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
898	b0b0ff12-ad8f-4634-a44c-7594c9984832	100	Pepsodent Kecil	7200.00	6193.00	3	21600.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
899	b0b0ff12-ad8f-4634-a44c-7594c9984832	110	Royco Ayam Kecil	39200.00	34012.00	3	117600.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
900	b0b0ff12-ad8f-4634-a44c-7594c9984832	114	Saus ABC Sedang	41900.00	36362.00	1	41900.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
901	04a8f340-dbdb-497d-af21-9ed3afbe7b55	71	Gula Pasir Gulaku Sedang	22400.00	19400.00	3	67200.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
902	04a8f340-dbdb-497d-af21-9ed3afbe7b55	74	Telur Ayam Sedang	6200.00	5381.00	3	18600.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
903	c1cbb89e-96f2-4070-bfeb-645a366a3adb	80	Kopi Kapal Api Sedang	45100.00	39184.00	1	45100.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
904	c1cbb89e-96f2-4070-bfeb-645a366a3adb	105	Gudang Garam Filter Kecil	22300.00	19348.00	3	66900.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
905	ff3603c7-42f7-4d13-a790-26399c685432	67	Beras Cianjur Sedang	48000.00	41716.00	2	96000.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
906	ff3603c7-42f7-4d13-a790-26399c685432	77	Aqua 600ml Besar	45600.00	39597.00	3	136800.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
907	ff3603c7-42f7-4d13-a790-26399c685432	95	Rinso Anti Noda Besar	14900.00	12880.00	1	14900.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
908	ff3603c7-42f7-4d13-a790-26399c685432	114	Saus ABC Sedang	41900.00	36362.00	1	41900.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
909	0df10c7f-1284-40c9-8c41-21a925ee0eb1	83	Susu Indomilk Sedang	1200.00	1011.00	3	3600.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
910	537c6ae6-7ac3-40e8-afe0-249fbf996e9d	77	Aqua 600ml Besar	45600.00	39597.00	3	136800.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
911	0f913f1d-a45e-4933-bb5d-0dcd67b48e14	71	Gula Pasir Gulaku Sedang	22400.00	19400.00	1	22400.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
912	0f913f1d-a45e-4933-bb5d-0dcd67b48e14	79	Kopi Kapal Api Kecil	3400.00	2944.00	1	3400.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
913	0f913f1d-a45e-4933-bb5d-0dcd67b48e14	92	Chocolatos Sedang	54700.00	47524.00	1	54700.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
914	0f913f1d-a45e-4933-bb5d-0dcd67b48e14	101	Pepsodent Sedang	36100.00	31369.00	3	108300.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
915	8a84aca9-17f5-4b34-9aba-ce417d7788af	70	Gula Pasir Gulaku Kecil	11800.00	10241.00	2	23600.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
916	8a84aca9-17f5-4b34-9aba-ce417d7788af	75	Aqua 600ml Kecil	57000.00	49488.00	2	114000.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
917	8a84aca9-17f5-4b34-9aba-ce417d7788af	92	Chocolatos Sedang	54700.00	47524.00	1	54700.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
918	8a84aca9-17f5-4b34-9aba-ce417d7788af	110	Royco Ayam Kecil	39200.00	34012.00	2	78400.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
919	78fe7023-96e9-4d80-86e7-c6d41b83354f	96	Sunlight Kecil	50000.00	43455.00	1	50000.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
920	4746975d-3433-4c5c-a982-dd316fa316b1	88	Chitato Kecil	18700.00	16186.00	3	56100.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
921	4746975d-3433-4c5c-a982-dd316fa316b1	95	Rinso Anti Noda Besar	14900.00	12880.00	2	29800.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
922	e342e291-9540-42cf-9b91-83545d2c0282	112	Kecap Bango Kecil	40500.00	35137.00	3	121500.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
923	fbe82d55-50c4-48dc-87c7-b8db12280e6a	66	Beras Cianjur Kecil	3200.00	2735.00	2	6400.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
924	fbe82d55-50c4-48dc-87c7-b8db12280e6a	100	Pepsodent Kecil	7200.00	6193.00	3	21600.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
925	fbe82d55-50c4-48dc-87c7-b8db12280e6a	106	Djarum Super Kecil	49900.00	43380.00	1	49900.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
926	fbe82d55-50c4-48dc-87c7-b8db12280e6a	112	Kecap Bango Kecil	40500.00	35137.00	3	121500.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
927	33720b9d-0bb3-49dd-8f55-acda2bad60c8	89	Taro Kecil	56400.00	48958.00	2	112800.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
928	33720b9d-0bb3-49dd-8f55-acda2bad60c8	91	Chocolatos Kecil	37400.00	32505.00	1	37400.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
929	33720b9d-0bb3-49dd-8f55-acda2bad60c8	110	Royco Ayam Kecil	39200.00	34012.00	2	78400.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
930	f4c6b6d3-99ee-407e-a204-eaa0029872ff	83	Susu Indomilk Sedang	1200.00	1011.00	2	2400.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
931	f4c6b6d3-99ee-407e-a204-eaa0029872ff	85	Indomie Goreng Kecil	16200.00	14030.00	1	16200.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
932	f4c6b6d3-99ee-407e-a204-eaa0029872ff	108	Masako Sapi Sedang	23200.00	20132.00	2	46400.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
933	cd7a476c-c8d5-421a-8982-5b03429f760c	88	Chitato Kecil	18700.00	16186.00	2	37400.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
934	cd7a476c-c8d5-421a-8982-5b03429f760c	93	Rinso Anti Noda Kecil	30400.00	26391.00	1	30400.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
935	cd7a476c-c8d5-421a-8982-5b03429f760c	99	Lifebuoy Kecil	4000.00	3439.00	2	8000.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
936	b3087cfa-bac9-46cd-9deb-e52087ac1e18	108	Masako Sapi Sedang	23200.00	20132.00	3	69600.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
937	b3087cfa-bac9-46cd-9deb-e52087ac1e18	113	Saus ABC Kecil	27100.00	23550.00	3	81300.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
938	9c124cc5-a7b6-448b-8890-23380cbe2ddf	69	Minyak Goreng Bimoli Sedang	52800.00	45888.00	1	52800.00	2026-02-16 20:41:39	2026-02-16 20:41:39	\N
939	6f67a262-389c-42de-9525-890d792411b5	80	Kopi Kapal Api Sedang	45100.00	39184.00	1	45100.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
940	6f67a262-389c-42de-9525-890d792411b5	94	Rinso Anti Noda Sedang	22500.00	19550.00	1	22500.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
941	6f67a262-389c-42de-9525-890d792411b5	103	Sampoerna Mild Kecil	37100.00	32210.00	3	111300.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
942	f4f1e4d3-fb5e-475d-9694-6f78193366c8	66	Beras Cianjur Kecil	3200.00	2735.00	2	6400.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
943	f4f1e4d3-fb5e-475d-9694-6f78193366c8	107	Masako Sapi Kecil	10000.00	8679.00	3	30000.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
944	f4f1e4d3-fb5e-475d-9694-6f78193366c8	108	Masako Sapi Sedang	23200.00	20132.00	2	46400.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
945	f4f1e4d3-fb5e-475d-9694-6f78193366c8	112	Kecap Bango Kecil	40500.00	35137.00	2	81000.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
946	fb797629-0597-41b6-a3d6-55d115635e44	82	Susu Indomilk Kecil	15400.00	13361.00	3	46200.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
947	8a2582aa-95a2-4530-b08b-fe66f8cede61	71	Gula Pasir Gulaku Sedang	22400.00	19400.00	2	44800.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
948	8a2582aa-95a2-4530-b08b-fe66f8cede61	75	Aqua 600ml Kecil	57000.00	49488.00	1	57000.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
949	8a2582aa-95a2-4530-b08b-fe66f8cede61	82	Susu Indomilk Kecil	15400.00	13361.00	2	30800.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
950	8a2582aa-95a2-4530-b08b-fe66f8cede61	105	Gudang Garam Filter Kecil	22300.00	19348.00	3	66900.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
951	5b41714f-2bc4-46bf-b6e7-4442f00c1bff	75	Aqua 600ml Kecil	57000.00	49488.00	3	171000.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
952	5b41714f-2bc4-46bf-b6e7-4442f00c1bff	77	Aqua 600ml Besar	45600.00	39597.00	1	45600.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
953	5b41714f-2bc4-46bf-b6e7-4442f00c1bff	91	Chocolatos Kecil	37400.00	32505.00	2	74800.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
954	5b41714f-2bc4-46bf-b6e7-4442f00c1bff	110	Royco Ayam Kecil	39200.00	34012.00	2	78400.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
955	7b9d34a4-765b-49ef-8ac0-d59beedc11d6	74	Telur Ayam Sedang	6200.00	5381.00	3	18600.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
956	7b9d34a4-765b-49ef-8ac0-d59beedc11d6	78	Teh Pucuk Harum Kecil	14700.00	12715.00	1	14700.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
957	eff31b71-230b-4452-b8f5-2e8b31c645eb	75	Aqua 600ml Kecil	57000.00	49488.00	1	57000.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
958	eff31b71-230b-4452-b8f5-2e8b31c645eb	100	Pepsodent Kecil	7200.00	6193.00	1	7200.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
959	eff31b71-230b-4452-b8f5-2e8b31c645eb	101	Pepsodent Sedang	36100.00	31369.00	2	72200.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
960	8f76782e-e024-4318-9f15-98f6d6fed88c	110	Royco Ayam Kecil	39200.00	34012.00	2	78400.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
961	25977f24-cdb8-432d-b67e-76f696ff6ee3	69	Minyak Goreng Bimoli Sedang	52800.00	45888.00	3	158400.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
962	25977f24-cdb8-432d-b67e-76f696ff6ee3	70	Gula Pasir Gulaku Kecil	11800.00	10241.00	1	11800.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
963	25977f24-cdb8-432d-b67e-76f696ff6ee3	106	Djarum Super Kecil	49900.00	43380.00	1	49900.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
964	25977f24-cdb8-432d-b67e-76f696ff6ee3	112	Kecap Bango Kecil	40500.00	35137.00	2	81000.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
965	2b442b28-d806-4d3e-b55b-e88e8eb04e82	79	Kopi Kapal Api Kecil	3400.00	2944.00	1	3400.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
966	2b442b28-d806-4d3e-b55b-e88e8eb04e82	88	Chitato Kecil	18700.00	16186.00	1	18700.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
967	7ce3b96c-146f-4d61-ac1e-41cfebd7c6a8	75	Aqua 600ml Kecil	57000.00	49488.00	3	171000.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
968	7ce3b96c-146f-4d61-ac1e-41cfebd7c6a8	99	Lifebuoy Kecil	4000.00	3439.00	1	4000.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
969	7ce3b96c-146f-4d61-ac1e-41cfebd7c6a8	110	Royco Ayam Kecil	39200.00	34012.00	3	117600.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
970	24219aa0-0bc6-499b-b1d2-070936e1d2aa	76	Aqua 600ml Sedang	17200.00	14885.00	2	34400.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
971	24219aa0-0bc6-499b-b1d2-070936e1d2aa	77	Aqua 600ml Besar	45600.00	39597.00	2	91200.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
972	64232d2e-43bf-4477-bd56-640cccd20a81	67	Beras Cianjur Sedang	48000.00	41716.00	1	48000.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
973	64232d2e-43bf-4477-bd56-640cccd20a81	110	Royco Ayam Kecil	39200.00	34012.00	2	78400.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
974	64232d2e-43bf-4477-bd56-640cccd20a81	113	Saus ABC Kecil	27100.00	23550.00	1	27100.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
975	e294ebcb-3ade-49d2-ba5a-4aaaa05bdf38	72	Gula Pasir Gulaku Besar	21600.00	18761.00	3	64800.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
976	e294ebcb-3ade-49d2-ba5a-4aaaa05bdf38	102	Pepsodent Besar	43000.00	37308.00	2	86000.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
977	2791cb11-3bf8-4333-9eaf-a3b8771df088	83	Susu Indomilk Sedang	1200.00	1011.00	1	1200.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
978	2791cb11-3bf8-4333-9eaf-a3b8771df088	86	Sarimi Kecil	46200.00	40117.00	1	46200.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
979	5095f47a-957b-4199-9210-fb68fe4b7612	86	Sarimi Kecil	46200.00	40117.00	3	138600.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
980	5095f47a-957b-4199-9210-fb68fe4b7612	101	Pepsodent Sedang	36100.00	31369.00	3	108300.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
981	5095f47a-957b-4199-9210-fb68fe4b7612	114	Saus ABC Sedang	41900.00	36362.00	2	83800.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
982	68833413-152d-4265-974b-4930be090e82	69	Minyak Goreng Bimoli Sedang	52800.00	45888.00	2	105600.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
983	68833413-152d-4265-974b-4930be090e82	86	Sarimi Kecil	46200.00	40117.00	2	92400.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
984	20933749-2a8f-4bc7-b366-887f7d3c4139	89	Taro Kecil	56400.00	48958.00	3	169200.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
985	b07a6ee2-f011-4e1c-b25f-7b7d60ab41fc	114	Saus ABC Sedang	41900.00	36362.00	2	83800.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
986	6dd3ccec-5783-44fd-82a2-d128c8df8045	105	Gudang Garam Filter Kecil	22300.00	19348.00	1	22300.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
987	6dd3ccec-5783-44fd-82a2-d128c8df8045	112	Kecap Bango Kecil	40500.00	35137.00	1	40500.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
988	d4ea9ee7-a910-4524-8893-441e58a7cb68	78	Teh Pucuk Harum Kecil	14700.00	12715.00	1	14700.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
989	d4ea9ee7-a910-4524-8893-441e58a7cb68	83	Susu Indomilk Sedang	1200.00	1011.00	1	1200.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
990	d4ea9ee7-a910-4524-8893-441e58a7cb68	84	Susu Indomilk Besar	9500.00	8191.00	1	9500.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
991	d4ea9ee7-a910-4524-8893-441e58a7cb68	89	Taro Kecil	56400.00	48958.00	2	112800.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
992	86be78cb-8573-409c-b3d4-18b98253c022	69	Minyak Goreng Bimoli Sedang	52800.00	45888.00	2	105600.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
993	86be78cb-8573-409c-b3d4-18b98253c022	85	Indomie Goreng Kecil	16200.00	14030.00	2	32400.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
994	86be78cb-8573-409c-b3d4-18b98253c022	114	Saus ABC Sedang	41900.00	36362.00	3	125700.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
995	3820db60-a65b-4fed-a285-b22b92d2760e	112	Kecap Bango Kecil	40500.00	35137.00	1	40500.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
996	48f7a7ee-baee-4282-ab41-0a51f4748593	81	Kopi Kapal Api Besar	21400.00	18559.00	1	21400.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
997	48f7a7ee-baee-4282-ab41-0a51f4748593	92	Chocolatos Sedang	54700.00	47524.00	2	109400.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
998	48f7a7ee-baee-4282-ab41-0a51f4748593	106	Djarum Super Kecil	49900.00	43380.00	3	149700.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
999	bc3fd44d-2056-4ac0-920a-6e4142ad4738	90	Taro Sedang	56700.00	49263.00	3	170100.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
1000	bd6cacba-82db-4d1f-a6f6-dba7ec4a96ad	70	Gula Pasir Gulaku Kecil	11800.00	10241.00	3	35400.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
1001	bd6cacba-82db-4d1f-a6f6-dba7ec4a96ad	95	Rinso Anti Noda Besar	14900.00	12880.00	3	44700.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
1002	30a7e30c-3b52-43ee-9847-dbb367e7ccf0	87	Sarimi Sedang	51200.00	44461.00	1	51200.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
1003	30a7e30c-3b52-43ee-9847-dbb367e7ccf0	90	Taro Sedang	56700.00	49263.00	1	56700.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
1004	30a7e30c-3b52-43ee-9847-dbb367e7ccf0	94	Rinso Anti Noda Sedang	22500.00	19550.00	3	67500.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
1005	7d4f3958-379c-456f-a919-169e49624270	67	Beras Cianjur Sedang	48000.00	41716.00	3	144000.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
1006	7d4f3958-379c-456f-a919-169e49624270	70	Gula Pasir Gulaku Kecil	11800.00	10241.00	3	35400.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
1007	7d4f3958-379c-456f-a919-169e49624270	75	Aqua 600ml Kecil	57000.00	49488.00	2	114000.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
1008	7d4f3958-379c-456f-a919-169e49624270	92	Chocolatos Sedang	54700.00	47524.00	2	109400.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
1009	ddad3d22-589e-4be4-8268-903348883e2e	109	Masako Sapi Besar	28000.00	24328.00	3	84000.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
1010	bbb136ed-4db9-40ef-b9ff-ea6384033449	76	Aqua 600ml Sedang	17200.00	14885.00	2	34400.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
1011	bbb136ed-4db9-40ef-b9ff-ea6384033449	94	Rinso Anti Noda Sedang	22500.00	19550.00	2	45000.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
1012	bbb136ed-4db9-40ef-b9ff-ea6384033449	104	Sampoerna Mild Sedang	35900.00	31151.00	1	35900.00	2026-02-16 20:41:40	2026-02-16 20:41:40	\N
1013	3e064ffb-cf31-43e8-b91c-c75feca623dc	73	Telur Ayam Kecil	35400.00	30754.00	3	106200.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1014	3e064ffb-cf31-43e8-b91c-c75feca623dc	83	Susu Indomilk Sedang	1200.00	1011.00	2	2400.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1015	3e064ffb-cf31-43e8-b91c-c75feca623dc	84	Susu Indomilk Besar	9500.00	8191.00	1	9500.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1016	3e064ffb-cf31-43e8-b91c-c75feca623dc	90	Taro Sedang	56700.00	49263.00	3	170100.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1017	0ae956b3-5857-40d3-b60e-97ec88f3a244	79	Kopi Kapal Api Kecil	3400.00	2944.00	1	3400.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1018	0ae956b3-5857-40d3-b60e-97ec88f3a244	96	Sunlight Kecil	50000.00	43455.00	2	100000.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1019	0ae956b3-5857-40d3-b60e-97ec88f3a244	104	Sampoerna Mild Sedang	35900.00	31151.00	1	35900.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1020	354430f1-2527-4edd-b375-f7264f41d50f	78	Teh Pucuk Harum Kecil	14700.00	12715.00	3	44100.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1021	7092b1a4-f5d0-427b-af1a-09d1b64ce16d	67	Beras Cianjur Sedang	48000.00	41716.00	3	144000.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1022	7092b1a4-f5d0-427b-af1a-09d1b64ce16d	98	Sunlight Besar	8800.00	7622.00	2	17600.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1023	7092b1a4-f5d0-427b-af1a-09d1b64ce16d	102	Pepsodent Besar	43000.00	37308.00	2	86000.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1024	7092b1a4-f5d0-427b-af1a-09d1b64ce16d	109	Masako Sapi Besar	28000.00	24328.00	2	56000.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1025	554401ed-f3c8-4dd0-ac49-9af0c6b0ece1	73	Telur Ayam Kecil	35400.00	30754.00	1	35400.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1026	554401ed-f3c8-4dd0-ac49-9af0c6b0ece1	83	Susu Indomilk Sedang	1200.00	1011.00	1	1200.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1027	554401ed-f3c8-4dd0-ac49-9af0c6b0ece1	89	Taro Kecil	56400.00	48958.00	1	56400.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1028	554401ed-f3c8-4dd0-ac49-9af0c6b0ece1	101	Pepsodent Sedang	36100.00	31369.00	2	72200.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1029	87a397cc-c686-4c64-978c-75bf338082a3	69	Minyak Goreng Bimoli Sedang	52800.00	45888.00	1	52800.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1030	87a397cc-c686-4c64-978c-75bf338082a3	79	Kopi Kapal Api Kecil	3400.00	2944.00	3	10200.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1031	87a397cc-c686-4c64-978c-75bf338082a3	100	Pepsodent Kecil	7200.00	6193.00	3	21600.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1032	1585ddd5-3ac0-4f16-95a3-ffa37dab9a6c	67	Beras Cianjur Sedang	48000.00	41716.00	3	144000.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1033	1585ddd5-3ac0-4f16-95a3-ffa37dab9a6c	109	Masako Sapi Besar	28000.00	24328.00	2	56000.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1034	1585ddd5-3ac0-4f16-95a3-ffa37dab9a6c	114	Saus ABC Sedang	41900.00	36362.00	1	41900.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1035	19c241e1-adb1-4e3e-a2c2-b9e7db113696	79	Kopi Kapal Api Kecil	3400.00	2944.00	3	10200.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1036	19c241e1-adb1-4e3e-a2c2-b9e7db113696	113	Saus ABC Kecil	27100.00	23550.00	1	27100.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1037	3fcb2441-4105-446d-a152-c09bcc46919a	67	Beras Cianjur Sedang	48000.00	41716.00	2	96000.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1038	3fcb2441-4105-446d-a152-c09bcc46919a	75	Aqua 600ml Kecil	57000.00	49488.00	1	57000.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1039	3fcb2441-4105-446d-a152-c09bcc46919a	88	Chitato Kecil	18700.00	16186.00	2	37400.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1040	93f97d4c-f935-45a9-9273-f937e1b6b9a4	75	Aqua 600ml Kecil	57000.00	49488.00	2	114000.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1041	93f97d4c-f935-45a9-9273-f937e1b6b9a4	96	Sunlight Kecil	50000.00	43455.00	3	150000.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1042	93f97d4c-f935-45a9-9273-f937e1b6b9a4	98	Sunlight Besar	8800.00	7622.00	1	8800.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1043	5a6b18ec-826c-4b94-9020-214b862d4632	87	Sarimi Sedang	51200.00	44461.00	2	102400.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1044	5a6b18ec-826c-4b94-9020-214b862d4632	91	Chocolatos Kecil	37400.00	32505.00	3	112200.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1045	5a6b18ec-826c-4b94-9020-214b862d4632	106	Djarum Super Kecil	49900.00	43380.00	3	149700.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1046	cca5f8a9-67d9-4e05-ac07-5ac113868649	71	Gula Pasir Gulaku Sedang	22400.00	19400.00	3	67200.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1047	cca5f8a9-67d9-4e05-ac07-5ac113868649	100	Pepsodent Kecil	7200.00	6193.00	3	21600.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1048	cca5f8a9-67d9-4e05-ac07-5ac113868649	113	Saus ABC Kecil	27100.00	23550.00	1	27100.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1049	19fb0a2e-13cc-43cd-b0dc-812675d85a70	87	Sarimi Sedang	51200.00	44461.00	2	102400.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1050	19fb0a2e-13cc-43cd-b0dc-812675d85a70	99	Lifebuoy Kecil	4000.00	3439.00	1	4000.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1051	19fb0a2e-13cc-43cd-b0dc-812675d85a70	110	Royco Ayam Kecil	39200.00	34012.00	2	78400.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1052	39fc5c77-58b5-4986-8b6b-6df3eee20604	93	Rinso Anti Noda Kecil	30400.00	26391.00	3	91200.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1053	39fc5c77-58b5-4986-8b6b-6df3eee20604	104	Sampoerna Mild Sedang	35900.00	31151.00	2	71800.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1054	e7c995a9-d384-4824-833c-0d9c3eb4f583	78	Teh Pucuk Harum Kecil	14700.00	12715.00	2	29400.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1055	e7c995a9-d384-4824-833c-0d9c3eb4f583	112	Kecap Bango Kecil	40500.00	35137.00	2	81000.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1056	cc3e329c-757a-42ff-8594-9e09a91c5be2	69	Minyak Goreng Bimoli Sedang	52800.00	45888.00	2	105600.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1057	cc3e329c-757a-42ff-8594-9e09a91c5be2	71	Gula Pasir Gulaku Sedang	22400.00	19400.00	2	44800.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1058	cc3e329c-757a-42ff-8594-9e09a91c5be2	89	Taro Kecil	56400.00	48958.00	2	112800.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1059	3fd9a1de-2e81-44c6-809e-d1ee51cbf203	81	Kopi Kapal Api Besar	21400.00	18559.00	3	64200.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1060	2598e10d-98bf-4433-b35f-d459e5c61e47	77	Aqua 600ml Besar	45600.00	39597.00	1	45600.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1061	2598e10d-98bf-4433-b35f-d459e5c61e47	81	Kopi Kapal Api Besar	21400.00	18559.00	1	21400.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1062	2598e10d-98bf-4433-b35f-d459e5c61e47	107	Masako Sapi Kecil	10000.00	8679.00	2	20000.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1063	ecdbf687-66d7-4cd5-9ecc-a9a781415f24	72	Gula Pasir Gulaku Besar	21600.00	18761.00	2	43200.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1064	ecdbf687-66d7-4cd5-9ecc-a9a781415f24	90	Taro Sedang	56700.00	49263.00	1	56700.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1065	ecdbf687-66d7-4cd5-9ecc-a9a781415f24	112	Kecap Bango Kecil	40500.00	35137.00	3	121500.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1066	64fda2a1-4db7-4de4-9aa5-259fd17a6981	74	Telur Ayam Sedang	6200.00	5381.00	1	6200.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1067	64fda2a1-4db7-4de4-9aa5-259fd17a6981	108	Masako Sapi Sedang	23200.00	20132.00	1	23200.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1068	64fda2a1-4db7-4de4-9aa5-259fd17a6981	111	Royco Ayam Sedang	20200.00	17555.00	3	60600.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1069	752f6c69-9a72-48df-a07c-0d25de02091a	71	Gula Pasir Gulaku Sedang	22400.00	19400.00	2	44800.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1070	752f6c69-9a72-48df-a07c-0d25de02091a	88	Chitato Kecil	18700.00	16186.00	3	56100.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1071	752f6c69-9a72-48df-a07c-0d25de02091a	99	Lifebuoy Kecil	4000.00	3439.00	2	8000.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1072	afc84a08-8503-404b-9162-3e8dd1c1e945	66	Beras Cianjur Kecil	3200.00	2735.00	2	6400.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1073	afc84a08-8503-404b-9162-3e8dd1c1e945	68	Minyak Goreng Bimoli Kecil	2200.00	1910.00	1	2200.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1074	afc84a08-8503-404b-9162-3e8dd1c1e945	101	Pepsodent Sedang	36100.00	31369.00	2	72200.00	2026-02-16 20:41:41	2026-02-16 20:41:41	\N
1076	55161f9e-74f9-4c27-8d03-c7df4993026f	17	Minyak Goreng 2L	38000.00	32000.00	20	760000.00	2026-02-17 04:47:03	2026-02-17 04:47:03	\N
1077	8e629cc1-d0b0-424d-8cce-528fb0bf3a70	17	Minyak Goreng 2L	38000.00	32000.00	3	114000.00	2026-02-17 04:48:58	2026-02-17 04:48:58	\N
1078	1339ec0e-6d13-4a4b-a81f-a0ebe168b96d	18	Beras Pandan Wangi 5kg	72000.00	65000.00	2	144000.00	2026-02-17 05:04:13	2026-02-17 05:04:13	\N
1079	1339ec0e-6d13-4a4b-a81f-a0ebe168b96d	15	Aqua 600ml	3500.00	2800.00	5	17500.00	2026-02-17 05:04:13	2026-02-17 05:04:13	\N
1080	1339ec0e-6d13-4a4b-a81f-a0ebe168b96d	11	Indomie Goreng	3000.00	2500.00	1	3000.00	2026-02-17 05:04:13	2026-02-17 05:04:13	\N
1081	1339ec0e-6d13-4a4b-a81f-a0ebe168b96d	12	Telur Ayam (Butir)	2000.00	1600.00	1	2000.00	2026-02-17 05:04:13	2026-02-17 05:04:13	\N
1082	1339ec0e-6d13-4a4b-a81f-a0ebe168b96d	14	Kopi Kapal Api 165g	12500.00	10000.00	1	12500.00	2026-02-17 05:04:13	2026-02-17 05:04:13	\N
1083	1339ec0e-6d13-4a4b-a81f-a0ebe168b96d	10	Payung Pelangi (Seasonal)	45000.00	30000.00	6	270000.00	2026-02-17 05:04:13	2026-02-17 05:04:13	\N
1084	96b2b416-9c8e-4e57-b30c-84e4a967c0f8	10	Payung Pelangi (Seasonal)	45000.00	30000.00	1	45000.00	2026-02-17 05:45:52	2026-02-17 05:45:52	\N
1085	96b2b416-9c8e-4e57-b30c-84e4a967c0f8	18	Beras Pandan Wangi 5kg	72000.00	65000.00	1	72000.00	2026-02-17 05:45:52	2026-02-17 05:45:52	\N
1086	96b2b416-9c8e-4e57-b30c-84e4a967c0f8	15	Aqua 600ml	3500.00	2800.00	1	3500.00	2026-02-17 05:45:52	2026-02-17 05:45:52	\N
1087	96b2b416-9c8e-4e57-b30c-84e4a967c0f8	17	Minyak Goreng 2L	38000.00	32000.00	1	38000.00	2026-02-17 05:45:52	2026-02-17 05:45:52	\N
1088	9867497a-8976-4bc9-a365-12bdc617275c	15	Aqua 600ml	3500.00	2800.00	10	35000.00	2026-02-17 05:52:46	2026-02-17 05:52:46	\N
1089	0051a42c-f274-4092-9a17-fdf8de9cb2e5	12	Telur Ayam (Butir)	2000.00	1600.00	99	198000.00	2026-02-17 05:54:09	2026-02-17 05:54:09	\N
\.


--
-- Data for Name: transaction_payments; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.transaction_payments (id, transaction_id, method, amount, reference_number, metadata, created_at, updated_at) FROM stdin;
1	5e477cb6-c92b-4ba7-8845-26bb80c8f377	qris	127136.00	\N	\N	2026-02-16 20:41:07	2026-02-16 20:41:07
2	188cd4d8-50a2-460b-b4bb-bed8626be723	cash	123424.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
3	cb553fda-654c-44ca-a53d-a562a9f97a86	cash	128876.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
4	faaba627-bd2d-4f00-a4f7-9cfb273ae334	cash	52896.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
5	faaba627-bd2d-4f00-a4f7-9cfb273ae334	qris	79344.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
6	d0f196f5-50c5-47c1-b342-a028214b898c	cash	286752.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
7	5767af0c-6ffe-4218-8a74-722e5c2ca4d4	cash	65053.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
8	5767af0c-6ffe-4218-8a74-722e5c2ca4d4	qris	97579.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
9	ab61a75b-fd98-4929-99b6-273a4b851b07	cash	62779.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
10	ab61a75b-fd98-4929-99b6-273a4b851b07	qris	94169.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
11	f7aec63d-c73c-4e93-b29c-26b25a211d8b	qris	92684.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
12	755ebeb1-2656-4022-938e-c61a14915526	cash	86304.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
13	816b3fb4-aaa1-46f5-9262-36eb97b13f82	qris	25056.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
14	889c3bd5-762e-4364-8c48-9539ddca6f7d	cash	21692.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
15	0cc86d72-b836-44b5-a45c-3cd282ae99e7	cash	31204.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
16	fa636cf3-838c-4c5c-8cf6-a3439c778710	cash	25938.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
17	fa636cf3-838c-4c5c-8cf6-a3439c778710	qris	38906.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
18	3b2d9651-9ae3-48ad-bd2e-0e2d81c96f1a	cash	81386.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
19	3b2d9651-9ae3-48ad-bd2e-0e2d81c96f1a	qris	122078.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
20	04341657-1a51-47da-8cf8-268a2ca3044f	cash	58371.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
21	04341657-1a51-47da-8cf8-268a2ca3044f	qris	87557.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
22	0df71fe4-a912-4b64-9bba-e30c3ac575b2	cash	59253.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
23	0df71fe4-a912-4b64-9bba-e30c3ac575b2	qris	88879.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
24	3bd0d3f6-e532-4350-9e2a-957f9f004625	qris	186992.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
25	1dae35b1-efb8-4eed-9fff-0009f2304ba0	cash	157157.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
26	1dae35b1-efb8-4eed-9fff-0009f2304ba0	qris	235735.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
27	b1f17b11-c2de-4202-9a98-fedf9bfb66ea	cash	63684.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
28	17dffab7-7e57-4943-a1a4-ac0155c886ad	cash	160776.00	\N	\N	2026-02-16 20:41:31	2026-02-16 20:41:31
29	bd6a0fa7-54b9-49c2-9c98-a6a908c86173	cash	66027.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
30	bd6a0fa7-54b9-49c2-9c98-a6a908c86173	qris	99041.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
31	7ac302c2-21b2-437a-aeb2-20b896acf23f	cash	37120.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
32	7ac302c2-21b2-437a-aeb2-20b896acf23f	qris	55680.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
33	5e939f2c-bac1-4dc0-b193-e268992f13cb	cash	13920.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
34	5e939f2c-bac1-4dc0-b193-e268992f13cb	qris	20880.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
35	f5c565c6-c6f0-43c6-bcba-5d31dc1e74e5	qris	147436.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
36	fa7d76f1-7196-4693-96fb-63566ef5c487	cash	156020.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
37	2aec118f-a4cd-476e-96f3-59db5bd5f835	qris	105792.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
38	29db4e77-8f4a-4c60-a083-9654af68ec3c	qris	206712.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
39	d4e58079-8a25-4de8-a5c6-9b5c96451dda	qris	14616.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
40	6c48321b-02ee-41bd-bd7e-e9a4b7c38942	cash	29789.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
41	6c48321b-02ee-41bd-bd7e-e9a4b7c38942	qris	44683.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
42	d9e14ae3-1fe7-4959-8201-c8f731050404	cash	23942.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
43	d9e14ae3-1fe7-4959-8201-c8f731050404	qris	35914.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
44	630ad66f-5123-4dba-bde8-b4bc36f02dca	qris	261464.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
45	f7857d14-155f-4fc0-95e0-ed248941a8e1	qris	195228.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
46	3de2cbbe-e4d5-48c3-b158-0773a0b08bb5	cash	134444.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
47	aac15ebc-08ec-4ede-999e-9c9511964d88	qris	197200.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
48	52841860-26e7-4f66-b7ae-20f2168eaa4f	cash	22272.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
49	52841860-26e7-4f66-b7ae-20f2168eaa4f	qris	33408.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
50	a39240f9-16d8-44ba-86e0-59afd1a78973	qris	89436.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
51	93a336ba-a29f-42fc-9ed3-c08939fc2d73	qris	146160.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
52	a0750e4f-2683-4a49-b738-6a629470b050	cash	107323.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
53	a0750e4f-2683-4a49-b738-6a629470b050	qris	160985.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
54	b46e0d85-9c45-447a-987e-c2a72a5cc776	qris	88160.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
55	21d3a652-cca7-4048-bf86-c9738d1adb2b	cash	55262.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
56	21d3a652-cca7-4048-bf86-c9738d1adb2b	qris	82894.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
57	ca16cd09-eb8d-4830-95b0-a2755a9e5191	cash	117021.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
58	ca16cd09-eb8d-4830-95b0-a2755a9e5191	qris	175531.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
59	5753e2c1-f568-4d53-bae5-cfc21b2e130e	qris	198824.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
60	f2deae93-e1b9-424b-96dc-79ec953e4c81	cash	254272.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
61	f47251c6-0d4a-4c9c-8a40-89877ab7e2f0	cash	179568.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
62	140f2a61-36d7-4511-afde-b9cc4ca91309	cash	304036.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
63	ca18d04f-a862-4049-bf62-527e91adff1e	cash	51040.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
64	ca18d04f-a862-4049-bf62-527e91adff1e	qris	76560.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
65	91fe449f-c6b3-4662-b746-169a7064592d	cash	92986.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
66	91fe449f-c6b3-4662-b746-169a7064592d	qris	139478.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
67	d9296d04-1239-4ef7-80f3-5604f24cea1e	cash	126858.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
68	d9296d04-1239-4ef7-80f3-5604f24cea1e	qris	190286.00	\N	\N	2026-02-16 20:41:32	2026-02-16 20:41:32
69	1c70a1a3-bb8b-41e4-bf2f-7da6f978c13b	qris	421080.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
70	71c38cdb-0ed2-42a7-8f88-25ae6d7fd22d	cash	109643.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
71	71c38cdb-0ed2-42a7-8f88-25ae6d7fd22d	qris	164465.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
72	68beb82e-0973-4324-880c-7b04bed64302	cash	52618.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
73	68beb82e-0973-4324-880c-7b04bed64302	qris	78926.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
74	402dbb8a-c672-412c-bc05-048ce9968925	qris	426300.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
75	b9388272-3e90-41f3-b7f3-813ed5c7c11d	qris	122728.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
76	673f8872-9fb2-424d-a5d1-21c1eed8253b	cash	28118.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
77	673f8872-9fb2-424d-a5d1-21c1eed8253b	qris	42178.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
78	1c192a8b-d9db-4b86-9edd-95837eef4030	cash	102312.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
79	ba93216c-6d7c-4011-b459-ed06f394edbe	cash	85051.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
80	ba93216c-6d7c-4011-b459-ed06f394edbe	qris	127577.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
81	9a8a681a-d77c-4994-85c6-90b4e4440afd	qris	188848.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
82	c14f59a5-2136-4f10-8235-91e7f1b0f546	cash	98275.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
83	c14f59a5-2136-4f10-8235-91e7f1b0f546	qris	147413.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
84	0b3402c7-5d73-48f4-a15b-315d2a534d17	qris	37584.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
85	9357d77b-a00d-4560-92ad-31c0ac320f6f	qris	124932.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
86	573e34bf-258d-44d5-a54e-d7856b68ede0	cash	33060.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
87	25be66d7-9581-489f-83b1-febcdc470f35	cash	166924.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
88	670b4ab2-f567-48fd-aadb-e33164ff68b6	qris	232928.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
89	88cd91ff-4ffc-43d8-b9c4-c43c4f79e36c	cash	6682.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
90	88cd91ff-4ffc-43d8-b9c4-c43c4f79e36c	qris	10022.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
91	51a3d4f3-03b8-4298-982c-0e5e012d1179	cash	124004.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
92	5eae991a-2fe4-4ac2-ae66-aa1d3ac50f4b	cash	89691.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
93	5eae991a-2fe4-4ac2-ae66-aa1d3ac50f4b	qris	134537.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
94	9b80e947-3300-4a6b-a549-5e1ecc09ffbe	cash	151496.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
95	f4e4ebea-d755-4011-8e7a-dc3e496ff736	cash	46214.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
96	f4e4ebea-d755-4011-8e7a-dc3e496ff736	qris	69322.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
97	5b2640ff-c500-4039-82aa-acfd0606e5e8	cash	86072.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
98	5b2640ff-c500-4039-82aa-acfd0606e5e8	qris	129108.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
99	b2db0df6-777d-4845-9d5a-641cf11af0ab	cash	38976.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
100	b2db0df6-777d-4845-9d5a-641cf11af0ab	qris	58464.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
101	1262f0eb-2d22-4a19-b4e6-a3f7a7b539e8	qris	97440.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
102	b379a906-50c7-4e01-a884-a23b38538452	cash	16426.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
103	b379a906-50c7-4e01-a884-a23b38538452	qris	24638.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
104	ba115e9e-e7e3-4f3a-b924-74b4cf455b0c	qris	284664.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
105	49ef21c7-0f33-4c80-8e37-ecfc37284e48	cash	17284.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
106	4cc66a87-bb46-4a42-924e-8aa7b38d9c84	qris	59392.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
107	c93aaf29-db26-4eaf-a902-7c22011c86ae	qris	152424.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
108	27a02e4e-1e1d-42a7-a589-08e3e0621897	qris	190356.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
109	3869e47e-4e65-4df2-8571-b130e3a6a5dd	cash	545200.00	\N	\N	2026-02-16 20:41:33	2026-02-16 20:41:33
110	0084ad8c-2c77-403f-945e-687d0dbd2c94	cash	7192.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
111	f0726e45-9a56-4283-80e5-303855703739	cash	214832.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
112	5bd2cfbd-60c4-4598-9559-4c1b5fdd7c64	cash	112056.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
113	44bc517f-73b2-48b1-8814-04ae7a9bc140	cash	79344.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
114	44bc517f-73b2-48b1-8814-04ae7a9bc140	qris	119016.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
115	9ab2fac5-26a6-4532-b374-b420d8a59dd8	cash	3712.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
116	319cfc37-a843-415b-a3ca-671d1b2fee7f	cash	4640.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
117	a85b793d-0b06-44f7-8c03-aef42c83d2e6	cash	251140.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
118	d4c38f8b-beef-4e9b-b047-ae41669173fa	cash	426764.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
119	d4c42702-5b8a-4bfc-9487-11c4b165b2af	cash	251604.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
120	573071ac-6b8e-46c2-8a24-a5a268514fa2	cash	116974.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
121	573071ac-6b8e-46c2-8a24-a5a268514fa2	qris	175462.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
122	fa36c357-80b5-474c-8c4f-6a9e61d2a5af	cash	21390.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
123	fa36c357-80b5-474c-8c4f-6a9e61d2a5af	qris	32086.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
124	9c102d66-244b-4cb0-be80-e6015358c9fa	cash	63475.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
125	9c102d66-244b-4cb0-be80-e6015358c9fa	qris	95213.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
126	e6f20d82-cd87-4b16-baf4-84f904690f7b	cash	218196.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
127	b1e132b3-d7b9-4087-975c-a0541babdd64	qris	190008.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
128	52bb003f-f071-4912-b25b-8e0edbf15fa5	cash	38976.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
129	52bb003f-f071-4912-b25b-8e0edbf15fa5	qris	58464.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
130	dc05ab3e-09d2-4e1f-95c4-b377810ee858	cash	54520.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
131	bf4dc0af-63b2-46dd-994a-06424729c944	cash	210540.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
132	8d40426f-c6b4-487e-aa2d-7221519b6dbe	cash	131126.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
133	8d40426f-c6b4-487e-aa2d-7221519b6dbe	qris	196690.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
134	eda548ed-f927-46cb-830b-83b20ccd8022	cash	41064.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
135	9ecd10b4-041c-425a-b796-31b40fa03863	cash	156948.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
136	abff2755-8130-4d9c-8dc4-f38e0e966a64	cash	98948.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
137	61b00242-a837-4a18-abdd-dd07d383d530	cash	104864.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
138	012ec076-3007-4f41-926b-6bcc33aa7e3d	cash	113100.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
139	a8fd022b-8fc2-4f84-b2af-bfe672bd0764	qris	116464.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
140	b6484477-3a80-49e5-8cb6-097a7e846159	cash	21854.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
141	b6484477-3a80-49e5-8cb6-097a7e846159	qris	32782.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
142	8693f9a6-8fd1-48ee-8382-ec04f236363b	cash	40832.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
143	902b7857-f135-422f-9ed8-d6feb1695f26	cash	69600.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
144	902b7857-f135-422f-9ed8-d6feb1695f26	qris	104400.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
145	f922cded-c77d-41af-8436-e70baf9c879e	cash	22272.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
146	f922cded-c77d-41af-8436-e70baf9c879e	qris	33408.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
147	6b783b0f-3b49-4a65-9c9c-b2410fceb2f4	cash	134142.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
148	6b783b0f-3b49-4a65-9c9c-b2410fceb2f4	qris	201214.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
149	eb7fcbd5-5f3d-4718-9135-a41dba47f598	qris	64960.00	\N	\N	2026-02-16 20:41:34	2026-02-16 20:41:34
150	372a3b10-9ab2-44a2-9275-fa2502bfbffd	qris	285244.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
151	2c3843e3-b93f-4839-9dd4-f5d18b952da8	cash	3712.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
152	2c3843e3-b93f-4839-9dd4-f5d18b952da8	qris	5568.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
153	4d390ca9-ab3c-492f-97e5-d59520c61260	qris	143608.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
154	e0245869-a089-49f9-93a6-1d0acc533390	qris	69020.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
155	68886fa9-980a-46d7-a9f4-52c364a61014	cash	52896.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
156	9ad4664c-c878-4d1d-9bdb-f032e106db12	cash	177364.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
157	b6dec020-a18d-493d-b0d0-e39c7c7e73ea	cash	25474.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
158	b6dec020-a18d-493d-b0d0-e39c7c7e73ea	qris	38210.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
159	e8e84890-a48d-47fe-8dc0-0452a67a625e	cash	60784.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
160	c2c17b7c-308c-4f0b-b7b7-2a48b44f9020	cash	126811.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
161	c2c17b7c-308c-4f0b-b7b7-2a48b44f9020	qris	190217.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
162	eaf4ecf0-bb64-42f0-bc88-c629b421342c	qris	77604.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
163	90a4b29f-8fb6-4af0-b3cb-b87344cdf3a2	cash	115722.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
164	90a4b29f-8fb6-4af0-b3cb-b87344cdf3a2	qris	173582.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
165	d72e46af-bc79-447f-b58c-8deb6f576cd0	qris	255200.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
166	8b531270-8c24-41df-934e-bf642dbc85b8	qris	288260.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
167	cf5a03ec-3d18-40d8-9268-b30fe10fba44	cash	252068.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
168	5fc397ed-cd75-4f0e-9c64-af4486862e69	qris	163444.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
169	1292bd85-1b11-4fbb-9819-dccd17187f39	cash	334080.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
170	9a8b6a9c-153a-41ae-a4e9-2a2ac543452a	qris	93960.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
171	6168162f-13e8-4121-9d8b-f2f8de4631c6	qris	196272.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
172	41bb4ccb-76b5-4468-b57b-7f042f292803	qris	201724.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
173	eaa6d66c-0403-47d6-a718-d56e77b3532d	qris	486040.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
174	2b670aba-39aa-43e5-a1e1-d2c653939ec7	cash	24267.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
175	2b670aba-39aa-43e5-a1e1-d2c653939ec7	qris	36401.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
176	8e0032f7-30da-41d2-a09b-087b9fa72a01	qris	238612.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
177	1df1fc5e-040e-4906-b876-624bb9a8b57b	cash	205436.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
178	872a4a7f-cb1a-49f1-a523-414e3f71bcd7	qris	128296.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
179	bcf057b7-d1a8-4668-b13e-09123991d9b3	cash	63452.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
180	c786161e-b934-4608-aeec-cfb60f649faf	cash	22272.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
181	c786161e-b934-4608-aeec-cfb60f649faf	qris	33408.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
182	0e80dffc-a496-47a3-9719-37f21704887a	cash	149454.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
183	0e80dffc-a496-47a3-9719-37f21704887a	qris	224182.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
184	08966db7-4bbf-43f8-9c88-9db67951da5f	cash	39440.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
185	882b98ee-d441-4eb8-9899-ab5f48d40095	cash	231420.00	\N	\N	2026-02-16 20:41:35	2026-02-16 20:41:35
186	3f65b885-52e5-41f4-990f-20790d1f514a	qris	277240.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
187	9cfc4602-47a6-46dd-aaa5-df172548f889	cash	175276.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
188	e8f55dc4-bdea-4e13-aa87-1a73840b99f8	cash	134792.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
189	e8f55dc4-bdea-4e13-aa87-1a73840b99f8	qris	202188.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
190	9693b3de-60cd-4d8f-bdbb-e49326750f07	cash	150336.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
191	8f2482f4-83a0-49f4-906a-dee0656b7556	cash	185600.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
192	91afe97a-4ea6-43d4-9637-9db715571221	cash	39904.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
193	443a7f86-9d92-4c58-a3e5-05860f8aa8bb	cash	441032.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
194	a6690e6e-c4db-495f-a553-ec8d4d4625a4	qris	170984.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
195	e156cc7d-cef9-49ff-9470-2510d73b88d7	qris	104632.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
196	e1c74394-678f-4e31-acb1-fe90f62caf5c	cash	2970.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
197	e1c74394-678f-4e31-acb1-fe90f62caf5c	qris	4454.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
198	dd3aef88-b443-4e11-966a-44dabc6fc98a	cash	49880.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
199	b937ff03-2a1f-41b4-a268-bc43b293e3de	qris	118088.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
200	a33e7b7c-8990-4caf-af53-e40e53ca0489	cash	58325.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
201	a33e7b7c-8990-4caf-af53-e40e53ca0489	qris	87487.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
202	ccfd956c-57ca-4ebb-ae7c-88f7f00b21c8	cash	102962.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
203	ccfd956c-57ca-4ebb-ae7c-88f7f00b21c8	qris	154442.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
204	a954dd38-8436-4f6d-bdae-5d133c931aae	cash	56144.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
205	a954dd38-8436-4f6d-bdae-5d133c931aae	qris	84216.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
206	7e547f2e-13a6-4053-9300-316b3cd70e23	cash	51968.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
207	a6302bd1-b609-4e39-9f28-aef1efff14b5	qris	191052.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
208	8ca6d724-c5db-45be-aeb1-a182c13a5df0	cash	113216.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
209	add2ef6e-6f45-44d5-b202-356c86cf9842	qris	275616.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
210	4f51fb27-da3a-4efc-98cd-b9279233f57f	cash	327120.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
211	321a1991-ae75-4afb-8cce-fb0adc219cf5	cash	156554.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
212	321a1991-ae75-4afb-8cce-fb0adc219cf5	qris	234830.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
213	40b2b249-158c-426c-8419-1d03b0e3a631	cash	56608.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
214	40b2b249-158c-426c-8419-1d03b0e3a631	qris	84912.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
215	09e7cc38-8d12-4060-af02-5607d574ee79	cash	23339.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
216	09e7cc38-8d12-4060-af02-5607d574ee79	qris	35009.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
217	1ecf4177-369f-4e05-b99b-15d25c9cf9bc	cash	317028.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
218	c2dd7efe-095c-4b16-9b1f-3ce706cb2a56	qris	166112.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
219	99bfea05-7d69-4405-ac58-216446dc46d9	qris	231072.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
220	e8383984-c30b-45d9-b456-059485c57a8a	cash	231420.00	\N	\N	2026-02-16 20:41:36	2026-02-16 20:41:36
221	9ec35e35-0f86-416a-8d84-b9126f8cca86	cash	292900.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
222	d14ca86b-00ce-46f0-836e-4baa61126563	qris	238264.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
223	ecfd457c-a9da-4a9d-b166-a8b119e22512	qris	35728.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
224	bf6c3576-a761-41e4-8634-ea30dae54eb9	cash	21437.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
225	bf6c3576-a761-41e4-8634-ea30dae54eb9	qris	32155.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
226	77661bf5-52ef-4c86-b2dd-44bb9352e38b	cash	257984.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
227	6913e216-5e43-429a-b666-ac4301b6911c	cash	189196.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
228	f3cf17f6-15a5-4775-a10c-ac1020b2f419	cash	60784.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
229	f3cf17f6-15a5-4775-a10c-ac1020b2f419	qris	91176.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
230	7bc46921-2dde-426d-8ba4-678a1858532b	cash	100734.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
231	7bc46921-2dde-426d-8ba4-678a1858532b	qris	151102.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
232	52aa32c3-2532-465e-a07c-e9e6ded2c029	cash	31320.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
233	52aa32c3-2532-465e-a07c-e9e6ded2c029	qris	46980.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
234	3eee2abe-3422-4de6-93ac-01af96978b4a	qris	164604.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
235	299ef771-2ad3-4236-8e56-535a4671154c	cash	310300.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
236	c4ef6536-c759-4750-889b-86d093308ebb	cash	238148.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
237	95e50fd1-eb30-47bc-a994-ebab966b7010	cash	59392.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
238	63cba2a6-10d9-45d5-a11b-c29dbb1f361b	qris	136416.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
239	ffe930cd-cffd-4e60-9ca2-8a08fc1f5a16	qris	114840.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
240	79bf03e7-527e-447f-8302-7abf7e0152ca	qris	43616.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
241	f922b262-bb30-4aa5-a362-a5b86ba600f2	qris	242904.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
242	98926479-995d-423d-9ce5-52fcfc1a0783	cash	19952.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
243	98926479-995d-423d-9ce5-52fcfc1a0783	qris	29928.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
244	4216c01e-f011-409d-9697-95bbab3a0f70	cash	91130.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
245	4216c01e-f011-409d-9697-95bbab3a0f70	qris	136694.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
246	736fb7e1-ada7-44c3-beed-f48acdb133d4	cash	137994.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
247	736fb7e1-ada7-44c3-beed-f48acdb133d4	qris	206990.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
248	ce24dd7e-99eb-4895-a5fa-5cc80e4e4cf4	cash	106534.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
249	ce24dd7e-99eb-4895-a5fa-5cc80e4e4cf4	qris	159802.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
250	118f8065-3a5d-49de-86fa-e670ff64bfe3	cash	76328.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
251	118f8065-3a5d-49de-86fa-e670ff64bfe3	qris	114492.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
252	32d85914-5fd2-4fc9-ac33-37eb478e79b9	cash	28397.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
253	32d85914-5fd2-4fc9-ac33-37eb478e79b9	qris	42595.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
254	56f7f7e8-e154-4fa1-9374-a5198a1ced32	cash	241628.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
255	bdba88e6-dcb0-499c-9f28-2a81c3940f45	cash	16658.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
256	bdba88e6-dcb0-499c-9f28-2a81c3940f45	qris	24986.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
257	a66992e5-e3e0-466c-a185-1b7722921735	cash	99760.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
258	b405e841-0115-43cc-8c65-99345c2e48db	cash	207524.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
259	0b2dd5e8-04ef-4233-b6a1-ac1ca2f2b277	cash	199520.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
260	d458822e-f0b8-4273-8cc1-ffb0784d9a35	qris	197316.00	\N	\N	2026-02-16 20:41:37	2026-02-16 20:41:37
261	a79ce322-349b-4d46-be93-eec40c315c63	cash	252184.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
262	9e0ef86b-485c-477b-85b8-efd4030ebc64	cash	13920.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
263	9e0ef86b-485c-477b-85b8-efd4030ebc64	qris	20880.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
264	9615de99-8c1e-4a91-b177-ed5273aa2a34	cash	115350.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
265	9615de99-8c1e-4a91-b177-ed5273aa2a34	qris	173026.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
266	b8987741-eb62-48bc-a5cf-406843e558bc	cash	52896.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
267	b8987741-eb62-48bc-a5cf-406843e558bc	qris	79344.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
268	01fa55a7-1d6d-4615-a487-f36d8eecfd03	cash	13224.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
269	01fa55a7-1d6d-4615-a487-f36d8eecfd03	qris	19836.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
270	7994d293-d4f9-49a3-922c-2bb38d0e5231	cash	46910.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
271	7994d293-d4f9-49a3-922c-2bb38d0e5231	qris	70366.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
272	e6ac1e5c-b9d3-45d3-afb5-db1ffd4e9d6e	qris	286520.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
273	942d1999-2686-418b-8725-6a2577a65f92	qris	314592.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
274	b7890def-eb0e-4da0-ad60-4da728e71d63	cash	92243.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
275	b7890def-eb0e-4da0-ad60-4da728e71d63	qris	138365.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
276	d63bd6f8-1fa0-41fa-9965-512477bc89be	cash	23200.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
277	d63bd6f8-1fa0-41fa-9965-512477bc89be	qris	34800.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
278	fa8bf67b-964d-4dc7-bc8f-d8672c4295f7	cash	85098.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
279	fa8bf67b-964d-4dc7-bc8f-d8672c4295f7	qris	127646.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
280	995b51ae-bfb4-4dc1-9c9a-d300c57f8eac	qris	226780.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
281	a938fea0-97a9-4b18-9ea7-06b53a306fee	qris	380364.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
282	90d9e660-704a-40da-9d07-a39f9ba8997c	cash	125628.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
283	ab4cd8ae-5408-421a-998f-6225cc1aa6db	cash	157992.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
284	bb6ab572-5b4d-41a7-87c0-3194bb82d3f1	cash	71178.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
285	bb6ab572-5b4d-41a7-87c0-3194bb82d3f1	qris	106766.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
286	55e818c1-bf27-456e-bb22-4a405cc49655	cash	95584.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
287	0c7b090a-f93a-4444-ba60-1c8a77f3f18f	cash	77117.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
288	0c7b090a-f93a-4444-ba60-1c8a77f3f18f	qris	115675.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
289	2781a08a-96bb-4b2b-a212-368272a46873	cash	28118.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
290	2781a08a-96bb-4b2b-a212-368272a46873	qris	42178.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
291	a95ee628-3417-4489-bd23-edae96d54e72	qris	134792.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
292	d5071524-8b0a-4685-a410-f725dd3e8706	qris	345332.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
293	f616be7c-0a16-4bc7-93a6-dede170f9759	cash	8352.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
294	3260eea4-eac1-42a7-ace0-ddefc87b0d7e	qris	183396.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
295	4a59c7ba-9b2d-43dc-98ae-c148265686a4	qris	53592.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
296	cd8f86a1-3c3e-4d37-869a-ab8b2e40db1b	cash	27933.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
297	cd8f86a1-3c3e-4d37-869a-ab8b2e40db1b	qris	41899.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
298	2ef661f1-76df-430f-81f4-820862dadbed	cash	128876.00	\N	\N	2026-02-16 20:41:38	2026-02-16 20:41:38
299	0fb317e1-7b3a-468a-82bd-8d3d8bc6a217	cash	448224.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
300	727caa62-013a-485a-8d6d-e0c51aa61473	cash	104632.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
301	a5879b4a-cf34-46b5-ad07-90c592949d9a	cash	31181.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
302	a5879b4a-cf34-46b5-ad07-90c592949d9a	qris	46771.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
303	cf6fb3cd-c653-4326-b6b7-88d6c4c28f9b	qris	179568.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
304	3ed44ab0-2a5d-4a01-a5ee-f834661802d9	qris	271788.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
305	4fa88121-4abb-4063-b858-5822a394aff5	cash	51156.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
306	ad68e5e5-fed1-45d7-8c59-8aedf23d50b1	cash	23432.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
307	b9a955ba-84ea-4c66-9d2d-d8e126088270	qris	60204.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
308	2cfc2236-89c4-4011-bc08-5ae57653b9c0	cash	83613.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
309	2cfc2236-89c4-4011-bc08-5ae57653b9c0	qris	125419.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
310	f1b769d2-f458-4509-878d-8a962ea00668	cash	65076.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
311	d2ab7468-becb-4a12-947a-1bbeaf16f048	cash	109388.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
312	225aafff-4b82-42ab-bbe7-15174202a14e	cash	166228.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
313	3ae1d235-b61d-411a-8940-4b03bfb044a8	qris	283852.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
314	b0b0ff12-ad8f-4634-a44c-7594c9984832	cash	340924.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
315	04a8f340-dbdb-497d-af21-9ed3afbe7b55	cash	99528.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
316	c1cbb89e-96f2-4070-bfeb-645a366a3adb	cash	129920.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
317	ff3603c7-42f7-4d13-a790-26399c685432	cash	134374.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
318	ff3603c7-42f7-4d13-a790-26399c685432	qris	201562.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
319	0df10c7f-1284-40c9-8c41-21a925ee0eb1	qris	4176.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
320	537c6ae6-7ac3-40e8-afe0-249fbf996e9d	qris	158688.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
321	0f913f1d-a45e-4933-bb5d-0dcd67b48e14	cash	219008.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
322	8a84aca9-17f5-4b34-9aba-ce417d7788af	cash	314012.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
323	78fe7023-96e9-4d80-86e7-c6d41b83354f	cash	23200.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
324	78fe7023-96e9-4d80-86e7-c6d41b83354f	qris	34800.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
325	4746975d-3433-4c5c-a982-dd316fa316b1	cash	99644.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
326	e342e291-9540-42cf-9b91-83545d2c0282	qris	140940.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
327	fbe82d55-50c4-48dc-87c7-b8db12280e6a	cash	231304.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
328	33720b9d-0bb3-49dd-8f55-acda2bad60c8	cash	106070.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
329	33720b9d-0bb3-49dd-8f55-acda2bad60c8	qris	159106.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
330	f4c6b6d3-99ee-407e-a204-eaa0029872ff	cash	75400.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
331	cd7a476c-c8d5-421a-8982-5b03429f760c	cash	35171.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
332	cd7a476c-c8d5-421a-8982-5b03429f760c	qris	52757.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
333	b3087cfa-bac9-46cd-9deb-e52087ac1e18	qris	175044.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
334	9c124cc5-a7b6-448b-8890-23380cbe2ddf	cash	61248.00	\N	\N	2026-02-16 20:41:39	2026-02-16 20:41:39
335	6f67a262-389c-42de-9525-890d792411b5	cash	83010.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
336	6f67a262-389c-42de-9525-890d792411b5	qris	124514.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
337	f4f1e4d3-fb5e-475d-9694-6f78193366c8	cash	76003.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
338	f4f1e4d3-fb5e-475d-9694-6f78193366c8	qris	114005.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
339	fb797629-0597-41b6-a3d6-55d115635e44	cash	53592.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
340	8a2582aa-95a2-4530-b08b-fe66f8cede61	cash	231420.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
341	5b41714f-2bc4-46bf-b6e7-4442f00c1bff	cash	171587.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
342	5b41714f-2bc4-46bf-b6e7-4442f00c1bff	qris	257381.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
343	7b9d34a4-765b-49ef-8ac0-d59beedc11d6	qris	38628.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
344	eff31b71-230b-4452-b8f5-2e8b31c645eb	cash	63290.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
345	eff31b71-230b-4452-b8f5-2e8b31c645eb	qris	94934.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
346	8f76782e-e024-4318-9f15-98f6d6fed88c	qris	90944.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
347	25977f24-cdb8-432d-b67e-76f696ff6ee3	cash	139710.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
348	25977f24-cdb8-432d-b67e-76f696ff6ee3	qris	209566.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
349	2b442b28-d806-4d3e-b55b-e88e8eb04e82	cash	10254.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
350	2b442b28-d806-4d3e-b55b-e88e8eb04e82	qris	15382.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
351	7ce3b96c-146f-4d61-ac1e-41cfebd7c6a8	cash	135766.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
352	7ce3b96c-146f-4d61-ac1e-41cfebd7c6a8	qris	203650.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
353	24219aa0-0bc6-499b-b1d2-070936e1d2aa	cash	145696.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
354	64232d2e-43bf-4477-bd56-640cccd20a81	cash	178060.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
355	e294ebcb-3ade-49d2-ba5a-4aaaa05bdf38	qris	174928.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
356	2791cb11-3bf8-4333-9eaf-a3b8771df088	cash	21994.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
357	2791cb11-3bf8-4333-9eaf-a3b8771df088	qris	32990.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
358	5095f47a-957b-4199-9210-fb68fe4b7612	qris	383612.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
359	68833413-152d-4265-974b-4930be090e82	cash	229680.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
360	20933749-2a8f-4bc7-b366-887f7d3c4139	cash	196272.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
361	b07a6ee2-f011-4e1c-b25f-7b7d60ab41fc	qris	97208.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
362	6dd3ccec-5783-44fd-82a2-d128c8df8045	cash	29139.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
363	6dd3ccec-5783-44fd-82a2-d128c8df8045	qris	43709.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
364	d4ea9ee7-a910-4524-8893-441e58a7cb68	cash	160312.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
365	86be78cb-8573-409c-b3d4-18b98253c022	qris	305892.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
366	3820db60-a65b-4fed-a285-b22b92d2760e	qris	46980.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
367	48f7a7ee-baee-4282-ab41-0a51f4748593	cash	130152.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
368	48f7a7ee-baee-4282-ab41-0a51f4748593	qris	195228.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
369	bc3fd44d-2056-4ac0-920a-6e4142ad4738	cash	197316.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
370	bd6cacba-82db-4d1f-a6f6-dba7ec4a96ad	cash	37166.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
371	bd6cacba-82db-4d1f-a6f6-dba7ec4a96ad	qris	55750.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
372	30a7e30c-3b52-43ee-9847-dbb367e7ccf0	qris	203464.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
373	7d4f3958-379c-456f-a919-169e49624270	qris	467248.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
374	ddad3d22-589e-4be4-8268-903348883e2e	cash	97440.00	\N	\N	2026-02-16 20:41:40	2026-02-16 20:41:40
375	bbb136ed-4db9-40ef-b9ff-ea6384033449	cash	53499.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
376	bbb136ed-4db9-40ef-b9ff-ea6384033449	qris	80249.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
377	3e064ffb-cf31-43e8-b91c-c75feca623dc	qris	334312.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
378	0ae956b3-5857-40d3-b60e-97ec88f3a244	qris	161588.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
379	354430f1-2527-4edd-b375-f7264f41d50f	cash	20462.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
380	354430f1-2527-4edd-b375-f7264f41d50f	qris	30694.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
381	7092b1a4-f5d0-427b-af1a-09d1b64ce16d	cash	352176.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
382	554401ed-f3c8-4dd0-ac49-9af0c6b0ece1	cash	191632.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
383	87a397cc-c686-4c64-978c-75bf338082a3	qris	98136.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
384	1585ddd5-3ac0-4f16-95a3-ffa37dab9a6c	cash	280604.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
385	19c241e1-adb1-4e3e-a2c2-b9e7db113696	qris	43268.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
386	3fcb2441-4105-446d-a152-c09bcc46919a	cash	88346.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
387	3fcb2441-4105-446d-a152-c09bcc46919a	qris	132518.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
388	93f97d4c-f935-45a9-9273-f937e1b6b9a4	qris	316448.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
389	5a6b18ec-826c-4b94-9020-214b862d4632	cash	169035.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
390	5a6b18ec-826c-4b94-9020-214b862d4632	qris	253553.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
391	cca5f8a9-67d9-4e05-ac07-5ac113868649	cash	53778.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
392	cca5f8a9-67d9-4e05-ac07-5ac113868649	qris	80666.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
393	19fb0a2e-13cc-43cd-b0dc-812675d85a70	cash	85747.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
394	19fb0a2e-13cc-43cd-b0dc-812675d85a70	qris	128621.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
395	39fc5c77-58b5-4986-8b6b-6df3eee20604	qris	189080.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
396	e7c995a9-d384-4824-833c-0d9c3eb4f583	cash	128064.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
397	cc3e329c-757a-42ff-8594-9e09a91c5be2	qris	305312.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
398	3fd9a1de-2e81-44c6-809e-d1ee51cbf203	qris	74472.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
399	2598e10d-98bf-4433-b35f-d459e5c61e47	qris	100920.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
400	ecdbf687-66d7-4cd5-9ecc-a9a781415f24	qris	256824.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
401	64fda2a1-4db7-4de4-9aa5-259fd17a6981	cash	41760.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
402	64fda2a1-4db7-4de4-9aa5-259fd17a6981	qris	62640.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
403	752f6c69-9a72-48df-a07c-0d25de02091a	cash	50530.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
404	752f6c69-9a72-48df-a07c-0d25de02091a	qris	75794.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
405	afc84a08-8503-404b-9162-3e8dd1c1e945	qris	93728.00	\N	\N	2026-02-16 20:41:41	2026-02-16 20:41:41
439	fbf581b7-886b-4c62-b8a0-d226c2ce616e	cash	1387500.00	\N	[]	2026-02-17 04:46:32	2026-02-17 04:46:32
440	55161f9e-74f9-4c27-8d03-c7df4993026f	cash	843600.00	\N	[]	2026-02-17 04:47:03	2026-02-17 04:47:03
441	8e629cc1-d0b0-424d-8cce-528fb0bf3a70	cash	126540.00	\N	[]	2026-02-17 04:48:58	2026-02-17 04:48:58
442	1339ec0e-6d13-4a4b-a81f-a0ebe168b96d	cash	498390.00	\N	[]	2026-02-17 05:04:13	2026-02-17 05:04:13
443	96b2b416-9c8e-4e57-b30c-84e4a967c0f8	cash	175935.00	\N	[]	2026-02-17 05:45:52	2026-02-17 05:45:52
444	9867497a-8976-4bc9-a365-12bdc617275c	cash	38850.00	\N	[]	2026-02-17 05:52:46	2026-02-17 05:52:46
445	0051a42c-f274-4092-9a17-fdf8de9cb2e5	cash	219780.00	\N	[]	2026-02-17 05:54:09	2026-02-17 05:54:09
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.transactions (id, store_id, user_id, invoice_number, subtotal, tax, discount, grand_total, cash_received, change_amount, payment_method, status, notes, transaction_date, created_at, updated_at, customer_id, points_earned, points_redeemed, service_charge, payment_details) FROM stdin;
e19775f2-4c09-4a3d-a52e-e4d775764841	2	1	INV-Y6GP5S	68000.00	0.00	1534.00	66466.00	\N	\N	cash	completed	\N	2026-02-04 19:43:30	2026-02-04 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
8fdb74d9-3039-4230-8da4-ed607ab0a3de	2	1	INV-0CFMEE	75500.00	0.00	0.00	75500.00	\N	\N	cash	completed	\N	2026-02-13 19:43:30	2026-02-13 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
67f7d382-fb06-46b0-ac42-2cdf052163a6	2	1	INV-WZGEFT	15000.00	0.00	1511.00	13489.00	\N	\N	cash	completed	\N	2026-01-27 19:43:30	2026-01-27 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
1bd5ae39-c836-4837-9562-17bd1f678fae	2	1	INV-56LWT4	3500.00	0.00	13189.00	0.00	\N	\N	cash	voided	\N	2026-01-25 19:43:30	2026-01-25 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
3fe2fdd9-d026-420a-8541-d4fc3a64f9af	2	1	INV-FV7U4R	146000.00	0.00	1973.00	144027.00	\N	\N	cash	completed	\N	2026-02-15 19:43:30	2026-02-15 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
d935a3b7-79e3-4b37-ac8a-9cb441950553	2	1	INV-RLL3X5	172500.00	0.00	13326.00	159174.00	\N	\N	cash	voided	\N	2026-02-01 19:43:30	2026-02-01 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
896f95d8-6cb4-4f50-93bd-3fa9d2cb9e8c	2	1	INV-RYOCOR	10000.00	0.00	1935.00	8065.00	\N	\N	cash	completed	\N	2026-01-24 19:43:30	2026-01-24 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
c8eb6c8b-fb01-4864-8e3e-4106f7247be4	2	1	INV-P4SEHY	162500.00	0.00	0.00	162500.00	\N	\N	cash	completed	\N	2026-01-17 19:43:30	2026-01-17 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
4ecf7b26-0467-4290-8177-523d0b92f378	2	1	INV-46MERC	217500.00	0.00	1468.00	216032.00	\N	\N	cash	completed	\N	2026-01-28 19:43:30	2026-01-28 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
e414a2e1-a60e-4b63-a70a-30b2d9f84574	2	1	INV-WCNVM3	172500.00	0.00	1165.00	171335.00	\N	\N	cash	completed	\N	2026-01-18 19:43:30	2026-01-18 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
910ed1a1-84a4-435f-9a29-ddb7f1e5b142	2	1	INV-RRPCEQ	80000.00	0.00	1365.00	78635.00	\N	\N	cash	completed	\N	2026-02-12 19:43:30	2026-02-12 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
47562087-9dc9-4664-b4b1-6ee46e0f36ec	2	1	INV-ZRTMLV	190000.00	0.00	0.00	190000.00	\N	\N	cash	completed	\N	2026-02-12 19:43:30	2026-02-12 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
0e26c949-70e8-46d5-b61b-4953f5514d85	2	1	INV-BFWHGM	216000.00	0.00	687.00	215313.00	\N	\N	cash	completed	\N	2026-01-23 19:43:30	2026-01-23 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
930c072b-eae1-41e1-b35d-8b9a363f9bdd	2	1	INV-ATAKFM	115000.00	0.00	0.00	115000.00	\N	\N	cash	completed	\N	2026-01-23 19:43:30	2026-01-23 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
9e262acc-de56-4e2d-b538-d7d2cf727594	2	1	INV-BVYNHN	126000.00	0.00	1333.00	124667.00	\N	\N	cash	completed	\N	2026-02-10 19:43:30	2026-02-10 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
a1f49d61-ff2e-4ed4-8ef2-08924f175006	2	1	INV-3ORQ87	15000.00	0.00	16808.00	0.00	\N	\N	cash	voided	\N	2026-01-31 19:43:30	2026-01-31 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
b6f4cf8e-2d74-420b-b194-216af81f9843	2	1	INV-J5CPQD	129500.00	0.00	0.00	129500.00	\N	\N	cash	completed	\N	2026-02-09 19:43:30	2026-02-09 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
ef777660-08ce-416f-b271-5410ca8245fb	2	1	INV-DLHIQX	129500.00	0.00	500.00	129000.00	\N	\N	cash	completed	\N	2026-02-16 19:43:30	2026-02-16 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
777a3290-96d4-4527-8c85-7356375f88cc	2	1	INV-SMKCQG	93000.00	0.00	1854.00	91146.00	\N	\N	cash	completed	\N	2026-01-26 19:43:30	2026-01-26 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
e43e2d56-582b-4183-8f90-f8b41c9ba1ae	2	1	INV-H0AHG0	167500.00	0.00	636.00	166864.00	\N	\N	cash	completed	\N	2026-01-27 19:43:30	2026-01-27 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
99e684bc-7482-4612-9b81-40f091524d2e	2	1	INV-OA3PHM	186500.00	0.00	10361.00	176139.00	\N	\N	cash	completed	\N	2026-01-19 19:43:30	2026-01-19 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
9ce5a8f4-5a9f-47e5-a6c6-a35923a8077f	2	1	INV-NSSZTB	120500.00	0.00	1940.00	118560.00	\N	\N	cash	completed	\N	2026-02-02 19:43:30	2026-02-02 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
2fe9bb7a-aff8-4726-b0e9-7318fca0e9c2	2	1	INV-ACJM42	126500.00	0.00	0.00	126500.00	\N	\N	cash	completed	\N	2026-02-07 19:43:30	2026-02-07 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
f5a94489-123f-4735-8e1f-5011c3053ef0	2	1	INV-NZDER2	18000.00	0.00	13803.00	4197.00	\N	\N	cash	voided	\N	2026-01-31 19:43:30	2026-01-31 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
3865d84f-6e17-40eb-b36b-d7c3433ca0fa	2	1	INV-20AA0J	111500.00	0.00	0.00	111500.00	\N	\N	cash	completed	\N	2026-01-22 19:43:30	2026-01-22 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
3d9cf173-44cc-4cba-a5b9-03a316ef5b3c	2	1	INV-OGVAQK	57500.00	0.00	0.00	57500.00	\N	\N	cash	completed	\N	2026-01-18 19:43:30	2026-01-18 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
1d23af7f-6aad-43a0-a732-dbeb04301c18	2	1	INV-IJLZCW	50000.00	0.00	0.00	50000.00	\N	\N	cash	completed	\N	2026-01-31 19:43:30	2026-01-31 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
a2fda4b0-c347-4f85-a97b-dac3038ac8ff	2	1	INV-A180IF	164500.00	0.00	1454.00	163046.00	\N	\N	cash	completed	\N	2026-02-11 19:43:30	2026-02-11 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
c4aee52a-1a09-4b85-baaa-731d94b44198	2	1	INV-RL1C8C	88500.00	0.00	16464.00	72036.00	\N	\N	cash	completed	\N	2026-01-28 19:43:30	2026-01-28 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
9b317cd1-c671-4c9f-bd63-ec5d6cee4c84	2	1	INV-N7NYOL	83500.00	0.00	1354.00	82146.00	\N	\N	cash	completed	\N	2026-02-07 19:43:30	2026-02-07 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
c520da17-9d33-4efa-9f67-3f5fde72e632	2	1	INV-LHE25L	85000.00	0.00	560.00	84440.00	\N	\N	cash	completed	\N	2026-01-31 19:43:30	2026-01-31 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
3893b580-4d8e-4273-a9c8-f261b13da3a0	2	1	INV-MJC6IW	10000.00	0.00	12818.00	0.00	\N	\N	cash	completed	\N	2026-01-30 19:43:30	2026-01-30 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
a993ec25-32ef-43ff-8007-d8127a028d34	2	1	INV-HT7LVX	7000.00	0.00	0.00	7000.00	\N	\N	cash	completed	\N	2026-02-01 19:43:30	2026-02-01 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
a41c8f44-0d4f-4414-b0fe-13a0a3113e04	2	1	INV-FL2XZR	86000.00	0.00	13075.00	72925.00	\N	\N	cash	voided	\N	2026-01-30 19:43:30	2026-01-30 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
795fb205-e5e2-41f4-924e-3bd9513954a6	2	1	INV-4URABN	164000.00	0.00	1937.00	162063.00	\N	\N	cash	completed	\N	2026-01-29 19:43:30	2026-01-29 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
40b0bc5e-ddac-485a-a776-1df532ad5687	2	1	INV-EMEHMW	64000.00	0.00	19488.00	44512.00	\N	\N	cash	voided	\N	2026-02-14 19:43:30	2026-02-14 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
85e3961f-c8ee-4bad-a5ee-3f59da48857c	2	1	INV-NBZQWU	103500.00	0.00	11149.00	92351.00	\N	\N	cash	completed	\N	2026-01-21 19:43:30	2026-01-21 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
1168e0a6-b698-40e3-b2fd-c39976621990	2	1	INV-BGYRYL	148000.00	0.00	0.00	148000.00	\N	\N	cash	completed	\N	2026-01-25 19:43:30	2026-01-25 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
46bd4af5-f0cb-4a65-b8e5-fb2019f2394a	2	1	INV-VFAXQC	143500.00	0.00	801.00	142699.00	\N	\N	cash	completed	\N	2026-02-02 19:43:30	2026-02-02 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
f92fd45b-d265-45d6-b121-c71d95c1fce2	2	1	INV-ILSTHG	128000.00	0.00	1434.00	126566.00	\N	\N	cash	completed	\N	2026-01-26 19:43:30	2026-01-26 19:43:30	2026-02-16 19:43:30	\N	0	0	0.00	\N
4a1399c7-fb76-4cfa-ae76-87908f95a347	2	1	INV-2YSVQ1	118000.00	0.00	0.00	118000.00	\N	\N	cash	completed	\N	2026-02-11 19:43:40	2026-02-11 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
c7589117-6882-428b-93ed-0fe0f7b93eaa	2	1	INV-FIAIAF	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-27 19:43:40	2026-01-27 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
6af2bc44-a64f-4e9d-857b-28e7043547f6	2	1	INV-KS71BY	100000.00	0.00	0.00	100000.00	\N	\N	cash	completed	\N	2026-01-30 19:43:40	2026-01-30 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
3476ef29-57c5-4ecf-a824-831ca6a7f54b	2	1	INV-MWOPOF	82500.00	0.00	19990.00	62510.00	\N	\N	cash	voided	\N	2026-01-24 19:43:40	2026-01-24 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
480e397a-990b-442a-a007-85331a069aee	2	1	INV-R2TCFF	21500.00	0.00	0.00	21500.00	\N	\N	cash	completed	\N	2026-01-28 19:43:40	2026-01-28 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
9f420fea-97a9-4c81-8501-afcc9daf7fc7	2	1	INV-IHH7SO	63000.00	0.00	1657.00	61343.00	\N	\N	cash	completed	\N	2026-01-25 19:43:40	2026-01-25 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
b328802c-76eb-4401-9bee-6fbf09971eb0	2	1	INV-BS2KKZ	140500.00	0.00	12835.00	127665.00	\N	\N	cash	voided	\N	2026-02-07 19:43:40	2026-02-07 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
7c047853-25a3-4e64-8e9c-d3d02fded9cd	2	1	INV-HWTORF	157000.00	0.00	0.00	157000.00	\N	\N	cash	completed	\N	2026-01-23 19:43:40	2026-01-23 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
76a79014-5c29-45eb-93e4-51423aab86ff	2	1	INV-DRBLND	258000.00	0.00	0.00	258000.00	\N	\N	cash	completed	\N	2026-01-31 19:43:40	2026-01-31 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
69474cb0-83f7-48c9-982e-bd48245d0713	2	1	INV-DKVLUA	160500.00	0.00	18862.00	141638.00	\N	\N	cash	voided	\N	2026-01-31 19:43:40	2026-01-31 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
e092acc9-87ce-4e23-9cfd-62edf8424923	2	1	INV-YBU4XQ	238500.00	0.00	0.00	238500.00	\N	\N	cash	completed	\N	2026-02-09 19:43:40	2026-02-09 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
0c5f1629-1d6b-4b98-ad71-e00b32a9a7e8	2	1	INV-AD2XN5	201500.00	0.00	1617.00	199883.00	\N	\N	cash	completed	\N	2026-02-09 19:43:40	2026-02-09 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
909e636d-a723-4e65-bb49-d45ec7379325	2	1	INV-7KUL15	28000.00	0.00	685.00	27315.00	\N	\N	cash	completed	\N	2026-02-15 19:43:40	2026-02-15 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
47e7bd48-0ad2-4b3d-84d5-577daf099a92	2	1	INV-XNF2WB	128500.00	0.00	1287.00	127213.00	\N	\N	cash	completed	\N	2026-02-09 19:43:40	2026-02-09 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
32d1ed78-1d65-41aa-8184-5c89a77a19f7	2	1	INV-GCT1VF	180000.00	0.00	976.00	179024.00	\N	\N	cash	completed	\N	2026-02-06 19:43:40	2026-02-06 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
090f1737-2f97-45d9-a3e2-0817ba0eecf1	2	1	INV-CMR41P	71500.00	0.00	1406.00	70094.00	\N	\N	cash	completed	\N	2026-01-31 19:43:40	2026-01-31 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
4dbb9ad6-b45c-49db-b7b5-a285aef4547c	2	1	INV-JV2UDO	130000.00	0.00	803.00	129197.00	\N	\N	cash	completed	\N	2026-01-17 19:43:40	2026-01-17 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
7e2f1399-3c2e-40c9-9b6f-abf333767a29	2	1	INV-M30AXP	89000.00	0.00	0.00	89000.00	\N	\N	cash	completed	\N	2026-02-01 19:43:40	2026-02-01 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
e51532b6-4470-4077-8e9b-510f5fe12065	2	1	INV-5P16FQ	177000.00	0.00	0.00	177000.00	\N	\N	cash	completed	\N	2026-02-04 19:43:40	2026-02-04 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
48e3ba53-e77d-4943-a936-dc1cb0aa8bd0	2	1	INV-6DX3QA	122000.00	0.00	18741.00	103259.00	\N	\N	cash	completed	\N	2026-01-20 19:43:40	2026-01-20 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
cd592b0b-1847-47de-9ed8-76d9f8b8ebd3	2	1	INV-FNHQLC	55000.00	0.00	0.00	55000.00	\N	\N	cash	completed	\N	2026-02-11 19:43:40	2026-02-11 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
61fac846-88de-42c6-be5c-ae89af43e49d	2	1	INV-XKTEDS	103500.00	0.00	1009.00	102491.00	\N	\N	cash	completed	\N	2026-02-16 19:43:40	2026-02-16 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
21eb245e-1e9a-42c3-ad68-0852c5e91b65	2	1	INV-4GIDOD	5000.00	0.00	0.00	5000.00	\N	\N	cash	completed	\N	2026-02-16 19:43:40	2026-02-16 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
de718915-795c-484a-8652-a161a0301cc9	2	1	INV-5LKMEB	15000.00	0.00	1695.00	13305.00	\N	\N	cash	completed	\N	2026-01-20 19:43:40	2026-01-20 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
34b3c1ca-97f6-46df-918c-edee8a7c8491	2	1	INV-4USGWZ	174000.00	0.00	1666.00	172334.00	\N	\N	cash	completed	\N	2026-01-28 19:43:40	2026-01-28 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
6eb493c6-1989-4c59-b0cd-cb88b75f3880	2	1	INV-3REZ1S	39500.00	0.00	0.00	39500.00	\N	\N	cash	completed	\N	2026-02-15 19:43:40	2026-02-15 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
bc1a285b-2630-4e16-b3fd-e742d1ee8ed1	2	1	INV-N79KUH	69500.00	0.00	1882.00	67618.00	\N	\N	cash	completed	\N	2026-02-06 19:43:40	2026-02-06 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
d24826f8-0579-45d9-9289-7f962f29a35c	2	1	INV-PQIJX4	167000.00	0.00	0.00	167000.00	\N	\N	cash	completed	\N	2026-01-17 19:43:40	2026-01-17 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
392c8a5a-aed7-4dad-a144-3f96161e011a	2	1	INV-GE88MS	46500.00	0.00	0.00	46500.00	\N	\N	cash	completed	\N	2026-02-03 19:43:40	2026-02-03 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
17845fc6-0ee1-477e-8be8-6fce95d8fe38	2	1	INV-XQVZKH	325500.00	0.00	0.00	325500.00	\N	\N	cash	completed	\N	2026-01-17 19:43:40	2026-01-17 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
7adf56b4-fe7c-4ab9-a76c-e0847340042c	2	1	INV-TSHTF2	150000.00	0.00	17539.00	132461.00	\N	\N	cash	completed	\N	2026-02-07 19:43:40	2026-02-07 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
028c7c54-8250-4eeb-86e2-76b2f7126101	2	1	INV-37FPJH	150000.00	0.00	0.00	150000.00	\N	\N	cash	completed	\N	2026-02-09 19:43:40	2026-02-09 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
bd767d99-cc96-478d-984f-7eae3b6af74d	2	1	INV-BNRX2A	296000.00	0.00	1280.00	294720.00	\N	\N	cash	completed	\N	2026-01-31 19:43:40	2026-01-31 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
0a46dc37-ba75-4a61-a0f1-5aab9204beee	2	1	INV-DWV8VR	140000.00	0.00	1376.00	138624.00	\N	\N	cash	completed	\N	2026-01-31 19:43:40	2026-01-31 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
e9387f4b-4bb9-4bd9-a14c-58820b48bfe9	2	1	INV-DUWK1V	46500.00	0.00	1765.00	44735.00	\N	\N	cash	completed	\N	2026-01-23 19:43:40	2026-01-23 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
fe83f2a3-bb3e-443f-8896-bc0293b5be1e	2	1	INV-VPCIRV	100000.00	0.00	19143.00	80857.00	\N	\N	cash	completed	\N	2026-02-09 19:43:40	2026-02-09 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
96ad07f0-504c-4ac6-bfb3-2f247be0e925	2	1	INV-HHVRXY	221000.00	0.00	580.00	220420.00	\N	\N	cash	completed	\N	2026-02-10 19:43:40	2026-02-10 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
39eee413-657b-4835-bdfb-b3b072342e2d	2	1	INV-DIRZCR	36000.00	0.00	11245.00	24755.00	\N	\N	cash	voided	\N	2026-01-29 19:43:40	2026-01-29 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
39918064-a463-4197-9908-f7dd2d085a7d	2	1	INV-V7MXG6	13500.00	0.00	13852.00	0.00	\N	\N	cash	voided	\N	2026-01-26 19:43:40	2026-01-26 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
789c5c48-4016-468d-972d-6b089e039e3e	2	1	INV-QIVNST	167500.00	0.00	0.00	167500.00	\N	\N	cash	completed	\N	2026-02-08 19:43:40	2026-02-08 19:43:40	2026-02-16 19:43:40	\N	0	0	0.00	\N
a4b2698b-355a-4e5e-b576-145d82b9e568	1	1	INV-STABLE-0	65000.00	0.00	0.00	65000.00	\N	\N	cash	completed	\N	2026-02-16 19:56:09	2026-02-16 19:56:09	2026-02-16 19:56:09	\N	0	0	0.00	\N
b5166ea4-8bc1-4e8f-ac34-f51b375e369a	1	1	INV-STABLE-1	65000.00	0.00	0.00	65000.00	\N	\N	cash	completed	\N	2026-02-15 19:56:09	2026-02-16 19:56:09	2026-02-16 19:56:09	\N	0	0	0.00	\N
0fdd5b59-734e-4f24-b393-187ad611801f	1	1	INV-STABLE-2	65000.00	0.00	0.00	65000.00	\N	\N	cash	completed	\N	2026-02-14 19:56:09	2026-02-16 19:56:09	2026-02-16 19:56:09	\N	0	0	0.00	\N
f2ffdc94-4c49-49b6-b826-ef134f1e3149	1	1	INV-STABLE-3	65000.00	0.00	0.00	65000.00	\N	\N	cash	completed	\N	2026-02-13 19:56:09	2026-02-16 19:56:09	2026-02-16 19:56:09	\N	0	0	0.00	\N
ec6348a0-655b-43fb-b984-043fb530f61f	1	1	INV-STABLE-4	65000.00	0.00	0.00	65000.00	\N	\N	cash	completed	\N	2026-02-12 19:56:09	2026-02-16 19:56:09	2026-02-16 19:56:09	\N	0	0	0.00	\N
11efdb24-ad1c-4004-9455-37274108c749	1	1	INV-STABLE-5	65000.00	0.00	0.00	65000.00	\N	\N	cash	completed	\N	2026-02-11 19:56:09	2026-02-16 19:56:09	2026-02-16 19:56:09	\N	0	0	0.00	\N
7ba0a887-206b-4e2a-a24d-b0cdc87fbd3c	1	1	INV-STABLE-6	65000.00	0.00	0.00	65000.00	\N	\N	cash	completed	\N	2026-02-10 19:56:09	2026-02-16 19:56:09	2026-02-16 19:56:09	\N	0	0	0.00	\N
726ce1d6-7e12-42af-aaa6-e208feb9a513	1	1	INV-STABLE-7	65000.00	0.00	0.00	65000.00	\N	\N	cash	completed	\N	2026-02-09 19:56:09	2026-02-16 19:56:09	2026-02-16 19:56:09	\N	0	0	0.00	\N
92b71709-6fe5-4ad5-a9fb-64a56fbe6ded	1	1	INV-STABLE-8	65000.00	0.00	0.00	65000.00	\N	\N	cash	completed	\N	2026-02-08 19:56:09	2026-02-16 19:56:09	2026-02-16 19:56:09	\N	0	0	0.00	\N
2c09d976-01d2-4643-ae7c-70e28a00b67d	1	1	INV-STABLE-9	65000.00	0.00	0.00	65000.00	\N	\N	cash	completed	\N	2026-02-07 19:56:09	2026-02-16 19:56:09	2026-02-16 19:56:09	\N	0	0	0.00	\N
d7e78646-3900-4d49-b8d7-6a422c25f1c9	1	1	INV-STABLE-10	65000.00	0.00	0.00	65000.00	\N	\N	cash	completed	\N	2026-02-06 19:56:09	2026-02-16 19:56:09	2026-02-16 19:56:09	\N	0	0	0.00	\N
018ac2e9-9141-43cb-8dfb-694a46cf0ae1	1	1	INV-STABLE-11	65000.00	0.00	0.00	65000.00	\N	\N	cash	completed	\N	2026-02-05 19:56:09	2026-02-16 19:56:09	2026-02-16 19:56:09	\N	0	0	0.00	\N
f9f3579a-78f5-4c76-88c7-f743ee5ed0af	1	1	INV-STABLE-12	65000.00	0.00	0.00	65000.00	\N	\N	cash	completed	\N	2026-02-04 19:56:09	2026-02-16 19:56:09	2026-02-16 19:56:09	\N	0	0	0.00	\N
1c6929b6-4dee-4707-b11e-433ddcf44a6c	1	1	INV-STABLE-13	65000.00	0.00	0.00	65000.00	\N	\N	cash	completed	\N	2026-02-03 19:56:09	2026-02-16 19:56:09	2026-02-16 19:56:09	\N	0	0	0.00	\N
046cfe40-2a4d-4e32-a76b-37a21b3f5a10	1	1	INV-BUNDLE-0	5000.00	0.00	0.00	5000.00	\N	\N	cash	completed	\N	2026-02-16 19:56:09	2026-02-16 19:56:09	2026-02-16 19:56:09	\N	0	0	0.00	\N
20a93432-b1ca-445a-9ed9-770b95393e4f	1	1	INV-BUNDLE-1	5000.00	0.00	0.00	5000.00	\N	\N	cash	completed	\N	2026-02-15 19:56:09	2026-02-16 19:56:09	2026-02-16 19:56:09	\N	0	0	0.00	\N
56832812-dcd1-4068-8410-482121f97812	1	1	INV-BUNDLE-2	5000.00	0.00	0.00	5000.00	\N	\N	cash	completed	\N	2026-02-14 19:56:09	2026-02-16 19:56:09	2026-02-16 19:56:09	\N	0	0	0.00	\N
f8ee2591-4a80-4209-8de3-88c0b9a8372d	1	1	INV-BUNDLE-3	5000.00	0.00	0.00	5000.00	\N	\N	cash	completed	\N	2026-02-13 19:56:09	2026-02-16 19:56:09	2026-02-16 19:56:09	\N	0	0	0.00	\N
5eaa3d3e-3945-44de-a24b-d0964a301e48	1	1	INV-BUNDLE-4	5000.00	0.00	0.00	5000.00	\N	\N	cash	completed	\N	2026-02-12 19:56:09	2026-02-16 19:56:09	2026-02-16 19:56:09	\N	0	0	0.00	\N
632796d2-ff9e-4028-a821-7815eca85603	1	1	INV-TREND-OLD-7	25000.00	0.00	0.00	25000.00	\N	\N	cash	completed	\N	2026-02-09 19:59:11	2026-02-16 19:59:11	2026-02-16 19:59:11	\N	0	0	0.00	\N
f929ed8c-5254-4e44-b25a-32b49c90afb2	1	1	INV-TREND-OLD-8	25000.00	0.00	0.00	25000.00	\N	\N	cash	completed	\N	2026-02-08 19:59:11	2026-02-16 19:59:11	2026-02-16 19:59:11	\N	0	0	0.00	\N
fc24bf0f-77e9-4f41-ad4c-2c75adf02320	1	1	INV-TREND-OLD-9	25000.00	0.00	0.00	25000.00	\N	\N	cash	completed	\N	2026-02-07 19:59:11	2026-02-16 19:59:11	2026-02-16 19:59:11	\N	0	0	0.00	\N
bd39c505-3017-44b5-b88f-5ef5ec762523	1	1	INV-TREND-OLD-10	25000.00	0.00	0.00	25000.00	\N	\N	cash	completed	\N	2026-02-06 19:59:11	2026-02-16 19:59:11	2026-02-16 19:59:11	\N	0	0	0.00	\N
e4a4e0f3-46de-4b86-8695-2c850f1767c5	1	1	INV-TREND-OLD-11	25000.00	0.00	0.00	25000.00	\N	\N	cash	completed	\N	2026-02-05 19:59:11	2026-02-16 19:59:11	2026-02-16 19:59:11	\N	0	0	0.00	\N
c0fc9684-ab0d-4796-abf2-a27f31fd59e5	1	1	INV-TREND-NEW	12500.00	0.00	0.00	12500.00	\N	\N	cash	completed	\N	2026-02-14 19:59:11	2026-02-16 19:59:11	2026-02-16 19:59:11	\N	0	0	0.00	\N
0ced3e3d-dee9-4f02-9019-bf78ce8d237e	1	1	INV-FAST-0-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-25 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
00c2dc66-976d-4ea4-9656-e1a38f5e3859	1	1	INV-FAST-1-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-18 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
2addd6a6-7556-44f7-8381-de9e27dbd241	1	1	INV-FAST-2-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-31 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
1ffde618-10b1-440b-9a07-1931bcba2304	1	1	INV-FAST-3-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-15 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
570e4667-e767-4936-a915-e4566bdb3ae4	1	1	INV-FAST-4-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-01 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
eaa24753-24be-4114-8d7f-4ea9e1793c4c	1	1	INV-FAST-5-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-09 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
d1606108-c1d0-45c6-93a9-cf255445e5a7	1	1	INV-FAST-6-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-25 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
a2a4b0e2-178d-48f5-a46f-157c6d8f4914	1	1	INV-FAST-7-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-28 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
73f4e714-112c-4dc3-95cc-972ab67ba2fd	1	1	INV-FAST-8-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-09 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
3966fa1a-8f1a-4f15-8dc3-3ddc70687d32	1	1	INV-FAST-9-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-15 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
0f0be040-55f8-499c-b5d3-fe95f1e630f5	1	1	INV-FAST-10-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-28 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
a53e8fc8-2cba-40e1-8a72-be490bca225b	1	1	INV-FAST-11-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-25 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
d52b4652-75ab-4abd-ac65-46de6a486433	1	1	INV-FAST-12-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-04 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
eea617a1-acd0-450c-9e68-da7175fed81d	1	1	INV-FAST-13-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-07 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
ad9979ab-36f0-4b8f-bbc0-cb9dc645b1c1	1	1	INV-FAST-14-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-10 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
60bd654c-2689-4c8a-986c-140f9e56ffdf	1	1	INV-FAST-15-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-10 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
d1d38a49-df7b-4731-8a89-ce7f28bc2f64	1	1	INV-FAST-16-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-01 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
23836234-7d35-45d8-9e37-e3d5a049611d	1	1	INV-FAST-17-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-23 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
0227b536-cdd3-4ebf-920b-d09e59dae02b	1	1	INV-FAST-18-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-27 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
df350a1f-525d-49a8-86d9-68cf252a0c83	1	1	INV-FAST-19-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-27 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
409167f2-bece-450a-b1f0-32c21f2a7d34	1	1	INV-FAST-20-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-08 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
c52a0218-2ca8-4968-b357-38551e59e162	1	1	INV-FAST-21-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-28 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
1292fb71-60d7-4b49-8264-ac906c808f64	1	1	INV-FAST-22-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-04 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
de50dc71-8be7-4cce-8a79-553b74665f74	1	1	INV-FAST-23-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-23 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
3d14bac8-8322-4949-9c11-c590a6db489e	1	1	INV-FAST-24-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-24 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
c3fbaf57-9384-47cd-acb8-2c1619210b5d	1	1	INV-FAST-25-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-29 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
eb630bfb-80d9-4861-b3da-5cb694223e42	1	1	INV-FAST-26-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-09 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
73d8fcea-95cf-44cc-9fe5-4bd8a1821bad	1	1	INV-FAST-27-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-01 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
61441ffe-6f5e-40ef-83a4-1b6bffd6695b	1	1	INV-FAST-28-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-30 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
cd2e9e8f-8f65-468f-a3c2-adf663f0fdc7	1	1	INV-FAST-29-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-22 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
456d7861-6dab-479d-8ad6-adf56fc5319b	1	1	INV-FAST-30-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-25 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
cf9b7d3c-9357-4cdd-95a6-b6f962438dad	1	1	INV-FAST-31-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-09 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
44abbbfc-9a16-4fb1-84c8-45a938cc9676	1	1	INV-FAST-32-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-13 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
e2c032e7-9a54-4841-a9ce-2cde47ad44d2	1	1	INV-FAST-33-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-22 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
75ccb778-b220-441e-a2f3-60bd61ef3550	1	1	INV-FAST-34-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-14 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
cad8c90c-eb07-4df7-8f64-a961dd57c084	1	1	INV-FAST-35-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-11 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
619b0358-a446-4d28-88b8-fc1fa7740c32	1	1	INV-FAST-36-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-07 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
e3cc4f3f-dbf9-4361-83d5-61444c5bc609	1	1	INV-FAST-37-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-29 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
3c4ba28e-ff21-4b69-b6c1-24d955e2e51b	1	1	INV-FAST-38-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-02 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
f4d85df5-8d3f-4f45-bd8c-8924b5f56c61	1	1	INV-FAST-39-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-25 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
defc3740-1842-41ac-bce4-7b2c702c8cb5	1	1	INV-FAST-40-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-29 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
6f0a2e33-2286-48e9-8e31-7eaefaf731dc	1	1	INV-FAST-41-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-05 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
989edd7f-aabd-46d3-a923-739aa304344c	1	1	INV-FAST-42-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-07 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
b702cbb0-a354-49c6-9a89-03524ecf2273	1	1	INV-FAST-43-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-08 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
8898e4a6-fc42-4555-b269-49d417a48a9a	1	1	INV-FAST-44-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-23 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
18adfba2-cad8-41e8-bcd9-2030ea57f8a3	1	1	INV-FAST-45-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-01 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
1a6a5c67-9c11-4d7b-acee-20a13676e222	1	1	INV-FAST-46-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-10 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
f7541033-6ac9-4089-b186-1d2eb336e75c	1	1	INV-FAST-47-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-18 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
df7f98fe-01eb-41ea-a471-a0b6c329fe5f	1	1	INV-FAST-48-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-07 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
98645c09-004f-4b51-a41e-2a4f263e6c7f	1	1	INV-FAST-49-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-19 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
418f43b6-c6f8-49e1-8803-c7b30cc1af56	1	1	INV-FAST-50-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-28 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
24954a8b-3074-4ba1-bc77-208e9790036e	1	1	INV-FAST-51-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-05 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
dab40fb4-1fc2-412b-af3b-333ed53b5d89	1	1	INV-FAST-52-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-28 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
5f36d179-e34a-4fb3-ad5d-a062f153846f	1	1	INV-FAST-53-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-11 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
3490bc1c-096d-4fce-81d9-d0c9cd5c4109	1	1	INV-FAST-54-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-20 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
ca83d3ff-4de9-4430-86be-4a4e46b5ffbc	1	1	INV-FAST-55-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-01 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
f8785a48-5614-4c05-9a62-c96c9ec000ca	1	1	INV-FAST-56-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-28 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
07ac07b9-bf28-4023-b7d6-a92d47ec0121	1	1	INV-FAST-57-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-11 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
97ff7199-4a1c-4d81-8eb5-fa20f7e3a074	1	1	INV-FAST-58-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-14 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
c178aad7-1c4a-40b4-9e50-a8bebb8abfc4	1	1	INV-FAST-59-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-09 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
b381d743-d2e6-46ac-80a6-bc946e659aeb	1	1	INV-FAST-60-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-30 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
0f127203-e0a0-43e4-a7d0-b544538c8489	1	1	INV-FAST-61-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-13 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
c464d4c3-a01f-4ded-9aed-cf4c0e6d6d5f	1	1	INV-FAST-62-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-01-30 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
c7270c11-112f-4435-b4fa-1f74d14b8b90	1	1	INV-FAST-63-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-01 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
d0aa740a-4e24-44a8-b66a-906a1720cb57	1	1	INV-FAST-64-1771272207	3500.00	0.00	0.00	3500.00	\N	\N	cash	completed	\N	2026-02-07 20:03:27	2026-02-16 20:03:27	2026-02-16 20:03:27	\N	0	0	0.00	\N
5e477cb6-c92b-4ba7-8845-26bb80c8f377	3	1	INV-YCGJCICF	109600.00	12056.00	0.00	127136.00	\N	\N	qris	completed	\N	2025-12-10 00:00:00	2025-12-10 14:41:06	2026-02-16 20:41:07	6	0	0	5480.00	\N
188cd4d8-50a2-460b-b4bb-bed8626be723	3	1	INV-GUUBFP3N	106400.00	11704.00	0.00	123424.00	\N	\N	cash	completed	\N	2026-02-02 00:00:00	2026-02-02 17:41:31	2026-02-16 20:41:31	20	0	0	5320.00	\N
cb553fda-654c-44ca-a53d-a562a9f97a86	3	1	INV-EFYDX5CF	111100.00	12221.00	0.00	128876.00	\N	\N	cash	completed	\N	2025-12-24 00:00:00	2025-12-24 11:41:31	2026-02-16 20:41:31	13	0	0	5555.00	\N
faaba627-bd2d-4f00-a4f7-9cfb273ae334	3	1	INV-T1QDDXCM	114000.00	12540.00	0.00	132240.00	\N	\N	split	completed	\N	2025-11-23 00:00:00	2025-11-23 12:41:31	2026-02-16 20:41:31	19	0	0	5700.00	\N
d0f196f5-50c5-47c1-b342-a028214b898c	3	1	INV-FKFPXWJB	247200.00	27192.00	0.00	286752.00	\N	\N	cash	completed	\N	2026-01-17 00:00:00	2026-01-17 18:41:31	2026-02-16 20:41:31	16	0	0	12360.00	\N
5767af0c-6ffe-4218-8a74-722e5c2ca4d4	3	1	INV-XUD9RDUB	140200.00	15422.00	0.00	162632.00	\N	\N	split	completed	\N	2025-12-22 00:00:00	2025-12-22 12:41:31	2026-02-16 20:41:31	11	0	0	7010.00	\N
ab61a75b-fd98-4929-99b6-273a4b851b07	3	1	INV-UF1NSARI	135300.00	14883.00	0.00	156948.00	\N	\N	split	completed	\N	2026-01-03 00:00:00	2026-01-03 10:41:31	2026-02-16 20:41:31	17	0	0	6765.00	\N
f7aec63d-c73c-4e93-b29c-26b25a211d8b	3	1	INV-KKYIM5MO	79900.00	8789.00	0.00	92684.00	\N	\N	qris	completed	\N	2026-01-31 00:00:00	2026-01-31 17:41:31	2026-02-16 20:41:31	18	0	0	3995.00	\N
755ebeb1-2656-4022-938e-c61a14915526	3	1	INV-VGKCR6ML	74400.00	8184.00	0.00	86304.00	\N	\N	cash	completed	\N	2026-01-08 00:00:00	2026-01-08 10:41:31	2026-02-16 20:41:31	16	0	0	3720.00	\N
816b3fb4-aaa1-46f5-9262-36eb97b13f82	3	1	INV-O1XMDUYJ	21600.00	2376.00	0.00	25056.00	\N	\N	qris	completed	\N	2026-01-07 00:00:00	2026-01-07 13:41:31	2026-02-16 20:41:31	15	0	0	1080.00	\N
889c3bd5-762e-4364-8c48-9539ddca6f7d	3	1	INV-EOCXY1TF	18700.00	2057.00	0.00	21692.00	\N	\N	cash	completed	\N	2026-02-15 00:00:00	2026-02-15 18:41:31	2026-02-16 20:41:31	18	0	0	935.00	\N
0cc86d72-b836-44b5-a45c-3cd282ae99e7	3	1	INV-XWGHNHT4	26900.00	2959.00	0.00	31204.00	\N	\N	cash	completed	\N	2025-12-10 00:00:00	2025-12-10 20:41:31	2026-02-16 20:41:31	18	0	0	1345.00	\N
fa636cf3-838c-4c5c-8cf6-a3439c778710	3	1	INV-EDAZWZBY	55900.00	6149.00	0.00	64844.00	\N	\N	split	completed	\N	2026-01-21 00:00:00	2026-01-21 13:41:31	2026-02-16 20:41:31	\N	0	0	2795.00	\N
3b2d9651-9ae3-48ad-bd2e-0e2d81c96f1a	3	1	INV-7SVUSF5X	175400.00	19294.00	0.00	203464.00	\N	\N	split	completed	\N	2025-12-29 00:00:00	2025-12-29 15:41:31	2026-02-16 20:41:31	12	0	0	8770.00	\N
04341657-1a51-47da-8cf8-268a2ca3044f	3	1	INV-GUG6WSRU	125800.00	13838.00	0.00	145928.00	\N	\N	split	completed	\N	2026-02-02 00:00:00	2026-02-02 14:41:31	2026-02-16 20:41:31	17	0	0	6290.00	\N
0df71fe4-a912-4b64-9bba-e30c3ac575b2	3	1	INV-WOWQYFIK	127700.00	14047.00	0.00	148132.00	\N	\N	split	completed	\N	2025-12-18 00:00:00	2025-12-18 14:41:31	2026-02-16 20:41:31	20	0	0	6385.00	\N
3bd0d3f6-e532-4350-9e2a-957f9f004625	3	1	INV-ZTS0FQNV	161200.00	17732.00	0.00	186992.00	\N	\N	qris	completed	\N	2026-01-16 00:00:00	2026-01-16 20:41:31	2026-02-16 20:41:31	17	0	0	8060.00	\N
1dae35b1-efb8-4eed-9fff-0009f2304ba0	3	1	INV-OZY5H490	338700.00	37257.00	0.00	392892.00	\N	\N	split	completed	\N	2026-02-08 00:00:00	2026-02-08 11:41:31	2026-02-16 20:41:31	13	0	0	16935.00	\N
b1f17b11-c2de-4202-9a98-fedf9bfb66ea	3	1	INV-4VAAXIOL	54900.00	6039.00	0.00	63684.00	\N	\N	cash	completed	\N	2026-01-27 00:00:00	2026-01-27 11:41:31	2026-02-16 20:41:31	\N	0	0	2745.00	\N
17dffab7-7e57-4943-a1a4-ac0155c886ad	3	1	INV-T4OCE4JJ	138600.00	15246.00	0.00	160776.00	\N	\N	cash	completed	\N	2025-12-06 00:00:00	2025-12-06 13:41:31	2026-02-16 20:41:31	\N	0	0	6930.00	\N
bd6a0fa7-54b9-49c2-9c98-a6a908c86173	3	1	INV-LQCAUXSC	142300.00	15653.00	0.00	165068.00	\N	\N	split	completed	\N	2026-01-17 00:00:00	2026-01-17 10:41:31	2026-02-16 20:41:31	17	0	0	7115.00	\N
7ac302c2-21b2-437a-aeb2-20b896acf23f	3	1	INV-XJNL12EI	80000.00	8800.00	0.00	92800.00	\N	\N	split	completed	\N	2026-02-04 00:00:00	2026-02-04 19:41:32	2026-02-16 20:41:32	15	0	0	4000.00	\N
5e939f2c-bac1-4dc0-b193-e268992f13cb	3	1	INV-KFCZWNF9	30000.00	3300.00	0.00	34800.00	\N	\N	split	completed	\N	2025-12-14 00:00:00	2025-12-14 17:41:32	2026-02-16 20:41:32	18	0	0	1500.00	\N
f5c565c6-c6f0-43c6-bcba-5d31dc1e74e5	3	1	INV-LBRNGFEH	127100.00	13981.00	0.00	147436.00	\N	\N	qris	completed	\N	2026-01-15 00:00:00	2026-01-15 13:41:32	2026-02-16 20:41:32	18	0	0	6355.00	\N
fa7d76f1-7196-4693-96fb-63566ef5c487	3	1	INV-UZIVVFSW	134500.00	14795.00	0.00	156020.00	\N	\N	cash	completed	\N	2026-01-05 00:00:00	2026-01-05 19:41:32	2026-02-16 20:41:32	12	0	0	6725.00	\N
2aec118f-a4cd-476e-96f3-59db5bd5f835	3	1	INV-A0KJPHLE	91200.00	10032.00	0.00	105792.00	\N	\N	qris	completed	\N	2026-01-28 00:00:00	2026-01-28 19:41:32	2026-02-16 20:41:32	14	0	0	4560.00	\N
29db4e77-8f4a-4c60-a083-9654af68ec3c	3	1	INV-VMWFWHOE	178200.00	19602.00	0.00	206712.00	\N	\N	qris	completed	\N	2025-12-26 00:00:00	2025-12-26 13:41:32	2026-02-16 20:41:32	11	0	0	8910.00	\N
d4e58079-8a25-4de8-a5c6-9b5c96451dda	3	1	INV-6D6JBLG0	12600.00	1386.00	0.00	14616.00	\N	\N	qris	completed	\N	2026-01-07 00:00:00	2026-01-07 10:41:32	2026-02-16 20:41:32	17	0	0	630.00	\N
6c48321b-02ee-41bd-bd7e-e9a4b7c38942	3	1	INV-NIWW51CA	64200.00	7062.00	0.00	74472.00	\N	\N	split	completed	\N	2025-12-03 00:00:00	2025-12-03 18:41:32	2026-02-16 20:41:32	11	0	0	3210.00	\N
d9e14ae3-1fe7-4959-8201-c8f731050404	3	1	INV-1SSGOHX9	51600.00	5676.00	0.00	59856.00	\N	\N	split	completed	\N	2026-01-07 00:00:00	2026-01-07 19:41:32	2026-02-16 20:41:32	18	0	0	2580.00	\N
630ad66f-5123-4dba-bde8-b4bc36f02dca	3	1	INV-PMKSMIXK	225400.00	24794.00	0.00	261464.00	\N	\N	qris	completed	\N	2026-01-03 00:00:00	2026-01-03 20:41:32	2026-02-16 20:41:32	\N	0	0	11270.00	\N
f7857d14-155f-4fc0-95e0-ed248941a8e1	3	1	INV-MVZMKXVY	168300.00	18513.00	0.00	195228.00	\N	\N	qris	completed	\N	2025-12-17 00:00:00	2025-12-17 16:41:32	2026-02-16 20:41:32	13	0	0	8415.00	\N
3de2cbbe-e4d5-48c3-b158-0773a0b08bb5	3	1	INV-FTKMIQUQ	115900.00	12749.00	0.00	134444.00	\N	\N	cash	completed	\N	2026-02-16 00:00:00	2026-02-16 12:41:32	2026-02-16 20:41:32	14	0	0	5795.00	\N
aac15ebc-08ec-4ede-999e-9c9511964d88	3	1	INV-WPDQGJ5E	170000.00	18700.00	0.00	197200.00	\N	\N	qris	completed	\N	2026-01-16 00:00:00	2026-01-16 15:41:32	2026-02-16 20:41:32	\N	0	0	8500.00	\N
52841860-26e7-4f66-b7ae-20f2168eaa4f	3	1	INV-M9YYRAX0	48000.00	5280.00	0.00	55680.00	\N	\N	split	completed	\N	2025-12-25 00:00:00	2025-12-25 13:41:32	2026-02-16 20:41:32	\N	0	0	2400.00	\N
a39240f9-16d8-44ba-86e0-59afd1a78973	3	1	INV-ZECRKSH0	77100.00	8481.00	0.00	89436.00	\N	\N	qris	completed	\N	2025-12-09 00:00:00	2025-12-09 12:41:32	2026-02-16 20:41:32	13	0	0	3855.00	\N
93a336ba-a29f-42fc-9ed3-c08939fc2d73	3	1	INV-52FSQBNK	126000.00	13860.00	0.00	146160.00	\N	\N	qris	completed	\N	2026-02-04 00:00:00	2026-02-04 18:41:32	2026-02-16 20:41:32	\N	0	0	6300.00	\N
a0750e4f-2683-4a49-b738-6a629470b050	3	1	INV-HVHT9LLM	231300.00	25443.00	0.00	268308.00	\N	\N	split	completed	\N	2025-11-22 00:00:00	2025-11-22 16:41:32	2026-02-16 20:41:32	\N	0	0	11565.00	\N
b46e0d85-9c45-447a-987e-c2a72a5cc776	3	1	INV-RFBRPCUV	76000.00	8360.00	0.00	88160.00	\N	\N	qris	completed	\N	2026-01-23 00:00:00	2026-01-23 18:41:32	2026-02-16 20:41:32	15	0	0	3800.00	\N
21d3a652-cca7-4048-bf86-c9738d1adb2b	3	1	INV-GKBRMZJ1	119100.00	13101.00	0.00	138156.00	\N	\N	split	completed	\N	2025-12-06 00:00:00	2025-12-06 11:41:32	2026-02-16 20:41:32	13	0	0	5955.00	\N
ca16cd09-eb8d-4830-95b0-a2755a9e5191	3	1	INV-FGCUNSZO	252200.00	27742.00	0.00	292552.00	\N	\N	split	completed	\N	2026-01-03 00:00:00	2026-01-03 19:41:32	2026-02-16 20:41:32	12	0	0	12610.00	\N
5753e2c1-f568-4d53-bae5-cfc21b2e130e	3	1	INV-DKXMEGYJ	171400.00	18854.00	0.00	198824.00	\N	\N	qris	completed	\N	2025-12-01 00:00:00	2025-12-01 15:41:32	2026-02-16 20:41:32	13	0	0	8570.00	\N
f2deae93-e1b9-424b-96dc-79ec953e4c81	3	1	INV-RK2C4ZVS	219200.00	24112.00	0.00	254272.00	\N	\N	cash	completed	\N	2025-12-02 00:00:00	2025-12-02 10:41:32	2026-02-16 20:41:32	15	0	0	10960.00	\N
f47251c6-0d4a-4c9c-8a40-89877ab7e2f0	3	1	INV-DSNTRA7V	154800.00	17028.00	0.00	179568.00	\N	\N	cash	completed	\N	2025-11-22 00:00:00	2025-11-22 12:41:32	2026-02-16 20:41:32	\N	0	0	7740.00	\N
140f2a61-36d7-4511-afde-b9cc4ca91309	3	1	INV-X6GN1QMP	262100.00	28831.00	0.00	304036.00	\N	\N	cash	completed	\N	2025-12-02 00:00:00	2025-12-02 18:41:32	2026-02-16 20:41:32	17	0	0	13105.00	\N
ca18d04f-a862-4049-bf62-527e91adff1e	3	1	INV-W4MOYUQF	110000.00	12100.00	0.00	127600.00	\N	\N	split	completed	\N	2025-11-25 00:00:00	2025-11-25 20:41:32	2026-02-16 20:41:32	13	0	0	5500.00	\N
91fe449f-c6b3-4662-b746-169a7064592d	3	1	INV-IICJZIG5	200400.00	22044.00	0.00	232464.00	\N	\N	split	completed	\N	2026-02-10 00:00:00	2026-02-10 12:41:32	2026-02-16 20:41:32	\N	0	0	10020.00	\N
d9296d04-1239-4ef7-80f3-5604f24cea1e	3	1	INV-O7DE43QY	273400.00	30074.00	0.00	317144.00	\N	\N	split	completed	\N	2025-12-24 00:00:00	2025-12-24 10:41:32	2026-02-16 20:41:32	\N	0	0	13670.00	\N
1c70a1a3-bb8b-41e4-bf2f-7da6f978c13b	3	1	INV-IMXYFMJA	363000.00	39930.00	0.00	421080.00	\N	\N	qris	completed	\N	2026-01-11 00:00:00	2026-01-11 18:41:32	2026-02-16 20:41:32	\N	0	0	18150.00	\N
71c38cdb-0ed2-42a7-8f88-25ae6d7fd22d	3	1	INV-2DCMSQIQ	236300.00	25993.00	0.00	274108.00	\N	\N	split	completed	\N	2026-01-11 00:00:00	2026-01-11 18:41:33	2026-02-16 20:41:33	\N	0	0	11815.00	\N
68beb82e-0973-4324-880c-7b04bed64302	3	1	INV-0WWT4ISA	113400.00	12474.00	0.00	131544.00	\N	\N	split	completed	\N	2026-02-12 00:00:00	2026-02-12 11:41:33	2026-02-16 20:41:33	19	0	0	5670.00	\N
402dbb8a-c672-412c-bc05-048ce9968925	3	1	INV-WJ7WZUUC	367500.00	40425.00	0.00	426300.00	\N	\N	qris	completed	\N	2026-01-17 00:00:00	2026-01-17 16:41:33	2026-02-16 20:41:33	16	0	0	18375.00	\N
b9388272-3e90-41f3-b7f3-813ed5c7c11d	3	1	INV-5AFEOOQ8	105800.00	11638.00	0.00	122728.00	\N	\N	qris	completed	\N	2025-12-05 00:00:00	2025-12-05 14:41:33	2026-02-16 20:41:33	18	0	0	5290.00	\N
673f8872-9fb2-424d-a5d1-21c1eed8253b	3	1	INV-RS9CLXVD	60600.00	6666.00	0.00	70296.00	\N	\N	split	completed	\N	2025-11-22 00:00:00	2025-11-22 15:41:33	2026-02-16 20:41:33	11	0	0	3030.00	\N
1c192a8b-d9db-4b86-9edd-95837eef4030	3	1	INV-8FHXT1KA	88200.00	9702.00	0.00	102312.00	\N	\N	cash	completed	\N	2025-12-29 00:00:00	2025-12-29 12:41:33	2026-02-16 20:41:33	17	0	0	4410.00	\N
ba93216c-6d7c-4011-b459-ed06f394edbe	3	1	INV-VNUWAJWP	183300.00	20163.00	0.00	212628.00	\N	\N	split	completed	\N	2026-01-05 00:00:00	2026-01-05 13:41:33	2026-02-16 20:41:33	14	0	0	9165.00	\N
9a8a681a-d77c-4994-85c6-90b4e4440afd	3	1	INV-BJHQWZLE	162800.00	17908.00	0.00	188848.00	\N	\N	qris	completed	\N	2025-12-03 00:00:00	2025-12-03 17:41:33	2026-02-16 20:41:33	17	0	0	8140.00	\N
c14f59a5-2136-4f10-8235-91e7f1b0f546	3	1	INV-8AMUP4AY	211800.00	23298.00	0.00	245688.00	\N	\N	split	completed	\N	2025-12-24 00:00:00	2025-12-24 20:41:33	2026-02-16 20:41:33	11	0	0	10590.00	\N
0b3402c7-5d73-48f4-a15b-315d2a534d17	3	1	INV-BXUCYFBB	32400.00	3564.00	0.00	37584.00	\N	\N	qris	completed	\N	2026-02-01 00:00:00	2026-02-01 11:41:33	2026-02-16 20:41:33	16	0	0	1620.00	\N
9357d77b-a00d-4560-92ad-31c0ac320f6f	3	1	INV-IRKYLO07	107700.00	11847.00	0.00	124932.00	\N	\N	qris	completed	\N	2026-01-26 00:00:00	2026-01-26 18:41:33	2026-02-16 20:41:33	15	0	0	5385.00	\N
573e34bf-258d-44d5-a54e-d7856b68ede0	3	1	INV-O2E06XBX	28500.00	3135.00	0.00	33060.00	\N	\N	cash	completed	\N	2026-01-07 00:00:00	2026-01-07 14:41:33	2026-02-16 20:41:33	12	0	0	1425.00	\N
25be66d7-9581-489f-83b1-febcdc470f35	3	1	INV-BURMJOXS	143900.00	15829.00	0.00	166924.00	\N	\N	cash	completed	\N	2026-01-11 00:00:00	2026-01-11 15:41:33	2026-02-16 20:41:33	16	0	0	7195.00	\N
670b4ab2-f567-48fd-aadb-e33164ff68b6	3	1	INV-SX2ZKYSK	200800.00	22088.00	0.00	232928.00	\N	\N	qris	completed	\N	2026-01-05 00:00:00	2026-01-05 18:41:33	2026-02-16 20:41:33	20	0	0	10040.00	\N
88cd91ff-4ffc-43d8-b9c4-c43c4f79e36c	3	1	INV-CD73PMDD	14400.00	1584.00	0.00	16704.00	\N	\N	split	completed	\N	2026-02-01 00:00:00	2026-02-01 14:41:33	2026-02-16 20:41:33	15	0	0	720.00	\N
51a3d4f3-03b8-4298-982c-0e5e012d1179	3	1	INV-5OMZFGSU	106900.00	11759.00	0.00	124004.00	\N	\N	cash	completed	\N	2026-02-10 00:00:00	2026-02-10 10:41:33	2026-02-16 20:41:33	15	0	0	5345.00	\N
5eae991a-2fe4-4ac2-ae66-aa1d3ac50f4b	3	1	INV-HZD6V62W	193300.00	21263.00	0.00	224228.00	\N	\N	split	completed	\N	2025-12-21 00:00:00	2025-12-21 20:41:33	2026-02-16 20:41:33	\N	0	0	9665.00	\N
9b80e947-3300-4a6b-a549-5e1ecc09ffbe	3	1	INV-FIBYF4E1	130600.00	14366.00	0.00	151496.00	\N	\N	cash	completed	\N	2026-01-20 00:00:00	2026-01-20 20:41:33	2026-02-16 20:41:33	\N	0	0	6530.00	\N
f4e4ebea-d755-4011-8e7a-dc3e496ff736	3	1	INV-IYYJSX88	99600.00	10956.00	0.00	115536.00	\N	\N	split	completed	\N	2025-12-11 00:00:00	2025-12-11 12:41:33	2026-02-16 20:41:33	\N	0	0	4980.00	\N
5b2640ff-c500-4039-82aa-acfd0606e5e8	3	1	INV-KTUBDIKB	185500.00	20405.00	0.00	215180.00	\N	\N	split	completed	\N	2026-01-04 00:00:00	2026-01-04 16:41:33	2026-02-16 20:41:33	13	0	0	9275.00	\N
b2db0df6-777d-4845-9d5a-641cf11af0ab	3	1	INV-A4LK6X1K	84000.00	9240.00	0.00	97440.00	\N	\N	split	completed	\N	2026-02-01 00:00:00	2026-02-01 19:41:33	2026-02-16 20:41:33	12	0	0	4200.00	\N
1262f0eb-2d22-4a19-b4e6-a3f7a7b539e8	3	1	INV-5BKCJEOG	84000.00	9240.00	0.00	97440.00	\N	\N	qris	completed	\N	2025-11-18 00:00:00	2025-11-18 16:41:33	2026-02-16 20:41:33	17	0	0	4200.00	\N
b379a906-50c7-4e01-a884-a23b38538452	3	1	INV-H5NWETBG	35400.00	3894.00	0.00	41064.00	\N	\N	split	completed	\N	2026-01-08 00:00:00	2026-01-08 10:41:33	2026-02-16 20:41:33	11	0	0	1770.00	\N
ba115e9e-e7e3-4f3a-b924-74b4cf455b0c	3	1	INV-8W2U5VDU	245400.00	26994.00	0.00	284664.00	\N	\N	qris	completed	\N	2026-01-31 00:00:00	2026-01-31 10:41:33	2026-02-16 20:41:33	\N	0	0	12270.00	\N
49ef21c7-0f33-4c80-8e37-ecfc37284e48	3	1	INV-7MYGR3CX	14900.00	1639.00	0.00	17284.00	\N	\N	cash	completed	\N	2026-02-08 00:00:00	2026-02-08 12:41:33	2026-02-16 20:41:33	12	0	0	745.00	\N
4cc66a87-bb46-4a42-924e-8aa7b38d9c84	3	1	INV-PAT8LSEG	51200.00	5632.00	0.00	59392.00	\N	\N	qris	completed	\N	2026-01-05 00:00:00	2026-01-05 19:41:33	2026-02-16 20:41:33	15	0	0	2560.00	\N
c93aaf29-db26-4eaf-a902-7c22011c86ae	3	1	INV-6YU8KXAU	131400.00	14454.00	0.00	152424.00	\N	\N	qris	completed	\N	2025-12-02 00:00:00	2025-12-02 13:41:33	2026-02-16 20:41:33	18	0	0	6570.00	\N
27a02e4e-1e1d-42a7-a589-08e3e0621897	3	1	INV-8DQSTD3S	164100.00	18051.00	0.00	190356.00	\N	\N	qris	completed	\N	2026-02-11 00:00:00	2026-02-11 10:41:33	2026-02-16 20:41:33	\N	0	0	8205.00	\N
3869e47e-4e65-4df2-8571-b130e3a6a5dd	3	1	INV-6FZF4YIN	470000.00	51700.00	0.00	545200.00	\N	\N	cash	completed	\N	2026-01-01 00:00:00	2026-01-01 15:41:33	2026-02-16 20:41:33	\N	0	0	23500.00	\N
0084ad8c-2c77-403f-945e-687d0dbd2c94	3	1	INV-MYIVBRVH	6200.00	682.00	0.00	7192.00	\N	\N	cash	completed	\N	2026-01-26 00:00:00	2026-01-26 17:41:34	2026-02-16 20:41:34	11	0	0	310.00	\N
f0726e45-9a56-4283-80e5-303855703739	3	1	INV-VWA9OE7V	185200.00	20372.00	0.00	214832.00	\N	\N	cash	completed	\N	2025-12-29 00:00:00	2025-12-29 19:41:34	2026-02-16 20:41:34	13	0	0	9260.00	\N
5bd2cfbd-60c4-4598-9559-4c1b5fdd7c64	3	1	INV-W9UN0FBZ	96600.00	10626.00	0.00	112056.00	\N	\N	cash	completed	\N	2026-02-05 00:00:00	2026-02-05 20:41:34	2026-02-16 20:41:34	\N	0	0	4830.00	\N
44bc517f-73b2-48b1-8814-04ae7a9bc140	3	1	INV-QA3BH2OD	171000.00	18810.00	0.00	198360.00	\N	\N	split	completed	\N	2026-02-06 00:00:00	2026-02-06 10:41:34	2026-02-16 20:41:34	18	0	0	8550.00	\N
9ab2fac5-26a6-4532-b374-b420d8a59dd8	3	1	INV-12EO8FWU	3200.00	352.00	0.00	3712.00	\N	\N	cash	completed	\N	2026-01-04 00:00:00	2026-01-04 13:41:34	2026-02-16 20:41:34	13	0	0	160.00	\N
319cfc37-a843-415b-a3ca-671d1b2fee7f	3	1	INV-B3KBPCHI	4000.00	440.00	0.00	4640.00	\N	\N	cash	completed	\N	2026-01-18 00:00:00	2026-01-18 17:41:34	2026-02-16 20:41:34	11	0	0	200.00	\N
a85b793d-0b06-44f7-8c03-aef42c83d2e6	3	1	INV-D2WITTXQ	216500.00	23815.00	0.00	251140.00	\N	\N	cash	completed	\N	2025-12-20 00:00:00	2025-12-20 16:41:34	2026-02-16 20:41:34	\N	0	0	10825.00	\N
d4c38f8b-beef-4e9b-b047-ae41669173fa	3	1	INV-B41ZRGFW	367900.00	40469.00	0.00	426764.00	\N	\N	cash	completed	\N	2026-02-12 00:00:00	2026-02-12 20:41:34	2026-02-16 20:41:34	11	0	0	18395.00	\N
d4c42702-5b8a-4bfc-9487-11c4b165b2af	3	1	INV-NECDC5DF	216900.00	23859.00	0.00	251604.00	\N	\N	cash	completed	\N	2026-02-06 00:00:00	2026-02-06 15:41:34	2026-02-16 20:41:34	\N	0	0	10845.00	\N
573071ac-6b8e-46c2-8a24-a5a268514fa2	3	1	INV-XY3NPNGZ	252100.00	27731.00	0.00	292436.00	\N	\N	split	completed	\N	2025-11-19 00:00:00	2025-11-19 10:41:34	2026-02-16 20:41:34	15	0	0	12605.00	\N
fa36c357-80b5-474c-8c4f-6a9e61d2a5af	3	1	INV-FWFXLRU7	46100.00	5071.00	0.00	53476.00	\N	\N	split	completed	\N	2026-01-12 00:00:00	2026-01-12 15:41:34	2026-02-16 20:41:34	11	0	0	2305.00	\N
9c102d66-244b-4cb0-be80-e6015358c9fa	3	1	INV-B1CDZZTW	136800.00	15048.00	0.00	158688.00	\N	\N	split	completed	\N	2025-12-17 00:00:00	2025-12-17 16:41:34	2026-02-16 20:41:34	18	0	0	6840.00	\N
e6f20d82-cd87-4b16-baf4-84f904690f7b	3	1	INV-ELYFJBL6	188100.00	20691.00	0.00	218196.00	\N	\N	cash	completed	\N	2025-11-21 00:00:00	2025-11-21 19:41:34	2026-02-16 20:41:34	11	0	0	9405.00	\N
b1e132b3-d7b9-4087-975c-a0541babdd64	3	1	INV-RY8IOPWT	163800.00	18018.00	0.00	190008.00	\N	\N	qris	completed	\N	2026-02-09 00:00:00	2026-02-09 14:41:34	2026-02-16 20:41:34	\N	0	0	8190.00	\N
52bb003f-f071-4912-b25b-8e0edbf15fa5	3	1	INV-FUFEPPJ2	84000.00	9240.00	0.00	97440.00	\N	\N	split	completed	\N	2026-02-11 00:00:00	2026-02-11 15:41:34	2026-02-16 20:41:34	13	0	0	4200.00	\N
dc05ab3e-09d2-4e1f-95c4-b377810ee858	3	1	INV-RV8GGR7F	47000.00	5170.00	0.00	54520.00	\N	\N	cash	completed	\N	2026-02-03 00:00:00	2026-02-03 19:41:34	2026-02-16 20:41:34	14	0	0	2350.00	\N
bf4dc0af-63b2-46dd-994a-06424729c944	3	1	INV-L9GBDB7V	181500.00	19965.00	0.00	210540.00	\N	\N	cash	completed	\N	2025-12-27 00:00:00	2025-12-27 18:41:34	2026-02-16 20:41:34	14	0	0	9075.00	\N
8d40426f-c6b4-487e-aa2d-7221519b6dbe	3	1	INV-WFHYSTYN	282600.00	31086.00	0.00	327816.00	\N	\N	split	completed	\N	2026-01-13 00:00:00	2026-01-13 12:41:34	2026-02-16 20:41:34	20	0	0	14130.00	\N
eda548ed-f927-46cb-830b-83b20ccd8022	3	1	INV-EGOKEF4M	35400.00	3894.00	0.00	41064.00	\N	\N	cash	completed	\N	2026-02-13 00:00:00	2026-02-13 20:41:34	2026-02-16 20:41:34	14	0	0	1770.00	\N
9ecd10b4-041c-425a-b796-31b40fa03863	3	1	INV-3F2ELRKF	135300.00	14883.00	0.00	156948.00	\N	\N	cash	completed	\N	2025-12-24 00:00:00	2025-12-24 13:41:34	2026-02-16 20:41:34	13	0	0	6765.00	\N
abff2755-8130-4d9c-8dc4-f38e0e966a64	3	1	INV-AZHYIELV	85300.00	9383.00	0.00	98948.00	\N	\N	cash	completed	\N	2025-12-18 00:00:00	2025-12-18 13:41:34	2026-02-16 20:41:34	15	0	0	4265.00	\N
61b00242-a837-4a18-abdd-dd07d383d530	3	1	INV-CWW6LLJG	90400.00	9944.00	0.00	104864.00	\N	\N	cash	completed	\N	2025-12-06 00:00:00	2025-12-06 16:41:34	2026-02-16 20:41:34	19	0	0	4520.00	\N
012ec076-3007-4f41-926b-6bcc33aa7e3d	3	1	INV-H1NJCOFS	97500.00	10725.00	0.00	113100.00	\N	\N	cash	completed	\N	2026-01-10 00:00:00	2026-01-10 20:41:34	2026-02-16 20:41:34	18	0	0	4875.00	\N
a8fd022b-8fc2-4f84-b2af-bfe672bd0764	3	1	INV-HFBOAIY3	100400.00	11044.00	0.00	116464.00	\N	\N	qris	completed	\N	2026-01-31 00:00:00	2026-01-31 11:41:34	2026-02-16 20:41:34	\N	0	0	5020.00	\N
b6484477-3a80-49e5-8cb6-097a7e846159	3	1	INV-H7CGFQUO	47100.00	5181.00	0.00	54636.00	\N	\N	split	completed	\N	2025-12-07 00:00:00	2025-12-07 10:41:34	2026-02-16 20:41:34	19	0	0	2355.00	\N
8693f9a6-8fd1-48ee-8382-ec04f236363b	3	1	INV-MWRZDBWB	35200.00	3872.00	0.00	40832.00	\N	\N	cash	completed	\N	2025-12-05 00:00:00	2025-12-05 12:41:34	2026-02-16 20:41:34	14	0	0	1760.00	\N
902b7857-f135-422f-9ed8-d6feb1695f26	3	1	INV-FRLDX13G	150000.00	16500.00	0.00	174000.00	\N	\N	split	completed	\N	2025-12-22 00:00:00	2025-12-22 10:41:34	2026-02-16 20:41:34	20	0	0	7500.00	\N
f922cded-c77d-41af-8436-e70baf9c879e	3	1	INV-PHTQUYTM	48000.00	5280.00	0.00	55680.00	\N	\N	split	completed	\N	2025-12-31 00:00:00	2025-12-31 12:41:34	2026-02-16 20:41:34	16	0	0	2400.00	\N
6b783b0f-3b49-4a65-9c9c-b2410fceb2f4	3	1	INV-O0FQMVJD	289100.00	31801.00	0.00	335356.00	\N	\N	split	completed	\N	2025-12-12 00:00:00	2025-12-12 10:41:34	2026-02-16 20:41:34	16	0	0	14455.00	\N
eb7fcbd5-5f3d-4718-9135-a41dba47f598	3	1	INV-OG4WIVFZ	56000.00	6160.00	0.00	64960.00	\N	\N	qris	completed	\N	2026-01-09 00:00:00	2026-01-09 19:41:34	2026-02-16 20:41:34	16	0	0	2800.00	\N
372a3b10-9ab2-44a2-9275-fa2502bfbffd	3	1	INV-ZAWTXVSF	245900.00	27049.00	0.00	285244.00	\N	\N	qris	completed	\N	2026-01-06 00:00:00	2026-01-06 19:41:34	2026-02-16 20:41:34	17	0	0	12295.00	\N
2c3843e3-b93f-4839-9dd4-f5d18b952da8	3	1	INV-H5H1IL5E	8000.00	880.00	0.00	9280.00	\N	\N	split	completed	\N	2025-12-07 00:00:00	2025-12-07 16:41:35	2026-02-16 20:41:35	\N	0	0	400.00	\N
4d390ca9-ab3c-492f-97e5-d59520c61260	3	1	INV-7RRVX9XH	123800.00	13618.00	0.00	143608.00	\N	\N	qris	completed	\N	2025-12-23 00:00:00	2025-12-23 16:41:35	2026-02-16 20:41:35	17	0	0	6190.00	\N
e0245869-a089-49f9-93a6-1d0acc533390	3	1	INV-TX63EWRR	59500.00	6545.00	0.00	69020.00	\N	\N	qris	completed	\N	2025-12-12 00:00:00	2025-12-12 16:41:35	2026-02-16 20:41:35	12	0	0	2975.00	\N
68886fa9-980a-46d7-a9f4-52c364a61014	3	1	INV-N9BBU68M	45600.00	5016.00	0.00	52896.00	\N	\N	cash	completed	\N	2025-12-07 00:00:00	2025-12-07 17:41:35	2026-02-16 20:41:35	20	0	0	2280.00	\N
9ad4664c-c878-4d1d-9bdb-f032e106db12	3	1	INV-RSHRQ3FF	152900.00	16819.00	0.00	177364.00	\N	\N	cash	completed	\N	2025-12-22 00:00:00	2025-12-22 20:41:35	2026-02-16 20:41:35	14	0	0	7645.00	\N
b6dec020-a18d-493d-b0d0-e39c7c7e73ea	3	1	INV-LIOISH1Y	54900.00	6039.00	0.00	63684.00	\N	\N	split	completed	\N	2025-12-10 00:00:00	2025-12-10 15:41:35	2026-02-16 20:41:35	17	0	0	2745.00	\N
e8e84890-a48d-47fe-8dc0-0452a67a625e	3	1	INV-QAQMNEEC	52400.00	5764.00	0.00	60784.00	\N	\N	cash	completed	\N	2025-12-15 00:00:00	2025-12-15 15:41:35	2026-02-16 20:41:35	\N	0	0	2620.00	\N
c2c17b7c-308c-4f0b-b7b7-2a48b44f9020	3	1	INV-GETHL1A0	273300.00	30063.00	0.00	317028.00	\N	\N	split	completed	\N	2025-12-21 00:00:00	2025-12-21 19:41:35	2026-02-16 20:41:35	\N	0	0	13665.00	\N
eaf4ecf0-bb64-42f0-bc88-c629b421342c	3	1	INV-DSREB2ZO	66900.00	7359.00	0.00	77604.00	\N	\N	qris	completed	\N	2026-01-03 00:00:00	2026-01-03 18:41:35	2026-02-16 20:41:35	14	0	0	3345.00	\N
90a4b29f-8fb6-4af0-b3cb-b87344cdf3a2	3	1	INV-ACMDHPZS	249400.00	27434.00	0.00	289304.00	\N	\N	split	completed	\N	2025-12-14 00:00:00	2025-12-14 11:41:35	2026-02-16 20:41:35	18	0	0	12470.00	\N
d72e46af-bc79-447f-b58c-8deb6f576cd0	3	1	INV-HWWYWIOM	220000.00	24200.00	0.00	255200.00	\N	\N	qris	completed	\N	2026-01-01 00:00:00	2026-01-01 10:41:35	2026-02-16 20:41:35	16	0	0	11000.00	\N
8b531270-8c24-41df-934e-bf642dbc85b8	3	1	INV-NWCFKISV	248500.00	27335.00	0.00	288260.00	\N	\N	qris	completed	\N	2025-11-29 00:00:00	2025-11-29 12:41:35	2026-02-16 20:41:35	\N	0	0	12425.00	\N
cf5a03ec-3d18-40d8-9268-b30fe10fba44	3	1	INV-VMVTVCKI	217300.00	23903.00	0.00	252068.00	\N	\N	cash	completed	\N	2026-01-28 00:00:00	2026-01-28 11:41:35	2026-02-16 20:41:35	12	0	0	10865.00	\N
5fc397ed-cd75-4f0e-9c64-af4486862e69	3	1	INV-6C92MJQS	140900.00	15499.00	0.00	163444.00	\N	\N	qris	completed	\N	2026-02-04 00:00:00	2026-02-04 10:41:35	2026-02-16 20:41:35	12	0	0	7045.00	\N
1292bd85-1b11-4fbb-9819-dccd17187f39	3	1	INV-SJFRCM9N	288000.00	31680.00	0.00	334080.00	\N	\N	cash	completed	\N	2025-12-24 00:00:00	2025-12-24 11:41:35	2026-02-16 20:41:35	\N	0	0	14400.00	\N
9a8b6a9c-153a-41ae-a4e9-2a2ac543452a	3	1	INV-2BP54C0L	81000.00	8910.00	0.00	93960.00	\N	\N	qris	completed	\N	2025-12-24 00:00:00	2025-12-24 20:41:35	2026-02-16 20:41:35	14	0	0	4050.00	\N
6168162f-13e8-4121-9d8b-f2f8de4631c6	3	1	INV-WSBOTNB7	169200.00	18612.00	0.00	196272.00	\N	\N	qris	completed	\N	2026-02-08 00:00:00	2026-02-08 14:41:35	2026-02-16 20:41:35	15	0	0	8460.00	\N
41bb4ccb-76b5-4468-b57b-7f042f292803	3	1	INV-AZZUMUPS	173900.00	19129.00	0.00	201724.00	\N	\N	qris	completed	\N	2025-11-29 00:00:00	2025-11-29 10:41:35	2026-02-16 20:41:35	12	0	0	8695.00	\N
eaa6d66c-0403-47d6-a718-d56e77b3532d	3	1	INV-HZV7RMKS	419000.00	46090.00	0.00	486040.00	\N	\N	qris	completed	\N	2026-01-21 00:00:00	2026-01-21 16:41:35	2026-02-16 20:41:35	15	0	0	20950.00	\N
2b670aba-39aa-43e5-a1e1-d2c653939ec7	3	1	INV-7NFVBEPK	52300.00	5753.00	0.00	60668.00	\N	\N	split	completed	\N	2026-01-13 00:00:00	2026-01-13 16:41:35	2026-02-16 20:41:35	\N	0	0	2615.00	\N
8e0032f7-30da-41d2-a09b-087b9fa72a01	3	1	INV-WDVWZQWP	205700.00	22627.00	0.00	238612.00	\N	\N	qris	completed	\N	2026-01-12 00:00:00	2026-01-12 10:41:35	2026-02-16 20:41:35	18	0	0	10285.00	\N
1df1fc5e-040e-4906-b876-624bb9a8b57b	3	1	INV-8SEJG5GX	177100.00	19481.00	0.00	205436.00	\N	\N	cash	completed	\N	2026-01-31 00:00:00	2026-01-31 12:41:35	2026-02-16 20:41:35	15	0	0	8855.00	\N
872a4a7f-cb1a-49f1-a523-414e3f71bcd7	3	1	INV-ZMZONG4P	110600.00	12166.00	0.00	128296.00	\N	\N	qris	completed	\N	2026-01-30 00:00:00	2026-01-30 19:41:35	2026-02-16 20:41:35	\N	0	0	5530.00	\N
bcf057b7-d1a8-4668-b13e-09123991d9b3	3	1	INV-UC7BXVS7	54700.00	6017.00	0.00	63452.00	\N	\N	cash	completed	\N	2026-02-08 00:00:00	2026-02-08 10:41:35	2026-02-16 20:41:35	20	0	0	2735.00	\N
c786161e-b934-4608-aeec-cfb60f649faf	3	1	INV-PUXKG5LT	48000.00	5280.00	0.00	55680.00	\N	\N	split	completed	\N	2025-12-05 00:00:00	2025-12-05 13:41:35	2026-02-16 20:41:35	\N	0	0	2400.00	\N
0e80dffc-a496-47a3-9719-37f21704887a	3	1	INV-CRXCIRZT	322100.00	35431.00	0.00	373636.00	\N	\N	split	completed	\N	2025-12-22 00:00:00	2025-12-22 16:41:35	2026-02-16 20:41:35	\N	0	0	16105.00	\N
08966db7-4bbf-43f8-9c88-9db67951da5f	3	1	INV-SBR9KJLB	34000.00	3740.00	0.00	39440.00	\N	\N	cash	completed	\N	2026-01-21 00:00:00	2026-01-21 17:41:35	2026-02-16 20:41:35	18	0	0	1700.00	\N
882b98ee-d441-4eb8-9899-ab5f48d40095	3	1	INV-CONGQ5M4	199500.00	21945.00	0.00	231420.00	\N	\N	cash	completed	\N	2025-12-04 00:00:00	2025-12-04 16:41:35	2026-02-16 20:41:35	\N	0	0	9975.00	\N
3f65b885-52e5-41f4-990f-20790d1f514a	3	1	INV-QTGTNVCG	239000.00	26290.00	0.00	277240.00	\N	\N	qris	completed	\N	2026-01-13 00:00:00	2026-01-13 11:41:35	2026-02-16 20:41:35	\N	0	0	11950.00	\N
9cfc4602-47a6-46dd-aaa5-df172548f889	3	1	INV-ZAI05PBZ	151100.00	16621.00	0.00	175276.00	\N	\N	cash	completed	\N	2026-02-10 00:00:00	2026-02-10 14:41:36	2026-02-16 20:41:36	\N	0	0	7555.00	\N
e8f55dc4-bdea-4e13-aa87-1a73840b99f8	3	1	INV-VM03NN2G	290500.00	31955.00	0.00	336980.00	\N	\N	split	completed	\N	2026-02-03 00:00:00	2026-02-03 14:41:36	2026-02-16 20:41:36	20	0	0	14525.00	\N
9693b3de-60cd-4d8f-bdbb-e49326750f07	3	1	INV-SBJJVNJN	129600.00	14256.00	0.00	150336.00	\N	\N	cash	completed	\N	2025-12-28 00:00:00	2025-12-28 17:41:36	2026-02-16 20:41:36	20	0	0	6480.00	\N
8f2482f4-83a0-49f4-906a-dee0656b7556	3	1	INV-XFIE7XCT	160000.00	17600.00	0.00	185600.00	\N	\N	cash	completed	\N	2026-01-02 00:00:00	2026-01-02 20:41:36	2026-02-16 20:41:36	\N	0	0	8000.00	\N
91afe97a-4ea6-43d4-9637-9db715571221	3	1	INV-YVYPRLO4	34400.00	3784.00	0.00	39904.00	\N	\N	cash	completed	\N	2025-11-24 00:00:00	2025-11-24 18:41:36	2026-02-16 20:41:36	20	0	0	1720.00	\N
443a7f86-9d92-4c58-a3e5-05860f8aa8bb	3	1	INV-EUJYQLF2	380200.00	41822.00	0.00	441032.00	\N	\N	cash	completed	\N	2026-01-27 00:00:00	2026-01-27 19:41:36	2026-02-16 20:41:36	15	0	0	19010.00	\N
a6690e6e-c4db-495f-a553-ec8d4d4625a4	3	1	INV-LXOKD6JQ	147400.00	16214.00	0.00	170984.00	\N	\N	qris	completed	\N	2026-01-26 00:00:00	2026-01-26 19:41:36	2026-02-16 20:41:36	14	0	0	7370.00	\N
e156cc7d-cef9-49ff-9470-2510d73b88d7	3	1	INV-VWVDCUN1	90200.00	9922.00	0.00	104632.00	\N	\N	qris	completed	\N	2026-01-28 00:00:00	2026-01-28 19:41:36	2026-02-16 20:41:36	15	0	0	4510.00	\N
e1c74394-678f-4e31-acb1-fe90f62caf5c	3	1	INV-DD4MCJRD	6400.00	704.00	0.00	7424.00	\N	\N	split	completed	\N	2025-12-04 00:00:00	2025-12-04 12:41:36	2026-02-16 20:41:36	16	0	0	320.00	\N
dd3aef88-b443-4e11-966a-44dabc6fc98a	3	1	INV-4G8I6KUO	43000.00	4730.00	0.00	49880.00	\N	\N	cash	completed	\N	2026-01-05 00:00:00	2026-01-05 20:41:36	2026-02-16 20:41:36	11	0	0	2150.00	\N
b937ff03-2a1f-41b4-a268-bc43b293e3de	3	1	INV-JEN3ETUO	101800.00	11198.00	0.00	118088.00	\N	\N	qris	completed	\N	2025-12-04 00:00:00	2025-12-04 12:41:36	2026-02-16 20:41:36	18	0	0	5090.00	\N
a33e7b7c-8990-4caf-af53-e40e53ca0489	3	1	INV-RMOLFOKZ	125700.00	13827.00	0.00	145812.00	\N	\N	split	completed	\N	2026-01-06 00:00:00	2026-01-06 17:41:36	2026-02-16 20:41:36	\N	0	0	6285.00	\N
ccfd956c-57ca-4ebb-ae7c-88f7f00b21c8	3	1	INV-T9EVZKTB	221900.00	24409.00	0.00	257404.00	\N	\N	split	completed	\N	2025-11-27 00:00:00	2025-11-27 18:41:36	2026-02-16 20:41:36	12	0	0	11095.00	\N
a954dd38-8436-4f6d-bdae-5d133c931aae	3	1	INV-E01NOH0I	121000.00	13310.00	0.00	140360.00	\N	\N	split	completed	\N	2025-12-19 00:00:00	2025-12-19 19:41:36	2026-02-16 20:41:36	13	0	0	6050.00	\N
7e547f2e-13a6-4053-9300-316b3cd70e23	3	1	INV-SDAS4FHK	44800.00	4928.00	0.00	51968.00	\N	\N	cash	completed	\N	2026-01-18 00:00:00	2026-01-18 14:41:36	2026-02-16 20:41:36	18	0	0	2240.00	\N
a6302bd1-b609-4e39-9f28-aef1efff14b5	3	1	INV-OF7MR2VG	164700.00	18117.00	0.00	191052.00	\N	\N	qris	completed	\N	2025-12-26 00:00:00	2025-12-26 11:41:36	2026-02-16 20:41:36	13	0	0	8235.00	\N
8ca6d724-c5db-45be-aeb1-a182c13a5df0	3	1	INV-6HJTJBNX	97600.00	10736.00	0.00	113216.00	\N	\N	cash	completed	\N	2026-01-19 00:00:00	2026-01-19 14:41:36	2026-02-16 20:41:36	\N	0	0	4880.00	\N
add2ef6e-6f45-44d5-b202-356c86cf9842	3	1	INV-R5ZMEX6Y	237600.00	26136.00	0.00	275616.00	\N	\N	qris	completed	\N	2026-01-19 00:00:00	2026-01-19 16:41:36	2026-02-16 20:41:36	11	0	0	11880.00	\N
4f51fb27-da3a-4efc-98cd-b9279233f57f	3	1	INV-CIAMHFG4	282000.00	31020.00	0.00	327120.00	\N	\N	cash	completed	\N	2025-12-09 00:00:00	2025-12-09 18:41:36	2026-02-16 20:41:36	15	0	0	14100.00	\N
321a1991-ae75-4afb-8cce-fb0adc219cf5	3	1	INV-G1482LKR	337400.00	37114.00	0.00	391384.00	\N	\N	split	completed	\N	2025-12-30 00:00:00	2025-12-30 14:41:36	2026-02-16 20:41:36	16	0	0	16870.00	\N
40b2b249-158c-426c-8419-1d03b0e3a631	3	1	INV-OUTNLYNP	122000.00	13420.00	0.00	141520.00	\N	\N	split	completed	\N	2025-12-05 00:00:00	2025-12-05 16:41:36	2026-02-16 20:41:36	\N	0	0	6100.00	\N
09e7cc38-8d12-4060-af02-5607d574ee79	3	1	INV-JJXBUQ5C	50300.00	5533.00	0.00	58348.00	\N	\N	split	completed	\N	2026-01-08 00:00:00	2026-01-08 10:41:36	2026-02-16 20:41:36	17	0	0	2515.00	\N
1ecf4177-369f-4e05-b99b-15d25c9cf9bc	3	1	INV-NFSE5JZZ	273300.00	30063.00	0.00	317028.00	\N	\N	cash	completed	\N	2026-02-04 00:00:00	2026-02-04 19:41:36	2026-02-16 20:41:36	14	0	0	13665.00	\N
c2dd7efe-095c-4b16-9b1f-3ce706cb2a56	3	1	INV-BKRGU1OG	143200.00	15752.00	0.00	166112.00	\N	\N	qris	completed	\N	2025-12-12 00:00:00	2025-12-12 20:41:36	2026-02-16 20:41:36	14	0	0	7160.00	\N
99bfea05-7d69-4405-ac58-216446dc46d9	3	1	INV-ODQSFFTD	199200.00	21912.00	0.00	231072.00	\N	\N	qris	completed	\N	2026-01-27 00:00:00	2026-01-27 16:41:36	2026-02-16 20:41:36	\N	0	0	9960.00	\N
e8383984-c30b-45d9-b456-059485c57a8a	3	1	INV-MDGHSYZH	199500.00	21945.00	0.00	231420.00	\N	\N	cash	completed	\N	2025-11-23 00:00:00	2025-11-23 12:41:36	2026-02-16 20:41:36	15	0	0	9975.00	\N
9ec35e35-0f86-416a-8d84-b9126f8cca86	3	1	INV-5LNKAGVD	252500.00	27775.00	0.00	292900.00	\N	\N	cash	completed	\N	2026-01-01 00:00:00	2026-01-01 19:41:37	2026-02-16 20:41:37	\N	0	0	12625.00	\N
d14ca86b-00ce-46f0-836e-4baa61126563	3	1	INV-4JZ0JPNI	205400.00	22594.00	0.00	238264.00	\N	\N	qris	completed	\N	2026-02-12 00:00:00	2026-02-12 20:41:37	2026-02-16 20:41:37	\N	0	0	10270.00	\N
ecfd457c-a9da-4a9d-b166-a8b119e22512	3	1	INV-DMUG7AIM	30800.00	3388.00	0.00	35728.00	\N	\N	qris	completed	\N	2025-11-18 00:00:00	2025-11-18 12:41:37	2026-02-16 20:41:37	\N	0	0	1540.00	\N
bf6c3576-a761-41e4-8634-ea30dae54eb9	3	1	INV-6NAFGWSQ	46200.00	5082.00	0.00	53592.00	\N	\N	split	completed	\N	2025-12-20 00:00:00	2025-12-20 11:41:37	2026-02-16 20:41:37	13	0	0	2310.00	\N
77661bf5-52ef-4c86-b2dd-44bb9352e38b	3	1	INV-ATOFHV9X	222400.00	24464.00	0.00	257984.00	\N	\N	cash	completed	\N	2026-01-10 00:00:00	2026-01-10 15:41:37	2026-02-16 20:41:37	18	0	0	11120.00	\N
6913e216-5e43-429a-b666-ac4301b6911c	3	1	INV-XAYGYNEN	163100.00	17941.00	0.00	189196.00	\N	\N	cash	completed	\N	2025-12-15 00:00:00	2025-12-15 13:41:37	2026-02-16 20:41:37	16	0	0	8155.00	\N
f3cf17f6-15a5-4775-a10c-ac1020b2f419	3	1	INV-BB44DRV6	131000.00	14410.00	0.00	151960.00	\N	\N	split	completed	\N	2026-01-09 00:00:00	2026-01-09 19:41:37	2026-02-16 20:41:37	11	0	0	6550.00	\N
7bc46921-2dde-426d-8ba4-678a1858532b	3	1	INV-LPU1PZCC	217100.00	23881.00	0.00	251836.00	\N	\N	split	completed	\N	2025-11-26 00:00:00	2025-11-26 15:41:37	2026-02-16 20:41:37	12	0	0	10855.00	\N
52aa32c3-2532-465e-a07c-e9e6ded2c029	3	1	INV-65VLYSUE	67500.00	7425.00	0.00	78300.00	\N	\N	split	completed	\N	2025-11-26 00:00:00	2025-11-26 15:41:37	2026-02-16 20:41:37	\N	0	0	3375.00	\N
3eee2abe-3422-4de6-93ac-01af96978b4a	3	1	INV-Q0SWJVZD	141900.00	15609.00	0.00	164604.00	\N	\N	qris	completed	\N	2026-02-06 00:00:00	2026-02-06 19:41:37	2026-02-16 20:41:37	12	0	0	7095.00	\N
299ef771-2ad3-4236-8e56-535a4671154c	3	1	INV-CK2UFNO4	267500.00	29425.00	0.00	310300.00	\N	\N	cash	completed	\N	2026-01-02 00:00:00	2026-01-02 15:41:37	2026-02-16 20:41:37	15	0	0	13375.00	\N
c4ef6536-c759-4750-889b-86d093308ebb	3	1	INV-VWN6AWFS	205300.00	22583.00	0.00	238148.00	\N	\N	cash	completed	\N	2025-11-29 00:00:00	2025-11-29 14:41:37	2026-02-16 20:41:37	13	0	0	10265.00	\N
95e50fd1-eb30-47bc-a994-ebab966b7010	3	1	INV-ZLX7LOP4	51200.00	5632.00	0.00	59392.00	\N	\N	cash	completed	\N	2026-01-01 00:00:00	2026-01-01 10:41:37	2026-02-16 20:41:37	\N	0	0	2560.00	\N
63cba2a6-10d9-45d5-a11b-c29dbb1f361b	3	1	INV-JOQNWJXC	117600.00	12936.00	0.00	136416.00	\N	\N	qris	completed	\N	2026-02-13 00:00:00	2026-02-13 14:41:37	2026-02-16 20:41:37	15	0	0	5880.00	\N
ffe930cd-cffd-4e60-9ca2-8a08fc1f5a16	3	1	INV-EOJA80J0	99000.00	10890.00	0.00	114840.00	\N	\N	qris	completed	\N	2026-01-03 00:00:00	2026-01-03 12:41:37	2026-02-16 20:41:37	13	0	0	4950.00	\N
79bf03e7-527e-447f-8302-7abf7e0152ca	3	1	INV-D2CSSCAQ	37600.00	4136.00	0.00	43616.00	\N	\N	qris	completed	\N	2025-11-23 00:00:00	2025-11-23 18:41:37	2026-02-16 20:41:37	18	0	0	1880.00	\N
f922b262-bb30-4aa5-a362-a5b86ba600f2	3	1	INV-VPUXXUOD	209400.00	23034.00	0.00	242904.00	\N	\N	qris	completed	\N	2026-01-29 00:00:00	2026-01-29 17:41:37	2026-02-16 20:41:37	15	0	0	10470.00	\N
98926479-995d-423d-9ce5-52fcfc1a0783	3	1	INV-YPSP6TFH	43000.00	4730.00	0.00	49880.00	\N	\N	split	completed	\N	2026-01-09 00:00:00	2026-01-09 18:41:37	2026-02-16 20:41:37	20	0	0	2150.00	\N
4216c01e-f011-409d-9697-95bbab3a0f70	3	1	INV-E2P1ARWK	196400.00	21604.00	0.00	227824.00	\N	\N	split	completed	\N	2025-12-02 00:00:00	2025-12-02 10:41:37	2026-02-16 20:41:37	17	0	0	9820.00	\N
736fb7e1-ada7-44c3-beed-f48acdb133d4	3	1	INV-DQXBYCFQ	297400.00	32714.00	0.00	344984.00	\N	\N	split	completed	\N	2025-11-19 00:00:00	2025-11-19 16:41:37	2026-02-16 20:41:37	11	0	0	14870.00	\N
ce24dd7e-99eb-4895-a5fa-5cc80e4e4cf4	3	1	INV-J67SFKZJ	229600.00	25256.00	0.00	266336.00	\N	\N	split	completed	\N	2026-02-01 00:00:00	2026-02-01 18:41:37	2026-02-16 20:41:37	\N	0	0	11480.00	\N
118f8065-3a5d-49de-86fa-e670ff64bfe3	3	1	INV-VEE2SVGI	164500.00	18095.00	0.00	190820.00	\N	\N	split	completed	\N	2026-01-20 00:00:00	2026-01-20 20:41:37	2026-02-16 20:41:37	\N	0	0	8225.00	\N
32d85914-5fd2-4fc9-ac33-37eb478e79b9	3	1	INV-OIHLLR0U	61200.00	6732.00	0.00	70992.00	\N	\N	split	completed	\N	2026-01-17 00:00:00	2026-01-17 20:41:37	2026-02-16 20:41:37	13	0	0	3060.00	\N
56f7f7e8-e154-4fa1-9374-a5198a1ced32	3	1	INV-5WJIPA8R	208300.00	22913.00	0.00	241628.00	\N	\N	cash	completed	\N	2025-12-19 00:00:00	2025-12-19 18:41:37	2026-02-16 20:41:37	19	0	0	10415.00	\N
bdba88e6-dcb0-499c-9f28-2a81c3940f45	3	1	INV-2XE3RRJE	35900.00	3949.00	0.00	41644.00	\N	\N	split	completed	\N	2025-12-31 00:00:00	2025-12-31 16:41:37	2026-02-16 20:41:37	15	0	0	1795.00	\N
a66992e5-e3e0-466c-a185-1b7722921735	3	1	INV-T8U523MZ	86000.00	9460.00	0.00	99760.00	\N	\N	cash	completed	\N	2026-01-10 00:00:00	2026-01-10 13:41:37	2026-02-16 20:41:37	20	0	0	4300.00	\N
b405e841-0115-43cc-8c65-99345c2e48db	3	1	INV-OJUVLSHX	178900.00	19679.00	0.00	207524.00	\N	\N	cash	completed	\N	2026-02-13 00:00:00	2026-02-13 11:41:37	2026-02-16 20:41:37	11	0	0	8945.00	\N
0b2dd5e8-04ef-4233-b6a1-ac1ca2f2b277	3	1	INV-ABP5FY6A	172000.00	18920.00	0.00	199520.00	\N	\N	cash	completed	\N	2026-02-07 00:00:00	2026-02-07 19:41:37	2026-02-16 20:41:37	\N	0	0	8600.00	\N
d458822e-f0b8-4273-8cc1-ffb0784d9a35	3	1	INV-NHDTDTED	170100.00	18711.00	0.00	197316.00	\N	\N	qris	completed	\N	2026-02-03 00:00:00	2026-02-03 18:41:37	2026-02-16 20:41:37	15	0	0	8505.00	\N
a79ce322-349b-4d46-be93-eec40c315c63	3	1	INV-BTODEURL	217400.00	23914.00	0.00	252184.00	\N	\N	cash	completed	\N	2025-12-14 00:00:00	2025-12-14 12:41:38	2026-02-16 20:41:38	18	0	0	10870.00	\N
9e0ef86b-485c-477b-85b8-efd4030ebc64	3	1	INV-TPHYFBWU	30000.00	3300.00	0.00	34800.00	\N	\N	split	completed	\N	2025-11-26 00:00:00	2025-11-26 14:41:38	2026-02-16 20:41:38	20	0	0	1500.00	\N
9615de99-8c1e-4a91-b177-ed5273aa2a34	3	1	INV-O9MMGDG7	248600.00	27346.00	0.00	288376.00	\N	\N	split	completed	\N	2026-01-28 00:00:00	2026-01-28 13:41:38	2026-02-16 20:41:38	19	0	0	12430.00	\N
b8987741-eb62-48bc-a5cf-406843e558bc	3	1	INV-BUYPZFI4	114000.00	12540.00	0.00	132240.00	\N	\N	split	completed	\N	2026-01-16 00:00:00	2026-01-16 18:41:38	2026-02-16 20:41:38	19	0	0	5700.00	\N
01fa55a7-1d6d-4615-a487-f36d8eecfd03	3	1	INV-2EXZSIAH	28500.00	3135.00	0.00	33060.00	\N	\N	split	completed	\N	2025-11-28 00:00:00	2025-11-28 10:41:38	2026-02-16 20:41:38	16	0	0	1425.00	\N
7994d293-d4f9-49a3-922c-2bb38d0e5231	3	1	INV-JKGVHRW3	101100.00	11121.00	0.00	117276.00	\N	\N	split	completed	\N	2025-11-22 00:00:00	2025-11-22 10:41:38	2026-02-16 20:41:38	17	0	0	5055.00	\N
e6ac1e5c-b9d3-45d3-afb5-db1ffd4e9d6e	3	1	INV-I2V6F5GO	247000.00	27170.00	0.00	286520.00	\N	\N	qris	completed	\N	2025-12-15 00:00:00	2025-12-15 11:41:38	2026-02-16 20:41:38	20	0	0	12350.00	\N
942d1999-2686-418b-8725-6a2577a65f92	3	1	INV-CCJUNUAZ	271200.00	29832.00	0.00	314592.00	\N	\N	qris	completed	\N	2026-01-23 00:00:00	2026-01-23 15:41:38	2026-02-16 20:41:38	\N	0	0	13560.00	\N
b7890def-eb0e-4da0-ad60-4da728e71d63	3	1	INV-IPAMMHIB	198800.00	21868.00	0.00	230608.00	\N	\N	split	completed	\N	2026-01-05 00:00:00	2026-01-05 19:41:38	2026-02-16 20:41:38	11	0	0	9940.00	\N
d63bd6f8-1fa0-41fa-9965-512477bc89be	3	1	INV-YSBGAQR3	50000.00	5500.00	0.00	58000.00	\N	\N	split	completed	\N	2026-02-07 00:00:00	2026-02-07 10:41:38	2026-02-16 20:41:38	20	0	0	2500.00	\N
fa8bf67b-964d-4dc7-bc8f-d8672c4295f7	3	1	INV-CJAWFGNE	183400.00	20174.00	0.00	212744.00	\N	\N	split	completed	\N	2025-12-31 00:00:00	2025-12-31 16:41:38	2026-02-16 20:41:38	20	0	0	9170.00	\N
995b51ae-bfb4-4dc1-9c9a-d300c57f8eac	3	1	INV-CAMSTUSS	195500.00	21505.00	0.00	226780.00	\N	\N	qris	completed	\N	2025-11-20 00:00:00	2025-11-20 18:41:38	2026-02-16 20:41:38	17	0	0	9775.00	\N
a938fea0-97a9-4b18-9ea7-06b53a306fee	3	1	INV-KIWJIZH1	327900.00	36069.00	0.00	380364.00	\N	\N	qris	completed	\N	2026-01-06 00:00:00	2026-01-06 18:41:38	2026-02-16 20:41:38	19	0	0	16395.00	\N
90d9e660-704a-40da-9d07-a39f9ba8997c	3	1	INV-INUZBT0E	108300.00	11913.00	0.00	125628.00	\N	\N	cash	completed	\N	2026-01-19 00:00:00	2026-01-19 11:41:38	2026-02-16 20:41:38	\N	0	0	5415.00	\N
ab4cd8ae-5408-421a-998f-6225cc1aa6db	3	1	INV-EBCN0CTI	136200.00	14982.00	0.00	157992.00	\N	\N	cash	completed	\N	2026-01-21 00:00:00	2026-01-21 13:41:38	2026-02-16 20:41:38	14	0	0	6810.00	\N
bb6ab572-5b4d-41a7-87c0-3194bb82d3f1	3	1	INV-KFQWANUP	153400.00	16874.00	0.00	177944.00	\N	\N	split	completed	\N	2025-12-05 00:00:00	2025-12-05 14:41:38	2026-02-16 20:41:38	20	0	0	7670.00	\N
55e818c1-bf27-456e-bb22-4a405cc49655	3	1	INV-9RHMQJNK	82400.00	9064.00	0.00	95584.00	\N	\N	cash	completed	\N	2026-02-14 00:00:00	2026-02-14 14:41:38	2026-02-16 20:41:38	\N	0	0	4120.00	\N
0c7b090a-f93a-4444-ba60-1c8a77f3f18f	3	1	INV-IQMSJFXQ	166200.00	18282.00	0.00	192792.00	\N	\N	split	completed	\N	2026-01-20 00:00:00	2026-01-20 16:41:38	2026-02-16 20:41:38	20	0	0	8310.00	\N
2781a08a-96bb-4b2b-a212-368272a46873	3	1	INV-T15R8L29	60600.00	6666.00	0.00	70296.00	\N	\N	split	completed	\N	2025-12-12 00:00:00	2025-12-12 15:41:38	2026-02-16 20:41:38	20	0	0	3030.00	\N
a95ee628-3417-4489-bd23-edae96d54e72	3	1	INV-T7A76SW0	116200.00	12782.00	0.00	134792.00	\N	\N	qris	completed	\N	2025-12-19 00:00:00	2025-12-19 19:41:38	2026-02-16 20:41:38	\N	0	0	5810.00	\N
d5071524-8b0a-4685-a410-f725dd3e8706	3	1	INV-VTRC1PDE	297700.00	32747.00	0.00	345332.00	\N	\N	qris	completed	\N	2026-02-03 00:00:00	2026-02-03 14:41:38	2026-02-16 20:41:38	\N	0	0	14885.00	\N
f616be7c-0a16-4bc7-93a6-dede170f9759	3	1	INV-S0PWNJRU	7200.00	792.00	0.00	8352.00	\N	\N	cash	completed	\N	2026-01-13 00:00:00	2026-01-13 11:41:38	2026-02-16 20:41:38	\N	0	0	360.00	\N
3260eea4-eac1-42a7-ace0-ddefc87b0d7e	3	1	INV-4ZHVPUME	158100.00	17391.00	0.00	183396.00	\N	\N	qris	completed	\N	2025-12-01 00:00:00	2025-12-01 14:41:38	2026-02-16 20:41:38	\N	0	0	7905.00	\N
4a59c7ba-9b2d-43dc-98ae-c148265686a4	3	1	INV-WVYCY3I1	46200.00	5082.00	0.00	53592.00	\N	\N	qris	completed	\N	2026-01-05 00:00:00	2026-01-05 19:41:38	2026-02-16 20:41:38	\N	0	0	2310.00	\N
cd8f86a1-3c3e-4d37-869a-ab8b2e40db1b	3	1	INV-OTMVDOGK	60200.00	6622.00	0.00	69832.00	\N	\N	split	completed	\N	2025-12-20 00:00:00	2025-12-20 17:41:38	2026-02-16 20:41:38	19	0	0	3010.00	\N
2ef661f1-76df-430f-81f4-820862dadbed	3	1	INV-5EO9SVI9	111100.00	12221.00	0.00	128876.00	\N	\N	cash	completed	\N	2025-11-22 00:00:00	2025-11-22 20:41:38	2026-02-16 20:41:38	\N	0	0	5555.00	\N
0fb317e1-7b3a-468a-82bd-8d3d8bc6a217	3	1	INV-MHKTMHU1	386400.00	42504.00	0.00	448224.00	\N	\N	cash	completed	\N	2026-02-14 00:00:00	2026-02-14 18:41:39	2026-02-16 20:41:39	18	0	0	19320.00	\N
727caa62-013a-485a-8d6d-e0c51aa61473	3	1	INV-8HOKHKS5	90200.00	9922.00	0.00	104632.00	\N	\N	cash	completed	\N	2026-01-20 00:00:00	2026-01-20 11:41:39	2026-02-16 20:41:39	18	0	0	4510.00	\N
a5879b4a-cf34-46b5-ad07-90c592949d9a	3	1	INV-6ZKM5OAK	67200.00	7392.00	0.00	77952.00	\N	\N	split	completed	\N	2025-12-24 00:00:00	2025-12-24 20:41:39	2026-02-16 20:41:39	20	0	0	3360.00	\N
cf6fb3cd-c653-4326-b6b7-88d6c4c28f9b	3	1	INV-0N1JCKYQ	154800.00	17028.00	0.00	179568.00	\N	\N	qris	completed	\N	2025-12-25 00:00:00	2025-12-25 11:41:39	2026-02-16 20:41:39	15	0	0	7740.00	\N
3ed44ab0-2a5d-4a01-a5ee-f834661802d9	3	1	INV-RWGSN913	234300.00	25773.00	0.00	271788.00	\N	\N	qris	completed	\N	2026-02-12 00:00:00	2026-02-12 13:41:39	2026-02-16 20:41:39	\N	0	0	11715.00	\N
4fa88121-4abb-4063-b858-5822a394aff5	3	1	INV-V9OEDHWY	44100.00	4851.00	0.00	51156.00	\N	\N	cash	completed	\N	2025-11-28 00:00:00	2025-11-28 17:41:39	2026-02-16 20:41:39	20	0	0	2205.00	\N
ad68e5e5-fed1-45d7-8c59-8aedf23d50b1	3	1	INV-VCQRDCDV	20200.00	2222.00	0.00	23432.00	\N	\N	cash	completed	\N	2025-12-09 00:00:00	2025-12-09 14:41:39	2026-02-16 20:41:39	18	0	0	1010.00	\N
b9a955ba-84ea-4c66-9d2d-d8e126088270	3	1	INV-SI25UISX	51900.00	5709.00	0.00	60204.00	\N	\N	qris	completed	\N	2026-01-22 00:00:00	2026-01-22 10:41:39	2026-02-16 20:41:39	11	0	0	2595.00	\N
2cfc2236-89c4-4011-bc08-5ae57653b9c0	3	1	INV-DZPYFXA9	180200.00	19822.00	0.00	209032.00	\N	\N	split	completed	\N	2026-02-03 00:00:00	2026-02-03 10:41:39	2026-02-16 20:41:39	18	0	0	9010.00	\N
f1b769d2-f458-4509-878d-8a962ea00668	3	1	INV-NUSQFBUW	56100.00	6171.00	0.00	65076.00	\N	\N	cash	completed	\N	2026-02-09 00:00:00	2026-02-09 16:41:39	2026-02-16 20:41:39	\N	0	0	2805.00	\N
d2ab7468-becb-4a12-947a-1bbeaf16f048	3	1	INV-FBCINPC2	94300.00	10373.00	0.00	109388.00	\N	\N	cash	completed	\N	2026-01-07 00:00:00	2026-01-07 19:41:39	2026-02-16 20:41:39	19	0	0	4715.00	\N
225aafff-4b82-42ab-bbe7-15174202a14e	3	1	INV-HKNT4XKX	143300.00	15763.00	0.00	166228.00	\N	\N	cash	completed	\N	2025-12-19 00:00:00	2025-12-19 17:41:39	2026-02-16 20:41:39	16	0	0	7165.00	\N
3ae1d235-b61d-411a-8940-4b03bfb044a8	3	1	INV-DDXONATC	244700.00	26917.00	0.00	283852.00	\N	\N	qris	completed	\N	2026-01-21 00:00:00	2026-01-21 16:41:39	2026-02-16 20:41:39	17	0	0	12235.00	\N
b0b0ff12-ad8f-4634-a44c-7594c9984832	3	1	INV-PAQDLEJX	293900.00	32329.00	0.00	340924.00	\N	\N	cash	completed	\N	2025-11-22 00:00:00	2025-11-22 16:41:39	2026-02-16 20:41:39	17	0	0	14695.00	\N
04a8f340-dbdb-497d-af21-9ed3afbe7b55	3	1	INV-TWDIUSVQ	85800.00	9438.00	0.00	99528.00	\N	\N	cash	completed	\N	2026-01-14 00:00:00	2026-01-14 14:41:39	2026-02-16 20:41:39	19	0	0	4290.00	\N
c1cbb89e-96f2-4070-bfeb-645a366a3adb	3	1	INV-I3HIZPGW	112000.00	12320.00	0.00	129920.00	\N	\N	cash	completed	\N	2026-02-14 00:00:00	2026-02-14 11:41:39	2026-02-16 20:41:39	14	0	0	5600.00	\N
ff3603c7-42f7-4d13-a790-26399c685432	3	1	INV-EVZQLKSW	289600.00	31856.00	0.00	335936.00	\N	\N	split	completed	\N	2025-11-21 00:00:00	2025-11-21 14:41:39	2026-02-16 20:41:39	11	0	0	14480.00	\N
0df10c7f-1284-40c9-8c41-21a925ee0eb1	3	1	INV-P5FS4U15	3600.00	396.00	0.00	4176.00	\N	\N	qris	completed	\N	2025-11-18 00:00:00	2025-11-18 17:41:39	2026-02-16 20:41:39	14	0	0	180.00	\N
537c6ae6-7ac3-40e8-afe0-249fbf996e9d	3	1	INV-NIAQG47H	136800.00	15048.00	0.00	158688.00	\N	\N	qris	completed	\N	2025-12-04 00:00:00	2025-12-04 10:41:39	2026-02-16 20:41:39	13	0	0	6840.00	\N
0f913f1d-a45e-4933-bb5d-0dcd67b48e14	3	1	INV-JTHBC1MO	188800.00	20768.00	0.00	219008.00	\N	\N	cash	completed	\N	2025-12-23 00:00:00	2025-12-23 12:41:39	2026-02-16 20:41:39	15	0	0	9440.00	\N
8a84aca9-17f5-4b34-9aba-ce417d7788af	3	1	INV-0SBPKIZS	270700.00	29777.00	0.00	314012.00	\N	\N	cash	completed	\N	2026-01-01 00:00:00	2026-01-01 11:41:39	2026-02-16 20:41:39	16	0	0	13535.00	\N
78fe7023-96e9-4d80-86e7-c6d41b83354f	3	1	INV-XJOYRWKG	50000.00	5500.00	0.00	58000.00	\N	\N	split	completed	\N	2026-01-22 00:00:00	2026-01-22 15:41:39	2026-02-16 20:41:39	12	0	0	2500.00	\N
4746975d-3433-4c5c-a982-dd316fa316b1	3	1	INV-IMLQHMJX	85900.00	9449.00	0.00	99644.00	\N	\N	cash	completed	\N	2025-12-27 00:00:00	2025-12-27 17:41:39	2026-02-16 20:41:39	14	0	0	4295.00	\N
e342e291-9540-42cf-9b91-83545d2c0282	3	1	INV-LRE1KEPY	121500.00	13365.00	0.00	140940.00	\N	\N	qris	completed	\N	2026-01-13 00:00:00	2026-01-13 15:41:39	2026-02-16 20:41:39	13	0	0	6075.00	\N
fbe82d55-50c4-48dc-87c7-b8db12280e6a	3	1	INV-MXIJUZLD	199400.00	21934.00	0.00	231304.00	\N	\N	cash	completed	\N	2025-11-21 00:00:00	2025-11-21 16:41:39	2026-02-16 20:41:39	16	0	0	9970.00	\N
33720b9d-0bb3-49dd-8f55-acda2bad60c8	3	1	INV-OJ7PSUOA	228600.00	25146.00	0.00	265176.00	\N	\N	split	completed	\N	2026-02-15 00:00:00	2026-02-15 11:41:39	2026-02-16 20:41:39	17	0	0	11430.00	\N
f4c6b6d3-99ee-407e-a204-eaa0029872ff	3	1	INV-SHC4JIA2	65000.00	7150.00	0.00	75400.00	\N	\N	cash	completed	\N	2026-01-16 00:00:00	2026-01-16 19:41:39	2026-02-16 20:41:39	20	0	0	3250.00	\N
cd7a476c-c8d5-421a-8982-5b03429f760c	3	1	INV-N8J5AHVD	75800.00	8338.00	0.00	87928.00	\N	\N	split	completed	\N	2025-11-27 00:00:00	2025-11-27 16:41:39	2026-02-16 20:41:39	\N	0	0	3790.00	\N
b3087cfa-bac9-46cd-9deb-e52087ac1e18	3	1	INV-N3EKLVGE	150900.00	16599.00	0.00	175044.00	\N	\N	qris	completed	\N	2025-11-18 00:00:00	2025-11-18 18:41:39	2026-02-16 20:41:39	16	0	0	7545.00	\N
9c124cc5-a7b6-448b-8890-23380cbe2ddf	3	1	INV-RKJGX89F	52800.00	5808.00	0.00	61248.00	\N	\N	cash	completed	\N	2025-12-11 00:00:00	2025-12-11 12:41:39	2026-02-16 20:41:39	18	0	0	2640.00	\N
6f67a262-389c-42de-9525-890d792411b5	3	1	INV-AAEN6RGD	178900.00	19679.00	0.00	207524.00	\N	\N	split	completed	\N	2025-12-24 00:00:00	2025-12-24 13:41:40	2026-02-16 20:41:40	12	0	0	8945.00	\N
f4f1e4d3-fb5e-475d-9694-6f78193366c8	3	1	INV-VSJ8VJLV	163800.00	18018.00	0.00	190008.00	\N	\N	split	completed	\N	2025-12-19 00:00:00	2025-12-19 11:41:40	2026-02-16 20:41:40	17	0	0	8190.00	\N
fb797629-0597-41b6-a3d6-55d115635e44	3	1	INV-Y6BCRJE0	46200.00	5082.00	0.00	53592.00	\N	\N	cash	completed	\N	2026-01-24 00:00:00	2026-01-24 16:41:40	2026-02-16 20:41:40	19	0	0	2310.00	\N
8a2582aa-95a2-4530-b08b-fe66f8cede61	3	1	INV-EITF2TSD	199500.00	21945.00	0.00	231420.00	\N	\N	cash	completed	\N	2025-12-30 00:00:00	2025-12-30 16:41:40	2026-02-16 20:41:40	19	0	0	9975.00	\N
5b41714f-2bc4-46bf-b6e7-4442f00c1bff	3	1	INV-Y0NAQOO8	369800.00	40678.00	0.00	428968.00	\N	\N	split	completed	\N	2025-12-14 00:00:00	2025-12-14 13:41:40	2026-02-16 20:41:40	\N	0	0	18490.00	\N
7b9d34a4-765b-49ef-8ac0-d59beedc11d6	3	1	INV-VN0SKOUF	33300.00	3663.00	0.00	38628.00	\N	\N	qris	completed	\N	2026-01-04 00:00:00	2026-01-04 20:41:40	2026-02-16 20:41:40	18	0	0	1665.00	\N
eff31b71-230b-4452-b8f5-2e8b31c645eb	3	1	INV-ROA6IKUP	136400.00	15004.00	0.00	158224.00	\N	\N	split	completed	\N	2025-12-23 00:00:00	2025-12-23 14:41:40	2026-02-16 20:41:40	11	0	0	6820.00	\N
8f76782e-e024-4318-9f15-98f6d6fed88c	3	1	INV-OENT4GQC	78400.00	8624.00	0.00	90944.00	\N	\N	qris	completed	\N	2026-02-14 00:00:00	2026-02-14 12:41:40	2026-02-16 20:41:40	17	0	0	3920.00	\N
25977f24-cdb8-432d-b67e-76f696ff6ee3	3	1	INV-F0JBLZMU	301100.00	33121.00	0.00	349276.00	\N	\N	split	completed	\N	2025-12-15 00:00:00	2025-12-15 17:41:40	2026-02-16 20:41:40	\N	0	0	15055.00	\N
2b442b28-d806-4d3e-b55b-e88e8eb04e82	3	1	INV-VFLGMIPF	22100.00	2431.00	0.00	25636.00	\N	\N	split	completed	\N	2025-12-27 00:00:00	2025-12-27 15:41:40	2026-02-16 20:41:40	\N	0	0	1105.00	\N
7ce3b96c-146f-4d61-ac1e-41cfebd7c6a8	3	1	INV-1BG2NGOW	292600.00	32186.00	0.00	339416.00	\N	\N	split	completed	\N	2026-02-07 00:00:00	2026-02-07 16:41:40	2026-02-16 20:41:40	\N	0	0	14630.00	\N
24219aa0-0bc6-499b-b1d2-070936e1d2aa	3	1	INV-BXHSPXZ2	125600.00	13816.00	0.00	145696.00	\N	\N	cash	completed	\N	2026-01-12 00:00:00	2026-01-12 20:41:40	2026-02-16 20:41:40	16	0	0	6280.00	\N
64232d2e-43bf-4477-bd56-640cccd20a81	3	1	INV-A7P7OYXQ	153500.00	16885.00	0.00	178060.00	\N	\N	cash	completed	\N	2025-11-27 00:00:00	2025-11-27 18:41:40	2026-02-16 20:41:40	18	0	0	7675.00	\N
e294ebcb-3ade-49d2-ba5a-4aaaa05bdf38	3	1	INV-GO7NNGSW	150800.00	16588.00	0.00	174928.00	\N	\N	qris	completed	\N	2026-01-13 00:00:00	2026-01-13 13:41:40	2026-02-16 20:41:40	15	0	0	7540.00	\N
2791cb11-3bf8-4333-9eaf-a3b8771df088	3	1	INV-CEDESXO9	47400.00	5214.00	0.00	54984.00	\N	\N	split	completed	\N	2026-01-04 00:00:00	2026-01-04 14:41:40	2026-02-16 20:41:40	\N	0	0	2370.00	\N
5095f47a-957b-4199-9210-fb68fe4b7612	3	1	INV-RJSI8PRS	330700.00	36377.00	0.00	383612.00	\N	\N	qris	completed	\N	2026-01-28 00:00:00	2026-01-28 14:41:40	2026-02-16 20:41:40	\N	0	0	16535.00	\N
68833413-152d-4265-974b-4930be090e82	3	1	INV-TVHAZPAB	198000.00	21780.00	0.00	229680.00	\N	\N	cash	completed	\N	2026-02-15 00:00:00	2026-02-15 12:41:40	2026-02-16 20:41:40	\N	0	0	9900.00	\N
20933749-2a8f-4bc7-b366-887f7d3c4139	3	1	INV-YY802MYR	169200.00	18612.00	0.00	196272.00	\N	\N	cash	completed	\N	2025-12-18 00:00:00	2025-12-18 16:41:40	2026-02-16 20:41:40	12	0	0	8460.00	\N
b07a6ee2-f011-4e1c-b25f-7b7d60ab41fc	3	1	INV-B1ZOZV96	83800.00	9218.00	0.00	97208.00	\N	\N	qris	completed	\N	2026-01-29 00:00:00	2026-01-29 14:41:40	2026-02-16 20:41:40	12	0	0	4190.00	\N
6dd3ccec-5783-44fd-82a2-d128c8df8045	3	1	INV-L3GOHPBC	62800.00	6908.00	0.00	72848.00	\N	\N	split	completed	\N	2025-11-29 00:00:00	2025-11-29 19:41:40	2026-02-16 20:41:40	\N	0	0	3140.00	\N
d4ea9ee7-a910-4524-8893-441e58a7cb68	3	1	INV-BA0KQKY0	138200.00	15202.00	0.00	160312.00	\N	\N	cash	completed	\N	2026-01-19 00:00:00	2026-01-19 11:41:40	2026-02-16 20:41:40	13	0	0	6910.00	\N
86be78cb-8573-409c-b3d4-18b98253c022	3	1	INV-M6EPIIVY	263700.00	29007.00	0.00	305892.00	\N	\N	qris	completed	\N	2026-01-04 00:00:00	2026-01-04 14:41:40	2026-02-16 20:41:40	20	0	0	13185.00	\N
3820db60-a65b-4fed-a285-b22b92d2760e	3	1	INV-NIYBSIYY	40500.00	4455.00	0.00	46980.00	\N	\N	qris	completed	\N	2025-12-30 00:00:00	2025-12-30 15:41:40	2026-02-16 20:41:40	19	0	0	2025.00	\N
48f7a7ee-baee-4282-ab41-0a51f4748593	3	1	INV-QLLHK9T6	280500.00	30855.00	0.00	325380.00	\N	\N	split	completed	\N	2026-01-25 00:00:00	2026-01-25 15:41:40	2026-02-16 20:41:40	12	0	0	14025.00	\N
bc3fd44d-2056-4ac0-920a-6e4142ad4738	3	1	INV-EES9YQAC	170100.00	18711.00	0.00	197316.00	\N	\N	cash	completed	\N	2025-11-21 00:00:00	2025-11-21 18:41:40	2026-02-16 20:41:40	18	0	0	8505.00	\N
bd6cacba-82db-4d1f-a6f6-dba7ec4a96ad	3	1	INV-LUU7ALRA	80100.00	8811.00	0.00	92916.00	\N	\N	split	completed	\N	2026-01-21 00:00:00	2026-01-21 18:41:40	2026-02-16 20:41:40	20	0	0	4005.00	\N
30a7e30c-3b52-43ee-9847-dbb367e7ccf0	3	1	INV-SLCKSTOF	175400.00	19294.00	0.00	203464.00	\N	\N	qris	completed	\N	2025-12-31 00:00:00	2025-12-31 17:41:40	2026-02-16 20:41:40	15	0	0	8770.00	\N
7d4f3958-379c-456f-a919-169e49624270	3	1	INV-E7CH6EJ1	402800.00	44308.00	0.00	467248.00	\N	\N	qris	completed	\N	2026-01-15 00:00:00	2026-01-15 10:41:40	2026-02-16 20:41:40	\N	0	0	20140.00	\N
ddad3d22-589e-4be4-8268-903348883e2e	3	1	INV-FCRA5YES	84000.00	9240.00	0.00	97440.00	\N	\N	cash	completed	\N	2025-12-12 00:00:00	2025-12-12 18:41:40	2026-02-16 20:41:40	13	0	0	4200.00	\N
bbb136ed-4db9-40ef-b9ff-ea6384033449	3	1	INV-IZVDKFC7	115300.00	12683.00	0.00	133748.00	\N	\N	split	completed	\N	2025-11-26 00:00:00	2025-11-26 20:41:40	2026-02-16 20:41:40	11	0	0	5765.00	\N
3e064ffb-cf31-43e8-b91c-c75feca623dc	3	1	INV-DKFTXASY	288200.00	31702.00	0.00	334312.00	\N	\N	qris	completed	\N	2025-11-21 00:00:00	2025-11-21 19:41:41	2026-02-16 20:41:41	16	0	0	14410.00	\N
0ae956b3-5857-40d3-b60e-97ec88f3a244	3	1	INV-LYFGKNHS	139300.00	15323.00	0.00	161588.00	\N	\N	qris	completed	\N	2025-11-28 00:00:00	2025-11-28 12:41:41	2026-02-16 20:41:41	19	0	0	6965.00	\N
354430f1-2527-4edd-b375-f7264f41d50f	3	1	INV-YXG9YSXC	44100.00	4851.00	0.00	51156.00	\N	\N	split	completed	\N	2026-01-14 00:00:00	2026-01-14 18:41:41	2026-02-16 20:41:41	19	0	0	2205.00	\N
7092b1a4-f5d0-427b-af1a-09d1b64ce16d	3	1	INV-MXFMXRLO	303600.00	33396.00	0.00	352176.00	\N	\N	cash	completed	\N	2025-12-27 00:00:00	2025-12-27 11:41:41	2026-02-16 20:41:41	11	0	0	15180.00	\N
554401ed-f3c8-4dd0-ac49-9af0c6b0ece1	3	1	INV-LO5C4WG6	165200.00	18172.00	0.00	191632.00	\N	\N	cash	completed	\N	2026-01-11 00:00:00	2026-01-11 18:41:41	2026-02-16 20:41:41	20	0	0	8260.00	\N
87a397cc-c686-4c64-978c-75bf338082a3	3	1	INV-SVEFNWJI	84600.00	9306.00	0.00	98136.00	\N	\N	qris	completed	\N	2026-01-03 00:00:00	2026-01-03 15:41:41	2026-02-16 20:41:41	12	0	0	4230.00	\N
1585ddd5-3ac0-4f16-95a3-ffa37dab9a6c	3	1	INV-V4VN5JJV	241900.00	26609.00	0.00	280604.00	\N	\N	cash	completed	\N	2026-01-22 00:00:00	2026-01-22 12:41:41	2026-02-16 20:41:41	13	0	0	12095.00	\N
19c241e1-adb1-4e3e-a2c2-b9e7db113696	3	1	INV-1CQK3WMK	37300.00	4103.00	0.00	43268.00	\N	\N	qris	completed	\N	2026-02-11 00:00:00	2026-02-11 20:41:41	2026-02-16 20:41:41	\N	0	0	1865.00	\N
3fcb2441-4105-446d-a152-c09bcc46919a	3	1	INV-C1UELFLE	190400.00	20944.00	0.00	220864.00	\N	\N	split	completed	\N	2026-01-30 00:00:00	2026-01-30 11:41:41	2026-02-16 20:41:41	11	0	0	9520.00	\N
93f97d4c-f935-45a9-9273-f937e1b6b9a4	3	1	INV-MAMDWN36	272800.00	30008.00	0.00	316448.00	\N	\N	qris	completed	\N	2026-02-03 00:00:00	2026-02-03 16:41:41	2026-02-16 20:41:41	14	0	0	13640.00	\N
5a6b18ec-826c-4b94-9020-214b862d4632	3	1	INV-8E59LQMZ	364300.00	40073.00	0.00	422588.00	\N	\N	split	completed	\N	2026-01-23 00:00:00	2026-01-23 15:41:41	2026-02-16 20:41:41	20	0	0	18215.00	\N
cca5f8a9-67d9-4e05-ac07-5ac113868649	3	1	INV-UNIHZGQX	115900.00	12749.00	0.00	134444.00	\N	\N	split	completed	\N	2025-12-21 00:00:00	2025-12-21 19:41:41	2026-02-16 20:41:41	14	0	0	5795.00	\N
19fb0a2e-13cc-43cd-b0dc-812675d85a70	3	1	INV-RZGEHNAU	184800.00	20328.00	0.00	214368.00	\N	\N	split	completed	\N	2026-01-27 00:00:00	2026-01-27 12:41:41	2026-02-16 20:41:41	19	0	0	9240.00	\N
39fc5c77-58b5-4986-8b6b-6df3eee20604	3	1	INV-TEIQOJFX	163000.00	17930.00	0.00	189080.00	\N	\N	qris	completed	\N	2026-01-24 00:00:00	2026-01-24 13:41:41	2026-02-16 20:41:41	\N	0	0	8150.00	\N
e7c995a9-d384-4824-833c-0d9c3eb4f583	3	1	INV-FX6A7POD	110400.00	12144.00	0.00	128064.00	\N	\N	cash	completed	\N	2025-12-20 00:00:00	2025-12-20 19:41:41	2026-02-16 20:41:41	13	0	0	5520.00	\N
cc3e329c-757a-42ff-8594-9e09a91c5be2	3	1	INV-BMX4M7IO	263200.00	28952.00	0.00	305312.00	\N	\N	qris	completed	\N	2026-01-25 00:00:00	2026-01-25 12:41:41	2026-02-16 20:41:41	18	0	0	13160.00	\N
3fd9a1de-2e81-44c6-809e-d1ee51cbf203	3	1	INV-PX0QKNZW	64200.00	7062.00	0.00	74472.00	\N	\N	qris	completed	\N	2025-12-08 00:00:00	2025-12-08 19:41:41	2026-02-16 20:41:41	19	0	0	3210.00	\N
2598e10d-98bf-4433-b35f-d459e5c61e47	3	1	INV-VFHEPCSW	87000.00	9570.00	0.00	100920.00	\N	\N	qris	completed	\N	2026-02-04 00:00:00	2026-02-04 10:41:41	2026-02-16 20:41:41	\N	0	0	4350.00	\N
ecdbf687-66d7-4cd5-9ecc-a9a781415f24	3	1	INV-ZJFY1IXI	221400.00	24354.00	0.00	256824.00	\N	\N	qris	completed	\N	2026-01-09 00:00:00	2026-01-09 20:41:41	2026-02-16 20:41:41	16	0	0	11070.00	\N
64fda2a1-4db7-4de4-9aa5-259fd17a6981	3	1	INV-MMSKODJB	90000.00	9900.00	0.00	104400.00	\N	\N	split	completed	\N	2025-12-20 00:00:00	2025-12-20 19:41:41	2026-02-16 20:41:41	\N	0	0	4500.00	\N
752f6c69-9a72-48df-a07c-0d25de02091a	3	1	INV-QFLHORVL	108900.00	11979.00	0.00	126324.00	\N	\N	split	completed	\N	2025-11-26 00:00:00	2025-11-26 13:41:41	2026-02-16 20:41:41	20	0	0	5445.00	\N
afc84a08-8503-404b-9162-3e8dd1c1e945	3	1	INV-N4JPZXXG	80800.00	8888.00	0.00	93728.00	\N	\N	qris	completed	\N	2025-11-30 00:00:00	2025-11-30 20:41:41	2026-02-16 20:41:41	20	0	0	4040.00	\N
55161f9e-74f9-4c27-8d03-c7df4993026f	1	8	INV-260217-0002	760000.00	83600.00	0.00	843600.00	900000.00	56400.00	cash	completed	\N	2026-02-17 04:47:03	2026-02-17 04:47:03	2026-02-17 04:47:03	\N	0	0	0.00	[{"method":"cash","amount":843600,"reference":null}]
8e629cc1-d0b0-424d-8cce-528fb0bf3a70	1	8	INV-260217-0003	114000.00	12540.00	0.00	126540.00	200000.00	73460.00	cash	completed	\N	2026-02-17 04:48:58	2026-02-17 04:48:58	2026-02-17 04:48:58	\N	0	0	0.00	[{"method":"cash","amount":126540,"reference":null}]
1339ec0e-6d13-4a4b-a81f-a0ebe168b96d	1	8	INV-260217-0004	449000.00	49390.00	0.00	498390.00	500000.00	1610.00	cash	completed	\N	2026-02-17 05:04:13	2026-02-17 05:04:13	2026-02-17 05:04:13	\N	0	0	0.00	[{"method":"cash","amount":498390,"reference":null}]
fbf581b7-886b-4c62-b8a0-d226c2ce616e	1	8	INV-260217-0001	1250000.00	137500.00	0.00	1387500.00	1400000.00	12500.00	cash	completed	\N	2026-02-17 04:46:32	2026-02-17 04:46:32	2026-02-17 04:46:32	\N	0	0	0.00	[{"method":"cash","amount":1387500,"reference":null}]
96b2b416-9c8e-4e57-b30c-84e4a967c0f8	1	8	INV-260217-0005	158500.00	17435.00	0.00	175935.00	200000.00	24065.00	cash	completed	\N	2026-02-17 05:45:52	2026-02-17 05:45:52	2026-02-17 05:45:52	\N	0	0	0.00	[{"method":"cash","amount":175935,"reference":null}]
9867497a-8976-4bc9-a365-12bdc617275c	1	8	INV-260217-0006	35000.00	3850.00	0.00	38850.00	100000.00	61150.00	cash	completed	\N	2026-02-17 05:52:46	2026-02-17 05:52:46	2026-02-17 05:52:46	\N	0	0	0.00	[{"method":"cash","amount":38850,"reference":null}]
0051a42c-f274-4092-9a17-fdf8de9cb2e5	1	8	INV-260217-0007	198000.00	21780.00	0.00	219780.00	300000.00	80220.00	cash	completed	\N	2026-02-17 05:54:09	2026-02-17 05:54:09	2026-02-17 05:54:09	\N	0	0	0.00	[{"method":"cash","amount":219780,"reference":null}]
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.users (id, name, email, email_verified_at, password, remember_token, created_at, updated_at, store_id, role, deleted_at) FROM stdin;
1	Admin	admin@kelontong.com	\N	$2y$12$7aUqq9PZ9NMcXm2RcAhXg.orBMoc0qiZZse19jQMgtjjv.3EXCRlK	\N	2026-02-16 19:43:29	2026-02-16 19:43:29	2	owner	\N
2	Siti Kasir	siti@example.com	\N	$2y$12$tUWjCLzbVYOuoEzGJW8CAuzs76Ybc06X5YTK79jXzOWZV7EzBOqDW	\N	2026-02-16 19:52:42	2026-02-16 19:52:42	1	cashier	\N
3	H. Maimun	owner@kelontong.com	\N	$2y$12$Fn7ndq4zssCWd1RMPE65.exYWKlRib0y5a1vXSvuCiRVUnfOWBeqe	\N	2026-02-16 20:41:06	2026-02-16 20:41:06	3	owner	\N
4	Owner Admin	owner@pos.com	\N	$2y$12$qG2P9h08UfLkJuL0hikN.Oi2Ek2oBhDnPiMi/GpBs5JmVMsdlxyuW	\N	2026-02-17 01:41:51	2026-02-17 01:41:51	\N	owner	\N
5	Store Manager	manager@pos.com	\N	$2y$12$gyeDQra4Fs4.1BcWq2/n1OHRknkHZRHFDfA9OjLncvGx.7uT7a3WO	\N	2026-02-17 01:41:52	2026-02-17 01:41:52	\N	manager	\N
6	Cashier Staff	cashier@pos.com	\N	$2y$12$Xd7rt8p0/ZM69XjVd8S0k.mhbN9PMEtkQEssn9msBp6bLZIM2EnEq	\N	2026-02-17 01:41:52	2026-02-17 01:41:52	\N	cashier	\N
7	Owner User	owner@example.com	2026-02-17 02:16:44	$2y$12$QzwGq4K5wzqu2JhQRYCQien8PENiLLpZPjVga2DcsPyujlhN6dAXi	\N	2026-02-17 02:16:44	2026-02-17 02:16:44	1	owner	\N
8	Store Admin	admin@example.com	2026-02-17 02:16:44	$2y$12$hZImkT1YZxBRyAtwpP0FPu6AaB9q.ZCQMh9MVxOUjyjjLMgfbw3YC	\N	2026-02-17 02:16:44	2026-02-17 02:16:44	1	admin	\N
9	Cashier User	cashier@example.com	2026-02-17 02:16:44	$2y$12$Fa/fUtrn2mWIDl6wj/hrAO0kZFL8WJnS.TJrE5Q4XFe5DQ8.oF/iC	\N	2026-02-17 02:16:44	2026-02-17 02:16:44	1	cashier	\N
10	Warehouse User	warehouse@example.com	2026-02-17 02:16:45	$2y$12$RrxQIkRxPpp5cAPp7esTwOwowQa4fT9XTmxVH9iQtN46JbseNjqxW	\N	2026-02-17 02:16:45	2026-02-17 02:16:45	1	warehouse	\N
\.


--
-- Data for Name: whatsapp_logs; Type: TABLE DATA; Schema: public; Owner: bihadmin
--

COPY public.whatsapp_logs (id, customer_id, phone, message, type, status, sent_at, error_message, created_at, updated_at) FROM stdin;
\.


--
-- Name: accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.accounts_id_seq', 17, true);


--
-- Name: ai_insights_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.ai_insights_id_seq', 3, true);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 22, true);


--
-- Name: budgets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.budgets_id_seq', 1, false);


--
-- Name: business_health_scores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.business_health_scores_id_seq', 2, true);


--
-- Name: cash_drawers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.cash_drawers_id_seq', 4, true);


--
-- Name: cashflow_projections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.cashflow_projections_id_seq', 31, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.categories_id_seq', 8, true);


--
-- Name: competitor_prices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.competitor_prices_id_seq', 2, true);


--
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.customers_id_seq', 20, true);


--
-- Name: employee_risk_scores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.employee_risk_scores_id_seq', 1, true);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- Name: fraud_alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.fraud_alerts_id_seq', 1, true);


--
-- Name: installments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.installments_id_seq', 1, false);


--
-- Name: inventory_valuations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.inventory_valuations_id_seq', 1, false);


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.jobs_id_seq', 1, true);


--
-- Name: journal_entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.journal_entries_id_seq', 308, true);


--
-- Name: journal_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.journal_items_id_seq', 1939, true);


--
-- Name: loyalty_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.loyalty_logs_id_seq', 1, false);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.migrations_id_seq', 47, true);


--
-- Name: price_tiers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.price_tiers_id_seq', 1, false);


--
-- Name: product_batches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.product_batches_id_seq', 1, false);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.products_id_seq', 114, true);


--
-- Name: profit_risk_scores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.profit_risk_scores_id_seq', 1, true);


--
-- Name: promotions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.promotions_id_seq', 1, false);


--
-- Name: purchase_order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.purchase_order_items_id_seq', 1, false);


--
-- Name: purchase_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.purchase_orders_id_seq', 1, false);


--
-- Name: return_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.return_items_id_seq', 1, false);


--
-- Name: stock_movements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.stock_movements_id_seq', 15, true);


--
-- Name: stock_opname_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.stock_opname_items_id_seq', 1, false);


--
-- Name: stock_opnames_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.stock_opnames_id_seq', 1, false);


--
-- Name: stock_transfer_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.stock_transfer_items_id_seq', 1, false);


--
-- Name: stock_transfers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.stock_transfers_id_seq', 1, false);


--
-- Name: store_wallets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.store_wallets_id_seq', 1, false);


--
-- Name: stores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.stores_id_seq', 3, true);


--
-- Name: suppliers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.suppliers_id_seq', 2, true);


--
-- Name: system_alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.system_alerts_id_seq', 4, true);


--
-- Name: transaction_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.transaction_items_id_seq', 1089, true);


--
-- Name: transaction_payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.transaction_payments_id_seq', 445, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.users_id_seq', 10, true);


--
-- Name: whatsapp_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bihadmin
--

SELECT pg_catalog.setval('public.whatsapp_logs_id_seq', 1, false);


--
-- Name: accounts accounts_code_unique; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_code_unique UNIQUE (code);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: ai_insights ai_insights_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.ai_insights
    ADD CONSTRAINT ai_insights_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: budgets budgets_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_pkey PRIMARY KEY (id);


--
-- Name: business_health_scores business_health_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.business_health_scores
    ADD CONSTRAINT business_health_scores_pkey PRIMARY KEY (id);


--
-- Name: cache_locks cache_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.cache_locks
    ADD CONSTRAINT cache_locks_pkey PRIMARY KEY (key);


--
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);


--
-- Name: cash_drawers cash_drawers_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.cash_drawers
    ADD CONSTRAINT cash_drawers_pkey PRIMARY KEY (id);


--
-- Name: cashflow_projections cashflow_projections_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.cashflow_projections
    ADD CONSTRAINT cashflow_projections_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: competitor_prices competitor_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.competitor_prices
    ADD CONSTRAINT competitor_prices_pkey PRIMARY KEY (id);


--
-- Name: customers customers_phone_unique; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_phone_unique UNIQUE (phone);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: employee_risk_scores employee_risk_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.employee_risk_scores
    ADD CONSTRAINT employee_risk_scores_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- Name: fraud_alerts fraud_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.fraud_alerts
    ADD CONSTRAINT fraud_alerts_pkey PRIMARY KEY (id);


--
-- Name: installments installments_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.installments
    ADD CONSTRAINT installments_pkey PRIMARY KEY (id);


--
-- Name: inventory_valuations inventory_valuations_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.inventory_valuations
    ADD CONSTRAINT inventory_valuations_pkey PRIMARY KEY (id);


--
-- Name: job_batches job_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.job_batches
    ADD CONSTRAINT job_batches_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: journal_entries journal_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.journal_entries
    ADD CONSTRAINT journal_entries_pkey PRIMARY KEY (id);


--
-- Name: journal_entries journal_entries_reference_number_unique; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.journal_entries
    ADD CONSTRAINT journal_entries_reference_number_unique UNIQUE (reference_number);


--
-- Name: journal_items journal_items_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.journal_items
    ADD CONSTRAINT journal_items_pkey PRIMARY KEY (id);


--
-- Name: loyalty_logs loyalty_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.loyalty_logs
    ADD CONSTRAINT loyalty_logs_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);


--
-- Name: price_tiers price_tiers_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.price_tiers
    ADD CONSTRAINT price_tiers_pkey PRIMARY KEY (id);


--
-- Name: product_batches product_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.product_batches
    ADD CONSTRAINT product_batches_pkey PRIMARY KEY (id);


--
-- Name: products products_barcode_unique; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_barcode_unique UNIQUE (barcode);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: profit_risk_scores profit_risk_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.profit_risk_scores
    ADD CONSTRAINT profit_risk_scores_pkey PRIMARY KEY (id);


--
-- Name: promotions promotions_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_pkey PRIMARY KEY (id);


--
-- Name: purchase_order_items purchase_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_pkey PRIMARY KEY (id);


--
-- Name: purchase_orders purchase_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_pkey PRIMARY KEY (id);


--
-- Name: purchase_orders purchase_orders_po_number_unique; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_po_number_unique UNIQUE (po_number);


--
-- Name: return_items return_items_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.return_items
    ADD CONSTRAINT return_items_pkey PRIMARY KEY (id);


--
-- Name: return_transactions return_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.return_transactions
    ADD CONSTRAINT return_transactions_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: stock_movements stock_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_pkey PRIMARY KEY (id);


--
-- Name: stock_opname_items stock_opname_items_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_opname_items
    ADD CONSTRAINT stock_opname_items_pkey PRIMARY KEY (id);


--
-- Name: stock_opname_items stock_opname_items_stock_opname_id_product_id_unique; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_opname_items
    ADD CONSTRAINT stock_opname_items_stock_opname_id_product_id_unique UNIQUE (stock_opname_id, product_id);


--
-- Name: stock_opnames stock_opnames_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_opnames
    ADD CONSTRAINT stock_opnames_pkey PRIMARY KEY (id);


--
-- Name: stock_opnames stock_opnames_reference_number_unique; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_opnames
    ADD CONSTRAINT stock_opnames_reference_number_unique UNIQUE (reference_number);


--
-- Name: stock_transfer_items stock_transfer_items_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_transfer_items
    ADD CONSTRAINT stock_transfer_items_pkey PRIMARY KEY (id);


--
-- Name: stock_transfers stock_transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_transfers
    ADD CONSTRAINT stock_transfers_pkey PRIMARY KEY (id);


--
-- Name: stock_transfers stock_transfers_transfer_number_unique; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_transfers
    ADD CONSTRAINT stock_transfers_transfer_number_unique UNIQUE (transfer_number);


--
-- Name: store_wallets store_wallets_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.store_wallets
    ADD CONSTRAINT store_wallets_pkey PRIMARY KEY (id);


--
-- Name: store_wallets store_wallets_store_id_provider_unique; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.store_wallets
    ADD CONSTRAINT store_wallets_store_id_provider_unique UNIQUE (store_id, provider);


--
-- Name: stores stores_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_pkey PRIMARY KEY (id);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: system_alerts system_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.system_alerts
    ADD CONSTRAINT system_alerts_pkey PRIMARY KEY (id);


--
-- Name: transaction_items transaction_items_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.transaction_items
    ADD CONSTRAINT transaction_items_pkey PRIMARY KEY (id);


--
-- Name: transaction_payments transaction_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.transaction_payments
    ADD CONSTRAINT transaction_payments_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_store_id_invoice_number_unique; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_store_id_invoice_number_unique UNIQUE (store_id, invoice_number);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: whatsapp_logs whatsapp_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.whatsapp_logs
    ADD CONSTRAINT whatsapp_logs_pkey PRIMARY KEY (id);


--
-- Name: ai_insights_store_id_status_type_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX ai_insights_store_id_status_type_index ON public.ai_insights USING btree (store_id, status, type);


--
-- Name: audit_logs_created_at_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX audit_logs_created_at_index ON public.audit_logs USING btree (created_at);


--
-- Name: audit_logs_target_type_target_id_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX audit_logs_target_type_target_id_index ON public.audit_logs USING btree (target_type, target_id);


--
-- Name: budgets_store_id_start_date_end_date_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX budgets_store_id_start_date_end_date_index ON public.budgets USING btree (store_id, start_date, end_date);


--
-- Name: business_health_scores_store_id_calculated_at_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX business_health_scores_store_id_calculated_at_index ON public.business_health_scores USING btree (store_id, calculated_at);


--
-- Name: cache_expiration_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX cache_expiration_index ON public.cache USING btree (expiration);


--
-- Name: cache_locks_expiration_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX cache_locks_expiration_index ON public.cache_locks USING btree (expiration);


--
-- Name: cash_drawers_store_id_user_id_closed_at_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX cash_drawers_store_id_user_id_closed_at_index ON public.cash_drawers USING btree (store_id, user_id, closed_at);


--
-- Name: cashflow_projections_store_id_projection_date_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX cashflow_projections_store_id_projection_date_index ON public.cashflow_projections USING btree (store_id, projection_date);


--
-- Name: competitor_prices_product_id_checked_at_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX competitor_prices_product_id_checked_at_index ON public.competitor_prices USING btree (product_id, checked_at);


--
-- Name: customers_phone_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX customers_phone_index ON public.customers USING btree (phone);


--
-- Name: employee_risk_scores_store_id_user_id_calculated_at_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX employee_risk_scores_store_id_user_id_calculated_at_index ON public.employee_risk_scores USING btree (store_id, user_id, calculated_at);


--
-- Name: fraud_alerts_reference_id_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX fraud_alerts_reference_id_index ON public.fraud_alerts USING btree (reference_id);


--
-- Name: installments_due_date_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX installments_due_date_index ON public.installments USING btree (due_date);


--
-- Name: installments_status_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX installments_status_index ON public.installments USING btree (status);


--
-- Name: inventory_valuations_store_id_valuation_date_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX inventory_valuations_store_id_valuation_date_index ON public.inventory_valuations USING btree (store_id, valuation_date);


--
-- Name: jobs_queue_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX jobs_queue_index ON public.jobs USING btree (queue);


--
-- Name: journal_entries_reference_type_reference_id_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX journal_entries_reference_type_reference_id_index ON public.journal_entries USING btree (reference_type, reference_id);


--
-- Name: journal_items_account_code_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX journal_items_account_code_index ON public.journal_items USING btree (account_code);


--
-- Name: loyalty_logs_customer_id_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX loyalty_logs_customer_id_index ON public.loyalty_logs USING btree (customer_id);


--
-- Name: price_tiers_product_id_store_id_tier_name_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX price_tiers_product_id_store_id_tier_name_index ON public.price_tiers USING btree (product_id, store_id, tier_name);


--
-- Name: product_batches_batch_number_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX product_batches_batch_number_index ON public.product_batches USING btree (batch_number);


--
-- Name: product_batches_store_id_product_id_expiry_date_received_at_ind; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX product_batches_store_id_product_id_expiry_date_received_at_ind ON public.product_batches USING btree (store_id, product_id, expiry_date, received_at);


--
-- Name: products_barcode_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX products_barcode_index ON public.products USING btree (barcode);


--
-- Name: products_name_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX products_name_index ON public.products USING btree (name);


--
-- Name: profit_risk_scores_store_id_calculated_at_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX profit_risk_scores_store_id_calculated_at_index ON public.profit_risk_scores USING btree (store_id, calculated_at);


--
-- Name: profit_risk_scores_user_id_calculated_at_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX profit_risk_scores_user_id_calculated_at_index ON public.profit_risk_scores USING btree (user_id, calculated_at);


--
-- Name: sessions_last_activity_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX sessions_last_activity_index ON public.sessions USING btree (last_activity);


--
-- Name: sessions_user_id_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX sessions_user_id_index ON public.sessions USING btree (user_id);


--
-- Name: stock_movements_reference_type_reference_id_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX stock_movements_reference_type_reference_id_index ON public.stock_movements USING btree (reference_type, reference_id);


--
-- Name: stock_movements_store_id_product_id_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX stock_movements_store_id_product_id_index ON public.stock_movements USING btree (store_id, product_id);


--
-- Name: stock_transfers_dest_store_id_status_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX stock_transfers_dest_store_id_status_index ON public.stock_transfers USING btree (dest_store_id, status);


--
-- Name: stock_transfers_source_store_id_status_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX stock_transfers_source_store_id_status_index ON public.stock_transfers USING btree (source_store_id, status);


--
-- Name: system_alerts_store_id_type_created_at_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX system_alerts_store_id_type_created_at_index ON public.system_alerts USING btree (store_id, type, created_at);


--
-- Name: transaction_payments_method_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX transaction_payments_method_index ON public.transaction_payments USING btree (method);


--
-- Name: transaction_payments_reference_number_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX transaction_payments_reference_number_index ON public.transaction_payments USING btree (reference_number);


--
-- Name: transactions_transaction_date_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX transactions_transaction_date_index ON public.transactions USING btree (transaction_date);


--
-- Name: whatsapp_logs_status_created_at_index; Type: INDEX; Schema: public; Owner: bihadmin
--

CREATE INDEX whatsapp_logs_status_created_at_index ON public.whatsapp_logs USING btree (status, created_at);


--
-- Name: ai_insights ai_insights_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.ai_insights
    ADD CONSTRAINT ai_insights_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: audit_logs audit_logs_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: budgets budgets_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: business_health_scores business_health_scores_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.business_health_scores
    ADD CONSTRAINT business_health_scores_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: cash_drawers cash_drawers_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.cash_drawers
    ADD CONSTRAINT cash_drawers_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: cash_drawers cash_drawers_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.cash_drawers
    ADD CONSTRAINT cash_drawers_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: cashflow_projections cashflow_projections_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.cashflow_projections
    ADD CONSTRAINT cashflow_projections_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: competitor_prices competitor_prices_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.competitor_prices
    ADD CONSTRAINT competitor_prices_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: customers customers_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE SET NULL;


--
-- Name: employee_risk_scores employee_risk_scores_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.employee_risk_scores
    ADD CONSTRAINT employee_risk_scores_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: employee_risk_scores employee_risk_scores_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.employee_risk_scores
    ADD CONSTRAINT employee_risk_scores_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: fraud_alerts fraud_alerts_resolved_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.fraud_alerts
    ADD CONSTRAINT fraud_alerts_resolved_by_foreign FOREIGN KEY (resolved_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: fraud_alerts fraud_alerts_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.fraud_alerts
    ADD CONSTRAINT fraud_alerts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: installments installments_transaction_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.installments
    ADD CONSTRAINT installments_transaction_id_foreign FOREIGN KEY (transaction_id) REFERENCES public.transactions(id) ON DELETE CASCADE;


--
-- Name: inventory_valuations inventory_valuations_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.inventory_valuations
    ADD CONSTRAINT inventory_valuations_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: journal_entries journal_entries_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.journal_entries
    ADD CONSTRAINT journal_entries_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: journal_entries journal_entries_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.journal_entries
    ADD CONSTRAINT journal_entries_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: journal_items journal_items_journal_entry_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.journal_items
    ADD CONSTRAINT journal_items_journal_entry_id_foreign FOREIGN KEY (journal_entry_id) REFERENCES public.journal_entries(id) ON DELETE CASCADE;


--
-- Name: loyalty_logs loyalty_logs_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.loyalty_logs
    ADD CONSTRAINT loyalty_logs_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE;


--
-- Name: loyalty_logs loyalty_logs_transaction_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.loyalty_logs
    ADD CONSTRAINT loyalty_logs_transaction_id_foreign FOREIGN KEY (transaction_id) REFERENCES public.transactions(id) ON DELETE SET NULL;


--
-- Name: price_tiers price_tiers_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.price_tiers
    ADD CONSTRAINT price_tiers_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: price_tiers price_tiers_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.price_tiers
    ADD CONSTRAINT price_tiers_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: product_batches product_batches_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.product_batches
    ADD CONSTRAINT product_batches_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: product_batches product_batches_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.product_batches
    ADD CONSTRAINT product_batches_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: products products_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_foreign FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: products products_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: products products_supplier_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_supplier_id_foreign FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id) ON DELETE SET NULL;


--
-- Name: profit_risk_scores profit_risk_scores_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.profit_risk_scores
    ADD CONSTRAINT profit_risk_scores_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: profit_risk_scores profit_risk_scores_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.profit_risk_scores
    ADD CONSTRAINT profit_risk_scores_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: promotions promotions_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_category_id_foreign FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE SET NULL;


--
-- Name: promotions promotions_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE SET NULL;


--
-- Name: promotions promotions_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: purchase_order_items purchase_order_items_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: purchase_order_items purchase_order_items_purchase_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_purchase_order_id_foreign FOREIGN KEY (purchase_order_id) REFERENCES public.purchase_orders(id) ON DELETE CASCADE;


--
-- Name: purchase_orders purchase_orders_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: purchase_orders purchase_orders_supplier_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_supplier_id_foreign FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id) ON DELETE CASCADE;


--
-- Name: purchase_orders purchase_orders_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: return_items return_items_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.return_items
    ADD CONSTRAINT return_items_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: return_items return_items_return_transaction_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.return_items
    ADD CONSTRAINT return_items_return_transaction_id_foreign FOREIGN KEY (return_transaction_id) REFERENCES public.return_transactions(id) ON DELETE CASCADE;


--
-- Name: return_transactions return_transactions_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.return_transactions
    ADD CONSTRAINT return_transactions_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: return_transactions return_transactions_transaction_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.return_transactions
    ADD CONSTRAINT return_transactions_transaction_id_foreign FOREIGN KEY (transaction_id) REFERENCES public.transactions(id) ON DELETE CASCADE;


--
-- Name: return_transactions return_transactions_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.return_transactions
    ADD CONSTRAINT return_transactions_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: stock_movements stock_movements_batch_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_batch_id_foreign FOREIGN KEY (batch_id) REFERENCES public.product_batches(id) ON DELETE SET NULL;


--
-- Name: stock_movements stock_movements_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: stock_movements stock_movements_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: stock_movements stock_movements_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: stock_opname_items stock_opname_items_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_opname_items
    ADD CONSTRAINT stock_opname_items_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: stock_opname_items stock_opname_items_stock_opname_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_opname_items
    ADD CONSTRAINT stock_opname_items_stock_opname_id_foreign FOREIGN KEY (stock_opname_id) REFERENCES public.stock_opnames(id) ON DELETE CASCADE;


--
-- Name: stock_opnames stock_opnames_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_opnames
    ADD CONSTRAINT stock_opnames_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: stock_opnames stock_opnames_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_opnames
    ADD CONSTRAINT stock_opnames_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: stock_transfer_items stock_transfer_items_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_transfer_items
    ADD CONSTRAINT stock_transfer_items_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: stock_transfer_items stock_transfer_items_stock_transfer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_transfer_items
    ADD CONSTRAINT stock_transfer_items_stock_transfer_id_foreign FOREIGN KEY (stock_transfer_id) REFERENCES public.stock_transfers(id) ON DELETE CASCADE;


--
-- Name: stock_transfers stock_transfers_created_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_transfers
    ADD CONSTRAINT stock_transfers_created_by_foreign FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: stock_transfers stock_transfers_dest_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_transfers
    ADD CONSTRAINT stock_transfers_dest_store_id_foreign FOREIGN KEY (dest_store_id) REFERENCES public.stores(id);


--
-- Name: stock_transfers stock_transfers_received_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_transfers
    ADD CONSTRAINT stock_transfers_received_by_foreign FOREIGN KEY (received_by) REFERENCES public.users(id);


--
-- Name: stock_transfers stock_transfers_source_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.stock_transfers
    ADD CONSTRAINT stock_transfers_source_store_id_foreign FOREIGN KEY (source_store_id) REFERENCES public.stores(id);


--
-- Name: store_wallets store_wallets_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.store_wallets
    ADD CONSTRAINT store_wallets_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: system_alerts system_alerts_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.system_alerts
    ADD CONSTRAINT system_alerts_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: transaction_items transaction_items_batch_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.transaction_items
    ADD CONSTRAINT transaction_items_batch_id_foreign FOREIGN KEY (batch_id) REFERENCES public.product_batches(id) ON DELETE SET NULL;


--
-- Name: transaction_items transaction_items_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.transaction_items
    ADD CONSTRAINT transaction_items_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: transaction_items transaction_items_transaction_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.transaction_items
    ADD CONSTRAINT transaction_items_transaction_id_foreign FOREIGN KEY (transaction_id) REFERENCES public.transactions(id) ON DELETE CASCADE;


--
-- Name: transaction_payments transaction_payments_transaction_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.transaction_payments
    ADD CONSTRAINT transaction_payments_transaction_id_foreign FOREIGN KEY (transaction_id) REFERENCES public.transactions(id) ON DELETE CASCADE;


--
-- Name: transactions transactions_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;


--
-- Name: transactions transactions_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: transactions transactions_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: users users_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: whatsapp_logs whatsapp_logs_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: bihadmin
--

ALTER TABLE ONLY public.whatsapp_logs
    ADD CONSTRAINT whatsapp_logs_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict 8fFDnUCw8UFg93rvKE8ASGKaZrnyil3f2LUgUDsTIMp9LZY6Zkp65rzrFLo7mcq

