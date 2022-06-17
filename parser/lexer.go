package parser

import (
	"errors"
	"fmt"
	"github.com/kota65535/sql-parser/lexer"
	"io"
	"os"
	"strings"
)

type Parser struct {
	lexer     *lexer.Lexer
	lastToken *lexer.Token
	result    []Statement
}

func NewParser(reader io.Reader) *Parser {
	l := lexer.NewLexer(reader,
		// Token types.
		// A keyword consists of at least one token.
		// Keywords that contain "NOT" token can lead to fail parse error in column options for example:
		//
		//   { [NOT] NULL | CHECK(...) [NOT] ENFORCED } ...
		//
		// And assume the following statement:
		//
		//   CHECK(...) NOT NULL
		//
		// In this case, shift takes precedence and ENFORCED token is expected, so NULL token causes parse error.
		// To prevent this, we treat keyword containing "NOT" (ex: "NOT NULL") as a single token, like "NOT\s+NULL".
		[]lexer.TokenType{
			// Signs
			lexer.NewSimpleTokenType(LP, "(", false, 1),
			lexer.NewSimpleTokenType(RP, ")", false, 1),
			lexer.NewSimpleTokenType(COMMA, ",", false, 1),
			lexer.NewSimpleTokenType(SEMICOLON, ";", false, 1),
			lexer.NewSimpleTokenType(EQ, "=", false, 1),
			lexer.NewSimpleTokenType(DOT, ".", false, 1),
			// Statement
			lexer.NewSimpleTokenType(CREATE, "CREATE", true, 1),
			lexer.NewSimpleTokenType(USE, "USE", true, 1),
			lexer.NewSimpleTokenType(TEMPORARY, "TEMPORARY", true, 1),
			lexer.NewSimpleTokenType(DATABASE, "DATABASE", true, 1),
			lexer.NewSimpleTokenType(SCHEMA, "SCHEMA", true, 1),
			lexer.NewRegexpTokenType(IF_NOT_EXISTS, "IF\\s+NOT\\s+EXISTS", true, 1),
			lexer.NewSimpleTokenType(TABLE, "TABLE", true, 1),
			lexer.NewSimpleTokenType(DEFAULT, "DEFAULT", true, 1),
			lexer.NewSimpleTokenType(CHARACTER, "CHARACTER", true, 1),
			lexer.NewSimpleTokenType(SET, "SET", true, 1),
			lexer.NewSimpleTokenType(CHARSET, "CHARSET", true, 1),
			lexer.NewSimpleTokenType(COLLATE, "COLLATE", true, 1),
			lexer.NewSimpleTokenType(ENCRYPTION, "ENCRYPTION", true, 1),
			// Numeric Types
			lexer.NewSimpleTokenType(BIT, "BIT", true, 1),
			lexer.NewSimpleTokenType(TINYINT, "TINYINT", true, 1),
			lexer.NewSimpleTokenType(BOOL, "BOOL", true, 1),
			lexer.NewSimpleTokenType(BOOLEAN, "BOOLEAN", true, 1),
			lexer.NewSimpleTokenType(SMALLINT, "SMALLINT", true, 1),
			lexer.NewSimpleTokenType(MEDIUMINT, "MEDIUMINT", true, 1),
			lexer.NewSimpleTokenType(INT, "INT", true, 1),
			lexer.NewSimpleTokenType(INTEGER, "INTEGER", true, 1),
			lexer.NewSimpleTokenType(BIGINT, "BIGINT", true, 1),
			lexer.NewSimpleTokenType(UNSIGNED, "UNSIGNED", true, 1),
			lexer.NewSimpleTokenType(ZEROFILL, "ZEROFILL", true, 1),
			lexer.NewSimpleTokenType(DECIMAL, "DECIMAL", true, 1),
			lexer.NewSimpleTokenType(DEC, "DEC", true, 1),
			lexer.NewSimpleTokenType(FIXED, "FIXED", true, 1),
			lexer.NewSimpleTokenType(FLOAT, "FLOAT", true, 1),
			lexer.NewSimpleTokenType(DOUBLE, "DOUBLE", true, 1),
			lexer.NewSimpleTokenType(REAL, "REAL", true, 1),
			// DateAndTime Types
			lexer.NewSimpleTokenType(DATE, "DATE", true, 1),
			lexer.NewSimpleTokenType(TIME, "TIME", true, 1),
			lexer.NewSimpleTokenType(DATETIME, "DATETIME", true, 1),
			lexer.NewSimpleTokenType(TIMESTAMP, "TIMESTAMP", true, 1),
			lexer.NewSimpleTokenType(YEAR, "YEAR", true, 1),
			// String Types
			// TODO: National
			lexer.NewSimpleTokenType(CHAR, "CHAR", true, 1),
			lexer.NewSimpleTokenType(VARCHAR, "VARCHAR", true, 1),
			lexer.NewSimpleTokenType(BINARY, "BINARY", true, 1),
			lexer.NewSimpleTokenType(VARBINARY, "VARBINARY", true, 1),
			lexer.NewSimpleTokenType(TINYBLOB, "TINYBLOB", true, 1),
			lexer.NewSimpleTokenType(TINYTEXT, "TINYTEXT", true, 1),
			lexer.NewSimpleTokenType(BLOB, "BLOB", true, 1),
			lexer.NewSimpleTokenType(TEXT, "TEXT", true, 1),
			lexer.NewSimpleTokenType(MEDIUMBLOB, "MEDIUMBLOB", true, 1),
			lexer.NewSimpleTokenType(MEDIUMTEXT, "MEDIUMTEXT", true, 1),
			lexer.NewSimpleTokenType(LONGBLOB, "LONGBLOB", true, 1),
			lexer.NewSimpleTokenType(LONGTEXT, "LONGTEXT", true, 1),
			lexer.NewSimpleTokenType(ENUM, "ENUM", true, 1),

			// Other Types
			lexer.NewSimpleTokenType(JSON, "JSON", true, 1),
			lexer.NewSimpleTokenType(GEOMETRY, "GEOMETRY", true, 1),
			lexer.NewSimpleTokenType(POINT, "POINT", true, 1),
			lexer.NewSimpleTokenType(LINESTRING, "LINESTRING", true, 1),
			lexer.NewSimpleTokenType(POLYGON, "POLYGON", true, 1),
			lexer.NewSimpleTokenType(MULTIPOINT, "MULTIPOINT", true, 1),
			lexer.NewSimpleTokenType(MULTILINESTRING, "MULTILINESTRING", true, 1),
			lexer.NewSimpleTokenType(MULTIPOLYGON, "MULTIPOLYGON", true, 1),
			lexer.NewSimpleTokenType(GEOMETRYCOLLECTION, "GEOMETRYCOLLECTION", true, 1),

			// Column Options
			lexer.NewSimpleTokenType(NULL, "NULL", true, 1),
			lexer.NewRegexpTokenType(NOT_NULL, "NOT\\s+NULL", true, 1),
			lexer.NewSimpleTokenType(VISIBLE, "VISIBLE", true, 1),
			lexer.NewSimpleTokenType(INVISIBLE, "INVISIBLE", true, 1),
			lexer.NewSimpleTokenType(ENFORCED, "ENFORCED", true, 1),
			lexer.NewRegexpTokenType(NOT_ENFORCED, "NOT\\s+ENFORCED", true, 1),
			lexer.NewSimpleTokenType(AUTO_INCREMENT, "AUTO_INCREMENT", true, 1),
			lexer.NewSimpleTokenType(UNIQUE, "UNIQUE", true, 1),
			lexer.NewSimpleTokenType(PRIMARY, "PRIMARY", true, 1),
			lexer.NewSimpleTokenType(KEY, "KEY", true, 1),
			lexer.NewSimpleTokenType(INDEX, "INDEX", true, 1),
			lexer.NewSimpleTokenType(ASC, "ASC", true, 1),
			lexer.NewSimpleTokenType(DESC, "DESC", true, 1),
			lexer.NewSimpleTokenType(USING, "USING", true, 1),
			lexer.NewSimpleTokenType(WITH, "WITH", true, 1),
			lexer.NewSimpleTokenType(PARSER, "PARSER", true, 1),
			lexer.NewSimpleTokenType(COMMENT, "COMMENT", true, 1),
			lexer.NewSimpleTokenType(FULLTEXT, "FULLTEXT", true, 1),
			lexer.NewSimpleTokenType(FOREIGN, "FOREIGN", true, 1),
			lexer.NewSimpleTokenType(REFERENCES, "REFERENCES", true, 1),
			lexer.NewSimpleTokenType(MATCH, "MATCH", true, 1),
			lexer.NewRegexpTokenType(ON_DELETE, "ON\\s+DELETE", true, 1),
			lexer.NewRegexpTokenType(ON_UPDATE, "ON\\s+UPDATE", true, 1),
			lexer.NewSimpleTokenType(CURRENT_TIMESTAMP, "CURRENT_TIMESTAMP", true, 1),
			lexer.NewSimpleTokenType(CASCADE, "CASCADE", true, 1),
			lexer.NewSimpleTokenType(RESTRICT, "RESTRICT", true, 1),
			lexer.NewRegexpTokenType(NO_ACTION, "NO\\s+ACTION", true, 1),
			lexer.NewSimpleTokenType(CONSTRAINT, "CONSTRAINT", true, 1),
			lexer.NewSimpleTokenType(CHECK, "CHECK", true, 1),
			lexer.NewSimpleTokenType(KEY_BLOCK_SIZE, "KEY_BLOCK_SIZE", true, 1),
			lexer.NewSimpleTokenType(SRID, "SRID", true, 1),
			lexer.NewSimpleTokenType(GENERATED, "GENERATED", true, 1),
			lexer.NewSimpleTokenType(ALWAYS, "ALWAYS", true, 1),
			lexer.NewSimpleTokenType(AS, "AS", true, 1),
			lexer.NewSimpleTokenType(VIRTUAL, "VIRTUAL", true, 1),
			lexer.NewSimpleTokenType(STORED, "STORED", true, 1),

			// Table Options
			lexer.NewSimpleTokenType(AUTOEXTENDED_SIZE, "AUTOEXTENDED_SIZE", true, 1),
			lexer.NewSimpleTokenType(AVG_ROW_LENGTH, "AVG_ROW_LENGTH", true, 1),
			lexer.NewSimpleTokenType(CHECKSUM, "CHECKSUM", true, 1),
			lexer.NewSimpleTokenType(COMPRESSION, "COMPRESSION", true, 1),
			lexer.NewSimpleTokenType(CONNECTION, "CONNECTION", true, 1),
			lexer.NewSimpleTokenType(DELAY_KEY_WRITE, "DELAY_KEY_WRITE", true, 1),
			lexer.NewSimpleTokenType(DATA, "DATA", true, 1),
			lexer.NewSimpleTokenType(DIRECTORY, "DIRECTORY", true, 1),
			lexer.NewSimpleTokenType(ENGINE, "ENGINE", true, 1),
			lexer.NewSimpleTokenType(ENGINE_ATTRIBUTE, "ENGINE_ATTRIBUTE", true, 1),
			lexer.NewSimpleTokenType(INSERT_METHOD, "INSERT_METHOD", true, 1),
			lexer.NewSimpleTokenType(MAX_ROWS, "MAX_ROWS", true, 1),
			lexer.NewSimpleTokenType(MIN_ROWS, "MIN_ROWS", true, 1),
			lexer.NewSimpleTokenType(PACK_KEYS, "PACK_KEYS", true, 1),
			lexer.NewSimpleTokenType(PASSWORD, "PASSWORD", true, 1),
			lexer.NewSimpleTokenType(ROW_FORMAT, "ROW_FORMAT", true, 1),
			lexer.NewSimpleTokenType(SECONDARY_ENGINE_ATTRIBUTE, "SECONDARY_ENGINE_ATTRIBUTE", true, 1),
			lexer.NewSimpleTokenType(STATS_AUTO_RECALC, "STATS_AUTO_RECALC", true, 1),
			lexer.NewSimpleTokenType(STATS_PERSISTENT, "STATS_PERSISTENT", true, 1),
			lexer.NewSimpleTokenType(STATS_SAMPLE_PAGES, "STATS_SAMPLE_PAGES", true, 1),
			lexer.NewSimpleTokenType(TABLESPACE, "TABLESPACE", true, 1),
			lexer.NewSimpleTokenType(STORAGE, "STORAGE", true, 1),
			lexer.NewSimpleTokenType(UNION, "UNION", true, 1),

			// Partition Options
			lexer.NewSimpleTokenType(PARTITION, "PARTITION", true, 1),
			lexer.NewSimpleTokenType(BY, "BY", true, 1),
			lexer.NewSimpleTokenType(PARTITIONS, "PARTITIONS", true, 1),
			lexer.NewSimpleTokenType(SUBPARTITION, "SUBPARTITION", true, 1),
			lexer.NewSimpleTokenType(SUBPARTITIONS, "SUBPARTITIONS", true, 1),
			lexer.NewSimpleTokenType(LINEAR, "LINEAR", true, 1),
			lexer.NewSimpleTokenType(HASH, "HASH", true, 1),
			lexer.NewSimpleTokenType(COLUMNS, "COLUMNS", true, 1),
			lexer.NewSimpleTokenType(ALGORITHM, "ALGORITHM", true, 1),
			lexer.NewSimpleTokenType(RANGE, "RANGE", true, 1),
			lexer.NewSimpleTokenType(LIST, "LIST", true, 1),
			lexer.NewSimpleTokenType(VALUES, "VALUES", true, 1),
			lexer.NewSimpleTokenType(LESS, "LESS", true, 1),
			lexer.NewSimpleTokenType(THAN, "THAN", true, 1),
			lexer.NewSimpleTokenType(MAXVALUE, "MAXVALUE", true, 1),
			lexer.NewSimpleTokenType(IN, "IN", true, 1),

			lexer.NewSimpleTokenType(TRUE, "TRUE", true, 1),
			lexer.NewSimpleTokenType(FALSE, "FALSE", true, 1),
			lexer.NewRegexpTokenType(BIT_STR, `b'[01]+'`, true, 2),
			lexer.NewRegexpTokenType(BIT_NUM, `0b[01]+`, true, 2),
			lexer.NewRegexpTokenType(INT_NUM, `[0-9]+`, true, 2),
			lexer.NewRegexpTokenType(HEX_STR, `[X]'[0-9A-F]+'`, true, 2),
			lexer.NewRegexpTokenType(HEX_NUM, `0x[0-9A-F]+`, true, 2),
			lexer.NewRegexpTokenType(FLOAT_NUM, `[+-]?[0-9]*(\.[0-9]+)?`, false, 2),
			lexer.NewRegexpTokenType(STRING, `'(.*)'`, false, 2),
			lexer.NewRegexpTokenType(IDENTIFIER, `[a-zA-Z_][a-zA-Z0-9_]*`, false, 2),
			lexer.NewRegexpTokenType(QUOTED_IDENTIFIER, "`([a-zA-Z_][a-zA-Z0-9_]*)`", false, 2),
		},
		// Skipped token types
		[]lexer.TokenType{
			lexer.NewRegexpTokenType(-1, "\\s", false, 0),
			lexer.NewRegexpTokenType(-1, "#.*\n", false, 0),
			lexer.NewRegexpTokenType(-1, "--.*\n", false, 0),
			lexer.NewRegexpTokenType(-1, "/\\*.*\\*/", false, 0),
		},
	)

	return &Parser{
		lexer: l,
	}
}

func (p *Parser) Parse() ([]Statement, error) {
	ret := yyParse(p)
	if ret != 0 {
		return nil, errors.New("parse failed")
	}
	return p.result, nil
}

func (p *Parser) Lex(lval *yySymType) int {
	token, err := p.lexer.Scan()
	if err != nil {
		if e, ok := err.(lexer.UnknownTokenError); ok {
			fmt.Fprintln(os.Stderr, e.Error()+":")
			fmt.Fprintln(os.Stderr, p.lexer.GetLastLine())
			fmt.Fprintln(os.Stderr, strings.Repeat(" ", e.Position.Column)+strings.Repeat("^", len(e.Literal)))
		}
		p.Error(err.Error())
	}
	if token == nil {
		return 0
	}

	lval.token = token

	p.lastToken = token

	fmt.Fprintf(os.Stderr, "Token '%s' as %s\n", token.Literal, token.Type.GetID())

	return int(token.Type.GetID())
}

func (p *Parser) Error(e string) {
	fmt.Fprintln(os.Stderr, e+":")
	fmt.Fprintln(os.Stderr, p.lexer.GetLastLine())
	fmt.Fprintln(os.Stderr, strings.Repeat(" ", p.lastToken.Position.Column)+strings.Repeat("^", len(p.lastToken.Literal)))
}
