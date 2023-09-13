def branchName      =  "main"
def gitUrl          = "https://github.com/bahamr/simple-java-app-main_01.git"
def gitUrlCode      =  "https://github.com/bahamr/simple-java-app-main_01.git"
def serviceName     =  "app"
def EnvName         = "java-app"
def imageTag        =  "${EnvName}-${BUILD_NUMBER}"
def registryId      =  "727245885999"
def awsRegion       =  "eu-west-1"
def ecrUrl          =  "727245885999.dkr.ecr.eu-west-1.amazonaws.com"
def k8sContext      =  "arn:aws:eks:eu-west-1:727245885999:cluster/ascot-prod"
def namespace       =  "prod"
def dockerfile      = "Dockerfile-${serviceName}"
def applicationName = "java-app"
def envName = "java-app"
def configName = "java-app"
def clientId = "${applicationName}-${envName}"

node () {

 try {
    
  notifyBuild('STARTED')
  stage ('cleanup')
    {
       cleanWs()
    }
  stage ("Get the app code")
    {
        checkout([$class: 'GitSCM', branches: [[name: "${branchName}"]] , extensions: [], userRemoteConfigs: [[ url: "${gitUrlCode}"]]])
       
       

    }
    
  stage("Get the env varaibles from Appconfig")
    {
       sh (" aws appconfig get-configuration --application ${applicationName} --environment ${envName} --configuration ${envName} --region ${awsRegion} --client-id ${clientId} .env")
    }
    
  stage('login to ecr ')
    {  
       sh("aws ecr get-login-password --region ${awsRegion}  | docker login --username AWS --password-stdin ${ecrUrl}")
    }
    
  stage('Build Docker Image')
    {
       sh (" pwd   && docker build -t ${ecrUrl}/${serviceName}:${imageTag} -f ${dockerfile} . ")
    }
   
  stage('Push Docker Image To ECR')
    {
       sh("docker push ${ecrUrl}/${serviceName}:${imageTag}")
    }
    
  stage ("Deploy ${serviceName} to ${branchName} Enviroment")
    {
       sh ("kubectx ${k8sContext}")
       sh ("helm upgrade --wait --install -n ${namespace} casper-fe  ${helmDir} --set image.repository=${ecrUrl}/${serviceName} --set image.tag=${imageTag} --set namespace=${namespace}")
       
      
    }
  stage('Remove local images')
    {
       sh("docker rmi -f ${serviceName}:${imageTag}")
       sh("docker rmi -f ${ecrUrl}/${serviceName}:${imageTag}")
    }
}

 catch (e) {
    // If there was an exception thrown, the build failed
    currentBuild.result = "FAILED"
    throw e
  } finally {
    // Success or failure, always send notifications
    notifyBuild(currentBuild.result)
  }
}

