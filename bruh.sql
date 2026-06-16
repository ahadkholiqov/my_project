--
-- PostgreSQL database dump
--

\restrict beJG0bXAMf5Szgf5PpCZI1LNFhQQlVtq3dKkt1AUEv1nCCpDYuolNoWRfV9Jlpo

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-05-25 08:30:25

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 890 (class 1247 OID 33106)
-- Name: idea_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.idea_status AS ENUM (
    'new',
    'reviewed',
    'accepted',
    'rejected'
);


ALTER TYPE public.idea_status OWNER TO postgres;

--
-- TOC entry 887 (class 1247 OID 33098)
-- Name: submission_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.submission_status AS ENUM (
    'pending',
    'approved',
    'rejected'
);


ALTER TYPE public.submission_status OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 246 (class 1259 OID 33435)
-- Name: action_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.action_logs (
    id integer NOT NULL,
    user_id integer,
    action character varying(255) NOT NULL,
    details text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.action_logs OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 33434)
-- Name: action_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.action_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.action_logs_id_seq OWNER TO postgres;

--
-- TOC entry 5263 (class 0 OID 0)
-- Dependencies: 245
-- Name: action_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.action_logs_id_seq OWNED BY public.action_logs.id;


--
-- TOC entry 232 (class 1259 OID 33220)
-- Name: announcements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.announcements (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    body text NOT NULL,
    author_id integer,
    target_role integer,
    pinned boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    approved boolean DEFAULT false,
    approved_by integer,
    status character varying(50) DEFAULT 'pending'::character varying,
    reject_reason text
);


ALTER TABLE public.announcements OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 33219)
-- Name: announcements_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.announcements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.announcements_id_seq OWNER TO postgres;

--
-- TOC entry 5264 (class 0 OID 0)
-- Dependencies: 231
-- Name: announcements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.announcements_id_seq OWNED BY public.announcements.id;


--
-- TOC entry 254 (class 1259 OID 33510)
-- Name: file_exchange_files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.file_exchange_files (
    id integer NOT NULL,
    semester_id integer,
    group_name character varying(100) NOT NULL,
    cycle_number integer NOT NULL,
    subject_name character varying(255) NOT NULL,
    teacher_name character varying(255) NOT NULL,
    file_name character varying(255),
    file_path character varying(500),
    file_size bigint,
    tag character varying(100),
    is_library_ref boolean DEFAULT false,
    library_book_id integer,
    uploaded_by integer,
    created_at timestamp without time zone DEFAULT now(),
    message_text text
);


ALTER TABLE public.file_exchange_files OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 33509)
-- Name: file_exchange_files_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.file_exchange_files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.file_exchange_files_id_seq OWNER TO postgres;

--
-- TOC entry 5265 (class 0 OID 0)
-- Dependencies: 253
-- Name: file_exchange_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.file_exchange_files_id_seq OWNED BY public.file_exchange_files.id;


--
-- TOC entry 240 (class 1259 OID 33314)
-- Name: file_submissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.file_submissions (
    id integer NOT NULL,
    group_id integer,
    uploaded_by integer,
    teacher_id integer,
    title character varying(255) NOT NULL,
    description text,
    file_path character varying(500) NOT NULL,
    file_size bigint,
    status public.submission_status DEFAULT 'pending'::public.submission_status,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    cycle character varying(100) NOT NULL
);


ALTER TABLE public.file_submissions OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 33313)
-- Name: file_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.file_submissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.file_submissions_id_seq OWNER TO postgres;

--
-- TOC entry 5266 (class 0 OID 0)
-- Dependencies: 239
-- Name: file_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.file_submissions_id_seq OWNED BY public.file_submissions.id;


--
-- TOC entry 222 (class 1259 OID 33127)
-- Name: groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groups (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    year integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.groups OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 33126)
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.groups_id_seq OWNER TO postgres;

--
-- TOC entry 5267 (class 0 OID 0)
-- Dependencies: 221
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- TOC entry 234 (class 1259 OID 33244)
-- Name: ideas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ideas (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    body text NOT NULL,
    author_id integer,
    moder_id integer,
    status character varying(50) DEFAULT 'new'::public.idea_status,
    votes integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    approved boolean DEFAULT false,
    moderator_comment text,
    approved_by integer
);


ALTER TABLE public.ideas OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 33243)
-- Name: ideas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ideas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ideas_id_seq OWNER TO postgres;

--
-- TOC entry 5268 (class 0 OID 0)
-- Dependencies: 233
-- Name: ideas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ideas_id_seq OWNED BY public.ideas.id;


--
-- TOC entry 236 (class 1259 OID 33270)
-- Name: ideas_likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ideas_likes (
    id integer NOT NULL,
    user_id integer NOT NULL,
    ideas_id integer NOT NULL,
    status boolean DEFAULT true
);


ALTER TABLE public.ideas_likes OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 33269)
-- Name: ideas_likes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ideas_likes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ideas_likes_id_seq OWNER TO postgres;

--
-- TOC entry 5269 (class 0 OID 0)
-- Dependencies: 235
-- Name: ideas_likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ideas_likes_id_seq OWNED BY public.ideas_likes.id;


--
-- TOC entry 238 (class 1259 OID 33293)
-- Name: library_books; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.library_books (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    subject character varying(100),
    file_path character varying(500) NOT NULL,
    file_size bigint,
    uploaded_by integer,
    approved boolean DEFAULT false,
    category character varying(100),
    downloads integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    description text,
    document_type character varying(100),
    publisher character varying(255),
    approved_by integer,
    status character varying(50) DEFAULT 'pending'::character varying,
    reject_reason text
);


ALTER TABLE public.library_books OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 33292)
-- Name: library_books_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.library_books_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.library_books_id_seq OWNER TO postgres;

--
-- TOC entry 5270 (class 0 OID 0)
-- Dependencies: 237
-- Name: library_books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.library_books_id_seq OWNED BY public.library_books.id;


--
-- TOC entry 244 (class 1259 OID 33412)
-- Name: library_favorites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.library_favorites (
    id integer NOT NULL,
    user_id integer NOT NULL,
    book_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.library_favorites OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 33411)
-- Name: library_favorites_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.library_favorites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.library_favorites_id_seq OWNER TO postgres;

--
-- TOC entry 5271 (class 0 OID 0)
-- Dependencies: 243
-- Name: library_favorites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.library_favorites_id_seq OWNED BY public.library_favorites.id;


--
-- TOC entry 230 (class 1259 OID 33202)
-- Name: moderators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.moderators (
    id integer NOT NULL,
    user_id integer NOT NULL,
    assigned_at date NOT NULL,
    is_active boolean DEFAULT true
);


ALTER TABLE public.moderators OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 33201)
-- Name: moderators_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.moderators_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.moderators_id_seq OWNER TO postgres;

--
-- TOC entry 5272 (class 0 OID 0)
-- Dependencies: 229
-- Name: moderators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.moderators_id_seq OWNED BY public.moderators.id;


--
-- TOC entry 220 (class 1259 OID 33116)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 33115)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- TOC entry 5273 (class 0 OID 0)
-- Dependencies: 219
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 242 (class 1259 OID 33344)
-- Name: semester; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.semester (
    id integer NOT NULL,
    name integer NOT NULL,
    academic_year integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL
);


ALTER TABLE public.semester OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 33466)
-- Name: semester_days; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.semester_days (
    id integer NOT NULL,
    semester_id integer,
    date date NOT NULL,
    day_type character varying(20) NOT NULL,
    cycle_number integer,
    is_holiday boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.semester_days OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 33465)
-- Name: semester_days_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.semester_days_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.semester_days_id_seq OWNER TO postgres;

--
-- TOC entry 5274 (class 0 OID 0)
-- Dependencies: 249
-- Name: semester_days_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.semester_days_id_seq OWNED BY public.semester_days.id;


--
-- TOC entry 241 (class 1259 OID 33343)
-- Name: semester_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.semester_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.semester_id_seq OWNER TO postgres;

--
-- TOC entry 5275 (class 0 OID 0)
-- Dependencies: 241
-- Name: semester_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.semester_id_seq OWNED BY public.semester.id;


--
-- TOC entry 248 (class 1259 OID 33454)
-- Name: semesters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.semesters (
    id integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    is_active boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.semesters OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 33453)
-- Name: semesters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.semesters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.semesters_id_seq OWNER TO postgres;

--
-- TOC entry 5276 (class 0 OID 0)
-- Dependencies: 247
-- Name: semesters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.semesters_id_seq OWNED BY public.semesters.id;


--
-- TOC entry 226 (class 1259 OID 33169)
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.students OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 33168)
-- Name: students_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.students_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.students_id_seq OWNER TO postgres;

--
-- TOC entry 5277 (class 0 OID 0)
-- Dependencies: 225
-- Name: students_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.students_id_seq OWNED BY public.students.id;


--
-- TOC entry 228 (class 1259 OID 33185)
-- Name: teachers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teachers (
    id integer NOT NULL,
    user_id integer NOT NULL,
    status character varying(100) NOT NULL
);


ALTER TABLE public.teachers OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 33184)
-- Name: teachers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teachers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.teachers_id_seq OWNER TO postgres;

--
-- TOC entry 5278 (class 0 OID 0)
-- Dependencies: 227
-- Name: teachers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teachers_id_seq OWNED BY public.teachers.id;


--
-- TOC entry 252 (class 1259 OID 33485)
-- Name: timetables; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.timetables (
    id integer NOT NULL,
    semester_id integer,
    subject_name character varying(255) NOT NULL,
    start_time time without time zone NOT NULL,
    group_name character varying(100) NOT NULL,
    teacher_name character varying(255) NOT NULL,
    building character varying(100) DEFAULT ''::character varying NOT NULL,
    room_number character varying(50) DEFAULT ''::character varying NOT NULL,
    shift character varying(5) DEFAULT ''::character varying NOT NULL,
    cycle_number integer DEFAULT 1 NOT NULL,
    day_slots text DEFAULT ''::text
);


ALTER TABLE public.timetables OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 33484)
-- Name: timetables_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.timetables_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.timetables_id_seq OWNER TO postgres;

--
-- TOC entry 5279 (class 0 OID 0)
-- Dependencies: 251
-- Name: timetables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.timetables_id_seq OWNED BY public.timetables.id;


--
-- TOC entry 224 (class 1259 OID 33138)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255),
    password character varying(255) NOT NULL,
    name character varying(100) NOT NULL,
    surname character varying(100) NOT NULL,
    middlename character varying(100),
    role_id integer NOT NULL,
    group_id integer,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    login character varying(50) NOT NULL,
    phone character varying(20)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 33137)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 5280 (class 0 OID 0)
-- Dependencies: 223
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4980 (class 2604 OID 33438)
-- Name: action_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action_logs ALTER COLUMN id SET DEFAULT nextval('public.action_logs_id_seq'::regclass);


--
-- TOC entry 4957 (class 2604 OID 33223)
-- Name: announcements id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements ALTER COLUMN id SET DEFAULT nextval('public.announcements_id_seq'::regclass);


--
-- TOC entry 4994 (class 2604 OID 33513)
-- Name: file_exchange_files id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_exchange_files ALTER COLUMN id SET DEFAULT nextval('public.file_exchange_files_id_seq'::regclass);


--
-- TOC entry 4974 (class 2604 OID 33317)
-- Name: file_submissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_submissions ALTER COLUMN id SET DEFAULT nextval('public.file_submissions_id_seq'::regclass);


--
-- TOC entry 4948 (class 2604 OID 33130)
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- TOC entry 4962 (class 2604 OID 33247)
-- Name: ideas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ideas ALTER COLUMN id SET DEFAULT nextval('public.ideas_id_seq'::regclass);


--
-- TOC entry 4967 (class 2604 OID 33273)
-- Name: ideas_likes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ideas_likes ALTER COLUMN id SET DEFAULT nextval('public.ideas_likes_id_seq'::regclass);


--
-- TOC entry 4969 (class 2604 OID 33296)
-- Name: library_books id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.library_books ALTER COLUMN id SET DEFAULT nextval('public.library_books_id_seq'::regclass);


--
-- TOC entry 4978 (class 2604 OID 33415)
-- Name: library_favorites id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.library_favorites ALTER COLUMN id SET DEFAULT nextval('public.library_favorites_id_seq'::regclass);


--
-- TOC entry 4955 (class 2604 OID 33205)
-- Name: moderators id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moderators ALTER COLUMN id SET DEFAULT nextval('public.moderators_id_seq'::regclass);


--
-- TOC entry 4947 (class 2604 OID 33119)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 4977 (class 2604 OID 33347)
-- Name: semester id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semester ALTER COLUMN id SET DEFAULT nextval('public.semester_id_seq'::regclass);


--
-- TOC entry 4985 (class 2604 OID 33469)
-- Name: semester_days id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semester_days ALTER COLUMN id SET DEFAULT nextval('public.semester_days_id_seq'::regclass);


--
-- TOC entry 4982 (class 2604 OID 33457)
-- Name: semesters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semesters ALTER COLUMN id SET DEFAULT nextval('public.semesters_id_seq'::regclass);


--
-- TOC entry 4953 (class 2604 OID 33172)
-- Name: students id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students ALTER COLUMN id SET DEFAULT nextval('public.students_id_seq'::regclass);


--
-- TOC entry 4954 (class 2604 OID 33188)
-- Name: teachers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers ALTER COLUMN id SET DEFAULT nextval('public.teachers_id_seq'::regclass);


--
-- TOC entry 4988 (class 2604 OID 33488)
-- Name: timetables id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timetables ALTER COLUMN id SET DEFAULT nextval('public.timetables_id_seq'::regclass);


--
-- TOC entry 4950 (class 2604 OID 33141)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 5249 (class 0 OID 33435)
-- Dependencies: 246
-- Data for Name: action_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.action_logs (id, user_id, action, details, created_at) FROM stdin;
1	4	Добавление пользователя	Добавлен 'manager' с ролью 'student'	2026-05-06 10:47:14.833036
2	4	Деактивация пользователя	Деактивирован 'manager'	2026-05-06 10:48:05.124187
3	4	Редактирование пользователя	Изменён пользователь ID=5 (t_karimov), роль=teacher	2026-05-07 08:53:23.908432
4	4	Генерация семестра	Семестр 26.01.2026 — 11.06.2026, 137 дней	2026-05-08 10:03:32.615875
5	4	Генерация семестра	Семестр 26.01.2026 — 11.06.2026, 137 дней	2026-05-08 10:08:42.970444
6	4	Редактирование дня семестра	День 27.05.2026 изменён на В, цикл 4	2026-05-08 10:11:56.495492
7	4	Редактирование дня семестра	День 11.06.2026 изменён на ИН, цикл 1	2026-05-08 10:12:24.930622
8	4	Редактирование дня семестра	День 11.06.2026 изменён на ИН, цикл 2	2026-05-08 10:12:32.348698
9	4	Редактирование дня семестра	День 11.06.2026 изменён на ИН, цикл 5	2026-05-08 10:12:49.724799
10	4	Генерация семестра	Семестр 10.09.2025 — 10.01.2026, 123 дней	2026-05-08 10:29:39.21061
11	4	Генерация семестра	Семестр 01.09.2025 — 10.01.2026, 132 дней	2026-05-08 10:30:36.806247
12	4	Генерация семестра	Семестр 26.01.2026 — 12.06.2026, 138 дней	2026-05-08 11:21:57.695817
13	4	Редактирование дня семестра	День 24.02.2026 — ИН, цикл 1	2026-05-08 11:22:17.445799
14	4	Редактирование дня семестра	День 25.02.2026 — , цикл 	2026-05-08 11:22:31.305375
15	4	Редактирование дня семестра	День 12.06.2026 — , цикл 	2026-05-08 11:23:01.735901
16	4	Редактирование дня семестра	День 12.06.2026 — , цикл 	2026-05-08 11:23:19.898322
17	4	Редактирование дня семестра	День 02.04.2026 — ИН, цикл 2	2026-05-08 11:24:29.118891
18	4	Редактирование дня семестра	День 03.04.2026 — , цикл 	2026-05-08 11:25:03.237368
19	4	Редактирование дня семестра	День 02.04.2026 — ИН, цикл 5	2026-05-08 11:34:00.86831
20	4	Редактирование дня семестра	День 02.04.2026 — , цикл 	2026-05-08 11:34:14.157545
21	4	Редактирование дня семестра	День 24.02.2026 — КИН, цикл 1	2026-05-08 11:38:32.071657
22	4	Редактирование дня семестра	День 24.02.2026 — , цикл 	2026-05-08 11:38:46.245054
23	4	Редактирование дня семестра	День 02.04.2026 — ИН, цикл 2	2026-05-08 11:39:11.477796
24	4	Редактирование дня семестра	День 31.03.2026 — , цикл 	2026-05-08 11:39:27.820234
25	4	Редактирование дня семестра	День 31.03.2026 — КИН, цикл 2	2026-05-08 11:42:05.236779
26	4	Редактирование дня семестра	День 02.04.2026 — ИН, цикл 2	2026-05-08 17:40:49.62907
27	4	Редактирование дня семестра	День 03.04.2026 — , цикл 	2026-05-08 17:41:46.494137
28	4	Генерация семестра	Семестр 01.09.2025 — 10.01.2026, 132 дней	2026-05-09 08:38:09.745117
29	4	Генерация семестра	Семестр 01.09.2025 — 10.01.2026, 132 дней	2026-05-09 08:48:50.881979
30	4	Генерация семестра	Семестр 26.01.2026 — 11.06.2026, 137 дней	2026-05-09 08:51:06.069867
31	4	Деактивация пользователя	Деактивирован 's_aliev'	2026-05-09 11:00:01.8257
32	4	Загрузка расписания	Загружено 39 записей из файла Сикли 4.ФЭ.xlsx	2026-05-11 09:13:26.430944
33	4	Очистка расписания	Удалено 39 записей	2026-05-11 09:14:20.888401
34	4	Загрузка расписания	Загружено 39 записей из файла Сикли 4.ФЭ.xlsx	2026-05-11 09:24:06.513148
35	4	Редактирование расписания	Изменена строка ID=41: 1_25.01.07ра — Забони хориҷӣ аз рӯи ихтисос	2026-05-11 09:30:04.689193
36	4	Редактирование расписания	Изменена строка ID=41: 1_25.01.07ра — Забони хориҷӣ аз рӯи ихтисос	2026-05-11 09:30:11.712324
37	4	Редактирование пользователя	Изменён пользователь ID=3 (moder), роль=moderator	2026-05-11 09:43:19.971646
38	4	Деактивация пользователя	Деактивирован 's_hasanov'	2026-05-11 11:26:06.694574
39	4	Удаление пользователя	Удалён 'manager'	2026-05-11 11:27:22.625626
40	4	Активация пользователя	Активирован 's_aliev'	2026-05-11 11:27:53.230673
41	4	Активация пользователя	Активирован 's_hasanov'	2026-05-11 11:27:58.095418
42	4	Деактивация пользователя	Деактивирован 's_aliev'	2026-05-11 23:32:57.496713
43	4	Активация пользователя	Активирован 's_aliev'	2026-05-11 23:33:11.912401
44	4	Деактивация пользователя	Деактивирован 's_rajabov'	2026-05-12 07:51:07.484802
45	4	Добавление пользователя	Добавлен 't_samad' с ролью 'teacher'	2026-05-12 09:17:22.660781
46	4	Добавление группы	Создана группа '2_25.01.07та' (2025)	2026-05-12 09:18:10.591644
47	4	Редактирование группы	Изменена группа ID=4: '2_25.01.07та' (2)	2026-05-12 09:18:22.350801
48	4	Редактирование пользователя	Изменён пользователь ID=10 (s_aliev), роль=student	2026-05-12 09:18:36.679376
49	4	Редактирование пользователя	Изменён пользователь ID=11 (s_hasanov), роль=student	2026-05-12 09:18:41.736088
50	4	Редактирование пользователя	Изменён пользователь ID=12 (s_umarov), роль=student	2026-05-12 09:18:45.324013
51	4	Редактирование пользователя	Изменён пользователь ID=13 (s_ergashev), роль=student	2026-05-12 09:18:49.506682
52	4	Редактирование пользователя	Изменён пользователь ID=14 (s_sotvold), роль=student	2026-05-12 09:18:57.913258
53	4	Очистка расписания	Удалено 39 записей	2026-05-12 09:19:24.100284
54	4	Загрузка расписания	Загружено 39 записей из файла Сикли 4.ФЭ.xlsx	2026-05-12 09:19:41.899037
55	4	Редактирование пользователя	Изменён пользователь ID=21 (t_samad), роль=teacher	2026-05-12 09:21:45.224984
56	4	Редактирование пользователя	Изменён пользователь ID=10 (s_aliev), роль=student	2026-05-12 09:40:55.01318
57	4	Добавление группы	Создана группа '1_43.01.03тб' (1)	2026-05-14 09:09:43.334704
58	4	Редактирование пользователя	Изменён пользователь ID=18 (s_mirzaev), роль=student	2026-05-14 09:09:58.738613
59	4	Редактирование пользователя	Изменён пользователь ID=17 (s_ismoilov), роль=student	2026-05-14 09:10:03.950706
60	4	Редактирование пользователя	Изменён пользователь ID=16 (s_tursunov), роль=student	2026-05-14 09:10:10.659116
61	4	Редактирование пользователя	Изменён пользователь ID=15 (s_qodirov), роль=student	2026-05-14 09:10:16.436183
62	4	Добавление пользователя	Добавлен 't_salima' с ролью 'teacher'	2026-05-14 09:12:03.207843
63	4	Очистка расписания	Удалено 39 записей	2026-05-14 09:12:27.833881
64	4	Загрузка расписания	Загружено 39 записей из файла Сикли 4.ФЭ.xlsx	2026-05-14 09:12:46.557674
65	4	Добавление группы	Создана группа '1_25.01.07ра' (1)	2026-05-15 08:46:09.639863
66	4	Добавление пользователя	Добавлен 't_munira' с ролью 'teacher'	2026-05-15 08:46:58.207388
67	4	Добавление пользователя	Добавлен 's_a' с ролью 'student'	2026-05-15 08:49:38.71034
68	4	Добавление пользователя	Добавлен 's_b' с ролью 'student'	2026-05-15 08:49:55.077652
69	4	Редактирование пользователя	Изменён пользователь ID=24 (s_a), роль=student	2026-05-15 08:50:18.059023
70	4	Редактирование пользователя	Изменён пользователь ID=25 (s_b), роль=student	2026-05-15 08:50:22.394686
71	4	Очистка расписания	Удалено 39 записей	2026-05-15 08:50:27.84004
72	4	Загрузка расписания	Загружено 39 записей из файла Сикли 4.ФЭ.xlsx	2026-05-15 08:50:46.697045
73	4	Добавление пользователя	Добавлен 's_parvina' с ролью 'teacher'	2026-05-15 08:51:39.104978
74	4	Деактивация пользователя	Деактивирован 's_parvina'	2026-05-15 08:54:28.590077
75	4	Активация пользователя	Активирован 's_rajabov'	2026-05-15 08:54:35.411018
76	4	Редактирование пользователя	Изменён пользователь ID=26 (s_parvina), роль=teacher	2026-05-15 08:54:40.178017
77	4	Активация пользователя	Активирован 's_parvina'	2026-05-15 08:54:42.548063
78	4	Очистка расписания	Удалено 39 записей	2026-05-18 09:42:44.507461
79	4	Загрузка расписания	Загружено 39 записей из файла Сикли 4.ФЭ.xlsx	2026-05-18 09:42:58.250081
80	4	Очистка расписания	Удалено 39 записей	2026-05-18 09:44:31.946007
81	4	Загрузка расписания	Загружено 39 записей из файла Сикли 4.ФЭ.xlsx	2026-05-18 09:44:38.948542
82	4	Очистка расписания	Удалено 39 записей	2026-05-18 11:11:10.799525
83	4	Загрузка расписания	Загружено 39 записей из файла Сикли 4.ФЭ.xlsx	2026-05-18 11:29:01.523625
84	4	Загрузка расписания	Загружено 39 записей из файла Сикли 4.ФЭ.xlsx	2026-05-18 11:29:09.338314
85	4	Загрузка расписания	Загружено 39 записей из файла Сикли 4.ФЭ.xlsx	2026-05-18 11:29:18.255209
86	4	Загрузка расписания	Загружено 39 записей из файла Сикли 4.ФЭ.xlsx	2026-05-18 11:29:31.259363
87	4	Очистка расписания	Удалено 39 записей (Цикл 1)	2026-05-18 11:29:42.073554
88	4	Очистка расписания	Удалено 39 записей (Цикл 4)	2026-05-18 11:29:49.512349
89	4	Очистка расписания	Удалено 39 записей (Цикл 2)	2026-05-18 11:29:54.105661
90	4	Загрузка расписания	Загружено 39 записей из файла Сикли 4.ФЭ.xlsx	2026-05-18 11:42:02.786129
91	4	Загрузка расписания	Загружено 39 записей из файла Сикли 4.ФЭ.xlsx	2026-05-18 11:43:36.223661
92	4	Очистка расписания	Удалено 39 записей (Цикл 4)	2026-05-18 11:44:19.931712
93	4	Загрузка расписания	Загружено 39 записей из файла Сикли 4.ФЭ.xlsx	2026-05-18 11:44:26.729083
94	4	Загрузка расписания	Загружено 39 записей из файла Сикли 4.ФЭ.xlsx	2026-05-18 11:44:46.977722
95	4	Загрузка расписания	Загружено 48 записей из файла н2.с1.xlsx	2026-05-19 10:01:23.193387
96	4	Очистка расписания	Удалено 48 записей (Цикл 1)	2026-05-19 10:02:59.559146
97	4	Загрузка расписания	Загружено 48 записей из файла н2.с1 — копия.xlsx	2026-05-19 10:26:44.717018
98	4	Очистка расписания	Удалено 39 записей (Цикл 4)	2026-05-19 10:27:03.139826
99	4	Загрузка расписания	Загружено 49 записей из файла сикл 4.xlsx	2026-05-19 10:59:32.997296
100	4	Редактирование расписания	Изменена строка ID=682: 1_25.01.03ра — Забони русӣ аз рӯи ихтисос	2026-05-19 11:01:51.436015
101	4	Загрузка расписания	Загружено 54 записей из файла н2с2 — копия.xlsx	2026-05-20 08:08:53.192567
102	4	Загрузка расписания	Загружено 52 записей из файла н2с3 — копия.xlsx	2026-05-20 08:15:49.99663
103	4	Загрузка расписания	Загружено 45 записей из файла н2.с5 — копия.xlsx	2026-05-20 08:18:01.543944
104	4	Загрузка расписания	Загружено 48 записей из файла н2.с1 — копия.xlsx	2026-05-20 08:56:47.06018
105	4	Загрузка расписания	Загружено 54 записей из файла н2с2 — копия.xlsx	2026-05-20 08:57:04.278157
106	4	Загрузка расписания	Загружено 52 записей из файла н2с3 — копия.xlsx	2026-05-20 08:57:19.975523
107	4	Загрузка расписания	Загружено 45 записей из файла н2.с5 — копия.xlsx	2026-05-20 08:57:29.067869
108	4	Загрузка расписания	Загружено 45 записей из файла н2.с5.xlsx	2026-05-20 08:57:38.665412
109	4	Загрузка расписания	Загружено 49 записей из файла сикл 4.xlsx	2026-05-20 08:58:02.296441
110	4	Добавление группы	Создана группа '1_25.01.03ра' (1)	2026-05-20 10:47:23.158281
111	4	Редактирование пользователя	Изменён пользователь ID=1 (student), роль=student	2026-05-20 10:47:35.015411
112	4	Редактирование расписания	Изменена строка ID=1126: 1_25.01.03ра — Забони русӣ аз рӯи ихтисос	2026-05-21 16:03:20.797801
113	4	Редактирование расписания	Изменена строка ID=1127: 1_25.01.03ра — Забони хориҷӣ аз рӯи ихтисос	2026-05-21 16:03:35.610963
114	4	Редактирование пользователя	Изменён пользователь ID=26 (s_parvina), роль=teacher	2026-05-21 16:04:46.208925
115	4	Редактирование расписания	Изменена строка ID=1129: 1_25.01.04ра — Забони хориҷӣ аз рӯи ихтисос	2026-05-22 09:48:44.666519
\.


--
-- TOC entry 5235 (class 0 OID 33220)
-- Dependencies: 232
-- Data for Name: announcements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.announcements (id, title, body, author_id, target_role, pinned, created_at, approved, approved_by, status, reject_reason) FROM stdin;
11	Экзамены	Все получили автомат	3	\N	f	2026-05-04 13:38:54.805878	t	3	approved	\N
10	Каникулы	Каникулы начинаются с завтрашнего дня до конца года!	3	\N	f	2026-05-04 13:38:30.09504	t	3	approved	\N
\.


--
-- TOC entry 5257 (class 0 OID 33510)
-- Dependencies: 254
-- Data for Name: file_exchange_files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.file_exchange_files (id, semester_id, group_name, cycle_number, subject_name, teacher_name, file_name, file_path, file_size, tag, is_library_ref, library_book_id, uploaded_by, created_at, message_text) FROM stdin;
3	8	1_43.01.03тб	4	Нақшакашӣ ва графикаи муҳандисӣ бо AutoCAD	Саидова Салима Алиевна	ДООП_народные_росписи_ПУМ_ПУМ_хэлп_1.docx	uploads/fileexchange/620e93a8-e307-4b80-8b11-e3d9c23bea67_ДООП_народные_росписи_ПУМ_ПУМ_хэлп_1.docx	55255	Методичка	f	\N	22	2026-05-14 09:13:26.477074	\N
4	8	1_25.01.07ра	4	Забони хориҷӣ аз рӯи ихтисос	Исломова Парвина Наимовна	EduHub_Файлообменник_Логика.docx	uploads/fileexchange/3f2206cc-6dc5-4ef9-8586-bfccdb1f6466_EduHub_Файлообменник_Логика.docx	27969	book	f	\N	26	2026-05-15 08:52:31.87713	\N
5	8	1_25.01.07ра	4	Забони хориҷӣ аз рӯи ихтисос	Исломова Парвина Наимовна	Презентация - Портрет.pptx	uploads/fileexchange/bc47d3bd-4a34-44a2-804e-8e98d14c809c_Презентация - Портрет.pptx	4770002	lecture	f	\N	26	2026-05-15 08:52:49.598554	\N
6	8	1_25.01.07ра	4	Забони русӣ аз рӯи ихтисос	Машарипова Мунира Элеоноровна	Сикли 4.ФЭ.xlsx	uploads/fileexchange/89d03093-8f30-4abe-8f70-01d8b10960d7_Сикли 4.ФЭ.xlsx	25697	template	f	\N	23	2026-05-15 08:53:36.737445	\N
7	8	1_25.01.07ра	4	Забони русӣ аз рӯи ихтисос	Машарипова Мунира Элеоноровна	c33.pdf	uploads/fileexchange/a162312a-8d3b-4cec-80d9-e2981bef66ab_c33.pdf	607355	article	f	\N	23	2026-05-15 08:53:44.672065	\N
9	8	1_25.01.07ра	4	Забони русӣ аз рӯи ихтисос	Машарипова Мунира Элеоноровна	\N	\N	\N	\N	f	\N	23	2026-05-18 08:23:35.411712	Edu Hub vs Telegram round 1
14	8	1_25.01.07ра	5	Забони русӣ аз рӯи ихтисос	Машарипова Мунира Элеоноровна	\N	\N	\N	\N	f	\N	23	2026-05-18 09:38:09.482456	ывыа
17	8	1_25.01.07ра	4	Забони русӣ аз рӯи ихтисос	Машарипова Мунира Элеоноровна	Дискретная математика	0ef97bf7-5627-46be-847a-e111cc9c3917.pdf	6775018	\N	t	32	23	2026-05-18 21:28:06.939416	привет
18	8	1_25.01.03ра	4	Забони хориҷӣ аз рӯи ихтисос	Исломова Парвина Наимовна	\N	\N	\N	\N	f	\N	26	2026-05-21 16:05:37.161618	hello
19	8	1_25.01.03ра	4	Забони хориҷӣ аз рӯи ихтисос	Исломова Парвина Наимовна	\N	\N	\N	\N	f	\N	26	2026-05-22 08:13:13.448367	hi
\.


--
-- TOC entry 5243 (class 0 OID 33314)
-- Dependencies: 240
-- Data for Name: file_submissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.file_submissions (id, group_id, uploaded_by, teacher_id, title, description, file_path, file_size, status, created_at, cycle) FROM stdin;
\.


--
-- TOC entry 5225 (class 0 OID 33127)
-- Dependencies: 222
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groups (id, name, year, created_at) FROM stdin;
1	1_400301ра	1	2026-04-27 17:43:16.924944
2	2_400301ра	2	2026-04-27 17:43:17.089397
3	3_400301ра	3	2026-04-27 17:43:17.09511
4	2_25.01.07та	2	2026-05-12 09:18:10.536107
5	1_43.01.03тб	1	2026-05-14 09:09:43.021461
6	1_25.01.07ра	1	2026-05-15 08:46:09.246582
7	1_25.01.03ра	1	2026-05-20 10:47:22.924912
\.


--
-- TOC entry 5237 (class 0 OID 33244)
-- Dependencies: 234
-- Data for Name: ideas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ideas (id, title, body, author_id, moder_id, status, votes, created_at, approved, moderator_comment, approved_by) FROM stdin;
16	Теннисный стол	Поставить теннисный стол в коридоре	3	\N	accepted	3	2026-05-04 13:39:40.791949	t	хорошая идея, включим в этом цикле	3
\.


--
-- TOC entry 5239 (class 0 OID 33270)
-- Dependencies: 236
-- Data for Name: ideas_likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ideas_likes (id, user_id, ideas_id, status) FROM stdin;
13	4	16	t
15	1	16	t
16	23	16	t
\.


--
-- TOC entry 5241 (class 0 OID 33293)
-- Dependencies: 238
-- Data for Name: library_books; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.library_books (id, title, author, subject, file_path, file_size, uploaded_by, approved, category, downloads, created_at, description, document_type, publisher, approved_by, status, reject_reason) FROM stdin;
34	d	d	d	b75e2a11-85fc-4ab1-8c1a-67892d487e15.docx	20175	1	t	\N	2	2026-05-05 23:22:42.154417	d	Книга	d	3	approved	\N
32	Дискретная математика	Тишин	Высшая математика	0ef97bf7-5627-46be-847a-e111cc9c3917.pdf	6775018	3	t	\N	1	2026-05-04 13:37:34.96496	\N	Книга	Кафедра цифровых технологий	3	approved	\N
\.


--
-- TOC entry 5247 (class 0 OID 33412)
-- Dependencies: 244
-- Data for Name: library_favorites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.library_favorites (id, user_id, book_id, created_at) FROM stdin;
\.


--
-- TOC entry 5233 (class 0 OID 33202)
-- Dependencies: 230
-- Data for Name: moderators; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.moderators (id, user_id, assigned_at, is_active) FROM stdin;
1	3	2026-04-16	t
\.


--
-- TOC entry 5223 (class 0 OID 33116)
-- Dependencies: 220
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name) FROM stdin;
1	student
2	teacher
3	moderator
4	admin
\.


--
-- TOC entry 5245 (class 0 OID 33344)
-- Dependencies: 242
-- Data for Name: semester; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.semester (id, name, academic_year, start_date, end_date) FROM stdin;
\.


--
-- TOC entry 5253 (class 0 OID 33466)
-- Dependencies: 250
-- Data for Name: semester_days; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.semester_days (id, semester_id, date, day_type, cycle_number, is_holiday, created_at) FROM stdin;
1	1	2026-01-26	1	1	f	2026-05-08 10:03:32.397962
2	1	2026-01-27	2	1	f	2026-05-08 10:03:32.398109
3	1	2026-01-28	3	1	f	2026-05-08 10:03:32.398109
4	1	2026-01-29	4	1	f	2026-05-08 10:03:32.39811
5	1	2026-01-30	5	1	f	2026-05-08 10:03:32.39811
6	1	2026-01-31	1 (Суб)	5	f	2026-05-08 10:03:32.39811
7	1	2026-02-01	В	\N	f	2026-05-08 10:03:32.39811
8	1	2026-02-02	6	1	f	2026-05-08 10:03:32.398111
9	1	2026-02-03	7	1	f	2026-05-08 10:03:32.398111
10	1	2026-02-04	ЧР1/8	1	f	2026-05-08 10:03:32.398219
11	1	2026-02-05	ЧР1/9	1	f	2026-05-08 10:03:32.398219
12	1	2026-02-06	10	1	f	2026-05-08 10:03:32.39822
13	1	2026-02-07	2 (Суб)	5	f	2026-05-08 10:03:32.39822
14	1	2026-02-08	В	\N	f	2026-05-08 10:03:32.39822
15	1	2026-02-09	11	1	f	2026-05-08 10:03:32.39822
16	1	2026-02-10	12	1	f	2026-05-08 10:03:32.398221
17	1	2026-02-11	13	1	f	2026-05-08 10:03:32.398221
18	1	2026-02-12	14	1	f	2026-05-08 10:03:32.398221
19	1	2026-02-13	15	1	f	2026-05-08 10:03:32.398221
20	1	2026-02-14	3 (Суб)	5	f	2026-05-08 10:03:32.398221
21	1	2026-02-15	В	\N	f	2026-05-08 10:03:32.398222
22	1	2026-02-16	16	1	f	2026-05-08 10:03:32.398222
23	1	2026-02-17	ЧР2/17	1	f	2026-05-08 10:03:32.398222
24	1	2026-02-18	ЧР2/18	1	f	2026-05-08 10:03:32.398222
25	1	2026-02-19	ЧС	1	f	2026-05-08 10:03:32.398223
26	1	2026-02-20	КИН	1	f	2026-05-08 10:03:32.398224
27	1	2026-02-21	4 (Суб)	5	f	2026-05-08 10:03:32.398224
28	1	2026-02-22	В	\N	f	2026-05-08 10:03:32.398224
29	1	2026-02-23	ИН	1	f	2026-05-08 10:03:32.398225
30	1	2026-02-24	ИН	1	f	2026-05-08 10:03:32.398225
31	1	2026-02-25	1	2	f	2026-05-08 10:03:32.398226
32	1	2026-02-26	2	2	f	2026-05-08 10:03:32.398226
33	1	2026-02-27	3	2	f	2026-05-08 10:03:32.398226
34	1	2026-02-28	5 (Суб)	5	f	2026-05-08 10:03:32.398226
35	1	2026-03-01	В	\N	f	2026-05-08 10:03:32.398227
36	1	2026-03-02	4	2	f	2026-05-08 10:03:32.398227
37	1	2026-03-03	5	2	f	2026-05-08 10:03:32.398227
38	1	2026-03-04	6	2	f	2026-05-08 10:03:32.398227
39	1	2026-03-05	7	2	f	2026-05-08 10:03:32.398227
40	1	2026-03-06	ЧР1/8	2	f	2026-05-08 10:03:32.398228
41	1	2026-03-07	6 (Суб)	5	f	2026-05-08 10:03:32.398228
42	1	2026-03-08	В	\N	f	2026-05-08 10:03:32.398228
43	1	2026-03-09	П	\N	t	2026-05-08 10:03:32.398228
44	1	2026-03-10	ЧР1/9	2	f	2026-05-08 10:03:32.398228
45	1	2026-03-11	10	2	f	2026-05-08 10:03:32.398228
46	1	2026-03-12	11	2	f	2026-05-08 10:03:32.398229
47	1	2026-03-13	12	2	f	2026-05-08 10:03:32.398229
48	1	2026-03-14	7 (Суб)	5	f	2026-05-08 10:03:32.398229
49	1	2026-03-15	В	\N	f	2026-05-08 10:03:32.398229
50	1	2026-03-16	13	2	f	2026-05-08 10:03:32.39823
51	1	2026-03-17	14	2	f	2026-05-08 10:03:32.39823
52	1	2026-03-18	15	2	f	2026-05-08 10:03:32.39823
53	1	2026-03-19	16	2	f	2026-05-08 10:03:32.39823
54	1	2026-03-20	П	\N	t	2026-05-08 10:03:32.39823
55	1	2026-03-21	П	\N	t	2026-05-08 10:03:32.398231
56	1	2026-03-22	В	\N	f	2026-05-08 10:03:32.398231
57	1	2026-03-23	П	\N	t	2026-05-08 10:03:32.398231
58	1	2026-03-24	П	\N	t	2026-05-08 10:03:32.398238
59	1	2026-03-25	П	\N	t	2026-05-08 10:03:32.398238
60	1	2026-03-26	ЧР2/17	2	f	2026-05-08 10:03:32.398239
61	1	2026-03-27	ЧР2/18	2	f	2026-05-08 10:03:32.398239
62	1	2026-03-28	ЧР1/8 (Суб)	5	f	2026-05-08 10:03:32.398239
63	1	2026-03-29	В	\N	f	2026-05-08 10:03:32.398239
64	1	2026-03-30	ЧС	2	f	2026-05-08 10:03:32.398239
65	1	2026-03-31	КИН	2	f	2026-05-08 10:03:32.39824
66	1	2026-04-01	ИН	2	f	2026-05-08 10:03:32.39824
67	1	2026-04-02	ИН	2	f	2026-05-08 10:03:32.39824
68	1	2026-04-03	1	3	f	2026-05-08 10:03:32.39824
69	1	2026-04-04	ЧР1/9 (Суб)	5	f	2026-05-08 10:03:32.39824
70	1	2026-04-05	В	\N	f	2026-05-08 10:03:32.398241
71	1	2026-04-06	2	3	f	2026-05-08 10:03:32.398241
72	1	2026-04-07	3	3	f	2026-05-08 10:03:32.398241
73	1	2026-04-08	4	3	f	2026-05-08 10:03:32.398241
74	1	2026-04-09	5	3	f	2026-05-08 10:03:32.398241
75	1	2026-04-10	6	3	f	2026-05-08 10:03:32.398242
76	1	2026-04-11	10 (Суб)	5	f	2026-05-08 10:03:32.398242
77	1	2026-04-12	В	\N	f	2026-05-08 10:03:32.398242
78	1	2026-04-13	7	3	f	2026-05-08 10:03:32.398242
79	1	2026-04-14	ЧР1/8	3	f	2026-05-08 10:03:32.398242
80	1	2026-04-15	ЧР1/9	3	f	2026-05-08 10:03:32.398242
81	1	2026-04-16	10	3	f	2026-05-08 10:03:32.398243
82	1	2026-04-17	11	3	f	2026-05-08 10:03:32.398243
83	1	2026-04-18	11 (Суб)	5	f	2026-05-08 10:03:32.398243
84	1	2026-04-19	В	\N	f	2026-05-08 10:03:32.398243
85	1	2026-04-20	12	3	f	2026-05-08 10:03:32.398243
86	1	2026-04-21	13	3	f	2026-05-08 10:03:32.398244
87	1	2026-04-22	14	3	f	2026-05-08 10:03:32.398244
88	1	2026-04-23	15	3	f	2026-05-08 10:03:32.398244
89	1	2026-04-24	16	3	f	2026-05-08 10:03:32.398244
90	1	2026-04-25	12 (Суб)	5	f	2026-05-08 10:03:32.398244
91	1	2026-04-26	В	\N	f	2026-05-08 10:03:32.398245
92	1	2026-04-27	ЧР2/17	3	f	2026-05-08 10:03:32.398245
93	1	2026-04-28	ЧР2/18	3	f	2026-05-08 10:03:32.398245
94	1	2026-04-29	ЧС	3	f	2026-05-08 10:03:32.398245
95	1	2026-04-30	КИН	3	f	2026-05-08 10:03:32.398245
96	1	2026-05-01	ИН	3	f	2026-05-08 10:03:32.398245
97	1	2026-05-02	13 (Суб)	5	f	2026-05-08 10:03:32.398246
98	1	2026-05-03	В	\N	f	2026-05-08 10:03:32.398246
99	1	2026-05-04	ИН	3	f	2026-05-08 10:03:32.398246
100	1	2026-05-05	1	4	f	2026-05-08 10:03:32.398246
101	1	2026-05-06	2	4	f	2026-05-08 10:03:32.398247
102	1	2026-05-07	3	4	f	2026-05-08 10:03:32.398247
103	1	2026-05-08	4	4	f	2026-05-08 10:03:32.398247
104	1	2026-05-09	П	\N	t	2026-05-08 10:03:32.398247
105	1	2026-05-10	В	\N	f	2026-05-08 10:03:32.398247
106	1	2026-05-11	5	4	f	2026-05-08 10:03:32.398247
107	1	2026-05-12	6	4	f	2026-05-08 10:03:32.398248
108	1	2026-05-13	7	4	f	2026-05-08 10:03:32.398248
109	1	2026-05-14	ЧР1/8	4	f	2026-05-08 10:03:32.398248
110	1	2026-05-15	ЧР1/9	4	f	2026-05-08 10:03:32.398248
111	1	2026-05-16	14 (Суб)	5	f	2026-05-08 10:03:32.398248
112	1	2026-05-17	В	\N	f	2026-05-08 10:03:32.398249
113	1	2026-05-18	10	4	f	2026-05-08 10:03:32.398249
114	1	2026-05-19	11	4	f	2026-05-08 10:03:32.398249
115	1	2026-05-20	12	4	f	2026-05-08 10:03:32.398249
116	1	2026-05-21	13	4	f	2026-05-08 10:03:32.398249
117	1	2026-05-22	14	4	f	2026-05-08 10:03:32.39825
118	1	2026-05-23	15 (Суб)	5	f	2026-05-08 10:03:32.39825
119	1	2026-05-24	В	\N	f	2026-05-08 10:03:32.39825
120	1	2026-05-25	15	4	f	2026-05-08 10:03:32.39825
121	1	2026-05-26	16	4	f	2026-05-08 10:03:32.39825
122	1	2026-05-27	П	\N	t	2026-05-08 10:03:32.398251
123	1	2026-05-28	ЧР2/17	4	f	2026-05-08 10:03:32.398251
124	1	2026-05-29	ЧР2/18	4	f	2026-05-08 10:03:32.398251
125	1	2026-05-30	16 (Суб)	5	f	2026-05-08 10:03:32.398252
126	1	2026-05-31	В	\N	f	2026-05-08 10:03:32.398252
127	1	2026-06-01	ЧС	4	f	2026-05-08 10:03:32.398252
128	1	2026-06-02	КИН	4	f	2026-05-08 10:03:32.398252
129	1	2026-06-03	ИН	4	f	2026-05-08 10:03:32.398253
130	1	2026-06-04	ИН	4	f	2026-05-08 10:03:32.398253
131	1	2026-06-05	ЧР2/18	5	f	2026-05-08 10:03:32.398253
132	1	2026-06-06	ЧР2/17 (Суб)	5	f	2026-05-08 10:03:32.398253
133	1	2026-06-07	В	\N	f	2026-05-08 10:03:32.398253
134	1	2026-06-08	ЧС	5	f	2026-05-08 10:03:32.398253
135	1	2026-06-09	КИН	5	f	2026-05-08 10:03:32.398254
136	1	2026-06-10	ИН	5	f	2026-05-08 10:03:32.398254
137	1	2026-06-11	ИН	5	f	2026-05-08 10:03:32.398254
138	2	2026-01-26	1	1	f	2026-05-08 10:08:42.762092
139	2	2026-01-27	2	1	f	2026-05-08 10:08:42.762295
140	2	2026-01-28	3	1	f	2026-05-08 10:08:42.762296
141	2	2026-01-29	4	1	f	2026-05-08 10:08:42.762296
142	2	2026-01-30	5	1	f	2026-05-08 10:08:42.762297
143	2	2026-01-31	1 (Суб)	5	f	2026-05-08 10:08:42.762297
144	2	2026-02-01	В	\N	f	2026-05-08 10:08:42.762297
145	2	2026-02-02	6	1	f	2026-05-08 10:08:42.762297
146	2	2026-02-03	7	1	f	2026-05-08 10:08:42.762298
147	2	2026-02-04	ЧР1/8	1	f	2026-05-08 10:08:42.762428
148	2	2026-02-05	ЧР1/9	1	f	2026-05-08 10:08:42.762428
149	2	2026-02-06	10	1	f	2026-05-08 10:08:42.762428
150	2	2026-02-07	2 (Суб)	5	f	2026-05-08 10:08:42.762429
151	2	2026-02-08	В	\N	f	2026-05-08 10:08:42.762429
152	2	2026-02-09	11	1	f	2026-05-08 10:08:42.762429
153	2	2026-02-10	12	1	f	2026-05-08 10:08:42.76243
154	2	2026-02-11	13	1	f	2026-05-08 10:08:42.76243
155	2	2026-02-12	14	1	f	2026-05-08 10:08:42.76243
156	2	2026-02-13	15	1	f	2026-05-08 10:08:42.76243
157	2	2026-02-14	3 (Суб)	5	f	2026-05-08 10:08:42.762431
158	2	2026-02-15	В	\N	f	2026-05-08 10:08:42.762431
159	2	2026-02-16	16	1	f	2026-05-08 10:08:42.762431
160	2	2026-02-17	ЧР2/17	1	f	2026-05-08 10:08:42.762432
161	2	2026-02-18	ЧР2/18	1	f	2026-05-08 10:08:42.762432
162	2	2026-02-19	ЧС	1	f	2026-05-08 10:08:42.762432
163	2	2026-02-20	КИН	1	f	2026-05-08 10:08:42.762434
164	2	2026-02-21	4 (Суб)	5	f	2026-05-08 10:08:42.762434
165	2	2026-02-22	В	\N	f	2026-05-08 10:08:42.762434
166	2	2026-02-23	ИН	1	f	2026-05-08 10:08:42.762434
167	2	2026-02-24	ИН	1	f	2026-05-08 10:08:42.762435
168	2	2026-02-25	1	2	f	2026-05-08 10:08:42.762436
169	2	2026-02-26	2	2	f	2026-05-08 10:08:42.762437
170	2	2026-02-27	3	2	f	2026-05-08 10:08:42.762437
171	2	2026-02-28	5 (Суб)	5	f	2026-05-08 10:08:42.762437
172	2	2026-03-01	В	\N	f	2026-05-08 10:08:42.762438
173	2	2026-03-02	4	2	f	2026-05-08 10:08:42.762438
174	2	2026-03-03	5	2	f	2026-05-08 10:08:42.762438
175	2	2026-03-04	6	2	f	2026-05-08 10:08:42.762439
176	2	2026-03-05	7	2	f	2026-05-08 10:08:42.762439
177	2	2026-03-06	ЧР1/8	2	f	2026-05-08 10:08:42.762439
178	2	2026-03-07	6 (Суб)	5	f	2026-05-08 10:08:42.76244
179	2	2026-03-08	В	\N	f	2026-05-08 10:08:42.76244
180	2	2026-03-09	П	\N	t	2026-05-08 10:08:42.76244
181	2	2026-03-10	ЧР1/9	2	f	2026-05-08 10:08:42.762441
182	2	2026-03-11	10	2	f	2026-05-08 10:08:42.762441
183	2	2026-03-12	11	2	f	2026-05-08 10:08:42.762441
184	2	2026-03-13	12	2	f	2026-05-08 10:08:42.762441
185	2	2026-03-14	7 (Суб)	5	f	2026-05-08 10:08:42.762442
186	2	2026-03-15	В	\N	f	2026-05-08 10:08:42.762442
187	2	2026-03-16	13	2	f	2026-05-08 10:08:42.762442
188	2	2026-03-17	14	2	f	2026-05-08 10:08:42.762443
189	2	2026-03-18	15	2	f	2026-05-08 10:08:42.762443
190	2	2026-03-19	16	2	f	2026-05-08 10:08:42.762443
191	2	2026-03-20	П	\N	t	2026-05-08 10:08:42.762444
192	2	2026-03-21	П	\N	t	2026-05-08 10:08:42.762444
193	2	2026-03-22	В	\N	f	2026-05-08 10:08:42.762444
194	2	2026-03-23	П	\N	t	2026-05-08 10:08:42.762445
195	2	2026-03-24	П	\N	t	2026-05-08 10:08:42.762446
196	2	2026-03-25	П	\N	t	2026-05-08 10:08:42.762446
197	2	2026-03-26	ЧР2/17	2	f	2026-05-08 10:08:42.762447
198	2	2026-03-27	ЧР2/18	2	f	2026-05-08 10:08:42.762447
199	2	2026-03-28	ЧР1/8 (Суб)	5	f	2026-05-08 10:08:42.762447
200	2	2026-03-29	В	\N	f	2026-05-08 10:08:42.762447
201	2	2026-03-30	ЧС	2	f	2026-05-08 10:08:42.762448
202	2	2026-03-31	КИН	2	f	2026-05-08 10:08:42.762448
203	2	2026-04-01	ИН	2	f	2026-05-08 10:08:42.762448
204	2	2026-04-02	ИН	2	f	2026-05-08 10:08:42.762449
205	2	2026-04-03	1	3	f	2026-05-08 10:08:42.762449
206	2	2026-04-04	ЧР1/9 (Суб)	5	f	2026-05-08 10:08:42.762449
207	2	2026-04-05	В	\N	f	2026-05-08 10:08:42.762449
208	2	2026-04-06	2	3	f	2026-05-08 10:08:42.76245
209	2	2026-04-07	3	3	f	2026-05-08 10:08:42.76245
210	2	2026-04-08	4	3	f	2026-05-08 10:08:42.76245
211	2	2026-04-09	5	3	f	2026-05-08 10:08:42.76245
212	2	2026-04-10	6	3	f	2026-05-08 10:08:42.762451
213	2	2026-04-11	10 (Суб)	5	f	2026-05-08 10:08:42.762451
214	2	2026-04-12	В	\N	f	2026-05-08 10:08:42.762451
215	2	2026-04-13	7	3	f	2026-05-08 10:08:42.762452
216	2	2026-04-14	ЧР1/8	3	f	2026-05-08 10:08:42.762452
217	2	2026-04-15	ЧР1/9	3	f	2026-05-08 10:08:42.762452
218	2	2026-04-16	10	3	f	2026-05-08 10:08:42.762453
219	2	2026-04-17	11	3	f	2026-05-08 10:08:42.762453
220	2	2026-04-18	11 (Суб)	5	f	2026-05-08 10:08:42.762453
221	2	2026-04-19	В	\N	f	2026-05-08 10:08:42.762453
222	2	2026-04-20	12	3	f	2026-05-08 10:08:42.762454
223	2	2026-04-21	13	3	f	2026-05-08 10:08:42.762454
224	2	2026-04-22	14	3	f	2026-05-08 10:08:42.762454
225	2	2026-04-23	15	3	f	2026-05-08 10:08:42.762454
226	2	2026-04-24	16	3	f	2026-05-08 10:08:42.762455
227	2	2026-04-25	12 (Суб)	5	f	2026-05-08 10:08:42.762455
228	2	2026-04-26	В	\N	f	2026-05-08 10:08:42.762455
229	2	2026-04-27	ЧР2/17	3	f	2026-05-08 10:08:42.762456
230	2	2026-04-28	ЧР2/18	3	f	2026-05-08 10:08:42.762456
231	2	2026-04-29	ЧС	3	f	2026-05-08 10:08:42.762456
232	2	2026-04-30	КИН	3	f	2026-05-08 10:08:42.762457
233	2	2026-05-01	ИН	3	f	2026-05-08 10:08:42.762457
234	2	2026-05-02	13 (Суб)	5	f	2026-05-08 10:08:42.762457
235	2	2026-05-03	В	\N	f	2026-05-08 10:08:42.762457
236	2	2026-05-04	ИН	3	f	2026-05-08 10:08:42.762458
237	2	2026-05-05	1	4	f	2026-05-08 10:08:42.762458
238	2	2026-05-06	2	4	f	2026-05-08 10:08:42.762468
239	2	2026-05-07	3	4	f	2026-05-08 10:08:42.762468
240	2	2026-05-08	4	4	f	2026-05-08 10:08:42.762468
241	2	2026-05-09	П	\N	t	2026-05-08 10:08:42.762469
242	2	2026-05-10	В	\N	f	2026-05-08 10:08:42.762469
243	2	2026-05-11	5	4	f	2026-05-08 10:08:42.762469
244	2	2026-05-12	6	4	f	2026-05-08 10:08:42.762469
245	2	2026-05-13	7	4	f	2026-05-08 10:08:42.76247
246	2	2026-05-14	ЧР1/8	4	f	2026-05-08 10:08:42.76247
247	2	2026-05-15	ЧР1/9	4	f	2026-05-08 10:08:42.76247
248	2	2026-05-16	14 (Суб)	5	f	2026-05-08 10:08:42.762471
249	2	2026-05-17	В	\N	f	2026-05-08 10:08:42.762471
250	2	2026-05-18	10	4	f	2026-05-08 10:08:42.762471
251	2	2026-05-19	11	4	f	2026-05-08 10:08:42.762472
252	2	2026-05-20	12	4	f	2026-05-08 10:08:42.762472
253	2	2026-05-21	13	4	f	2026-05-08 10:08:42.762472
254	2	2026-05-22	14	4	f	2026-05-08 10:08:42.762473
255	2	2026-05-23	15 (Суб)	5	f	2026-05-08 10:08:42.762473
256	2	2026-05-24	В	\N	f	2026-05-08 10:08:42.762473
257	2	2026-05-25	15	4	f	2026-05-08 10:08:42.762473
258	2	2026-05-26	16	4	f	2026-05-08 10:08:42.762474
668	6	2025-09-01	1	1	f	2026-05-09 08:38:09.503968
260	2	2026-05-28	ЧР2/18	4	f	2026-05-08 10:08:42.762475
261	2	2026-05-29	ЧС	4	f	2026-05-08 10:08:42.762475
262	2	2026-05-30	16 (Суб)	5	f	2026-05-08 10:08:42.762475
263	2	2026-05-31	В	\N	f	2026-05-08 10:08:42.762476
264	2	2026-06-01	КИН	4	f	2026-05-08 10:08:42.762476
265	2	2026-06-02	ИН	4	f	2026-05-08 10:08:42.762476
266	2	2026-06-03	ИН	4	f	2026-05-08 10:08:42.762476
267	2	2026-06-04	ЧР2/18	5	f	2026-05-08 10:08:42.762477
268	2	2026-06-05	ЧС	5	f	2026-05-08 10:08:42.762477
269	2	2026-06-06	ЧР2/17 (Суб)	5	f	2026-05-08 10:08:42.762477
270	2	2026-06-07	В	\N	f	2026-05-08 10:08:42.762478
271	2	2026-06-08	КИН	5	f	2026-05-08 10:08:42.762478
272	2	2026-06-09	ИН	5	f	2026-05-08 10:08:42.762478
273	2	2026-06-10	ИН	5	f	2026-05-08 10:08:42.762478
259	2	2026-05-27	В	4	t	2026-05-08 10:08:42.762474
669	6	2025-09-02	2	1	f	2026-05-09 08:38:09.504195
670	6	2025-09-03	3	1	f	2026-05-09 08:38:09.504196
274	2	2026-06-11	ИН	5	f	2026-05-08 10:08:42.762479
275	3	2025-09-10	1	1	f	2026-05-08 10:29:39.032407
276	3	2025-09-11	2	1	f	2026-05-08 10:29:39.032729
277	3	2025-09-12	3	1	f	2026-05-08 10:29:39.03273
278	3	2025-09-13	1 (Суб)	5	f	2026-05-08 10:29:39.03273
279	3	2025-09-14	В	\N	f	2026-05-08 10:29:39.032731
280	3	2025-09-15	4	1	f	2026-05-08 10:29:39.032731
281	3	2025-09-16	5	1	f	2026-05-08 10:29:39.032731
282	3	2025-09-17	6	1	f	2026-05-08 10:29:39.032731
283	3	2025-09-18	7	1	f	2026-05-08 10:29:39.032732
284	3	2025-09-19	ЧР1/8	1	f	2026-05-08 10:29:39.03296
285	3	2025-09-20	2 (Суб)	5	f	2026-05-08 10:29:39.032961
286	3	2025-09-21	В	\N	f	2026-05-08 10:29:39.032961
287	3	2025-09-22	ЧР1/9	1	f	2026-05-08 10:29:39.032961
288	3	2025-09-23	10	1	f	2026-05-08 10:29:39.032962
289	3	2025-09-24	11	1	f	2026-05-08 10:29:39.032962
290	3	2025-09-25	12	1	f	2026-05-08 10:29:39.032962
291	3	2025-09-26	13	1	f	2026-05-08 10:29:39.032962
292	3	2025-09-27	3 (Суб)	5	f	2026-05-08 10:29:39.032963
293	3	2025-09-28	В	\N	f	2026-05-08 10:29:39.032963
294	3	2025-09-29	14	1	f	2026-05-08 10:29:39.032963
295	3	2025-09-30	15	1	f	2026-05-08 10:29:39.032963
296	3	2025-10-01	16	1	f	2026-05-08 10:29:39.032964
297	3	2025-10-02	ЧР2/17	1	f	2026-05-08 10:29:39.032964
298	3	2025-10-03	ЧР2/18	1	f	2026-05-08 10:29:39.032964
299	3	2025-10-04	4 (Суб)	5	f	2026-05-08 10:29:39.032965
300	3	2025-10-05	В	\N	f	2026-05-08 10:29:39.032967
301	3	2025-10-06	ЧС	1	f	2026-05-08 10:29:39.032967
302	3	2025-10-07	КИН	1	f	2026-05-08 10:29:39.032968
303	3	2025-10-08	ИН	1	f	2026-05-08 10:29:39.032968
304	3	2025-10-09	ИН	1	f	2026-05-08 10:29:39.032968
305	3	2025-10-10	1	2	f	2026-05-08 10:29:39.03297
306	3	2025-10-11	5 (Суб)	5	f	2026-05-08 10:29:39.032971
307	3	2025-10-12	В	\N	f	2026-05-08 10:29:39.032971
308	3	2025-10-13	2	2	f	2026-05-08 10:29:39.032971
309	3	2025-10-14	3	2	f	2026-05-08 10:29:39.032972
310	3	2025-10-15	4	2	f	2026-05-08 10:29:39.032972
311	3	2025-10-16	5	2	f	2026-05-08 10:29:39.032972
312	3	2025-10-17	6	2	f	2026-05-08 10:29:39.032972
313	3	2025-10-18	6 (Суб)	5	f	2026-05-08 10:29:39.032973
314	3	2025-10-19	В	\N	f	2026-05-08 10:29:39.032973
315	3	2025-10-20	7	2	f	2026-05-08 10:29:39.032973
316	3	2025-10-21	ЧР1/8	2	f	2026-05-08 10:29:39.032974
317	3	2025-10-22	ЧР1/9	2	f	2026-05-08 10:29:39.032974
318	3	2025-10-23	10	2	f	2026-05-08 10:29:39.032974
319	3	2025-10-24	11	2	f	2026-05-08 10:29:39.032974
320	3	2025-10-25	7 (Суб)	5	f	2026-05-08 10:29:39.032975
321	3	2025-10-26	В	\N	f	2026-05-08 10:29:39.032975
322	3	2025-10-27	12	2	f	2026-05-08 10:29:39.032975
323	3	2025-10-28	13	2	f	2026-05-08 10:29:39.032976
324	3	2025-10-29	14	2	f	2026-05-08 10:29:39.032976
325	3	2025-10-30	15	2	f	2026-05-08 10:29:39.032976
326	3	2025-10-31	16	2	f	2026-05-08 10:29:39.032977
327	3	2025-11-01	ЧР1/8 (Суб)	5	f	2026-05-08 10:29:39.032977
328	3	2025-11-02	В	\N	f	2026-05-08 10:29:39.032977
329	3	2025-11-03	ЧР2/17	2	f	2026-05-08 10:29:39.032977
330	3	2025-11-04	ЧР2/18	2	f	2026-05-08 10:29:39.032978
331	3	2025-11-05	ЧС	2	f	2026-05-08 10:29:39.032978
332	3	2025-11-06	КИН	2	f	2026-05-08 10:29:39.032979
333	3	2025-11-07	ИН	2	f	2026-05-08 10:29:39.032979
334	3	2025-11-08	ЧР1/9 (Суб)	5	f	2026-05-08 10:29:39.03298
335	3	2025-11-09	В	\N	f	2026-05-08 10:29:39.03298
336	3	2025-11-10	ИН	2	f	2026-05-08 10:29:39.03298
337	3	2025-11-11	1	3	f	2026-05-08 10:29:39.03298
338	3	2025-11-12	2	3	f	2026-05-08 10:29:39.032981
339	3	2025-11-13	3	3	f	2026-05-08 10:29:39.032981
340	3	2025-11-14	4	3	f	2026-05-08 10:29:39.032981
341	3	2025-11-15	10 (Суб)	5	f	2026-05-08 10:29:39.032982
342	3	2025-11-16	В	\N	f	2026-05-08 10:29:39.032982
343	3	2025-11-17	5	3	f	2026-05-08 10:29:39.032982
344	3	2025-11-18	6	3	f	2026-05-08 10:29:39.032982
345	3	2025-11-19	7	3	f	2026-05-08 10:29:39.032983
346	3	2025-11-20	ЧР1/8	3	f	2026-05-08 10:29:39.032983
347	3	2025-11-21	ЧР1/9	3	f	2026-05-08 10:29:39.032983
348	3	2025-11-22	11 (Суб)	5	f	2026-05-08 10:29:39.032983
349	3	2025-11-23	В	\N	f	2026-05-08 10:29:39.032984
350	3	2025-11-24	10	3	f	2026-05-08 10:29:39.032984
351	3	2025-11-25	11	3	f	2026-05-08 10:29:39.032984
352	3	2025-11-26	12	3	f	2026-05-08 10:29:39.032985
353	3	2025-11-27	13	3	f	2026-05-08 10:29:39.032985
354	3	2025-11-28	14	3	f	2026-05-08 10:29:39.032985
355	3	2025-11-29	12 (Суб)	5	f	2026-05-08 10:29:39.032985
356	3	2025-11-30	В	\N	f	2026-05-08 10:29:39.032986
357	3	2025-12-01	15	3	f	2026-05-08 10:29:39.032986
358	3	2025-12-02	16	3	f	2026-05-08 10:29:39.032989
359	3	2025-12-03	ЧР2/17	3	f	2026-05-08 10:29:39.03299
360	3	2025-12-04	ЧР2/18	3	f	2026-05-08 10:29:39.03299
361	3	2025-12-05	ЧС	3	f	2026-05-08 10:29:39.03299
362	3	2025-12-06	13 (Суб)	5	f	2026-05-08 10:29:39.03299
363	3	2025-12-07	В	\N	f	2026-05-08 10:29:39.032991
364	3	2025-12-08	КИН	3	f	2026-05-08 10:29:39.032991
365	3	2025-12-09	ИН	3	f	2026-05-08 10:29:39.032991
366	3	2025-12-10	ИН	3	f	2026-05-08 10:29:39.032991
367	3	2025-12-11	1	4	f	2026-05-08 10:29:39.032992
368	3	2025-12-12	2	4	f	2026-05-08 10:29:39.032992
369	3	2025-12-13	14 (Суб)	5	f	2026-05-08 10:29:39.032992
370	3	2025-12-14	В	\N	f	2026-05-08 10:29:39.032992
371	3	2025-12-15	3	4	f	2026-05-08 10:29:39.032993
372	3	2025-12-16	4	4	f	2026-05-08 10:29:39.032993
373	3	2025-12-17	5	4	f	2026-05-08 10:29:39.032993
374	3	2025-12-18	6	4	f	2026-05-08 10:29:39.032994
375	3	2025-12-19	7	4	f	2026-05-08 10:29:39.032994
376	3	2025-12-20	15 (Суб)	5	f	2026-05-08 10:29:39.032994
377	3	2025-12-21	В	\N	f	2026-05-08 10:29:39.032994
378	3	2025-12-22	ЧР1/8	4	f	2026-05-08 10:29:39.032995
379	3	2025-12-23	ЧР1/9	4	f	2026-05-08 10:29:39.032995
380	3	2025-12-24	10	4	f	2026-05-08 10:29:39.032995
381	3	2025-12-25	11	4	f	2026-05-08 10:29:39.032996
382	3	2025-12-26	12	4	f	2026-05-08 10:29:39.032996
383	3	2025-12-27	16 (Суб)	5	f	2026-05-08 10:29:39.032996
384	3	2025-12-28	В	\N	f	2026-05-08 10:29:39.032996
385	3	2025-12-29	13	4	f	2026-05-08 10:29:39.032997
386	3	2025-12-30	14	4	f	2026-05-08 10:29:39.032997
387	3	2025-12-31	15	4	f	2026-05-08 10:29:39.032997
388	3	2026-01-01	П	\N	t	2026-05-08 10:29:39.032998
389	3	2026-01-02	16	4	f	2026-05-08 10:29:39.032998
390	3	2026-01-03	ЧР2/17 (Суб)	5	f	2026-05-08 10:29:39.032998
391	3	2026-01-04	В	\N	f	2026-05-08 10:29:39.032998
671	6	2025-09-04	4	1	f	2026-05-09 08:38:09.504197
392	3	2026-01-05	ЧР2/17	4	f	2026-05-08 10:29:39.032999
393	3	2026-01-06	ЧР2/18	4	f	2026-05-08 10:29:39.032999
394	3	2026-01-07	ЧС	4	f	2026-05-08 10:29:39.032999
395	3	2026-01-08	КИН	4	f	2026-05-08 10:29:39.033
396	3	2026-01-09	ИН	4	f	2026-05-08 10:29:39.033
397	3	2026-01-10	ЧР2/18 (Суб)	5	f	2026-05-08 10:29:39.033001
398	4	2025-09-01	1	1	f	2026-05-08 10:30:36.704219
399	4	2025-09-02	2	1	f	2026-05-08 10:30:36.704221
400	4	2025-09-03	3	1	f	2026-05-08 10:30:36.704221
401	4	2025-09-04	4	1	f	2026-05-08 10:30:36.704221
402	4	2025-09-05	5	1	f	2026-05-08 10:30:36.704222
403	4	2025-09-06	1 (Суб)	5	f	2026-05-08 10:30:36.704222
404	4	2025-09-07	В	\N	f	2026-05-08 10:30:36.704223
405	4	2025-09-08	6	1	f	2026-05-08 10:30:36.704223
406	4	2025-09-09	П	\N	t	2026-05-08 10:30:36.704241
407	4	2025-09-10	7	1	f	2026-05-08 10:30:36.704255
408	4	2025-09-11	ЧР1/8	1	f	2026-05-08 10:30:36.704256
409	4	2025-09-12	ЧР1/9	1	f	2026-05-08 10:30:36.704256
410	4	2025-09-13	2 (Суб)	5	f	2026-05-08 10:30:36.704257
411	4	2025-09-14	В	\N	f	2026-05-08 10:30:36.704257
412	4	2025-09-15	10	1	f	2026-05-08 10:30:36.704257
413	4	2025-09-16	11	1	f	2026-05-08 10:30:36.704257
414	4	2025-09-17	12	1	f	2026-05-08 10:30:36.704258
415	4	2025-09-18	13	1	f	2026-05-08 10:30:36.704258
416	4	2025-09-19	14	1	f	2026-05-08 10:30:36.704258
417	4	2025-09-20	3 (Суб)	5	f	2026-05-08 10:30:36.704259
418	4	2025-09-21	В	\N	f	2026-05-08 10:30:36.704259
419	4	2025-09-22	15	1	f	2026-05-08 10:30:36.704259
420	4	2025-09-23	16	1	f	2026-05-08 10:30:36.70426
421	4	2025-09-24	ЧР2/17	1	f	2026-05-08 10:30:36.70426
422	4	2025-09-25	ЧР2/18	1	f	2026-05-08 10:30:36.70426
423	4	2025-09-26	ЧС	1	f	2026-05-08 10:30:36.704261
424	4	2025-09-27	4 (Суб)	5	f	2026-05-08 10:30:36.704261
425	4	2025-09-28	В	\N	f	2026-05-08 10:30:36.704264
426	4	2025-09-29	КИН	1	f	2026-05-08 10:30:36.704264
427	4	2025-09-30	ИН	1	f	2026-05-08 10:30:36.704267
428	4	2025-10-01	ИН	1	f	2026-05-08 10:30:36.704269
429	4	2025-10-02	1	2	f	2026-05-08 10:30:36.70427
430	4	2025-10-03	2	2	f	2026-05-08 10:30:36.70427
431	4	2025-10-04	5 (Суб)	5	f	2026-05-08 10:30:36.70427
432	4	2025-10-05	В	\N	f	2026-05-08 10:30:36.704271
433	4	2025-10-06	П	\N	t	2026-05-08 10:30:36.704271
434	4	2025-10-07	3	2	f	2026-05-08 10:30:36.704271
435	4	2025-10-08	4	2	f	2026-05-08 10:30:36.704272
436	4	2025-10-09	5	2	f	2026-05-08 10:30:36.704272
437	4	2025-10-10	6	2	f	2026-05-08 10:30:36.704272
438	4	2025-10-11	6 (Суб)	5	f	2026-05-08 10:30:36.704273
439	4	2025-10-12	В	\N	f	2026-05-08 10:30:36.704273
440	4	2025-10-13	7	2	f	2026-05-08 10:30:36.704273
441	4	2025-10-14	ЧР1/8	2	f	2026-05-08 10:30:36.704274
442	4	2025-10-15	ЧР1/9	2	f	2026-05-08 10:30:36.704274
443	4	2025-10-16	10	2	f	2026-05-08 10:30:36.704274
444	4	2025-10-17	11	2	f	2026-05-08 10:30:36.704275
445	4	2025-10-18	7 (Суб)	5	f	2026-05-08 10:30:36.704275
446	4	2025-10-19	В	\N	f	2026-05-08 10:30:36.704275
447	4	2025-10-20	12	2	f	2026-05-08 10:30:36.704276
448	4	2025-10-21	13	2	f	2026-05-08 10:30:36.704276
449	4	2025-10-22	14	2	f	2026-05-08 10:30:36.704276
450	4	2025-10-23	15	2	f	2026-05-08 10:30:36.704276
451	4	2025-10-24	16	2	f	2026-05-08 10:30:36.704277
452	4	2025-10-25	ЧР1/8 (Суб)	5	f	2026-05-08 10:30:36.704277
453	4	2025-10-26	В	\N	f	2026-05-08 10:30:36.704277
454	4	2025-10-27	ЧР2/17	2	f	2026-05-08 10:30:36.704278
455	4	2025-10-28	ЧР2/18	2	f	2026-05-08 10:30:36.704278
456	4	2025-10-29	ЧС	2	f	2026-05-08 10:30:36.704278
457	4	2025-10-30	КИН	2	f	2026-05-08 10:30:36.704279
458	4	2025-10-31	ИН	2	f	2026-05-08 10:30:36.704279
459	4	2025-11-01	ЧР1/9 (Суб)	5	f	2026-05-08 10:30:36.704279
460	4	2025-11-02	В	\N	f	2026-05-08 10:30:36.70428
461	4	2025-11-03	ИН	2	f	2026-05-08 10:30:36.70428
462	4	2025-11-04	1	3	f	2026-05-08 10:30:36.70428
463	4	2025-11-05	2	3	f	2026-05-08 10:30:36.704281
464	4	2025-11-06	3	3	f	2026-05-08 10:30:36.704281
465	4	2025-11-07	4	3	f	2026-05-08 10:30:36.704281
466	4	2025-11-08	10 (Суб)	5	f	2026-05-08 10:30:36.704282
467	4	2025-11-09	В	\N	f	2026-05-08 10:30:36.704282
468	4	2025-11-10	5	3	f	2026-05-08 10:30:36.704282
469	4	2025-11-11	6	3	f	2026-05-08 10:30:36.704283
470	4	2025-11-12	7	3	f	2026-05-08 10:30:36.704283
471	4	2025-11-13	ЧР1/8	3	f	2026-05-08 10:30:36.704283
472	4	2025-11-14	ЧР1/9	3	f	2026-05-08 10:30:36.704283
473	4	2025-11-15	11 (Суб)	5	f	2026-05-08 10:30:36.704284
474	4	2025-11-16	В	\N	f	2026-05-08 10:30:36.704284
475	4	2025-11-17	10	3	f	2026-05-08 10:30:36.704284
476	4	2025-11-18	11	3	f	2026-05-08 10:30:36.704285
477	4	2025-11-19	12	3	f	2026-05-08 10:30:36.704285
478	4	2025-11-20	13	3	f	2026-05-08 10:30:36.704285
479	4	2025-11-21	14	3	f	2026-05-08 10:30:36.704286
480	4	2025-11-22	12 (Суб)	5	f	2026-05-08 10:30:36.704286
481	4	2025-11-23	В	\N	f	2026-05-08 10:30:36.704286
482	4	2025-11-24	15	3	f	2026-05-08 10:30:36.704286
483	4	2025-11-25	16	3	f	2026-05-08 10:30:36.704287
484	4	2025-11-26	ЧР2/17	3	f	2026-05-08 10:30:36.704287
485	4	2025-11-27	ЧР2/18	3	f	2026-05-08 10:30:36.704287
486	4	2025-11-28	ЧС	3	f	2026-05-08 10:30:36.704288
487	4	2025-11-29	13 (Суб)	5	f	2026-05-08 10:30:36.704288
488	4	2025-11-30	В	\N	f	2026-05-08 10:30:36.704288
489	4	2025-12-01	КИН	3	f	2026-05-08 10:30:36.704289
490	4	2025-12-02	ИН	3	f	2026-05-08 10:30:36.704289
491	4	2025-12-03	ИН	3	f	2026-05-08 10:30:36.704289
492	4	2025-12-04	1	4	f	2026-05-08 10:30:36.704289
493	4	2025-12-05	2	4	f	2026-05-08 10:30:36.70429
494	4	2025-12-06	14 (Суб)	5	f	2026-05-08 10:30:36.70429
495	4	2025-12-07	В	\N	f	2026-05-08 10:30:36.70429
496	4	2025-12-08	3	4	f	2026-05-08 10:30:36.704308
497	4	2025-12-09	4	4	f	2026-05-08 10:30:36.704309
498	4	2025-12-10	5	4	f	2026-05-08 10:30:36.704309
499	4	2025-12-11	6	4	f	2026-05-08 10:30:36.704309
500	4	2025-12-12	7	4	f	2026-05-08 10:30:36.70431
501	4	2025-12-13	15 (Суб)	5	f	2026-05-08 10:30:36.70431
502	4	2025-12-14	В	\N	f	2026-05-08 10:30:36.70431
503	4	2025-12-15	ЧР1/8	4	f	2026-05-08 10:30:36.704311
504	4	2025-12-16	ЧР1/9	4	f	2026-05-08 10:30:36.704311
505	4	2025-12-17	10	4	f	2026-05-08 10:30:36.704311
506	4	2025-12-18	11	4	f	2026-05-08 10:30:36.704312
507	4	2025-12-19	12	4	f	2026-05-08 10:30:36.704312
508	4	2025-12-20	16 (Суб)	5	f	2026-05-08 10:30:36.704312
509	4	2025-12-21	В	\N	f	2026-05-08 10:30:36.704313
510	4	2025-12-22	13	4	f	2026-05-08 10:30:36.704313
511	4	2025-12-23	14	4	f	2026-05-08 10:30:36.704313
512	4	2025-12-24	15	4	f	2026-05-08 10:30:36.704313
513	4	2025-12-25	16	4	f	2026-05-08 10:30:36.704314
514	4	2025-12-26	ЧР2/17	4	f	2026-05-08 10:30:36.704314
515	4	2025-12-27	ЧР2/17 (Суб)	5	f	2026-05-08 10:30:36.704314
516	4	2025-12-28	В	\N	f	2026-05-08 10:30:36.704315
517	4	2025-12-29	ЧР2/18	4	f	2026-05-08 10:30:36.704315
518	4	2025-12-30	ЧС	4	f	2026-05-08 10:30:36.704315
519	4	2025-12-31	КИН	4	f	2026-05-08 10:30:36.704316
520	4	2026-01-01	П	\N	t	2026-05-08 10:30:36.704316
521	4	2026-01-02	ИН	4	f	2026-05-08 10:30:36.704316
522	4	2026-01-03	ЧР2/18 (Суб)	5	f	2026-05-08 10:30:36.704317
523	4	2026-01-04	В	\N	f	2026-05-08 10:30:36.704317
524	4	2026-01-05	ИН	4	f	2026-05-08 10:30:36.704318
525	4	2026-01-06	КИН	5	f	2026-05-08 10:30:36.704318
526	4	2026-01-07	ИН	5	f	2026-05-08 10:30:36.704318
527	4	2026-01-08	ИН	5	f	2026-05-08 10:30:36.704318
528	4	2026-01-09		\N	f	2026-05-08 10:30:36.704319
529	4	2026-01-10	ЧС (Суб)	5	f	2026-05-08 10:30:36.704319
530	5	2026-01-26	1	1	f	2026-05-08 11:21:57.30213
531	5	2026-01-27	2	1	f	2026-05-08 11:21:57.30242
532	5	2026-01-28	3	1	f	2026-05-08 11:21:57.302421
533	5	2026-01-29	4	1	f	2026-05-08 11:21:57.302422
534	5	2026-01-30	5	1	f	2026-05-08 11:21:57.302422
535	5	2026-01-31	1 (Суб)	5	f	2026-05-08 11:21:57.302422
536	5	2026-02-01	В	\N	f	2026-05-08 11:21:57.302423
537	5	2026-02-02	6	1	f	2026-05-08 11:21:57.302423
538	5	2026-02-03	7	1	f	2026-05-08 11:21:57.302424
539	5	2026-02-04	ЧР1/8	1	f	2026-05-08 11:21:57.302582
540	5	2026-02-05	ЧР1/9	1	f	2026-05-08 11:21:57.302583
541	5	2026-02-06	10	1	f	2026-05-08 11:21:57.302584
542	5	2026-02-07	2 (Суб)	5	f	2026-05-08 11:21:57.302584
543	5	2026-02-08	В	\N	f	2026-05-08 11:21:57.302589
544	5	2026-02-09	11	1	f	2026-05-08 11:21:57.302589
545	5	2026-02-10	12	1	f	2026-05-08 11:21:57.30259
546	5	2026-02-11	13	1	f	2026-05-08 11:21:57.30259
547	5	2026-02-12	14	1	f	2026-05-08 11:21:57.302591
548	5	2026-02-13	15	1	f	2026-05-08 11:21:57.302591
549	5	2026-02-14	3 (Суб)	5	f	2026-05-08 11:21:57.302591
550	5	2026-02-15	В	\N	f	2026-05-08 11:21:57.302592
551	5	2026-02-16	16	1	f	2026-05-08 11:21:57.302592
552	5	2026-02-17	ЧР2/17	1	f	2026-05-08 11:21:57.302592
553	5	2026-02-18	ЧР2/18	1	f	2026-05-08 11:21:57.302593
554	5	2026-02-19	ЧС	1	f	2026-05-08 11:21:57.302593
555	5	2026-02-20	КИН	1	f	2026-05-08 11:21:57.302596
556	5	2026-02-21	4 (Суб)	5	f	2026-05-08 11:21:57.302596
557	5	2026-02-22	В	\N	f	2026-05-08 11:21:57.302596
558	5	2026-02-23	ИН	1	f	2026-05-08 11:21:57.302597
596	5	2026-04-02	ИН	2	f	2026-05-08 11:21:57.302616
559	5	2026-02-24	ИН	1	f	2026-05-08 11:21:57.302597
564	5	2026-03-01	В	\N	f	2026-05-08 11:21:57.302601
672	6	2025-09-05	5	1	f	2026-05-09 08:38:09.504197
673	6	2025-09-06	1 (Суб)	5	f	2026-05-09 08:38:09.504197
674	6	2025-09-07	В	\N	f	2026-05-09 08:38:09.504198
675	6	2025-09-08	6	1	f	2026-05-09 08:38:09.504198
676	6	2025-09-09	П	\N	t	2026-05-09 08:38:09.504198
677	6	2025-09-10	7	1	f	2026-05-09 08:38:09.504315
571	5	2026-03-08	В	\N	f	2026-05-08 11:21:57.302604
678	6	2025-09-11	ЧР1/8	1	f	2026-05-09 08:38:09.504315
679	6	2025-09-12	ЧР1/9	1	f	2026-05-09 08:38:09.504316
680	6	2025-09-13	2 (Суб)	5	f	2026-05-09 08:38:09.504316
681	6	2025-09-14	В	\N	f	2026-05-09 08:38:09.504316
682	6	2025-09-15	10	1	f	2026-05-09 08:38:09.504317
683	6	2025-09-16	11	1	f	2026-05-09 08:38:09.504317
578	5	2026-03-15	В	\N	f	2026-05-08 11:21:57.302607
684	6	2025-09-17	12	1	f	2026-05-09 08:38:09.504317
685	6	2025-09-18	13	1	f	2026-05-09 08:38:09.504318
686	6	2025-09-19	14	1	f	2026-05-09 08:38:09.504318
687	6	2025-09-20	3 (Суб)	5	f	2026-05-09 08:38:09.504318
688	6	2025-09-21	В	\N	f	2026-05-09 08:38:09.504319
584	5	2026-03-21	П	\N	t	2026-05-08 11:21:57.30261
585	5	2026-03-22	В	\N	f	2026-05-08 11:21:57.30261
586	5	2026-03-23	П	\N	t	2026-05-08 11:21:57.302611
587	5	2026-03-24	П	\N	t	2026-05-08 11:21:57.302612
588	5	2026-03-25	П	\N	t	2026-05-08 11:21:57.302612
689	6	2025-09-22	15	1	f	2026-05-09 08:38:09.504319
690	6	2025-09-23	16	1	f	2026-05-09 08:38:09.504319
691	6	2025-09-24	ЧР2/17	1	f	2026-05-09 08:38:09.504319
592	5	2026-03-29	В	\N	f	2026-05-08 11:21:57.302614
692	6	2025-09-25	ЧР2/18	1	f	2026-05-09 08:38:09.50432
693	6	2025-09-26	ЧС	1	f	2026-05-09 08:38:09.504321
694	6	2025-09-27	4 (Суб)	5	f	2026-05-09 08:38:09.504322
695	6	2025-09-28	В	\N	f	2026-05-09 08:38:09.504322
696	6	2025-09-29	КИН	1	f	2026-05-09 08:38:09.504322
599	5	2026-04-05	В	\N	f	2026-05-08 11:21:57.302617
697	6	2025-09-30	ИН	1	f	2026-05-09 08:38:09.504323
698	6	2025-10-01	ИН	1	f	2026-05-09 08:38:09.504324
699	6	2025-10-02	1	2	f	2026-05-09 08:38:09.504325
700	6	2025-10-03	2	2	f	2026-05-09 08:38:09.504325
701	6	2025-10-04	5 (Суб)	5	f	2026-05-09 08:38:09.504329
702	6	2025-10-05	В	\N	f	2026-05-09 08:38:09.504329
606	5	2026-04-12	В	\N	f	2026-05-08 11:21:57.30262
703	6	2025-10-06	П	\N	t	2026-05-09 08:38:09.504329
704	6	2025-10-07	3	2	f	2026-05-09 08:38:09.50433
705	6	2025-10-08	4	2	f	2026-05-09 08:38:09.50433
706	6	2025-10-09	5	2	f	2026-05-09 08:38:09.504331
707	6	2025-10-10	6	2	f	2026-05-09 08:38:09.504331
708	6	2025-10-11	6 (Суб)	5	f	2026-05-09 08:38:09.504331
613	5	2026-04-19	В	\N	f	2026-05-08 11:21:57.302623
709	6	2025-10-12	В	\N	f	2026-05-09 08:38:09.504332
710	6	2025-10-13	7	2	f	2026-05-09 08:38:09.504332
711	6	2025-10-14	ЧР1/8	2	f	2026-05-09 08:38:09.504332
712	6	2025-10-15	ЧР1/9	2	f	2026-05-09 08:38:09.504333
713	6	2025-10-16	10	2	f	2026-05-09 08:38:09.504333
714	6	2025-10-17	11	2	f	2026-05-09 08:38:09.504333
620	5	2026-04-26	В	\N	f	2026-05-08 11:21:57.302626
715	6	2025-10-18	7 (Суб)	5	f	2026-05-09 08:38:09.504334
716	6	2025-10-19	В	\N	f	2026-05-09 08:38:09.504334
717	6	2025-10-20	12	2	f	2026-05-09 08:38:09.504334
718	6	2025-10-21	13	2	f	2026-05-09 08:38:09.504335
719	6	2025-10-22	14	2	f	2026-05-09 08:38:09.504335
720	6	2025-10-23	15	2	f	2026-05-09 08:38:09.504335
627	5	2026-05-03	В	\N	f	2026-05-08 11:21:57.30263
721	6	2025-10-24	16	2	f	2026-05-09 08:38:09.504336
722	6	2025-10-25	ЧР1/8 (Суб)	5	f	2026-05-09 08:38:09.504336
723	6	2025-10-26	В	\N	f	2026-05-09 08:38:09.504336
724	6	2025-10-27	ЧР2/17	2	f	2026-05-09 08:38:09.504337
725	6	2025-10-28	ЧР2/18	2	f	2026-05-09 08:38:09.504337
726	6	2025-10-29	ЧС	2	f	2026-05-09 08:38:09.504338
634	5	2026-05-10	В	\N	f	2026-05-08 11:21:57.302632
727	6	2025-10-30	КИН	2	f	2026-05-09 08:38:09.504338
728	6	2025-10-31	ИН	2	f	2026-05-09 08:38:09.504338
729	6	2025-11-01	ЧР1/9 (Суб)	5	f	2026-05-09 08:38:09.504339
730	6	2025-11-02	В	\N	f	2026-05-09 08:38:09.504339
731	6	2025-11-03	ИН	2	f	2026-05-09 08:38:09.504339
732	6	2025-11-04	1	3	f	2026-05-09 08:38:09.50434
641	5	2026-05-17	В	\N	f	2026-05-08 11:21:57.302635
733	6	2025-11-05	2	3	f	2026-05-09 08:38:09.50434
734	6	2025-11-06	3	3	f	2026-05-09 08:38:09.50434
735	6	2025-11-07	4	3	f	2026-05-09 08:38:09.504341
736	6	2025-11-08	10 (Суб)	5	f	2026-05-09 08:38:09.504341
737	6	2025-11-09	В	\N	f	2026-05-09 08:38:09.504341
738	6	2025-11-10	5	3	f	2026-05-09 08:38:09.504342
648	5	2026-05-24	В	\N	f	2026-05-08 11:21:57.302641
739	6	2025-11-11	6	3	f	2026-05-09 08:38:09.504342
740	6	2025-11-12	7	3	f	2026-05-09 08:38:09.504342
741	6	2025-11-13	ЧР1/8	3	f	2026-05-09 08:38:09.504343
742	6	2025-11-14	ЧР1/9	3	f	2026-05-09 08:38:09.504343
743	6	2025-11-15	11 (Суб)	5	f	2026-05-09 08:38:09.504343
744	6	2025-11-16	В	\N	f	2026-05-09 08:38:09.504344
575	5	2026-03-12	11	2	f	2026-05-08 11:21:57.302606
655	5	2026-05-31	В	\N	f	2026-05-08 11:21:57.302644
576	5	2026-03-13	12	2	f	2026-05-08 11:21:57.302606
579	5	2026-03-16	13	2	f	2026-05-08 11:21:57.302608
580	5	2026-03-17	14	2	f	2026-05-08 11:21:57.302608
659	5	2026-06-04	ИН	4	f	2026-05-08 11:21:57.302646
581	5	2026-03-18	15	2	f	2026-05-08 11:21:57.302609
582	5	2026-03-19	16	2	f	2026-05-08 11:21:57.302609
662	5	2026-06-07	В	\N	f	2026-05-08 11:21:57.302648
589	5	2026-03-26	ЧР2/17	2	f	2026-05-08 11:21:57.302613
590	5	2026-03-27	ЧР2/18	2	f	2026-05-08 11:21:57.302613
593	5	2026-03-30	ЧС	2	f	2026-05-08 11:21:57.302614
666	5	2026-06-11	ИН	5	f	2026-05-08 11:21:57.302649
595	5	2026-04-01	ИН	2	f	2026-05-08 11:21:57.302615
598	5	2026-04-04	ЧР1/9 (Суб)	5	f	2026-05-08 11:21:57.302617
605	5	2026-04-11	10 (Суб)	5	f	2026-05-08 11:21:57.30262
594	5	2026-03-31	КИН	2	f	2026-05-08 11:21:57.302615
563	5	2026-02-28	5 (Суб)	5	f	2026-05-08 11:21:57.302601
570	5	2026-03-07	6 (Суб)	5	f	2026-05-08 11:21:57.302604
572	5	2026-03-09	П	\N	t	2026-05-08 11:21:57.302605
597	5	2026-04-03	1	3	f	2026-05-08 11:21:57.302616
600	5	2026-04-06	2	3	f	2026-05-08 11:21:57.302617
601	5	2026-04-07	3	3	f	2026-05-08 11:21:57.302618
602	5	2026-04-08	4	3	f	2026-05-08 11:21:57.302618
577	5	2026-03-14	7 (Суб)	5	f	2026-05-08 11:21:57.302607
603	5	2026-04-09	5	3	f	2026-05-08 11:21:57.302619
604	5	2026-04-10	6	3	f	2026-05-08 11:21:57.302619
607	5	2026-04-13	7	3	f	2026-05-08 11:21:57.302621
608	5	2026-04-14	ЧР1/8	3	f	2026-05-08 11:21:57.302621
583	5	2026-03-20	П	\N	t	2026-05-08 11:21:57.302609
609	5	2026-04-15	ЧР1/9	3	f	2026-05-08 11:21:57.302621
745	6	2025-11-17	10	3	f	2026-05-09 08:38:09.504344
591	5	2026-03-28	ЧР1/8 (Суб)	5	f	2026-05-08 11:21:57.302614
746	6	2025-11-18	11	3	f	2026-05-09 08:38:09.504344
747	6	2025-11-19	12	3	f	2026-05-09 08:38:09.504345
748	6	2025-11-20	13	3	f	2026-05-09 08:38:09.504345
749	6	2025-11-21	14	3	f	2026-05-09 08:38:09.504345
560	5	2026-02-25	1	2	f	2026-05-08 11:21:57.3026
561	5	2026-02-26	2	2	f	2026-05-08 11:21:57.3026
562	5	2026-02-27	3	2	f	2026-05-08 11:21:57.3026
565	5	2026-03-02	4	2	f	2026-05-08 11:21:57.302602
566	5	2026-03-03	5	2	f	2026-05-08 11:21:57.302602
567	5	2026-03-04	6	2	f	2026-05-08 11:21:57.302603
568	5	2026-03-05	7	2	f	2026-05-08 11:21:57.302603
569	5	2026-03-06	ЧР1/8	2	f	2026-05-08 11:21:57.302604
573	5	2026-03-10	ЧР1/9	2	f	2026-05-08 11:21:57.302605
574	5	2026-03-11	10	2	f	2026-05-08 11:21:57.302606
750	6	2025-11-22	12 (Суб)	5	f	2026-05-09 08:38:09.504346
751	6	2025-11-23	В	\N	f	2026-05-09 08:38:09.504346
752	6	2025-11-24	15	3	f	2026-05-09 08:38:09.504347
753	6	2025-11-25	16	3	f	2026-05-09 08:38:09.504347
754	6	2025-11-26	ЧР2/17	3	f	2026-05-09 08:38:09.504347
755	6	2025-11-27	ЧР2/18	3	f	2026-05-09 08:38:09.504348
756	6	2025-11-28	ЧС	3	f	2026-05-09 08:38:09.504348
757	6	2025-11-29	13 (Суб)	5	f	2026-05-09 08:38:09.504348
758	6	2025-11-30	В	\N	f	2026-05-09 08:38:09.504349
759	6	2025-12-01	КИН	3	f	2026-05-09 08:38:09.504349
760	6	2025-12-02	ИН	3	f	2026-05-09 08:38:09.504349
761	6	2025-12-03	ИН	3	f	2026-05-09 08:38:09.50435
762	6	2025-12-04	1	4	f	2026-05-09 08:38:09.50435
800	7	2025-09-01	1	1	f	2026-05-09 08:48:50.697511
801	7	2025-09-02	2	1	f	2026-05-09 08:48:50.697664
802	7	2025-09-03	3	1	f	2026-05-09 08:48:50.697665
803	7	2025-09-04	4	1	f	2026-05-09 08:48:50.697668
804	7	2025-09-05	5	1	f	2026-05-09 08:48:50.697669
805	7	2025-09-06	1 (Суб)	5	f	2026-05-09 08:48:50.697669
806	7	2025-09-07	В	\N	f	2026-05-09 08:48:50.697669
807	7	2025-09-08	6	1	f	2026-05-09 08:48:50.697669
808	7	2025-09-09	П	\N	t	2026-05-09 08:48:50.697669
809	7	2025-09-10	7	1	f	2026-05-09 08:48:50.69775
810	7	2025-09-11	ЧР1/8	1	f	2026-05-09 08:48:50.697751
652	5	2026-05-28	ЧР2/17	4	f	2026-05-08 11:21:57.302643
653	5	2026-05-29	ЧР2/18	4	f	2026-05-08 11:21:57.302643
656	5	2026-06-01	ЧС	4	f	2026-05-08 11:21:57.302645
657	5	2026-06-02	КИН	4	f	2026-05-08 11:21:57.302645
658	5	2026-06-03	ИН	4	f	2026-05-08 11:21:57.302646
660	5	2026-06-05	ЧР2/18	5	f	2026-05-08 11:21:57.302647
663	5	2026-06-08	ЧС	5	f	2026-05-08 11:21:57.302648
664	5	2026-06-09	КИН	5	f	2026-05-08 11:21:57.302648
665	5	2026-06-10	ИН	5	f	2026-05-08 11:21:57.302649
667	5	2026-06-12		\N	f	2026-05-08 11:21:57.30265
763	6	2025-12-05	2	4	f	2026-05-09 08:38:09.50435
764	6	2025-12-06	14 (Суб)	5	f	2026-05-09 08:38:09.504351
765	6	2025-12-07	В	\N	f	2026-05-09 08:38:09.504351
766	6	2025-12-08	3	4	f	2026-05-09 08:38:09.504351
767	6	2025-12-09	4	4	f	2026-05-09 08:38:09.504352
768	6	2025-12-10	5	4	f	2026-05-09 08:38:09.504352
769	6	2025-12-11	6	4	f	2026-05-09 08:38:09.504352
770	6	2025-12-12	7	4	f	2026-05-09 08:38:09.504353
771	6	2025-12-13	15 (Суб)	5	f	2026-05-09 08:38:09.504353
772	6	2025-12-14	В	\N	f	2026-05-09 08:38:09.504353
811	7	2025-09-12	ЧР1/9	1	f	2026-05-09 08:48:50.697751
812	7	2025-09-13	2 (Суб)	5	f	2026-05-09 08:48:50.697751
813	7	2025-09-14	В	\N	f	2026-05-09 08:48:50.697751
612	5	2026-04-18	11 (Суб)	5	f	2026-05-08 11:21:57.302623
814	7	2025-09-15	10	1	f	2026-05-09 08:48:50.697751
815	7	2025-09-16	11	1	f	2026-05-09 08:48:50.697752
816	7	2025-09-17	12	1	f	2026-05-09 08:48:50.697752
817	7	2025-09-18	13	1	f	2026-05-09 08:48:50.697752
818	7	2025-09-19	14	1	f	2026-05-09 08:48:50.697752
619	5	2026-04-25	12 (Суб)	5	f	2026-05-08 11:21:57.302626
819	7	2025-09-20	3 (Суб)	5	f	2026-05-09 08:48:50.697752
820	7	2025-09-21	В	\N	f	2026-05-09 08:48:50.697753
821	7	2025-09-22	15	1	f	2026-05-09 08:48:50.697753
610	5	2026-04-16	10	3	f	2026-05-08 11:21:57.302622
611	5	2026-04-17	11	3	f	2026-05-08 11:21:57.302622
626	5	2026-05-02	13 (Суб)	5	f	2026-05-08 11:21:57.302629
628	5	2026-05-04	ИН	3	f	2026-05-08 11:21:57.30263
614	5	2026-04-20	12	3	f	2026-05-08 11:21:57.302624
615	5	2026-04-21	13	3	f	2026-05-08 11:21:57.302624
616	5	2026-04-22	14	3	f	2026-05-08 11:21:57.302625
617	5	2026-04-23	15	3	f	2026-05-08 11:21:57.302625
633	5	2026-05-09	П	\N	t	2026-05-08 11:21:57.302632
618	5	2026-04-24	16	3	f	2026-05-08 11:21:57.302626
621	5	2026-04-27	ЧР2/17	3	f	2026-05-08 11:21:57.302627
622	5	2026-04-28	ЧР2/18	3	f	2026-05-08 11:21:57.302627
623	5	2026-04-29	ЧС	3	f	2026-05-08 11:21:57.302628
624	5	2026-04-30	КИН	3	f	2026-05-08 11:21:57.302628
640	5	2026-05-16	14 (Суб)	5	f	2026-05-08 11:21:57.302635
625	5	2026-05-01	ИН	3	f	2026-05-08 11:21:57.302629
629	5	2026-05-05	1	4	f	2026-05-08 11:21:57.30263
630	5	2026-05-06	2	4	f	2026-05-08 11:21:57.302631
631	5	2026-05-07	3	4	f	2026-05-08 11:21:57.302631
632	5	2026-05-08	4	4	f	2026-05-08 11:21:57.302632
647	5	2026-05-23	15 (Суб)	5	f	2026-05-08 11:21:57.30264
635	5	2026-05-11	5	4	f	2026-05-08 11:21:57.302633
636	5	2026-05-12	6	4	f	2026-05-08 11:21:57.302633
651	5	2026-05-27	П	\N	t	2026-05-08 11:21:57.302643
637	5	2026-05-13	7	4	f	2026-05-08 11:21:57.302634
638	5	2026-05-14	ЧР1/8	4	f	2026-05-08 11:21:57.302634
654	5	2026-05-30	16 (Суб)	5	f	2026-05-08 11:21:57.302644
639	5	2026-05-15	ЧР1/9	4	f	2026-05-08 11:21:57.302634
642	5	2026-05-18	10	4	f	2026-05-08 11:21:57.302636
643	5	2026-05-19	11	4	f	2026-05-08 11:21:57.302636
644	5	2026-05-20	12	4	f	2026-05-08 11:21:57.302637
661	5	2026-06-06	ЧР2/17 (Суб)	5	f	2026-05-08 11:21:57.302647
645	5	2026-05-21	13	4	f	2026-05-08 11:21:57.30264
646	5	2026-05-22	14	4	f	2026-05-08 11:21:57.30264
649	5	2026-05-25	15	4	f	2026-05-08 11:21:57.302641
773	6	2025-12-15	ЧР1/8	4	f	2026-05-09 08:38:09.504354
774	6	2025-12-16	ЧР1/9	4	f	2026-05-09 08:38:09.504354
775	6	2025-12-17	10	4	f	2026-05-09 08:38:09.504354
776	6	2025-12-18	11	4	f	2026-05-09 08:38:09.504355
777	6	2025-12-19	12	4	f	2026-05-09 08:38:09.504355
778	6	2025-12-20	16 (Суб)	5	f	2026-05-09 08:38:09.504355
779	6	2025-12-21	В	\N	f	2026-05-09 08:38:09.504356
780	6	2025-12-22	13	4	f	2026-05-09 08:38:09.504356
781	6	2025-12-23	14	4	f	2026-05-09 08:38:09.504356
782	6	2025-12-24	15	4	f	2026-05-09 08:38:09.504357
783	6	2025-12-25	16	4	f	2026-05-09 08:38:09.504357
784	6	2025-12-26	ЧР2/17	4	f	2026-05-09 08:38:09.504357
785	6	2025-12-27	ЧР2/17 (Суб)	5	f	2026-05-09 08:38:09.504358
786	6	2025-12-28	В	\N	f	2026-05-09 08:38:09.504358
787	6	2025-12-29	ЧР2/18	4	f	2026-05-09 08:38:09.504358
788	6	2025-12-30	ЧС	4	f	2026-05-09 08:38:09.504359
789	6	2025-12-31	КИН	4	f	2026-05-09 08:38:09.50436
822	7	2025-09-23	16	1	f	2026-05-09 08:48:50.697753
823	7	2025-09-24	ЧР2/17	1	f	2026-05-09 08:48:50.697753
824	7	2025-09-25	ЧР2/18	1	f	2026-05-09 08:48:50.697753
825	7	2025-09-26	ЧС	1	f	2026-05-09 08:48:50.697754
826	7	2025-09-27	4 (Суб)	5	f	2026-05-09 08:48:50.697754
827	7	2025-09-28	В	\N	f	2026-05-09 08:48:50.697755
828	7	2025-09-29	КИН	1	f	2026-05-09 08:48:50.697755
829	7	2025-09-30	ИН	1	f	2026-05-09 08:48:50.697755
830	7	2025-10-01	ИН	1	f	2026-05-09 08:48:50.697756
831	7	2025-10-02	1	2	f	2026-05-09 08:48:50.697756
832	7	2025-10-03	2	2	f	2026-05-09 08:48:50.697757
833	7	2025-10-04	5 (Суб)	5	f	2026-05-09 08:48:50.697757
834	7	2025-10-05	В	\N	f	2026-05-09 08:48:50.697757
835	7	2025-10-06	П	\N	t	2026-05-09 08:48:50.697757
836	7	2025-10-07	3	2	f	2026-05-09 08:48:50.697757
837	7	2025-10-08	4	2	f	2026-05-09 08:48:50.697758
790	6	2026-01-01	П	\N	t	2026-05-09 08:38:09.504361
650	5	2026-05-26	16	4	f	2026-05-08 11:21:57.302642
791	6	2026-01-02	ИН	4	f	2026-05-09 08:38:09.504361
792	6	2026-01-03	ЧР2/18 (Суб)	5	f	2026-05-09 08:38:09.504361
793	6	2026-01-04	В	\N	f	2026-05-09 08:38:09.504363
794	6	2026-01-05	ИН	4	f	2026-05-09 08:38:09.504364
795	6	2026-01-06	КИН	5	f	2026-05-09 08:38:09.504364
796	6	2026-01-07	ИН	5	f	2026-05-09 08:38:09.504365
797	6	2026-01-08	ИН	5	f	2026-05-09 08:38:09.504365
798	6	2026-01-09		\N	f	2026-05-09 08:38:09.504365
799	6	2026-01-10	ЧС (Суб)	5	f	2026-05-09 08:38:09.504365
838	7	2025-10-09	5	2	f	2026-05-09 08:48:50.697758
839	7	2025-10-10	6	2	f	2026-05-09 08:48:50.697758
840	7	2025-10-11	6 (Суб)	5	f	2026-05-09 08:48:50.697758
841	7	2025-10-12	В	\N	f	2026-05-09 08:48:50.697758
842	7	2025-10-13	7	2	f	2026-05-09 08:48:50.697759
843	7	2025-10-14	ЧР1/8	2	f	2026-05-09 08:48:50.697759
844	7	2025-10-15	ЧР1/9	2	f	2026-05-09 08:48:50.697759
845	7	2025-10-16	10	2	f	2026-05-09 08:48:50.697759
846	7	2025-10-17	11	2	f	2026-05-09 08:48:50.697759
847	7	2025-10-18	7 (Суб)	5	f	2026-05-09 08:48:50.697759
848	7	2025-10-19	В	\N	f	2026-05-09 08:48:50.69776
849	7	2025-10-20	12	2	f	2026-05-09 08:48:50.69776
850	7	2025-10-21	13	2	f	2026-05-09 08:48:50.69776
851	7	2025-10-22	14	2	f	2026-05-09 08:48:50.69776
852	7	2025-10-23	15	2	f	2026-05-09 08:48:50.69776
853	7	2025-10-24	16	2	f	2026-05-09 08:48:50.697761
854	7	2025-10-25	ЧР1/8 (Суб)	5	f	2026-05-09 08:48:50.697761
855	7	2025-10-26	В	\N	f	2026-05-09 08:48:50.697761
856	7	2025-10-27	ЧР2/17	2	f	2026-05-09 08:48:50.697761
857	7	2025-10-28	ЧР2/18	2	f	2026-05-09 08:48:50.697762
858	7	2025-10-29	ЧС	2	f	2026-05-09 08:48:50.697762
859	7	2025-10-30	КИН	2	f	2026-05-09 08:48:50.697762
860	7	2025-10-31	ИН	2	f	2026-05-09 08:48:50.697762
861	7	2025-11-01	ЧР1/9 (Суб)	5	f	2026-05-09 08:48:50.697762
862	7	2025-11-02	В	\N	f	2026-05-09 08:48:50.697763
863	7	2025-11-03	ИН	2	f	2026-05-09 08:48:50.697763
864	7	2025-11-04	1	3	f	2026-05-09 08:48:50.697763
865	7	2025-11-05	2	3	f	2026-05-09 08:48:50.697763
866	7	2025-11-06	3	3	f	2026-05-09 08:48:50.697763
867	7	2025-11-07	4	3	f	2026-05-09 08:48:50.697764
868	7	2025-11-08	10 (Суб)	5	f	2026-05-09 08:48:50.697764
869	7	2025-11-09	В	\N	f	2026-05-09 08:48:50.697764
870	7	2025-11-10	5	3	f	2026-05-09 08:48:50.697764
871	7	2025-11-11	6	3	f	2026-05-09 08:48:50.697764
872	7	2025-11-12	7	3	f	2026-05-09 08:48:50.697765
873	7	2025-11-13	ЧР1/8	3	f	2026-05-09 08:48:50.697765
874	7	2025-11-14	ЧР1/9	3	f	2026-05-09 08:48:50.697765
875	7	2025-11-15	11 (Суб)	5	f	2026-05-09 08:48:50.697765
876	7	2025-11-16	В	\N	f	2026-05-09 08:48:50.697765
877	7	2025-11-17	10	3	f	2026-05-09 08:48:50.697766
878	7	2025-11-18	11	3	f	2026-05-09 08:48:50.697766
879	7	2025-11-19	12	3	f	2026-05-09 08:48:50.697766
880	7	2025-11-20	13	3	f	2026-05-09 08:48:50.697766
881	7	2025-11-21	14	3	f	2026-05-09 08:48:50.697766
882	7	2025-11-22	12 (Суб)	5	f	2026-05-09 08:48:50.697766
883	7	2025-11-23	В	\N	f	2026-05-09 08:48:50.697767
884	7	2025-11-24	15	3	f	2026-05-09 08:48:50.697767
885	7	2025-11-25	16	3	f	2026-05-09 08:48:50.697767
886	7	2025-11-26	ЧР2/17	3	f	2026-05-09 08:48:50.697767
887	7	2025-11-27	ЧР2/18	3	f	2026-05-09 08:48:50.697767
888	7	2025-11-28	ЧС	3	f	2026-05-09 08:48:50.697769
889	7	2025-11-29	13 (Суб)	5	f	2026-05-09 08:48:50.697769
890	7	2025-11-30	В	\N	f	2026-05-09 08:48:50.69777
891	7	2025-12-01	КИН	3	f	2026-05-09 08:48:50.69777
892	7	2025-12-02	ИН	3	f	2026-05-09 08:48:50.69777
893	7	2025-12-03	ИН	3	f	2026-05-09 08:48:50.69777
894	7	2025-12-04	1	4	f	2026-05-09 08:48:50.69777
895	7	2025-12-05	2	4	f	2026-05-09 08:48:50.69777
896	7	2025-12-06	14 (Суб)	5	f	2026-05-09 08:48:50.697771
897	7	2025-12-07	В	\N	f	2026-05-09 08:48:50.697771
898	7	2025-12-08	3	4	f	2026-05-09 08:48:50.697771
899	7	2025-12-09	4	4	f	2026-05-09 08:48:50.697771
900	7	2025-12-10	5	4	f	2026-05-09 08:48:50.697771
901	7	2025-12-11	6	4	f	2026-05-09 08:48:50.697772
902	7	2025-12-12	7	4	f	2026-05-09 08:48:50.697772
903	7	2025-12-13	15 (Суб)	5	f	2026-05-09 08:48:50.697772
904	7	2025-12-14	В	\N	f	2026-05-09 08:48:50.697772
905	7	2025-12-15	ЧР1/8	4	f	2026-05-09 08:48:50.697772
906	7	2025-12-16	ЧР1/9	4	f	2026-05-09 08:48:50.697773
907	7	2025-12-17	10	4	f	2026-05-09 08:48:50.697773
908	7	2025-12-18	11	4	f	2026-05-09 08:48:50.697773
909	7	2025-12-19	12	4	f	2026-05-09 08:48:50.697773
910	7	2025-12-20	16 (Суб)	5	f	2026-05-09 08:48:50.697773
911	7	2025-12-21	В	\N	f	2026-05-09 08:48:50.697774
912	7	2025-12-22	13	4	f	2026-05-09 08:48:50.697774
913	7	2025-12-23	14	4	f	2026-05-09 08:48:50.697774
914	7	2025-12-24	15	4	f	2026-05-09 08:48:50.697774
915	7	2025-12-25	16	4	f	2026-05-09 08:48:50.697774
916	7	2025-12-26	ЧР2/17	4	f	2026-05-09 08:48:50.697774
917	7	2025-12-27	ЧР2/17 (Суб)	5	f	2026-05-09 08:48:50.697775
918	7	2025-12-28	В	\N	f	2026-05-09 08:48:50.697775
919	7	2025-12-29	ЧР2/18	4	f	2026-05-09 08:48:50.697775
920	7	2025-12-30	ЧС	4	f	2026-05-09 08:48:50.697775
921	7	2025-12-31	КИН	4	f	2026-05-09 08:48:50.697776
922	7	2026-01-01	П	\N	t	2026-05-09 08:48:50.697776
923	7	2026-01-02	ИН	4	f	2026-05-09 08:48:50.697776
924	7	2026-01-03	ЧР2/18 (Суб)	5	f	2026-05-09 08:48:50.697777
925	7	2026-01-04	В	\N	f	2026-05-09 08:48:50.697777
926	7	2026-01-05	ИН	4	f	2026-05-09 08:48:50.697777
927	7	2026-01-06	ЧС	5	f	2026-05-09 08:48:50.697777
928	7	2026-01-07	КИН	5	f	2026-05-09 08:48:50.697777
929	7	2026-01-08	ИН	5	f	2026-05-09 08:48:50.697778
930	7	2026-01-09	ИН	5	f	2026-05-09 08:48:50.697778
931	7	2026-01-10		\N	f	2026-05-09 08:48:50.697778
932	8	2026-01-26	1	1	f	2026-05-09 08:51:05.973202
933	8	2026-01-27	2	1	f	2026-05-09 08:51:05.973205
934	8	2026-01-28	3	1	f	2026-05-09 08:51:05.973205
935	8	2026-01-29	4	1	f	2026-05-09 08:51:05.973206
936	8	2026-01-30	5	1	f	2026-05-09 08:51:05.973206
937	8	2026-01-31	1 (Суб)	5	f	2026-05-09 08:51:05.973206
938	8	2026-02-01	В	\N	f	2026-05-09 08:51:05.973207
939	8	2026-02-02	6	1	f	2026-05-09 08:51:05.973207
940	8	2026-02-03	7	1	f	2026-05-09 08:51:05.973208
941	8	2026-02-04	ЧР1/8	1	f	2026-05-09 08:51:05.973222
942	8	2026-02-05	ЧР1/9	1	f	2026-05-09 08:51:05.973222
943	8	2026-02-06	10	1	f	2026-05-09 08:51:05.973223
944	8	2026-02-07	2 (Суб)	5	f	2026-05-09 08:51:05.973223
945	8	2026-02-08	В	\N	f	2026-05-09 08:51:05.973223
946	8	2026-02-09	11	1	f	2026-05-09 08:51:05.973224
947	8	2026-02-10	12	1	f	2026-05-09 08:51:05.973224
948	8	2026-02-11	13	1	f	2026-05-09 08:51:05.973224
949	8	2026-02-12	14	1	f	2026-05-09 08:51:05.973225
950	8	2026-02-13	15	1	f	2026-05-09 08:51:05.973225
951	8	2026-02-14	3 (Суб)	5	f	2026-05-09 08:51:05.973225
952	8	2026-02-15	В	\N	f	2026-05-09 08:51:05.973225
953	8	2026-02-16	16	1	f	2026-05-09 08:51:05.973226
954	8	2026-02-17	ЧР2/17	1	f	2026-05-09 08:51:05.973226
955	8	2026-02-18	ЧР2/18	1	f	2026-05-09 08:51:05.973226
956	8	2026-02-19	ЧС	1	f	2026-05-09 08:51:05.973227
957	8	2026-02-20	КИН	1	f	2026-05-09 08:51:05.973227
958	8	2026-02-21	4 (Суб)	5	f	2026-05-09 08:51:05.973228
959	8	2026-02-22	В	\N	f	2026-05-09 08:51:05.97323
960	8	2026-02-23	ИН	1	f	2026-05-09 08:51:05.97323
961	8	2026-02-24	ИН	1	f	2026-05-09 08:51:05.973233
962	8	2026-02-25	1	2	f	2026-05-09 08:51:05.973236
963	8	2026-02-26	2	2	f	2026-05-09 08:51:05.973237
964	8	2026-02-27	3	2	f	2026-05-09 08:51:05.973237
965	8	2026-02-28	5 (Суб)	5	f	2026-05-09 08:51:05.973237
966	8	2026-03-01	В	\N	f	2026-05-09 08:51:05.973238
967	8	2026-03-02	4	2	f	2026-05-09 08:51:05.973238
968	8	2026-03-03	5	2	f	2026-05-09 08:51:05.97325
969	8	2026-03-04	6	2	f	2026-05-09 08:51:05.97325
970	8	2026-03-05	7	2	f	2026-05-09 08:51:05.973251
971	8	2026-03-06	ЧР1/8	2	f	2026-05-09 08:51:05.973251
972	8	2026-03-07	6 (Суб)	5	f	2026-05-09 08:51:05.973251
973	8	2026-03-08	В	\N	f	2026-05-09 08:51:05.973252
974	8	2026-03-09	П	\N	t	2026-05-09 08:51:05.973252
975	8	2026-03-10	ЧР1/9	2	f	2026-05-09 08:51:05.973252
976	8	2026-03-11	10	2	f	2026-05-09 08:51:05.973253
977	8	2026-03-12	11	2	f	2026-05-09 08:51:05.973253
978	8	2026-03-13	12	2	f	2026-05-09 08:51:05.973253
979	8	2026-03-14	7 (Суб)	5	f	2026-05-09 08:51:05.973254
980	8	2026-03-15	В	\N	f	2026-05-09 08:51:05.973254
981	8	2026-03-16	13	2	f	2026-05-09 08:51:05.973254
982	8	2026-03-17	14	2	f	2026-05-09 08:51:05.973254
983	8	2026-03-18	15	2	f	2026-05-09 08:51:05.973255
984	8	2026-03-19	16	2	f	2026-05-09 08:51:05.973255
985	8	2026-03-20	П	\N	t	2026-05-09 08:51:05.973255
986	8	2026-03-21	П	\N	t	2026-05-09 08:51:05.973256
987	8	2026-03-22	В	\N	f	2026-05-09 08:51:05.973256
988	8	2026-03-23	П	\N	t	2026-05-09 08:51:05.973256
989	8	2026-03-24	П	\N	t	2026-05-09 08:51:05.973257
990	8	2026-03-25	П	\N	t	2026-05-09 08:51:05.973257
991	8	2026-03-26	ЧР2/17	2	f	2026-05-09 08:51:05.973257
992	8	2026-03-27	ЧР2/18	2	f	2026-05-09 08:51:05.973258
993	8	2026-03-28	ЧР1/8 (Суб)	5	f	2026-05-09 08:51:05.973258
994	8	2026-03-29	В	\N	f	2026-05-09 08:51:05.973258
995	8	2026-03-30	ЧС	2	f	2026-05-09 08:51:05.973259
996	8	2026-03-31	КИН	2	f	2026-05-09 08:51:05.973259
997	8	2026-04-01	ИН	2	f	2026-05-09 08:51:05.973259
998	8	2026-04-02	ИН	2	f	2026-05-09 08:51:05.973259
999	8	2026-04-03	1	3	f	2026-05-09 08:51:05.97326
1000	8	2026-04-04	ЧР1/9 (Суб)	5	f	2026-05-09 08:51:05.97326
1001	8	2026-04-05	В	\N	f	2026-05-09 08:51:05.97326
1002	8	2026-04-06	2	3	f	2026-05-09 08:51:05.973261
1003	8	2026-04-07	3	3	f	2026-05-09 08:51:05.973261
1004	8	2026-04-08	4	3	f	2026-05-09 08:51:05.973261
1005	8	2026-04-09	5	3	f	2026-05-09 08:51:05.973262
1006	8	2026-04-10	6	3	f	2026-05-09 08:51:05.973262
1007	8	2026-04-11	10 (Суб)	5	f	2026-05-09 08:51:05.973262
1008	8	2026-04-12	В	\N	f	2026-05-09 08:51:05.973262
1009	8	2026-04-13	7	3	f	2026-05-09 08:51:05.973263
1010	8	2026-04-14	ЧР1/8	3	f	2026-05-09 08:51:05.973263
1011	8	2026-04-15	ЧР1/9	3	f	2026-05-09 08:51:05.973263
1012	8	2026-04-16	10	3	f	2026-05-09 08:51:05.973264
1013	8	2026-04-17	11	3	f	2026-05-09 08:51:05.973264
1014	8	2026-04-18	11 (Суб)	5	f	2026-05-09 08:51:05.973264
1015	8	2026-04-19	В	\N	f	2026-05-09 08:51:05.973264
1016	8	2026-04-20	12	3	f	2026-05-09 08:51:05.973265
1017	8	2026-04-21	13	3	f	2026-05-09 08:51:05.973265
1018	8	2026-04-22	14	3	f	2026-05-09 08:51:05.973265
1019	8	2026-04-23	15	3	f	2026-05-09 08:51:05.973266
1020	8	2026-04-24	16	3	f	2026-05-09 08:51:05.973266
1021	8	2026-04-25	12 (Суб)	5	f	2026-05-09 08:51:05.973266
1022	8	2026-04-26	В	\N	f	2026-05-09 08:51:05.973266
1023	8	2026-04-27	ЧР2/17	3	f	2026-05-09 08:51:05.973267
1024	8	2026-04-28	ЧР2/18	3	f	2026-05-09 08:51:05.973267
1025	8	2026-04-29	ЧС	3	f	2026-05-09 08:51:05.973267
1026	8	2026-04-30	КИН	3	f	2026-05-09 08:51:05.973268
1027	8	2026-05-01	ИН	3	f	2026-05-09 08:51:05.973268
1028	8	2026-05-02	13 (Суб)	5	f	2026-05-09 08:51:05.973268
1029	8	2026-05-03	В	\N	f	2026-05-09 08:51:05.973269
1030	8	2026-05-04	ИН	3	f	2026-05-09 08:51:05.973269
1031	8	2026-05-05	1	4	f	2026-05-09 08:51:05.973269
1032	8	2026-05-06	2	4	f	2026-05-09 08:51:05.973269
1033	8	2026-05-07	3	4	f	2026-05-09 08:51:05.97327
1034	8	2026-05-08	4	4	f	2026-05-09 08:51:05.97327
1035	8	2026-05-09	П	\N	t	2026-05-09 08:51:05.97327
1036	8	2026-05-10	В	\N	f	2026-05-09 08:51:05.97327
1037	8	2026-05-11	5	4	f	2026-05-09 08:51:05.973271
1038	8	2026-05-12	6	4	f	2026-05-09 08:51:05.973271
1039	8	2026-05-13	7	4	f	2026-05-09 08:51:05.973271
1040	8	2026-05-14	ЧР1/8	4	f	2026-05-09 08:51:05.973272
1041	8	2026-05-15	ЧР1/9	4	f	2026-05-09 08:51:05.973272
1042	8	2026-05-16	14 (Суб)	5	f	2026-05-09 08:51:05.973272
1043	8	2026-05-17	В	\N	f	2026-05-09 08:51:05.973273
1044	8	2026-05-18	10	4	f	2026-05-09 08:51:05.973273
1045	8	2026-05-19	11	4	f	2026-05-09 08:51:05.973273
1046	8	2026-05-20	12	4	f	2026-05-09 08:51:05.973273
1047	8	2026-05-21	13	4	f	2026-05-09 08:51:05.973274
1048	8	2026-05-22	14	4	f	2026-05-09 08:51:05.973274
1049	8	2026-05-23	15 (Суб)	5	f	2026-05-09 08:51:05.973274
1050	8	2026-05-24	В	\N	f	2026-05-09 08:51:05.973275
1051	8	2026-05-25	15	4	f	2026-05-09 08:51:05.973275
1052	8	2026-05-26	16	4	f	2026-05-09 08:51:05.973275
1053	8	2026-05-27	П	\N	t	2026-05-09 08:51:05.973276
1054	8	2026-05-28	ЧР2/17	4	f	2026-05-09 08:51:05.973276
1055	8	2026-05-29	ЧР2/18	4	f	2026-05-09 08:51:05.973276
1056	8	2026-05-30	16 (Суб)	5	f	2026-05-09 08:51:05.973287
1057	8	2026-05-31	В	\N	f	2026-05-09 08:51:05.973288
1058	8	2026-06-01	ЧС	4	f	2026-05-09 08:51:05.973288
1059	8	2026-06-02	КИН	4	f	2026-05-09 08:51:05.973288
1060	8	2026-06-03	ИН	4	f	2026-05-09 08:51:05.973289
1061	8	2026-06-04	ИН	4	f	2026-05-09 08:51:05.973289
1062	8	2026-06-05	ЧР2/17	5	f	2026-05-09 08:51:05.973289
1063	8	2026-06-06	ЧР2/18	5	f	2026-05-09 08:51:05.97329
1064	8	2026-06-07	В	\N	f	2026-05-09 08:51:05.97329
1065	8	2026-06-08	ЧС	5	f	2026-05-09 08:51:05.97329
1066	8	2026-06-09	КИН	5	f	2026-05-09 08:51:05.97329
1067	8	2026-06-10	ИН	5	f	2026-05-09 08:51:05.973291
1068	8	2026-06-11	ИН	5	f	2026-05-09 08:51:05.973291
\.


--
-- TOC entry 5251 (class 0 OID 33454)
-- Dependencies: 248
-- Data for Name: semesters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.semesters (id, start_date, end_date, is_active, created_at) FROM stdin;
1	2026-01-26	2026-06-11	f	2026-05-08 10:03:32.189015
2	2026-01-26	2026-06-11	f	2026-05-08 10:08:42.381735
3	2025-09-10	2026-01-10	f	2026-05-08 10:29:38.732911
4	2025-09-01	2026-01-10	f	2026-05-08 10:30:36.689748
5	2026-01-26	2026-06-12	f	2026-05-08 11:21:56.746818
6	2025-09-01	2026-01-10	f	2026-05-09 08:38:09.148556
7	2025-09-01	2026-01-10	f	2026-05-09 08:48:50.376641
8	2026-01-26	2026-06-11	t	2026-05-09 08:51:05.956026
\.


--
-- TOC entry 5229 (class 0 OID 33169)
-- Dependencies: 226
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students (id, user_id) FROM stdin;
1	1
2	10
3	11
4	12
5	13
6	14
7	15
8	16
9	17
10	18
11	19
\.


--
-- TOC entry 5231 (class 0 OID 33185)
-- Dependencies: 228
-- Data for Name: teachers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teachers (id, user_id, status) FROM stdin;
1	2	active
2	5	active
3	6	active
4	7	active
5	8	active
6	9	active
\.


--
-- TOC entry 5255 (class 0 OID 33485)
-- Dependencies: 252
-- Data for Name: timetables; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.timetables (id, semester_id, subject_name, start_time, group_name, teacher_name, building, room_number, shift, cycle_number, day_slots) FROM stdin;
1229	8	Пул, қарз, бонкҳо	08:00:00	1_25.01.03ра	Оқилҷонова Ш.Ю.	ФТР	Ф203	1	2	111111111111111111
1230	8	Технологияи информатсионӣ	12:10:00	1_25.01.04ра	Исмоилова С.К.	ФЭ	Э108	2	2	111111111111111111
1231	8	Математика дар иқтисодиёт	08:00:00	1_25.01.04та	Раҳматуллоева М.М.	ФЭ	Э308	1	2	111111111111111111
1232	8	Технологияи информатсионӣ	11:00:00	1_25.01.04тб	Одилов З.Р.	ФТР	И104	1	2	111111111111111111
1233	8	Манбаи додаҳо	12:10:00	1_26.03.01ра	Фозилова М.М.	ФТР	И103	2	2	111111111111111111
1234	8	Диншиносии илмӣ	08:00:00	1_26.03.01та	Ҳотамова М.Ғ.	ФЭ	Э404	1	2	101010101010101010
1235	8	Таҷрибаомӯзии таълимӣ	08:00:00	1_26.03.01та	Шерматова Ш.И.	ФТР	И206	1	2	010101000101010100
1236	8	Математика барои муҳандисон	08:00:00	1_40.01.01ра	Азимов Н.С.	ФЭ	Э316	1	2	111111111111111111
1237	8	Асосҳои алгоритмсозӣ ва барномарезӣ	08:00:00	1_40.01.01рб	Фозилова М.М.	ФТР	И305	1	2	111111111111111111
1238	8	Забони тоҷикӣ аз рӯи ихтисос	08:00:00	1_40.01.01та	Ҳалимова М.Ҷ.	ФТР	И201	1	2	010101010101010101
1239	8	Фарҳангшиносӣ	08:00:00	1_40.01.01та	Раҳмонов З.А.	ФТР	И201	1	2	101010101010101010
1240	8	Асосҳои алгоритмсозӣ ва барномарезӣ	12:10:00	1_40.01.02ра	Усмонов А.А.	ФТР	И101	2	2	111111111111111111
1241	8	Забони русӣ аз рӯи ихтисос	08:00:00	1_40.01.02та	Солиев З.Т.	ФТР	И206	1	2	101010101010101010
1242	8	Забони хориҷӣ аз рӯи ихтисос	08:00:00	1_40.01.02та	Аминҷонова Р.Ҳ.	ФЭ	Э317	1	2	010101010101010101
1243	8	Забони русӣ аз рӯи ихтисос	08:00:00	1_40.03.01ра	Машарипова М.Э.	ФЭ	Э313	1	2	010101010101010101
1244	8	Забони хориҷӣ аз рӯи ихтисос	12:10:00	1_40.03.01ра	Исломова П.Н.	ФТР	И201	2	2	101010101010101010
1245	8	Забони тоҷикӣ аз рӯи ихтисос	08:00:00	1_45.01.01ра	Ҳалимова М.Ҷ.	ФТР	И105	1	2	101010101010101010
1246	8	Фарҳангшиносӣ	08:00:00	1_45.01.01ра	Раҳмонов З.А.	ФТР	И105	1	2	010101010101010101
1247	8	Андоз ва андозбандӣ	09:00:00	2_25.01.04ра	Ҳаитова Н.Н.	ФТР	Ф104	1	2	111111111111111111
1248	8	Молияи давлатӣ	08:00:00	2_25.01.04та	Раҳмонов Ф.Х.	ФТР	Ф106	1	2	001001010001010001
1249	8	Фалсафа	12:00:00	2_25.01.04та	Ҳотамова М.Ғ.	ФЭ	Э404	2	2	110110101110101110
1250	8	Эконометрика	08:00:00	2_26.03.01та	Ахмедова М.М.	ФТР	Ф108	1	2	111111111111111111
1251	8	Асосҳои бехатарии фаъолияти ҳаёт	08:00:00	2_40.01.01ра	Ҳофизов Ҳ.Р.	ФСН	Д302	1	2	010000010010001001
1252	8	Мудофиаи шаҳрвандӣ	08:00:00	2_40.01.01ра	Ҳофизов Ҳ.Р.	ФСН	Д302	1	2	000100100000010101
1253	8	Ҳуқуқ аз рӯи ихтисос	08:00:00	2_40.01.01ра	Норов И.С.	ФЭ	Э101	1	2	101011001101100010
1254	8	Асосҳои бехатарии фаъолияти ҳаёт	08:00:00	2_40.01.01рб	Ҳофизов Ҳ.Р.	ФСН	Д302	1	2	010000010010001001
1255	8	Мудофиаи шаҳрвандӣ	08:00:00	2_40.01.01рб	Ҳофизов Ҳ.Р.	ФСН	Д302	1	2	000100100000010101
1256	8	Ҳуқуқ аз рӯи ихтисос	08:00:00	2_40.01.01рб	Норов И.С.	ФЭ	Э101	1	2	101011001101100010
1257	8	Асосҳои бехатарии фаъолияти ҳаёт	08:00:00	2_40.01.01та	Ҳофизов Ҳ.Р.	ФСН	Д302	1	2	100001001001000010
1258	8	Мудофиаи шаҳрвандӣ	08:00:00	2_40.01.01та	Ҳофизов Ҳ.Р.	ФСН	Д302	1	2	001010000100100010
1259	8	Ҳуқуқ аз рӯи ихтисос	08:00:00	2_40.01.01та	Норов И.С.	ФЭ	Э101	1	2	010100110010011101
1260	8	Макроиқтисодиёт	08:00:00	2_40.01.02ра	Набиева Х.Н.	ФЭ	Э416	1	2	111111111111111111
1261	8	Баҳисобгирии муҳосибӣ ва аудит	12:10:00	2_40.01.02та	Тоҷибоева М.Н.	ФТР	Ф102	2	2	111111111111111111
1262	8	Асосҳои бехатарии фаъолияти ҳаёт	08:00:00	2_40.03.01ра	Ҳофизов Ҳ.Р.	ФСН	Д302	1	2	010000010010001001
1263	8	Мудофиаи шаҳрвандӣ	08:00:00	2_40.03.01ра	Ҳофизов Ҳ.Р.	ФСН	Д302	1	2	000100100000010101
1264	8	Ҳуқуқ аз рӯи ихтисос	08:00:00	2_40.03.01ра	Норов И.С.	ФЭ	Э101	1	2	101011001101100010
1265	8	Фаъолияти бонкӣ	08:00:00	3_25.01.04ра	Комилова М.А.	ФТР	Ф102	1	2	111111111111111111
1266	8	Фаъолияти бонкӣ	08:00:00	3_25.01.04та	Сатторов Ш.А.	ФТР	Ф105	1	2	111111111111111111
1267	8	Таҷрибаомӯзии истеҳсолӣ	13:00:00	3_26.03.01ра	Қаюмова Д.Д.	ФТР	И102	2	2	100100001001001001
1268	8	Таҷрибаомӯзии истеҳсолӣ	08:00:00	3_40.01.01ра	Худойбердиев Х.А.	ФЭ	Э106	1	2	100010001010010001
1269	8	Сиёсатшиносӣ	12:00:00	3_40.01.01та	Норов И.С.	ФЭ	Э101	2	2	010101010101010101
1270	8	Технологияҳо ва забонҳои Internet барномасозӣ	08:00:00	3_40.01.01та	ВакКБНИ	ФТР	И205	1	2	101010101010101010
1271	8	Таҷрибаомӯзии истеҳсолӣ	13:00:00	3_40.01.02ра	Қаюмова Д.Д.	ФТР	И102	2	2	010010001010000101
1272	8	Тиҷорати электронӣ	08:00:00	3_40.01.02та	Рашидова Ф.М.	ФТР	И207	1	2	111111111111111111
1273	8	Практикуми тахассусӣ	08:00:00	4_25.01.04ра	Исоев Д.Т.	ФТР	Ф103	1	2	111111111111111111
1274	8	Менеҷмент ва маркетинги рақамӣ	08:00:00	4_26.03.01ра	Усмонова М.Р.	ФТР	И203	1	2	111111111111111111
1275	8	Барномасозӣ барои таҷҳизоти мобилӣ	08:00:00	4_40.01.01ра	Етмишбоева Ш.А.	ФЭ	Э107	1	2	111111111111111111
1276	8	Менеҷмент ва маркетинг дар соҳаи технологияи иттилоотӣ	08:00:00	4_40.01.01та	Ҷӯраева З.А.	ФТР	И306	1	2	111111111111111111
1277	8	Менеҷмент ва маркетинги рақамӣ	12:10:00	4_40.01.02ра	Рашидова Ф.М.	ФТР	И205	2	2	111111111111111111
1278	8	Тахлили зеҳнии додаҳо	08:00:00	4_40.03.01ра	ВакКИР	ZPL.AI		1	2	111111111111111111
1279	8	Маркетинги байналхалқӣ	08:00:00	2_25.01.03ра	Бакаев М.Х.	ФТР	Ф101	1	2	111111111111111111
1280	8	Идоракунии додаҳо	08:00:00	2_26.03.01ра	Қаюмова Д.Д.	ФТР	И103	1	2	111111111111111111
1281	8	Математикаи дискретӣ	08:00:00	2_45.01.01ра	Гуломнабиев С.Г.	ФТР	И304	1	2	111111111111111111
1282	8	Бизнес зеҳният бо барномаи SPSS	08:00:00	3_40.03.01ра	Усмонов А.А.	ФТР	И101	1	2	111111111111111111
882	8	Технологияи информатсионӣ	12:10:00	1_25.01.03ра	Исмоилова С.К.	ФИЭ	Э108	2	1	111111111111111111
883	8	Молия, муомилоти пулӣ, қарз	08:00:00	1_25.01.04ра	Комилова М.А.	ФМИ	Ф102	1	1	111111111111111111
884	8	Технологияи информатсионӣ	11:00:00	1_25.01.04та	Одилов З.Р.	ФМИ	И104	1	1	111111111111111111
885	8	Забони русӣ аз рӯи ихтисос	12:10:00	1_25.01.04тб	Ҳамидова Н.Ш.	ФМИ	Ф203	2	1	101010101010101010
886	8	Забони хориҷӣ аз рӯи ихтисос	12:10:00	1_25.01.04тб	Шарипова М.А.	ФМИ	Ф203	2	1	010101010101010101
887	8	Диншиносии илмӣ	12:00:00	1_26.03.01ра	Темирхоҷаев А.У.	ФИЭ	Э101	2	1	010101010100011101
888	8	Таҷрибаомӯзии таълимӣ	12:10:00	1_26.03.01ра	Шерматова Ш.И.	ФМИ	И305	2	1	101010100011100000
889	8	Манбаи додаҳо	12:10:00	1_26.03.01та	Қаюмова Д.Д.	ФМИ	И103	2	1	111111111111111111
890	8	Забони русӣ аз рӯи ихтисос	08:00:00	1_40.01.01ра	Солиев З.Т.	ФМИ	И205	1	1	010101010101010101
891	8	Забони хориҷӣ аз рӯи ихтисос	08:00:00	1_40.01.01ра	Исломова П.Н.	ФМИ	И205	1	1	101010101010101010
892	8	Забони русӣ аз рӯи ихтисос	08:00:00	1_40.01.01рб	Машарипова М.Э.	ФМИ	И201	1	1	101010101010101010
893	8	Забони хориҷӣ аз рӯи ихтисос	08:00:00	1_40.01.01рб	Исломова П.Н.	ФМИ	И201	1	1	010101010101010101
894	8	Физикаи ҳодисаҳои электрикӣ ва нимноқилҳо	12:10:00	1_40.01.01та	Бобоҷонов Х.А.	ФИЭ	Э316	2	1	111111111111111111
895	8	Забони тоҷикӣ аз рӯи ихтисос	08:00:00	1_40.01.02ра	Ҳалимова М.Ҷ.	ФМИ	И102	1	1	101010101010101010
896	8	Фарҳангшиносӣ	08:00:00	1_40.01.02ра	Муллоусмонова Г.Ғ.	ФМИ	И102	1	1	010101010101010101
897	8	Назарияи эҳтимолият ва омори математикӣ	08:00:00	1_40.01.02та	Раҳматуллоева М.М.	ФИЭ	Э308	1	1	111111111111111111
898	8	Забони тоҷикӣ аз рӯи ихтисос	12:10:00	1_40.03.01ра	Ҳалимова М.Ҷ.	ФМИ	И201	2	1	010101010101010101
899	8	Фарҳангшиносӣ	12:10:00	1_40.03.01ра	Муллоусмонова Г.Ғ.	ФМИ	И201	2	1	101010101010101010
900	8	Назарияи умумии алоқа	12:10:00	1_45.01.01ра	Левандовский Б.И.	ФМИ	И306	2	1	111111111111111111
901	8	Маркетинг	08:00:00	2_25.01.03ра	Раҳимӣ Ш.	ФМИ	Ф203	1	1	111111111111111111
902	8	Андоз ва андозбандӣ	08:00:00	2_25.01.04та	Сатторов Ш.А.	ФМИ	Ф105	1	1	111111111111111111
903	8	Эконометрика	08:00:00	2_26.03.01ра	Ахмедова М.М.	ФМИ	Ф108	1	1	111111111111111111
904	8	Технологияи сохтани шабакаҳои компутерӣ	08:00:00	2_40.01.01рб	Левандовский Б.И.	ФМИ	И306	1	1	111111111111111111
905	8	Манбаи додаҳо	08:00:00	2_40.01.01та	Фозилова М.М.	ФМИ	И305	1	1	111111111111111111
906	8	Баҳисобгирии муҳосибӣ ва аудит	08:00:00	2_40.01.02ра	Акбарова Н.А.	ФМИ	Ф103	1	1	111111111111111111
907	8	Макроиқтисодиёт	08:00:00	2_40.01.02та	Набиева Х.Н.	ФИЭ	Э416	1	1	111111111111111111
908	8	Сохтори додаҳо ва алгоритмҳо	08:00:00	2_40.03.01ра	Ахмедов М.Р.	FIN Group		1	1	111111111111111111
909	8	Асосҳои бехатарии фаъолияти ҳаёт	08:00:00	2_45.01.01ра	Ҳофизов Ҳ.Р.	ФИЭ	Э404	1	1	100010001000001010
910	8	Мудофиаи шаҳрвандӣ	08:00:00	2_45.01.01ра	Ҳофизов Ҳ.Р.	ФИЭ	Э404	1	1	001000100010100010
911	8	Ҳуқуқ аз рӯи ихтисос	08:00:00	2_45.01.01ра	Норов И.С.	ФСН	Э404	1	1	010101010101010101
912	8	Баҳисобгирии молиявӣ	12:10:00	3_25.01.04ра	Ҳаитова Н.Н.	ФМИ	Ф104	2	1	111111111111111111
913	8	Менеҷменти молиявӣ	08:00:00	3_25.01.04та	Раҳмонов Ф.Х.	ФМИ	Ф106	1	1	101010101010101010
914	8	Сиёсатшиносӣ	08:00:00	3_25.01.04та	Ҳотамова М.Ғ.	ФИЭ	Э101	1	1	010101010101010101
915	8	Сохтор ва алгоритмҳои коркарди додаҳо	12:10:00	3_40.01.01ра	Ашӯрова Ш.Н.	ФИЭ	Э107	2	1	111111111111111111
916	8	Балоиҳагирии системаҳои барномавӣ	08:00:00	3_40.01.01та	Худойбердиев Х.А.	ФИЭ	Э106	1	1	111111111111111111
917	8	Тиҷорати электронӣ	12:10:00	3_40.01.02ра	Рашидова Ф.М.	ФМИ	И207	2	1	111111111111111111
918	8	Коркарди низомҳои иттилоотӣ	08:00:00	3_40.01.02та	Мирмуҳамедова Ш.Р.	ФМИ	И105	1	1	111111111111111111
919	8	Технологияи коркарди муосири Веб-низомҳо	08:00:00	3_40.03.01ра	Рашидова Ф.М.	ФМИ	И207	1	1	111111111111111111
920	8	Назорати молиявӣ	08:00:00	4_25.01.04ра	Ҳаитова Н.Н.	ФМИ	Ф104	1	1	111111111111111111
921	8	Идораи захираҳои иттилоотӣ	12:10:00	4_26.03.01ра	ВакКИР	ФМИ	И205	2	1	111111111111111111
922	8	Менеҷмент ва маркетинг дар соҳаи технологияи иттилоотӣ	08:00:00	4_40.01.01ра	Ҷӯраева З.А.	ФМТ	Т204	1	1	111111111111111111
923	8	Барномасозӣ барои таҷҳизоти мобилӣ	08:00:00	4_40.01.01та	Етмишбоева Ш.А.	ФИЭ	Э107	1	1	111111111111111111
924	8	Эътимоднокии низомҳову шабакаҳои компютерӣ ва ҳимояи захираҳои иттилоотии онҳо	08:00:00	4_40.01.02ра	Олимов Н.А.	ФМИ	И206	1	1	111111111111111111
925	8	Асосҳои коркарди забонҳои табиӣ	08:00:00	4_40.03.01ра	Мақсудов Х.Т.	ФМИ	И203	1	1	111111111111111111
926	8	Ҳуқуқи молиявӣ	08:00:00	2_25.01.04ра	Оқилҷонова Ш.Ю.	ФМИ	Ф101	1	1	111111111111111111
927	8	Идоракунии додаҳо	08:00:00	2_26.03.01та	Қаюмова Д.Д.	ФМИ	И103	1	1	111111111111111111
928	8	Математикаи дискретӣ	08:00:00	2_40.01.01ра	Гуломнабиев С.Г.	ФМИ	И304	1	1	111111111111111111
929	8	Зеҳнияти равандҳои корӣ бо барномаи SPSS	08:00:00	3_26.03.01ра	Усмонов А.А.	ФМИ	И101	1	1	111111111111111111
984	8	Математика дар иқтисодиёт	08:00:00	1_25.01.03ра	Гуломнабиев С.Г.	ФМИ	И304	1	3	111111111111111111
985	8	Математика дар иқтисодиёт	08:00:00	1_25.01.04ра	Раҳимов А.А.	ФМИ	И102	1	3	111111111111111111
986	8	Забони тоҷикӣ аз рӯи ихтисос	12:10:00	1_25.01.04та	Раҳмонов З.А.	ФМИ	ф102	2	3	101010101010101010
987	8	Фарҳангшиносӣ	12:10:00	1_25.01.04та	Раҳмонов З.А.	ФМИ	ф102	2	3	010101010101010101
988	8	Микроиқтисод	08:00:00	1_25.01.04тб	Набиева Х.Н.	ФИЭ	Э416	1	3	010101010101010101
989	8	Назарияи иқтисодӣ	08:00:00	1_25.01.04тб	Набиева Х.Н.	ФИЭ	Э416	1	3	101010101010101010
990	8	Асосҳои Веб дизайн	08:00:00	1_26.03.01ра	Рашидова Ф.М.	ФМИ	И207	1	3	111111111111111111
991	8	Забони русӣ аз рӯи ихтисос	08:00:00	1_26.03.01та	Солиев З.Т.	ФМИ	И206	1	3	010101010101010101
992	8	Забони хориҷӣ аз рӯи ихтисос	08:00:00	1_26.03.01та	Қаландарова М.Д.	ФМИ	И206	1	3	101010101010101010
993	8	Диншиносии илмӣ	08:00:00	1_40.01.01ра	Ҳофизов Ҳ.Р.	ФСН	Д302	1	3	010101010101010101
994	8	Таҷрибаомӯзии таълимӣ	13:00:00	1_40.01.01ра	Қодирова Х.М.	ФМИ	И	2	3	101010100010101000
995	8	Диншиносии илмӣ	08:00:00	1_40.01.01рб	Ҳофизов Ҳ.Р.	ФСН	И205	1	3	010101010101010101
996	8	Таҷрибаомӯзии таълимӣ	13:00:00	1_40.01.01рб	Ашӯрова Ш.Н.	ФМИ	И306	2	3	101010100010101000
997	8	Диншиносии илмӣ	08:00:00	1_40.01.01та	Ҳофизов Ҳ.Р.	ФСН	Д302	1	3	010101010101010101
998	8	Таҷрибаомӯзии таълимӣ	08:00:00	1_40.01.01та	Фозилова М.М.	ФМИ	И305	1	3	101010100010101000
999	8	Диншиносии илмӣ	08:00:00	1_40.01.02ра	Ҳофизов Ҳ.Р.	ФСН	Д302	1	3	101010101010101010
1000	8	Таҷрибаомӯзии таълимӣ	13:00:00	1_40.01.02ра	Шерматова Ш.И.	ФИЭ	Э410	2	3	010101000101010100
1001	8	Технологияи информатсионӣ	08:00:00	1_40.01.02та	Одилов З.Р.	ФМИ	И104	1	3	111111111111111111
1002	8	Назарияи эҳтимолият ва омори математикӣ	08:00:00	1_40.03.01ра	Раҳимов А.А.	ФИЭ	Э202	1	3	111111111111111111
1003	8	Диншиносии илмӣ	08:00:00	1_45.01.01ра	Ҳофизов Ҳ.Р.	ФСН	Д302	1	3	101010101010101010
1004	8	Таҷрибаомӯзии таълимӣ	13:00:00	1_45.01.01ра	Ашӯрова Ш.Н.	ФМИ	И306	2	3	010101000101010100
1005	8	Сотсиология	08:00:00	2_25.01.03ра	Темирхоҷаев А.У.	ФИЭ	Э404	1	3	101010101010101010
1006	8	Таърихи муосири Тоҷикистон	08:00:00	2_25.01.03ра	Ҳотамова М.Ғ.	ФИЭ	Э404	1	3	010101010101010101
1007	8	Сиёсати макроиқтисодӣ	08:00:00	2_25.01.04ра	Оқилҷонова Ш.Ю.	ФМИ	Ф104	1	3	111111111111111111
1008	8	Географияи иқтисодии Тоҷикистон бо асосҳои демография	12:00:00	2_26.03.01ра	Юсупова М.З.	ФИЭ	Э101	2	3	101010101010101010
1009	8	Экология	12:00:00	2_26.03.01ра	Ғафоров А.А.	ФИЭ	Э101	2	3	010101010101010101
1010	8	Амалияи барномарезӣ	08:00:00	2_40.01.01ра	Ашӯрова Ш.Н.	ФМИ	И306	1	3	111111111111111111
1011	8	Сотсиология	08:00:00	2_40.01.01рб	Темирхоҷаев А.У.	ФИЭ	Э404	1	3	101010101010101010
1012	8	Таърихи муосири Тоҷикистон	08:00:00	2_40.01.01рб	Ҳотамова М.Ғ.	ФИЭ	Э404	1	3	010101010101010101
1013	8	Географияи иқтисодии Тоҷикистон бо асосҳои демография	08:00:00	2_40.01.02ра	Юсупова М.З.	ФМИ	И301	1	3	010101010101010101
1014	8	Экология	08:00:00	2_40.01.02ра	Масаидов Ҷ.Ғ.	ФМИ	И301	1	3	101010101010101010
1015	8	Географияи иқтисодии Тоҷикистон бо асосҳои демография	08:00:00	2_40.03.01ра	Юсупова М.З.	ФМИ	И301	1	3	010101010101010101
1016	8	Экология	08:00:00	2_40.03.01ра	Масаидов Ҷ.Ғ.	ФМИ	И301	1	3	101010101010101010
1017	8	Асосҳои бунёди низомҳо ва шабакаҳои инфоробитавӣ	12:10:00	2_45.01.01ра	Левандовский Б.И.	ФМИ	И101	2	3	111111111111111111
1018	8	Молияи давлатӣ	08:00:00	3_25.01.04та	Раҳмонов Ф.Х.	ФМИ	Ф106	1	3	111011101111111101
1019	8	Маъмурчигии низомҳои иттилоотӣ	08:00:00	3_26.03.01ра	Қаюмова Д.Д.	ФМИ	И103	1	3	111111111111111111
1020	8	Асосҳои Web-дизайн	08:00:00	3_40.01.01та	Етмишбоева Ш.А.	ФИЭ	Э107	1	3	111111111111111111
1021	8	Системаҳои оператсионӣ ва барномасозии системавӣ	08:00:00	4_40.01.01ра	Қодирова Х.М.	ФМИ	Ф108	1	3	111111111111111111
1022	8	Тарҳрезии низомҳои зеҳнӣ	12:10:00	4_40.03.01ра	Усмонова М.Р.	ФМИ	И203	2	3	111111111111111111
1023	8	Этика ва эстетика	08:00:00	2_25.01.04та	Ҳотамова М.Ғ.	ФИЭ	Э101	1	3	101010101010101010
1024	8	Этика ва эстетика	12:00:00	2_26.03.01та	Умарова М.И.	ФИЭ	Э404	2	3	010101010101010101
1025	8	Этика ва эстетика	12:00:00	2_40.01.01та	Умарова М.И.	ФСН	Д302	2	3	101010101010101010
1026	8	Амалияи барномарезӣ	12:10:00	2_40.01.02та	Довудов Г.М.	ФИЭ	Э107	2	3	111111111111111111
1027	8	1C - Муҳосибот	12:10:00	3_25.01.04ра	Сатторов Ш.А.	ФМИ	И205	2	3	111111111111111111
1028	8	Забони дархостҳои SQL	08:00:00	3_40.01.01ра	Худойбердиев Х.А.	ФИЭ	Э106	1	3	111111111111111111
1029	8	Забони дархостҳои SQL	08:00:00	3_40.01.02ра	ВакКИР	ФМИ	IT-RUN	1	3	111111111111111111
1030	8	Пешвоӣ дар роҳбарӣ	08:00:00	3_40.01.02та	Низомитдинова Ф.Б.	ФИЭ	Э413	1	3	111111111111111111
1031	8	Амалияи манбаи додаҳо (MongoDB)	08:00:00	3_40.03.01ра	Иномов Б.Б.	ФМИ	И203	1	3	111111111111111111
1032	8	Таҳлили молиявӣ	08:00:00	4_25.01.04ра	Комилова М.А.	ФМИ	Ф102	1	3	111111111111111111
1033	8	Коркарди низоми тиҷорати электронӣ	08:00:00	4_26.03.01ра	Ахмедов М.Р.	ФМИ	FIN Group	1	3	111111111111111111
1034	8	Барномарезӣ дар Andriod	08:00:00	4_40.01.01та	Фозилова М.М.	ФМИ	И305	1	3	111111111111111111
1035	8	Зеҳнияти равандҳои корӣ бо барномаи Tableau	08:00:00	4_40.01.02ра	Усмонов А.А.	ФМИ	И101	1	3	111111111111111111
1126	8	Забони русӣ аз рӯи ихтисос	08:00:00	1_25.01.03ра	Солиев Зариф Тович	ФТР	Ф103	1	4	101010101010101010
1127	8	Забони хориҷӣ аз рӯи ихтисос	08:00:00	1_25.01.03ра	Исломова Парвина Наимовна	ФТР	Ф103	1	4	010101010101010101
1129	8	Забони хориҷӣ аз рӯи ихтисос	08:00:00	1_25.01.04ра	Исломова Парвина Наимовна	ФТР	Ф203	1	4	010101010101110101
1128	8	Забони русӣ аз рӯи ихтисос	08:00:00	1_25.01.04ра	Машарипова М.Э.	ФТР	Ф203	1	4	101010101010101010
1130	8	Менеҷмент ва маркетинг	08:00:00	1_25.01.04та	Аминҷонова М.М.	ФЭ	Э410	1	4	111111111111111111
1131	8	Математика дар иқтисодиёт	08:00:00	1_25.01.04тб	Исмоилова М.Ҳ.	ФТР	Ф105	1	4	111111111111111111
1132	8	Асосҳои алгоритмиронӣ ва барномасозӣ	08:00:00	1_26.03.01ра	Усмонов А.А.	ФТР	И101	1	4	111111111111111111
1133	8	Асосҳои алгоритмиронӣ ва барномасозӣ	10:00:00	1_26.03.01та	Довудзода Г.М.	ФТР	И105	1	4	111111111111111111
1134	8	Забони тоҷикӣ аз рӯи ихтисос	08:00:00	1_40.01.01ра	Ҳоҷаева Н.А.	ФТР	И301	1	4	101010101010101010
1135	8	Фарҳангшиносӣ	08:00:00	1_40.01.01ра	Раҳмонов З.А.	ФТР	И301	1	4	010101010101010101
1136	8	Физикаи ҳодисаҳои электрикӣ ва нимноқилҳо	12:10:00	1_40.01.01рб	Каюмова М.Г.	ФТР	И305	2	4	111111111111111111
1137	8	Математика барои муҳандисон	08:00:00	1_40.01.01та	Раҷабов Ғ.Н.	ФТР	Ф108	1	4	111111111111111111
1081	8	Математика дар иқтисодиёт	08:00:00	1_25.01.03ра	Раҳматова М.А.	ФИЭ	Э401	1	5	111111111111111111
1082	8	Математика дар иқтисодиёт	08:00:00	1_25.01.04ра	Раҳимов А.А.	ФМИ	Ф203	1	5	111111111111111111
1083	8	Молия, муомилоти пулӣ, қарз	08:00:00	1_25.01.04та	Оқилҷонова Ш.Ю.	ФМИ	Ф101	1	5	111111111111111111
1084	8	Молия, муомилоти пулӣ, қарз	09:00:00	1_25.01.04тб	Мирзоева М.У.	ФМИ	Ф104	1	5	111111111111111111
1085	8	Забони русӣ аз рӯи ихтисос	12:10:00	1_26.03.01ра	Машарипова М.Э.	ФМИ	И306	2	5	010101010101010101
1086	8	Забони хориҷӣ аз рӯи ихтисос	12:10:00	1_26.03.01ра	Исломова П.Н.	ФМИ	И306	2	5	101010101010101010
1087	8	Забони русӣ аз рӯи ихтисос	12:10:00	1_26.03.01та	Ҳамидова Н.Ш.	ФМИ	И201	2	5	101010101010101010
1088	8	Забони хориҷӣ аз рӯи ихтисос	12:10:00	1_26.03.01та	Баҳридинова А.А.	ФМИ	И201	2	5	010101010101010101
1089	8	Физикаи ҳодисаҳои электрикӣ ва нимноқилҳо	12:10:00	1_40.01.01ра	Бобоҷонов Х.А.	ФИЭ	Э306	2	5	111111111111111111
1090	8	Забони тоҷикӣ аз рӯи ихтисос	08:00:00	1_40.01.01рб	Раҳматова М.М.	ФМИ	Ф108	1	5	101010101010101010
1091	8	Фарҳангшиносӣ	08:00:00	1_40.01.01рб	Раҳматова М.М.	ФМИ	Ф108	1	5	010101010101010101
1092	8	Забони русӣ аз рӯи ихтисос	08:00:00	1_40.01.01та	Солиев З.Т.	ФМИ	И201	1	5	101010101010101010
1093	8	Забони хориҷӣ аз рӯи ихтисос	08:00:00	1_40.01.01та	Исломова П.Н.	ФМИ	И201	1	5	010101010101010101
1094	8	Манбаи додаҳо	12:10:00	1_40.01.02ра	Фозилова М.М.	ФМИ	И305	2	5	111111111111111111
1095	8	Манбаи додаҳо	12:10:00	1_40.01.02та	Икромзода Ф.	ФМИ	И102	2	5	111111111111111111
1096	8	Математикаи дискретӣ	08:00:00	1_40.03.01ра	Гуломнабиев С.Г.	ФМИ	И304	1	5	111111111111111111
1097	8	Физикаи ҳодисаҳои электрикӣ ва нимноқилҳо	08:00:00	1_45.01.01ра	Шодиев Ш.Ш.	ФИЭ	Э319	1	5	111111111111111111
1098	8	Иқтисодиёти ҷаҳонӣ	08:00:00	2_25.01.03ра	Бакаев М.Х.	ФМИ	Ф105	1	5	010010001001001001
1099	8	Фалсафа	08:00:00	2_25.01.03ра	Темирхоҷаев А.У.	ФСН	Д302	1	5	101101110110110110
1100	8	Молияи давлатӣ	08:00:00	2_25.01.04ра	Раҳмонов Ф.Х.	ФМИ	Ф106	1	5	010010001001001001
1101	8	Фалсафа	08:00:00	2_25.01.04ра	Темирхоҷаев А.У.	ФСН	Д302	1	5	101101110110110110
1102	8	Баҳисобгирии муҳосибӣ	08:00:00	2_25.01.04та	Акбарова Н.А.	ФМИ	Ф103	1	5	111111111111111111
1103	8	Бехатарии иттилоотӣ ва ҳимояи иттилоот	12:10:00	2_26.03.01ра	Усмонов А.А.	ФМИ	И101	2	5	101001000100100100
1104	8	Фалсафа	08:00:00	2_26.03.01ра	Ғозиева М.С.	ФИЭ	Э404	1	5	010110111011011011
1105	8	Балоиҳагирӣ ва нигоҳубини техникии шабакаҳои компютерӣ	08:00:00	2_26.03.01та	Олимов Н.А.	ФМИ	И205	1	5	111111111111111111
1106	8	Манбаи додаҳо	08:00:00	2_40.01.01ра	Фозилова М.М.	ФМИ	И305	1	5	111111111111111111
1107	8	Барномарезии ба объект нигаронидашуда	08:00:00	2_40.01.01рб	Бобоева Д.Н.	ФМИ	И105	1	5	010010001001001001
1108	8	Фалсафа	08:00:00	2_40.01.01рб	Темирхоҷаев А.У.	ФСН	Д302	1	5	101101110110110110
1109	8	Технологияи сохтани шабакаҳои компутерӣ	12:10:00	2_40.01.01та	Назаров А.А.	ФИЭ	Э106	2	5	111111111111111111
1110	8	Муҳитҳои паҳнкунии электроалоқа	08:00:00	2_45.01.01ра	Левандовский Б.И.	ФМИ	И306	1	5	010010001001001001
1111	8	Фалсафа	08:00:00	2_45.01.01ра	Темирхоҷаев А.У.	ФСН	Д302	1	5	101101110110110110
1112	8	Менеҷменти молиявӣ	08:00:00	3_25.01.04ра	Юсупова Г.А.	ФМИ	И206	1	5	010101010101010101
1113	8	Сиёсатшиносӣ	08:00:00	3_25.01.04ра	Ҳотамова М.Ғ.	ФМИ	И301	1	5	101010101010101010
1114	8	Баҳисобгирии молиявӣ	08:00:00	3_25.01.04та	Исоев Д.Т.	ФМИ	Ф102	1	5	111111111111111111
1115	8	Сиёсатшиносӣ	08:00:00	3_26.03.01ра	Ҳотамова М.Ғ.	ФМИ	И301	1	5	010101010101010101
1116	8	Тарҳрезӣ ва коркарди низомҳои иттилоотӣ	08:00:00	3_26.03.01ра	Мирмуҳамедова Ш.Р.	ФМИ	И206	1	5	101010101010101010
1117	8	Сиёсатшиносӣ	08:00:00	3_40.01.01ра	Ҳотамова М.Ғ.	ФМИ	И301	1	5	010101010101010101
1118	8	Технологияҳо ва забонҳои Internet барномасозӣ	08:00:00	3_40.01.01ра	ВакКБНИ	ФМИ	И103	1	5	101010101010101010
1119	8	Сохтор ва алгоритмҳои коркарди додаҳо	08:00:00	3_40.01.01та	Назаров А.А.	ФИЭ	Э106	1	5	111111111111111111
1120	8	Коркарди низомҳои иттилоотӣ	08:00:00	3_40.01.02ра	Иномов Б.Б.	ФМИ	И207	1	5	111111111111111111
1121	8	Омӯзиши мошинӣ	08:00:00	3_40.03.01ра	Низамитдинов А.И.	ФМИ	И203	1	5	111111111111111111
1122	8	Барномасозӣ дар Python	08:00:00	2_40.01.02ра	Усмонов А.А.	ФМИ	И101	1	5	111111111111111111
1123	8	Барномасозӣ дар C#	08:00:00	2_40.01.02та	Довудов Г.М.	ФИЭ	Э414	1	5	111111111111111111
1124	8	Барномасозӣ дар C++	12:10:00	2_40.03.01ра	ВакКИР	ФМИ	И207	2	5	111111111111111111
1125	8	Барномасозии ба объект нигаронидашуда	08:00:00	3_40.01.02та	Икромзода Ф.	ФМИ	И102	1	5	111111111111111111
1138	8	Назарияи эҳтимолият ва омори математикӣ	12:10:00	1_40.01.02ра	Азимов Н.С.	ФЭ	Э316	2	4	111111111111111111
1139	8	Асосҳои алгоритмсозӣ ва барномарезӣ	08:00:00	1_40.01.02та	Рашидова Ф.М.	ФТР	И207	1	4	111111111111111111
1140	8	Математикаи ҳисоббарор	08:00:00	1_40.03.01ра	Раҳимов А.А.	ФЭ	Э202	1	4	111111111111111111
1141	8	Забони русӣ аз рӯи ихтисос	08:00:00	1_45.01.01ра	Абдусаломова М.А.	ФТР	И102	1	4	010101010101010101
1142	8	Забони хориҷӣ аз рӯи ихтисос	08:00:00	1_45.01.01ра	Шарипова М.А.	ФТР	И102	1	4	101010101010101010
1143	8	Банақшагирии макроиқтисодӣ	08:00:00	2_25.01.03ра	Оқилҷонова Ш.Ю.	ФТР	Ф101	1	4	111111111111111111
1144	8	Баҳисобгирии муҳосибӣ	08:00:00	2_25.01.04ра	Акбарова Н.А.	ФТР	Ф102	1	4	111111111111111111
1145	8	Консепсияи табиатшиносии муосир	08:00:00	2_25.01.04та	Алиев С.С.	ФЭ	Э101	1	4	000100100000010101
1146	8	Мудофиаи шаҳрвандӣ	12:00:00	2_25.01.04та	Ҳофизов Ҳ.Р.	ФЭ	Э101	2	4	010000010010001001
1147	8	Ҳуқуқ аз рӯи ихтисос	12:00:00	2_25.01.04та	Темирхоҷаев А.У.	ФЭ	Э101	2	4	101011001101100010
1148	8	ҳагирӣ ва нигоҳубини техникии шабакаҳои ком	08:00:00	2_26.03.01ра	Олимов Н.А.	ФТР	И205	1	4	111111111111111111
1149	8	Консепсияи табиатшиносии муосир	08:00:00	2_26.03.01та	Алиев С.С.	ФЭ	Э101	1	4	000100100000010101
1150	8	Мудофиаи шаҳрвандӣ	12:00:00	2_26.03.01та	Ҳофизов Ҳ.Р.	ФЭ	Э101	2	4	010000010010001001
1151	8	Ҳуқуқ аз рӯи ихтисос	12:00:00	2_26.03.01та	Темирхоҷаев А.У.	ФЭ	Э101	2	4	101011001101100010
1152	8	Барномарезии ба объект нигаронидашуда	12:10:00	2_40.01.01ра	Бобоева Д.Н.	ФТР	И206	2	4	001001010001010001
1153	8	Фалсафа	08:00:00	2_40.01.01ра	Темирхоҷаев А.У.	ФЭ	Э404	1	4	110110101110101110
1154	8	Тарҳрезии низомҳои иттилоотӣ	12:10:00	2_40.01.02ра	Усмонова М.Р.	ФТР	И205	2	4	001001010001010001
1155	8	Фалсафа	08:00:00	2_40.01.02ра	Темирхоҷаев А.У.	ФЭ	Э404	1	4	110110101110101110
1156	8	Консепсияи табиатшиносии муосир	08:00:00	2_40.01.02та	Алиев С.С.	ФЭ	Э101	1	4	000100100000010101
1157	8	Мудофиаи шаҳрвандӣ	12:00:00	2_40.01.02та	Ҳофизов Ҳ.Р.	ФЭ	Э101	2	4	010000010010001001
1158	8	Ҳуқуқ аз рӯи ихтисос	12:00:00	2_40.01.02та	Темирхоҷаев А.У.	ФЭ	Э101	2	4	101011001101100010
1159	8	Барномарезии ба объект нигаронидашуда	08:00:00	2_40.03.01ра	Мақсудов Х.Т.	ФТР	И203	1	4	001001010001010001
1160	8	Фалсафа	08:00:00	2_40.03.01ра	Ғозиева М.С.	ФЭ	Э201	1	4	110110101110101110
1161	8	Электроника	12:10:00	2_45.01.01ра	Левандовский Б.И.	ФТР	И306	2	4	111111111111111111
1162	8	Таҷрибаомӯзии истеҳсолӣ	13:00:00	3_25.01.04ра	Содиқзода Х.С.	ФТР	Ф203	2	4	100100001001001001
1163	8	Захираҳои иттилоотӣ	08:00:00	3_26.03.01ра	Қаюмова Д.Д.	ФТР	И103	1	4	111111111111111111
1164	8	Балоиҳагирии системаҳои барномавӣ	08:00:00	3_40.01.01ра	Худойбердиев Х.А.	ФЭ	Э106	1	4	111111111111111111
1165	8	Сиёсатшиносӣ	12:00:00	3_40.01.02ра	Ҳотамова М.Ғ.	ФТР	И201	2	4	010101010101010101
1166	8	Технологияҳо ва забонҳои Internet барномасозӣ	12:10:00	3_40.01.02ра	Мирмуҳамедова Ш.Р.	ФТР	И206	2	4	101010101010101010
1167	8	Сиёсатшиносӣ	08:00:00	3_40.01.02та	Ҳотамова М.Ғ.	ФТР	И201	1	4	010101010101010101
1168	8	Технологияҳо ва забонҳои Internet барномасозӣ	08:00:00	3_40.01.02та	Мирмуҳамедова Ш.Р.	ФТР	И206	1	4	101010101010101010
1169	8	Сиёсатшиносӣ	12:00:00	3_40.03.01ра	Ҳотамова М.Ғ.	ФТР	И201	2	4	010101010101010101
1170	8	Тарҳрезии низомҳои зеҳнӣ	08:00:00	3_40.03.01ра	Низамитдинов А.И.	ФТР	zypl ai	1	4	101010101010101010
1171	8	Математикаи дискретӣ	08:00:00	2_40.01.01рб	Гуломнабиев С.Г.	ФТР	И304	1	4	111111111111111111
1172	8	Математикаи дискретӣ	08:00:00	2_40.01.01та	Раҳимов А.А.	ФТР	И306	1	4	111111111111111111
1173	8	Амалияи баҳисобгирии муҳосибӣ	08:00:00	3_25.01.04та	Раҳмонов Ф.Х.	ФТР	Ф106	1	4	111111111111111111
1174	8	Таҳлили манбаи дониш бо забони Python	12:10:00	3_40.01.01та	Етмишбоева Ш.А.	ФТР	И301	2	4	111111111111111111
\.


--
-- TOC entry 5227 (class 0 OID 33138)
-- Dependencies: 224
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password, name, surname, middlename, role_id, group_id, is_active, created_at, login, phone) FROM stdin;
2	\N	$2a$11$YhXe5C/eqgVC4wrGKz99Ue1DtCUQHJllw/dUqesVsyC9B7qbEdsUK	Зариф	Довудов	\N	2	\N	t	2026-04-16 11:32:29.598722	teacher	\N
6	\N	$2a$11$.7.M6VboPOqyaLfeFPbnRuBP3oIdCqrHbqcdLTkTX/0s4SMJpyqHO	Бахром	Рахимов	\N	2	\N	t	2026-04-27 17:43:18.558111	t_rahimov	\N
7	\N	$2a$11$om4BUR1DVJH0NZuq0RcCsec2UUlyx1fIPgneTOq4Rp/1IuamJ2lMm	Санжар	Назаров	\N	2	\N	t	2026-04-27 17:43:19.089267	t_nazarov	\N
8	\N	$2a$11$BabxU1n8NDz4Edzz8pVwcej6EBu4g6lh3Teu/l2sY2IyZDpkL4xW2	Фаррух	Юсупов	\N	2	\N	t	2026-04-27 17:43:19.544103	t_yusupov	\N
9	\N	$2a$11$jBztUpqib0Vnemx.BaFjK.bi5voHjakV9R4ylTwKxPEWxBF/dEJM6	Дилшод	Тошев	\N	2	\N	t	2026-04-27 17:43:19.961805	t_toshev	\N
13	\N	$2a$11$sxjvYEBTwTNXgI6j1UL3LOc3xixGGr/JxUVIzWdKAuO02vPlsrFO2	Эргаш	Эргашев	\N	1	4	t	2026-04-27 17:43:21.220407	s_ergashev	\N
14	\N	$2a$11$kYhod2n95/EnFlOQMo3Jkuy4t/bQXGeZRosCKDIphrHH6kOjKtBTe	Сотвол	Сотволдиев	\N	1	4	t	2026-04-27 17:43:21.494287	s_sotvold	\N
21	\N	$2a$11$9wWG1.I1eKXCJ9ywaGP/1OBzOoILB4H/zQo5q8ZHEh5D5qEdshYOW	Самад	Алиев	Самадович	2	\N	t	2026-05-12 09:17:22.301544	t_samad	\N
18	\N	$2a$11$Kaxp7DX3KwhiYs0gyWrWaeA8U0gr6wOp2Zt8S2CIDCHRjpQWOaVJe	Мирзо	Мирзаев	\N	1	5	t	2026-04-27 17:43:22.585333	s_mirzaev	\N
17	\N	$2a$11$ZPqxtRNecLpcoe.uf4GAVeuoWFlFAfogwHL7iDAgMBKu7Zl/Aq8ru	Исмоил	Исмоилов	\N	1	5	t	2026-04-27 17:43:22.236186	s_ismoilov	\N
16	\N	$2a$11$qALSNxy2RlIM/pRx8jThjuW/3pz/sawiO1NZfUG1ijGT5/TrjW.cy	Турсун	Турсунов	\N	1	5	t	2026-04-27 17:43:21.951115	s_tursunov	\N
15	\N	$2a$11$NKzxp7QjVKdMyXMJS79Js.2Vhhkgok0jDOIdDsU0myRIjBUOTYPIa	Кодир	Кодиров	\N	1	5	t	2026-04-27 17:43:21.686716	s_qodirov	\N
5	\N	$2a$11$/kiI4PeSv.yn66xGDtRDZOILBxTzrH0.BStZxp1UhgG1bys25J3C6	Алишер	Каримов	\N	2	1	t	2026-04-27 17:43:18.017353	t_karimov	\N
22	\N	$2a$11$a0r3qnjNWVuUS4Njhvsi7eHoC6Ww4xj.8PbQl3lAkLT6HdIbKLAMG	Салима	Саидова	Алиевна	2	\N	t	2026-05-14 09:12:03.177539	t_salima	\N
3	\N	$2a$11$R68FH2HlLBxuvHKo8cAKcOkhpiDzJYZI48ZmY1.xTxS9k6pzbg4E2	Саидазим	Раджабов	\N	3	3	t	2026-04-16 11:32:29.598722	moder	\N
23	\N	$2a$11$7r6KRy.ytcO9rTEjIhBmK.RdMWBFmIQ1PcoYXQx0gVr3XVkbaD9cS	Мунира	Машарипова	Элеоноровна	2	\N	t	2026-05-15 08:46:58.178126	t_munira	\N
24	\N	$2a$11$8SL4WSNRcUQKnqULzrVMMuvj2VxsTlAcBxTk0.1cJR3ZurJUCHA86	А	А	\N	1	6	t	2026-05-15 08:49:38.704887	s_a	\N
25	\N	$2a$11$AlqXXu7OAz36CM9tft4Yw.rAKhfIUQB3HmUCAxF4QrXZd6m2qtwiG	Б	Б	\N	1	6	t	2026-05-15 08:49:55.072082	s_b	\N
4	\N	$2a$11$e/UW608xPUPgiJ30gFFLQe8zOk9kEssTQKZ.CBRaQa1V1CACf7O4W	Бехруз	Зокиров	\N	4	\N	t	2026-04-16 11:32:29.598722	admin	\N
10	\N	$2a$11$6S5T0hvmX9.rIwR5PFTK8.xyRaaMRQi4yzaHyqQP8JXcSAps/VLvi	Акбар	Алиев	\N	1	4	t	2026-04-27 17:43:20.431515	s_aliev	\N
11	\N	$2a$11$vBnNTuhCy3iITY93489WuOXvtk8BtDdHZ3SG1Itqqkvwc8niFr7aS	Хасан	Хасанов	\N	1	4	t	2026-04-27 17:43:20.797482	s_hasanov	\N
12	\N	$2a$11$MPEirWfL/hLLQvf6gTDyLOLak3rXf.D1XWJmwmo7Dt8DFEiXDz7AO	Умар	Умаров	\N	1	4	t	2026-04-27 17:43:20.997096	s_umarov	\N
19	\N	$2a$11$buESUN108J2L9e3hyRHObO17uniBYVvlLnku/fdp5uU6Y97tTWqke	Рустам	Ражабов	\N	1	3	t	2026-04-27 17:43:22.934499	s_rajabov	\N
1	kholikovahad705@gmail.com	$2a$11$URVBmFiAc1BXkSLao7oc5.amJOYWO/DDNxiv7GGDTSmDqGWrBUdX.	Ахад	Холиков	\N	1	7	t	2026-04-16 11:32:29.598722	student	1
26	\N	$2a$11$vj4u.SoWDR0kgf5sQ9sDbeDH3rCybKNs7A3VfSnn6Y.pPPZazuRSu	Парвина	Исломова	Наимовна	2	\N	t	2026-05-15 08:51:39.097623	s_parvina	\N
\.


--
-- TOC entry 5281 (class 0 OID 0)
-- Dependencies: 245
-- Name: action_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.action_logs_id_seq', 115, true);


--
-- TOC entry 5282 (class 0 OID 0)
-- Dependencies: 231
-- Name: announcements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.announcements_id_seq', 20, true);


--
-- TOC entry 5283 (class 0 OID 0)
-- Dependencies: 253
-- Name: file_exchange_files_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.file_exchange_files_id_seq', 31, true);


--
-- TOC entry 5284 (class 0 OID 0)
-- Dependencies: 239
-- Name: file_submissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.file_submissions_id_seq', 1, false);


--
-- TOC entry 5285 (class 0 OID 0)
-- Dependencies: 221
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.groups_id_seq', 7, true);


--
-- TOC entry 5286 (class 0 OID 0)
-- Dependencies: 233
-- Name: ideas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ideas_id_seq', 19, true);


--
-- TOC entry 5287 (class 0 OID 0)
-- Dependencies: 235
-- Name: ideas_likes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ideas_likes_id_seq', 16, true);


--
-- TOC entry 5288 (class 0 OID 0)
-- Dependencies: 237
-- Name: library_books_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.library_books_id_seq', 41, true);


--
-- TOC entry 5289 (class 0 OID 0)
-- Dependencies: 243
-- Name: library_favorites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.library_favorites_id_seq', 2, true);


--
-- TOC entry 5290 (class 0 OID 0)
-- Dependencies: 229
-- Name: moderators_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.moderators_id_seq', 1, true);


--
-- TOC entry 5291 (class 0 OID 0)
-- Dependencies: 219
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 4, true);


--
-- TOC entry 5292 (class 0 OID 0)
-- Dependencies: 249
-- Name: semester_days_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.semester_days_id_seq', 1068, true);


--
-- TOC entry 5293 (class 0 OID 0)
-- Dependencies: 241
-- Name: semester_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.semester_id_seq', 1, false);


--
-- TOC entry 5294 (class 0 OID 0)
-- Dependencies: 247
-- Name: semesters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.semesters_id_seq', 8, true);


--
-- TOC entry 5295 (class 0 OID 0)
-- Dependencies: 225
-- Name: students_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.students_id_seq', 11, true);


--
-- TOC entry 5296 (class 0 OID 0)
-- Dependencies: 227
-- Name: teachers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teachers_id_seq', 6, true);


--
-- TOC entry 5297 (class 0 OID 0)
-- Dependencies: 251
-- Name: timetables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.timetables_id_seq', 1282, true);


--
-- TOC entry 5298 (class 0 OID 0)
-- Dependencies: 223
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 26, true);


--
-- TOC entry 5040 (class 2606 OID 33447)
-- Name: action_logs action_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action_logs
    ADD CONSTRAINT action_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 5022 (class 2606 OID 33232)
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (id);


--
-- TOC entry 5048 (class 2606 OID 33524)
-- Name: file_exchange_files file_exchange_files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_exchange_files
    ADD CONSTRAINT file_exchange_files_pkey PRIMARY KEY (id);


--
-- TOC entry 5032 (class 2606 OID 33327)
-- Name: file_submissions file_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_submissions
    ADD CONSTRAINT file_submissions_pkey PRIMARY KEY (id);


--
-- TOC entry 5002 (class 2606 OID 33136)
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- TOC entry 5026 (class 2606 OID 33279)
-- Name: ideas_likes ideas_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ideas_likes
    ADD CONSTRAINT ideas_likes_pkey PRIMARY KEY (id);


--
-- TOC entry 5028 (class 2606 OID 33281)
-- Name: ideas_likes ideas_likes_user_id_ideas_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ideas_likes
    ADD CONSTRAINT ideas_likes_user_id_ideas_id_key UNIQUE (user_id, ideas_id);


--
-- TOC entry 5024 (class 2606 OID 33258)
-- Name: ideas ideas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ideas
    ADD CONSTRAINT ideas_pkey PRIMARY KEY (id);


--
-- TOC entry 5030 (class 2606 OID 33307)
-- Name: library_books library_books_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.library_books
    ADD CONSTRAINT library_books_pkey PRIMARY KEY (id);


--
-- TOC entry 5036 (class 2606 OID 33421)
-- Name: library_favorites library_favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.library_favorites
    ADD CONSTRAINT library_favorites_pkey PRIMARY KEY (id);


--
-- TOC entry 5038 (class 2606 OID 33423)
-- Name: library_favorites library_favorites_user_id_book_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.library_favorites
    ADD CONSTRAINT library_favorites_user_id_book_id_key UNIQUE (user_id, book_id);


--
-- TOC entry 5018 (class 2606 OID 33211)
-- Name: moderators moderators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moderators
    ADD CONSTRAINT moderators_pkey PRIMARY KEY (id);


--
-- TOC entry 5020 (class 2606 OID 33213)
-- Name: moderators moderators_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moderators
    ADD CONSTRAINT moderators_user_id_key UNIQUE (user_id);


--
-- TOC entry 4998 (class 2606 OID 33125)
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- TOC entry 5000 (class 2606 OID 33123)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 5044 (class 2606 OID 33476)
-- Name: semester_days semester_days_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semester_days
    ADD CONSTRAINT semester_days_pkey PRIMARY KEY (id);


--
-- TOC entry 5034 (class 2606 OID 33354)
-- Name: semester semester_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semester
    ADD CONSTRAINT semester_pkey PRIMARY KEY (id);


--
-- TOC entry 5042 (class 2606 OID 33464)
-- Name: semesters semesters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semesters
    ADD CONSTRAINT semesters_pkey PRIMARY KEY (id);


--
-- TOC entry 5010 (class 2606 OID 33176)
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- TOC entry 5012 (class 2606 OID 33178)
-- Name: students students_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_user_id_key UNIQUE (user_id);


--
-- TOC entry 5014 (class 2606 OID 33193)
-- Name: teachers teachers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_pkey PRIMARY KEY (id);


--
-- TOC entry 5016 (class 2606 OID 33195)
-- Name: teachers teachers_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_user_id_key UNIQUE (user_id);


--
-- TOC entry 5046 (class 2606 OID 33503)
-- Name: timetables timetables_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timetables
    ADD CONSTRAINT timetables_pkey PRIMARY KEY (id);


--
-- TOC entry 5004 (class 2606 OID 33155)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 5006 (class 2606 OID 33157)
-- Name: users users_login_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key UNIQUE (login);


--
-- TOC entry 5008 (class 2606 OID 33153)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 5069 (class 2606 OID 33448)
-- Name: action_logs action_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action_logs
    ADD CONSTRAINT action_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 5054 (class 2606 OID 33392)
-- Name: announcements announcements_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 5055 (class 2606 OID 33233)
-- Name: announcements announcements_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5056 (class 2606 OID 33238)
-- Name: announcements announcements_target_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_target_role_fkey FOREIGN KEY (target_role) REFERENCES public.roles(id);


--
-- TOC entry 5072 (class 2606 OID 33530)
-- Name: file_exchange_files file_exchange_files_library_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_exchange_files
    ADD CONSTRAINT file_exchange_files_library_book_id_fkey FOREIGN KEY (library_book_id) REFERENCES public.library_books(id);


--
-- TOC entry 5073 (class 2606 OID 33525)
-- Name: file_exchange_files file_exchange_files_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_exchange_files
    ADD CONSTRAINT file_exchange_files_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semesters(id) ON DELETE CASCADE;


--
-- TOC entry 5074 (class 2606 OID 33535)
-- Name: file_exchange_files file_exchange_files_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_exchange_files
    ADD CONSTRAINT file_exchange_files_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id);


--
-- TOC entry 5064 (class 2606 OID 33328)
-- Name: file_submissions file_submissions_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_submissions
    ADD CONSTRAINT file_submissions_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- TOC entry 5065 (class 2606 OID 33338)
-- Name: file_submissions file_submissions_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_submissions
    ADD CONSTRAINT file_submissions_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teachers(id) ON DELETE SET NULL;


--
-- TOC entry 5066 (class 2606 OID 33333)
-- Name: file_submissions file_submissions_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_submissions
    ADD CONSTRAINT file_submissions_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 5057 (class 2606 OID 33399)
-- Name: ideas ideas_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ideas
    ADD CONSTRAINT ideas_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 5058 (class 2606 OID 33259)
-- Name: ideas ideas_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ideas
    ADD CONSTRAINT ideas_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5060 (class 2606 OID 33287)
-- Name: ideas_likes ideas_likes_ideas_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ideas_likes
    ADD CONSTRAINT ideas_likes_ideas_id_fkey FOREIGN KEY (ideas_id) REFERENCES public.ideas(id) ON DELETE CASCADE;


--
-- TOC entry 5061 (class 2606 OID 33282)
-- Name: ideas_likes ideas_likes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ideas_likes
    ADD CONSTRAINT ideas_likes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5059 (class 2606 OID 33264)
-- Name: ideas ideas_moder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ideas
    ADD CONSTRAINT ideas_moder_id_fkey FOREIGN KEY (moder_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 5062 (class 2606 OID 33386)
-- Name: library_books library_books_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.library_books
    ADD CONSTRAINT library_books_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 5063 (class 2606 OID 33308)
-- Name: library_books library_books_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.library_books
    ADD CONSTRAINT library_books_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 5067 (class 2606 OID 33429)
-- Name: library_favorites library_favorites_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.library_favorites
    ADD CONSTRAINT library_favorites_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.library_books(id) ON DELETE CASCADE;


--
-- TOC entry 5068 (class 2606 OID 33424)
-- Name: library_favorites library_favorites_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.library_favorites
    ADD CONSTRAINT library_favorites_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5053 (class 2606 OID 33214)
-- Name: moderators moderators_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moderators
    ADD CONSTRAINT moderators_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5070 (class 2606 OID 33477)
-- Name: semester_days semester_days_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semester_days
    ADD CONSTRAINT semester_days_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semesters(id) ON DELETE CASCADE;


--
-- TOC entry 5051 (class 2606 OID 33179)
-- Name: students students_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5052 (class 2606 OID 33196)
-- Name: teachers teachers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5071 (class 2606 OID 33504)
-- Name: timetables timetables_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timetables
    ADD CONSTRAINT timetables_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semesters(id) ON DELETE CASCADE;


--
-- TOC entry 5049 (class 2606 OID 33163)
-- Name: users users_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE SET NULL;


--
-- TOC entry 5050 (class 2606 OID 33158)
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


-- Completed on 2026-05-25 08:30:26

--
-- PostgreSQL database dump complete
--

\unrestrict beJG0bXAMf5Szgf5PpCZI1LNFhQQlVtq3dKkt1AUEv1nCCpDYuolNoWRfV9Jlpo

