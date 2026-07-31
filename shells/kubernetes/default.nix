# shells/kubernetes/default.nix
# =============================
#
# Copying
# -------
#
# Copyright (c) 2026 universe/config authors and contributors.
#
# This file is part of the *universe/config* project.
#
# *universe/config* is a free software project. You can redistribute it
# and/or modify it following the terms of the MIT License.
#
# This software project is distributed *as is*, WITHOUT WARRANTY OF ANY KIND;
# including but not limited to the WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE and NONINFRINGEMENT.
#
# You should have received a copy of the MIT License along with
# *universe/config*. If not, see <http://opensource.org/licenses/MIT>.
#
{
  # Flake's library as well as the libraries available from the flake's
  # inputs.
  lib,
  # Flake's inputs.
  inputs,
  # The namespace of the flake. See `snowfall.namespace`.
  namespace,
  # An instance of `pkgs` with the overlays and other packages.
  pkgs,
  mkShell,
  ...
}: let
  shell = builtins.baseNameOf (builtins.getEnv "SHELL");
  fastfetch_cfg = pkgs.writeText "fastfetch.jsonc" (
    lib.universe.shells.mkFastFetchConfig
    "A shell environment to manage Kubernetes clusters."
    [
      # Core CLI
      {
        name = "  Core CLI";
        description = "";
      }
      {
        name = "kubectl";
        description = "Kubernetes command-line tool.";
      }
      {
        name = "k9s";
        description = "Kubernetes CLI to manage your clusters in style.";
      }
      {
        name = "kubectx";
        description = "Switch faster between clusters and namespaces.";
      }
      {
        name = "stern";
        description = "Multi pod and container log tailing.";
      }
      # Package & Config Management
      {
        name = "  Package & Config Management";
        description = "";
      }
      {
        name = "kubernetes-helm";
        description = "The Kubernetes Package Manager.";
      }
      {
        name = "kustomize";
        description = "Customization of kubernetes YAML configurations.";
      }
      # GitOps
      {
        name = "  GitOps";
        description = "";
      }
      {
        name = "argocd";
        description = "Declarative GitOps continuous delivery tool.";
      }
      {
        name = "fluxcd";
        description = "Open and extensible continuous delivery solution.";
      }
      # OpenShift Ecosystem
      {
        name = "  OpenShift Ecosystem";
        description = "";
      }
      {
        name = "butane";
        description = "Translates Butane Configs into Ignition Configs.";
      }
      {
        name = "odo";
        description = "Developer-focused CLI for OpenShift and Kubernetes.";
      }
      {
        name = "openshift";
        description = "OpenShift CLI (oc).";
      }
      # Secrets & Virtualization
      {
        name = "  Secrets & Virtualization";
        description = "";
      }
      {
        name = "kubeseal";
        description = "Tool for one-way encrypted Secrets.";
      }
      {
        name = "kubevirt";
        description = "Virtual Machine Management on Kubernetes.";
      }
      # Provisioning
      {
        name = "  Provisioning";
        description = "";
      }
      {
        name = "clusterctl";
        description = "The Cluster API command line tool.";
      }
      {
        name = "eksctl";
        description = "The official CLI for Amazon EKS.";
      }
      # Linters & Validation
      {
        name = "  Linters & Validation";
        description = "";
      }
      {
        name = "checkov";
        description = "Static code analysis tool for IaC.";
      }
      {
        name = "conftest";
        description = "Write tests against structured config data.";
      }
      {
        name = "kics";
        description = "Keeping Infrastructure as Code Secure.";
      }
      {
        name = "kube-bench";
        description = "CIS Kubernetes Benchmark checker.";
      }
      {
        name = "kube-score";
        description = "Kubernetes object analysis and recommendations.";
      }
      {
        name = "kubeconform";
        description = "A FAST Kubernetes manifests validator.";
      }
      {
        name = "tflint";
        description = "A Pluggable Terraform Linter.";
      }
      {
        name = "yamllint";
        description = "A linter for YAML files.";
      }
      # Local Clusters
      {
        name = "  Local Clusters";
        description = "";
      }
      {
        name = "k3s";
        description = "Lightweight Kubernetes distribution.";
      }
      {
        name = "kind";
        description = "Kubernetes IN Docker - local clusters.";
      }
      {
        name = "minikube";
        description = "Local Kubernetes engine.";
      }
    ]
  );
in
  mkShell {
    packages = with pkgs;
      [
        # Core CLI
        kubectl
        k9s
        kubectx
        stern

        # Package & Config Management
        kubernetes-helm
        kustomize

        # GitOps
        argocd
        fluxcd

        # OpenShift Ecosystem
        butane
        odo
        openshift

        # Secrets & Virtualization
        kubeseal
        kubevirt

        # Provisioning
        clusterctl
        eksctl

        # Linters & Validation
        checkov
        conftest
        kics
        kube-bench
        kube-score
        kubeconform
        tflint
        yamllint

        # Local Clusters
        kind
        minikube

        # Misc
        fastfetch
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        k3s
      ]
      ++ (lib.optional (shell != "") pkgs.${shell});

    name = "kubernetes";
    shellHook = ''
      fastfetch --config "${fastfetch_cfg}"

      export PS1="[''${name}]$ "
      if [ "${shell}" ]
      then
        export SHELL="$(which ${shell})"
        exec ''${SHELL}
      fi
    '';
  }
