def packageChart(String chart, String package_path) {
    sh ("./cr package ${chart} --package-path ${package_path}")
}

// Get the commit hash 
String gitRevision() {
    return sh(
        script: "git rev-parse HEAD",
        returnStdout: true
    )
}

pipeline {

   environment {
    CHARTS_REPO_URL = "https://singularity-dao.github.io/helm-charts/"
    CHARTS_DIR = "charts"
    RELEASE_PACKAGE_DIR = ".cr-release-packages"
    INDEX_DIR = ".cr-index"
    CR_GIT_REPO = "helm-charts"
    CR_OWNER = "Singularity-DAO"
    CR_PAGES_BRANCH = "main"
   }

   agent {
      label 'fargate'
   }

   stages {

        stage("Configure Chart Releaser") {
            steps {
                script {
                    echo "Installing Chart Releaser"
                    sh ('''
                        curl -sSLo cr.tar.gz "https://github.com/helm/chart-releaser/releases/download/v1.5.0/chart-releaser_1.5.0_linux_amd64.tar.gz"
                        tar -xzf cr.tar.gz -C $(pwd)
                        rm cr.tar.gz
                    ''')
                }
            }
        }

        stage('Package Charts'){
            steps {
                script {
                    echo "Packaging API Chart."
                    sh ("mkdir -p ${RELEASE_PACKAGE_DIR}")
                    sh ("mkdir -p ${INDEX_DIR}")
                    packageChart("${CHARTS_DIR}/launchpad-services-api", "${RELEASE_PACKAGE_DIR}")
                    packageChart("${CHARTS_DIR}/msd-fastapi", "${RELEASE_PACKAGE_DIR}")
                    packageChart("${CHARTS_DIR}/dynaset-services", "${RELEASE_PACKAGE_DIR}")
                    packageChart("${CHARTS_DIR}/execution-services", "${RELEASE_PACKAGE_DIR}")
                }
            }
        }
        stage('Release Chart') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'Jenkinsprivateac', usernameVariable: "GIT_OWNER", passwordVariable: "CR_TOKEN")]) {
                        echo "Releasing API CHARTS"
                        CR_COMMIT=gitRevision()
                        sh ('''
                            ./cr upload --skip-existing
                        ''')
                    }
                }
            }
        }

        stage('Update Index') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'Jenkinsprivateac', usernameVariable: "GIT_OWNER", passwordVariable: "CR_TOKEN")]) {
                        echo "Updating Index for Chart"
                        sh('''
                        ./cr index
                        ''')
                    }
                }
            }
        }
        stage('Push Index To Github') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'Jenkinsprivateac', usernameVariable: "GIT_OWNER", passwordVariable: "CR_TOKEN")]) {
                        echo "Updating Index for Chart"
                        sh('''
                        ./cr index --push
                        ''')
                    }
                }
            }
        }
    }
    post {
        always {
            deleteDir()
        }
    }
}
