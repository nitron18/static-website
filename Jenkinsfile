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
                git branch: 'main', url: 'https://github.com/nitron18/static-website.git'
            }
        }

    stage('Upload to S3') {
        steps {
            script {
                sh '''
                    echo "Verifying files before upload..."
                    ls -lah

                    # Ensure the files exist before zipping
                    if [ ! -f "index.html" ] || [ ! -f "styles.css" ] || [ ! -f "appspec.yml" ] || [ ! -d "scripts" ]; then
                        echo "Error: Required files are missing!"
                        exit 1
                    fi

                    # Zip the files properly
                    zip -r deploy.zip index.html styles.css appspec.yml scripts/

                    # Verify zip creation
                    ls -lah deploy.zip

                    # Upload to S3
                    aws s3 cp deploy.zip s3://my-static-website-deployments/
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
                      --s3-location bucket=$S3_BUCKET,key=deploy.zip,bundleType=zip \
                      --query "deploymentId" --output text)

                    echo "Triggered deployment: $DEPLOY_ID"
                '''
            }
        }
    }
}
