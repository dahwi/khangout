CREATE SEQUENCE _Hangout_id_seq;

CREATE TABLE _Hangout (
    id bigint PRIMARY KEY DEFAULT nextval('_Hangout_id_seq'),
    title text NOT NULL,
    start_time text NOT NULL,
    end_time text NOT NULL
);

ALTER SEQUENCE _Hangout_id_seq
OWNED BY _Hangout.id;

CREATE INDEX _Hangout_start_time ON _Hangout USING btree(start_time);
CREATE INDEX _Hangout_end_time ON _Hangout USING btree(end_time);



