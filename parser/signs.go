package parser

var Signs = map[int]string{
	LP:        "(",
	RP:        ")",
	LCB:       "{",
	RCB:       "}",
	COMMA:     ",",
	SEMICOLON: ";",
	EQ:        "=",
	DOT:       ".",
	GT:        ">",
	GTE:       ">=",
	LT:        "<",
	LTE:       "<=",
	NE:        "!=",
	NE2:       "<>",
	NSEQ:      "<=>",
	TILDE:     "~",
	AND:       "&",
	AND2:      "&&",
	OR:        "|",
	OR2:       "||",
	RSHIFT:    "<<",
	LSHIFT:    ">>",
	PLUS:      "+",
	MINUS:     "-",
	MULT:      "*",
	DIV:       "/",
	MOD:       "%",
	HAT:       "^",
	EXCL:      "!",
	QSTN:      "?",
}

var Literals = map[int][]string{
	BIT_STR:    {`b'[01]+'`},
	BIT_NUM:    {`0b[01]+`},
	INT_NUM:    {`[0-9]+`},
	HEX_STR:    {`[xX]'[0-9A-F]+'`},
	HEX_NUM:    {`0x[0-9A-F]+`},
	FLOAT_NUM:  {`[+-]?[0-9]+(\.[0-9]+)?(E[+-]?[0-9]+)?`},
	STRING:     {`'(?:[^'\\]|.)*?'`},
	IDENTIFIER: {`[a-zA-Z_][a-zA-Z0-9_]*`},
	LOCAL_VAR: {
		"@[a-zA-Z_][a-zA-Z0-9_]*",
		"@`[a-zA-Z_][a-zA-Z0-9_]*`",
	},
	GLOBAL_VAR: {
		"@@(GLOBAL\\.|SESSION\\.)?[a-zA-Z_][a-zA-Z0-9_]*",
		"@@`(GLOBAL\\.|SESSION\\.)?[a-zA-Z_][a-zA-Z0-9_]*`",
	},
	QUOTED_IDENTIFIER: {"`([a-zA-Z_][a-zA-Z0-9_]*)`"},
}

var Skipped = []string{
	"\\s",
	"#.*\n",
	"--.*\n",
	"/\\*.*\\*/",
}
