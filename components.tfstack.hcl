# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

component "s3" {
  for_each = var.regions

  source = "./s3"

  inputs = {
    region = each.value
    environment = var.env
  }

  providers = {
    aws    = provider.aws.configurations[each.value]
    random  = provider.random.this
  }
}

component "lambda" {
  for_each = var.regions

  source = "./lambda"

  inputs = {
    region    = var.regions
    bucket_id = component.s3[each.value].bucket_id
  }

  providers = {
    aws     = provider.aws.configurations[each.value]
    archive = provider.archive.this
    local   = provider.local.this
    random  = provider.random.this
  }
}

component "api_gateway" {
  for_each = var.regions

  source = "./api-gateway"

  inputs = {
    region               = each.value
    lambda_function_name = component.lambda[each.value].function_name
    lambda_invoke_arn    = component.lambda[each.value].invoke_arn
  }

  providers = {
    aws    = provider.aws.configurations[each.value]
    random = provider.random.this
  }
}

removed {
    source = "./s3"
    for_each = var.removed_regions

    from = component.s3_buckets[each.value]
    providers = {
        aws = provider.aws.config[each.value]
        random = provider.random.this
    }
}


removed {
    source = "./lambda"
    for_each = var.removed_regions

    from = component.lambda[each.value]
    providers = {
        aws = provider.aws.config[each.value]
        archive = provider.archive.this
        local   = provider.local.this
        random  = provider.random.this
    }
}

removed {
    source = "./api-gateway"
    for_each = var.removed_regions

    from = component.api_gateway[each.value]
    providers = {
        aws = provider.aws.config[each.value]
        random  = provider.random.this
    }
}