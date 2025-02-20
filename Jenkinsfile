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

        stage('Upload Files to S3') {
            steps {
                script {
                    sh '''
                        echo "Uploading website files to S3..."
                        
                        # Ensure files exist
                        if [ ! -f "index.html" ] || [ ! -f "style.css" ] || [ ! -f "appspec.yml" ] || [ ! -d "scripts" ]; then
                            echo "Error: Required files are missing!"
                            exit 1
                        fi

                        # Upload files directly to S3
                        aws s3 cp index.html s3://$S3_BUCKET/
                        aws s3 cp style.css s3://$S3_BUCKET/
                        aws s3 cp appspec.yml s3://$S3_BUCKET/
                        aws s3 cp --recursive scripts/ s3://$S3_BUCKET/scripts/
                    '''
                }
            }
        }

        stage('Trigger AWS CodeDeploy') {
            steps {
                sh '''
                    DEPLOY_ID=$(aws deploy create-deployment \
                      --application-name $CODEDEPLOY_APP \
                      --deployment-group-name $CODEDEPLOY_GROUP \
                      --s3-location bucket=$S3_BUCKET,key=appspec.yml,bundleType=yaml \
                      --query "deploymentId" --output text)

                    echo "Triggered deployment: $DEPLOY_ID"
                '''
            }
        }
    }
}
