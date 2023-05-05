deploy:
    hugo --gc --minify --cleanDestinationDir --environment production
    rsync -avz --delete public/ zoidberg.vpn.hilandchris.com:/var/www/christopherjones.us/

new-post postname:
    hugo new content/posts/{{postname}}.md
