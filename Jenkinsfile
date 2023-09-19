def branchName      =  "main"
def gitUrl          = "https://github.com/bahamr/simple-java-app-main_01.git"
def gitUrlCode      =  "https://github.com/bahamr/simple-java-app-main_01.git"
def serviceName     =  "apptest"
def EnvName         = "javaapp"
def imageTag        =  "${EnvName}-${BUILD_NUMBER}"
def registryId      =  "727245885999"
def awsRegion       =  "eu-west-1"
def ecrUrl          =  "727245885999.dkr.ecr.eu-west-1.amazonaws.com/apptest"
def k8sContext      =  "arn:aws:eks:eu-west-1:727245885999:cluster/eks-app-test"
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
      sh 'export AWS_ACCESS_KEY_ID="ASIA2SUZ3SIXYDD4F3CB"
export AWS_SECRET_ACCESS_KEY="xk6MhnpLeeE1y1XDgCXWBmxHtdfyeb77ykNJCCDt"
export AWS_SESSION_TOKEN="IQoJb3JpZ2luX2VjEBsaCWV1LXdlc3QtMSJGMEQCIEeL++a4ViOylZctn+o6/tnZQQ3+7ffZLKV2wyYMWJO+AiA8r9ibcfVyQS7vNib23dbwzeZFDmoZLImKJQb1nSxWDiqLAwj0//////////8BEAQaDDcyNzI0NTg4NTk5OSIM4ynn+zYMl7LcgAPSKt8CEfaNCIXUKxBPoDrWUQDaMIxL6hfdlIBToqbsMOPNuoqoANtfHn8+RnbSrtZKYSH1kDUJrze6cu3J+cX3D/Nddc+KNkBSbOP2AAnCqIZHOS7a5jOAkEkodScyB87Mp0eq2Z72Xut0aCN4jiPCaGjD2q5PuCd9iKHHiUcesVmvpxO7cBhuJ4L9LX7sF9sE77NpjHzCV3+Cpf5cKwMS7qRTtCqyBJnzrQsmvIyKkCNArpU2iTEJaPHelXDKRTY4PgXcdhBxiwaclTnjw0FRvPrVQCEfp7p/bfKg1v7wxvmb6XQcR7OOeoVTEMi6NgSB12mqnKZzgt40Zs0uLVW1Kp+PDPjP2+PBxVKPgN1V2AzcX18tVoEZlY/jnSjZxyveynNyGza72uPyv6E4YJ0nQYd0ouGrPG0cdddKh3Pxu/hdCjivor0aS1OUnP5r1TZbn4akwopp9013r4P/xJvJJu84MJW+/acGOqcBc7La4avr1Oxot077bDArAC5CHfjKgWAeNnwpPTWcVOZyAJiBeEMjAZvnyRRZWIdcFrSJ5gakd8MGH5XA7GAyNTvE8z56O8TPW3Tc/m+YnzlLokqbRu9DtZ5G+vFjBKwacNu0pPYBalKzx3tDSP9Ub36UqZgcBWBYoIasmMU207+Os7fqy1dCh0vSvls/dkRL9T+LIFKLNUhPu+yBp33Ob7Rmtz4m1S4="'
     withAWS(credentials: 'AWS-EKS', region: 'eu-west-1') {
       sh 'aws eks update-kubeconfig --region eu-west-1 --name eks-app-test'
       sh 'kubectl apply -f ./k8s/deployment.yaml'
        
}
        
      // sh ("kubectx ${k8sContext}")
       //sh ("helm upgrade --wait --install -n ${namespace} java-app  ${helmDir} --set image.repository=${ecrUrl}/${serviceName} --set image.tag=${imageTag} --set namespace=${namespace}")
       
      
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
