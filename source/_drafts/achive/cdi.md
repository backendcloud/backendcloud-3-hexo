---
title: cdi
readmore: true
date: 2022-05-08 07:32:17
categories:
tags:
---

# Purpose
This project is designed with Kubevirt in mind and provides a declarative method for importing VM images into a Kuberenetes cluster. Kubevirt detects when the VM image copy is complete and, using the same PVC that triggered the import process, creates the VM.

This approach supports two main use-cases:

a cluster administrator can build an abstract registry of immutable images (referred to as "Golden Images") which can be cloned and later consumed by Kubevirt, or
an ad-hoc user (granted access) can import a VM image into their own namespace and feed this image directly to Kubevirt, bypassing the cloning step.

# Event Sequence
The admin creates the CDI Deployment in the target namespace to initialize the CDI controller. The Deployment launches the controller within this namespace and ensures only one instance of the controller is always running. This controller watches for PVCs containing special annotations that define the source file's endpoint URI and secret name (if credentials are needed to access the endpoint).

(Optional) If the source repo requires authentication credentials to access the source endpoint, then the admin can create one or more secrets in the "golden" namespace, which contain the credentials in base64 encoding.

The admin creates the "golden" PVC in the "golden" namespace. This PVC requires dynamic provisioning and should either specify the desired Storage Class or omit the feild entirely (to signal the "default" Storage Class). These PVCs, with annotations defined below, signal the controller to launch the ephemeral importer pod.

When a PVC is created, the dynamic provisioner referenced by the Storage Class will create a Persistent Volume representing the actual storage volume.

(Parallel to 4) The dynamic provisioner creates the backing storage volume.

NOTE: for VM images there is a one-to-one mapping of a volume to a single image. Thus, each PVC represents a single VM image.

The ephemeral Importer Pod, created by the controller, binds the Secret and mounts the backing storage volume via the Persistent Volume Claim.

The Importer Pod streams the file from the remote data store to the mounted backing storage volume and performs unarchiving, decompression and qcow2-to-raw conversion (see supported formats). When the copy completes, the importer pod terminates. The destination file name is always disk.img (a kubevirt requirement) but, since there is one image per volume, naming collisions are not a concern.

# Components
CDI Deployment: Kubernetes Deployment that manages a single CDI controller within the namespace of the Deployment.

CDI Controller: Long-lived Controller pod. The controller scans PVCs within its namespace by looking for specific annotations. On detecting a new PVC with the endpoint annotation, the controller creates Data Import Pod. The controller cleans up the data import pod on completion.

Data Import Pod: Short-lived pod in "golden" namespace. The pod is created by the controller and consumes the secret (if any) and the endpoint annotated in the PVC. It streams a single file referenced in the endpoint annotation to the storage volume. In all cases the target file name is disk.img.

Dynamic Provisioner: Existing storage provisoner(s) which create the Golden Persistent Volume that reference an empty cluster storage volume. Creation begins automatically when the Golden PVC is created by an admin.

Endpoint Secret: Long-lived secret in "golden" namespace that is defined and created by the admin. The Secret must contain the access key id and secret key required to make requests from the object store. The Secret is mounted by the Data Import pod.

"Golden" Namespace: Restricted/private Namespace for Golden PVCs and endpoint Secrets. Also the namespace where the CDI Controller and CDI Importer pods run.

Golden PV: Long-lived Persistent Volume created by the Dynamic Provisioner and written to by the Data Import Pod. References the Golden Image volume in storage.

Golden PVC: Long-lived Persistent Volume Claim manually created by an admin in the "golden" namespace. Linked to the Dynamic Provisioner via a reference to the storage class and automatically bound to a dynamically created Golden PV. The "default" provisioner and storage class is used in the example; however, the importer pod supports any dynamic provisioner which supports mountable volumes.

* cdi.kubevirt.io/storage.import.endpoint: Defined by the admin: the full endpoint URI for the source file/image
* cdi.kubevirt.io/storage.import.secretName: Defined by the admin: the name of the existing Secret containing the credential to access the endpoint.
* cdi.kubevirt.io/storage.import.status: Added by the controller: the current status of the PVC with respect to the import/copy process. Values include: ”In process”, “Success”, “ Failed”

Object Store: Arbitrary url-based storage location. Currently we support http and S3 protocols.

Storage Class: Long-lived, default Storage Class which links Persistent Volume Claims to the desired Dynamic Provisioner(s). Referenced by the golden PVC. The example makes use of the "default" provisioner; however, any provisioner that manages mountable volumes is compatible.