export MSYS_NO_PATHCONV=1

AZURE_CLIENT_ID=390a1281-c64e-4348-bdab-b6cbe92ab46b
AZURE_SUBSCRIPTION_ID=b8e2fd18-3092-457e-a524-b2f3e5659139
AZURE_TENANT_ID=e7c0101c-ae45-42f9-9ef6-857013ad7cd7

# SP_ID=$(az ad sp show --id $AZURE_CLIENT_ID --query id -o tsv)

# az account set --subscription "$AZURE_SUBSCRIPTION_ID"

# az role assignment create --assignee-object-id $SP_ID --assignee-principal-type ServicePrincipal \
#   --role "Contributor" --scope "/subscriptions/$AZURE_SUBSCRIPTION_ID"

# az role assignment create --assignee-object-id $SP_ID --assignee-principal-type ServicePrincipal \
#   --role "Role Based Access Control Administrator" --scope "/subscriptions/$AZURE_SUBSCRIPTION_ID"

# az role assignment create --assignee-object-id $SP_ID --assignee-principal-type ServicePrincipal \
#   --role "Managed Identity Operator" --scope "/subscriptions/$AZURE_SUBSCRIPTION_ID/resourceGroups/rg-readmit-prod"

# ---------------------------------------

# cat > federated-credential.json <<'EOF'
# {
#   "name": "multi-env-mlops-main",
#   "issuer": "https://token.actions.githubusercontent.com",
#   "subject": "repo:amosbangmo@17532278/multi_env_mlops@1451893488:ref:refs/heads/main",
#   "audiences": ["api://AzureADTokenExchange"]
# }
# EOF

# az ad app federated-credential create \
#   --id "$AZURE_CLIENT_ID" \
#   --parameters federated-credential.json

# rm federated-credential.json

# ---------------------------------------

# gh secret set AZURE_CLIENT_ID --env prod --repo amosbangmo/multi_env_mlops --body "$AZURE_CLIENT_ID"
# gh secret set AZURE_TENANT_ID --env prod --repo amosbangmo/multi_env_mlops --body "$AZURE_TENANT_ID"
# gh secret set AZURE_SUBSCRIPTION_ID --env prod --repo amosbangmo/multi_env_mlops --body "$AZURE_SUBSCRIPTION_ID"

# gh secret list --env prod --repo amosbangmo/multi_env_mlops


# python scripts/generate_and_upload_data.py -g rg-readmit-dev -w readmit-dev-131516-ws

# python scripts/generate_and_upload_data.py -g rg-readmit-test -w readmit-test-132208-ws --num-samples 50000


# # 1. Créer un groupe de sécurité Entra ID
# GROUP_ID=$(az ad group create \
#   --display-name "mlops-developers" \
#   --mail-nickname "mlops-developers" \
#   --query id -o tsv)

# # 2. Récupérer l'Object ID de l'utilisateur connecté
# USER_ID=$(az ad signed-in-user show --query id -o tsv)

# # 3. Ajouter l'utilisateur au groupe
# az ad group member add \
#   --group "$GROUP_ID" \
#   --member-id "$USER_ID"

# # 4. Vérifier les membres
# az ad group member list \
#   --group "$GROUP_ID" \
#   --query "[].{Name:displayName, ID:id}" \
#   -o table

# GROUP_ID=$(az ad group show --group "mlops-developers" --query id -o tsv)

# # Repeat for each environment's storage account (readmitdevst, readmittestst, readmitprodst)
# STORAGE_ID=$(az storage account show --name readmitprodsts3x7cz --resource-group rg-readmit-prod --query id -o tsv)

# az role assignment create --assignee-object-id $GROUP_ID --assignee-principal-type Group \
#   --role "Storage Blob Data Contributor" --scope $STORAGE_ID

# az role assignment create --assignee-object-id $GROUP_ID --assignee-principal-type Group \
#   --role "Storage File Data Privileged Contributor" --scope $STORAGE_ID

# # Workspace — AzureML Data Scientist
# WS_ID=$(az ml workspace show --name readmit-prod-132800-ws --resource-group rg-readmit-prod --query id -o tsv)
# az role assignment create --assignee-object-id $GROUP_ID --assignee-principal-type Group \
#   --role "AzureML Data Scientist" --scope $WS_ID

# # Key Vault — Secrets User (required for Studio)
# KV_ID=$(az keyvault show --name readmit-prod-kv-4 --resource-group rg-readmit-prod --query id -o tsv)
# az role assignment create --assignee-object-id $GROUP_ID --assignee-principal-type Group \
#   --role "Key Vault Secrets User" --scope $KV_ID

# az ml component list --registry-name readmit-registry -o table

# az ml environment list --registry-name readmit-registry -o table


az ml online-endpoint list \
  -g rg-readmit-test \
  -w readmit-test-132208-ws \
  -o table
