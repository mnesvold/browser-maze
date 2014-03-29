function conditional_html(flags) {
    var regex = /<!-- #if\(([A-Z]+)\) -->([\s\S]*?)<!-- #endif -->/g;
    return function(input) {
        return input.replace(regex, function(match, flag, content) {
            if(flags.indexOf(flag) >= 0) {
                return content;
            }
            return '';
        });
    };
}

module.exports = function(grunt) {
    grunt.initConfig({
        pkg: {
            'name': 'maze',
            'version': '0.1.0'
        },
        clean: {
            all: [
                'build/',
                'dist/'
            ]
        },
        coffee: {
            options: {
            },
            files: {
                expand: true,
                cwd: 'src',
                src: ['scripts/**/*.coffee'],
                dest: 'build/',
                ext: '.js'
            }
        },
        copy: {
            html_dev: {
                expand: true,
                cwd: 'src',
                src: ['*.html'],
                dest: 'build/',
                options: {
                    process: conditional_html(['DEV'])
                }
            },
            html_dist: {
                expand: true,
                cwd: 'src',
                src: ['*.html'],
                dest: 'dist/',
                options: {
                    process: conditional_html(['DIST'])
                }
            },
            raw_js: {
                expand: true,
                cwd: 'src',
                src: ['**/*.js'],
                dest: 'build/'
            },
            dist_require: {
                src: ['src/scripts/require.js'],
                dest: 'dist/require.js'
            }
        },
        requirejs: {
            compile_main: {
                options: {
                    baseUrl: 'build/scripts',
                    name: 'app',
                    out: 'dist/maze.js',
                    optimize: 'uglify2',
                    mainConfigFile: 'build/scripts/config.js'
                }
            },
            compile_mapper: {
                options: {
                    baseUrl: 'build/scripts',
                    name: 'app-map',
                    out: 'dist/map.js',
                    optimize: 'uglify2',
                    mainConfigFile: 'build/scripts/config.js'
                }
            }
        },
        watch: {
            coffee: {
                files: ['src/scripts/**.coffee'],
                tasks: ['coffee']
            },
            raw_js: {
                files: ['src/scripts/**.js'],
                tasks: ['copy:raw_js']
            },
            html: {
                files: ['src/**.html'],
                tasks: ['copy:html_dev']
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-requirejs');
    grunt.loadNpmTasks('grunt-contrib-watch');

    grunt.registerTask('default', ['build']);
    grunt.registerTask('build', ['copy:html_dev', 'copy:raw_js', 'coffee']);
    grunt.registerTask('dist', ['build', 'requirejs', 'copy:html_dist', 'copy:dist_require']);
}
