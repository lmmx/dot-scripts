cd /gits/copermut.wiki/
git pull
cp /gits/copermut.wiki/*.md /gits/copermut.github.io/_wiki/
cd /gits/copermut.github.io/_wiki/
git pull # get any web interface-added pages (bad idea to do!)
echo "Press any key to proceed"
read dummyvar
for filename in *.md; do
	echo "---" > ../_posts/"2000-01-01-$filename"
	echo "layout: post" >> ../_posts/"2000-01-01-$filename"
	echo "---" >> ../_posts/"2000-01-01-$filename"
	# prepend YAML layout header to ensure it's rendered by Jekyll
	cat $filename >> ../_posts/"2000-01-01-$filename"
done
echo "just 'getgot' or write a commit message and push to the site"
