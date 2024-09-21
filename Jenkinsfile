pipeline {
    agent any

    stages{
        stage("code"){
            steps {
                echo "building the code"
                git url:"https://github.com/orjoonadhikari/django-notes-app.git", branch: "main"
            }
        }
        stage("image build"){
            steps {
                echo "Building the code"
                sh 'docker build -t django-note-app .'
            }
        }
        stage("push to dockerhub"){
            steps {
                echo "Pushing to docker hub"
                withCredentials([usernamePassword(credentialsId:"dockerhub",passwordVariable:"dockerHubpass",usernameVariable:"dockerHubUser")]){
                sh "docker login -u ${dockerHubUser} -p ${dockerHubpass}"
                sh 'docker tag django-note-app ${dockerHubUser}/django-note-app:${BUILD_ID}'
                sh 'docker push ${dockerHubUser}/django-note-app:${BUILD_ID}'
                }
            }
        }
        stage("deploy"){
            environment {
                GIT_REPO_NAME = "django-notes-app"
                GIT_USER_NAME = "orjoonadhikari"
            }
            steps {
                withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]){
                echo "deploying the app in docker"
                sh '''
                    git config user.email "orjoonadhikari19@gmail.com"
                    git config user.name "Arjun Adhikari"
                    BUILD_NUMBER=${BUILD_NUMBER}
                    sed -i "s/:[0-9]\+/:${BUILD_NUMBER}/g" docker-compose.yml
                    git add docker-compose.yml
                    git commit -m "Update  image to version ${BUILD_NUMBER}"
                    git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
                    docker-compose down && docker-compose up -d  
                '''
                }
            }
        }
    }
}
