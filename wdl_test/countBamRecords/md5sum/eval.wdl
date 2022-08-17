version 1.0

workflow eval_workflow {
    input {
        File data_file
        String image_to_use = "quay.io/agduncan94/my-md5sum"
        String expectedMd5sum 
    }
    call compare {
        input:
            data_file = data_file,
            image_to_use = image_to_use,
            expectedMd5sum = expectedMd5sum
    }
    output {
        File comparison_result = compare.comparison_result
    }
}

task compare {
    input {
        File data_file
        String image_to_use
        String expectedMd5sum
    }
    command <<<
        
        md5sum helloworld.txt | sed "s/|/ /" | awk "{print $1, $8}" | read filemd5

        if [$filemd5 == $expectedMd5sum]
        then
        echo "true"
        else
        echo "false"
        fi
    >>>
    runtime {
        docker: image_to_use
    }
    output {
        File comparison_result = stdout()
    }
}
