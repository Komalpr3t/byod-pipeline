pipeline {
    agent any

    environment {
        
        BRANCH_NAME           = "${env.BRANCH_NAME ?: 'dev'}"

        TF_IN_AUTOMATION      = 'true'
        TF_CLI_ARGS           = '-no-color'
        
        
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        SSH_CRED_ID           = 'my-ssh-key-id' 
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Initialize & Inspect') {
            steps {
                script {
                    // Initialize Terraform (Using bat for Windows)
                    bat 'terraform init'
                    
                    echo "--- Environment: ${BRANCH_NAME} ---"
                    
                    // Windows logic to check if file exists and print it
                    bat """
                       if exist "${BRANCH_NAME}.tfvars" (
                           echo Using variable file: ${BRANCH_NAME}.tfvars
                           type ${BRANCH_NAME}.tfvars
                       ) else (
                           echo Error: ${BRANCH_NAME}.tfvars not found!
                           exit 1
                       )
                    """
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    echo "Generating Plan for ${BRANCH_NAME}..."
                    // using 'bat' for Windows
                    bat "terraform plan -var-file=${BRANCH_NAME}.tfvars -out=tfplan"
                }
            }
        }

        stage('Validate Apply') {
            /
            when {
                expression { return env.BRANCH_NAME == 'dev' }
            }
            steps {
                input message: "Approve deployment to ${BRANCH_NAME}?", ok: "Yes, Apply"
                echo "Approval Granted. Proceeding to Apply..."
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    echo "Applying changes to ${BRANCH_NAME}..."
                    // using 'bat' for Windows
                    bat "terraform apply -auto-approve tfplan"
                }
            }
        }
    }
}