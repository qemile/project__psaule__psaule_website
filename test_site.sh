#!/bin/bash

# Test script to verify the site works correctly
set -e

echo "====================================="
echo "Testing psaule-site Docker container"
echo "====================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Test 1: Check if container is running
echo "Test 1: Container is running..."
if docker ps | grep -q psaule-debug; then
    echo -e "${GREEN}✓ Container is running${NC}"
else
    echo -e "${RED}✗ Container is NOT running${NC}"
    exit 1
fi
echo ""

# Test 2: Check if index.php returns HTML
echo "Test 2: index.php returns HTML..."
CONTENT_TYPE=$(curl -s -I http://localhost:8080/ | grep -i "content-type" | cut -d' ' -f2 | tr -d '\r')
if [[ "$CONTENT_TYPE" == *"text/html"* ]]; then
    echo -e "${GREEN}✓ index.php returns HTML (Content-Type: $CONTENT_TYPE)${NC}"
else
    echo -e "${RED}✗ index.php does NOT return HTML (Content-Type: $CONTENT_TYPE)${NC}"
    exit 1
fi
echo ""

# Test 3: Check if CSS file is served correctly
echo "Test 3: CSS file is served correctly..."
CSS_CONTENT_TYPE=$(curl -s -I http://localhost:8080/assets/css/style.css | grep -i "content-type" | cut -d' ' -f2 | tr -d '\r')
CSS_SIZE=$(curl -s -I http://localhost:8080/assets/css/style.css | grep -i "content-length" | cut -d' ' -f2 | tr -d '\r')
if [[ "$CSS_CONTENT_TYPE" == *"text/css"* ]] && [[ "$CSS_SIZE" -gt 1000 ]]; then
    echo -e "${GREEN}✓ CSS is served correctly (Content-Type: $CSS_CONTENT_TYPE, Size: $CSS_SIZE bytes)${NC}"
else
    echo -e "${RED}✗ CSS is NOT served correctly (Content-Type: $CSS_CONTENT_TYPE, Size: $CSS_SIZE bytes)${NC}"
    exit 1
fi
echo ""

# Test 4: Check if JS file is served correctly
echo "Test 4: JS file is served correctly..."
JS_CONTENT_TYPE=$(curl -s -I http://localhost:8080/assets/js/main.js | grep -i "content-type" | cut -d' ' -f2 | tr -d '\r')
JS_SIZE=$(curl -s -I http://localhost:8080/assets/js/main.js | grep -i "content-length" | cut -d' ' -f2 | tr -d '\r')
if [[ "$JS_CONTENT_TYPE" == *"javascript"* ]] && [[ "$JS_SIZE" -gt 1000 ]]; then
    echo -e "${GREEN}✓ JS is served correctly (Content-Type: $JS_CONTENT_TYPE, Size: $JS_SIZE bytes)${NC}"
else
    echo -e "${RED}✗ JS is NOT served correctly (Content-Type: $JS_CONTENT_TYPE, Size: $JS_SIZE bytes)${NC}"
    exit 1
fi
echo ""

# Test 5: Check if preloader fix is in main.js
echo "Test 5: Preloader timeout fix is present..."
if curl -s http://localhost:8080/assets/js/main.js | grep -q "setTimeout"; then
    echo -e "${GREEN}✓ Preloader timeout fix is present in main.js${NC}"
else
    echo -e "${RED}✗ Preloader timeout fix is NOT present in main.js${NC}"
    exit 1
fi
echo ""

# Test 6: Check if main.js content is actually JavaScript
echo "Test 6: main.js contains valid JavaScript..."
FIRST_LINE=$(curl -s http://localhost:8080/assets/js/main.js | head -n 1)
if [[ "$FIRST_LINE" != *"<!DOCTYPE"* ]] && [[ "$FIRST_LINE" != *"<html"* ]]; then
    echo -e "${GREEN}✓ main.js contains JavaScript code (not HTML)${NC}"
else
    echo -e "${RED}✗ main.js is returning HTML instead of JavaScript!${NC}"
    exit 1
fi
echo ""

# Test 7: Verify CSS is not returning HTML
echo "Test 7: CSS file is not returning HTML..."
CSS_FIRST_LINE=$(curl -s http://localhost:8080/assets/css/style.css | head -n 1)
if [[ "$CSS_FIRST_LINE" == *"<!DOCTYPE"* ]] || [[ "$CSS_FIRST_LINE" == *"<html"* ]]; then
    echo -e "${RED}✗ CSS is returning HTML instead of CSS!${NC}"
    exit 1
else
    echo -e "${GREEN}✓ CSS file is not returning HTML${NC}"
fi
echo ""

# Test 8: Check if images are served correctly
echo "Test 8: Images are served correctly..."
IMG_CONTENT_TYPE=$(curl -s -I http://localhost:8080/assets/img/psaule_favicon.png | grep -i "content-type" | cut -d' ' -f2 | tr -d '\r')
if [[ "$IMG_CONTENT_TYPE" == *"image"* ]]; then
    echo -e "${GREEN}✓ Images are served correctly (Content-Type: $IMG_CONTENT_TYPE)${NC}"
else
    echo -e "${RED}✗ Images are NOT served correctly (Content-Type: $IMG_CONTENT_TYPE)${NC}"
    exit 1
fi
echo ""

echo "====================================="
echo -e "${GREEN}All tests passed! ✓${NC}"
echo "====================================="
echo ""
echo "If the site still shows a preloader in your browser:"
echo "1. Open DevTools (F12)"
echo "2. Go to Application > Storage > Clear site data"
echo "3. Or use Ctrl+Shift+Delete to clear browser cache"
echo "4. Then reload with Ctrl+Shift+R"
