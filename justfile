deploy:
    @echo "Copying CNAME file to dist/ directory..."
    cp CNAME dist/
    @echo "Deploying to gh-pages..."
    gh-pages -d dist
