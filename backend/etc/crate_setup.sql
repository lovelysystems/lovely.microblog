CREATE TABLE blogpost (
    id string primary key,
    created timestamp,
    text string,
    creator string 
);

CREATE TABLE users (
    id string primary key, 
    name string, 
    password string 
);
