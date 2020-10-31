CREATE SEQUENCE hangout_id_seq;

CREATE TABLE hangout (
    id bigint PRIMARY KEY DEFAULT nextval('hangout_id_seq'),
    title text NOT NULL,
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NULL
);

ALTER SEQUENCE hangout_id_seq
OWNED BY hangout.id;

CREATE INDEX hangout_start_time ON hangout USING btree(start_time);
CREATE INDEX hangout_end_time ON hangout USING btree(end_time);



