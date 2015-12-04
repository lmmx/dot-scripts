package main

import (
	"fmt"
	"github.com/PuerkitoBio/goquery"
	"log"
	"os"
)

func check(e error) {
	if e != nil {
		log.Fatal(e)
	}
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
		para := s.Text()
		fmt.Printf("Paragraph %d: %s", i, para)
	})
}
