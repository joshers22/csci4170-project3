pipeline {
  agent {
    kubernetes {
      yamlFile 'agent-pod.yaml'
      defaultContainer 'gcloud'
    }
  }
  options {
    disableConcurrentBuilds()
  }
  stages {
    stage('Build image') {
      steps {
        script {
          def project = sh(returnStdout: true, script: 'gcloud config get-value project').trim()
          env.IMAGE = "us-east4-docker.pkg.dev/${project}/demo-repo/nyan:${env.GIT_COMMIT}-${env.BUILD_NUMBER}"
        }
        sh 'gcloud builds submit --tag "$IMAGE" .'
      }
    }
    stage('Deploy') {
      steps {
        script {
          container('jnlp') {
            env.COMMIT_MSG = sh(returnStdout: true, script: 'git log -1 --pretty=%B').trim()
          }
          env.TARGET = env.COMMIT_MSG.contains('[canary]') ? 'nyan-canary' : 'nyan'
        }
        container('kubectl') {
          sh 'kubectl set image deployment/"$TARGET" nyan="$IMAGE"'
          sh 'kubectl rollout status deployment/"$TARGET" --timeout=180s'
        }
      }
    }
  }
}
