package main

import (
	"bufio"
	"bytes"
	_ "embed"
	"os"
	"sort"
	"text/template"
)

//go:generate go run gen.go

//go:embed keyword.go.tmpl
var tokensTemplate string

func main() {
	f, err := os.Open("gen/keyword.txt")
	if err != nil {
		panic(err)
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)
	scanner.Split(bufio.ScanLines)
	tokens := []string{}
	for scanner.Scan() {
		tokens = append(tokens, scanner.Text())
	}

	sort.Strings(tokens)

	t, err := template.New("tokens").Parse(tokensTemplate)
	if err != nil {
		panic(err)
	}

	var buf bytes.Buffer
	err = t.Execute(&buf, map[string][]string{
		"Tokens": tokens,
	})

	f2, err := os.Create("parser/keyword.go")
	f2.Write(buf.Bytes())
	defer f2.Close()

}
