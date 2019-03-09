# ripple.fm helm charts

This repo contains the helm charts and helmfile used to deploy ripple.fm and other required services on a kubernetes cluster.

The master branch reflects the current state of the cluster running ripple.fm in production

## Table of Contents

* [Prerequisites](#prerequisites)
* [Technologies](#technologies)
* [Getting Started](#getting-started)
  * [Initializing helm on the cluster](#initializing-helm-on-the-cluster)
  * [Setting up environment variables](#setting-up-environment-variables)
  * [Setting chart values](#setting-chart-values)
* [Deployment](#deployment)
  * [Checking diff](#checking-diff)
  * [Applying](#applying)

# Prerequisites

- kubernetes cluster ([minikube](https://kubernetes.io/docs/setup/minikube/) works)
- [helm](https://helm.sh/) installed locally with the [helm-diff](https://github.com/databus23/helm-diff) plugin
- [helmfile](https://github.com/roboll/helmfile)

# Technologies

- [helm](https://helm.sh/)
- [helmfile](https://github.com/roboll/helmfile) to easily configure and manage multiple helm charts
- [traefik](https://traefik.io/) as an ingress controller for ripple.fm services

# Getting Started

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

## Setting up environment variables

Currently chart secrets are defined in your `.env` file. To get started we can copy [.env.example](.env.example) to `.env`:

```sh
$ cp .env.example .env
```

After setting the values for each variable defined in `.env` we load the variables:

```sh
$ source .env
```

## Setting chart values

The majority of the coniguration for ripple.fm services is located [here](values/ripple.yaml.gotmpl). The default values should work fine but you'll probably want to change `url.protocol` and `url.baseDomain`.

The configuration for ripple.fm also requires a public and private RSA key pair, an example is provided [here](values/ssl.example.yaml). We'll copy this example file to the `value/secret` folder where it will be read with production value keys:

```sh
$ cp values/ssl.example.yaml values/secret/ssl.yaml
```

We then [generate](https://en.wikibooks.org/wiki/Cryptography/Generate_a_keypair_using_OpenSSL#Generate_an_RSA_keypair_with_a_2048_bit_private_key) and paste (or paste existing) RSA keys into `values/secret/ssl.yaml`

ripple.fm also allows for providing templates for stations to be seeded and started with autoplayers. The [station_templates.example.yaml](values/station_templates.example.yaml) provides a basic example file which we must copy to the `values/secret` folder:

```sh
$ cp values/station_templates.example.yaml values/secret/station_templates.yaml
```

The example templates file provides a few stations that can be seeded but you may edit it to add more custom stations.

# Deployment

## Checking diff

Once we are finished with changes for our releases we can compare the newly declared state with the state currently running on the cluster using:

```sh
$ helmfile diff
```

This will output the changes required to achieve the newly declared state. More information is available [here](https://github.com/roboll/helmfile#diff).

## Applying

If we are satisfied with the changes after running `helmfile diff` we can apply the new state:

```sh
$ helmfile apply
```

This will sync the local state with the state running in the cluster. More information is available [here](https://github.com/roboll/helmfile#apply).


