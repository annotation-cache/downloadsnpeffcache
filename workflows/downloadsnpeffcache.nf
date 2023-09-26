//
// DOWNLOAD SNPEFF CACHE
//

include { SNPEFF_DOWNLOAD } from '../modules/nf-core/snpeff/download/main'

workflow DOWNLOADSNPEFFCACHE {
    take:
    snpeff_info

    main:
    SNPEFF_DOWNLOAD(snpeff_info)

    emit:
    snpeff_cache = SNPEFF_DOWNLOAD.out.cache.collect()  // channel: [ meta, cache ]
    versions     = SNPEFF_DOWNLOAD.out.versions         // channel: [ versions.yml ]
}
