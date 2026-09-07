

pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-northeast-1'
        AWS_ACCOUNT_ID = '597994428626'
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

        NEXUS_SETTINGS_ID = '4b74d0c0-9d58-4550-9968-5ea92a1cefc6'

        SERVICES = 'auth-service user-service address-service category-service product-service cart-service order-service notification-service'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out Amma Pickles source code...'

                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                sh '''
                    set -e

                    for SERVICE in $SERVICES
                    do
                        echo "===== Building $SERVICE ====="

                        cd "$SERVICE"

                        chmod +x ../mvnw

                        ../mvnw clean verify

                        cd ..
                    done
                '''
            }
        }

        stage('Publish Maven Artifacts to Nexus') {
            steps {

                withCredentials([
                    usernamePassword(
                        credentialsId: 'nexus-maven',
                        usernameVariable: 'NEXUS_USERNAME',
                        passwordVariable: 'NEXUS_PASSWORD'
                    )
                ]) {

                    configFileProvider([
                        configFile(
                            fileId: "${NEXUS_SETTINGS_ID}",
                            variable: 'MAVEN_SETTINGS'
                        )
                    ]) {

                        sh '''
                            set -e

                            for SERVICE in $SERVICES
                            do
                                echo "===== Publishing $SERVICE to Nexus ====="

                                cd "$SERVICE"

                                ../mvnw deploy \
                                    --settings "$MAVEN_SETTINGS" \
                                    -DskipTests

                                cd ..
                            done
                        '''
                    }
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                sh '''
                    set -e

                    SHORT_COMMIT=$(printf "%.7s" "$GIT_COMMIT")
                    IMAGE_TAG="${BUILD_NUMBER}-${SHORT_COMMIT}"

                    echo "Docker image tag: $IMAGE_TAG"

                    for SERVICE in $SERVICES
                    do
                        echo "===== Building Docker image for $SERVICE ====="

                        docker build \
                            -t "${SERVICE}:${IMAGE_TAG}" \
                            "./${SERVICE}"
                    done
                '''
            }
        }

        stage('Login to Amazon ECR') {
            steps {
                sh '''
                    set -e

                    echo "Logging in to Amazon ECR..."

                    aws ecr get-login-password \
                        --region "$AWS_REGION" \
                    | docker login \
                        --username AWS \
                        --password-stdin "$ECR_REGISTRY"
                '''
            }
        }

        stage('Push Images to ECR') {
            steps {
                sh '''
                    set -e

                    SHORT_COMMIT=$(printf "%.7s" "$GIT_COMMIT")
                    IMAGE_TAG="${BUILD_NUMBER}-${SHORT_COMMIT}"

                    for SERVICE in $SERVICES
                    do
                        echo "===== Pushing $SERVICE:$IMAGE_TAG to ECR ====="

                        docker tag \
                            "${SERVICE}:${IMAGE_TAG}" \
                            "${ECR_REGISTRY}/amma-pickles/${SERVICE}:${IMAGE_TAG}"

                        docker push \
                            "${ECR_REGISTRY}/amma-pickles/${SERVICE}:${IMAGE_TAG}"
                    done
                '''
            }
        }
    }

    post {

        success {
            echo '========================================'
            echo 'AMMA PICKLES CI PIPELINE SUCCESSFUL'
            echo '========================================'
        }

        failure {
            echo '========================================'
            echo 'AMMA PICKLES CI PIPELINE FAILED'
            echo '========================================'
        }

        always {
            echo "Build Number: ${BUILD_NUMBER}"
            echo "Git Commit: ${GIT_COMMIT}"
        }
    }
}
