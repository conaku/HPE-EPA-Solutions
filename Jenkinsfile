pipeline {
agent none
stages {
stage('Git pull'){
agent{label 'master'}
steps{
sh '''
su - root << EOF
root
git clone https://github.com/conaku/HPE-EPA-Solutions.git /var/lib/jenkins/workspace/Deployment_scripts
EOF
'''
}
}
}
}
