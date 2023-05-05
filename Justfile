set dotenv-load := true

deploy:
    hugo --gc --minify --cleanDestinationDir --environment production
    hugo deploy
    s3cmd setacl s3://cwj-website/ --acl-public --recursive

new-post postname:
    hugo new content/posts/{{postname}}.md
