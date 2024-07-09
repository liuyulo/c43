ALTER TABLE users DROP COLUMN name;
CREATE INDEX stocklists_user_id_index ON stocklists (user_id);
ALTER TABLE portfolios ADD CONSTRAINT portfolios_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE stocklists ADD CONSTRAINT stocklists_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE transactions ADD CONSTRAINT transactions_ref_user_from FOREIGN KEY (user_from) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE transactions ADD CONSTRAINT transactions_ref_user_to FOREIGN KEY (user_to) REFERENCES users (id) ON DELETE NO ACTION;
