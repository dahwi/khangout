CREATE SEQUENCE kzoo_user_id_seq;

CREATE TABLE kzoo_user (
    id bigint PRIMARY KEY DEFAULT nextval('kzoo_user_id_seq'),
    email text NOT NULL,
    user_password text NOT NULL,
    UNIQUE(email)
);

ALTER SEQUENCE kzoo_user_id_seq
OWNED BY kzoo_user.id;

ALTER TABLE _Hangout
ADD COLUMN creater TEXT NOT NULL,
ADD CONSTRAINT _Hangout_creater_fkey
FOREIGN KEY (creater) REFERENCES kzoo_user(email) ON UPDATE CASCADE ON DELETE CASCADE;


CREATE INDEX _Hangout_creater ON _Hangout USING btree(creater);

grant all on kzoo_user, kzoo_user_id_seq to nikhil;
grant all on kzoo_user, kzoo_user_id_seq to binny;