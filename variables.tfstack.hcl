# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "regions" {
  type = set(string)
}

variable "env" {
  type = string
}

variable "identity_token" {
  type      = string
  ephemeral = true
}

variable "role_arn" {
  type = string
}

variable "default_tags" {
  description = "A map of default tags to apply to all AWS resources"
  type        = map(string)
  default     = {}
}

variable "removed_regions" {
    type = set(string)
}