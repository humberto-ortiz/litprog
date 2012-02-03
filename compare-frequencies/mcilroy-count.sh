#!/bin/sh

tr -cs A-Za-z '
' | tr A-Z a-z | sort | uniq -c | sort -rn | sed ${1}q

