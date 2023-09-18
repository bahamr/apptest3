def branchName      =  "main"
def gitUrl          = "https://github.com/bahamr/simple-java-app-main_01.git"
def gitUrlCode      =  "https://github.com/bahamr/simple-java-app-main_01.git"
def serviceName     =  "apptest"
def EnvName         = "javaapp"
def imageTag        =  "${EnvName}-${BUILD_NUMBER}"
def registryId      =  "727245885999"
def awsRegion       =  "eu-west-1"
def ecrUrl          =  "727245885999.dkr.ecr.eu-west-1.amazonaws.com/apptest"
def namespace       =  "prod"
def dockerfile      = "Dockerfile-${serviceName}"
def applicationName = "java-app"
def envName = "prod"
def configName = "prod"

node () {

 
 try {
    
  notifyBuild('STARTED')
  stage ('cleanup')
    {
       cleanWs()
    }
  
    
  
    
  stage('login to ecr ')
    {  
       sh("aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 727245885999.dkr.ecr.eu-west-1.amazonaws.com")
    }
    
  stage('Build Docker Image')
    {
     
 
  sh  'docker build /var/lib/jenkins/javaapptest/apptest3 -t apptest2'
  sh  'docker tag apptest:latest 727245885999.dkr.ecr.eu-west-1.amazonaws.com/apptest:latest' 
     
    }
   
  stage('Push Docker Image To ECR')
    {
     sh 'docker push 727245885999.dkr.ecr.eu-west-1.amazonaws.com/apptest:latest'
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

def notifyBuild(String buildStatus = 'STARTED') {
  // build status of null means successful
  buildStatus =  buildStatus ?: 'SUCCESSFUL'
  // Default values
  def colorName = 'RED'
  def colorCode = '#FF0000'
  def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
  def summary = "${subject} (${env.BUILD_URL})"
  // Override default values based on build status
  if (buildStatus == 'STARTED') {
    color = 'YELLOW'
    colorCode = '#FFFF00'
  } else if (buildStatus == 'SUCCESSFUL') {
    color = 'GREEN'
    colorCode = '#00FF00'
  } else {
    color = 'RED'
    colorCode = '#FF0000'
  }
  // Send notifications
    slackSend (color: colorCode, message: summary)
 }
