process SNPEFF_DOWNLOAD {
    tag "${meta.id}"
    label 'process_medium'

    conda "bioconda::snpeff=5.3.0a"
    container "${workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container
        ? 'https://depot.galaxyproject.org/singularity/snpeff:5.1--hdfd78af_2'
        : 'community.wave.seqera.io/library/snpeff:5.3.0a--ca8e0b08f227a463'}"

    input:
    tuple val(meta), val(genome)

    output:
    tuple val(meta), path(prefix), emit: cache
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def avail_mem = 6144
    if (!task.memory) {
        log.info('[snpEff] Available memory not known - defaulting to 6GB. Specify process memory requirements to change this.')
    }
    else {
        avail_mem = (task.memory.mega * 0.8).intValue()
    }
    prefix = task.ext.prefix ?: 'snpeff_cache'
    """
    snpEff \\
        -Xmx${avail_mem}M \\
        download ${genome} \\
        -dataDir \${PWD}/${prefix} \\
        ${args}


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        snpeff: \$(echo \$(snpEff -version 2>&1) | cut -f 2 -d ' ')
    END_VERSIONS
    """

    stub:
    """
    mkdir ${genome}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        snpeff: \$(echo \$(snpEff -version 2>&1) | cut -f 2 -d ' ')
    END_VERSIONS
    """
}
