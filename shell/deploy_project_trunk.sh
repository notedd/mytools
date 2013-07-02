#!/bin/bash

project_svn_dir="/home/q/data/source/tts_java/trunk/"
project_name="ttstw"
war_name="tts.war"
project_root_dir="/home/q/www/$project_name/webapps/ROOT/"
project_path_dir="/home/q/www/$project_name/"

war_name_path="$project_svn_dir"target/$war_name

echo "# cd $project_svn_dir"
cd $project_svn_dir

echo "# sudo svn update"
sudo svn update

echo "# sudo mvn clean package -Pdev -Dmaven.test.skip"
sudo mvn clean package -Pdev -Dmaven.test.skip

echo "# cd $project_root_dir || exit 1"
cd $project_root_dir || exit 1

echo "# ls -l"
ls -l

echo "# sudo rm -rf *"
sudo rm -rf *

echo "# sudo cp $war_name_path ."
sudo cp $war_name_path .

echo "# sudo unzip -o $war_name"
sudo unzip -o $war_name

echo "# sudo rm $war_name -f"
sudo rm $war_name -f

echo "# sudo  nohup /home/q/tools/bin/restart_tomcat.sh /home/q/www/$project_name  > /dev/null 2>&1"
sudo  nohup /home/q/tools/bin/restart_tomcat.sh /home/q/www/$project_name  > /dev/null 2>&1

echo -e "#\r\ntail -f "$project_path_dir"logs/catalina.out \r\n"
tail -f "$project_path_dir"logs/catalina.out
