# Certified Kubernetes Administrator (CKA)

# kubectl Command Line v1.11.0

## version

```json
{   
    Major: "1",
    Minor: "11",
    GitVersion: "v1.11.0",
    GitCommit: "91e7b4fd31fcd3d5f436da26c980becec37ceefe",
    GitTreeState: "clean",
    BuildDate: "2018-06-27T20:17:28Z",
    GoVersion: "go1.10.2",
    Compiler: "gc",
    Platform: "linux/amd64"
}
```

## overview of all commands

```bash
[vagrant@node1 ~]$ kubectl
kubectl controls the Kubernetes cluster manager. 

Find more information at: https://kubernetes.io/docs/reference/kubectl/overview/

Basic Commands (Beginner):
  create         Create a resource from a file or from stdin.
  expose         Take a replication controller, service, deployment or pod and expose it as a new Kubernetes Service
  run            Run a particular image on the cluster
  set            Set specific features on objects

Basic Commands (Intermediate):
  explain        Documentation of resources
  get            Display one or many resources
  edit           Edit a resource on the server
  delete         Delete resources by filenames, stdin, resources and names, or by resources and label selector

Deploy Commands:
  rollout        Manage the rollout of a resource
  scale          Set a new size for a Deployment, ReplicaSet, Replication Controller, or Job
  autoscale      Auto-scale a Deployment, ReplicaSet, or ReplicationController

Cluster Management Commands:
  certificate    Modify certificate resources.
  cluster-info   Display cluster info
  top            Display Resource (CPU/Memory/Storage) usage.
  cordon         Mark node as unschedulable
  uncordon       Mark node as schedulable
  drain          Drain node in preparation for maintenance
  taint          Update the taints on one or more nodes

Troubleshooting and Debugging Commands:
  describe       Show details of a specific resource or group of resources
  logs           Print the logs for a container in a pod
  attach         Attach to a running container
  exec           Execute a command in a container
  port-forward   Forward one or more local ports to a pod
  proxy          Run a proxy to the Kubernetes API server
  cp             Copy files and directories to and from containers.
  auth           Inspect authorization

Advanced Commands:
  apply          Apply a configuration to a resource by filename or stdin
  patch          Update field(s) of a resource using strategic merge patch
  replace        Replace a resource by filename or stdin
  wait           Experimental: Wait for one condition on one or many resources
  convert        Convert config files between different API versions

Settings Commands:
  label          Update the labels on a resource
  annotate       Update the annotations on a resource
  completion     Output shell completion code for the specified shell (bash or zsh)

Other Commands:
  alpha          Commands for features in alpha
  api-resources  Print the supported API resources on the server
  api-versions   Print the supported API versions on the server, in the form of "group/version"
  config         Modify kubeconfig files
  plugin         Runs a command-line plugin
  version        Print the client and server version information

Usage:
  kubectl [flags] [options]

Use "kubectl <command> --help" for more information about a given command.
Use "kubectl options" for a list of global command-line options (applies to all commands).
```

```bash
[vagrant@node1 ~]$ kubectl <TAB>
alpha          apply          certificate    convert        delete         exec           label          plugin         rollout        taint          wait
annotate       attach         cluster-info   cordon         describe       explain        logs           port-forward   run            top
api-resources  auth           completion     cp             drain          expose         options        proxy          scale          uncordon
api-versions   autoscale      config         create         edit           get            patch          replace        set            version
```

## options

```bash
[vagrant@node1 ~]$ kubectl options 
The following options can be passed to any command:

      --alsologtostderr=false: log to standard error as well as files
      --as='': Username to impersonate for the operation
      --as-group=[]: Group to impersonate for the operation, this flag can be repeated to specify multiple groups.
      --cache-dir='/home/vagrant/.kube/http-cache': Default HTTP cache directory
      --certificate-authority='': Path to a cert file for the certificate authority
      --client-certificate='': Path to a client certificate file for TLS
      --client-key='': Path to a client key file for TLS
      --cluster='': The name of the kubeconfig cluster to use
      --context='': The name of the kubeconfig context to use
      --insecure-skip-tls-verify=false: If true, the server's certificate will not be checked for validity. This will
make your HTTPS connections insecure
      --kubeconfig='': Path to the kubeconfig file to use for CLI requests.
      --log-backtrace-at=:0: when logging hits line file:N, emit a stack trace
      --log-dir='': If non-empty, write log files in this directory
      --log-flush-frequency=5s: Maximum number of seconds between log flushes
      --logtostderr=true: log to standard error instead of files
      --match-server-version=false: Require server version to match client version
  -n, --namespace='': If present, the namespace scope for this CLI request
      --request-timeout='0': The length of time to wait before giving up on a single server request. Non-zero values
should contain a corresponding time unit (e.g. 1s, 2m, 3h). A value of zero means don't timeout requests.
  -s, --server='': The address and port of the Kubernetes API server
      --stderrthreshold=2: logs at or above this threshold go to stderr
      --token='': Bearer token for authentication to the API server
      --user='': The name of the kubeconfig user to use
  -v, --v=0: log level for V logs
      --vmodule=: comma-separated list of pattern=N settings for file-filtered logging
```

## alpha

```bash
[vagrant@node1 ~]$ kubectl alpha -h
These commands correspond to alpha features that are not enabled in Kubernetes clusters by default.

Available Commands:
  diff        Diff different versions of configurations
```

## annotate

```bash
[vagrant@node1 ~]$ kubectl annotate -h
Update the annotations on one or more resources 

All Kubernetes objects support the ability to store additional data with the object as annotations. Annotations are
key/value pairs that can be larger than labels and include arbitrary string values such as structured JSON. Tools and
system extensions may use annotations to store their own data. 

Attempting to set an annotation that already exists will fail unless --overwrite is set. If --resource-version is
specified and does not match the current resource version on the server the command will fail.

Use "kubectl api-resources" for a complete list of supported resources.

Examples:
  # Update pod 'foo' with the annotation 'description' and the value 'my frontend'.
  # If the same annotation is set multiple times, only the last value will be applied
  kubectl annotate pods foo description='my frontend'
  
  # Update a pod identified by type and name in "pod.json"
  kubectl annotate -f pod.json description='my frontend'
  
  # Update pod 'foo' with the annotation 'description' and the value 'my frontend running nginx', overwriting any
existing value.
  kubectl annotate --overwrite pods foo description='my frontend running nginx'
  
  # Update all pods in the namespace
  kubectl annotate pods --all description='my frontend running nginx'
  
  # Update pod 'foo' only if the resource is unchanged from version 1.
  kubectl annotate pods foo description='my frontend running nginx' --resource-version=1
  
  # Update pod 'foo' by removing an annotation named 'description' if it exists.
  # Does not require the --overwrite flag.
  kubectl annotate pods foo description-

Options:
      --all=false: Select all resources, including uninitialized ones, in the namespace of the specified resource types.
      --dry-run=false: If true, only print the object that would be sent, without sending it.
      --field-selector='': Selector (field query) to filter on, supports '=', '==', and '!='.(e.g. --field-selector
key1=value1,key2=value2). The server only supports a limited number of field queries per type.
  -f, --filename=[]: Filename, directory, or URL to files identifying the resource to update the annotation
      --include-uninitialized=false: If true, the kubectl command applies to uninitialized objects. If explicitly set to
false, this flag overrides other flags that make the kubectl commands apply to uninitialized objects, e.g., "--all".
Objects with empty metadata.initializers are regarded as initialized.
      --local=false: If true, annotation will NOT contact api-server but run locally.
  -o, --output='': Output format. One of:
json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...
See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template
[http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template
[http://kubernetes.io/docs/user-guide/jsonpath].
      --overwrite=false: If true, allow annotations to be overwritten, otherwise reject annotation updates that
overwrite existing annotations.
      --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the
command. If set to true, record the command. If not set, default to updating the existing annotation value only if one
already exists.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
related manifests organized within the same directory.
      --resource-version='': If non-empty, the annotation update will only succeed if this is the current
resource-version for the object. Only valid when specifying a single resource.
  -l, --selector='': Selector (label query) to filter on, not including uninitialized ones, supports '=', '==', and
'!='.(e.g. -l key1=value1,key2=value2).

Usage:
  kubectl annotate [--overwrite] (-f FILENAME | TYPE NAME) KEY_1=VAL_1 ... KEY_N=VAL_N [--resource-version=version]
[options]
```

## api-resources

```bash
[vagrant@node1 ~]$ kubectl api-resources -h
Print the supported API resources on the server

Examples:
  # Print the supported API Resources
  kubectl api-resources
  
  # Print the supported API Resources with more information
  kubectl api-resources -o wide
  
  # Print the supported namespaced resources
  kubectl api-resources --namespaced=true
  
  # Print the supported non-namespaced resources
  kubectl api-resources --namespaced=false
  
  # Print the supported API Resources with specific APIGroup
  kubectl api-resources --api-group=extensions

Options:
      --api-group='': Limit to resources in the specified API group.
      --cached=false: Use the cached list of resources if available.
      --namespaced=true: If false, non-namespaced resources will be returned, otherwise returning namespaced resources
by default.
      --no-headers=false: When using the default or custom-column output format, don't print headers (default print
headers).
  -o, --output='': Output format. One of: wide|name.
      --verbs=[]: Limit to resources that support the specified verbs.

Usage:
  kubectl api-resources [flags] [options]
```

## api-versions

```bash
[vagrant@node1 ~]$ kubectl api-versions -h
Print the supported API versions on the server, in the form of "group/version"

Examples:
  # Print the supported API versions
  kubectl api-versions

Usage:
  kubectl api-versions [flags] [options]
```

## apply

```bash
[vagrant@node1 ~]$ kubectl apply -h
Apply a configuration to a resource by filename or stdin. The resource name must be specified. This resource will be
created if it doesn't exist yet. To use 'apply', always create the resource initially with either 'apply' or 'create
--save-config'. 

JSON and YAML formats are accepted. 

Alpha Disclaimer: the --prune functionality is not yet complete. Do not use unless you are aware of what the current
state is. See https://issues.k8s.io/34274.

Examples:
  # Apply the configuration in pod.json to a pod.
  kubectl apply -f ./pod.json
  
  # Apply the JSON passed into stdin to a pod.
  cat pod.json | kubectl apply -f -
  
  # Note: --prune is still in Alpha
  # Apply the configuration in manifest.yaml that matches label app=nginx and delete all the other resources that are
not in the file and match label app=nginx.
  kubectl apply --prune -f manifest.yaml -l app=nginx
  
  # Apply the configuration in manifest.yaml and delete all the other configmaps that are not in the file.
  kubectl apply --prune -f manifest.yaml --all --prune-whitelist=core/v1/ConfigMap

Available Commands:
  edit-last-applied Edit latest last-applied-configuration annotations of a resource/object
  set-last-applied  Set the last-applied-configuration annotation on a live object to match the contents of a file.
  view-last-applied View latest last-applied-configuration annotations of a resource/object

Options:
      --all=false: Select all resources in the namespace of the specified resource types.
      --cascade=true: If true, cascade the deletion of the resources managed by this resource (e.g. Pods created by a
ReplicationController).  Default true.
      --dry-run=false: If true, only print the object that would be sent, without sending it.
  -f, --filename=[]: that contains the configuration to apply
      --force=false: Only used when grace-period=0. If true, immediately remove resources from API and bypass graceful
deletion. Note that immediate deletion of some resources may result in inconsistency or data loss and requires
confirmation.
      --grace-period=-1: Period of time in seconds given to the resource to terminate gracefully. Ignored if negative.
Set to 1 for immediate shutdown. Can only be set to 0 when --force is true (force deletion).
      --include-uninitialized=false: If true, the kubectl command applies to uninitialized objects. If explicitly set to
false, this flag overrides other flags that make the kubectl commands apply to uninitialized objects, e.g., "--all".
Objects with empty metadata.initializers are regarded as initialized.
      --openapi-patch=true: If true, use openapi to calculate diff when the openapi presents and the resource can be
found in the openapi spec. Otherwise, fall back to use baked-in types.
  -o, --output='': Output format. One of:
json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...
See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template
[http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template
[http://kubernetes.io/docs/user-guide/jsonpath].
      --overwrite=true: Automatically resolve conflicts between the modified and live configuration by using values from
the modified configuration
      --prune=false: Automatically delete resource objects, including the uninitialized ones, that do not appear in the
configs and are created by either apply or create --save-config. Should be used with either -l or --all.
      --prune-whitelist=[]: Overwrite the default whitelist with <group/version/kind> for --prune
      --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the
command. If set to true, record the command. If not set, default to updating the existing annotation value only if one
already exists.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
related manifests organized within the same directory.
  -l, --selector='': Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2)
      --timeout=0s: The length of time to wait before giving up on a delete, zero means determine a timeout from the
size of the object
      --validate=true: If true, use a schema to validate the input before sending it
      --wait=false: If true, wait for resources to be gone before returning. This waits for finalizers.

Usage:
  kubectl apply -f FILENAME [options]
```

## attach

```bash
[vagrant@node1 ~]$ kubectl attach -h
Attach to a process that is already running inside an existing container.

Examples:
  # Get output from running pod 123456-7890, using the first container by default
  kubectl attach 123456-7890
  
  # Get output from ruby-container from pod 123456-7890
  kubectl attach 123456-7890 -c ruby-container
  
  # Switch to raw terminal mode, sends stdin to 'bash' in ruby-container from pod 123456-7890
  # and sends stdout/stderr from 'bash' back to the client
  kubectl attach 123456-7890 -c ruby-container -i -t
  
  # Get output from the first pod of a ReplicaSet named nginx
  kubectl attach rs/nginx

Options:
  -c, --container='': Container name. If omitted, the first container in the pod will be chosen
      --pod-running-timeout=1m0s: The length of time (like 5s, 2m, or 3h, higher than zero) to wait until at least one
pod is running
  -i, --stdin=false: Pass stdin to the container
  -t, --tty=false: Stdin is a TTY

Usage:
  kubectl attach (POD | TYPE/NAME) -c CONTAINER [options]
```

## auth

```bash
[vagrant@node1 ~]$ kubectl auth -h
Inspect authorization

Available Commands:
  can-i       Check whether an action is allowed
  reconcile   Reconciles rules for RBAC Role, RoleBinding, ClusterRole, and ClusterRole binding objects

Usage:
  kubectl auth [flags] [options]
```

## autoscale

```bash
[vagrant@node1 ~]$ kubectl autoscale -h
Creates an autoscaler that automatically chooses and sets the number of pods that run in a kubernetes cluster. 

Looks up a Deployment, ReplicaSet, or ReplicationController by name and creates an autoscaler that uses the given
resource as a reference. An autoscaler can automatically increase or decrease number of pods deployed within the system
as needed.

Examples:
  # Auto scale a deployment "foo", with the number of pods between 2 and 10, no target CPU utilization specified so a
default autoscaling policy will be used:
  kubectl autoscale deployment foo --min=2 --max=10
  
  # Auto scale a replication controller "foo", with the number of pods between 1 and 5, target CPU utilization at 80%:
  kubectl autoscale rc foo --max=5 --cpu-percent=80

Options:
      --cpu-percent=-1: The target average CPU utilization (represented as a percent of requested CPU) over all the
pods. If it's not specified or negative, a default autoscaling policy will be used.
      --dry-run=false: If true, only print the object that would be sent, without sending it.
  -f, --filename=[]: Filename, directory, or URL to files identifying the resource to autoscale.
      --generator='horizontalpodautoscaler/v1': The name of the API generator to use. Currently there is only 1
generator.
      --max=-1: The upper limit for the number of pods that can be set by the autoscaler. Required.
      --min=-1: The lower limit for the number of pods that can be set by the autoscaler. If it's not specified or
negative, the server will apply a default value.
      --name='': The name for the newly created object. If not specified, the name of the input resource will be used.
  -o, --output='': Output format. One of:
json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...
See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template
[http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template
[http://kubernetes.io/docs/user-guide/jsonpath].
      --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the
command. If set to true, record the command. If not set, default to updating the existing annotation value only if one
already exists.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
related manifests organized within the same directory.
      --save-config=false: If true, the configuration of current object will be saved in its annotation. Otherwise, the
annotation will be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.

Usage:
  kubectl autoscale (-f FILENAME | TYPE NAME | TYPE/NAME) [--min=MINPODS] --max=MAXPODS [--cpu-percent=CPU] [options]
```

## certificate

```bash
[vagrant@node1 ~]$ kubectl certificate -h
Modify certificate resources.

Available Commands:
  approve     Approve a certificate signing request
  deny        Deny a certificate signing request

Usage:
  kubectl certificate SUBCOMMAND [options]
```

## cluster-info

```bash
[vagrant@node1 ~]$ kubectl cluster-info -h
Display addresses of the master and services with label kubernetes.io/cluster-service=true To further debug and diagnose
cluster problems, use 'kubectl cluster-info dump'.

Examples:
  # Print the address of the master and cluster services
  kubectl cluster-info

Available Commands:
  dump        Dump lots of relevant info for debugging and diagnosis

Usage:
  kubectl cluster-info [flags] [options]
```

## completion

```bash
[vagrant@node1 ~]$ kubectl completion -h
Output shell completion code for the specified shell (bash or zsh). The shell code must be evaluated to provide
interactive completion of kubectl commands.  This can be done by sourcing it from the .bash _profile. 

Detailed instructions on how to do this are available here:
https://kubernetes.io/docs/tasks/tools/install-kubectl/#enabling-shell-autocompletion 

Note for zsh users: [1] zsh completions are only supported in versions of zsh >= 5.2

Examples:
  # Installing bash completion on macOS using homebrew
  ## If running Bash 3.2 included with macOS
  brew install bash-completion
  ## or, if running Bash 4.1+
  brew install bash-completion@2
  ## If kubectl is installed via homebrew, this should start working immediately.
  ## If you've installed via other means, you may need add the completion to your completion directory
  kubectl completion bash > $(brew --prefix)/etc/bash_completion.d/kubectl
  
  
  # Installing bash completion on Linux
  ## Load the kubectl completion code for bash into the current shell
  source <(kubectl completion bash)
  ## Write bash completion code to a file and source if from .bash_profile
  kubectl completion bash > ~/.kube/completion.bash.inc
  printf "
  # Kubectl shell completion
  source '$HOME/.kube/completion.bash.inc'
  " >> $HOME/.bash_profile
  source $HOME/.bash_profile
  
  # Load the kubectl completion code for zsh[1] into the current shell
  source <(kubectl completion zsh)
  # Set the kubectl completion code for zsh[1] to autoload on startup
  kubectl completion zsh > "${fpath[1]}/_kubectl"

Usage:
  kubectl completion SHELL [options]
```

## config

```bash
[vagrant@node1 ~]$ kubectl config -h
Modify kubeconfig files using subcommands like "kubectl config set current-context my-context" 

The loading order follows these rules: 

  1. If the --kubeconfig flag is set, then only that file is loaded.  The flag may only be set once and no merging takes
place.  
  2. If $KUBECONFIG environment variable is set, then it is used a list of paths (normal path delimitting rules for your
system).  These paths are merged.  When a value is modified, it is modified in the file that defines the stanza.  When a
value is created, it is created in the first file that exists.  If no files in the chain exist, then it creates the last
file in the list.  
  3. Otherwise, ${HOME}/.kube/config is used and no merging takes place.

Available Commands:
  current-context Displays the current-context
  delete-cluster  Delete the specified cluster from the kubeconfig
  delete-context  Delete the specified context from the kubeconfig
  get-clusters    Display clusters defined in the kubeconfig
  get-contexts    Describe one or many contexts
  rename-context  Renames a context from the kubeconfig file.
  set             Sets an individual value in a kubeconfig file
  set-cluster     Sets a cluster entry in kubeconfig
  set-context     Sets a context entry in kubeconfig
  set-credentials Sets a user entry in kubeconfig
  unset           Unsets an individual value in a kubeconfig file
  use-context     Sets the current-context in a kubeconfig file
  view            Display merged kubeconfig settings or a specified kubeconfig file

Usage:
  kubectl config SUBCOMMAND [options]
```

## cordon

```bash
[vagrant@node1 ~]$ kubectl cordon -h
Mark node as unschedulable.

Examples:
  # Mark node "foo" as unschedulable.
  kubectl cordon foo

Options:
      --dry-run=false: If true, only print the object that would be sent, without sending it.
  -l, --selector='': Selector (label query) to filter on

Usage:
  kubectl cordon NODE [options]
```

## cp

```bash
Copy files and directories to and from containers.

Examples:
  # !!!Important Note!!!
  # Requires that the 'tar' binary is present in your container
  # image.  If 'tar' is not present, 'kubectl cp' will fail.
  
  # Copy /tmp/foo_dir local directory to /tmp/bar_dir in a remote pod in the default namespace
  kubectl cp /tmp/foo_dir <some-pod>:/tmp/bar_dir
  
  # Copy /tmp/foo local file to /tmp/bar in a remote pod in a specific container
  kubectl cp /tmp/foo <some-pod>:/tmp/bar -c <specific-container>
  
  # Copy /tmp/foo local file to /tmp/bar in a remote pod in namespace <some-namespace>
  kubectl cp /tmp/foo <some-namespace>/<some-pod>:/tmp/bar
  
  # Copy /tmp/foo from a remote pod to /tmp/bar locally
  kubectl cp <some-namespace>/<some-pod>:/tmp/foo /tmp/bar

Options:
  -c, --container='': Container name. If omitted, the first container in the pod will be chosen

Usage:
  kubectl cp <file-spec-src> <file-spec-dest> [options]
```

## create

```bash
[vagrant@node1 ~]$ kubectl create -h
Create a resource from a file or from stdin. 

JSON and YAML formats are accepted.

Examples:
  # Create a pod using the data in pod.json.
  kubectl create -f ./pod.json
  
  # Create a pod based on the JSON passed into stdin.
  cat pod.json | kubectl create -f -
  
  # Edit the data in docker-registry.yaml in JSON then create the resource using the edited data.
  kubectl create -f docker-registry.yaml --edit -o json

Available Commands:
  clusterrole         Create a ClusterRole.
  clusterrolebinding  Create a ClusterRoleBinding for a particular ClusterRole
  configmap           Create a configmap from a local file, directory or literal value
  deployment          Create a deployment with the specified name.
  job                 Create a job with the specified name.
  namespace           Create a namespace with the specified name
  poddisruptionbudget Create a pod disruption budget with the specified name.
  priorityclass       Create a priorityclass with the specified name.
  quota               Create a quota with the specified name.
  role                Create a role with single rule.
  rolebinding         Create a RoleBinding for a particular Role or ClusterRole
  secret              Create a secret using specified subcommand
  service             Create a service using specified subcommand.
  serviceaccount      Create a service account with the specified name

Options:
      --allow-missing-template-keys=true: If true, ignore any errors in templates when a field or map key is missing in
the template. Only applies to golang and jsonpath output formats.
      --dry-run=false: If true, only print the object that would be sent, without sending it.
      --edit=false: Edit the API resource before creating
  -f, --filename=[]: Filename, directory, or URL to files to use to create the resource
  -o, --output='': Output format. One of:
json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...
See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template
[http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template
[http://kubernetes.io/docs/user-guide/jsonpath].
      --raw='': Raw URI to POST to the server.  Uses the transport specified by the kubeconfig file.
      --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the
command. If set to true, record the command. If not set, default to updating the existing annotation value only if one
already exists.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
related manifests organized within the same directory.
      --save-config=false: If true, the configuration of current object will be saved in its annotation. Otherwise, the
annotation will be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.
  -l, --selector='': Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2)
      --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The
template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
      --validate=true: If true, use a schema to validate the input before sending it
      --windows-line-endings=false: Only relevant if --edit=true. Defaults to the line ending native to your platform.

Usage:
  kubectl create -f FILENAME [options]
[vagrant@node1 ~]$ kubectl create -h
Create a resource from a file or from stdin. 

JSON and YAML formats are accepted.

Examples:
  # Create a pod using the data in pod.json.
  kubectl create -f ./pod.json
  
  # Create a pod based on the JSON passed into stdin.
  cat pod.json | kubectl create -f -
  
  # Edit the data in docker-registry.yaml in JSON then create the resource using the edited data.
  kubectl create -f docker-registry.yaml --edit -o json

Available Commands:
  clusterrole         Create a ClusterRole.
  clusterrolebinding  Create a ClusterRoleBinding for a particular ClusterRole
  configmap           Create a configmap from a local file, directory or literal value
  deployment          Create a deployment with the specified name.
  job                 Create a job with the specified name.
  namespace           Create a namespace with the specified name
  poddisruptionbudget Create a pod disruption budget with the specified name.
  priorityclass       Create a priorityclass with the specified name.
  quota               Create a quota with the specified name.
  role                Create a role with single rule.
  rolebinding         Create a RoleBinding for a particular Role or ClusterRole
  secret              Create a secret using specified subcommand
  service             Create a service using specified subcommand.
  serviceaccount      Create a service account with the specified name

Options:
      --allow-missing-template-keys=true: If true, ignore any errors in templates when a field or map key is missing in
the template. Only applies to golang and jsonpath output formats.
      --dry-run=false: If true, only print the object that would be sent, without sending it.
      --edit=false: Edit the API resource before creating
  -f, --filename=[]: Filename, directory, or URL to files to use to create the resource
  -o, --output='': Output format. One of:
json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...
See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template
[http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template
[http://kubernetes.io/docs/user-guide/jsonpath].
      --raw='': Raw URI to POST to the server.  Uses the transport specified by the kubeconfig file.
      --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the
command. If set to true, record the command. If not set, default to updating the existing annotation value only if one
already exists.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
related manifests organized within the same directory.
      --save-config=false: If true, the configuration of current object will be saved in its annotation. Otherwise, the
annotation will be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.
  -l, --selector='': Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2)
      --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The
template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
      --validate=true: If true, use a schema to validate the input before sending it
      --windows-line-endings=false: Only relevant if --edit=true. Defaults to the line ending native to your platform.

Usage:
  kubectl create -f FILENAME [options]
```

## convert

```bash
[vagrant@node1 ~]$ kubectl convert -h
Convert config files between different API versions. Both YAML and JSON formats are accepted. 

The command takes filename, directory, or URL as input, and convert it into format of version specified by
--output-version flag. If target version is not specified or not supported, convert to latest version. 

The default output will be printed to stdout in YAML format. One can use -o option to change to output destination.

Examples:
  # Convert 'pod.yaml' to latest version and print to stdout.
  kubectl convert -f pod.yaml
  
  # Convert the live state of the resource specified by 'pod.yaml' to the latest version
  # and print to stdout in JSON format.
  kubectl convert -f pod.yaml --local -o json
  
  # Convert all files under current directory to latest version and create them all.
  kubectl convert -f . | kubectl create -f -

Options:
  -f, --filename=[]: Filename, directory, or URL to files to need to get converted.
      --local=true: If true, convert will NOT try to contact api-server but run locally.
  -o, --output='yaml': Output format. One of:
json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...
See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template
[http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template
[http://kubernetes.io/docs/user-guide/jsonpath].
      --output-version='': Output the formatted object with the given group version (for ex: 'extensions/v1beta1').)
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
related manifests organized within the same directory.
      --validate=true: If true, use a schema to validate the input before sending it

Usage:
  kubectl convert -f FILENAME [options]
```

## delete

```bash
[vagrant@node1 ~]$ kubectl delete -h
Delete resources by filenames, stdin, resources and names, or by resources and label selector. 

JSON and YAML formats are accepted. Only one type of the arguments may be specified: filenames, resources and names, or
resources and label selector. 

Some resources, such as pods, support graceful deletion. These resources define a default period before they are
forcibly terminated (the grace period) but you may override that value with the --grace-period flag, or pass --now to
set a grace-period of 1. Because these resources often represent entities in the cluster, deletion may not be
acknowledged immediately. If the node hosting a pod is down or cannot reach the API server, termination may take
significantly longer than the grace period. To force delete a resource, you must pass a grace period of 0 and specify
the --force flag. 

IMPORTANT: Force deleting pods does not wait for confirmation that the pod's processes have been terminated, which can
leave those processes running until the node detects the deletion and completes graceful deletion. If your processes use
shared storage or talk to a remote API and depend on the name of the pod to identify themselves, force deleting those
pods may result in multiple processes running on different machines using the same identification which may lead to data
corruption or inconsistency. Only force delete pods when you are sure the pod is terminated, or if your application can
tolerate multiple copies of the same pod running at once. Also, if you force delete pods the scheduler may place new
pods on those nodes before the node has released those resources and causing those pods to be evicted immediately. 

Note that the delete command does NOT do resource version checks, so if someone submits an update to a resource right
when you submit a delete, their update will be lost along with the rest of the resource.

Examples:
  # Delete a pod using the type and name specified in pod.json.
  kubectl delete -f ./pod.json
  
  # Delete a pod based on the type and name in the JSON passed into stdin.
  cat pod.json | kubectl delete -f -
  
  # Delete pods and services with same names "baz" and "foo"
  kubectl delete pod,service baz foo
  
  # Delete pods and services with label name=myLabel.
  kubectl delete pods,services -l name=myLabel
  
  # Delete a pod with minimal delay
  kubectl delete pod foo --now
  
  # Force delete a pod on a dead node
  kubectl delete pod foo --grace-period=0 --force
  
  # Delete all pods
  kubectl delete pods --all

Options:
      --all=false: Delete all resources, including uninitialized ones, in the namespace of the specified resource types.
      --cascade=true: If true, cascade the deletion of the resources managed by this resource (e.g. Pods created by a
ReplicationController).  Default true.
      --field-selector='': Selector (field query) to filter on, supports '=', '==', and '!='.(e.g. --field-selector
key1=value1,key2=value2). The server only supports a limited number of field queries per type.
  -f, --filename=[]: containing the resource to delete.
      --force=false: Only used when grace-period=0. If true, immediately remove resources from API and bypass graceful
deletion. Note that immediate deletion of some resources may result in inconsistency or data loss and requires
confirmation.
      --grace-period=-1: Period of time in seconds given to the resource to terminate gracefully. Ignored if negative.
Set to 1 for immediate shutdown. Can only be set to 0 when --force is true (force deletion).
      --ignore-not-found=false: Treat "resource not found" as a successful delete. Defaults to "true" when --all is
specified.
      --include-uninitialized=false: If true, the kubectl command applies to uninitialized objects. If explicitly set to
false, this flag overrides other flags that make the kubectl commands apply to uninitialized objects, e.g., "--all".
Objects with empty metadata.initializers are regarded as initialized.
      --now=false: If true, resources are signaled for immediate shutdown (same as --grace-period=1).
  -o, --output='': Output mode. Use "-o name" for shorter output (resource/name).
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
related manifests organized within the same directory.
  -l, --selector='': Selector (label query) to filter on, not including uninitialized ones.
      --timeout=0s: The length of time to wait before giving up on a delete, zero means determine a timeout from the
size of the object
      --wait=true: If true, wait for resources to be gone before returning. This waits for finalizers.

Usage:
  kubectl delete ([-f FILENAME] | TYPE [(NAME | -l label | --all)]) [options]
```

## describe

```bash
[vagrant@node1 ~]$ kubectl describe -h
Show details of a specific resource or group of resources 

Print a detailed description of the selected resources, including related resources such as events or controllers. You
may select a single object by name, all objects of that type, provide a name prefix, or label selector. For example: 

  $ kubectl describe TYPE NAME_PREFIX
  
will first check for an exact match on TYPE and NAME PREFIX. If no such resource exists, it will output details for
every resource that has a name prefixed with NAME PREFIX.

Use "kubectl api-resources" for a complete list of supported resources.

Examples:
  # Describe a node
  kubectl describe nodes kubernetes-node-emt8.c.myproject.internal
  
  # Describe a pod
  kubectl describe pods/nginx
  
  # Describe a pod identified by type and name in "pod.json"
  kubectl describe -f pod.json
  
  # Describe all pods
  kubectl describe pods
  
  # Describe pods by label name=myLabel
  kubectl describe po -l name=myLabel
  
  # Describe all pods managed by the 'frontend' replication controller (rc-created pods
  # get the name of the rc as a prefix in the pod the name).
  kubectl describe pods frontend

Options:
      --all-namespaces=false: If present, list the requested object(s) across all namespaces. Namespace in current
context is ignored even if specified with --namespace.
  -f, --filename=[]: Filename, directory, or URL to files containing the resource to describe
      --include-uninitialized=false: If true, the kubectl command applies to uninitialized objects. If explicitly set to
false, this flag overrides other flags that make the kubectl commands apply to uninitialized objects, e.g., "--all".
Objects with empty metadata.initializers are regarded as initialized.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
related manifests organized within the same directory.
  -l, --selector='': Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2)
      --show-events=true: If true, display events related to the described object.

Usage:
  kubectl describe (-f FILENAME | TYPE [NAME_PREFIX | -l label] | TYPE/NAME) [options]
```

## drain

```bash
[vagrant@node1 ~]$ kubectl drain -h
Drain node in preparation for maintenance. 

The given node will be marked unschedulable to prevent new pods from arriving. 'drain' evicts the pods if the APIServer
supports eviction (http://kubernetes.io/docs/admin/disruptions/). Otherwise, it will use normal DELETE to delete the
pods. The 'drain' evicts or deletes all pods except mirror pods (which cannot be deleted through the API server).  If
there are DaemonSet-managed pods, drain will not proceed without --ignore-daemonsets, and regardless it will not delete
any DaemonSet-managed pods, because those pods would be immediately replaced by the DaemonSet controller, which ignores
unschedulable markings.  If there are any pods that are neither mirror pods nor managed by ReplicationController,
ReplicaSet, DaemonSet, StatefulSet or Job, then drain will not delete any pods unless you use --force.  --force will
also allow deletion to proceed if the managing resource of one or more pods is missing. 

'drain' waits for graceful termination. You should not operate on the machine until the command completes. 

When you are ready to put the node back into service, use kubectl uncordon, which will make the node schedulable again. 

! http://kubernetes.io/images/docs/kubectl_drain.svg

Examples:
  # Drain node "foo", even if there are pods not managed by a ReplicationController, ReplicaSet, Job, DaemonSet or
StatefulSet on it.
  $ kubectl drain foo --force
  
  # As above, but abort if there are pods not managed by a ReplicationController, ReplicaSet, Job, DaemonSet or
StatefulSet, and use a grace period of 15 minutes.
  $ kubectl drain foo --grace-period=900

Options:
      --delete-local-data=false: Continue even if there are pods using emptyDir (local data that will be deleted when
the node is drained).
      --dry-run=false: If true, only print the object that would be sent, without sending it.
      --force=false: Continue even if there are pods not managed by a ReplicationController, ReplicaSet, Job, DaemonSet
or StatefulSet.
      --grace-period=-1: Period of time in seconds given to each pod to terminate gracefully. If negative, the default
value specified in the pod will be used.
      --ignore-daemonsets=false: Ignore DaemonSet-managed pods.
      --pod-selector='': Label selector to filter pods on the node
  -l, --selector='': Selector (label query) to filter on
      --timeout=0s: The length of time to wait before giving up, zero means infinite

Usage:
  kubectl drain NODE [options]
```

## edit

```bash
[vagrant@node1 ~]$ kubectl edit -h
Edit a resource from the default editor. 

The edit command allows you to directly edit any API resource you can retrieve via the command line tools. It will open
the editor defined by your KUBE _EDITOR, or EDITOR environment variables, or fall back to 'vi' for Linux or 'notepad'
for Windows. You can edit multiple objects, although changes are applied one at a time. The command accepts filenames as
well as command line arguments, although the files you point to must be previously saved versions of resources. 

Editing is done with the API version used to fetch the resource. To edit using a specific API version, fully-qualify the
resource, version, and group. 

The default format is YAML. To edit in JSON, specify "-o json". 

The flag --windows-line-endings can be used to force Windows line endings, otherwise the default for your operating
system will be used. 

In the event an error occurs while updating, a temporary file will be created on disk that contains your unapplied
changes. The most common error when updating a resource is another editor changing the resource on the server. When this
occurs, you will have to apply your changes to the newer version of the resource, or update your temporary saved copy to
include the latest resource version.

Examples:
  # Edit the service named 'docker-registry':
  kubectl edit svc/docker-registry
  
  # Use an alternative editor
  KUBE_EDITOR="nano" kubectl edit svc/docker-registry
  
  # Edit the job 'myjob' in JSON using the v1 API format:
  kubectl edit job.v1.batch/myjob -o json
  
  # Edit the deployment 'mydeployment' in YAML and save the modified config in its annotation:
  kubectl edit deployment/mydeployment -o yaml --save-config

Options:
  -f, --filename=[]: Filename, directory, or URL to files to use to edit the resource
      --include-uninitialized=false: If true, the kubectl command applies to uninitialized objects. If explicitly set to
false, this flag overrides other flags that make the kubectl commands apply to uninitialized objects, e.g., "--all".
Objects with empty metadata.initializers are regarded as initialized.
  -o, --output='': Output format. One of:
json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...
See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template
[http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template
[http://kubernetes.io/docs/user-guide/jsonpath].
      --output-patch=false: Output the patch if the resource is edited.
      --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the
command. If set to true, record the command. If not set, default to updating the existing annotation value only if one
already exists.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
related manifests organized within the same directory.
      --save-config=false: If true, the configuration of current object will be saved in its annotation. Otherwise, the
annotation will be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.
      --validate=true: If true, use a schema to validate the input before sending it
      --windows-line-endings=false: Defaults to the line ending native to your platform.

Usage:
  kubectl edit (RESOURCE/NAME | -f FILENAME) [options]
```

## exec

```bash
[vagrant@node1 ~]$ kubectl exec -h
Execute a command in a container.

Examples:
  # Get output from running 'date' from pod 123456-7890, using the first container by default
  kubectl exec 123456-7890 date
  
  # Get output from running 'date' in ruby-container from pod 123456-7890
  kubectl exec 123456-7890 -c ruby-container date
  
  # Switch to raw terminal mode, sends stdin to 'bash' in ruby-container from pod 123456-7890
  # and sends stdout/stderr from 'bash' back to the client
  kubectl exec 123456-7890 -c ruby-container -i -t -- bash -il
  
  # List contents of /usr from the first container of pod 123456-7890 and sort by modification time.
  # If the command you want to execute in the pod has any flags in common (e.g. -i),
  # you must use two dashes (--) to separate your command's flags/arguments.
  # Also note, do not surround your command and its flags/arguments with quotes
  # unless that is how you would execute it normally (i.e., do ls -t /usr, not "ls -t /usr").
  kubectl exec 123456-7890 -i -t -- ls -t /usr

Options:
  -c, --container='': Container name. If omitted, the first container in the pod will be chosen
  -p, --pod='': Pod name
  -i, --stdin=false: Pass stdin to the container
  -t, --tty=false: Stdin is a TTY

Usage:
  kubectl exec POD [-c CONTAINER] -- COMMAND [args...] [options]
```

## explain

```bash
[vagrant@node1 ~]$ kubectl explain -h
List the fields for supported resources 

This command describes the fields associated with each supported API resource. Fields are identified via a simple
JSONPath identifier: 

  <type>.<fieldName>[.<fieldName>]
  
Add the --recursive flag to display all of the fields at once without descriptions. Information about each field is
retrieved from the server in OpenAPI format.

Use "kubectl api-resources" for a complete list of supported resources.

Examples:
  # Get the documentation of the resource and its fields
  kubectl explain pods
  
  # Get the documentation of a specific field of a resource
  kubectl explain pods.spec.containers

Options:
      --api-version='': Get different explanations for particular API version
      --recursive=false: Print the fields of fields (Currently only 1 level deep)

Usage:
  kubectl explain RESOURCE [options]
```

## expose

```bash
[vagrant@node1 ~]$ kubectl expose -h
Expose a resource as a new Kubernetes service. 

Looks up a deployment, service, replica set, replication controller or pod by name and uses the selector for that
resource as the selector for a new service on the specified port. A deployment or replica set will be exposed as a
service only if its selector is convertible to a selector that service supports, i.e. when the selector contains only
the matchLabels component. Note that if no port is specified via --port and the exposed resource has multiple ports, all
will be re-used by the new service. Also if no labels are specified, the new service will re-use the labels from the
resource it exposes. 

Possible resources include (case insensitive): 

pod (po), service (svc), replicationcontroller (rc), deployment (deploy), replicaset (rs)

Examples:
  # Create a service for a replicated nginx, which serves on port 80 and connects to the containers on port 8000.
  kubectl expose rc nginx --port=80 --target-port=8000
  
  # Create a service for a replication controller identified by type and name specified in "nginx-controller.yaml",
which serves on port 80 and connects to the containers on port 8000.
  kubectl expose -f nginx-controller.yaml --port=80 --target-port=8000
  
  # Create a service for a pod valid-pod, which serves on port 444 with the name "frontend"
  kubectl expose pod valid-pod --port=444 --name=frontend
  
  # Create a second service based on the above service, exposing the container port 8443 as port 443 with the name
"nginx-https"
  kubectl expose service nginx --port=443 --target-port=8443 --name=nginx-https
  
  # Create a service for a replicated streaming application on port 4100 balancing UDP traffic and named 'video-stream'.
  kubectl expose rc streamer --port=4100 --protocol=udp --name=video-stream
  
  # Create a service for a replicated nginx using replica set, which serves on port 80 and connects to the containers on
port 8000.
  kubectl expose rs nginx --port=80 --target-port=8000
  
  # Create a service for an nginx deployment, which serves on port 80 and connects to the containers on port 8000.
  kubectl expose deployment nginx --port=80 --target-port=8000

Options:
      --cluster-ip='': ClusterIP to be assigned to the service. Leave empty to auto-allocate, or set to 'None' to create
a headless service.
      --dry-run=false: If true, only print the object that would be sent, without sending it.
      --external-ip='': Additional external IP address (not managed by Kubernetes) to accept for the service. If this IP
is routed to a node, the service can be accessed by this IP in addition to its generated service IP.
  -f, --filename=[]: Filename, directory, or URL to files identifying the resource to expose a service
      --generator='service/v2': The name of the API generator to use. There are 2 generators: 'service/v1' and
'service/v2'. The only difference between them is that service port in v1 is named 'default', while it is left unnamed
in v2. Default is 'service/v2'.
  -l, --labels='': Labels to apply to the service created by this call.
      --load-balancer-ip='': IP to assign to the LoadBalancer. If empty, an ephemeral IP will be created and used
(cloud-provider specific).
      --name='': The name for the newly created object.
  -o, --output='': Output format. One of:
json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...
See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template
[http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template
[http://kubernetes.io/docs/user-guide/jsonpath].
      --overrides='': An inline JSON override for the generated object. If this is non-empty, it is used to override the
generated object. Requires that the object supply a valid apiVersion field.
      --port='': The port that the service should serve on. Copied from the resource being exposed, if unspecified
      --protocol='': The network protocol for the service to be created. Default is 'TCP'.
      --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the
command. If set to true, record the command. If not set, default to updating the existing annotation value only if one
already exists.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
related manifests organized within the same directory.
      --save-config=false: If true, the configuration of current object will be saved in its annotation. Otherwise, the
annotation will be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.
      --selector='': A label selector to use for this service. Only equality-based selector requirements are supported.
If empty (the default) infer the selector from the replication controller or replica set.)
      --session-affinity='': If non-empty, set the session affinity for the service to this; legal values: 'None',
'ClientIP'
      --target-port='': Name or number for the port on the container that the service should direct traffic to.
Optional.
      --type='': Type for this service: ClusterIP, NodePort, LoadBalancer, or ExternalName. Default is 'ClusterIP'.

Usage:
  kubectl expose (-f FILENAME | TYPE NAME) [--port=port] [--protocol=TCP|UDP] [--target-port=number-or-name]
[--name=name] [--external-ip=external-ip-of-service] [--type=type] [options]
```

## get

```bash
[vagrant@node1 ~]$ kubectl get -h
Display one or many resources 

Prints a table of the most important information about the specified resources. You can filter the list using a label
selector and the --selector flag. If the desired resource type is namespaced you will only see results in your current
namespace unless you pass --all-namespaces. 

Uninitialized objects are not shown unless --include-uninitialized is passed. 

By specifying the output as 'template' and providing a Go template as the value of the --template flag, you can filter
the attributes of the fetched resources.

Use "kubectl api-resources" for a complete list of supported resources.

Examples:
  # List all pods in ps output format.
  kubectl get pods
  
  # List all pods in ps output format with more information (such as node name).
  kubectl get pods -o wide
  
  # List a single replication controller with specified NAME in ps output format.
  kubectl get replicationcontroller web
  
  # List deployments in JSON output format, in the "v1" version of the "apps" API group:
  kubectl get deployments.v1.apps -o json
  
  # List a single pod in JSON output format.
  kubectl get -o json pod web-pod-13je7
  
  # List a pod identified by type and name specified in "pod.yaml" in JSON output format.
  kubectl get -f pod.yaml -o json
  
  # Return only the phase value of the specified pod.
  kubectl get -o template pod/web-pod-13je7 --template={{.status.phase}}
  
  # List all replication controllers and services together in ps output format.
  kubectl get rc,services
  
  # List one or more resources by their type and names.
  kubectl get rc/web service/frontend pods/web-pod-13je7

Options:
      --all-namespaces=false: If present, list the requested object(s) across all namespaces. Namespace in current
context is ignored even if specified with --namespace.
      --allow-missing-template-keys=true: If true, ignore any errors in templates when a field or map key is missing in
the template. Only applies to golang and jsonpath output formats.
      --chunk-size=500: Return large lists in chunks rather than all at once. Pass 0 to disable. This flag is beta and
may change in the future.
      --export=false: If true, use 'export' for the resources.  Exported resources are stripped of cluster-specific
information.
      --field-selector='': Selector (field query) to filter on, supports '=', '==', and '!='.(e.g. --field-selector
key1=value1,key2=value2). The server only supports a limited number of field queries per type.
  -f, --filename=[]: Filename, directory, or URL to files identifying the resource to get from a server.
      --ignore-not-found=false: If the requested object does not exist the command will return exit code 0.
      --include-uninitialized=false: If true, the kubectl command applies to uninitialized objects. If explicitly set to
false, this flag overrides other flags that make the kubectl commands apply to uninitialized objects, e.g., "--all".
Objects with empty metadata.initializers are regarded as initialized.
  -L, --label-columns=[]: Accepts a comma separated list of labels that are going to be presented as columns. Names are
case-sensitive. You can also use multiple flag options like -L label1 -L label2...
      --no-headers=false: When using the default or custom-column output format, don't print headers (default print
headers).
  -o, --output='': Output format. One of:
json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...
See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template
[http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template
[http://kubernetes.io/docs/user-guide/jsonpath].
      --raw='': Raw URI to request from the server.  Uses the transport specified by the kubeconfig file.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
related manifests organized within the same directory.
  -l, --selector='': Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2)
      --server-print=true: If true, have the server return the appropriate table output. Supports extension APIs and
CRDs.
      --show-kind=false: If present, list the resource type for the requested object(s).
      --show-labels=false: When printing, show all labels as the last column (default hide labels column)
      --sort-by='': If non-empty, sort list types using this field specification.  The field specification is expressed
as a JSONPath expression (e.g. '{.metadata.name}'). The field in the API resource specified by this JSONPath expression
must be an integer or a string.
      --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The
template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
      --use-openapi-print-columns=false: If true, use x-kubernetes-print-column metadata (if present) from the OpenAPI
schema for displaying a resource.
  -w, --watch=false: After listing/getting the requested object, watch for changes. Uninitialized objects are excluded
if no object name is provided.
      --watch-only=false: Watch for changes to the requested object(s), without listing/getting first.

Usage:
  kubectl get
[(-o|--output=)json|yaml|wide|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...]
(TYPE[.VERSION][.GROUP] [NAME | -l label] | TYPE[.VERSION][.GROUP]/NAME ...) [flags] [options]
```

## label

```bash
[vagrant@node1 ~]$ kubectl label -h
Update the labels on a resource. 

  * A label key and value must begin with a letter or number, and may contain letters, numbers, hyphens, dots, and
underscores, up to  63 characters each.  
  * Optionally, the key can begin with a DNS subdomain prefix and a single '/', like example.com/my-app  
  * If --overwrite is true, then existing labels can be overwritten, otherwise attempting to overwrite a label will
result in an error.  
  * If --resource-version is specified, then updates will use this resource version, otherwise the existing
resource-version will be used.

Examples:
  # Update pod 'foo' with the label 'unhealthy' and the value 'true'.
  kubectl label pods foo unhealthy=true
  
  # Update pod 'foo' with the label 'status' and the value 'unhealthy', overwriting any existing value.
  kubectl label --overwrite pods foo status=unhealthy
  
  # Update all pods in the namespace
  kubectl label pods --all status=unhealthy
  
  # Update a pod identified by the type and name in "pod.json"
  kubectl label -f pod.json status=unhealthy
  
  # Update pod 'foo' only if the resource is unchanged from version 1.
  kubectl label pods foo status=unhealthy --resource-version=1
  
  # Update pod 'foo' by removing a label named 'bar' if it exists.
  # Does not require the --overwrite flag.
  kubectl label pods foo bar-

Options:
      --all=false: Select all resources, including uninitialized ones, in the namespace of the specified resource types
      --dry-run=false: If true, only print the object that would be sent, without sending it.
      --field-selector='': Selector (field query) to filter on, supports '=', '==', and '!='.(e.g. --field-selector
key1=value1,key2=value2). The server only supports a limited number of field queries per type.
  -f, --filename=[]: Filename, directory, or URL to files identifying the resource to update the labels
      --include-uninitialized=false: If true, the kubectl command applies to uninitialized objects. If explicitly set to
false, this flag overrides other flags that make the kubectl commands apply to uninitialized objects, e.g., "--all".
Objects with empty metadata.initializers are regarded as initialized.
      --list=false: If true, display the labels for a given resource.
      --local=false: If true, label will NOT contact api-server but run locally.
  -o, --output='': Output format. One of:
json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...
See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template
[http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template
[http://kubernetes.io/docs/user-guide/jsonpath].
      --overwrite=false: If true, allow labels to be overwritten, otherwise reject label updates that overwrite existing
labels.
      --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the
command. If set to true, record the command. If not set, default to updating the existing annotation value only if one
already exists.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
related manifests organized within the same directory.
      --resource-version='': If non-empty, the labels update will only succeed if this is the current resource-version
for the object. Only valid when specifying a single resource.
  -l, --selector='': Selector (label query) to filter on, not including uninitialized ones, supports '=', '==', and
'!='.(e.g. -l key1=value1,key2=value2).

Usage:
  kubectl label [--overwrite] (-f FILENAME | TYPE NAME) KEY_1=VAL_1 ... KEY_N=VAL_N [--resource-version=version] [options]
```

## logs

```bash
[vagrant@node1 ~]$ kubectl logs -h
Print the logs for a container in a pod or specified resource. If the pod has only one container, the container name is
optional.

Aliases:
logs, log

Examples:
  # Return snapshot logs from pod nginx with only one container
  kubectl logs nginx
  
  # Return snapshot logs from pod nginx with multi containers
  kubectl logs nginx --all-containers=true
  
  # Return snapshot logs from all containers in pods defined by label app=nginx
  kubectl logs -lapp=nginx --all-containers=true
  
  # Return snapshot of previous terminated ruby container logs from pod web-1
  kubectl logs -p -c ruby web-1
  
  # Begin streaming the logs of the ruby container in pod web-1
  kubectl logs -f -c ruby web-1
  
  # Display only the most recent 20 lines of output in pod nginx
  kubectl logs --tail=20 nginx
  
  # Show all logs from pod nginx written in the last hour
  kubectl logs --since=1h nginx
  
  # Return snapshot logs from first container of a job named hello
  kubectl logs job/hello
  
  # Return snapshot logs from container nginx-1 of a deployment named nginx
  kubectl logs deployment/nginx -c nginx-1

Options:
      --all-containers=false: Get all containers's logs in the pod(s).
  -c, --container='': Print the logs of this container
  -f, --follow=false: Specify if the logs should be streamed.
      --limit-bytes=0: Maximum bytes of logs to return. Defaults to no limit.
      --pod-running-timeout=20s: The length of time (like 5s, 2m, or 3h, higher than zero) to wait until at least one
pod is running
  -p, --previous=false: If true, print the logs for the previous instance of the container in a pod if it exists.
  -l, --selector='': Selector (label query) to filter on.
      --since=0s: Only return logs newer than a relative duration like 5s, 2m, or 3h. Defaults to all logs. Only one of
since-time / since may be used.
      --since-time='': Only return logs after a specific date (RFC3339). Defaults to all logs. Only one of since-time /
since may be used.
      --tail=-1: Lines of recent log file to display. Defaults to -1 with no selector, showing all log lines otherwise
10, if a selector is provided.
      --timestamps=false: Include timestamps on each line in the log output

Usage:
  kubectl logs [-f] [-p] (POD | TYPE/NAME) [-c CONTAINER] [options]
```

## patch

```bash
[vagrant@node1 ~]$ kubectl patch -h
Update field(s) of a resource using strategic merge patch, a JSON merge patch, or a JSON patch. 

JSON and YAML formats are accepted. 

Please refer to the models in
https://htmlpreview.github.io/?https://github.com/kubernetes/kubernetes/blob/HEAD/docs/api-reference/v1/definitions.html
to find if a field is mutable.

Examples:
  # Partially update a node using a strategic merge patch. Specify the patch as JSON.
  kubectl patch node k8s-node-1 -p '{"spec":{"unschedulable":true}}'
  
  # Partially update a node using a strategic merge patch. Specify the patch as YAML.
  kubectl patch node k8s-node-1 -p $'spec:\n unschedulable: true'
  
  # Partially update a node identified by the type and name specified in "node.json" using strategic merge patch.
  kubectl patch -f node.json -p '{"spec":{"unschedulable":true}}'
  
  # Update a container's image; spec.containers[*].name is required because it's a merge key.
  kubectl patch pod valid-pod -p '{"spec":{"containers":[{"name":"kubernetes-serve-hostname","image":"new image"}]}}'
  
  # Update a container's image using a json patch with positional arrays.
  kubectl patch pod valid-pod --type='json' -p='[{"op": "replace", "path": "/spec/containers/0/image", "value":"new
image"}]'

Options:
      --dry-run=false: If true, only print the object that would be sent, without sending it.
  -f, --filename=[]: Filename, directory, or URL to files identifying the resource to update
      --local=false: If true, patch will operate on the content of the file, not the server-side resource.
  -o, --output='': Output format. One of:
json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...
See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template
[http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template
[http://kubernetes.io/docs/user-guide/jsonpath].
  -p, --patch='': The patch to be applied to the resource JSON file.
      --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the
command. If set to true, record the command. If not set, default to updating the existing annotation value only if one
already exists.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
related manifests organized within the same directory.
      --type='strategic': The type of patch being provided; one of [json merge strategic]

Usage:
  kubectl patch (-f FILENAME | TYPE NAME) -p PATCH [options]
```

## plugin

```bash
[vagrant@node1 ~]$ kubectl plugin -h
Runs a command-line plugin. 

Plugins are subcommands that are not part of the major command-line distribution and can even be provided by
third-parties. Please refer to the documentation and examples for more information about how to install and write your
own plugins.

Usage:
  kubectl plugin NAME [options]
```

## port-forward

```bash
[vagrant@node1 ~]$ kubectl port-forward -h
Forward one or more local ports to a pod. 

Use resource type/name such as deployment/mydeployment to select a pod. Resource type defaults to 'pod' if omitted. 

If there are multiple pods matching the criteria, a pod will be selected automatically. The forwarding session ends when
the selected pod terminates, and rerun of the command is needed to resume forwarding.

Examples:
  # Listen on ports 5000 and 6000 locally, forwarding data to/from ports 5000 and 6000 in the pod
  kubectl port-forward pod/mypod 5000 6000
  
  # Listen on ports 5000 and 6000 locally, forwarding data to/from ports 5000 and 6000 in a pod selected by the
deployment
  kubectl port-forward deployment/mydeployment 5000 6000
  
  # Listen on port 8888 locally, forwarding to 5000 in the pod
  kubectl port-forward pod/mypod 8888:5000
  
  # Listen on a random port locally, forwarding to 5000 in the pod
  kubectl port-forward pod/mypod :5000

Options:
      --pod-running-timeout=1m0s: The length of time (like 5s, 2m, or 3h, higher than zero) to wait until at least one
pod is running

Usage:
  kubectl port-forward TYPE/NAME [LOCAL_PORT:]REMOTE_PORT [...[LOCAL_PORT_N:]REMOTE_PORT_N] [options]
```

## proxy

```bash
[vagrant@node1 ~]$ kubectl proxy -h
Creates a proxy server or application-level gateway between localhost and the Kubernetes API Server. It also allows
serving static content over specified HTTP path. All incoming data enters through one port and gets forwarded to the
remote kubernetes API Server port, except for the path matching the static content path.

Examples:
  # To proxy all of the kubernetes api and nothing else, use:
  
  $ kubectl proxy --api-prefix=/
  
  # To proxy only part of the kubernetes api and also some static files:
  
  $ kubectl proxy --www=/my/files --www-prefix=/static/ --api-prefix=/api/
  
  # The above lets you 'curl localhost:8001/api/v1/pods'.
  
  # To proxy the entire kubernetes api at a different root, use:
  
  $ kubectl proxy --api-prefix=/custom/
  
  # The above lets you 'curl localhost:8001/custom/api/v1/pods'
  
  # Run a proxy to kubernetes apiserver on port 8011, serving static content from ./local/www/
  kubectl proxy --port=8011 --www=./local/www/
  
  # Run a proxy to kubernetes apiserver on an arbitrary local port.
  # The chosen port for the server will be output to stdout.
  kubectl proxy --port=0
  
  # Run a proxy to kubernetes apiserver, changing the api prefix to k8s-api
  # This makes e.g. the pods api available at localhost:8001/k8s-api/v1/pods/
  kubectl proxy --api-prefix=/k8s-api

Options:
      --accept-hosts='^localhost$,^127\.0\.0\.1$,^\[::1\]$': Regular expression for hosts that the proxy should accept.
      --accept-paths='^.*': Regular expression for paths that the proxy should accept.
      --address='127.0.0.1': The IP address on which to serve on.
      --api-prefix='/': Prefix to serve the proxied API under.
      --disable-filter=false: If true, disable request filtering in the proxy. This is dangerous, and can leave you
vulnerable to XSRF attacks, when used with an accessible port.
  -p, --port=8001: The port on which to run the proxy. Set to 0 to pick a random port.
      --reject-methods='^$': Regular expression for HTTP methods that the proxy should reject (example
--reject-methods='POST,PUT,PATCH'). 
      --reject-paths='^/api/.*/pods/.*/exec,^/api/.*/pods/.*/attach': Regular expression for paths that the proxy should
reject. Paths specified here will be rejected even accepted by --accept-paths.
  -u, --unix-socket='': Unix socket on which to run the proxy.
  -w, --www='': Also serve static files from the given directory under the specified prefix.
  -P, --www-prefix='/static/': Prefix to serve static files under, if static file directory is specified.

Usage:
  kubectl proxy [--port=PORT] [--www=static-dir] [--www-prefix=prefix] [--api-prefix=prefix] [options]
```

## replace

```bash
[vagrant@node1 ~]$ kubectl replace -h
Replace a resource by filename or stdin. 

JSON and YAML formats are accepted. If replacing an existing resource, the complete resource spec must be provided. This
can be obtained by 

  $ kubectl get TYPE NAME -o yaml
  
Please refer to the models in
https://htmlpreview.github.io/?https://github.com/kubernetes/kubernetes/blob/HEAD/docs/api-reference/v1/definitions.html
to find if a field is mutable.

Examples:
  # Replace a pod using the data in pod.json.
  kubectl replace -f ./pod.json
  
  # Replace a pod based on the JSON passed into stdin.
  cat pod.json | kubectl replace -f -
  
  # Update a single-container pod's image version (tag) to v4
  kubectl get pod mypod -o yaml | sed 's/\(image: myimage\):.*$/\1:v4/' | kubectl replace -f -
  
  # Force replace, delete and then re-create the resource
  kubectl replace --force -f ./pod.json

Options:
      --cascade=true: If true, cascade the deletion of the resources managed by this resource (e.g. Pods created by a
ReplicationController).  Default true.
  -f, --filename=[]: to use to replace the resource.
      --force=false: Only used when grace-period=0. If true, immediately remove resources from API and bypass graceful
deletion. Note that immediate deletion of some resources may result in inconsistency or data loss and requires
confirmation.
      --grace-period=-1: Period of time in seconds given to the resource to terminate gracefully. Ignored if negative.
Set to 1 for immediate shutdown. Can only be set to 0 when --force is true (force deletion).
  -o, --output='': Output format. One of:
json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...
See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template
[http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template
[http://kubernetes.io/docs/user-guide/jsonpath].
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
related manifests organized within the same directory.
      --save-config=false: If true, the configuration of current object will be saved in its annotation. Otherwise, the
annotation will be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.
      --timeout=0s: The length of time to wait before giving up on a delete, zero means determine a timeout from the
size of the object
      --validate=true: If true, use a schema to validate the input before sending it
      --wait=false: If true, wait for resources to be gone before returning. This waits for finalizers.

Usage:
  kubectl replace -f FILENAME [options]
```

## rollout

```bash
[vagrant@node1 ~]$ kubectl rollout -h
Manage the rollout of a resource.
  
Valid resource types include: 

  * deployments  
  * daemonsets  
  * statefulsets

Examples:
  # Rollback to the previous deployment
  kubectl rollout undo deployment/abc
  
  # Check the rollout status of a daemonset
  kubectl rollout status daemonset/foo

Available Commands:
  history     View rollout history
  pause       Mark the provided resource as paused
  resume      Resume a paused resource
  status      Show the status of the rollout
  undo        Undo a previous rollout

Usage:
  kubectl rollout SUBCOMMAND [options]
```

## run

```bash
[vagrant@node1 ~]$ kubectl run -h
Create and run a particular image, possibly replicated. 

Creates a deployment or job to manage the created container(s).

Examples:
  # Start a single instance of nginx.
  kubectl run nginx --image=nginx
  
  # Start a single instance of hazelcast and let the container expose port 5701 .
  kubectl run hazelcast --image=hazelcast --port=5701
  
  # Start a single instance of hazelcast and set environment variables "DNS_DOMAIN=cluster" and "POD_NAMESPACE=default"
in the container.
  kubectl run hazelcast --image=hazelcast --env="DNS_DOMAIN=cluster" --env="POD_NAMESPACE=default"
  
  # Start a single instance of hazelcast and set labels "app=hazelcast" and "env=prod" in the container.
  kubectl run hazelcast --image=nginx --labels="app=hazelcast,env=prod"
  
  # Start a replicated instance of nginx.
  kubectl run nginx --image=nginx --replicas=5
  
  # Dry run. Print the corresponding API objects without creating them.
  kubectl run nginx --image=nginx --dry-run
  
  # Start a single instance of nginx, but overload the spec of the deployment with a partial set of values parsed from
JSON.
  kubectl run nginx --image=nginx --overrides='{ "apiVersion": "v1", "spec": { ... } }'
  
  # Start a pod of busybox and keep it in the foreground, don't restart it if it exits.
  kubectl run -i -t busybox --image=busybox --restart=Never
  
  # Start the nginx container using the default command, but use custom arguments (arg1 .. argN) for that command.
  kubectl run nginx --image=nginx -- <arg1> <arg2> ... <argN>
  
  # Start the nginx container using a different command and custom arguments.
  kubectl run nginx --image=nginx --command -- <cmd> <arg1> ... <argN>
  
  # Start the perl container to compute π to 2000 places and print it out.
  kubectl run pi --image=perl --restart=OnFailure -- perl -Mbignum=bpi -wle 'print bpi(2000)'
  
  # Start the cron job to compute π to 2000 places and print it out every 5 minutes.
  kubectl run pi --schedule="0/5 * * * ?" --image=perl --restart=OnFailure -- perl -Mbignum=bpi -wle 'print bpi(2000)'

Options:
      --attach=false: If true, wait for the Pod to start running, and then attach to the Pod as if 'kubectl attach ...'
were called.  Default false, unless '-i/--stdin' is set, in which case the default is true. With '--restart=Never' the
exit code of the container process is returned.
      --cascade=true: If true, cascade the deletion of the resources managed by this resource (e.g. Pods created by a
ReplicationController).  Default true.
      --command=false: If true and extra arguments are present, use them as the 'command' field in the container, rather
than the 'args' field which is the default.
      --dry-run=false: If true, only print the object that would be sent, without sending it.
      --env=[]: Environment variables to set in the container
      --expose=false: If true, a public, external service is created for the container(s) which are run
  -f, --filename=[]: to use to replace the resource.
      --force=false: Only used when grace-period=0. If true, immediately remove resources from API and bypass graceful
deletion. Note that immediate deletion of some resources may result in inconsistency or data loss and requires
confirmation.
      --generator='': The name of the API generator to use, see
http://kubernetes.io/docs/user-guide/kubectl-conventions/#generators for a list.
      --grace-period=-1: Period of time in seconds given to the resource to terminate gracefully. Ignored if negative.
Set to 1 for immediate shutdown. Can only be set to 0 when --force is true (force deletion).
      --hostport=-1: The host port mapping for the container port. To demonstrate a single-machine container.
      --image='': The image for the container to run.
      --image-pull-policy='': The image pull policy for the container. If left empty, this value will not be specified
by the client and defaulted by the server
  -l, --labels='': Comma separated labels to apply to the pod(s). Will override previous values.
      --leave-stdin-open=false: If the pod is started in interactive mode or with stdin, leave stdin open after the
first attach completes. By default, stdin will be closed after the first attach completes.
      --limits='': The resource requirement limits for this container.  For example, 'cpu=200m,memory=512Mi'.  Note that
server side components may assign limits depending on the server configuration, such as limit ranges.
  -o, --output='': Output format. One of:
json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...
See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template
[http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template
[http://kubernetes.io/docs/user-guide/jsonpath].
      --overrides='': An inline JSON override for the generated object. If this is non-empty, it is used to override the
generated object. Requires that the object supply a valid apiVersion field.
      --pod-running-timeout=1m0s: The length of time (like 5s, 2m, or 3h, higher than zero) to wait until at least one
pod is running
      --port='': The port that this container exposes.  If --expose is true, this is also the port used by the service
that is created.
      --quiet=false: If true, suppress prompt messages.
      --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the
command. If set to true, record the command. If not set, default to updating the existing annotation value only if one
already exists.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
related manifests organized within the same directory.
  -r, --replicas=1: Number of replicas to create for this container. Default is 1.
      --requests='': The resource requirement requests for this container.  For example, 'cpu=100m,memory=256Mi'.  Note
that server side components may assign requests depending on the server configuration, such as limit ranges.
      --restart='Always': The restart policy for this Pod.  Legal values [Always, OnFailure, Never].  If set to 'Always'
a deployment is created, if set to 'OnFailure' a job is created, if set to 'Never', a regular pod is created. For the
latter two --replicas must be 1.  Default 'Always', for CronJobs `Never`.
      --rm=false: If true, delete resources created in this command for attached containers.
      --save-config=false: If true, the configuration of current object will be saved in its annotation. Otherwise, the
annotation will be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.
      --schedule='': A schedule in the Cron format the job should be run with.
      --service-generator='service/v2': The name of the generator to use for creating a service.  Only used if --expose
is true
      --service-overrides='': An inline JSON override for the generated service object. If this is non-empty, it is used
to override the generated object. Requires that the object supply a valid apiVersion field.  Only used if --expose is
true.
      --serviceaccount='': Service account to set in the pod spec
  -i, --stdin=false: Keep stdin open on the container(s) in the pod, even if nothing is attached.
      --timeout=0s: The length of time to wait before giving up on a delete, zero means determine a timeout from the
size of the object
  -t, --tty=false: Allocated a TTY for each container in the pod.
      --wait=false: If true, wait for resources to be gone before returning. This waits for finalizers.

Usage:
  kubectl run NAME --image=image [--env="key=value"] [--port=port] [--replicas=replicas] [--dry-run=bool]
[--overrides=inline-json] [--command] -- [COMMAND] [args...] [options]
```

## scale

```bash
[vagrant@node1 ~]$ kubectl scale -h
Set a new size for a Deployment, ReplicaSet, Replication Controller, or StatefulSet. 

Scale also allows users to specify one or more preconditions for the scale action. 

If --current-replicas or --resource-version is specified, it is validated before the scale is attempted, and it is
guaranteed that the precondition holds true when the scale is sent to the server.

Examples:
  # Scale a replicaset named 'foo' to 3.
  kubectl scale --replicas=3 rs/foo
  
  # Scale a resource identified by type and name specified in "foo.yaml" to 3.
  kubectl scale --replicas=3 -f foo.yaml
  
  # If the deployment named mysql's current size is 2, scale mysql to 3.
  kubectl scale --current-replicas=2 --replicas=3 deployment/mysql
  
  # Scale multiple replication controllers.
  kubectl scale --replicas=5 rc/foo rc/bar rc/baz
  
  # Scale statefulset named 'web' to 3.
  kubectl scale --replicas=3 statefulset/web

Options:
      --all=false: Select all resources in the namespace of the specified resource types
      --current-replicas=-1: Precondition for current size. Requires that the current size of the resource match this
value in order to scale.
  -f, --filename=[]: Filename, directory, or URL to files identifying the resource to set a new size
  -o, --output='': Output format. One of:
json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...
See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template
[http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template
[http://kubernetes.io/docs/user-guide/jsonpath].
      --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the
command. If set to true, record the command. If not set, default to updating the existing annotation value only if one
already exists.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
related manifests organized within the same directory.
      --replicas=0: The new desired number of replicas. Required.
      --resource-version='': Precondition for resource version. Requires that the current resource version match this
value in order to scale.
  -l, --selector='': Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2)
      --timeout=0s: The length of time to wait before giving up on a scale operation, zero means don't wait. Any other
values should contain a corresponding time unit (e.g. 1s, 2m, 3h).

Usage:
  kubectl scale [--resource-version=version] [--current-replicas=count] --replicas=COUNT (-f FILENAME | TYPE NAME)
[options]
```

## set

```bash
api-versions   autoscale      config         create         edit           get            patch          replace        set            version        
[vagrant@node1 ~]$ kubectl set -h
Configure application resources 

These commands help you make changes to existing application resources.

Available Commands:
  env            Update environment variables on a pod template
  image          Update image of a pod template
  resources      Update resource requests/limits on objects with pod templates
  selector       Set the selector on a resource
  serviceaccount Update ServiceAccount of a resource
  subject        Update User, Group or ServiceAccount in a RoleBinding/ClusterRoleBinding

Usage:
  kubectl set SUBCOMMAND [options]
```

## taint

```bash
[vagrant@node1 ~]$ kubectl taint -h
Update the taints on one or more nodes. 

  * A taint consists of a key, value, and effect. As an argument here, it is expressed as key=value:effect.  
  * The key must begin with a letter or number, and may contain letters, numbers, hyphens, dots, and underscores, up to
253 characters.  
  * Optionally, the key can begin with a DNS subdomain prefix and a single '/', like example.com/my-app  
  * The value must begin with a letter or number, and may contain letters, numbers, hyphens, dots, and underscores, up
to  63 characters.  
  * The effect must be NoSchedule, PreferNoSchedule or NoExecute.  
  * Currently taint can only apply to node.

Examples:
  # Update node 'foo' with a taint with key 'dedicated' and value 'special-user' and effect 'NoSchedule'.
  # If a taint with that key and effect already exists, its value is replaced as specified.
  kubectl taint nodes foo dedicated=special-user:NoSchedule
  
  # Remove from node 'foo' the taint with key 'dedicated' and effect 'NoSchedule' if one exists.
  kubectl taint nodes foo dedicated:NoSchedule-
  
  # Remove from node 'foo' all the taints with key 'dedicated'
  kubectl taint nodes foo dedicated-
  
  # Add a taint with key 'dedicated' on nodes having label mylabel=X
  kubectl taint node -l myLabel=X  dedicated=foo:PreferNoSchedule

Options:
      --all=false: Select all nodes in the cluster
  -o, --output='': Output format. One of:
json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...
See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template
[http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template
[http://kubernetes.io/docs/user-guide/jsonpath].
      --overwrite=false: If true, allow taints to be overwritten, otherwise reject taint updates that overwrite existing
taints.
  -l, --selector='': Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2)
      --validate=true: If true, use a schema to validate the input before sending it

Usage:
  kubectl taint NODE NAME KEY_1=VAL_1:TAINT_EFFECT_1 ... KEY_N=VAL_N:TAINT_EFFECT_N [options]
```

## top

```bash
[vagrant@node1 ~]$ kubectl top -h
Display Resource (CPU/Memory/Storage) usage. 

The top command allows you to see the resource consumption for nodes or pods. 

This command requires Heapster to be correctly configured and working on the server.

Available Commands:
  node        Display Resource (CPU/Memory/Storage) usage of nodes
  pod         Display Resource (CPU/Memory/Storage) usage of pods

Usage:
  kubectl top [flags] [options]
```

## uncordon

```bash
[vagrant@node1 ~]$ kubectl uncordon -h
Mark node as schedulable.

Examples:
  # Mark node "foo" as schedulable.
  $ kubectl uncordon foo

Options:
      --dry-run=false: If true, only print the object that would be sent, without sending it.
  -l, --selector='': Selector (label query) to filter on

Usage:
  kubectl uncordon NODE [options]
```

## wait

```bash
[vagrant@node1 ~]$ kubectl wait -h
Experimental: Wait for one condition on one or many resources

Options:
      --all-namespaces=false: If present, list the requested object(s) across all namespaces. Namespace in current
context is ignored even if specified with --namespace.
  -f, --filename=[]: identifying the resource.
      --for='': The condition to wait on: [delete|condition=condition-name].
  -o, --output='': Output format. One of:
json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...
See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template
[http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template
[http://kubernetes.io/docs/user-guide/jsonpath].
  -R, --recursive=true: Process the directory used in -f, --filename recursively. Useful when you want to manage related
manifests organized within the same directory.
  -l, --selector='': Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2)
      --timeout=30s: The length of time to wait before giving up.  Zero means check once and don't wait, negative means
wait for a week.

Usage:
  kubectl wait resource.group/name [--for=delete|--for condition=available] [options]
```
