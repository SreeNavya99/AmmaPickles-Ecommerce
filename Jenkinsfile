<?xml version="1.0" encoding="UTF-8"?>

<settings xmlns="http://maven.apache.org/SETTINGS/1.2.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.2.0
                              https://maven.apache.org/xsd/settings-1.2.0.xsd">

    <servers>

        <server>
            <id>nexus-group</id>
            <username>${env.NEXUS_USERNAME}</username>
            <password>${env.NEXUS_PASSWORD}</password>
        </server>

        <server>
            <id>nexus-releases</id>
            <username>${env.NEXUS_USERNAME}</username>
            <password>${env.NEXUS_PASSWORD}</password>
        </server>

        <server>
            <id>nexus-snapshots</id>
            <username>${env.NEXUS_USERNAME}</username>
            <password>${env.NEXUS_PASSWORD}</password>
        </server>

    </servers>

    <mirrors>

        <mirror>
            <id>nexus-group</id>
            <name>Amma Pickles Nexus Maven Group</name>
            <url>http://nexus:8081/repository/amma-pickles-maven-group/</url>
            <mirrorOf>*</mirrorOf>
        </mirror>

    </mirrors>

AMMA PICKLES CI PIPELINE SUCCESSFUL
'''
        }

        failure {
            echo '''
AMMA PICKLES CI PIPELINE FAILED
'''
        }

        always {
            echo "Build Number: ${BUILD_NUMBER}"
            echo "Git Commit: ${GIT_COMMIT}"
        }
    }
}
</settings>
