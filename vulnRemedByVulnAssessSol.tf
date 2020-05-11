provider "azurerm" {
  features {}
}

resource "azurerm_policy_definition" "policy" {
  name         = "VulRemedByVulnAssessSol"
  policy_type  = "BuiltIn"
  mode         = "All"
  display_name = "Vulnerabilities should be remediated by a Vulnerability Assessment solution"

  metadata = <<METADATA
    {
    "category": "Security Center"
    }

METADATA


  policy_rule = <<POLICY_RULE
    {
    "if": {
      
        "field": "type",
        "in": "[
            "Microsoft.Compute/virtualMachines",
          "Microsoft.ClassicCompute/virtualMachines"]"
      }
    },
    "then": {
      "effect": "[parameters('effect')]",
      "details": {
          "type": "Microsoft.Security/complianceResults",
          "name": "vulnerabilityAssessment",
          "existenceCondition": {
            "field": "Microsoft.Security/complianceResults/resourceStatus",
            "in": [
              "OffByPolicy",
              "Healthy"
            ]
        } 
    }
  }
POLICY_RULE



  parameters = <<PARAMETERS
    {
    "effect": {
      "type": "String",
      "metadata": {
        "description": "Enable or disable the execution of this policy",
        "displayName": "Effect"
        },
        "allowedValues" : [
            "AuditIfNotExists",
            "Disabled"
        ],
    }
  }
PARAMETERS

}