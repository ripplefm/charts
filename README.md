# ripple.fm helm charts

This repo contains the helm charts and helmfile used to deploy ripple.fm and other required services on a kubernetes cluster.

The master branch reflects the current state of the cluster running ripple.fm in production

## Table of Contents

* [Prerequisites](#prerequisites)
* [Technologies](#technologies)
* [Development](#development)
  * [Initializing helm on the cluster](#initializing-helm-on-the-cluster)
  * [Setting up helm secrets](#setting-up-helm-secrets)
  * [Setting chart values](#setting-chart-values)
  * [Changing secret values](#changing-secret-values)
* [Deployment](#deployment)
  * [Travis CI](#travis-ci)
  * [Manual](#manual)

# Prerequisites

- kubernetes cluster ([minikube](https://kubernetes.io/docs/setup/minikube/) works)
- [helm](https://helm.sh/) installed locally with the [helm-diff](https://github.com/databus23/helm-diff) and [helm secrets](https://github.com/futuresimple/helm-secrets) plugins
- [helmfile](https://github.com/roboll/helmfile)

# Technologies

- [helm](https://helm.sh/)
- [helm secrets](https://github.com/futuresimple/helm-secrets) to encrypt and decrypt helm values. Allows us to keep encrypted secrets and keys in version control
- [helmfile](https://github.com/roboll/helmfile) to easily configure and manage multiple helm charts
- [traefik](https://traefik.io/) as an ingress controller for ripple.fm services

# Development

## Initializing helm on the cluster

If you have helm properly installed on your cluster you can skip this step.

We must first initialize helm to work with our cluster. We defined RBAC resources for tiller [here](tiller-rbac.yaml) which we apply to our cluster using the following command:

```sh
$ kubectl create -f tiller-rbac.yaml
```

Now that the cluster knows about the roles we can tell helm to install tiller with the correct service account:

```sh
$ helm init --service-account tiller
```

## Setting up helm secrets

Helm secrets uses PGP keys to encrypt sensitive values in our yaml files. We can import a PGP key using the following command:

```sh
$ gpg --import key.asc
```

## Setting chart values

The majority of the coniguration for ripple.fm services is located [here](values/ripple.yaml.gotmpl). The default values should work fine but you'll probably want to change `url.protocol` and `url.baseDomain`.

### Secrets

Sensitive values are stored in the encrypted file [values/secrets.yaml](values/secrets.yaml). We can create our own secret values by renaming the `values/secrets.example.yaml` file to `values/secrets.yaml` and providing our values. After we provide our secrets we must encrypt the `values/secrets.yaml` file so that changes can be tracked in version control:

```sh
$ helm secrets enc values/secrets.yaml
```

### SSL Keys

The configuration for ripple.fm also requires a public and private RSA key pair, an example is provided [here](values/ssl.example.yaml).

We'll rename this file to `values/ssl.yaml` and change the values for the keys ([generate](https://en.wikibooks.org/wiki/Cryptography/Generate_a_keypair_using_OpenSSL#Generate_an_RSA_keypair_with_a_2048_bit_private_key) and paste (or paste existing) the RSA keys into `values/ssl.yaml`). After changing the values we must encrypt the file so that it can be tracked in version control:

```sh
$ helm secrets enc values/ssl.yaml
```

### Station Templates

We then 

ripple.fm also allows for providing templates for stations to be seeded and started with autoplayers. The [station_templates.example.yaml](values/station_templates.example.yaml) provides a basic example file which we must rename to `values/station_templates.yaml`. After renaming (and optionally editting) the file we must encrypt it:

```sh
$ helm secrets enc values/station_templates.yaml
```

The example templates file provides a few stations that can be seeded but you may edit it to add more custom stations.

## Changing secret values

Secrets are stored as encrypted files in version control ([example](values/secrets.yaml)). If you need to update or add values to the secret files follow these steps:

1. Ensure you have the correct PGP keys configured
1. Decrypt the secret file you wish to work with:
    ```sh
    $ helm secrets dec values/$MY_FILE.yaml
    ```
1. The file will be decrypted and available as `values/$MY_FILE.yaml.dec`. Edit the `.yaml.dec` file and make the required changes
1. Encrypt the updated file:
    ```sh
    $ helm secrets enc values/$MY_FILE.yaml
    ```
1. Commit the newly encrypted file to version control

# Deployment

## Travis CI

The state declared in the master branch of this repository reflects the state on the production Kubernetes cluster. Whenever a pull request is made travis-ci will run a build which will log the output of `helmfile diff` and show the comparison of the declared state and the production state.

Once a pull request is merged into the `master` branch, travis-ci will run a build which executes `helmfile apply` and updates the desired cluster state.

## Manual

Although it is not recommended, we can manually view or change the state of the cluster:

1. Ensure your kubeconfig is pointed to the desired cluster and you can succesfully run `kubectl get nodes`
1. Compare declared state with existing cluster state:
    ```sh
    $ helmfile diff
    ```
1. Apply changes from above step to cluster state:
    ```sh
    $ helmfile apply
    ```

More information on manual deployment available [here.](https://github.com/roboll/helmfile)