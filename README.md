Istio Extauth example
=====================

This example walks through how to create a sidecar grpc extauth implementation and configure the Istio proxy to route all traffic to it prior to hitting the application.

We will deploy httpbin as the application in the mesh with an additional sidecar to hanlde the external auth traffic.  This example uses extension providers to enable external auth for the application.  Examine the overlay in the extension-provider directory to see how this works.

For further explanation, check out Istio's [guide to enabling external authorization](https://istio.io/latest/docs/tasks/security/authorization/authz-custom/).

## Running the Example

First, deploy the example which will create a single k3d cluster with Istio 1.15 and deploy httpbin into the mesh. We will expose port 8080 for ingress.

```
./setup.sh
```

Then, use curl to attempt to access httpbin

```
$ curl -v localhost:8080/headers
```

The above should result in a 403.

Next, add an Authorization token to access the service.

```
$ curl -v -H "x-ext-authz: allow" localhost:8080/headers
```

The above should succeed.

## Cleanup

To tear down the cluster, just run the cleanup script.

```
./cleanup.sh
```