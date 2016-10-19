node("fq-jenkins") {
    stage concurrency: 1, name: 'Backup'
    sh """
        export CLOUDSDK_PYTHON_SITEPACKAGES=1
        
        ${HOME}/google-cloud-sdk/bin/gcloud config set account ${JENKINS_SVC_ACCOUNT}
        
        CLOUDSDK_PYTHON_SITEPACKAGES=1 ${HOME}/google-cloud-sdk/bin/gcloud auth activate-service-account '${JENKINS_SVC_ACCOUNT}' --key-file ${HOME}/.gcp/accounts.json
        
        /home/jenkins/google-cloud-sdk/bin/gcloud compute --project '${PROJECT_ID}' disks snapshot '${SNAPSHOT_SOURCE}' --zone '${SNAPSHOT_ZONE}' --description '${SNAPSHOT_DESCRIPTION}' --snapshot-names '${SNAPSHOT_NAME}'-`date +'%Y%m%d'`
    """
}
