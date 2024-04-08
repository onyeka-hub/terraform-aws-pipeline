// pipeline {
//     agent any

//     environment {
//         TF_CLI_ARGS = '-no-color'
//     }

//     stages {
//         stage('Checkout') {
//             steps {
//                 script {
//                     checkout scm
//                 }
//             }
//         }

//         stage('Terraform Plan') {
//             steps {
//                 script {
//                     withCredentials([aws(credentialsId: 'AWS_CRED', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
//                         sh 'terraform init'
//                         sh 'terraform plan -out=tfplan'
//                     }
//                 }
//             }
//         }

//         stage('Terraform Apply') {
//             when {
//                 expression { env.BRANCH_NAME == 'main' }
//                 expression { currentBuild.rawBuild.getCause(hudson.model.Cause$UserIdCause) != null }
//             }
//             steps {
//                 script {
//         //             // Ask for manual confirmation before applying changes
//                     input message: 'Do you want to apply changes?', ok: 'Yes'
//                     withCredentials([aws(credentialsId: 'AWS_CRED', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
//                         sh 'terraform init'
//                         sh 'terraform aply -out=tfplan'
//                     }
//                 }
//             }
//         }
//     }
// }

pipeline {
    agent any

    environment {
        TF_CLI_ARGS = '-no-color'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        stage('Terraform Lint') {
            steps {
                script {
                    echo 'Executing Terraform Lint...'
                    sh 'terraform init -input=false -no-color'
                    sh 'terraform validate'
                    echo 'Terraform Lint executed successfully.'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    echo 'Executing Terraform Plan...'
                    withCredentials([aws(credentialsId: 'AWS_CRED', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh 'terraform init -input=false -no-color'
                        sh 'terraform plan -input=false -no-color'
                    }
                    echo 'Terraform Plan executed successfully.'
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { env.BRANCH_NAME == 'main' }
                expression { currentBuild.rawBuild.getCause(hudson.model.Cause$UserIdCause) != null }
            }
            steps {
                script {
                    try {
                        // Ask for manual confirmation before applying changes
                        input message: 'Do you want to apply changes?', ok: 'Yes'
                        echo 'Executing Terraform Apply...'
                        withCredentials([aws(credentialsId: 'AWS_CRED', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                            sh 'terraform init -input=false -no-color'
                            sh 'terraform apply tfplan -input=false -no-color'
                        }
                        echo 'Terraform Apply executed successfully.'
                    } catch (Exception e) {
                        echo "An error occurred: ${e.message}"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }

        stage('Error Handling') {
            when {
                expression { currentBuild.result == 'SUCCESS' }
            }
            steps {
                echo 'Error occurred during pipeline execution. Handling...'
                // Add error handling tasks here, if any
                echo 'Error handling completed.'
            }
        }

        stage('Cleanup') {
            steps {
                echo 'Performing cleanup...'
                cleanWs(cleanWhenAborted: true, cleanWhenFailure: true, cleanWhenNotBuilt: true, cleanWhenUnstable: true, deleteDirs: true)
                echo 'Cleanup completed.'
            }
        }
    }
}


// pipeline {
//     agent any
    
//     environment {
//         // Assign the AWS credentials to the environment variable
//         MAIN_BRANCH_CREDENTIALS = credentials('AWS_CRED')
//     }

//     stages {
//         stage('Checkout') {
//             steps {
//                 script {
//                     // Checkout the main branch from the Git repository
//                     checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[url: 'https://github.com/onyeka-hub/terraform-aws-pipeline.git']]])
//                 }
//             }
//         }

//         stage('Build') {
//             steps {
//                 script {
//                     // Use the AWS credentials stored in the environment variable
//                     withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_CRED', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
//                         // Your build steps here
//                         // You can access AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY variables here
//                     }
//                 }
//             }
//         }
//     }
// }