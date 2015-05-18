module.exports = (grunt) ->
  require('jit-grunt')(grunt, {
    express: 'grunt-express-server'
    unzip: 'grunt-zip'
    replace: 'grunt-text-replace'
  });
  require('time-grunt')(grunt);

  expressPort = '<%= grunt.option("port") || 3000 %>'
  isWindows = process.platform == 'win32'

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    SOURCE_PATH: './src/main'
    ASSETS_PATH: grunt.option("assetsDir") || './src/main/webapp'
    BUILD_PATH: './build'

    less:
      build:
        options:
          cleancss: true
        files:
          '<%= BUILD_PATH %>/css/sonar.css': [
            '<%= SOURCE_PATH %>/less/jquery-ui.less'
            '<%= SOURCE_PATH %>/less/select2.less'
            '<%= SOURCE_PATH %>/less/select2-sonar.less'

            '<%= SOURCE_PATH %>/less/init.less'
            '<%= SOURCE_PATH %>/less/components.less'
            '<%= SOURCE_PATH %>/less/pages.less'

            '<%= SOURCE_PATH %>/less/style.less'

            '<%= SOURCE_PATH %>/less/*.less'
          ]


    coffee:
      build:
        files: [
          expand: true
          cwd: '<%= SOURCE_PATH %>/coffee'
          src: ['**/*.coffee']
          dest: '<%= BUILD_PATH %>/js'
          ext: '.js'
        ]


    concat:
      build:
        files:
          '<%= BUILD_PATH %>/js/sonar.js': [
            '<%= BUILD_PATH %>/js/libs/translate.js'
            '<%= BUILD_PATH %>/js/libs/third-party/jquery.js'
            '<%= BUILD_PATH %>/js/libs/third-party/jquery-ui.js'
            '<%= BUILD_PATH %>/js/libs/third-party/d3.js'
            '<%= BUILD_PATH %>/js/libs/third-party/latinize.js'
            '<%= BUILD_PATH %>/js/libs/third-party/underscore.js'
            '<%= BUILD_PATH %>/js/libs/third-party/backbone.js'
            '<%= BUILD_PATH %>/js/libs/third-party/backbone.marionette.js'
            '<%= BUILD_PATH %>/js/libs/third-party/handlebars.js'
            '<%= BUILD_PATH %>/js/libs/third-party/underscore.js'
            '<%= BUILD_PATH %>/js/libs/third-party/select2.js'
            '<%= BUILD_PATH %>/js/libs/third-party/keymaster.js'
            '<%= BUILD_PATH %>/js/libs/third-party/moment.js'
            '<%= BUILD_PATH %>/js/libs/third-party/numeral.js'
            '<%= BUILD_PATH %>/js/libs/third-party/numeral-languages.js'
            '<%= BUILD_PATH %>/js/libs/third-party/bootstrap/tooltip.js'
            '<%= BUILD_PATH %>/js/libs/third-party/bootstrap/dropdown.js'
            '<%= BUILD_PATH %>/js/libs/select2-jquery-ui-fix.js'

            '<%= BUILD_PATH %>/js/libs/widgets/base.js'
            '<%= BUILD_PATH %>/js/libs/widgets/widget.js'
            '<%= BUILD_PATH %>/js/libs/widgets/bubble-chart.js'
            '<%= BUILD_PATH %>/js/libs/widgets/timeline.js'
            '<%= BUILD_PATH %>/js/libs/widgets/stack-area.js'
            '<%= BUILD_PATH %>/js/libs/widgets/pie-chart.js'
            '<%= BUILD_PATH %>/js/libs/widgets/histogram.js'
            '<%= BUILD_PATH %>/js/libs/widgets/word-cloud.js'
            '<%= BUILD_PATH %>/js/libs/widgets/tag-cloud.js'
            '<%= BUILD_PATH %>/js/libs/widgets/treemap.js'

            '<%= BUILD_PATH %>/js/libs/graphics/pie-chart.js'
            '<%= BUILD_PATH %>/js/libs/graphics/barchart.js'
            '<%= BUILD_PATH %>/js/libs/sortable.js'

            '<%= BUILD_PATH %>/js/components/common/inputs.js'
            '<%= BUILD_PATH %>/js/components/common/dialogs.js'
            '<%= BUILD_PATH %>/js/components/common/processes.js'
            '<%= BUILD_PATH %>/js/components/common/jquery-isolated-scroll.js'
            '<%= BUILD_PATH %>/js/components/common/handlebars-extensions.js'

            '<%= BUILD_PATH %>/js/libs/application.js'
            '<%= BUILD_PATH %>/js/libs/csv.js'
            '<%= BUILD_PATH %>/js/libs/dashboard.js'
            '<%= BUILD_PATH %>/js/libs/recent-history.js'
            '<%= BUILD_PATH %>/js/libs/require.js'
          ]


    requirejs:
      options:
        baseUrl: '<%= BUILD_PATH %>/js/'
        preserveLicenseComments: false

      qualityGate: options:
        name: 'apps/quality-gate/app'
        out: '<%= ASSETS_PATH %>/js/apps/quality-gate/app.js'

      qualityProfiles: options:
        name: 'apps/quality-profiles/app'
        out: '<%= ASSETS_PATH %>/js/apps/quality-profiles/app.js'

      codingRules: options:
        name: 'apps/coding-rules/app'
        out: '<%= ASSETS_PATH %>/js/apps/coding-rules/app.js'

      issues: options:
        name: 'apps/issues/app-new'
        out: '<%= ASSETS_PATH %>/js/apps/issues/app-new.js'

      issuesContext: options:
        name: 'apps/issues/app-context'
        out: '<%= ASSETS_PATH %>/js/apps/issues/app-context.js'

      measures: options:
        name: 'apps/measures/app'
        out: '<%= ASSETS_PATH %>/js/apps/measures/app.js'

      selectList: options:
        name: 'components/common/select-list'
        out: '<%= ASSETS_PATH %>/js/components/common/select-list.js'

      apiDocumentation: options:
        name: 'apps/api-documentation/app'
        out: '<%= ASSETS_PATH %>/js/apps/api-documentation/app.js'

      drilldown: options:
        name: 'apps/drilldown/app'
        out: '<%= ASSETS_PATH %>/js/apps/drilldown/app.js'

      sourceViewer: options:
        name: 'apps/source-viewer/app'
        out: '<%= ASSETS_PATH %>/js/apps/source-viewer/app.js'

      monitoring: options:
        name: 'apps/analysis-reports/app'
        out: '<%= ASSETS_PATH %>/js/apps/analysis-reports/app.js'

      nav: options:
        name: 'apps/nav/app'
        out: '<%= ASSETS_PATH %>/js/apps/nav/app.js'

      issueFilterWidget: options:
        name: 'widgets/issue-filter/widget'
        out: '<%= ASSETS_PATH %>/js/widgets/issue-filter/widget.js'

      markdown: options:
        name: 'apps/markdown/app'
        out: '<%= ASSETS_PATH %>/js/apps/markdown/app.js'


    parallel:
      compile:
        options: grunt: true
        tasks: ['less:build', 'coffee:build', 'handlebars:build']
      build:
        options: grunt: true
        tasks: [
          'uglify:build'
          'requirejs:qualityGate'
          'requirejs:qualityProfiles'
          'requirejs:codingRules'
          'requirejs:issues'
          'requirejs:issuesContext'
          'requirejs:measures'
          'requirejs:selectList'
          'requirejs:apiDocumentation'
          'requirejs:drilldown'
          'requirejs:sourceViewer'
          'requirejs:monitoring'
          'requirejs:nav'
          'requirejs:issueFilterWidget'
          'requirejs:markdown'
        ]
      'build-test':
        options:
          grunt: true
        tasks: ['build-suffix', 'test-suffix']
      'build-coverage':
        options:
          grunt: true
        tasks: ['build-suffix', 'coverage-suffix']


    handlebars:
      options:
        namespace: 'Templates'
        processName: (name) ->
          pieces = name.split '/'
          fileName = pieces[pieces.length - 1]
          fileName.split('.')[0]
        processPartialName: (name) ->
          pieces = name.split '/'
          fileName = pieces[pieces.length - 1]
          fileName.split('.')[0]

      build:
        files:
          '<%= BUILD_PATH %>/js/components/navigator/templates.js': [
            '<%= SOURCE_PATH %>/js/components/navigator/templates/**/*.hbs'
          ]
          '<%= BUILD_PATH %>/js/apps/coding-rules/templates.js': [
            '<%= SOURCE_PATH %>/js/components/common/templates/**/*.hbs'
            '<%= SOURCE_PATH %>/js/apps/coding-rules/templates/**/*.hbs'
          ]
          '<%= BUILD_PATH %>/js/apps/quality-gate/templates.js': [
            '<%= SOURCE_PATH %>/coffee/apps/quality-gate/templates/**/*.hbs'
          ]
          '<%= BUILD_PATH %>/js/apps/quality-profiles/templates.js': [
            '<%= SOURCE_PATH %>/js/apps/quality-profiles/templates/**/*.hbs'
          ]
          '<%= BUILD_PATH %>/js/components/source-viewer/templates.js': [
            '<%= SOURCE_PATH %>/js/components/source-viewer/templates/**/*.hbs'
          ]
          '<%= BUILD_PATH %>/js/components/issue/templates.js': [
            '<%= SOURCE_PATH %>/js/components/common/templates/**/*.hbs'
            '<%= SOURCE_PATH %>/coffee/components/issue/templates/**/*.hbs'
          ]
          '<%= BUILD_PATH %>/js/apps/issues/templates.js': [
            '<%= SOURCE_PATH %>/coffee/apps/issues/templates/**/*.hbs'
          ]
          '<%= BUILD_PATH %>/js/apps/api-documentation/templates.js': [
            '<%= SOURCE_PATH %>/js/apps/api-documentation/templates/**/*.hbs'
          ]
          '<%= BUILD_PATH %>/js/apps/analysis-reports/templates.js': [
            '<%= SOURCE_PATH %>/coffee/apps/analysis-reports/templates/**/*.hbs'
          ]
          '<%= BUILD_PATH %>/js/apps/nav/templates.js': [
            '<%= SOURCE_PATH %>/js/apps/nav/templates/**/*.hbs'
          ]
          '<%= BUILD_PATH %>/js/widgets/issue-filter/templates.js': [
            '<%= SOURCE_PATH %>/js/widgets/issue-filter/templates/**/*.hbs'
          ]
          '<%= BUILD_PATH %>/js/components/workspace/templates.js': [
            '<%= SOURCE_PATH %>/js/components/workspace/templates/**/*.hbs'
          ]
          '<%= BUILD_PATH %>/js/apps/markdown/templates.js': [
            '<%= SOURCE_PATH %>/js/apps/markdown/templates/**/*.hbs'
          ]


    clean:
      options:
        force: true
      css: ['<%= ASSETS_PATH %>/css']
      js: ['<%= ASSETS_PATH %>/js']
      build: ['<%= BUILD_PATH %>']


    copy:
      js:
        expand: true, cwd: '<%= SOURCE_PATH %>/js', src: ['**/*.js'], dest: '<%= BUILD_PATH %>/js'
      'assets-js':
        src: '<%= BUILD_PATH %>/js/sonar.js', dest: '<%= ASSETS_PATH %>/js/sonar.js'
      'assets-all-js':
        expand: true, cwd: '<%= BUILD_PATH %>/js', src: ['**/*.js'], dest: '<%= ASSETS_PATH %>/js'
      'assets-css':
        src: '<%= BUILD_PATH %>/css/sonar.css', dest: '<%= ASSETS_PATH %>/css/sonar.css'


    express:
      test:
        options:
          script: 'src/test/server.js'
          port: expressPort
      testCoverage:
        options:
          script: 'src/test/server-coverage.js'
          port: expressPort
      dev:
        options:
          background: false
          script: 'src/test/server.js'


    casper:
      test:
        options:
          test: true
          'no-colors': true
          'fail-fast': true
          concise: true
          parallel: !isWindows
          port: expressPort
        src: ['src/test/js/**/*.js']
      testCoverage:
        options:
          test: true
          'no-colors': true
          concise: true
          parallel: !isWindows
          port: expressPort
        src: ['src/test/js/**/*.js']
      testCoverageLight:
        options:
          test: true
          'fail-fast': true
          verbose: true
          parallel: !isWindows
          port: expressPort
        src: ['src/test/js/**/*<%= grunt.option("spec") %>*.js']
      single:
        options:
          test: true
          verbose: true
          'fail-fast': true
          port: expressPort
        src: ['src/test/js/<%= grunt.option("spec") %>-spec.js']
      testfile:
        options:
          test: true
          verbose: true
          'fail-fast': true
          port: expressPort
        src: ['<%= grunt.option("file") %>']


    uglify:
      build:
        src: '<%= ASSETS_PATH %>/js/sonar.js'
        dest: '<%= ASSETS_PATH %>/js/sonar.js'


    curl:
      resetCoverage:
        src:
          url: 'http://localhost:' + expressPort + '/coverage/reset'
          method: 'POST'
        dest: 'target/reset_coverage.dump'

      downloadCoverage:
        src: 'http://localhost:' + expressPort + '/coverage/download'
        dest: 'target/coverage.zip'


    unzip:
      'target/js-coverage': 'target/coverage.zip'


    replace:
      lcov:
        src: 'target/js-coverage/lcov.info'
        dest: 'target/js-coverage/lcov.info'
        replacements: [
          { from: '/webapp', to: '' }
          { from: '\webapp', to: '' }
        ]


    jshint:
      dev:
        src: [
          '<%= SOURCE_PATH %>/js/**/*.js'
          '!<%= SOURCE_PATH %>/js/third-party/underscore.js'
          '!<%= SOURCE_PATH %>/js/third-party/**/*.js'
          '!<%= SOURCE_PATH %>/js/tests/**/*.js'
          '!<%= SOURCE_PATH %>/js/require.js'
        ]
        options:
          jshintrc: true


    watch:
      options:
        spawn: false

      less:
        files: '<%= SOURCE_PATH %>/less/**/*.less'
        tasks: ['less:build']

      coffee:
        files: '<%= SOURCE_PATH %>/coffee/**/*.coffee'
        tasks: ['coffee:build', 'copy:js', 'concat:build']

      js:
        files: '<%= SOURCE_PATH %>/js/**/*.js'
        tasks: ['copy:js', 'concat:build']

      handlebars:
        files: '<%= SOURCE_PATH %>/hbs/**/*.hbs'
        tasks: ['handlebars:build']


  # Basic tasks
  grunt.registerTask 'prepare',
      ['clean:css', 'clean:js', 'clean:build', 'parallel:compile', 'copy:js', 'concat:build']

  grunt.registerTask 'build-fast-suffix',
      ['copy:assets-css', 'copy:assets-all-js']

  grunt.registerTask 'build-suffix',
      ['copy:assets-css', 'copy:assets-js', 'parallel:build']

  grunt.registerTask 'test-suffix',
      ['express:test', 'casper:test']

  grunt.registerTask 'coverage-suffix',
      ['express:testCoverage', 'curl:resetCoverage', 'casper:testCoverage', 'curl:downloadCoverage', 'unzip',
       'replace:lcov']

  # Output tasks
  grunt.registerTask 'build-fast',
      ['prepare', 'build-fast-suffix']

  grunt.registerTask 'build',
      ['prepare', 'build-suffix']

  grunt.registerTask 'build-test',
      ['prepare', 'parallel:build-test']

  grunt.registerTask 'build-coverage',
      ['prepare', 'parallel:build-coverage']

  grunt.registerTask 'test',
      ['prepare', 'test-suffix']

  grunt.registerTask 'coverage',
      ['prepare', 'coverage-suffix']

  grunt.registerTask 'default',
      ['build']

  # Development
  grunt.registerTask 'dw',
      ['build-fast', 'watch']

  grunt.registerTask 'testCoverageLight',
      ['prepare', 'express:testCoverage', 'curl:resetCoverage', 'casper:testCoverageLight', 'curl:downloadCoverage', 'unzip', 'replace:lcov']

  grunt.registerTask 'single',
      ['prepare', 'express:test', 'casper:single']

  grunt.registerTask 'testfile',
      ['prepare', 'express:test', 'casper:testfile']

  # tasks used by Maven build (see pom.xml)
  grunt.registerTask 'maven-quick-build',
      ['build-fast']

  grunt.registerTask 'maven-build-skip-tests-true-nocoverage',
      ['build']

  grunt.registerTask 'maven-build-skip-tests-false-nocoverage',
      ['build-test']

  grunt.registerTask 'maven-build-skip-tests-false-coverage',
      ['build-coverage']
