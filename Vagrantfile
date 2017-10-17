$script = <<EOS
printf 'Checking for and retrieving apt prerequisites\n'
apt-get update
apt-get install -y nginx-extras lua-cjson lua-zlib

printf 'Checking for lua prerequisite code\n'
for r in lua-resty-lrucache lua-resty-iputils github-oauth-nginx
do
    printf 'Checking for %s\n' "$r"
    if [ -d "/srv/$r" ]
    then
        printf '%s already present.\n' "$r"
    else
        printf '%s not present, cloning...\n' "$r"
        git clone "https://github.com/refinery29/$r.git" "/srv/$r"
    fi
done

if [ -e /etc/nginx/sites-available/default ]
then
    printf 'nginx default site enabled, disabling...\n'
    rm /etc/nginx/sites-available/default
    [ -e /etc/nginx/sites-enabled/default ] && rm /etc/nginx/sites-enabled/default
fi

printf 'Ensuring multiauth nginx config files linked and enabled\n'
for f in $(find /vagrant/nginx-example-config -type f)
do
    printf 'Ensuring link of %s...\n'  "$f"
    ln -sf "$f" "/etc/nginx/$(echo "$f" | cut -d'/' -f4-)"
done

printf 'Restarting nginx...\n'
service nginx restart
EOS

Vagrant.configure(2) do |config|
    config.vm.box = "ubuntu/xenial64"
    config.vm.network "private_network", ip: "192.168.29.42"
    config.vm.provision "shell", inline: $script, privileged: true
end
