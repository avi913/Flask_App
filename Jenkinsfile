pipeline {
  agent any

  environment {
    AZURE_CREDENTIALS = credentials('azure-sp')
    ACR_NAME = 'flaskacr5002' 
    AKS_RG = 'project_1'
    AKS_CLUSTER = 'flask-aks'
    IMAGE_NAME = 'flask-app'
    DOCKER_TAG = "latest"
    SONARQUBE_ENV = 'MySonarServer' 
    SONAR_TOKEN = credentials('sonarqube') 
  }

  stages {
  stage('Checkout the code') {
    steps {
      git(branch: 'master', url: 'https://github.com/avi913/Flask_App.git')
    }
  }
}


    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv("${SONARQUBE_ENV}") {
          sh '''
          sonar-scanner \
            -Dsonar.projectKey=Flask_App \
            -Dsonar.sources=. \
            -Dsonar.host.url=$SONAR_HOST_URL \
            -Dsonar.login=$SONAR_TOKEN
          '''
        }
      }
    }

    stage('Login to Azure') {
      steps {
        withCredentials([string(credentialsId: 'azure-sp', variable: 'AZ_CREDS')]) {
          sh '''
          echo $AZ_CREDS > azure.json
          az login --service-principal --username $(jq -r .clientId azure.json) \
                   --password $(jq -r .clientSecret azure.json) \
                   --tenant $(jq -r .tenantId azure.json)
          az account set --subscription $(jq -r .subscriptionId azure.json)
          '''
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        sh '''
        az acr login --name $ACR_NAME
        docker build -t $ACR_NAME.azurecr.io/$IMAGE_NAME:$DOCKER_TAG .
        '''
      }
    }

    stage('Push to ACR') {
      steps {
        sh '''
        docker push $ACR_NAME.azurecr.io/$IMAGE_NAME:$DOCKER_TAG
        '''
      }
    }

    stage('Get AKS Credentials') {
      steps {
        sh '''
        az aks get-credentials --resource-group $AKS_RG --name $AKS_CLUSTER --overwrite-existing
        '''
      }
    }

    stage('Deploy to AKS') {
      steps {
        sh '''
        kubectl apply -f k8s/deployment.yaml
        kubectl apply -f k8s/service.yaml
        '''
      }
    }
  }

  post {
    success {
      echo 'Deployed successfully to AKS!'
    }
    failure {
      echo 'Deployment failed!'
    }
  }
}
