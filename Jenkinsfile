pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-northeast-1'
        AWS_ACCOUNT_ID = '206632868064'
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

        NEXUS_SETTINGS_ID = 'amma-pickles-maven-settings'

        SERVICES = 'auth-service user-service address-service category-service product-service cart-service order-service notification-service'
    }

    tools {
        jdk 'Java17'
        maven 'Maven3'
    }

    stages {

        /*
         * ============================================================
         * CHECKOUT
         * ============================================================
         */
        stage('Checkout') {
            steps {
                echo 'Checking out Amma Pickles source code...'

                checkout scm
            }
        }


        /*
         * ============================================================
         * BUILD & TEST
         * ============================================================
         */
        stage('Build & Test') {
            steps {
                sh '''
                    set -e

                    for SERVICE in $SERVICES
                    do
                        echo "========================================"
                        echo "Building $SERVICE"
                        echo "========================================"

                        cd "$SERVICE"

                        chmod +x ../mvnw

                        ../mvnw clean verify

                        cd ..
                    done
                '''
            }
        }


        /*
         * ============================================================
         * PUBLISH MAVEN ARTIFACTS TO NEXUS
         * ============================================================
         */
        stage('Publish Maven Artifacts to Nexus') {
            steps {

                /*
                 * Jenkins credential:
                 *
                 * ID:
                 * Jenkins-nexus
                 *
                 * Username:
                 * NEXUS_USERNAME
                 *
                 * Password:
                 * NEXUS_PASSWORD
                 */
                withCredentials([
                    usernamePassword(
                        credentialsId: 'Jenkins-nexus',
                        usernameVariable: 'NEXUS_USERNAME',
                        passwordVariable: 'NEXUS_PASSWORD'
                    )
                ]) {

                    /*
                     * Load the managed Maven settings.xml
                     */
                    configFileProvider([
                        configFile(
                            fileId: "${NEXUS_SETTINGS_ID}",
                            variable: 'MAVEN_SETTINGS'
                        )
                    ]) {

                        sh '''
                            set -e

                            echo "========================================"
                            echo "Checking Nexus credential injection"
                            echo "========================================"

                            if [ -n "$NEXUS_USERNAME" ]; then
                                echo "NEXUS_USERNAME: SET"
                            else
                                echo "NEXUS_USERNAME: NOT SET"
                                exit 1
                            fi

                            if [ -n "$NEXUS_PASSWORD" ]; then
                                echo "NEXUS_PASSWORD: SET"
                            else
                                echo "NEXUS_PASSWORD: NOT SET"
                                exit 1
                            fi

                            echo "Maven settings file:"
                            echo "$MAVEN_SETTINGS"

                            test -f "$MAVEN_SETTINGS"

                            echo "Maven settings file exists: YES"

                            echo "========================================"
                            echo "Publishing Maven artifacts to Nexus"
                            echo "========================================"

                            for SERVICE in $SERVICES
                            do
                                echo "========================================"
                                echo "Publishing $SERVICE to Nexus"
                                echo "========================================"

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


        /*
         * ============================================================
         * BUILD DOCKER IMAGES
         * ============================================================
         */
        stage('Build Docker Images') {
            steps {
                sh '''
                    set -e

                    SHORT_COMMIT=$(printf "%.7s" "$GIT_COMMIT")
                    IMAGE_TAG="${BUILD_NUMBER}-${SHORT_COMMIT}"

                    echo "========================================"
                    echo "Docker image tag: $IMAGE_TAG"
                    echo "========================================"

                    for SERVICE in $SERVICES
                    do
                        echo "========================================"
                        echo "Building Docker image for $SERVICE"
                        echo "========================================"

                        docker build \
                            -t "${SERVICE}:${IMAGE_TAG}" \
                            "./${SERVICE}"
                    done
                '''
            }
        }


        /*
         * ============================================================
         * LOGIN TO AMAZON ECR
         * ============================================================
         */
        stage('Login to Amazon ECR') {
            steps {
                sh '''
                    set -e

                    echo "========================================"
                    echo "Logging in to Amazon ECR"
                    echo "========================================"

                    aws ecr get-login-password \
                        --region "$AWS_REGION" \
                    | docker login \
                        --username AWS \
                        --password-stdin "$ECR_REGISTRY"
                '''
            }
        }


        /*
         * ============================================================
         * PUSH DOCKER IMAGES TO ECR
         * ============================================================
         */
        stage('Push Images to ECR') {
            steps {
                sh '''
                    set -e

                    SHORT_COMMIT=$(printf "%.7s" "$GIT_COMMIT")
                    IMAGE_TAG="${BUILD_NUMBER}-${SHORT_COMMIT}"

                    echo "========================================"
                    echo "Pushing Docker images to ECR"
                    echo "========================================"

                    for SERVICE in $SERVICES
                    do
                        echo "========================================"
                        echo "Pushing $SERVICE:$IMAGE_TAG"
                        echo "========================================"

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


    /*
     * ================================================================
     * POST ACTIONS
     * ================================================================
     */
    post {

        success {
            echo '''
========================================
AMMA PICKLES CI PIPELINE SUCCESSFUL
========================================
'''
        }

        failure {
            echo '''
========================================
AMMA PICKLES CI PIPELINE FAILED
========================================
'''
        }

        always {
            echo "Build Number: ${BUILD_NUMBER}"
            echo "Git Commit: ${GIT_COMMIT}"
        }
    }
}

