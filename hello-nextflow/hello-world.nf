#!/usr/bin/env nextflow
include { convertToUpper } from './solutions/hello-world/hello-world-9.nf'

/*
 * Use echo to print 'Hello World!' to standard out
 */
params.input_file = "data/greetings.csv"

process sayHello {

    publishDir 'results', mode: 'copy'
    
    input:
        val greeting

    output:
        path "${greeting}-output.txt"

    script:
    """
    echo '$greeting' > '$greeting-output.txt'
    """
}

process covertToUpper {
    
        publishDir 'results', mode: 'copy'
    
        input:
            path input_file
    
        output:
            path "UPPER-${input_file}"
    
        script:
        """
        cat '$input_file' | tr '[a-z]' '[A-Z]' > UPPER-${input_file}
        """
}

workflow {

    // create a channel for inputs
    greeting_ch = Channel.fromPath(params.input_file)
                         .splitCsv()
                         .flatten()

    // emit a greeting
    sayHello(greeting_ch)

    convertToUpper(sayHello.out)
}
