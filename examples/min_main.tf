module "network" {
  source = "registry.terraform.io/telekom-mms/network/azurerm"
  virtual_network = {
    vn-app-mms = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
      address_space       = ["173.0.0.0/23"]
    }
  }
}

module "dns" {
  source = "registry.terraform.io/telekom-mms/dns/azurerm"
  dns_zone = {
    "mms-github-plattform.com" = {
      resource_group_name = "rg-mms-github"
    }
  }
  private_dns_zone = {
    "mms-github-privat-plattform.com" = {
      resource_group_name = "rg-mms-github"
    }
  }
  dns_a_record = {
    "@" = {
      resource_group_name = module.dns.dns_zone["mms-github-plattform.com"].resource_group_name
      zone_name           = module.dns.dns_zone["mms-github-plattform.com"].name
      records             = ["127.0.0.2"]
    }
  }
  dns_cname_record = {
    www = {
      resource_group_name = module.dns.dns_zone["mms-github-plattform.com"].resource_group_name
      zone_name           = module.dns.dns_zone["mms-github-plattform.com"].name
      record              = module.dns.dns_a_record["@"].fqdn
    }
  }
  dns_txt_record = {
    dnsauth = {
      resource_group_name = module.dns.dns_zone["mms-github-plattform.com"].resource_group_name
      zone_name           = module.dns.dns_zone["mms-github-plattform.com"].name
      record = {
        frontdoor = {
          value = "frontdoor"
        }
      }
    }
  }
  dns_mx_record = {
    mail = {
      resource_group_name = module.dns.dns_zone["mms-github-plattform.com"].resource_group_name
      zone_name           = module.dns.dns_zone["mms-github-plattform.com"].name
      record = {
        mail1 = {
          preference = 10
          exchange   = "mail1.telekom-mms.com"
        }
      }
    }
  }
  private_dns_a_record = {
    "@" = {
      resource_group_name = module.dns.private_dns_zone["mms-github-privat-plattform.com"].resource_group_name
      zone_name           = module.dns.private_dns_zone["mms-github-privat-plattform.com"].name
      records             = ["127.0.0.3"]
    }
  }
  private_dns_cname_record = {
    www = {
      resource_group_name = module.dns.private_dns_zone["mms-github-privat-plattform.com"].resource_group_name
      zone_name           = module.dns.private_dns_zone["mms-github-privat-plattform.com"].name
      record              = module.dns.private_dns_a_record["@"].fqdn
    }
  }
  private_dns_txt_record = {
    dnsauth = {
      resource_group_name = module.dns.private_dns_zone["mms-github-privat-plattform.com"].resource_group_name
      zone_name           = module.dns.private_dns_zone["mms-github-privat-plattform.com"].name
      record = {
        frontdoor = {
          value = "frontdoor"
        }
      }
    }
  }
  private_dns_mx_record = {
    mail = {
      resource_group_name = module.dns.private_dns_zone["mms-github-privat-plattform.com"].resource_group_name
      zone_name           = module.dns.private_dns_zone["mms-github-privat-plattform.com"].name
      record = {
        mail1 = {
          preference = 10
          exchange   = "mail1.telekom-mms.com"
        }
      }
    }
  }
  private_dns_zone_virtual_network_link = {
    pl-mms-github = {
      resource_group_name   = "rg-mms-github"
      private_dns_zone_name = module.dns.private_dns_zone["mms-github-privat-plattform.com"].name
      virtual_network_id    = module.network.virtual_network["vn-app-mms"].id
    }
  }
}
