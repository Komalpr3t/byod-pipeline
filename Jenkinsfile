pipeline {
    agent any

    environment {
        // --- Task 2: Pipeline Environment & Credentials ---
        TF_IN_AUTOMATION      = 'true'
        TF_CLI_ARGS           = '-no-color'
        
        // Injecting AWS Credentials securely
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        
        // Injecting SSH Key ID
        SSH_CRED_ID           = 'my-ssh-key-id' 
    }

    stages {
        stage('Checkout') {
            steps {
                // Pulls code from your GitHub repo
                checkout scm
            }
        }

        stage('Initialize & Inspect') {
            // --- Task 3: Initialization & Variable Inspection ---
            steps {
                script {
                    // Initialize Terraform
                    sh 'terraform init'

                    // Display the variable file content
                    echo "--- Checking variables for branch: ${env.BRANCH_NAME} ---"
                    sh """
                       if [ -f "${env.BRANCH_NAME}.tfvars" ]; then
                           cat ${env.BRANCH_NAME}.tfvars
                       else
                           echo "Error: ${env.BRANCH_NAME}.tfvars not found!"
                           exit 1
                       fi
                    """
                }
            }
        }

        stage('Terraform Plan') {
            // --- Task 4: Branch-Specific Planning ---
            steps {
                script {
                    echo "Planning for ${env.BRANCH_NAME}..."
                    // Run plan using the branch-specific variable file
                    sh "terraform plan -var-file=${env.BRANCH_NAME}.tfvars"
                }
            }
        }

        stage('Validate Apply') {
            // --- Task 5: Conditional Manual Approval ---
            when {
                branch 'dev'  // Only runs if the branch is 'dev'
            }
            steps {
                input message: "Approve deployment to ${env.BRANCH_NAME}?", ok: "Yes, Proceed"
                echo "Approval Granted!"
            }
        }
    }
}