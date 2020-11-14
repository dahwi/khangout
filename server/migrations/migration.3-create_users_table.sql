CREATE TABLE kzoo_user (
    email text PRIMARY KEY NOT NULL,
    user_password text NOT NULL,
    hangouts bigint[]
);

ALTER TABLE _Hangout
ADD COLUMN creater text NOT NULL,
ADD COLUMN participants text[],
ADD CONSTRAINT _Hangout_creater_fkey
FOREIGN KEY (creater) REFERENCES kzoo_user(email) ON UPDATE CASCADE ON DELETE CASCADE;


CREATE INDEX _Hangout_creater ON _Hangout USING btree(creater);

grant all on kzoo_user, kzoo_user_id_seq to nikhil;
grant all on kzoo_user, kzoo_user_id_seq to binny;