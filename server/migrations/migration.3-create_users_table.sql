CREATE SEQUENCE user_id_seq;

CREATE TABLE user (
    id bigint PRIMARY KEY DEFAULT nextval('user_id_seq'),
    email text NOT NULL,
    user_password text NOT NULL,
    hangouts bigint[],
);

ALTER SEQUENCE user_id_seq
OWNED BY user.id;

-- CREATE INDEX user_password ON user USING btree(user_password);
CREATE INDEX email ON user USING btree(email);

ALTER TABLE _Hangout
ADD COLUMN creater TEXT;