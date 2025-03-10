pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        S3_BUCKET = 'my-codedeploy-bucket-3731'
        CODEDEPLOY_APP = 'MyStaticWebsite'
        CODEDEPLOY_GROUP = 'MyDeploymentGroup'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', credentialsId: 'github-ssh-key', url: 'https://github.com/nitron18/static-website.git'
            }
        }

        stage('Package and Upload to S3') {
            steps {
                script {
                    sh '''
                        echo "Packaging website files..."
                        zip -r deploy.zip index.html style.css appspec.yml scripts/

                        echo "Uploading to S3..."
                        aws s3 cp deploy.zip s3://my-codedeploy-bucket-3731/
                    '''
                }
            }
        }

        stage('Trigger AWS CodeDeploy') {
            steps {
                script {
                    sh '''
                        DEPLOY_ID=$(aws deploy create-deployment \
                          --application-name $CODEDEPLOY_APP \
                          --deployment-group-name $CODEDEPLOY_GROUP \
                          --s3-location bucket=$S3_BUCKET,key=deploy.zip,bundleType=zip \
                          --query "deploymentId" --output text)

                        echo "Triggered deployment: $DEPLOY_ID"
                    '''
                }
            }
        }
    }
}
