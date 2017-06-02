### Remote Container Repository Access

The supported methods for accessing container images within the MYOB Kubernetes environments are local ECR repository within the kubernetes AWS account, a remote ECR repository in a different AWS account, or use Artifactory hosted repositories.

By default, Kubernetes will be able to access any public container repository, such as DockerHub or Artifactory public repositories.

Additional configuration is required to access remote AWS ECR repositories and private Artifactory repositories.

#### ECR
To configure Kubernetes access to a remote ECR repository, IAM policy is applied to the remote repo to allow cross-account access.

Firstly, authenticate to the remote AWS account, then run the following script to apply the policy.

```
  $ REPOSITORY_NAME=<your-remote-repository-name> ecr-remote-repository-policy
```

Next, update your application config to use your remotely hosted image.
Then you can apply and see wonders unfold.

```
  $ kubectl apply -f ecr-nginx.yml
```

#### Artifactory

To configure Kubernetes access to Artifactory private repository, Kubernetes requires a secret contains dockerconfigjson (Base64 encode string)

Firstly, you should login into your AWS account, that has access to the remote artifactory apikey s3 bucket.
Then run the following script to create your access secret key, providing appropriate values for the variables.
```
  $ USER=<artifactory-user-name> SECRET_KEY_NAME=<your-secret-key-name> artifactory-secret
```

Next, update your application's configuration to use the newly create secret. Set the imagePullSecrets attribute accordingly.
Then apply your new config and behold.

```
  $ kubectl apply -f artifactory-nginx.yml
```
