.
├── .github/
│   └── workflows/
│       └── terraform.yml  
├── modules/
│   ├── compute/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── network/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── logging/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── envs/
│   ├── pre-prod/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── backend.tf
├── .gitignore
└── README.md  #