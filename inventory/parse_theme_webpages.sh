#!/usr/bin/env bash

for theme in theme*/; do
  ftpattern="$theme"*mod*/
  thememoddirs=( $ftpattern )
  firstthememoddir="${thememoddirs[0]}"
  ftdpattern="$firstthememoddir"*.html
  firstthememodfiles=( $ftdpattern )
  firstthememodfile="${firstthememodfiles[0]}"
  modprefixline="$(grep -n '<div id=\"page\">' $firstthememodfile | cut -f1 -d:)"
  (( modprefixline-- ))

  # BEGIN CREATING WEB PAGE FOR EACH THEME

  # Print up to end of the page header, where #page-body should begin
  theme_html=$(sed -n '1,'"$modprefixline"'p' "$firstthememodfile"
  
  # Next fill in multiple div#page elements for the entire theme with:
  #   - as many #page elements as there are modules in the theme
  #   - as many #page-body elements as there are steps in each module

  # For each theme module, take the first file's #page start tag to its #header end tag
  #   - then for each step in the module, add the #page-body
  #   - then finish off with the first file's #page-body end tag to its #page end tag

  for thememod in "$theme"*mod*/; do
    pattern="$thememod*.html"
    modfiles=( $pattern )
    firstmodfile="${modfiles[0]}"
    modpagestartline="$(grep -n '<div id=\"page\">' $firstmodfile | cut -f1 -d:)"
    modprefixline=$(grep -n '<!-- id=\"header\" -->' $firstmodfile | cut -f1 -d:)

    # first file's #page start tag to its #header end tag
    sed -n "$modpagestartline"','"$modprefixline"'p' "$firstmodfile"

    htmlstr=$(for themefile in "$thememod"*.html; do
      echo '<!-- sourcing from "$themefile" -->'
      parsedom "$themefile" "#page-body"
      echo ""
      echo '<!-- sourced from "$themefile" -->'
    done)
    # Print multiple #page-body elements (no unique ID naming, whatever)
    echo "$htmlstr"

    modinsertline=$(grep -n '<!-- id=\"page-body\" -->' $firstmodfile | cut -f1 -d:)
    modpageendline=$(grep -n '<!-- id=\"page\" -->' $firstmodfile | cut -f1 -d:)

    (( modinsertline++ )) # move past the end of the #page-body tags, recomment it:
    echo ""
    echo '<!-- end of '"$(basename $thememod)"' #page-body tags -->'

    # Only need this once, the footer and the Javascript:
    # Print what comes after the #page-body elements: #footer to end of #page element
    sed -n "$modinsertline"','"$modpageendline"'p' "$firstmodfile"
  done

  echo '  </body>'
  echo '</html>')

  echo "BELOW IS THEME $theme :"
  echo "$theme_html"
  echo ""
done
