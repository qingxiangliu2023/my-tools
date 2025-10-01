
###########################################
###########################################
#   Add current file to ~/.bash_profile, ~/.bashrc. ~/.zshrc, ~/.zprofile
#   echo "~~~~~~~~ Welcome to Qingxiang liu's World ~~~~~~~~"
#   . /Users/qingxiang.liu/QingxiangLiu/workspace/my-tools/bash__git_ps1
#   . /Users/qingxiang.liu/QingxiangLiu/workspace/my-tools/my.sh


###########################################
###########################################

export JAVA_HOME=/Library/Java/JavaVirtualMachines/graalvm-jdk-23.0.2+7.1/Contents/Home/
echo export DOCKER_DEFAULT_PLATFORM=linux/amd64

# Tell grep to highlight matches
export GREP_OPTIONS='--color=auto'

# Tell ls to be colourful
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad
export LSCOLORS=Exfxcxdxbxegedabagacad

# postgres database
# export PGUSER=dbuser
# export PGPASSWORD=dbpassword
export PGDATABASE=postgres
# export PGHOST=localhost


ARRAY_BASE_INDEX=("111")
if [[ ${ARRAY_BASE_INDEX[0]} == "111" ]]; then
    ARRAY_BASE_INDEX=0
else
    ARRAY_BASE_INDEX=1
fi

echo "~~~~ setting up the rben ~~~~"
export PATH="$HOME/.rbenv/versions/3.4.4/bin:$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"
echo $PATH

###########################################
alias ls='ls -G'
alias ll='ls -alG'
alias dev='cd ~/workspace/idme-marketplace'
alias my=my_main

# export API_KEY=3642e99b-04ea-4fc4-a13c-426450c9ec96

# daniel+1 staging account: 199
# export API_KEY=ad825b80-0af9-11ee-9dbe-25314275f7f1
export TEST_ENV=staging


unset GREP_OPTIONS

###########################################
my_main() {
    case $1 in
        current_git_branch)
            git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
            ;;

        ##############################################################################
        ################################### ????? ####################################
        ##############################################################################

        aws)
            my_print_message "configure AWS CLI"
            AWS_ENV=$2
            if [[ $AWS_ENV == "staging" ]]; then
                my_print_and_execute "more ~/Daniel/personal/MyTools/aws/staging_input.txt | aws configure"
            elif [[ $AWS_ENV == "prod" ]]; then
                my_print_and_execute "more ~/Daniel/personal/MyTools/aws/prod_input.txt | aws configure"
            elif [[ $AWS_ENV == "daniel" ]]; then
                my_print_and_execute "more ~/Daniel/personal/MyTools/aws/daniel_input.txt | aws configure"
            else
                my_print_and_execute "bat ~/.aws/*"
                my_print_and_execute "aws configure"
            fi
            ;;

        build)
            my_print_message "gradle build"
            TEST_CASE=$2
            if [[ $TEST_CASE == "all" ]]; then
                my_print_and_execute "./gradlew build"
            else
                my_print_and_execute "./gradlew build :payments:service:test"
            fi
            ;;

        staging)
            my_print_message "gradle build and deploy to staging"
            my_print_and_execute "gradle shadowJar"
            my_print_and_execute "./deploy-to-staging.sh"
            ;;

        app)
            my_print_message "gradle build and start the app"
            APP_CLASS_NAME=$2
            my_print_and_execute "gradle shadowJar"
            my_print_and_execute "java -Xms4g -Xmx8g -Djava.util.concurrent.ForkJoinPool.common.parallelism=40 -cp payments/service/build/libs/shadow.jar com.amberflo.metering.payment.apps.${APP_CLASS_NAME} $3 $4 $5 $6 $7 $8 $9"
            ;;

        doc | api)
            my_print_message "gradle build the documents"
            my_print_and_execute "./gradlew generateOpenApiSpecs"
            ;;

        api-key)
            my_print_message "fetch the API KEY for the given account id and environment"
            API_KEY_DEPLOY_ENV=$2
            API_KEY_ACCOUNT_ID=$3
            if [[ $API_KEY_DEPLOY_ENV == "prod" ]]; then
                API_KEY_MASTER_KEY="337b3819-2ade-4a8c-a589-e4727f75fb50"
                API_KEY_ROOT_URL="https://app.amberflo.io"
            else
                API_KEY_MASTER_KEY="24af0537-431e-46d1-91ae-14f8641dc5f2"
                API_KEY_ROOT_URL="https://beta.amberflo.io"
            fi
            my_print_and_execute "curl '${API_KEY_ROOT_URL}/key-management' -H 'X-API-Key: ${API_KEY_MASTER_KEY}' -H 'X-Impersonate-Owner: ${API_KEY_ACCOUNT_ID}'"
            ;;

        db)
            my_print_message "recreate the local postgres database"
            my_print_and_execute "RAILS_ENV=test bundle exec rake db:recreate"
            ;;

        refresh)
            my_print_message "refresh gradle dependencies"
            my_print_and_execute "./gradlew build --refresh-dependencies"
            ;;


        ##############################################################################
        ################################### ID.ME ####################################
        ##############################################################################

        my)
            my_print_message "refresh my tools"
            my_print_and_execute ". /Users/qingxiang.liu/workspace/my-tools/my.sh"
            ;;

        branch)
            my_print_message "create a new git branch and switch to it"
            BRANCH_NAME=$2
            if [[ $BRANCH_NAME == "" ]]; then
                my_print_and_execute git branch
                return
            fi
            my_print_and_execute "git branch ${BRANCH_NAME}"
            my_print_and_execute "git checkout ${BRANCH_NAME}"
            ;;

        checkout | co)
            my_print_message "present a list of recent git branches to checkout"
            if [[ $# > 1 ]]; then
                CHECKOUT_COUNT=$2
            else
                CHECKOUT_COUNT=10
            fi
            CHECKOUT_BRANCHES=($(git for-each-ref --count=${CHECKOUT_COUNT} --sort=-committerdate refs/heads/ --format='%(refname)' | cut -d / -f 3-))
            for (( i = 0; i < ${#CHECKOUT_BRANCHES[@]}; i++ )) do
                echo "${i} ) ${CHECKOUT_BRANCHES[$i+${ARRAY_BASE_INDEX}]}"
            done
            echo -n "----> select a number > "
            read CHECKOUT_INDEX
            CHECKOUT_SELECTED=${CHECKOUT_BRANCHES[$CHECKOUT_INDEX+${ARRAY_BASE_INDEX}]}
            echo "----> switching to branch '$CHECKOUT_SELECTED' ..."
            git checkout $CHECKOUT_SELECTED 2>&1 > /dev/null
            ;;

        lint)
            my_print_message "run code linters for SQL, Java, and Ruby"
            LINT_FILE_TYPE=$2
            if [[ $LINT_FILE_TYPE == "sql" ]]; then
                my_print_and_execute "mvn me.id.database.management:sql-linter-maven-plugin:check"
            elif [[ $LINT_FILE_TYPE == "java" ]]; then
                my_print_and_execute "mvn spotless:apply"
            elif [[ $LINT_FILE_TYPE == "all" ]]; then
                my_print_and_execute "git diff --diff-filter=ACMRT --name-only origin/master HEAD . | grep '.java$' | xargs -I {} java -jar /Users/qingxiang.liu/QingxiangLiu/personal/applications/google-java-format.jar --replace {}"
                my_print_and_execute "git diff --diff-filter=ACMRT --name-only origin/master HEAD . | grep '.rb$'   | xargs -I{} rubocop -A --format quiet {}"
            else
                my_print_and_execute "bundle exec rubocop -a"
            fi
            ;;

        odbc)
            my_print_message "install ruby-odbc gems"
            my_print_and_execute "bundle config set build.ruby-odbc --with-odbc-dir=/opt/homebrew/Cellar/unixodbc/2.3.12"
            my_print_and_execute "bundle install"
            ;;

        prometheus)
            my_print_message "start prometheus exporter in the background asynchronously"
            my_print_and_execute "bundle exec prometheus_exporter --port 9394 &"
            ;;

        console)
            my_print_message "start ruby console"
            my_print_and_execute "bundle exec rails console"
            ;;

        puma)
            my_print_message "show puma log or clean up puma-dev"
            PUMA_TARGET=$2
            if [[ $PUMA_TARGET == "clean" ]]; then
                my_print_and_execute "pkill -9 puma-dev"
                my_print_and_execute "curl shop.idme.test > /dev/null"
            else
                my_print_and_execute "tail -f ~/Library/Logs/puma-dev.log"
            fi
            ;;

        test)
            my_print_message "run ruby tests"
            TEST_CASE=$2
            if [[ $TEST_CASE == "" ]]; then
                my_print_and_execute "bundle exec rspec"
            else
                my_print_and_execute "bundle exec rspec ${TEST_CASE}"
            fi
            ;;

        debug)
            my_print_message "run the rails server with rdbg"
            my_print_and_execute "rdbg -n -c -- bundle exec bin/rails server"
            ;;

        changes)
            my_print_message "show the PRs from last tag"
            CHANGE_LAST_REPO_TAG=`git describe --tags --abbrev=0`
            my_print_message "The last tag is: ${CHANGE_LAST_REPO_TAG}"
            my_print_and_execute "git log ${CHANGE_LAST_REPO_TAG}..HEAD --pretty=format:'%ad | %h | %an | %s' --date=iso | grep -v 'skip ci'"
            ;;

        python)
            source ~/.python3/venv/bin/activate
            ;;

        space)
            my_print_message "remove trailing spaces"
            my_print_and_execute "git diff master --name-only | xargs -I{} perl -i -pe 's/[ \t]+$//' {}"
            ;;

        diff)
            my_print_message "show the file names changed since last master"
            my_print_and_execute "git diff --diff-filter=ACMRT --name-only origin/master HEAD"
            ;;

        *)
            my_print_message "Unknown command to 'my': $1"
            ;;
    esac
}

my_print_and_execute() {
    my_print_message $@
    eval $@
}

my_print_message() {
    echo "========> $@"
}


###########################################
if [[ ${ARRAY_BASE_INDEX} == 1 ]]; then
    setopt prompt_subst
    autoload -Uz vcs_info
    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' formats "(%b) "
fi

precmd() {
    if [[ ${ARRAY_BASE_INDEX} == 1 ]]; then
        vcs_info
    fi

    # __git_ps1
    MY_CURRENT_GIT_BRANCH=$(my current_git_branch)
}

# export PROMPT="%n@%m %1~ %#"
PROMPT='%F{red}%n@%m%f %~ %F{013}${vcs_info_msg_0_}%f%# '
PROMPT='%F{red}%n@%m%f %~ %F{013}${MY_CURRENT_GIT_BRANCH}%f%# '

if [[ ${ARRAY_BASE_INDEX} == 0 ]]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;35m\]$(__git_ps1)\[\033[00m\]\$ '
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
fi
