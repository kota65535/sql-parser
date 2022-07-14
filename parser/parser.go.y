%{
package parser

import (
	"github.com/kota65535/sql-parser/lexer"
	"github.com/imdario/mergo"
	"fmt"
	"strings"
)
%}

%union{
empty      struct{}
statements []Statement
statement Statement
partitionDefinitionList []PartitionDefinition
subpartitionDefinitionList []SubpartitionDefinition
keyPartList []KeyPart
list []interface{}
item interface{}
stringList []string
stringItem string
keyword bool
token *lexer.Token
}

%type<statements>
	Statements

%type<statement>
  	Statement
  	CreateDatabaseStatement
  	UseStatement
  	CreateTableStatement

%type<partitionDefinitionList>
	OptPartitionDefinitionList
	PartitionDefinitionList
	PartitionDefinitions

%type<subpartitionDefinitionList>
	OptSubpartitionDefinitionList
	SubpartitionDefinitionList
	SubpartitionDefinitions

%type<keyPartList>
	KeyPartList
	KeyParts

%type<list>
	CreateDefinitionList
	CreateDefinitions

%type<item>
  	// Database
  	DatabaseOptions
  	DatabaseOption

  	// Table
  	CreateDefinition
  	ColumnDefinition
	ColumnOptions
	ColumnOption
  	TableOptions
  	TableOption

  	// DataType
  	DataType
  	NumericType
  	IntegerType
  	FixedPointType
  	FloatingPointType
  	DateAndTimeType
  	StringType
  	JsonType
  	SpatialType
  	ReferenceDefinition
  	ReferenceOptions
  	ReferenceOption
  	CheckConstraintDefinition
  	CheckConstraintOptions
  	CheckConstraintOption

  	// Index, Constraints
  	IndexDefinition
    FullTextIndexDefinition
  	IndexOptions
  	IndexOption
    PrimaryKeyDefinition
    UniqueKeyDefinition
   	ForeignKeyDefinition
   	CheckConstraintDefinition
  	KeyPart

  	// Partitions
  	OptPartitionConfig
  	PartitionConfig
  	PartitionBy
  	OptSubpartitionBy
  	SubpartitionBy
  	PartitionByHash
  	PartitionByKey
  	PartitionByRange
  	PartitionByList
  	OptAlgorithm
  	Algorithm
  	PartitionDefinition
  	PartitionOptions
  	PartitionOption
 	SubpartitionDefinition

%type<stringList>
	StringLiteralList
	StringLiterals
	IdentifierList
	Identifiers
	ExpressionList
	Expressions
	OptExpressions
  	OptFieldLenAndScale
  	FieldLenAndScale
  	OptFieldLenAndOptScale
  	FieldLenAndOptScale
  	TableSpace
  	TableUnion
  	TableName
  	PartitionValues

%type<stringItem>
	// Literal etc
	Literal
	BooleanLiteral
	BitLiteral
	IntLiteral
	FloatLiteral
	HexLiteral
	StringLiteral
	Identifier
	BitExpression
	Expression
	BooleanPrimaryExpression
	PredicateExpression
	SimpleExpression
	MatchExpression
	OptSearchModifier
	SearchModifier
	CaseExpression
	WhenClauses
	WhenClause
	OptElseClause
	ElseClause
	OptIntroducer
	Introducer
	ComparisonOp
	IntervalExpression
	TimeUnit
	FunctionCall
	FunctionCallGeneric
	FunctionCallKeyword
	FunctionNameConflict
	FunctionNameOptionalBraces
	FunctionNameDatetimePrecision
	OptBraces
  	OptNot

  	// Database
  	DbName
  	DefaultCharset
  	DefaultCollate
	DefaultEncryption

	// Data type
  	OptFieldLen
  	FieldLen

	// Column Options
  	Nullability
  	DefaultDefinition
  	DefaultValue
  	Visibility
  	OptCharset
  	Charset
  	OptCollate
  	Collate
  	GeneratedAlwaysAs
  	GeneratedColumnType
  	Srid

  	// Index
  	OptIndexName
  	KeyOrder
	KeyBlockSize
  	IndexType
  	Parser
  	Comment

  	// Foreign Key
  	OptConstraint
  	Match
  	OnDelete
  	OnUpdate
  	ReferencialAction

  	// Check Constraint
  	Enforcement

  	// Table Options
	AutoExtendedSize
	AutoIncrementValue
	AvgRowLength
	Checksum
  	Compression
  	Connection
  	TableComment
  	DelayKeyWrite
  	DataDirectory
  	IndexDirectory
	Encryption
  	Engine
  	EngineAttribute
  	InsertMethod
  	MaxRows
  	MinRows
  	PackKeys
  	Password
  	RowFormat
  	SecondaryEngineAttribute
  	StatsAutoRecalc
  	StatsPersistent
  	StatsSamplePages
  	OptStorage
  	Storage

  	// Partition Options
  	OptPartitions
  	Partitions
  	OptSubpartitions
  	Subpartitions
  	PartitionStorageEngine
  	PartitionTableSpace

  	Variable

%type<keyword>
	// Sign
  	OptEq

	// Create Statements
  	OptTemporaryKwd
  	DatabaseKwd
  	OptIfNotExistsKwd

  	// Database Options
  	OptDefaultKwd
  	CharsetKwd

  	// Numeric Types
	BoolKwd
	IntKwd
	DecimalKwd
	DoubleKwd

	// String Types
  	CharKwd

  	// Column Options
  	OptUnsignedKwd
  	OptZerofillKwd
  	ColumnUniqueKwd
  	ColumnPrimaryKwd
  	GeneratedAlwaysAsKwd

	// Index
  	IndexKwd
  	FullTextIndexKwd
  	UniqueKeyKwd

  	// Foreign Key

  	// Partition Options
  	OptLinearKwd
  	PartitionStorageEngineKwd

  	NotKwd

%token<token>
	// Signs
  	LP
  	RP
  	COMMA
  	SEMICOLON
  	EQ
  	GT
  	GTE
  	LT
  	LTE
  	NE
  	NSEQ
  	AND
  	OR
  	XOR
  	IS
  	DOT
  	NOT
	PIPE
	BIT_AND
	RSHIFT
	LSHIFT
	PLUS
	MINUS
	MULT
	DIV
	MOD
	HAT
	LOCAL_VAR
	GLOBAL_VAR
	TILDE
	EXCL
	QSTN
	ROW
	LCB
	RCB
	AGAINST
	CASE
	WHEN
	THEN
	END
	ELSE
	IF
	UNKNOWN

  	// Create Statements
	CREATE
  	USE
  	TEMPORARY
  	DATABASE
  	SCHEMA
  	TABLE
  	EXISTS

  	// Database Options
  	DEFAULT
	CHARSET
  	CHARACTER
	SET
	COLLATE
  	ENCRYPTION

  	// Numeric Types
  	BIT
  	TINYINT
  	BOOL
  	BOOLEAN
  	SMALLINT
  	MEDIUMINT
  	INT
  	INTEGER
  	BIGINT
  	UNSIGNED
  	ZEROFILL
  	DECIMAL
  	DEC
  	FIXED
  	FLOAT
  	DOUBLE
  	REAL

	// String Types
  	CHAR
	VARCHAR
	BINARY
	VARBINARY
	TINYBLOB
	TINYTEXT
	BLOB
	TEXT
	MEDIUMBLOB
	MEDIUMTEXT
	LONGBLOB
	LONGTEXT
	ENUM

  	// DateAndTime Types
  	DATE
  	TIME
  	DATETIME
  	TIMESTAMP
  	YEAR

	// Other Types
  	JSON
  	GEOMETRY
  	POINT
  	LINESTRING
  	POLYGON
  	MULTIPOINT
  	MULTILINESTRING
  	MULTIPOLYGON
  	GEOMETRYCOLLECTION

  	// Column Options
	NULL
	VISIBLE
	INVISIBLE
	AUTO_INCREMENT
	UNIQUE
	PRIMARY
	KEY
	CURRENT_TIMESTAMP
	GENERATED
	ALWAYS
	AS
	VIRTUAL
	STORED
	SRID

	// Index
	INDEX
	ASC
	DESC
	USING
	FULLTEXT
	KEY_BLOCK_SIZE
	WITH
	PARSER

	// Foreign Key
	CONSTRAINT
	FOREIGN
	REFERENCES
	MATCH
	ON_DELETE
	ON_UPDATE
	CASCADE
	RESTRICT
	NO_ACTION

	// Check Constraint
	CHECK
	ENFORCED
	NOT_ENFORCED

	// Table Options
  	AUTOEXTENDED_SIZE
  	AVG_ROW_LENGTH
  	CHECKSUM
	COMMENT
  	COMPRESSION
  	CONNECTION
  	DELAY_KEY_WRITE
  	DATA
  	DIRECTORY
  	ENGINE
  	ENGINE_ATTRIBUTE
  	INSERT_METHOD
  	MAX_ROWS
  	MIN_ROWS
  	PACK_KEYS
  	PASSWORD
  	ROW_FORMAT
  	SECONDARY_ENGINE_ATTRIBUTE
  	STATS_AUTO_RECALC
  	STATS_PERSISTENT
  	STATS_SAMPLE_PAGES
  	TABLESPACE
  	STORAGE
  	UNION

	// Literals etc
  	INT_NUM
  	FLOAT_NUM
  	BIT_NUM
  	BIT_STR
  	HEX_NUM
  	HEX_STR
	STRING
  	IDENTIFIER
  	QUOTED_IDENTIFIER
  	TRUE
  	FALSE
	EXPRESSION

  	// Partition Options
  	PARTITION
  	BY
  	PARTITIONS
  	Subpartition
  	LINEAR
  	HASH
  	COLUMNS
  	ALGORITHM
  	RANGE
  	LIST
  	SUBPARTITIONS
  	SUBPARTITION
  	VALUES
  	LESS
  	THAN
  	MAXVALUE
  	IN
  	NATURAL
  	LANGUAGE
  	MODE
  	QUERY
  	EXPANSION

  	SOUNDS
  	LIKE
  	BETWEEN
  	REGEXP

  	INTERVAL

  	MICROSECOND
    SECOND
    MINUTE
    HOUR
    DAY
    WEEK
    MONTH
    QUARTER
    SECOND_MICROSECOND
    MINUTE_MICROSECOND
    MINUTE_SECOND
    HOUR_MICROSECOND
    HOUR_SECOND
    HOUR_MINUTE
    DAY_MICROSECOND
    DAY_SECOND
    DAY_MINUTE
    DAY_HOUR
    YEAR_MONTH

    CURRENT_USER
    CURRENT_DATE
    CURRENT_ROLE
    UTC_DATE
    CURRENT_TIME
    LOCALTIME
    LOCALTIMESTAMP
    UTC_TIME
    UTC_TIMESTAMP


%right NOT

%%

Statements:
	// Empty
	{
		$$ = []Statement{}
		yylex.(*Parser).result = $$
	}
|	Statement
	{
		$$ = []Statement{$1}
		yylex.(*Parser).result = $$
	}
|	Statements SEMICOLON Statement
	{
		if $3 != nil {
		  $1 = append($1, $3)
		}
		$$ = $1
		yylex.(*Parser).result = $1
	}

Statement:
	// Empty
	{
		$$ = nil
	}
|	CreateDatabaseStatement
	{
		$$ = $1
	}
|	UseStatement
	{
		$$ = $1
	}
|	CreateTableStatement
	{
		$$ = $1
	}

UseStatement:
	USE DbName
	{
		$$ = UseStatement{
			DbName: $2,
		}
	}

CreateDatabaseStatement:
	CREATE DatabaseKwd OptIfNotExistsKwd DbName DatabaseOptions
	{
		$$ = CreateDatabaseStatement{
        	IfNotExists: $3,
			DbName: $4,
			DatabaseOptions: $5.(DatabaseOptions),
		}
	}

DbName:
	Identifier
	{
		$$ = $1
	}

DatabaseOptions:
	{
		$$ = DatabaseOptions{}
	}
|	DatabaseOption
	{
		$$ = $1
	}
|	DatabaseOptions DatabaseOption
	{
		// TODO: error handling
		merged := $1.(DatabaseOptions)
		mergo.Merge(&merged, $2.(DatabaseOptions))
		$$ = merged
	}

DatabaseOption:
	DefaultCharset
	{
		$$ = DatabaseOptions{
			DefaultCharset: $1,
		}
	}
|	DefaultCollate
	{
		$$ = DatabaseOptions{
			DefaultCollate: $1,
		}
	}
|	DefaultEncryption
	{
		$$ = DatabaseOptions{
			DefaultEncryption: $1,
		}
	}

DefaultCharset:
	OptDefaultKwd CharsetKwd OptEq Identifier
	{
		$$ = $4
	}

DefaultCollate:
	OptDefaultKwd COLLATE OptEq Identifier
	{
		$$ = $4
	}

DefaultEncryption:
	OptDefaultKwd ENCRYPTION OptEq StringLiteral
	{
		$$ = $4
	}

CreateTableStatement:
	CREATE OptTemporaryKwd TABLE OptIfNotExistsKwd TableName CreateDefinitionList TableOptions OptPartitionConfig
	{
        	$$ = CreateTableStatement{
        		DbName: $5[0],
		   		Temporary: $2,
		   		IfNotExists: $4,
		   		TableName: $5[1],
		   		CreateDefinitions: $6,
		   		TableOptions: $7.(TableOptions),
		   		Partitions: $8.(PartitionConfig),
        	}
    }

TableName:
	Identifier
	{
		$$ = []string{"", $1}
	}
|	Identifier DOT Identifier
	{
		$$ = []string{$1, $3}
	}

CreateDefinitionList:
    LP CreateDefinitions RP
    {
		$$ = $2
    }

CreateDefinitions:
    CreateDefinition
    {
		$$ = []interface{}{$1}
    }
|   CreateDefinitions COMMA CreateDefinition
    {
		$$ = append($1, $3)
    }

CreateDefinition:
    ColumnDefinition
    {
        $$ = $1.(*ColumnDefinition)
    }
|	IndexDefinition
	{
		$$ = $1.(*IndexDefinition)
	}
|	FullTextIndexDefinition
	{
		$$ = $1.(*FullTextIndexDefinition)
	}
|	PrimaryKeyDefinition
	{
		$$ = $1.(*PrimaryKeyDefinition)
	}
|	UniqueKeyDefinition
	{
		$$ = $1.(*UniqueKeyDefinition)
	}
|	ForeignKeyDefinition
	{
		$$ = $1.(*ForeignKeyDefinition)
	}
|	CheckConstraintDefinition
	{
		$$ = $1.(*CheckConstraintDefinition)
	}

ColumnDefinition:
    Identifier DataType ColumnOptions
    {
    	columnOptions := $3.(ColumnOptions)
    	if columnOptions.Nullability == "" {
    		columnOptions.Nullability = "NULL"
    	}
        $$ = &ColumnDefinition{
            ColumnName: $1,
            DataType: $2,
            ColumnOptions: $3.(ColumnOptions),
        }
    }

DataType:
    NumericType
    {
    	$$ = $1
    }
|	DateAndTimeType
	{
		$$ = $1
	}
|	StringType
	{
		$$ = $1
	}
|	JsonType
	{
		$$ = $1
	}
|	SpatialType
	{
		$$ = $1
	}

NumericType:
	IntegerType
	{
		$$ = $1
	}
|   FixedPointType
	{
		$$ = $1
	}
|   FloatingPointType
	{
		$$ = $1
	}

IntegerType:
	BIT OptFieldLen
	{
		$$ = IntegerType{
			Name: "bit",
			FieldLen: $2,
		}
	}
| 	TINYINT OptFieldLen OptUnsignedKwd OptZerofillKwd
	{
		$$ = IntegerType{
			Name: "tinyint",
			FieldLen: $2,
			Unsigned: $3,
			Zerofill: $4,
		}
	}
|	BoolKwd
	{
		// Bool type is synonym of tinyint(1)
		$$ = IntegerType{
			Name: "tinyint",
			FieldLen: "1",
		}
	}
|	SMALLINT OptFieldLen OptUnsignedKwd OptZerofillKwd
	{
		$$ = IntegerType{
			Name: "smallint",
			FieldLen: $2,
			Unsigned: $3,
			Zerofill: $4,
		}
	}
|	MEDIUMINT OptFieldLen OptUnsignedKwd OptZerofillKwd
	{
		$$ = IntegerType{
			Name: "mediumint",
			FieldLen: $2,
			Unsigned: $3,
			Zerofill: $4,
		}
	}
|	IntKwd OptFieldLen OptUnsignedKwd OptZerofillKwd
	{
		$$ = IntegerType{
			Name: "int",
			FieldLen: $2,
			Unsigned: $3,
			Zerofill: $4,
		}
	}
|	BIGINT OptFieldLen OptUnsignedKwd OptZerofillKwd
	{
		$$ = IntegerType{
			Name: "bigint",
			FieldLen: $2,
			Unsigned: $3,
			Zerofill: $4,
		}
	}

FixedPointType:
    DecimalKwd OptFieldLenAndOptScale OptUnsignedKwd OptZerofillKwd
    {
    	fieldLen := ""
    	fieldScale := ""
    	if len($2) >= 1 {
    		fieldLen = $2[0]
			if len($2) >= 2 {
				 fieldScale = $2[1]
			}
		}
		$$ = FixedPointType{
			Name: "decimal",
			FieldLen: fieldLen,
			FieldScale: fieldScale,
			Unsigned: $3,
			Zerofill: $4,
		}
    }

FloatingPointType:
    FLOAT OptFieldLenAndScale OptUnsignedKwd OptZerofillKwd
    {
    	fieldLen := ""
    	fieldScale := ""
	 	if len($2) >= 2 {
		   fieldLen = $2[0]
		   fieldScale = $2[1]
	 	}
		$$ = FixedPointType{
			Name: "float",
			FieldLen: fieldLen,
			FieldScale: fieldScale,
			Unsigned: $3,
			Zerofill: $4,
		}
    }
|   DoubleKwd OptFieldLenAndScale OptUnsignedKwd OptZerofillKwd
	{
    	fieldLen := ""
    	fieldScale := ""
	 	if len($2) >= 2 {
		   fieldLen = $2[0]
		   fieldScale = $2[1]
	 	}
		$$ = FixedPointType{
			Name: "double",
			FieldLen: fieldLen,
			FieldScale: fieldScale,
			Unsigned: $3,
			Zerofill: $4,
		}
	}

OptFieldLen:
	{
		$$ = ""
	}
|	FieldLen
    {
    	$$ = $1
    }

FieldLen:
	LP IntLiteral RP
	{
		$$ = $2
	}

OptFieldLenAndScale:
	{
		$$ = []string{}
	}
|	FieldLenAndScale
	{
		$$ = $1
	}

FieldLenAndScale:
	LP IntLiteral COMMA IntLiteral RP
	{
		$$ = []string{$2, $4}
	}

OptFieldLenAndOptScale:
	{
		$$ = []string{}
	}
|   FieldLenAndOptScale
    {
    	$$ = $1
    }

FieldLenAndOptScale:
	LP IntLiteral RP
	{
		$$ = []string{$2}
	}
|	LP IntLiteral COMMA IntLiteral RP
	{
		$$ = []string{$2, $4}
	}

DateAndTimeType:
	DATE
	{
		$$ = DateAndTimeType{
			Name: "date",
		}
	}
| 	TIME OptFieldLen
	{
		fieldLen := ""
		if $2 != "" {
			fieldLen = $2
		}
		$$ = DateAndTimeType{
			Name: "time",
			FieldLen: fieldLen,
		}
	}
|	DATETIME OptFieldLen
	{
		fieldLen := ""
		if $2 != "" {
			fieldLen = $2
		}
		$$ = DateAndTimeType{
			Name: "datetime",
			FieldLen: fieldLen,
		}
	}
| 	TIMESTAMP OptFieldLen
	{
		fieldLen := ""
		if $2 != "" {
			fieldLen = $2
		}
		$$ = DateAndTimeType{
			Name: "timestamp",
			FieldLen: fieldLen,
		}
	}
| 	YEAR OptFieldLen
	{
		fieldLen := ""
		if $2 != "" {
			fieldLen = $2
		}
		$$ = DateAndTimeType{
			Name: "year",
			FieldLen: fieldLen,
		}
	}

StringType:
	CharKwd OptFieldLen OptCharset OptCollate
	{
		fieldLen := ""
		if $2 != "" {
			fieldLen = $2
		}
		$$ = StringType{
			Name: "char",
			FieldLen: fieldLen,
			Charset: $3,
			Collation: $4,
		}
	}
|	VARCHAR FieldLen OptCharset OptCollate
	{
		$$ = StringType{
			Name: "varchar",
			FieldLen:  $2,
			Charset: $3,
			Collation: $4,
		}
	}
|	BINARY OptFieldLen
	{
		fieldLen := ""
		if $2 != "" {
			fieldLen = $2
		}
		$$ = StringType{
			Name: "binary",
			FieldLen: fieldLen,
		}
	}
|	VARBINARY FieldLen
	{
		$$ = StringType{
			Name: "varbinary",
			FieldLen: $2,
		}
	}
| 	TINYBLOB
	{
		$$ = StringType{
			Name: "tinyblob",
		}
	}
| 	TINYTEXT OptCharset OptCollate
	{
		$$ = StringType{
			Name: "tinytext",
			Charset: $2,
			Collation: $3,
		}
	}
| 	BLOB OptFieldLen
	{
		fieldLen := ""
		if $2 != "" {
			fieldLen = $2
		}
		$$ = StringType{
			Name: "blob",
			FieldLen: fieldLen,
		}
	}
| 	TEXT OptFieldLen OptCharset OptCollate
	{
		fieldLen := ""
		if $2 != "" {
			fieldLen = $2
		}
		$$ = StringType{
			Name: "text",
			FieldLen: fieldLen,
			Charset: $3,
			Collation: $4,
		}
	}
| 	MEDIUMBLOB
	{
		$$ = StringType{
			Name: "mediumblob",
		}
	}
| 	MEDIUMTEXT OptCharset OptCollate
	{
		$$ = StringType{
			Name: "mediumtext",
			Charset: $2,
			Collation: $3,
		}
	}
| 	LONGBLOB
	{
		$$ = StringType{
			Name: "longblob",
		}
	}
| 	LONGTEXT OptCharset OptCollate
	{
		$$ = StringType{
			Name: "longtext",
			Charset: $2,
			Collation: $3,
		}
	}
|	ENUM StringLiteralList OptCharset OptCollate
	{
		$$ = StringListType{
			Name: "enum",
			Values: $2,
			Charset: $3,
			Collation: $4,
		}
	}
|	SET StringLiteralList OptCharset OptCollate
    {
  		 $$ = StringListType{
  			 Name: "set",
  			 Values: $2,
  			 Charset: $3,
  			 Collation: $4,
  		 }
    }

JsonType:
	JSON
	{
		$$ = JsonType{
			Name: "json",
		}
	}


SpatialType:
	GEOMETRY
	{
		$$ = SpatialType{
			Name: "geometry",
		}
	}
|	POINT
	{
		$$ = SpatialType{
			Name: "point",
		}
	}
|	LINESTRING
	{
		$$ = SpatialType{
			Name: "linestring",
		}
	}
|	POLYGON
	{
		$$ = SpatialType{
			Name: "polygon",
		}
	}
|	MULTIPOINT
	{
		$$ = SpatialType{
			Name: "multipoint",
		}
	}
|	MULTILINESTRING
	{
		$$ = SpatialType{
			Name: "multilinestring",
		}
	}
|	MULTIPOLYGON
	{
		$$ = SpatialType{
			Name: "multipolygon",
		}
	}
|	GEOMETRYCOLLECTION
	{
		$$ = SpatialType{
			Name: "geometrycollection",
		}
	}

ColumnOptions:
	{
		$$ = ColumnOptions{}
	}
|	ColumnOption
	{
		$$ = $1
	}
|	ColumnOptions ColumnOption
	{
		// TODO: error handling
		merged := $1.(ColumnOptions)
		mergo.Merge(&merged, $2.(ColumnOptions))
		$$ = merged
	}

ColumnOption:
	Nullability
	{
		$$ = ColumnOptions{
			Nullability: $1,
		}
	}
|	DefaultDefinition
	{
		$$ = ColumnOptions{
			Default: $1,
		}
	}
|	Visibility
	{
		$$ = ColumnOptions{
			Visibility: $1,
		}
	}
|	AUTO_INCREMENT
	{
		$$ = ColumnOptions{
			AutoIncrement: true,
		}
	}
|	ColumnUniqueKwd
	{
		$$ = ColumnOptions{
			Unique: $1,
		}
	}
|	ColumnPrimaryKwd
	{
		$$ = ColumnOptions{
			Primary: $1,
		}
	}
|	Comment
	{
		$$ = ColumnOptions{
			Comment: $1,
		}
	}
| 	ReferenceDefinition
	{
		$$ = ColumnOptions{
			ReferenceDefinition: $1.(ReferenceDefinition),
		}
	}
|	CheckConstraintDefinition
	{
		$$ = ColumnOptions{
			CheckConstraintDefinition: $1.(CheckConstraintDefinition),
		}
	}
|	OnUpdate
	{
		$$ = ColumnOptions{
			OnUpdate: $1,
		}
	}
|	GeneratedAlwaysAs
	{
		$$ = ColumnOptions{
			GeneratedAs: $1,
		}
	}
|	GeneratedColumnType
	{
		$$ = ColumnOptions{
			GeneratedColumnType: $1,
		}
	}
|	Srid
	{
		$$ = ColumnOptions{
			Srid: $1,
		}
	}

Nullability:
	NULL
	{
		$$ = "NULL"
	}
|	NOT NULL
	{
		$$ = "NOT NULL"
	}

DefaultDefinition:
	DEFAULT DefaultValue
	{
		$$ = $2
	}

DefaultValue:
	Literal
	{
		$$ = $1
	}
|	LP Expression RP
	{
		$$ = fmt.Sprintf("(%s)", $2)
	}
|	FunctionNameDatetimePrecision OptFieldLen
	{
		$$ = compactJoin([]string{$1, $2}, "")
	}

Visibility:
	VISIBLE
	{
		$$ = "VISIBLE"
	}
|	INVISIBLE
	{
		$$ = "INVISIBLE"
	}

OptCharset:
	{
		$$ = ""
	}
|	Charset
 	{
		$$ = $1
    }

Charset:
	CharsetKwd Identifier
	{
		$$ = $2
    }

OptCollate:
	{
		$$ = ""
	}
|	Collate
	{
		$$ = $1
	}

Collate:
	COLLATE Identifier
	{
		$$ = $2
	}

GeneratedAlwaysAs:
	GeneratedAlwaysAsKwd LP Expression RP
	{
		$$ = fmt.Sprintf("(%s)", $3)
	}

GeneratedColumnType:
	VIRTUAL
	{
		$$ = "VIRTUAL"
	}
|	STORED
	{
		$$ = "STORED"
	}

Srid:
	SRID IntLiteral
	{
		$$ = $2
	}

IndexDefinition:
	IndexKwd OptIndexName KeyPartList IndexOptions
	{
		$$ = &IndexDefinition{
			IndexName: $2,
			KeyPartList: $3,
			IndexOptions: $4.(IndexOptions),
		}
	}

FullTextIndexDefinition:
	FullTextIndexKwd OptIndexName KeyPartList IndexOptions
	{
		$$ = &FullTextIndexDefinition{
			IndexName: $2,
			KeyPartList: $3,
			IndexOptions: $4.(IndexOptions),
		}
	}

PrimaryKeyDefinition:
	OptConstraint PRIMARY KEY KeyPartList IndexOptions
	{
		$$ = &PrimaryKeyDefinition{
			ConstraintName: $1,
			KeyPartList: $4,
			IndexOptions: $5.(IndexOptions),
		}
	}

UniqueKeyDefinition:
	OptConstraint UniqueKeyKwd OptIndexName KeyPartList IndexOptions
	{
		$$ = &UniqueKeyDefinition{
			ConstraintName: $1,
			IndexName: $3,
			KeyPartList: $4,
			IndexOptions: $5.(IndexOptions),
		}
	}

ForeignKeyDefinition:
	OptConstraint FOREIGN KEY OptIndexName KeyPartList ReferenceDefinition
	{
		$$ = &ForeignKeyDefinition{
			ConstraintName: $1,
			IndexName: $4,
			KeyPartList: $5,
			ReferenceDefinition: $6.(ReferenceDefinition),
		}
	}

OptIndexName:
	{
		$$ = ""
	}
|	Identifier
	{
		$$ = $1
	}

KeyPartList:
	LP KeyParts RP
	{
		$$ = $2
	}

KeyParts:
	KeyPart
	{
		$$ = []KeyPart{$1.(KeyPart)}
	}
|	KeyParts COMMA KeyPart
	{
		$$ = append($1, $3.(KeyPart))
	}

KeyOrder:
	{
		$$ = ""
	}
|	ASC
	{
		$$ = "ASC"
	}
|	DESC
	{
		$$ = "DESC"
	}

KeyPart:
	Identifier OptFieldLen KeyOrder
	{
		$$ = KeyPart{
			Column: $1,
			Length: $2,
			Order: $3,
		}
	}
|	Expression KeyOrder
	{
		$$ = KeyPart{
			Column: $1,
			Order: $2,
		}
	}

IndexOptions:
	{
		$$ = IndexOptions{}
	}
|	IndexOption
	{
		$$ = $1
	}
|	IndexOptions IndexOption
	{
		// TODO: error handling
		merged := $1.(IndexOptions)
		mergo.Merge(&merged, $2.(IndexOptions))
		$$ = merged
	}

IndexOption:
	KeyBlockSize
	{
		$$ = IndexOptions{
			KeyBlockSize: $1,
		}
	}
|	IndexType
	{
		$$ = IndexOptions{
			IndexType: $1,
		}
	}
|	Parser
	{
		$$ = IndexOptions{
			Parser: $1,
		}
	}
|	Comment
	{
		$$ = IndexOptions{
			Comment: $1,
		}
	}
|	Visibility
	{
		$$ = IndexOptions{
			Visibility: $1,
		}
	}

KeyBlockSize:
	KEY_BLOCK_SIZE OptEq IntLiteral
	{
		$$ = $3
	}

IndexType:
	USING Identifier
	{
		$$ = $2
	}

Parser:
	WITH PARSER Identifier
	{
		$$ = $3
	}

Comment:
	COMMENT StringLiteral
	{
		$$ = $2
	}

ReferenceDefinition:
	REFERENCES TableName KeyPartList ReferenceOptions
	{
		$$ = ReferenceDefinition{
			TableName: $2[1],
			KeyPartList: $3,
			ReferenceOptions: $4.(ReferenceOptions),
		}
	}

ReferenceOptions:
	{
		$$ = ReferenceOptions{}
	}
|	ReferenceOption
	{
		$$ = $1
	}
|	ReferenceOptions ReferenceOption
	{
		// TODO: error handling
		merged := $1.(ReferenceOptions)
		mergo.Merge(&merged, $2.(ReferenceOptions))
		$$ = merged
	}

ReferenceOption:
	Match
	{
		$$ = ReferenceOptions{
			Match: $1,
		}
	}
|	OnDelete
	{
		$$ = ReferenceOptions{
			OnDelete: $1,
		}
	}
|	OnUpdate
	{
		$$ = ReferenceOptions{
			OnUpdate: $1,
		}
	}

Match:
	MATCH Identifier
	{
		$$ = $2
	}

OnDelete:
	ON_DELETE ReferencialAction
	{
		$$ = $2
	}

OnUpdate:
	ON_UPDATE ReferencialAction
	{
		$$ = $2
	}

ReferencialAction:
	CASCADE
	{
		$$ = "CASCADE"
	}
|	SET NULL
	{
		$$ = "SET NULL"
	}
|	RESTRICT
	{
		$$ = "RESTRICT"
	}
|	SET DEFAULT
	{
		$$ = "SET DEFAULT"
	}
|	NO_ACTION
	{
		$$ = "RESTRICT"
	}
|	CURRENT_TIMESTAMP
	{
		$$ = "CURRENT_TIMESTAMP"
	}

CheckConstraintDefinition:
	OptConstraint CHECK EXPRESSION CheckConstraintOptions
	{
		$$ = &CheckConstraintDefinition{
			ConstraintName: $1,
			Check: $3.Literal,
			CheckConstraintOptions: $4.(CheckConstraintOptions),
		}
	}

OptConstraint:
	{
		$$ = ""
	}
|	CONSTRAINT
	{
		$$ = ""
	}
|	CONSTRAINT Identifier
	{
		$$ = $2
	}

CheckConstraintOptions:
	{
		 $$ = CheckConstraintOptions{}
	}
|	CheckConstraintOption
	{
		 $$ = $1
	}
|	CheckConstraintOptions CheckConstraintOption
	{
		 // TODO: error handling
		 merged := $1.(CheckConstraintOptions)
		 mergo.Merge(&merged, $2.(CheckConstraintOptions))
		 $$ = merged
	}

CheckConstraintOption:
	Enforcement
	{
		$$ = CheckConstraintOptions{
			Enforcement: $1,
		}
	}

Enforcement:
	ENFORCED
	{
		$$ = "ENFORCED"
	}
|	NOT_ENFORCED
	{
		$$ = "NOT ENFORCED"
	}

TableOptions:
	{
		$$ = TableOptions{}
	}
|	TableOption
	{
		$$ = $1
	}
|	TableOptions TableOption
	{
		// TODO: error handling
		merged := $1.(TableOptions)
		mergo.Merge(&merged, $2.(TableOptions))
		$$ = merged
	}

TableOption:
	AutoExtendedSize
	{
		$$ = TableOptions{
			AutoExtendedSize: $1,
		}
	}
|	AutoIncrementValue
	{
		$$ = TableOptions{
			AutoIncrement: $1,
		}
	}
|	AvgRowLength
	{
		$$ = TableOptions{
			AvgRowLength: $1,
		}
	}
|	DefaultCharset
	{
		$$ = TableOptions{
			DefaultCharset: $1,
		}
	}
|	DefaultCollate
	{
		$$ = TableOptions{
			DefaultCollate: $1,
		}
	}
|	Checksum
	{
		$$ = TableOptions{
			Checksum: $1,
		}
	}
|	TableComment
	{
		$$ = TableOptions{
			Comment: $1,
		}
	}
|	Compression
	{
		$$ = TableOptions{
			Compression: $1,
		}
	}
|	Connection
	{
		$$ = TableOptions{
			Connection: $1,
		}
	}
|	DataDirectory
	{
		$$ = TableOptions{
			DataDirectory: $1,
		}

	}
|	IndexDirectory
	{
		$$ = TableOptions{
			IndexDirectory: $1,
		}

	}
|	DelayKeyWrite
	{
		$$ = TableOptions{
			DelayKeyWrite: $1,
		}

	}
|	Encryption
	{
		$$ = TableOptions{
			Encryption: $1,
		}
	}
|	Engine
	{
		$$ = TableOptions{
			Engine: $1,
		}
	}
|	EngineAttribute
	{
		$$ = TableOptions{
			EngineAttribute: $1,
		}
	}
|	InsertMethod
	{
		$$ = TableOptions{
			InsertMethod: $1,
		}
	}
|	KeyBlockSize
	{
		$$ = TableOptions{
			KeyBlockSize: $1,
		}
	}
|	MaxRows
	{
		$$ = TableOptions{
			MaxRows: $1,
		}
	}
|	MinRows
	{
		$$ = TableOptions{
			MinRows: $1,
		}
	}
|	PackKeys
	{
		$$ = TableOptions{
			PackKeys: $1,
		}
	}
|	Password
	{
		$$ = TableOptions{
			Password: $1,
		}
	}
|	RowFormat
	{
		$$ = TableOptions{
			RowFormat: $1,
		}
	}
|	SecondaryEngineAttribute
	{
		$$ = TableOptions{
			SecondaryEngineAttribute: $1,
		}
	}
|	StatsAutoRecalc
	{
		$$ = TableOptions{
			StatsAutoRecalc: $1,
		}
	}
|	StatsPersistent
	{
		$$ = TableOptions{
			StatsPersistent: $1,
		}
	}
|	StatsSamplePages
	{
		$$ = TableOptions{
			StatsSamplePages: $1,
		}
	}
|	TableSpace
	{
		$$ = TableOptions{
			TableSpace: $1[0],
			TableSpaceStorage: $1[1],
		}
	}
|	TableUnion
	{
		$$ = TableOptions{
			Union: $1,
		}
	}

AutoExtendedSize:
	AUTOEXTENDED_SIZE OptEq IntLiteral
	{
		$$ = $3
	}

AutoIncrementValue:
	AUTO_INCREMENT OptEq IntLiteral
	{
		$$ = $3
	}

AvgRowLength:
	AVG_ROW_LENGTH OptEq IntLiteral
	{
		$$ = $3
	}

Checksum:
	CHECKSUM OptEq IntLiteral
	{
		$$ = $3
	}

TableComment:
	COMMENT OptEq StringLiteral
	{
		$$ = $3
	}

Compression:
	COMPRESSION OptEq StringLiteral
	{
		$$ = $3
	}

Connection:
	CONNECTION OptEq StringLiteral
	{
		$$ = $3
	}

DataDirectory:
	DATA DIRECTORY OptEq StringLiteral
	{
		$$ = $4
	}

IndexDirectory:
	INDEX DIRECTORY OptEq StringLiteral
	{
		$$ = $4
	}

DelayKeyWrite:
	DELAY_KEY_WRITE OptEq IntLiteral
	{
		$$ = $3
	}

Encryption:
	ENCRYPTION OptEq StringLiteral
	{
		$$ = $3
	}

Engine:
	ENGINE OptEq Identifier
	{
		$$ = $3
	}

EngineAttribute:
	ENGINE_ATTRIBUTE OptEq StringLiteral
	{
		$$ = $3
	}

InsertMethod:
	INSERT_METHOD OptEq Identifier
	{
		$$ = $3
	}

MaxRows:
	MAX_ROWS OptEq IntLiteral
	{
		$$ = $3
	}

MinRows:
	MIN_ROWS OptEq IntLiteral
	{
		$$ = $3
	}

PackKeys:
	PACK_KEYS OptEq IntLiteral
	{
		$$ = $3
	}

Password:
	PASSWORD OptEq StringLiteral
	{
		$$ = $3
	}

RowFormat:
	ROW_FORMAT OptEq Identifier
	{
		$$ = $3
	}

SecondaryEngineAttribute:
	SECONDARY_ENGINE_ATTRIBUTE OptEq StringLiteral
	{
		$$ = $3
	}

StatsAutoRecalc:
	STATS_AUTO_RECALC OptEq IntLiteral
	{
		$$ = $3
	}

StatsPersistent:
	STATS_PERSISTENT OptEq IntLiteral
	{
		$$ = $3
	}

StatsSamplePages:
	STATS_SAMPLE_PAGES OptEq IntLiteral
	{
		$$ = $3
	}

TableSpace:
	TABLESPACE Identifier OptStorage
	{
		$$ = []string{$2, $3}
	}

OptStorage:
	{
		$$ = ""
	}
|	Storage
	{
		$$ = $1
	}

Storage:
	STORAGE Identifier
	{
		$$ = $2
	}

TableUnion:
	UNION OptEq IdentifierList
	{
		$$ = $3
	}

OptPartitionConfig:
	{
		$$ = PartitionConfig{}
	}
|	PartitionConfig
	{
		$$ = $1
	}

PartitionConfig:
	PartitionBy OptPartitions OptSubpartitionBy OptSubpartitions OptPartitionDefinitionList
	{
		$$ = PartitionConfig{
			PartitionBy: $1.(PartitionBy),
			Partitions: $2,
			SubpartitionBy: $3.(PartitionBy),
			Subpartitions: $4,
			PartitionDefinitions: $5,
		}
	}

PartitionBy:
	PARTITION BY PartitionByHash
	{
		$$ = $3
	}
|	PARTITION BY PartitionByKey
	{
		$$ = $3
	}
|	PARTITION BY PartitionByRange
	{
		$$ = $3
	}
|	PARTITION BY PartitionByList
	{
		$$ = $3
	}

OptPartitions:
	{
		$$ = ""
	}
|	Partitions
	{
		$$ = $1
	}

Partitions:
	PARTITIONS IntLiteral
	{
		$$ = $2
	}

OptSubpartitionBy:
	{
		$$ = PartitionBy{}
	}
|	SubpartitionBy
	{
		$$ = $1
	}

SubpartitionBy:
	SUBPARTITION BY PartitionByHash
	{
		$$ = $3
	}
|	SUBPARTITION BY PartitionByKey
	{
		$$ = $3
	}

OptSubpartitions:
	{
		$$ = ""
	}
|	Subpartitions
	{
		$$ = $1
	}

Subpartitions:
	SUBPARTITIONS IntLiteral
	{
		$$ = $2
	}

PartitionByHash:
	OptLinearKwd HASH Expression
	{
		$$ = PartitionBy{
		  Type: "HASH",
		  Expression: $3,
		}
	}

PartitionByKey:
	OptLinearKwd KEY OptAlgorithm IdentifierList
	{
		$$ = PartitionBy{
		  Type: "KEY",
		  Columns: $4,
		}
	}

PartitionByRange:
	RANGE Expression
	{
		$$ = PartitionBy{
		  Type: "RANGE",
		  Expression: $2,
		}
	}
|	RANGE COLUMNS IdentifierList
	{
		$$ = PartitionBy{
		  Type: "RANGE COLUMNS",
		  Columns: $3,
		}
	}

PartitionByList:
	LIST Expression
	{
		$$ = PartitionBy{
		  Type: "LIST",
		  Expression: $2,
		}
	}
|	LIST COLUMNS IdentifierList
	{
		$$ = PartitionBy{
		  Type: "LIST COLUMNS",
		  Columns: $3,
		}
	}

OptAlgorithm:
	{
		$$ = ""
	}
|	Algorithm
	{
		$$ = $1
	}

Algorithm:
	ALGORITHM OptEq IntLiteral
	{
		$$ = $3
	}

OptPartitionDefinitionList:
	{
		$$ = []PartitionDefinition{}
	}
| 	PartitionDefinitionList
	{
		$$ = $1
	}

PartitionDefinitionList:
    LP PartitionDefinitions RP
    {
		$$ = $2
    }

PartitionDefinitions:
    PartitionDefinition
    {
		$$ = []PartitionDefinition{$1.(PartitionDefinition)}
    }
|   PartitionDefinitions COMMA PartitionDefinition
    {
		$$ = append($1, $3.(PartitionDefinition))
    }

PartitionDefinition:
	PARTITION Identifier PartitionValues PartitionOptions OptSubpartitionDefinitionList
	{
		$$ = PartitionDefinition{
			Name: $2,
			Operator: $3[0],
			ValueExpression: $3[1],
			PartitionOptions: $4.(PartitionOptions),
			Subpartitions: $5,
		}
	}

PartitionValues:
	VALUES LESS THAN Expression
	{
		$$ = []string{"LESS THAN", $4}
	}
|	VALUES IN Expression
	{
		$$ = []string{"IN", $3}
	}

PartitionOptions:
	{
		$$ = PartitionOptions{}
	}
|	PartitionOption
	{
		$$ = $1
	}
|	PartitionOptions PartitionOption
	{
		// TODO: error handling
		merged := $1.(PartitionOptions)
		mergo.Merge(&merged, $2.(PartitionOptions))
		$$ = merged
	}

PartitionOption:
	PartitionStorageEngine
	{
		$$ = PartitionOptions{
			Engine: $1,
		}
	}
|	TableComment
	{
		$$ = PartitionOptions{
			Comment: $1,
		}
	}
|	DataDirectory
	{
		$$ = PartitionOptions{
			DataDirectory: $1,
		}
	}
|	IndexDirectory
	{
		$$ = PartitionOptions{
			IndexDirectory: $1,
		}
	}
|	MaxRows
	{
		$$ = PartitionOptions{
			MaxRows: $1,
		}
	}
|	MinRows
	{
		$$ = PartitionOptions{
			MinRows: $1,
		}
	}
|	PartitionTableSpace
	{
		$$ = PartitionOptions{
			TableSpace: $1,
		}
	}

PartitionTableSpace:
	TABLESPACE OptEq Identifier
	{
		$$ = $3
	}

PartitionStorageEngine:
	PartitionStorageEngineKwd Identifier
	{
		$$ = $2
	}

OptSubpartitionDefinitionList:
	{
		$$ = []SubpartitionDefinition{}
	}
|	SubpartitionDefinitionList
	{
		$$ = $1
	}

SubpartitionDefinitionList:
    LP SubpartitionDefinitions RP
    {
		$$ = $2
    }

SubpartitionDefinitions:
    SubpartitionDefinition
    {
		$$ = []SubpartitionDefinition{$1.(SubpartitionDefinition)}
    }
|   SubpartitionDefinitions COMMA SubpartitionDefinition
    {
		$$ = append($1, $3.(SubpartitionDefinition))
    }

SubpartitionDefinition:
	SUBPARTITION Identifier PartitionOptions
	{
		$$ = SubpartitionDefinition{
			Name: $2,
			PartitionOptions: $3.(PartitionOptions),
		}
	}

OptEq:
	// Empty
	{
		$$ = false
	}
|	EQ
	{
		$$ = true
	}

OptNot:
	{
		$$ = ""
	}
|	NOT
	{
		$$ = "NOT"
	}

Literal:
	BooleanLiteral
	{
		$$ = $1
	}
|	HexLiteral
	{
		$$ = $1
	}
|	BitLiteral
	{
		$$ = $1
	}
|	IntLiteral
	{
		$$ = $1
	}
|	FloatLiteral
	{
		$$ = $1
	}
|	StringLiteral
	{
		$$ = $1
	}
|	NULL
	{
		$$ = "NULL"
	}

BooleanLiteral:
	TRUE
	{
		$$ = "TRUE"
	}
|	FALSE
	{
		$$ = "FALSE"
	}

HexLiteral:
	HEX_NUM
	{
		$$ = $1.Literal
	}
|	HEX_STR
	{
		$$ = "0x" + $1.Literal[2:len($1.Literal)-1]
	}

BitLiteral:
	BIT_NUM
	{
		$$ = $1.Literal
	}
|	BIT_STR
	{
		$$ = "0b" + $1.Literal[1:len($1.Literal)-1]
	}

IntLiteral:
	INT_NUM
	{
		$$ = $1.Literal
	}

FloatLiteral:
	FLOAT_NUM
	{
		$$ = $1.Literal
	}

// cf. https://dev.mysql.com/doc/refman/8.0/en/string-literals.html
StringLiteral:
	OptIntroducer STRING OptCollate
	{
		$$ = $2.Literal
	}

OptIntroducer:
	{
		$$ = ""
	}
|	Introducer
	{
		$$ = $1
	}

Introducer:
	IDENTIFIER
	{
		$$ = $1.Literal
	}

StringLiterals:
	StringLiteral
	{
		$$ = []string{$1}
	}
|	StringLiterals COMMA StringLiteral
	{
		$$ = append($1, $3)
	}

StringLiteralList:
	LP StringLiterals RP
	{
		$$ = $2
	}

Identifier:
    IDENTIFIER
    {
    	$$ = $1.Literal
    }
|	QUOTED_IDENTIFIER
	{
		$$ = $1.Submatches[0]
	}

Identifiers:
	Identifier
	{
		$$ = []string{$1}
	}
|	Identifiers COMMA Identifier
	{
		$$ = append($1, $3)
	}

IdentifierList:
	LP Identifiers RP
	{
		$$ = $2
	}

Variable:
	LOCAL_VAR
	{
		$$ = $1.Literal
	}
|	GLOBAL_VAR
	{
		$$ = $1.Literal
	}

ComparisonOp:
  EQ
  {
    $$ = $1.Literal
  }
| GT
  {
    $$ = $1.Literal
  }
| GTE
  {
    $$ = $1.Literal
  }
| LT
  {
    $$ = $1.Literal
  }
| LTE
  {
    $$ = $1.Literal
  }
| NE
  {
    $$ = $1.Literal
  }
| NSEQ
  {
    $$ = $1.Literal
  }


OptExpressions:
	{
		$$ = []string{}
	}
|	Expressions
	{
		$$ = $1
	}

ExpressionList:
	LP Expressions RP
	{
		$$ = $2
	}

Expressions:
	Expression
	{
		$$ = []string{$1}
	}
|	Expressions COMMA Expression
	{
		$$ = append($1, $3)
	}

Expression:
	Expression AND Expression
	{
		$$ = fmt.Sprintf("%s AND %s", $1, $3)
	}
|	Expression OR Expression
	{
		$$ = fmt.Sprintf("%s OR %s", $1, $3)
	}
|	Expression XOR Expression
	{
		$$ = fmt.Sprintf("%s XOR %s", $1, $3)
	}
|	NotKwd Expression
	{
		$$ = fmt.Sprintf("NOT %s", $2)
	}
|	BooleanPrimaryExpression IS OptNot BooleanLiteral
	{
		$$ = compactJoin([]string{$1, "IS", $3, $4}, " ")
	}
|	BooleanPrimaryExpression IS OptNot UNKNOWN
	{
		$$ = compactJoin([]string{$1, "IS", $3, "UNKNOWN"}, " ")
	}
|	BooleanPrimaryExpression
	{
		$$ = $1
	}

NotKwd:
	NOT
	{ $$ = true }
|	EXCL
	{ $$ = true }

BooleanPrimaryExpression:
	BooleanPrimaryExpression IS OptNot NULL
	{
		$$ = compactJoin([]string{$1, $2.Literal, $3, $4.Literal}, " ")
	}
|	BooleanPrimaryExpression ComparisonOp PredicateExpression
	{
		$$ = compactJoin([]string{$1, $2, $3}, " ")
	}
|	PredicateExpression
	{
		$$ = $1
	}

PredicateExpression:
//	BitExpression OptNot IN RP Subquery LP
//	{
//		$$ = compactJoin([]string{$1, $2, "IN", "(", $5, ")")}, " ")
//	}
	BitExpression OptNot IN ExpressionList
	{
		expressions := fmt.Sprintf("(%s)", strings.Join($4, ", "))
		$$ = compactJoin([]string{$1, $2, "IN", expressions}, " ")
	}
|	BitExpression OptNot BETWEEN BitExpression AND PredicateExpression
	{
		$$ = compactJoin([]string{$1, $2, "BETWEEN", $4, "AND", $6}, " ")
	}
| 	BitExpression SOUNDS LIKE BitExpression
	{
		$$ = compactJoin([]string{$1, "SOUNDS", "LIKE", $4}, " ")
	}
| 	BitExpression OptNot LIKE SimpleExpression
	{
		$$ = compactJoin([]string{$1, $2, "LIKE", $4}, " ")
	}
| 	BitExpression OptNot REGEXP BitExpression
	{
		$$ = compactJoin([]string{$1, $2, "REGEXP", $4}, " ")
	}
|	BitExpression
	{
		$$ = $1
	}

BitExpression:
	BitExpression PIPE BitExpression
	{
		$$ = fmt.Sprintf("%s | %s", $1, $3)
	}
| 	BitExpression BIT_AND BitExpression
	{
		$$ = fmt.Sprintf("%s & %s", $1, $3)
	}
| 	BitExpression RSHIFT BitExpression
	{
		$$ = fmt.Sprintf("%s << %s", $1, $3)
	}
| 	BitExpression LSHIFT BitExpression
	{
		$$ = fmt.Sprintf("%s >> %s", $1, $3)
	}
| 	BitExpression PLUS BitExpression
	{
		$$ = fmt.Sprintf("%s + %s", $1, $3)
	}
| 	BitExpression MINUS BitExpression
	{
		$$ = fmt.Sprintf("%s - %s", $1, $3)
	}
| 	BitExpression MULT BitExpression
	{
		$$ = fmt.Sprintf("%s * %s", $1, $3)
	}
| 	BitExpression DIV BitExpression
	{
		$$ = fmt.Sprintf("%s / %s", $1, $3)
	}
| 	BitExpression MOD BitExpression
	{
		$$ = fmt.Sprintf("%s %% %s", $1, $3)
	}
| 	BitExpression HAT BitExpression
	{
		$$ = fmt.Sprintf("%s ^ %s", $1, $3)
	}
| 	BitExpression PLUS IntervalExpression
	{
		$$ = fmt.Sprintf("%s + %s", $1, $3)
	}
| 	BitExpression MINUS IntervalExpression
	{
		$$ = fmt.Sprintf("%s - %s", $1, $3)
	}
|	SimpleExpression
	{
		$$ = $1
	}


SimpleExpression:
	Literal
	{
		$$ = $1
	}
|	Identifier
	{
		$$ = fmt.Sprintf("`%s`", $1)
	}
//|	SimpleExpression ComparisonOp SimpleExpression
//	{
//		$$ = $1 + $2 + $3
//	}
|	FunctionCall
	{
		$$ = $1
	}
|	SimpleExpression COLLATE Identifier
	{
		$$ = fmt.Sprintf("%s COLLATE %s", $1, $3)
	}
| 	QSTN
	{
		$$ = "?"
	}
| 	Variable
	{
		$$ = $1
	}
|	PLUS SimpleExpression
	{
		$$ = fmt.Sprintf("+ %s", $2)
	}
|	MINUS SimpleExpression
	{
		$$ = fmt.Sprintf("- %s", $2)
	}
|	TILDE SimpleExpression
	{
		$$ = fmt.Sprintf("~ %s", $2)
	}
|	EXCL SimpleExpression
	{
		$$ = fmt.Sprintf("! %s", $2)
	}
|	BINARY SimpleExpression
	{
		$$ = fmt.Sprintf("BINARY %s", $2)
	}
|	ExpressionList
	{
		$$ = fmt.Sprintf("(%s)", strings.Join($1, ", "))
	}
|	ROW ExpressionList
	{
		expressions := fmt.Sprintf("(%s)", strings.Join($2, ", "))
		$$ = fmt.Sprintf("ROW %s", expressions)
	}
//|	RP Subquery LP
//	{
//
//	}
//|	EXISTS RP Subquery LP
//	{
//
//	}
|	LCB Identifier Expression RCB
	{
		ident := fmt.Sprintf("`%s`", $2)
		$$ = fmt.Sprintf("{%s %s}", ident, $3)
	}
|	MatchExpression
	{
		$$ = $1
	}
|	CaseExpression
	{
		$$ = $1
	}
|	IntervalExpression
	{
		$$ = $1
	}

MatchExpression:
	MATCH IdentifierList AGAINST LP BitExpression OptSearchModifier RP
	{
		idents := fmt.Sprintf("(%s)", JoinS($2, ", ", "`"))
		against := fmt.Sprintf("(%s)", compactJoin([]string{$5, $6}, " "))
		$$ = compactJoin([]string{"MATCH", idents, "AGAINST", against}, " ")
	}

OptSearchModifier:
	{
		$$ = ""
	}
|	SearchModifier
	{
		$$ = $1
	}

SearchModifier:
	IN NATURAL LANGUAGE MODE
	{
		$$ = "IN NATURAL LANGUAGE MODE"
	}
|	IN NATURAL LANGUAGE MODE WITH QUERY EXPANSION
	{
		$$ = "IN NATURAL LANGUAGE MODE WITH QUERY EXPANSION"
	}
|	IN BOOLEAN MODE
	{
		$$ = "IN BOOLEAN MODE"
	}
|	WITH QUERY EXPANSION
	{
		$$ = "WITH QUERY EXPANSION"
	}

CaseExpression:
	CASE Expression WhenClauses OptElseClause END
	{
		$$ = compactJoin([]string{"CASE", $2, $3, $4, "END"}, " ")
	}

WhenClauses:
	WhenClause
	{
		$$ = $1
	}
|	WhenClauses WhenClause
	{
		$$ = fmt.Sprintf("%s %s", $1, $2)
	}

OptElseClause:
	{
		$$ = ""
	}
|	ElseClause
	{
		$$ = $1
	}

ElseClause:
	ELSE Expression
	{
		$$ = fmt.Sprintf("ELSE %s", $2)
	}

WhenClause:
	WHEN Expression THEN Expression
	{
		$$ = fmt.Sprintf("WHEN %s THEN %s", $2, $4)
	}

IntervalExpression:
	INTERVAL Expression TimeUnit
	{
		$$ = compactJoin([]string{"INTERVAL", $2, $3}, " ")
	}

TimeUnit:
	MICROSECOND { $$ = "MICROSECOND" }
|	SECOND	 { $$ = "SECOND" }
|	MINUTE	 { $$ = "MINUTE" }
|	HOUR	 { $$ = "HOUR" }
|	DAY	 { $$ = "DAY" }
|	WEEK	 { $$ = "WEEK" }
|	MONTH	 { $$ = "MONTH" }
|	QUARTER	 { $$ = "QUARTER" }
|	YEAR	 { $$ = "YEAR" }
|	SECOND_MICROSECOND	 { $$ = "SECOND_MICROSECOND" }
|	MINUTE_MICROSECOND	 { $$ = "MINUTE_MICROSECOND" }
|	MINUTE_SECOND	 { $$ = "MINUTE_SECOND" }
|	HOUR_MICROSECOND	 { $$ = "HOUR_MICROSECOND" }
|	HOUR_SECOND	 { $$ = "HOUR_SECOND" }
|	HOUR_MINUTE	 { $$ = "HOUR_MINUTE" }
|	DAY_MICROSECOND	 { $$ = "DAY_MICROSECOND" }
|	DAY_SECOND	 { $$ = "DAY_SECOND" }
|	DAY_MINUTE	 { $$ = "DAY_MINUTE" }
|	DAY_HOUR	 { $$ = "DAY_HOUR" }
|	YEAR_MONTH	 { $$ = "YEAR_MONTH" }


FunctionCall:
	FunctionCallGeneric
	{
		$$ = $1
	}
|	FunctionCallKeyword
	{
		$$ = $1
	}

FunctionCallKeyword:
	FunctionNameConflict LP OptExpressions RP
	{
		$$ = fmt.Sprintf("%s(%s)", $1, strings.Join($3, ","))
	}
|	FunctionNameOptionalBraces OptBraces
	{
		$$ = $1
	}
|	FunctionNameDatetimePrecision OptFieldLen
	{
		$$ = compactJoin([]string{$1, $2}, "")
	}

OptBraces:
	{ $$ = "" }
|	LP RP { $$ = "()" }

FunctionNameConflict:
	CHARSET { $$ = "CHAESET" }
|	DATE { $$ = "DATE" }
|	DATABASE { $$ = "DATABASE" }
|	DEFAULT { $$ = "DEFAULT" }
|	YEAR { $$ = "YEAR" }
|	MONTH { $$ = "MONTH" }
|	WEEK { $$ = "WEEK" }
|	DAY { $$ = "DAY" }
|	HOUR { $$ = "HOUR" }
|	MINUTE { $$ = "MINUTE" }
|	SECOND { $$ = "SECOND" }
|	MICROSECOND { $$ = "MICROSECOND" }
|	IF { $$ = "IF" }
|	INTERVAL { $$ = "INTERVAL" }
|	TIME { $$ = "TIME" }
|	TIMESTAMP { $$ = "TIMESTAMP" }

FunctionNameOptionalBraces:
	CURRENT_USER { $$ = "CURRENT_UESR" }
|	CURRENT_DATE { $$ = "CURRENT_DATE" }
|	CURRENT_ROLE { $$ = "CURRENT_ROLE" }
|	UTC_DATE { $$ = "UTC_DATE" }

FunctionNameDatetimePrecision:
	CURRENT_TIME { $$ = "CURRENT_TIME" }
|   CURRENT_TIMESTAMP { $$ = "CURRENT_TIMESTAMP" }
|   LOCALTIME { $$ = "LOCALTIME" }
|   LOCALTIMESTAMP { $$ = "LOCALTIMESTAMP" }
|   UTC_TIME { $$ = "UTC_TIME" }
|   UTC_TIMESTAMP { $$ = "UTC_TIMESTAMP" }


FunctionCallGeneric:
	Identifier LP OptExpressions RP
	{
		$$ = fmt.Sprintf("%s(%s)", $1, strings.Join($3, ","))
	}


OptTemporaryKwd:
	{ $$ = false }
|   TEMPORARY
    { $$ = true }

DatabaseKwd:
	DATABASE
	{ $$ = true }
|	SCHEMA
	{ $$ = true }

OptIfNotExistsKwd:
	{ $$ = false }
|	IF NOT EXISTS
    { $$ = true }

OptDefaultKwd:
	{ $$ = true }
|	DEFAULT
	{ $$ = false }

CharsetKwd:
	CHARACTER SET
	{ $$ = true }
|	CHARSET
	{ $$ = true }

BoolKwd:
	BOOL
	{ $$ = true }
|	BOOLEAN
	{ $$ = true }

IntKwd:
	INT
	{ $$ = true }
|	INTEGER
	{ $$ = true }

DecimalKwd:
	DECIMAL
	{ $$ = true }
|	DEC
	{ $$ = true }
|	FIXED
	{ $$ = true }

DoubleKwd:
	DOUBLE
	{ $$ = true }
|	REAL
	{ $$ = true }

CharKwd:
	CHAR
	{ $$ = true }
|	CHARACTER
	{ $$ = true }


OptUnsignedKwd:
	{ $$ = false }
|	UNSIGNED
	{ $$ = true }

OptZerofillKwd:
	{ $$ = false }
|	ZEROFILL
	{ $$ = true }

ColumnUniqueKwd:
	UNIQUE
	{ $$ = true }
|	UNIQUE KEY
	{ $$ = true }

ColumnPrimaryKwd:
	KEY
	{ $$ = true }
|	PRIMARY KEY
	{ $$ = true }

GeneratedAlwaysAsKwd:
	GENERATED ALWAYS AS
	{ $$ = true }
|	AS
	{ $$ = true }

IndexKwd:
	INDEX
	{ $$ = true }
| 	KEY
	{ $$ = true }

FullTextIndexKwd:
	FULLTEXT INDEX
	{ $$ = true }
| 	FULLTEXT KEY
	{ $$ = true }

UniqueKeyKwd:
	UNIQUE KEY
	{ $$ = true }
|	UNIQUE INDEX
	{ $$ = true }

OptLinearKwd:
	{ $$ = false }
|	LINEAR
	{ $$ = true }

PartitionStorageEngineKwd:
	STORAGE ENGINE
	{ $$ = true }
|	ENGINE
	{ $$ = true }

%%
