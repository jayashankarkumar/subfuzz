#!/bin/bash
if ! [ -x "$(command -v sublist3r)" ]; then
    cd /root/ && git clone https://github.com/aboul3la/Sublist3r.git
    cd /root/Sublist3r*
    pip install -r requirements.txt
    cd /root/
fi

if ! [ -x "$(command -v findomain)" ]; then
     cd /root/ && git clone https://github.com/Edu4rdSHL/findomain.git
     cd findomain
     cargo build --release
     sudo cp target/release/findomain /usr/bin/
     cd /root/
fi

if ! [ -x "$(command -v findomain)" ]; then
     go get -v github.com/projectdiscovery/subfinder/cmd/subfinder
fi
echo "Hey there"
echo "Input type: "
echo "1.Domain [Ex: domain.com]"
echo "2.File [Ex: domains_list.txt]"
read n

if [ $n == 1 ];
then
 echo "Staring subdomain enumeration"
 echo
 findomain -t $1 -u sub.txt
 echo
 curl -s https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1 | tee -a sub.txt
 echo
 subfinder -d $1 -o sub.txt
 echo
 python /root/Sublist3r/sublist3r.py -d $1 -o sub.txt
 echo
 cat sub.txt | sort -u | sed 's/<.*//' > subdomains.txt
 echo
 rm sub.txt
 echo "Output file is saved in /root/subdomains.txt and the file count is: "
 cat subdomains.txt | wc -l
fi

if [ $n == 2 ];
then
 echo "1.sublist3r"
 echo "2.subfinder"
 echo "3.findimain"
 echo "4.certspotter"
 echo "5.All the above.[This takes lot of time!!!]"
 sleep 2
 echo "Select a script to loop!"
 read n

if [ $n == 1 ];
then
 echo "Looping with sublist3r!"
 for domain in $(cat $1); do python /root/Sublist3r/sublist3r.py -d $domain -o more.subdomains.txt;done
 echo
 echo "Done with looping!"
fi

if [ $n == 2 ];
then
 echo "Looping with subfinder!"
 for domain in $(cat $1); do subfinder -d $domain -t 100 -o more.subdomains.txt;done
 echo
 echo "Done with looping!"
fi

if [ $n == 3 ];
then
 echo "Looping with findomain!"
 for domain in $(cat $1); do findomain -t $domain -u more.subdomains.txt;done
 echo
 echo "Done with looping!"
fi

if [ $n == 4 ];
then
 echo "Looping with certspotter!"
 for domain in $(cat $1); do curl -s https://certspotter.com/api/v0/certs\?domain\=$domain | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $d
omain | tee -a more.subdomains.txt;done
 echo
 echo "Done with looping!"
fi

if [ $n == 5 ];
then
 echo "Looping with all the above scripts!!!"
 for domain in $(cat $1); do python /root/tools/Sublist3r/sublist3r.py -d $domain -o more.subdomains.txt;done
 for domain in $(cat $1); do subfinder -d $domain -t 100 -o more.subdomains.txt;done
 for domain in $(cat $1); do findomain -t $domain -u more.subdomains.txt;done
 for domain in $(cat $1); do curl -s https://certspotter.com/api/v0/certs\?domain\=$domain | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $domain | tee -a more.subdomains.txt;done
 echo
 echo "Done with looping!!!!!"
fi
fi
echo "Output is saved in /root/"
