#!/usr/bin/env node

var exec = require('child_process').exec
var san = require('sanitize-html')
function puts(error, stdout, stderr) { console.log(san(stdout)) }
exec("xclip -o", puts)
