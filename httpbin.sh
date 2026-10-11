#!/bin/bash
set -e

tag="http-28609f1f"
quantity="20"
status="422"

capture() {
  task="$1"
  shift
  { set +x; } 2>/dev/null
  printf '\nHTTPBIN_BEGIN %s %s\n' "$tag" "$task"
  "$@"
  printf '\nHTTPBIN_END %s %s\n' "$tag" "$task"
  set -x
}

set -x

# 1. GET
capture GET curl -sS -H "X-Exam-Tag: http-28609f1f" "https://httpbin.org/get?course=TDS&tag=http-28609f1f"

# 2. POST
capture POST curl -sS -H "Content-Type: application/json" -d '{"tag":"http-28609f1f","quantity":20,"active":true}' https://httpbin.org/post

# 3. FORM
capture FORM curl -sS -X PUT -d "tag=http-28609f1f&quantity=20" https://httpbin.org/put

# 4. AUTH
capture AUTH curl -sS -H "Authorization: Bearer http-28609f1f" https://httpbin.org/bearer

# 5. REDIRECT: with literal url and -L
capture REDIRECT curl -sS -L "https://httpbin.org/redirect-to?url=https://httpbin.org/get?tag=http-28609f1f"

# 6. COOKIES: cookie set is OUTSIDE capture
rm -f cookies.txt
curl -sS -c cookies.txt "https://httpbin.org/cookies/set?exam=http-28609f1f" > /dev/null
capture COOKIES curl -sS -b cookies.txt https://httpbin.org/cookies
rm -f cookies.txt

# 7. STATUS
capture STATUS curl -sS -o /dev/null -w "%{http_code}" "https://httpbin.org/status/422"

{ set +x; } 2>/dev/null
