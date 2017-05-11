Memcached with Prometheus Exporter for Kubernetes
=================================================

This project shows how to run a memcached in your Kubernetes cluster. Memcached is stateless, so it is pleasure to run it in K8S.

Our task is to create N memcaches instances, each of them needs to have its own kubernetes service and deployment. We cannot hide the memcache behind one service, because a memcached client has to know all the instances for fail-over and load-balancing.

Features:

- Generate k8s configuration files for memcached shreds
- Memcached metrics exposed with a prometheus exporter

The opinionated parts:

- Use Makefile,
- Wrap kuberctl commands with Makefile tasks to enforce guards,
- A guard that checks whether the intendent TARGET_ENV matches a kubernetes cluster, you are logged in,
- Use separate kubernetes clusters with postfix: developmnet, staging, production (see *guard_right_env* in Makefile).


Howto
-----

1. Generate kubernetes config files for your environment (in tmp/$TARGET_ENV directory):

   ::

     NUM_SHRED=2 TARGET_ENV=staging make kubernetes_generate_yml

2. Create services:

   ::

     TARGET_ENV=staging make apply_service

3. Create deployment:

   ::

     TARGET_ENV=staging make apply_service
