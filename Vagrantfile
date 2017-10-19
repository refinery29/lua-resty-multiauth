$scripts = {}
$scripts['bento-ubuntu-16-04'] = <<EOS
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

$scripts['bento-ubuntu-14-04'] = <<EOS
printf 'Checking for and retrieving apt prerequisites\n'
curl https://openresty.org/package/pubkey.gpg | sudo apt-key add -
apt-get -y install software-properties-common
add-apt-repository -y "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main"
apt-get update
apt-get install --no-install-recommends git openresty -qq

ln -s /etc/{openresty,nginx}
ln -s /etc/init.d/{openresty,nginx}

mkdir /etc/nginx/{conf.d,sites-{enabled,available}}

cat >/etc/nginx/nginx.conf <<EOF
worker_processes auto;

events {
    worker_connections 768;
}

http {
    include /etc/nginx/conf.d/*;
    include /etc/nginx/sites-enabled/*;
}
EOF

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
    machines = %w(bento/ubuntu-16.04 bento/ubuntu-14.04)
    machines.each_with_index do |release, index|
        machine_name = release.gsub(/(\/|\.)/, '-')
        config.vm.define machine_name do |machine|
            machine.vm.box = release

            config.vm.network "private_network", ip: "192.168.29.#{42 + index}"
            config.vm.provision "shell", inline: $scripts[machine_name], privileged: true
        end
    end
end
