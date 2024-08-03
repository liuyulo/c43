CREATE TABLE users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    locked_at TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    failed_login_attempts INT DEFAULT 0 NOT NULL
);
CREATE TABLE portfolios (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    username TEXT NOT NULL,
    portfolio_name TEXT NOT NULL,
    cash REAL DEFAULT 0 NOT NULL,
    UNIQUE(username, portfolio_name)
);
CREATE TABLE stocks(
    symbol TEXT PRIMARY KEY NOT NULL
);
CREATE TABLE stocklists (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL UNIQUE,
    username TEXT NOT NULL,
    list_name TEXT NOT NULL,
    is_public BOOLEAN DEFAULT false NOT NULL,
    category TEXT NOT NULL,
    UNIQUE(username, list_name)
);
CREATE TABLE transactions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    amount REAL NOT NULL,
    price REAL NOT NULL,
    portfolio_id UUID NOT NULL,
    symbol TEXT NOT NULL
);
CREATE TYPE status AS ENUM ('ACCEPTED', 'REJECTED', 'PENDING');
CREATE TABLE friends (
    user_from TEXT NOT NULL,
    user_to TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    status status NOT NULL,
    PRIMARY KEY(user_from, user_to)
);
CREATE TABLE accesses (
    username TEXT NOT NULL,
    list_id UUID NOT NULL,
    PRIMARY KEY(list_id, username)
);
CREATE TABLE reviews (
    username TEXT NOT NULL,
    list_id UUID NOT NULL,
    content TEXT NOT NULL,
    PRIMARY KEY(username, list_id)
);
CREATE TABLE list_contains (
    list_id UUID NOT NULL,
    symbol TEXT NOT NULL,
    amount REAL NOT NULL,
    PRIMARY KEY(list_id, symbol)
);
CREATE TABLE history (
    "timestamp" DATE NOT NULL,
    open REAL,
    high REAL,
    low REAL,
    "close" REAL NOT NULL,
    volume INT NOT NULL,
    symbol TEXT NOT NULL,
    PRIMARY KEY(symbol, timestamp)
);

CREATE TABLE current_values(
    symbol TEXT PRIMARY KEY NOT NULL,
    "date" DATE NOT NULL,
    value REAL NOT NULL
);
CREATE TABLE portfolio_holds (
    portfolio_id UUID NOT NULL,
    symbol TEXT NOT NULL,
    amount REAL NOT NULL,
    PRIMARY KEY(symbol, portfolio_id)
);
CREATE TABLE prediction (
    symbol TEXT NOT NULL
    , date DATE NOT NULL
    , price REAL NOT NULL
    , PRIMARY KEY(symbol, date)
);
-- CREATE VIEW current_values AS SELECT DISTINCT ON (symbol) symbol, close AS value, timestamp as date FROM history ORDER BY symbol, timestamp DESC;
-- CREATE VIEW portfolio_holds AS SELECT portfolio_id, symbol, SUM(amount) AS amount FROM transactions GROUP BY portfolio_id, symbol;

-- TODO portfolio_holds must have amount > 0
-- TODO reviews: user_id must have access to list_id
-- TODO accesses: user_id can't own list_id
ALTER TABLE prediction ADD CONSTRAINT prediction_ref_symbol FOREIGN KEY (symbol) REFERENCES stocks ON DELETE NO ACTION;
ALTER TABLE accesses ADD CONSTRAINT accesses_ref_list_id FOREIGN KEY (list_id) REFERENCES stocklists ON DELETE CASCADE;
ALTER TABLE list_contains ADD CONSTRAINT list_contains_positive_amount CHECK (amount > 0);
ALTER TABLE list_contains ADD CONSTRAINT list_contains_ref_list_id FOREIGN KEY (list_id) REFERENCES stocklists (id) ON DELETE CASCADE;
ALTER TABLE list_contains ADD CONSTRAINT list_contains_ref_symbol FOREIGN KEY (symbol) REFERENCES stocks ON DELETE NO ACTION;
ALTER TABLE transactions ADD CONSTRAINT transactions_ref_symbol FOREIGN KEY (symbol) REFERENCES stocks ON DELETE NO ACTION;
ALTER TABLE portfolios ADD CONSTRAINT portfolio_cash_nonnegative CHECK (cash >= 0);
ALTER TABLE portfolios ADD CONSTRAINT portfolio_nonempty_name CHECK (portfolio_name <> '');
ALTER TABLE reviews ADD CONSTRAINT reviews_nonempty_content CHECK (content <> '');
ALTER TABLE reviews ADD CONSTRAINT reviews_ref_list_id FOREIGN KEY (list_id) REFERENCES stocklists (id) ON DELETE CASCADE;
ALTER TABLE stocklists ADD CONSTRAINT stocklists_nonempty_category CHECK (category <> '');
ALTER TABLE stocklists ADD CONSTRAINT stocklists_nonempty_name CHECK (list_name <> '');
ALTER TABLE transactions ADD CONSTRAINT transactions_amount_nonzero CHECK (amount <> 0);
ALTER TABLE transactions ADD CONSTRAINT transactions_price_positive CHECK (price > 0);
ALTER TABLE transactions ADD CONSTRAINT transactions_ref_portfolio_id FOREIGN KEY (portfolio_id) REFERENCES portfolios (id) ON DELETE CASCADE;
ALTER TABLE users ADD CONSTRAINT users_nonempty_email CHECK (email <> '');
