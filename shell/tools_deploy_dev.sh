#!/bin/bash

#./tools_deploy_dev.sh l-ttsn8.f.dev.cn6 user.name ttstw tts.war .

host="$1"
user="$2"
project_name="$3"
war_name="$4"
warpath="$5"

war_path="$warpath"/$war_name
project_name="$project_name"
project_path=/home/q/www/$project_name/

root_path="$project_path"webapps/ROOT

echo "deploy start! "

#echo "mvn clean package -Pdev -Dmaven.test.skip"
#mvn clean package -Pdev -Dmaven.test.skip || exit 1

if [ ! -f "$war_path" ];then
    echo "error: $war_path not found!" && exit 1
fi

echo "scp $war_path $user@$host:/home/$user"
scp $war_path $user@$host:/home/$user || exit 1

sleep 3
ssh $user@$host <<EOF
    source /etc/profile
    printf "hostname:" && hostname
    
    echo "# cd $root_path"
    cd $root_path || exit 1 
    
    echo "# ls -l"
    ls -l       

    echo "# sudo rm * -rf"
    echo "wait 5s..."
    sleep 5
    sudo rm * -rf

    echo "# sudo cp ~/$war_name ."  
    sudo cp ~/$war_name .

    echo "# unzip -o $war_name"
    sudo  unzip -o $war_name
    
    echo "# rm $war_name -f"
    sudo rm $war_name -f

    echo "# sudo  nohup /home/q/tools/bin/restart_tomcat.sh /home/q/www/$project_name  > /dev/null 2>&1"
    sudo  nohup /home/q/tools/bin/restart_tomcat.sh /home/q/www/$project_name  > /dev/null 2>&1
    
    echo -e "\r\ntail -f catalina.out \r\n"
    tail -f "$project_path"logs/catalina.out

EOF
