package lexer

import (
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"strings"
	"testing"
)

var Skipped = []TokenType{
	NewRegexpTokenType(-1, "\\s", false, 0),
	NewRegexpTokenType(-1, "#.*\n", false, 0),
	NewRegexpTokenType(-1, "--.*\n", false, 0),
	NewRegexpTokenType(-1, "/\\*.*\\*/\n", false, 0),
}

func TestPatternTokenType(t *testing.T) {

	schema := "CREATE table `t1` (`id` inthogee)"

	l := NewLexer(strings.NewReader(schema),
		[]TokenType{
			NewSimpleTokenType(1, "CREATE", true, 1),
			NewSimpleTokenType(2, "TABLE", true, 1),
		},
		Skipped,
	)

	t1, err := l.Scan()
	t2, err := l.Scan()

	require.NoError(t, err)
	assert.Equal(t, 1, int(t1.Type.GetID()))
	assert.Equal(t, "CREATE", t1.Literal)
	assert.Equal(t, 2, int(t2.Type.GetID()))
	assert.Equal(t, "TABLE", t2.Literal)
}

func TestRegexTokenType(t *testing.T) {

	schema := "REFERENCES tbl MATCH FULL"

	l := NewLexer(strings.NewReader(schema),
		[]TokenType{
			NewSimpleTokenType(1, "REFERENCES", true, 1),
			NewRegexpTokenType(2, "[a-zA-Z0-9]+", true, 2),
			NewRegexpTokenType(3, "MATCH (FULL|PARTIAL)", true, 1),
		},
		Skipped,
	)

	t1, err := l.Scan()
	t2, err := l.Scan()
	t3, err := l.Scan()

	require.NoError(t, err)
	assert.Equal(t, 1, int(t1.Type.GetID()))
	assert.Equal(t, "REFERENCES", t1.Literal)
	assert.Equal(t, 2, int(t2.Type.GetID()))
	assert.Equal(t, "tbl", t2.Literal)
	assert.Equal(t, 3, int(t3.Type.GetID()))
	assert.Equal(t, "MATCH FULL", t3.Literal)
	assert.Equal(t, "FULL", t3.Submatches[0])
}

func TestBalancedParenthesesTokenType(t *testing.T) {

	schema := "t1 (CONSTRAINT `cnst` CHECK (age > (1+2) * (3+4)))"

	l := NewLexer(strings.NewReader(schema),
		[]TokenType{
			NewSimpleTokenType(3, "(", false, 2),
			NewSimpleTokenType(4, "CONSTRAINT", true, 1),
			NewSimpleTokenType(5, "CHECK", true, 1),
			NewSimpleTokenType(7, ")", false, 1),
			NewRegexpTokenType(1, "[a-zA-Z0-9]+", false, 1),
			NewRegexpTokenType(2, "`([a-zA-Z0-9]+?)`", false, 1),
		},
		Skipped,
	)

	t1, err := l.Scan()
	t2, err := l.Scan()
	t3, err := l.Scan()
	t4, err := l.Scan()
	t5, err := l.Scan()
	t6, err := l.Scan()
	t7, err := l.Scan()

	require.NoError(t, err)
	assert.Equal(t, 1, int(t1.Type.GetID()))
	assert.Equal(t, "t1", t1.Literal)
	assert.Equal(t, 3, int(t2.Type.GetID()))
	assert.Equal(t, "(", t2.Literal)
	assert.Equal(t, 4, int(t3.Type.GetID()))
	assert.Equal(t, "CONSTRAINT", t3.Literal)
	assert.Equal(t, 2, int(t4.Type.GetID()))
	assert.Equal(t, "`cnst`", t4.Literal)
	assert.Equal(t, 5, int(t5.Type.GetID()))
	assert.Equal(t, "CHECK", t5.Literal)
	assert.Equal(t, 6, int(t6.Type.GetID()))
	assert.Equal(t, "(age > (1+2) * (3+4))", t6.Literal)
	assert.Equal(t, 7, int(t7.Type.GetID()))
	assert.Equal(t, ")", t7.Literal)
}
