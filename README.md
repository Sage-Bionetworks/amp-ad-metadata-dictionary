# AMP-AD Metadata Dictionary

Hosts the dictionary used for metadata in AMP-AD, which is a ReacTable object that displays the production [ADKP data model](https://github.com/adknowledgeportal/data-models/blob/main/AD.model.csv). 

The dictionary app displays all attributes used as manifest columns, and all valid values for those columns. It does not display manifest attributes (where Parent = 'ManifestTemplate'). 

As of August 2024, this app no longer interacts with Synapse since it is pulling from the ADKP data model used for schematic and DCA. The recitulate and synapsclient dependencies have been removed.

It may take a few minutes (five-ish?) and a browser refresh for changes merged into the AD.model.csv file on the main akdp data model repo branch to appear in the app, but they should display without needing to redeploy the app. 

### To deploy to ShinyApps.io:

The shinyapps.io deployment workflow is `deploy-shinyapps-io.yaml`. 
- This uses repository secrets to deploy the app to ShinyApps.io via rsconnect: `RSCONNECT_USER`, `RSCONNECT_TOKEN`, and `RSCONNECT_SECRET`. Values for these are saved in Sage's LastPass.
- This workflow runs when a PR is approved and merged into, OR via manual workflow dispatch
- Upon completion of the workflow, the app will deploy to staging.
Check out the app here: https://sagebio.shinyapps.io/amp-ad-metadata-dictionary-staging.
- After verifying correctness on `main`, create pull request with at least one reviewer to `prod` branch
- Upon merge of pull request, the app will deploy to production.
- The production app will become available at https://sagebio.shinyapps.io/amp-ad-metadata-dictionary
- This app is embedded as an iframe on the Synapse wiki here: https://www.synapse.org/Synapse:syn25878249

### To deploy to Github Pages via shinylive:

The shinylive deployment workflow is `deploy-shinylive.yaml`. 
- This uses the `shinylive` package to build a static site that is run entirely in the browser (https://posit-dev.github.io/r-shinylive/), and deploy that site to Github pages
- This workflow runs on a push to `main` or via workflow dispatch
- ⚠️ right now this site loads very, very slowly. The static site will not replace the shinyapps.io deployment as our user-facing version unless we can figure out how to speed it up.  
