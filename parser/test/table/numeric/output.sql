CREATE TABLE `t1`
(
    `bit1`       bit,
    `bit2`       bit(1)                          NOT NULL DEFAULT 0b001,
    `tinyint1`   tinyint,
    `tinyint2`   tinyint(1) unsigned zerofill    NOT NULL DEFAULT 1,
    `bool1`      tinyint(1),
    `bool2`      tinyint(1)                      NOT NULL DEFAULT TRUE,
    `smallint1`  smallint,
    `smallint2`  smallint(1) unsigned zerofill   NOT NULL DEFAULT 0x123,
    `mediumint1` mediumint,
    `mediumint2` mediumint(1) unsigned zerofill  NOT NULL DEFAULT 0x0123,
    `int1`       int,
    `int2`       int(1) unsigned zerofill        NOT NULL DEFAULT 1,
    `bigint1`    bigint,
    `bigint2`    bigint(1) unsigned zerofill     NOT NULL DEFAULT 1,
    `decimal1`   decimal,
    `decimal2`   decimal(2),
    `decimal3`   decimal(2, 1) unsigned zerofill NOT NULL DEFAULT 1,
    `float1`     float,
    `float2`     float(2, 1) unsigned zerofill   NOT NULL DEFAULT (rand() * rand()),
    `double1`    double,
    `double2`    double(2, 1) unsigned zerofill  NOT NULL DEFAULT 1.1,
    `double3`    double                          GENERATED ALWAYS AS (sqrt(`double1` * `double2`))
);