Here's how to create a **Project** in Jenkins and configure it to use a `Jenkinsfile` from your repository:


#### 1. **Create a Project**
   - Go to Jenkins Dashboard → **New Item** → Enter project name (e.g., `my-app-pipeline`) → Select **Freestyle project** → Click **OK**.

  
---

#### 2. **Configure Source Code Management (SCM)**
   - Under the **Source Code Management** section:
     - Select **Git**.
     - Add your repository URL (e.g., `https://github.com/your-username/devops-test-task.git`).
     - Specify the branch (e.g., `main` or `master`).

  ---

#### 3. **Add a Build Step to Run the Jenkinsfile**
   Since Freestyle projects don’t natively support Jenkinsfiles, use a workaround:

   - Under the **Build** section:
     - Click **Add build step** → **Execute shell** (Linux) or **Execute Windows batch command** (Windows).
     - Run the `jenkins/Jenkinsfile` using the `pipeline` command:

       ```bash
       # Execute the Jenkinsfile from the repository
       pipeline {
           agent any
           stages {
               stage('Build') {
                   steps {
                       echo 'Building...'
                       sh 'docker build -t my-app .'
                   }
               }
               stage('Test') {
                   steps {
                       echo 'Testing...'
                       sh 'curl -s http://localhost:5000/health | grep "200"'
                   }
               }
           }
       }
       ```

---

#### 4. **Save and Run the Pipeline**
   - Click **Save** → **Build Now** to trigger the pipeline.

---

### Why This Works
- **Freestyle Project Limitations**: Freestyle projects don’t directly support Jenkinsfiles (they’re designed for Pipelines). However, you can manually invoke the pipeline script inside a shell step.
- **Better Alternative**: Use a **Pipeline Project** instead (recommended). For Pipelines:
  1. Create a **Pipeline Project**.
  2. Under **Pipeline → Definition**, select **Pipeline script from SCM**.
  3. Specify the path to your `Jenkinsfile` (e.g., `jenkins/Jenkinsfile`).

---

### Example Jenkinsfile
```groovy
// jenkins/Jenkinsfile
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                script {
                    docker.build("my-app:${env.BUILD_ID}")
                }
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker compose up -d app'
            }
        }

        stage('Test') {
            steps {
                script {
                    sleep(10) // Wait for app to start
                    def status = sh(script: "curl -s -o /dev/null -w '%{http_code}' http://localhost:5000/health", returnStdout: true).trim()
                    if (status != "200") {
                        error "Test failed: HTTP ${status}"
                    }
                }
            }
        }
    }
}
```
