%{
package parser

import (
	"github.com/kota65535/sql-parser/lexer"
	"github.com/imdario/mergo"
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
  	PartitionDefinition
  	PartitionOptions
  	PartitionOption
 	SubpartitionDefinition

%type<stringList>
	StringLiteralList
	StringLiterals
	IdentifierList
	Identifiers
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
	BooleanLiteral
	BitLiteral
	IntLiteral
	FloatLiteral
	HexLiteral
	StringLiteral
	Identifier
	Expression
	OptIntroducer
	Introducer

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

%type<keyword>
	// Sign
  	OptEq

	// Create Statements
  	CreateKwd
  	UseKwd
  	OptTemporaryKwd
  	TemporaryKwd
  	DatabaseKwd
  	TableKwd
  	OptIfNotExistsKwd
  	IfNotExistsKwd

  	// Database Options
  	OptDefaultKwd
  	DefaultKwd
  	CharsetKwd
  	CollateKwd
  	EncryptionKwd

  	// Numeric Types
	BitKwd
	TinyIntKwd
	BoolKwd
	SmallIntKwd
	MediumIntKwd
	IntKwd
	BigIntKwd
	DecimalKwd
	FloatKwd
	DoubleKwd

	// String Types
  	CharKwd
  	VarcharKwd
  	BinaryKwd
  	VarBinaryKwd
  	TinyBlobKwd
  	TinyTextKwd
  	BlobKwd
  	TextKwd
  	MediumBlobKwd
  	MediumTextKwd
  	LongBlobKwd
  	LongTextKwd
  	EnumKwd
  	SetKwd

  	// Other Types
  	JsonKwd
	GeometryKwd
	PointKwd
	LineStringKwd
	PolygonKwd
	MultiPointKwd
	MultiLineStringKwd
	MultiPolygonKwd
	GeometryCollectionKwd

  	// Column Options
  	OptUnsignedKwd
  	UnsignedKwd
  	OptZerofillKwd
  	ZerofillKwd
  	ColumnUniqueKwd
  	ColumnPrimaryKwd
  	GeneratedAlwaysAsKwd
	SridKwd

	// Index
  	IndexKwd
  	FullTextIndexKwd
  	UniqueKeyKwd
  	PrimaryKeyKwd
  	KeyBlockSizeKwd
  	UsingKwd
  	WithParserKwd
  	CommentKwd

  	// Foreign Key
  	ForeignKeyKwd

  	// Table Options
  	AutoExtendedSizeKwd
  	AutoIncrementKwd
  	AvgRowLengthKwd
  	ChecksumKwd
  	CompressionKwd
  	ConnectionKwd
  	DelayKeyWriteKwd
  	DataDirectoryKwd
  	EngineKwd
  	EngineAttributeKwd
  	IndexDirectoryKwd
  	InsertMethodKwd
  	MaxRowsKwd
  	MinRowsKwd
  	PackKeysKwd
  	PasswordKwd
  	RowFormatKwd
  	SecondaryEngineAttributeKwd
  	StatsAutoRecalcKwd
  	StatsPersistentKwd
  	StatsSamplePagesKwd
  	TableSpaceKwd
  	StorageKwd
  	UnionKwd

  	// Partition Options
  	PartitionByKwd
  	OptLinearKwd
  	LinearKwd
  	AlgorithmKwd
  	RangeKwd
  	ListKwd
  	PartitionsKwd
  	SubpartitionByKwd
  	SubpartitionsKwd
  	PartitionKwd
  	UniqueKeyKwd
  	PartitionStorageEngineKwd
  	ValuesLessThanKwd
  	ValuesInKwd
  	SubpartitionKwd

%token<token>
	// Signs
  	LP
  	RP
  	COMMA
  	SEMICOLON
  	EQ
  	DOT

  	// Create Statements
	CREATE
  	USE
  	TEMPORARY
  	DATABASE
  	SCHEMA
  	TABLE
  	IF_NOT_EXISTS

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
	NOT_NULL
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
	UseKwd DbName
	{
		$$ = UseStatement{
			DbName: $2,
		}
	}

CreateDatabaseStatement:
	CreateKwd DatabaseKwd OptIfNotExistsKwd DbName DatabaseOptions
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
	OptDefaultKwd CollateKwd OptEq Identifier
	{
		$$ = $4
	}

DefaultEncryption:
	OptDefaultKwd EncryptionKwd OptEq StringLiteral
	{
		$$ = $4
	}

CreateTableStatement:
	CreateKwd OptTemporaryKwd TableKwd OptIfNotExistsKwd TableName CreateDefinitionList TableOptions OptPartitionConfig
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
	BitKwd OptFieldLen
	{
		$$ = IntegerType{
			Name: "bit",
			FieldLen: $2,
		}
	}
| 	TinyIntKwd OptFieldLen OptUnsignedKwd OptZerofillKwd
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
|	SmallIntKwd OptFieldLen OptUnsignedKwd OptZerofillKwd
	{
		$$ = IntegerType{
			Name: "smallint",
			FieldLen: $2,
			Unsigned: $3,
			Zerofill: $4,
		}
	}
|	MediumIntKwd OptFieldLen OptUnsignedKwd OptZerofillKwd
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
|	BigIntKwd OptFieldLen OptUnsignedKwd OptZerofillKwd
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
    FloatKwd OptFieldLenAndScale OptUnsignedKwd OptZerofillKwd
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
|	VarcharKwd FieldLen OptCharset OptCollate
	{
		$$ = StringType{
			Name: "varchar",
			FieldLen:  $2,
			Charset: $3,
			Collation: $4,
		}
	}
|	BinaryKwd OptFieldLen
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
|	VarBinaryKwd FieldLen
	{
		$$ = StringType{
			Name: "varbinary",
			FieldLen: $2,
		}
	}
| 	TinyBlobKwd
	{
		$$ = StringType{
			Name: "tinyblob",
		}
	}
| 	TinyTextKwd OptCharset OptCollate
	{
		$$ = StringType{
			Name: "tinytext",
			Charset: $2,
			Collation: $3,
		}
	}
| 	BlobKwd OptFieldLen
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
| 	TextKwd OptFieldLen OptCharset OptCollate
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
| 	MediumBlobKwd
	{
		$$ = StringType{
			Name: "mediumblob",
		}
	}
| 	MediumTextKwd OptCharset OptCollate
	{
		$$ = StringType{
			Name: "mediumtext",
			Charset: $2,
			Collation: $3,
		}
	}
| 	LongBlobKwd
	{
		$$ = StringType{
			Name: "longblob",
		}
	}
| 	LongTextKwd OptCharset OptCollate
	{
		$$ = StringType{
			Name: "longtext",
			Charset: $2,
			Collation: $3,
		}
	}
|	EnumKwd StringLiteralList OptCharset OptCollate
	{
		$$ = StringListType{
			Name: "enum",
			Values: $2,
			Charset: $3,
			Collation: $4,
		}
	}
|	SetKwd StringLiteralList OptCharset OptCollate
    {
  		 $$ = StringListType{
  			 Name: "set",
  			 Values: $2,
  			 Charset: $3,
  			 Collation: $4,
  		 }
    }

JsonType:
	JsonKwd
	{
		$$ = JsonType{
			Name: "json",
		}
	}


SpatialType:
	GeometryKwd
	{
		$$ = SpatialType{
			Name: "geometry",
		}
	}
|	PointKwd
	{
		$$ = SpatialType{
			Name: "point",
		}
	}
|	LineStringKwd
	{
		$$ = SpatialType{
			Name: "linestring",
		}
	}
|	PolygonKwd
	{
		$$ = SpatialType{
			Name: "polygon",
		}
	}
|	MultiPointKwd
	{
		$$ = SpatialType{
			Name: "multipoint",
		}
	}
|	MultiLineStringKwd
	{
		$$ = SpatialType{
			Name: "multilinestring",
		}
	}
|	MultiPolygonKwd
	{
		$$ = SpatialType{
			Name: "multipolygon",
		}
	}
|	GeometryCollectionKwd
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
|	AutoIncrementKwd
	{
		$$ = ColumnOptions{
			AutoIncrement: $1,
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
		$$ = $1.Literal
	}
|	NOT_NULL
	{
		$$ = $1.Literal
	}

DefaultDefinition:
	DefaultKwd DefaultValue
	{
		$$ = "CURRENT_TIMESTAMP"
	}

DefaultValue:
	StringLiteral
	{
		$$ = $1
	}
|	BooleanLiteral
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
|	HexLiteral
	{
		$$ = $1
	}
|	Expression
	{
		$$ = $1
	}
|	NULL
	{
		$$ = ""
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
	GeneratedAlwaysAsKwd Expression
	{
		$$ = $2
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
	SridKwd IntLiteral
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
	OptConstraint PrimaryKeyKwd KeyPartList IndexOptions
	{
		$$ = &PrimaryKeyDefinition{
			ConstraintName: $1,
			KeyPartList: $3,
			IndexOptions: $4.(IndexOptions),
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
	OptConstraint ForeignKeyKwd OptIndexName KeyPartList ReferenceDefinition
	{
		$$ = &ForeignKeyDefinition{
			ConstraintName: $1,
			IndexName: $3,
			KeyPartList: $4,
			ReferenceDefinition: $5.(ReferenceDefinition),
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
	KeyBlockSizeKwd OptEq IntLiteral
	{
		$$ = $3
	}

IndexType:
	UsingKwd Identifier
	{
		$$ = $2
	}

Parser:
	WithParserKwd Identifier
	{
		$$ = $2
	}

Comment:
	CommentKwd StringLiteral
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
	AutoExtendedSizeKwd OptEq IntLiteral
	{
		$$ = $3
	}

AutoIncrementValue:
	AutoIncrementKwd OptEq IntLiteral
	{
		$$ = $3
	}

AvgRowLength:
	AvgRowLengthKwd OptEq IntLiteral
	{
		$$ = $3
	}

Checksum:
	ChecksumKwd OptEq IntLiteral
	{
		$$ = $3
	}

TableComment:
	CommentKwd OptEq StringLiteral
	{
		$$ = $3
	}

Compression:
	CompressionKwd OptEq StringLiteral
	{
		$$ = $3
	}

Connection:
	ConnectionKwd OptEq StringLiteral
	{
		$$ = $3
	}

DataDirectory:
	DataDirectoryKwd OptEq StringLiteral
	{
		$$ = $3
	}

IndexDirectory:
	IndexDirectoryKwd OptEq StringLiteral
	{
		$$ = $3
	}

DelayKeyWrite:
	DelayKeyWriteKwd OptEq IntLiteral
	{
		$$ = $3
	}

Encryption:
	EncryptionKwd OptEq StringLiteral
	{
		$$ = $3
	}

Engine:
	EngineKwd OptEq Identifier
	{
		$$ = $3
	}

EngineAttribute:
	EngineAttributeKwd OptEq StringLiteral
	{
		$$ = $3
	}

InsertMethod:
	InsertMethodKwd OptEq Identifier
	{
		$$ = $3
	}

MaxRows:
	MaxRowsKwd OptEq IntLiteral
	{
		$$ = $3
	}

MinRows:
	MinRowsKwd OptEq IntLiteral
	{
		$$ = $3
	}

PackKeys:
	PackKeysKwd OptEq IntLiteral
	{
		$$ = $3
	}

Password:
	PasswordKwd OptEq StringLiteral
	{
		$$ = $3
	}

RowFormat:
	RowFormatKwd OptEq Identifier
	{
		$$ = $3
	}

SecondaryEngineAttribute:
	SecondaryEngineAttributeKwd OptEq StringLiteral
	{
		$$ = $3
	}

StatsAutoRecalc:
	StatsAutoRecalcKwd OptEq IntLiteral
	{
		$$ = $3
	}

StatsPersistent:
	StatsPersistentKwd OptEq IntLiteral
	{
		$$ = $3
	}

StatsSamplePages:
	StatsSamplePagesKwd OptEq IntLiteral
	{
		$$ = $3
	}

TableSpace:
	TableSpaceKwd Identifier OptStorage
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
	StorageKwd Identifier
	{
		$$ = $2
	}

TableUnion:
	UnionKwd OptEq IdentifierList
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
	PartitionByKwd PartitionByHash
	{
		$$ = $2
	}
|	PartitionByKwd PartitionByKey
	{
		$$ = $2
	}
|	PartitionByKwd PartitionByRange
	{
		$$ = $2
	}
|	PartitionByKwd PartitionByList
	{
		$$ = $2
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
	PartitionsKwd IntLiteral
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
	SubpartitionByKwd PartitionByHash
	{
		$$ = $2
	}
|	SubpartitionByKwd PartitionByKey
	{
		$$ = $2
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
	SubpartitionsKwd IntLiteral
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
	RangeKwd Expression
	{
		$$ = PartitionBy{
		  Type: "RANGE",
		  Expression: $2,
		}
	}
|	RangeKwd COLUMNS IdentifierList
	{
		$$ = PartitionBy{
		  Type: "RANGE COLUMNS",
		  Columns: $3,
		}
	}

PartitionByList:
	ListKwd Expression
	{
		$$ = PartitionBy{
		  Type: "LIST",
		  Expression: $2,
		}
	}
|	ListKwd COLUMNS IdentifierList
	{
		$$ = PartitionBy{
		  Type: "LIST COLUMNS",
		  Columns: $3,
		}
	}

OptAlgorithm:
	{

	}
|	Algorithm
	{

	}

Algorithm:
	AlgorithmKwd OptEq IntLiteral
	{

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
	PartitionKwd Identifier PartitionValues PartitionOptions OptSubpartitionDefinitionList
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
	ValuesLessThanKwd Expression
	{
		$$ = []string{"LESS THAN", $2}
	}
|	ValuesInKwd Expression
	{
		$$ = []string{"IN", $2}
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
	TableSpaceKwd OptEq Identifier
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
	SubpartitionKwd Identifier PartitionOptions
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
		$$ = "0x" + $1.Literal[1:len($1.Literal)-1]
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

Expression:
	{

	}



CreateKwd:
	CREATE
	{ $$ = true }

UseKwd:
 	USE
 	{ $$ = true }

OptTemporaryKwd:
	{ $$ = false }
|   TemporaryKwd
    { $$ = true }

TemporaryKwd:
	TEMPORARY
	{ $$ = true }

DatabaseKwd:
	DATABASE
	{ $$ = true }
|	SCHEMA
	{ $$ = true }

TableKwd:
	TABLE
	{ $$ = true }

OptIfNotExistsKwd:
	{ $$ = false }
|	IfNotExistsKwd
    { $$ = true }

IfNotExistsKwd:
	IF_NOT_EXISTS
	{ $$ = true }

OptDefaultKwd:
	{ $$ = true }
|	DefaultKwd
	{ $$ = false }

DefaultKwd:
	DEFAULT
	{ $$ = true }

CharsetKwd:
	CHARACTER SET
	{ $$ = true }
|	CHARSET
	{ $$ = true }

CollateKwd:
	COLLATE
	{ $$ = true }

EncryptionKwd:
	ENCRYPTION
	{ $$ = true }

BitKwd:
	BIT
	{ $$ = true }

TinyIntKwd:
	TINYINT
	{ $$ = true }

BoolKwd:
	BOOL
	{ $$ = true }
|	BOOLEAN
	{ $$ = true }

SmallIntKwd:
	SMALLINT
	{ $$ = true }

MediumIntKwd:
	MEDIUMINT
	{ $$ = true }

IntKwd:
	INT
	{ $$ = true }
|	INTEGER
	{ $$ = true }

BigIntKwd:
	BIGINT
	{ $$ = true }

DecimalKwd:
	DECIMAL
	{ $$ = true }
|	DEC
	{ $$ = true }
|	FIXED
	{ $$ = true }

FloatKwd:
	FLOAT
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

VarcharKwd:
	VARCHAR
	{ $$ = true }

BinaryKwd:
	BINARY
	{ $$ = true }

VarBinaryKwd:
	VARBINARY
	{ $$ = true }

TinyBlobKwd:
	TINYBLOB
	{ $$ = true }

TinyTextKwd:
	TINYTEXT
	{ $$ = true }

BlobKwd:
	BLOB
	{ $$ = true }

TextKwd:
	TEXT
	{ $$ = true }

MediumBlobKwd:
	MEDIUMBLOB
	{ $$ = true }

MediumTextKwd:
	MEDIUMTEXT
	{ $$ = true }

LongBlobKwd:
	LONGBLOB
	{ $$ = true }

LongTextKwd:
	LONGTEXT
	{ $$ = true }

EnumKwd:
	ENUM
	{ $$ = true }

SetKwd:
	SET
	{ $$ = true }

JsonKwd:
	JSON
	{ $$ = true }

GeometryKwd:
	GEOMETRY
	{ $$ = true }

PointKwd:
	POINT
	{ $$ = true }

LineStringKwd:
	LINESTRING
	{ $$ = true }

PolygonKwd:
	POLYGON
	{ $$ = true }

MultiPointKwd:
	MULTIPOINT
	{ $$ = true }

MultiLineStringKwd:
	MULTILINESTRING
	{ $$ = true }

MultiPolygonKwd:
	MULTIPOLYGON
	{ $$ = true }

GeometryCollectionKwd:
	GEOMETRYCOLLECTION
	{ $$ = true }

OptUnsignedKwd:
	{ $$ = false }
|	UnsignedKwd
	{ $$ = true }

UnsignedKwd:
	UNSIGNED
	{ $$ = true }

ZerofillKwd:
	ZEROFILL
	{ $$ = true }

OptZerofillKwd:
	{ $$ = false }
|	ZerofillKwd
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

SridKwd:
	SRID
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

PrimaryKeyKwd:
	PRIMARY KEY
	{ $$ = true }

KeyBlockSizeKwd:
	KEY_BLOCK_SIZE
	{ $$ = true }

UsingKwd:
	USING
	{ $$ = true }

WithParserKwd:
	WITH PARSER
	{ $$ = true }

CommentKwd:
	COMMENT
	{ $$ = true }

ForeignKeyKwd:
	FOREIGN KEY
	{ $$ = true }

AutoExtendedSizeKwd:
	AUTOEXTENDED_SIZE
	{ $$ = true }

AutoIncrementKwd:
	AUTO_INCREMENT
	{ $$ = true }

AvgRowLengthKwd:
	AVG_ROW_LENGTH
	{ $$ = true }

ChecksumKwd:
	CHECKSUM
	{ $$ = true }

CompressionKwd:
	COMPRESSION
	{ $$ = true }

ConnectionKwd:
	CONNECTION
	{ $$ = true }

DelayKeyWriteKwd:
	DELAY_KEY_WRITE
	{ $$ = true }

DataDirectoryKwd:
	DATA DIRECTORY
	{ $$ = true }

EngineKwd:
	ENGINE
	{ $$ = true }

EngineAttributeKwd:
	ENGINE_ATTRIBUTE
	{ $$ = true }

IndexDirectoryKwd:
	INDEX DIRECTORY
	{ $$ = true }

InsertMethodKwd:
	INSERT_METHOD
	{ $$ = true }

MaxRowsKwd:
	MAX_ROWS
	{ $$ = true }

MinRowsKwd:
	MIN_ROWS
	{ $$ = true }

PackKeysKwd:
	PACK_KEYS
	{ $$ = true }

PasswordKwd:
	PASSWORD
	{ $$ = true }

RowFormatKwd:
	ROW_FORMAT
	{ $$ = true }

SecondaryEngineAttributeKwd:
	SECONDARY_ENGINE_ATTRIBUTE
	{ $$ = true }

StatsAutoRecalcKwd:
	STATS_AUTO_RECALC
	{ $$ = true }

StatsPersistentKwd:
	STATS_PERSISTENT
	{ $$ = true }

StatsSamplePagesKwd:
	STATS_SAMPLE_PAGES
	{ $$ = true }

TableSpaceKwd:
	TABLESPACE
	{ $$ = true }

StorageKwd:
	STORAGE
	{ $$ = true }

UnionKwd:
	UNION
	{ $$ = true }

PartitionByKwd:
	PARTITION BY
	{ $$ = true }

AlgorithmKwd:
	ALGORITHM
	{ $$ = true }

RangeKwd:
	RANGE
	{ $$ = true }

LinearKwd:
	LINEAR
	{ $$ = true }

ListKwd:
	LIST
	{ $$ = true }

PartitionKwd:
	PARTITION
	{ $$ = true }

PartitionsKwd:
	PARTITIONS
	{ $$ = true }

SubpartitionByKwd:
	SUBPARTITION BY
	{ $$ = true }

SubpartitionsKwd:
	SUBPARTITIONS
	{ $$ = true }

OptLinearKwd:
	{ $$ = false }
|	LinearKwd
	{ $$ = true }

PartitionStorageEngineKwd:
	STORAGE ENGINE
	{ $$ = true }
|	ENGINE
	{ $$ = true }

SubpartitionKwd:
	SUBPARTITION
	{ $$ = true }

ValuesLessThanKwd:
	VALUES LESS THAN
	{ $$ = true }

ValuesInKwd:
	VALUES IN
	{ $$ = true }

%%
