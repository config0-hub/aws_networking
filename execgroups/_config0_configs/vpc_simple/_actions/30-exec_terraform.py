def default():
    return {
        'method': 'shelloutconfig',
        'metadata': {
            'shelloutconfigs': ['config0-publish:::terraform::resource_wrapper'],
            'env_vars': ['config0-publish:::docker::build.env']
        }
    }
