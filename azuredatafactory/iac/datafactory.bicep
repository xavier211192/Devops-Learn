param location string = resourceGroup().location
@description('The name of the environment. This must be devlopment, test, uat or production')
@allowed([
  'development'
  'test'
  'uat'
  'production'
])
param environment string = 'development'
//adf name must be globally unique
param dataFactoryName string = '${environment}-datafactory-${uniqueString(resourceGroup().id)}'
//Repo config
param repositoryType string = ''
param projectName string  = 'MicrosoftLearn'
param repositoryName string = 'Devops-Learn'
param accountName string = 'xavier211192'
param collaborationBranch string = 'develop'
param rootFolder string = '/azuredatafactory/src'
param hostName string = ''

var _repositoryType = (repositoryType == 'AzureDevOps') ? 'FactoryVSTSConfiguration' : 'FactoryGitHubConfiguration'

var azDevopsRepoConfiguration = {
  accountName: accountName
  repositoryName: repositoryName
  collaborationBranch: collaborationBranch
  rootFolder: rootFolder  
  type: _repositoryType
  projectName: projectName
}

var gitHubRepoConfiguration = {
  accountName: accountName
  repositoryName: repositoryName
  collaborationBranch: collaborationBranch
  rootFolder: rootFolder  
  type: _repositoryType
}


resource dataFactoryName_resource 'Microsoft.DataFactory/factories@2018-06-01' =  {
  name: dataFactoryName
  location: location
  properties: {
    repoConfiguration:(environment=='development') ? (repositoryType=='AzureDevOps') ? azDevopsRepoConfiguration : gitHubRepoConfiguration : {}
  }
}
//To Deploy 
//az login
//az deployment group create -f .<your file>.bicep -g <your resource group>
