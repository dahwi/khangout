CREATE SEQUENCE users_hangouts_id_seq;

CREATE TABLE users_hangouts (
  id bigint PRIMARY KEY DEFAULT nextval('users_hangouts_id_seq'),
  user_id bigint NOT NULL,
  hangout_id bigint NOT NULL,
  UNIQUE(user_id, hangout_id),
  FOREIGN KEY (user_id) REFERENCES users_hangouts(id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (hangout_id) REFERENCES _hangout(id) ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER SEQUENCE users_hangouts_id_seq
OWNED BY users_hangouts.id;