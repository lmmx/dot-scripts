package main

import (
	"bytes"
	"fmt"
	"github.com/PuerkitoBio/goquery"
	"golang.org/x/net/html"
	"log"
	"os"
)

// Should make this multipurpose with flags for innerHTML/outerHTML/innerText grabbing
// for now it's just outerHTML for a given CSS selector-chosen element

// cannot extend type from package, but can define alias/sub-package
// via http://stackoverflow.com/a/28800807/2668831

type ParserSelection goquery.Selection

func check(e error) {
	if e != nil {
		log.Fatal(e)
	}
}

// Implemented from equivalent for InnerHtml (see .Html() in goquery/property.go)
func (s *ParserSelection) OuterHtml() (ret string, e error) {
	// Since there is no .outerHtml, the HTML content must be re-created from
	// the node using html.Render
	var buf bytes.Buffer
	if len(s.Nodes) > 0 {
		c := s.Nodes[0]
		e = html.Render(&buf, c)
		if e != nil {
			return
		}
		ret = buf.String()
	}
	return
}

func main() {
	if len(os.Args) != 3 {
		panic(fmt.Sprintf("Number of arguments: %v. Please pass 1 file and 1 CSS selector to this script", len(os.Args)-1))
	}
	filename := os.Args[1]
	// just use one HTML file at a time in this script but obviously multiple possible
	//	args.Each...
	f, err := os.Open(filename)
	defer f.Close()
	check(err)
	doc, err := goquery.NewDocumentFromReader(f)
	check(err)
	selector := os.Args[2]
	doc.Find(selector).Each(func(i int, s *goquery.Selection) {
		// mask the Selection type so Go doesn't grumble
		mask := ParserSelection(*s)
		element, err := mask.OuterHtml()
		check(err)
		fmt.Printf(element)
	})
}
