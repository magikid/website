set dotenv-load := true

deploy:
    hugo --gc --minify --cleanDestinationDir --environment production
    hugo deploy
    s3cmd setacl s3://cwj-website/ --acl-public --recursive
