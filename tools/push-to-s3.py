from __future__ import print_function
import os
import sys
import zlib
import shutil
import hashlib
import boto
import mimetypes
from boto.s3.key import Key
try:
    from cStringIO import StringIO
except ImportError:
    from StringIO import StringIO

ROOT = sys.argv[1]
BUCKET_NAME = sys.argv[2]
BUCKET =  boto.connect_s3().get_bucket(BUCKET_NAME)

EXCLUDE_TYPES = [
    # Compressed types
    '.bz2', '.gz',
    # Audio types
    '.aac', '.flac', '.mp3', '.wma',
    # Image types
    '.gif', '.jpg', '.jpeg', '.png',
    # Video types
    '.avi', '.mov', '.mp4', '.webm',
]


def get_md5(f):
    m = hashlib.md5()
    while True:
        data = f.read(10240)
        if len(data) == 0:
            break
        m.update(data)
    return m.hexdigest()

def open_gzip(fn):
    # FROM pelican-plugins/gzip_cache/gzip_cache.py
    # According to zlib manual: 'Add 16 to
    # windowBits to write a simple gzip header and trailer around the
    # compressed data instead of a zlib wrapper. The gzip header will
    # have no file name, no extra data, no comment, no modification
    # time (set to zero), no header crc, and the operating system
    # will be set to 255 (unknown)'
    COMPRESSION_LEVEL = 9 # Best Compression
    WBITS = zlib.MAX_WBITS | 16

    f = open(fn, 'rb')
    if os.path.splitext(fn)[1] in EXCLUDE_TYPES:
        return f, False

    gz_obj = zlib.compressobj(COMPRESSION_LEVEL, zlib.DEFLATED, WBITS)
    uncompressed_data = f.read()
    gzipped_data = gz_obj.compress(uncompressed_data)
    gzipped_data += gz_obj.flush()
    
    return StringIO(gzipped_data), True


def main():
    for dirpath, dirnames, filenames in os.walk(ROOT):
        for filename in filenames:
            fn = os.path.join(dirpath, filename)
            key_name = os.path.relpath(fn, ROOT)
            key = BUCKET.get_key(key_name)
            f, is_gzipped = open_gzip(fn)

            if (key is None) or (key.etag.strip('"').strip("'") != get_md5(f)):
                print('Uploading', fn, '...')
        
                k = Key(BUCKET)
                k.key = key_name                
                headers = {
                    'Content-Type': mimetypes.guess_type(fn)[0],
                    'Cache-Control': 'public, max-age=3600'
                }
                if is_gzipped:
                    headers['Content-Encoding'] = 'gzip'
                k.set_contents_from_file(f, headers=headers, rewind=True)
                
            else:
                print('Skipping', fn)


if __name__ == '__main__':
    main()