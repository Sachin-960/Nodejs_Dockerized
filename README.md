# 🚀 Node.js Dockerized App with AWS + GitHub Actions CI/CD

A fully automated deployment pipeline that provisions infrastructure on **AWS**, builds and runs a **Dockerized Node.js app** using **GitHub Actions** — without pushing the image anywhere.

> ✅ Supports Basic Auth  
> ✅ Uses GitHub Secrets for config  
> ✅ Fully automated via Terraform & GitHub Actions  
> ✅ No `.env` file needed  
> ✅ Public repo only (no token required)

---

## 📁 File Structure

```
nodejs-docker-secret/
├── app.js
├── package.json
├── Dockerfile
├── .dockerignore
├── terraform/
│   └── main.tf
└── .github/workflows/deploy.yml
```

---

## 🔧 Features

- `/` → Returns `"Hello, world!"`
- `/secret` → Protected by Basic Auth
- Built-in support for:
  - AWS EC2 provisioning using Terraform
  - GitHub Actions for CI/CD
  - Environment variables injected at runtime
  - Secure secret management using GitHub Secrets

---

## 🧩 Requirements

- ✅ GitHub repository (public)
- ✅ AWS account with IAM access
- ✅ SSH key pair added to AWS
- ✅ Terraform installed locally (for testing)
- ✅ Docker installed locally (for testing)

---

## 🛠️ Steps to Use

### 1. Clone This Repo

```bash
git clone https://github.com/Sachin-960/Nodejs_Dockerized
```

### 2. Create AWS Key Pair

In AWS Console:
- Go to **EC2 > Key Pairs**
- Create or reuse an existing key pair
- Save the private key securely (e.g., `~/.ssh/id_rsa`)

### 3. Set Up GitHub Secrets

Go to:  
**GitHub Repo > Settings > Secrets and variables > Actions**

Add these secrets:

| Secret Name | Description |
|-------------|-------------|
| `AWS_REGION` | e.g., `us-east-1` |
| `AWS_ACCESS_KEY_ID` | Your AWS IAM access key ID |
| `AWS_SECRET_ACCESS_KEY` | Your AWS IAM secret key |
| `AWS_KEY_PAIR_NAME` | The name of the key pair already in AWS |
| `SSH_PRIVATE_KEY` | Content of your local private SSH key (`~/.ssh/id_rsa`) |
| `APP_SECRET_MESSAGE` | Message shown on `/secret` route |
| `APP_USERNAME` | Basic auth username |
| `APP_PASSWORD` | Basic auth password |

> 🔐 Make sure to keep all sensitive values in GitHub Secrets — no `.env` file used.

### 4. Push to GitHub

```bash
git add .
git commit -m "Initial commit"
git push origin main
```

GitHub Actions will:
- Run Terraform
- Provision AWS EC2 instance
- Git clone repo on server
- Build and run Docker container with secrets

---

## 🧪 Test Locally (Optional)

To test the app before deploying:

```bash
npm install
docker build -t nodejs-app .
docker run -d -p 3000:3000 \
  -e SECRET_MESSAGE="This is a secret!" \
  -e USERNAME=admin \
  -e PASSWORD=secret123 \
  --name node-app nodejs-app
```

Then open:
- `http://localhost:3000/`
- `http://localhost:3000/secret` (use credentials from above)

---

## 📦 GitHub Actions Workflow

The workflow does the following:

1. Runs `terraform apply` to create AWS EC2 instance
2. Clones your public GitHub repo directly on the server
3. Builds Docker image remotely
4. Injects environment variables at runtime
5. Starts the app on port `3000`

You can find it in:
`.github/workflows/deploy.yml`

---

## 📌 Accessing the App

After successful deployment:
- Get the IP address from GitHub Actions logs
- Visit: `http://<server-ip>:3000/`
- Try accessing: `http://<server-ip>:3000/secret`

---

## 🧰 Optional: Add HTTPS Support

If you want to enable HTTPS later:
- Use Nginx as reverse proxy
- Use Let's Encrypt with Certbot
- Or use AWS ALB + ACM

Let me know if you'd like help adding this!

---

## 🗑️ Optional: Cleanup After Deploy

Want to destroy the EC2 instance after deploy?  
I can help you add a cleanup step using:

```yaml
- name: Terraform Destroy
  run: |
    cd terraform
    terraform destroy -auto-approve \
      -var "region=${{ secrets.AWS_REGION }}" \
      -var "aws_access_key=${{ secrets.AWS_ACCESS_KEY_ID }}" \
      -var "aws_secret_key=${{ secrets.AWS_SECRET_ACCESS_KEY }}" \
      -var "key_pair_name=${{ secrets.AWS_KEY_PAIR_NAME }}"
```

---

## ✨ Success!

App is now live and secure ✅  
Everything is handled automatically when you push to `main` branch.
