Build a Kubernete cluster with a service mesh on top of it.
===========================================================

Challenge accepted!

_Disclaimer: I did the exercise on my Mac, so the recipe only is granted on same platform_

1. Building a Kubernetes cluster

OK, for this one, I made the _lazy_ choice of relying on tools that will help me do it quickly. After all, the assignment is for 1 effort day, right?
So choosing `minikube` seems the efficient choice.
But one thing I have in common with my company, is the attraction towards RedHat, so my preference would rather go to OpenShift, hence `minishift`

To be honest, I attempted with both, but I'll come back later on why final choice went to `minishift` 

So let's [install](https://docs.okd.io/latest/minishift/getting-started/installing.html): 

```bash
brew cask install minishift
```

Then, in order to enable cluster admin role (will be useful later)

```bash
minishift addons install --defaults
minishift addons enable admin-user
```

And simply start after:
```bash
minishift start
```


2. Using Helm to install packages

Helm is a good package manager and usually provides efficient ways to install complex sets of resources, and I could see that `istio` recommends to use it.

```bash
brew install kubernetes-helm
```


3. Adding a service mesh

A wide variety of different solutions pop to my mind to do this assignment, the most important ones being `consul` (by HashiCorp) and `istio`.
Given that I've had this pretty sticker of istio on my laptop for a while, I decided to go with `istio` 

So I followed the instructions from istio.io docs, first [plaform setup for openshift](https://istio.io/docs/setup/platform-setup/openshift/), then [installation with helm](https://istio.io/docs/setup/install/helm/#cni).

As commands are pretty numerous, I gathered them in a shell script
```bash
sh openshift-istio.sh
```

Then, use Helm chart to download templates
```bash
sh helm-istio.sh
``` 


4. Deploying a container to the instance

I can use hello-world image as an application example.
Well, hello-world is a one-off container that will simply write to console.
For this, deployment or replication controller is a bit overhead.

Only thing to know is that as pod will end when print is done, it might end up in CrashLoopBackOff state, which is not ideal for the exercise, so let's just say that when done, it should not restart.

```bash
oc run hello --image hello-world --restart=Never
```

And you can verify the results:
```bash
 oc get pods
```
```
NAME      READY     STATUS      RESTARTS   AGE
hello     0/1       Completed   0          11m
```
```bash
oc logs hello
```
```
Hello from Docker!
This message shows that your installation appears to be working correctly.
To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.
To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash
Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/
For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```


