pipeline {
agent none
stages {
stage('Git pull'){
agent{label 'master'}
steps{
sh '''
su - root << EOF
root
git clone https://github.com/svn123/Spark_zeppelin_script.git /var/lib/jenkins/workspace/Deployment_scripts
EOF
'''
}
}
}
}
