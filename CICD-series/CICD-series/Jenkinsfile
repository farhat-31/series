pipeline {
    agent any

    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'apply = create resources, destroy = delete them')
        booleanParam(name: 'AUTO_APPROVE', defaultValue: true, description: 'Skip the manual approval step')
    }

    environment {
        TF_DIR             = 'Day-1-terraform-cicd-jenkins'
        AWS_DEFAULT_REGION = 'ap-south-1'   // change to your region
        TF_IN_AUTOMATION   = 'true'
    }

    stages {
        stage('git checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/farhat-31/CICD-series.git'
                // Private repo? Use this instead:
                // git branch: 'main', credentialsId: 'github-token', url: 'https://github.com/farhat-31/CICD-series.git'
            }
        }

        stage('check files') {
            steps {
                sh 'echo "Using folder: $TF_DIR"; find . -name "*.tf" -not -path "*/.terraform/*"'
                sh 'ls "$TF_DIR"/*.tf || { echo "ERROR: no .tf files in $TF_DIR"; exit 1; }'
            }
        }

        stage('init') {
            steps {
                dir("${env.TF_DIR}") {
                    sh 'terraform init -input=false -no-color'
                }
            }
        }

        stage('validate') {
            steps {
                dir("${env.TF_DIR}") {
                    sh 'terraform validate -no-color'
                }
            }
        }

        stage('plan') {
            steps {
                dir("${env.TF_DIR}") {
                    script {
                        def flag = (params.ACTION == 'destroy') ? '-destroy' : ''
                        sh "terraform plan -input=false -no-color ${flag} -out=tfplan"
                    }
                }
            }
        }

        stage('approval') {
            when { expression { return !params.AUTO_APPROVE } }
            steps {
                input message: "Run terraform ${params.ACTION}?", ok: 'Yes'
            }
        }

        stage('apply / destroy') {
            steps {
                dir("${env.TF_DIR}") {
                    sh 'terraform apply -input=false -no-color tfplan'
                    sh 'terraform output || true'
                }
            }
        }
    }

    post {
        always {
            echo "ACTION=${params.ACTION} finished: ${currentBuild.currentResult}"
        }
    }
}
