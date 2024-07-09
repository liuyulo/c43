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
    name TEXT NOT NULL,
    UNIQUE(user_id, name)
);
CREATE TABLE holdings (
    portfolio UUID NOT NULL,
    symbol TEXT NOT NULL,
    amount INT NOT NULL,
    PRIMARY KEY(portfolio, symbol)
);
CREATE TABLE stocklists (
    user_id UUID NOT NULL,
    name TEXT NOT NULL,
    is_public BOOLEAN DEFAULT false NOT NULL,
    category TEXT NOT NULL,
    PRIMARY KEY(user_id, name)
);
CREATE INDEX stocklists_user_id_index ON stocklists (user_id);
CREATE TABLE transactions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    user_from UUID DEFAULT NULL,
    user_to UUID DEFAULT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    symbol TEXT NOT NULL,
    amount TEXT NOT NULL
);
CREATE INDEX transactions_created_at_index ON transactions (created_at);
ALTER TABLE holdings ADD CONSTRAINT holdings_ref_portfolio FOREIGN KEY (portfolio) REFERENCES portfolios (id) ON DELETE NO ACTION;
ALTER TABLE portfolios ADD CONSTRAINT portfolios_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE stocklists ADD CONSTRAINT stocklists_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE transactions ADD CONSTRAINT transactions_ref_user_from FOREIGN KEY (user_from) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE transactions ADD CONSTRAINT transactions_ref_user_to FOREIGN KEY (user_to) REFERENCES users (id) ON DELETE NO ACTION;
