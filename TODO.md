
## TODO ##
- Call Cartier to order parts
  - glasses model: CT0058O - 003
    - hinges: left and right
    - screws:
      for hinges to lens, 1 pair
      for bridges to lens, 1 pair
- How to create client_id/secret for the local test environment



test@troopswap.com
YWQ3AfY8zc



## Query Consumer and their Client IDs / Oauth IDs
### Python to generate the SQL array
- lines = """ABC DEF GHI JKL"""
- names = [f"'%{x}%'".lower() for x in lines.split("\n") if x]; names.sort(); print(",".join(names))

### Run the following SQL in Metabase against Core(AllyDB)
SELECT name, oauth_id
FROM consumers
WHERE LOWER(name) LIKE ANY (ARRAY[
  'aldo shoes%','brilliant earth%','bushnell golf%','firehouse subs%','forever 21%','getaway%','lee%','lenscrafters%','lucky brand%','nautica%','philly zoo%','ray-ban%','red rock military%','swanson vitamins%','toms shoes%','untuckit%'
])
ORDER BY LOWER(name);



## Query GraphQL
query MyQuery {
  addressLiteralReadables(
    condition: {
      attrib: "6249"
    }
  ) {
    edges {
      node {
        attrib
        number
        street
        street2
        municipality
        subdivision
        postalCode
        country
        readable
      }
    }
  }
  addressLiterals(
    condition: {
      attrib: "6249"
    }
  ) {
    edges {
      node {
        street
        street2
        municipality
        subdivision
        postalCode
        country
        fullText
        uuid
      }
    }
  }
}


## Verify and decompile a java class
jar tf commerce-merchants/target/commerce-merchants-0.0.1-SNAPSHOT.jar | grep Merchant.class
javap -classpath commerce-merchants/target/commerce-merchants-0.0.1-SNAPSHOT.jar me.id.merchants.model.Merchant | sed -n '1,120p'

jar tf merchants/target/merchants-1.0.0-SNAPSHOT-model.jar | grep Merchant.class
javap -classpath merchants/target/merchants-1.0.0-SNAPSHOT-model.jar me.id.merchants.model.Merchant | sed -n '1,120p'

jar tf merchants/target/merchants-1.0.0-SNAPSHOT-server-stubs.jar
javap -classpath merchants/target/merchants-1.0.0-SNAPSHOT-server-stubs.jar me.id.merchants.service.api.MerchantsApiSpudController

jar tf authenticators/target/authenticators-1.0.0-SNAPSHOT-model.jar  | grep CreatePasswordAuthenticatorRequest.class
javap -classpath authenticators/target/authenticators-1.0.0-SNAPSHOT-model.jar me.id.authenticators.model.CreatePasswordAuthenticatorRequest



## oAuth (Open Authorization) and oIDC (OpenID Connect)
- Links
  - https://www.youtube.com/watch?v=t18YB3xDfXI
  - https://www.youtube.com/watch?v=q3FiuTZlroE
- oAuth 2.0
  - client type
    - single page application: an application without backend server.
      - such as single page web application, or mobile app without backend
      - they can't store the client secret, only the client id is issued
  - token instrospection
    - how the resource server verifies the access token with authorization
      server.
  - parties:
    - resource owner or user
    - client or application
    - authorization server, where resource owner has an account
    - resource server, where client wants to use on behalf of the resoure owner
  - grant type:
    - authorization code grant
    - client credential grant
    - implicit grant (MUST NOT USE)
    - resource owner password grant (MUST NOT USE)
    - device authorization
  - catches:
    - the authorization server may not be the same as resource server
      the authorization server may be someone the resource server trusts
    - the redirect url: the callback url is where the authorization server
      redirects the client
      with the authorization code. It's usually an API of client
      from the authorization server
    - the response type is what the client expects to receive during the
      callback from authorization server
    - the scope is the granular permissions the client wants to access with
      the resource server.
    - the consent: the authorization server takes the scope the client requests
      and verifies with the resource owner whether or not they want to give
      the client permission.
    - the client id: the id to identify the client with the authorization server
    - the client secret: the secret password only the client and authorization
      server know
    - authorization code: a short-lived temporarily code the authorization
      server sends back to the client through callback. the client will send
      the authorization code, along with its client id and client secret in
      exchange for an access token
    - access token: the key the client will use from that point forwat to
      communicate with the resource server, which gives the client the permission to request data or perform actions on the resource server
      on behalf of the resource owner
  - diagram
    - the resource owner wants the client to access the owner's resources
      in resource server.
    - the resource owner opens a web browser which indicates the intention
      to grant the client to access its resource on resource server
    - the client redirects the browser to the authorization server,
      includes the request the client id, redirect url, response type,
      and one or more scopes it needs
    - the authorization server verifies the resource owner, and if necessary
      prompts for a login
    - the authorization server then presents the resource owner a consent
      form baesd on the scopes requesed by the client. The resource owner
      has the ability to deny or grant permission
    - the authorization server redirects to the client using the redirect
      url along with a temporary authorization code
    - the client then contacts the authorization server directly. It does not
      use resource owner's browser, and securely sends its client id, client
      secret and the authorization code
    - the authorization server verifies the data and response with an access
      token. the client can use the access token to send requests to the
      resource server.
    - the client and the authorization server need to establish a working
      relationshop. the authorization generated a cient id and client secret
      and gave them to the client to use for all future oAuth exchanges.



## SPUD & API Service ##

- Java: almost ready except some helping tools, ETA: Jun/July
- Ruby: Jun/July

```
Browser --> BrExt     -----------------\
Shop Browser ------------> WebServer --> Marketplace API Server --> DB/GrapphQL/...
3rd Party             -----------------/
```

- dockersize the new API service
- debug with the docker
- Pros & Cons for each solution
  - Level of effort to complish each
  - Architecture diagram
- initial APIs
  - feature flags
  - tracking


- introduction
- system diagram / design / docs
  - https://docs.google.com/presentation/d/1D1MuSP4iZKZ82NXYSA1kcB47awdFv1QwlulIeMAr0C0/edit?slide=id.g21fde0d8a82_0_26#slide=id.g21fde0d8a82_0_26
  - what if the network_id mismatched between store + offer? https://docs.google.com/presentation/d/1D1MuSP4iZKZ82NXYSA1kcB47awdFv1QwlulIeMAr0C0/edit?slide=id.g220cd5493d0_0_93#slide=id.g220cd5493d0_0_93
- local setup for running, debugging the marketplace service locally
  - follow the README for local setup
- remote debugging to staging/production
  - staging only
  - production -
- monitoring etc (sentry / honeycomb)



## Marketplace Deployment

**Checklist**
- See [Running a Marketplace Deployment](https://idmeinc.atlassian.net/wiki/spaces/EN/pages/3067576335/Running+a+Marketplace+Deployment)
- Create and publish [a release tag, such as 9.200.0](https://github.com/IDme/idme-marketplace/releases/tag/9.200.0)
- Duplidate and create [a new release checklist, such as shop 9.200.0](https://docs.google.com/spreadsheets/d/12sMpDpz8DZ6XSqQ8IzZYMZa9eLVYRMcaxqloajfAK94/edit?gid=1500403791#gid=1500403791)
  - uncheck necessary cells
  - update the release notes
  - publish the release notes to the following slack channels for preparing
    - [marketplaces-eng-leads](https://idme.enterprise.slack.com/archives/C050ZN3K3AR)
    - [xfn-engineering-releases](https://idme.enterprise.slack.com/archives/C08F2RWF0NR)

**Deploy to staging to verify and run e2e tests**
- visit harness
- Switch project from "Platform" to "Marketplace" at left hand side
- Select "Execution" in left hand side
- Find the most success one by filter Service=shop and Environment=mrkt-prod/mrkt-nonprod
- Click a "Nomad Deploy" entry
  - Click the "Re-run" button on up left and select "Pipeline" to rerun
    - The image_tag should be the PR name or the tag (such as 9.200.0 without v)
      - The docker image in artifacts, such as [shop 9.200.0](https://packages.idme.co/ui/repos/tree/Properties/containers-idme/idme/shop/9.200.0)
    - Fill in NOMAD_JOB_REF the ticket number (such as MAR-3849) if any
    - Make sure that the "Select Service" is Project "shop"
    - Make sure that the "Environment" is "mrkt-prod" or "mrkt-nonprod"
    - Make sure that the "Specify Infrastructure" is "mrkt-nonprod-staging" or "mrkt-prod-prod"
    - Click "Re-run pipeline" to start the deployment
    - See [the following execution for reference](https://app.harness.io/ng/account/0J5OMwyEQ1Gjs91VARtemA/module/cd/orgs/engineering/projects/marketplace/pipelines/Nomad_Deploy/deployments/o79dqPJzQAmLa7ijpvx8nA/inputs?storeType=INLINE)
  - The "Nomad Periodic Jobs" needs to be deployed as well
  - The  "Nomad Batch Docker" is used to run scripts against staging for upgrade etc
- Login to Nomad to monitor the deployment
  - [Fetch Nomad access token here](https://idmeinc.atlassian.net/wiki/spaces/EN/pages/2681307450/Nomad+Access+Token+Generation#Staging-Access)
  - Nomad Staging
    - [Fetch Nomad staging secret from vault](https://idmeinc.atlassian.net/wiki/spaces/EN/pages/2681307450/Nomad+Access+Token+Generation#Staging-Access)
    - [Enter secret in Nomad staging](https://nomad.mrkt.nonprod.platform.idme.co)
    - [Check Shop on Nomad staging](https://nomad.mrkt.nonprod.platform.idme.co/ui/jobs/shop@staging)
  - Nomad Prod
    - [Fetch Nomad prod secret from vault](https://idmeinc.atlassian.net/wiki/spaces/EN/pages/2681307450/Nomad+Access+Token+Generation#Production-Access)
    - [Enter secret in Nomad Prod](https://nomad.mrkt.prod.platform.idme.co/)
    - [Check shop on Nomad prod](https://nomad.mrkt.prod.platform.idme.co/ui/jobs/shop@prod)
**Run the E2E tests for marketplace**
- Start [marketplace e2e tests](https://github.com/IDme/idme-test-automation/actions/workflows/run_playwright_marketplace_tests_chromium.yml)


Deploy to platform/nginx:
  - run from [an existing pipeline](https://app.harness.io/ng/account/0J5OMwyEQ1Gjs91VARtemA/module/cd/orgs/engineering/projects/platform/pipelines/Nomad_Deploy/pipeline-studio/?storeType=INLINE)
  - Here is an example execution [the pipeline from an execution](https://app.harness.io/ng/account/0J5OMwyEQ1Gjs91VARtemA/module/cd/orgs/engineering/projects/platform/pipelines/Nomad_Deploy/deployments/FYdukg_JQpiIdCvANeriuw/pipeline?storeType=INLINE). Try re-run button to see the configuration and update the configuration for a new pipeline.

**deployment procedure**
  - use harness to deploy
  - use nomad for monitor the deployment
  - request access to harness + nomad and nomad console access (staging only)
  - publish the deployment/release to the following channel
    - [marketplaces-eng-leads](https://idme.enterprise.slack.com/archives/C050ZN3K3AR)
    - [xfn-engineering-releases](https://idme.enterprise.slack.com/archives/C08F2RWF0NR)
    - [xfn-communities-marketplaces](https://idme.enterprise.slack.com/archives/C040BP1F62J)
    - [eng-deployments-prod]



## Debugging on staging
**create nomad tokens**
- Wiki: https://idmeinc.atlassian.net/wiki/spaces/PLT/pages/2679406639/How+to+Log+Into+Nomad
- Login to Vault: https://vault.mrkt.nonprod.platform.idme.co/ui/vault/secrets?namespace=mrkt%2Fplatform
- open console and run command:
  - read nomad/creds/staging-readonly
  - read nomad/creds/staging-operator

**run all shop locally**
- Make sure docker is closed, as docker uses elastic search or database port
- Check the ports in use, which app PID uses the port, and the app of the PID
```BASH
docker exec -it idme-marketplace-shop.idme.test-1 bash

gem install bundler -v 2.5.11

# stop the docker or local elastic search running at port 9200
netstat -an | grep LISTEN
lsof -i :9200
ps -ef | grep 67197
elasticsearch

# run the sidekiq with local redis
export REDIS_URL=localhost:9200
sidekiq

```
- Start the `elasticsearch` and check `http://es.shop.idme.test:9200/stores`
- Start the `sidekiq` and check `http://shop.idme.test/sidekiq/retries` with idme@sidekiq

**setup the shop tests**
```BASH
~/.pyenv/shims/python -m venv .venv
source .venv/bin/activate

uv lock --upgrade-package idme-tdk --native-tls
uv pip install --requirements pyproject.toml --native-tls
pip install playwright
python -m playwright install --with-deps


```

**run shop test**
```BASH
pytest modules/pw_tests/src/pw_tests/tests/mar/shop/test_cash_back_offer.py::test_cash_back_offer_percentage --qase-testops-api-token="your_token" --qase-testops-project=IDW --headed

more ~/Desktop/1.txt | grep FAILED | awk -F '::' '{ print $1 }' | cut -c8- | xargs -n 1 -I {} pytest {} --qase-testops-api-token="your_token" --qase-testops-project=MAR --headed

more ~/Desktop/1.txt | grep FAILED | cut -d ' ' -f2 | xargs -n 1 -I {} pytest {} --qase-testops-api-token="your_token" --qase-testops-project=MAR --headed

more ~/Desktop/1.txt | grep "^FAILED" | cut -d ' ' -f2 | sort
more ~/Desktop/1.txt | grep modules/pw_tests | xargs -n 1 -I {} pytest {} --qase-testops-api-token="your_token" --qase-testops-project=MAR --headed

pytest -n 16 modules/pw_tests/src/pw_tests/tests/mar/     -m '(homepage or shop)' -s  --test-env=staging  --video=retain-on-failure  --screenshot=only-on-failure  --junit-xml=test-results/report.xml  --alluredir=allure-results --qase-testops-api-token=*** --qase-testops-project=MAR --qase-testops-batch-size=1 --qase-debug=true --qase-testops-run-title="$RUN_TITLE"

pytest -n 4 \
    modules/pw_tests/src/pw_tests/tests/ \
    -m "(homepage or shop)" \
    -s  \
    --test-env=staging \
    --video=retain-on-failure \
    --screenshot=only-on-failure \
    --junit-xml=test-results/report.xml \
    --alluredir=allure-results \
    --qase-testops-api-token=*** \
    --qase-testops-project=MAR \
    --qase-testops-batch-size=1 \
    --qase-debug=true \
    --qase-testops-run-title="${RUN_TITLE}"

```

**Clean the test environment for E2E**
```BASH
OfferVariant.where("offer_id > ?", 50).delete_all
PopularOffer.where("offer_id > ?", 50).delete_all
Offer.where("id > ?", 50).delete_all
Store.where("id > ?", 50).delete_all
```


## Login Credentials

LAPTOP: qingxiang.liu / abcd
gmail: qingxiang.liu@id.me / abcd
okta: qingxiang.liu / aaaa



## Run Marketplace From Local/Development

Start Redis with: redis-server
Start Elasticsearch with: elasticsearch
Start Sidekiq with: sidekiq -q mailer
Start with: http://localhost:9200/

Start Marketplace locally
  - start the prometheus: bundle exec prometheus_exporter --port 9394 &
  - start the server: rails server
  - start the elasticsearch: elasticsearch
  - open the web: http://127.0.0.1:3000/
  - show puma-dev log: tail -f ~/Library/Logs/puma-dev.log
  - start rails console: bundle exec rails console
  - migrate database: RAILS_ENV=test bundle exec rake db:recreate/migrate/seed/etc
  - login to sidekiq: https://shop.idme.test/sidekiq
  - running sidekiq queue: sidekiq -q mailer



##  Marketplace Engineer Onboarding

Gotcha for onboarding
- OKTA does not require the @id.me in the login name
- Developer Environment Setup Playbook
  - https://idmeinc.atlassian.net/wiki/spaces/EN/pages/1752334518/Developer+Environment+Setup+Playbook
  - Need access to the page of Adding-Users-to-temas
    Verify that your github account can see the ID.me repos. You should see 300+ repos. If you’re unable to see them, go to ID.me and verify that your user is a member of a team.
If not, a teammate can help add you to the appropriate team by following the steps in
https://idmeinc.atlassian.net/wiki/spaces/PLT/pages/3389554705/Team+Management+-+GitHub#Adding-Users-to-Teams<Request access.>
  - Add yourself to the proper team in GitHub: https://github.com/orgs/IDme/teams
- Failed with "ERROR: sql.h not found" in idme-marketplace
  - install unixodbc manually
    - brew install unixodbc
  - check the unixodbc installation location
    - brew list unixodbc
  - install ruby-odbc manually (not working as v0.999991 and v0.999992)
    - gem install ruby-odbc -- --with-odbc-dir=/opt/homebrew/Cellar/unixodbc/2.3.12
  - set ruby-odbc directory
    - bundle config set build.ruby-odbc --with-odbc-dir=/opt/homebrew/Cellar/unixodbc/2.3.12
- failed with database seeding
 - Install vips manually
  - brew install vips

- idp
- fraud
- verification

- authority
- encryption
- test-drive admin

https://shop.idme.test/admin/sign_in


  - should use the BYOD for mobile access?
    - https://idmeinc.atlassian.net/servicedesk/customer/portal/7/create/41
  - should apply for Brex access?
    - https://idmeinc.atlassian.net/wiki/spaces/FA/pages/2750611485/Brex+Empower-T+E+Platform-Out+of+pocket+Reimbursement+User+Guide
  - what is FMTC, GNC, AMA, SC team
  - access to
    - Figma
    - Snowflake
    - GCP Console access for github ci using IT support
  - access to marketplace data
    - production: https://metabase.idme.co/
    - staging https://metabase.idme.cc/
  - no access to grafana
    - https://grafana.idme.co/login or https://grafana.idmeinc.net/
  - How to access prod and non-prod vault
    - LDAP, OKTA, etc?
  - How to access EPPO
    - use Google login failed with 'We could not log you in because there was an authentication error'

  - How shopify works with affliate, AF, and Amazon & Ebay?



## Run API Calls From Curl
```
curl -i -X POST "https://shop.idme.test/api/v1/webhooks/events" \
     -H "Content-Type: application/json" \
     -d '{
    "event": "verification.complete",
    "data": {
        "email": "anonymous@gmail.com",
        "fpjs_request": "",
        "fingerprint": "",
        "session_id": "",
        "port": "",
        "entity_uuid": "475315302",
        "entity_type": "IDme::VerificationAttempt",
        "attempt": "86d0f728f8cb42c38bfb886597fc80c0",
        "group": "Student",
        "group_handle": "student",
        "option": "student_document",
        "policy": {
            "id": "9474",
            "name": "Student Verification"
        }
    },
    "user": "563c47ae9b004148b8de7adb0260d1ee",
    "controller": "api/v1/webhooks/events",
    "action": "create"
}'
```


## SQL Query
WITH my_offers AS (SELECT commission_split, commission_total, *
		FROM offers
		WHERE id IN (2893299, 2891236)
	),
	my_stores AS (
		SELECT commission_split, commission_total, commission_average, *
		FROM stores
		WHERE id IN (SELECT merchant_id FROM my_offers)
	),
	my_store_group_commissions AS (
		SELECT * FROM store_group_commissions WHERE store_id IN (SELECT id FROM my_stores)
	)
SELECT * FROM my_store_group_commissions


## Running Docker
```BASH
docker run --rm alpine getent hosts host.docker.internal

docker build -t e2e-tests-test -f Dockerfile-test .
docker run -it --entrypoint bash idme-marketplace-shop.idme.test

docker run -it --rm \
  --add-host=shop.idme.test:192.168.65.254 \
  --add-host=authority.idme.test:192.168.65.254 \
  e2e-tests \
  /bin/bash

docker build -f e2e_tests/ruby_e2e_tests/Dockerfile --build-arg E2E_TEST_DIR=e2e_tests/ruby_e2e_tests  -t ruby-e2e-tests .
docker run -it --rm --env TEST_ENV=staging ruby-e2e-tests
docker run -it --rm --env TEST_ENV=staging ruby-e2e-tests /bin/bash

```

