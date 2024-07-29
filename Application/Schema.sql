CREATE TABLE users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    email TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    locked_at TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    failed_login_attempts INT DEFAULT 0 NOT NULL
);
CREATE TABLE portfolios (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    user_id UUID NOT NULL,
    portfolio_name TEXT NOT NULL,
    cash INT DEFAULT 0 NOT NULL,
    UNIQUE(user_id, portfolio_name)
);
CREATE TABLE portfolio_holds (
    portfolio_id UUID NOT NULL,
    symbol TEXT NOT NULL,
    amount INT NOT NULL,
    PRIMARY KEY(symbol, portfolio_id)
);
CREATE TABLE stocklists (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL UNIQUE,
    user_id UUID NOT NULL,
    list_name TEXT NOT NULL,
    is_public BOOLEAN DEFAULT false NOT NULL,
    category TEXT NOT NULL,
    UNIQUE(user_id, list_name)
);
CREATE INDEX stocklists_user_id_index ON stocklists (user_id);
CREATE TABLE transactions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    amount INT NOT NULL,
    portfolio_from UUID NOT NULL,
    portfolio_to UUID NOT NULL,
    symbol TEXT NOT NULL
);
CREATE INDEX transactions_created_at_index ON transactions (created_at);
CREATE TYPE status AS ENUM ('ACCEPTED', 'REJECTED', 'PENDING');
CREATE TABLE friends (
    user_from UUID NOT NULL,
    user_to UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    status status,
    PRIMARY KEY(user_from, user_to)
);
CREATE INDEX friends_user_from_index ON friends (user_from);
CREATE INDEX friends_user_to_index ON friends (user_to);
CREATE TABLE accesses (
    user_id UUID NOT NULL,
    owner_id UUID NOT NULL,
    list_id UUID NOT NULL,
    PRIMARY KEY(list_id, owner_id, user_id)
);
CREATE INDEX accesses_user_id_index ON accesses (user_id);
CREATE TABLE reviews (
    user_id UUID NOT NULL,
    list_id UUID NOT NULL,
    content TEXT NOT NULL,
    PRIMARY KEY(user_id, list_id)
);
CREATE INDEX reviews_user_id_index ON reviews (user_id);
CREATE INDEX reviews_list_id_index ON reviews (list_id);
CREATE TABLE list_contains (
    list_id UUID NOT NULL,
    symbol TEXT NOT NULL,
    amount INT NOT NULL,
    PRIMARY KEY(list_id, symbol)
);
CREATE TABLE stocks (
    symbol TEXT PRIMARY KEY NOT NULL
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
CREATE INDEX transactions_portfolio_from_index ON transactions (portfolio_from);
CREATE INDEX transactions_portfolio_to_index ON transactions (portfolio_to);
ALTER TABLE accesses ADD CONSTRAINT accesses_ref_list_id FOREIGN KEY (list_id) REFERENCES stocklists (id) ON DELETE NO ACTION;
ALTER TABLE accesses ADD CONSTRAINT accesses_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE friends ADD CONSTRAINT friends_ref_user_from FOREIGN KEY (user_from) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE friends ADD CONSTRAINT friends_ref_user_to FOREIGN KEY (user_to) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE history ADD CONSTRAINT history_ref_symbol FOREIGN KEY (symbol) REFERENCES stocks ON DELETE NO ACTION;
ALTER TABLE list_contains ADD CONSTRAINT list_contains_ref_list_id FOREIGN KEY (list_id) REFERENCES stocklists (id) ON DELETE NO ACTION;
ALTER TABLE list_contains ADD CONSTRAINT list_contains_ref_symbol FOREIGN KEY (symbol) REFERENCES stocks ON DELETE NO ACTION;
ALTER TABLE portfolio_holds ADD CONSTRAINT portfolio_holds_ref_portfolio_id FOREIGN KEY (portfolio_id) REFERENCES portfolios (id) ON DELETE NO ACTION;
ALTER TABLE portfolio_holds ADD CONSTRAINT portfolio_holds_ref_symbol FOREIGN KEY (symbol) REFERENCES stocks ON DELETE NO ACTION;
ALTER TABLE portfolios ADD CONSTRAINT portfolios_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE reviews ADD CONSTRAINT reviews_ref_list_id FOREIGN KEY (list_id) REFERENCES stocklists (id) ON DELETE NO ACTION;
ALTER TABLE reviews ADD CONSTRAINT reviews_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE stocklists ADD CONSTRAINT stocklists_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE transactions ADD CONSTRAINT transactions_ref_portfolio_from FOREIGN KEY (portfolio_from) REFERENCES portfolios (id) ON DELETE NO ACTION;
ALTER TABLE transactions ADD CONSTRAINT transactions_ref_portfolio_to FOREIGN KEY (portfolio_to) REFERENCES portfolios (id) ON DELETE NO ACTION;
ALTER TABLE transactions ADD CONSTRAINT transactions_ref_symbol FOREIGN KEY (symbol) REFERENCES stocks ON DELETE NO ACTION;
