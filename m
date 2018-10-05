Return-Path: <zohar@linux.ibm.com>
Subject: Re: PROBLEM: IMA xattrs not written on overlayfs
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Fri, 05 Oct 2018 06:33:55 -0400
In-Reply-To: <20181005025733.fjlz34pph2hzcsxd@merlin>
References: <81a0a75d-bd4e-25ef-b41b-adb65ac6dee8@suse.de>
	 <1538153671.3713.4.camel@linux.ibm.com>
	 <0e1ba67f-3091-2d56-a464-07e1a8251e5e@suse.de>
	 <2170726.hUdX192fWn@linux-e202.suse.de>
	 <CAJfpegtk=OD6GVVOOtBT4Lto9x73vnSGdTMrzK-uTvStE6KxWw@mail.gmail.com>
	 <1538601501.3702.217.camel@linux.ibm.com>
	 <CAJfpegt52N==WoSQt_GMwZnOPyoV38j3r8vL95Ds0-NakVFueg@mail.gmail.com>
	 <1538668350.3702.348.camel@linux.ibm.com>
	 <20181005025733.fjlz34pph2hzcsxd@merlin>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <1538735635.3702.423.camel@linux.ibm.com>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Fabian Vogt <fvogt@suse.de>, Ignaz Forster <iforster@suse.de>, overlayfs <linux-unionfs@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, 2018-10-04 at 21:57 -0500, Goldwyn Rodrigues wrote:
> On 11:52 04/10, Mimi Zohar wrote:
> > On Thu, 2018-10-04 at 00:35 +0200, Miklos Szeredi wrote:
> > 
> > > Right, if it's done from last fput() then it's at least not a security hole.
> > > 
> > > This hack may work for some filesystems, but as you noticed, it won't
> > > work for overlayfs.  And  if probably won't work for a number of other
> > > filesystems as well: the fs can assume that f_mode & FMODE_READ will
> > > remain off if it was off at open time.
> > > 
> > > The proper way to handle it generally is to open a separate instance
> > > of the same file from IMA with O_RDONLY and use that to calculate the
> > > hash.   There's really no point in reusing the same file and hacking
> > > the f_mode bits.
> > 
> > Is there an appropriate low level kernel call for creating a new file
> > descriptor that would be appropriate?  dentry_open(), like the call in
> > file_clone_open(), has a lot of overhead, including the LSM calls.
> >  Calculating the file hash always needs to work.
> > 
> 
> Mimi,
> 
> I have formulated a patch which is working for me on overlayfs. I am
> using dentry_open(), which I agree may have overhead. While this
> opens up the possibility of using it for files opened with O_DIRECT
> which may end up getting the file into pagecache.
> 
> Subject: [PATCH] Open new file instance O_RDONLY to calculate hash
> 
> Using the open struct file to calculate the hash does not work
> with overlayfs, because the real struct file is hidden behind the
> overlays struct file. So, any file->f_mode manipulations are not
> reflected on the real struct file. So, open the file again, read and
> calculate the hash.
> 
> As a byproduct, we can remove all instance of f_mode manipulations
> and can work with O_DIRECT as well.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

By "overhead", I didn't mean it from a performance perspective, but
was concerned about the dentry_open() failing.  If "dentry_open" fails
for any reason, the file hash will not be re-calculated, causing
future file opens to fail.  Missing is the test for dentry_open()
failure.

By removing the "read" check, re-opening the file is now for all
files, not just those opened without "read".  From a testing
perspective, it will catch problems faster, but ...

I've had a patch queued that removes the O_DIRECT test, but haven't
had a chance to test it on ALL filesystems.  I would probably re-open
the file with the original flags, plus read, as much as possible.
 
Mimi


> 
> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
> index 7e7e7e7c250a..87e5fedc2162 100644
> --- a/security/integrity/ima/ima_crypto.c
> +++ b/security/integrity/ima/ima_crypto.c
> @@ -210,7 +210,7 @@ static int ima_calc_file_hash_atfm(struct file *file,
>  {
>  	loff_t i_size, offset;
>  	char *rbuf[2] = { NULL, };
> -	int rc, read = 0, rbuf_len, active = 0, ahash_rc = 0;
> +	int rc, rbuf_len, active = 0, ahash_rc = 0;
>  	struct ahash_request *req;
>  	struct scatterlist sg[1];
>  	struct crypto_wait wait;
> @@ -257,11 +257,6 @@ static int ima_calc_file_hash_atfm(struct file *file,
>  					  &rbuf_size[1], 0);
>  	}
>  
> -	if (!(file->f_mode & FMODE_READ)) {
> -		file->f_mode |= FMODE_READ;
> -		read = 1;
> -	}
> -
>  	for (offset = 0; offset < i_size; offset += rbuf_len) {
>  		if (!rbuf[1] && offset) {
>  			/* Not using two buffers, and it is not the first
> @@ -300,8 +295,6 @@ static int ima_calc_file_hash_atfm(struct file *file,
>  	/* wait for the last update request to complete */
>  	rc = ahash_wait(ahash_rc, &wait);
>  out3:
> -	if (read)
> -		file->f_mode &= ~FMODE_READ;
>  	ima_free_pages(rbuf[0], rbuf_size[0]);
>  	ima_free_pages(rbuf[1], rbuf_size[1]);
>  out2:
> @@ -336,7 +329,7 @@ static int ima_calc_file_hash_tfm(struct file *file,
>  {
>  	loff_t i_size, offset = 0;
>  	char *rbuf;
> -	int rc, read = 0;
> +	int rc;
>  	SHASH_DESC_ON_STACK(shash, tfm);
>  
>  	shash->tfm = tfm;
> @@ -357,11 +350,6 @@ static int ima_calc_file_hash_tfm(struct file *file,
>  	if (!rbuf)
>  		return -ENOMEM;
>  
> -	if (!(file->f_mode & FMODE_READ)) {
> -		file->f_mode |= FMODE_READ;
> -		read = 1;
> -	}
> -
>  	while (offset < i_size) {
>  		int rbuf_len;
>  
> @@ -378,8 +366,6 @@ static int ima_calc_file_hash_tfm(struct file *file,
>  		if (rc)
>  			break;
>  	}
> -	if (read)
> -		file->f_mode &= ~FMODE_READ;
>  	kfree(rbuf);
>  out:
>  	if (!rc)
> @@ -420,26 +406,21 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
>  {
>  	loff_t i_size;
>  	int rc;
> +	struct file *f = dentry_open(&file->f_path, O_LARGEFILE | O_RDONLY,
> +			current_cred());
>  
> -	/*
> -	 * For consistency, fail file's opened with the O_DIRECT flag on
> -	 * filesystems mounted with/without DAX option.
> -	 */
> -	if (file->f_flags & O_DIRECT) {
> -		hash->length = hash_digest_size[ima_hash_algo];
> -		hash->algo = ima_hash_algo;
> -		return -EINVAL;
> -	}
> -
> -	i_size = i_size_read(file_inode(file));
> +	i_size = i_size_read(file_inode(f));
>  
>  	if (ima_ahash_minsize && i_size >= ima_ahash_minsize) {
> -		rc = ima_calc_file_ahash(file, hash);
> +		rc = ima_calc_file_ahash(f, hash);
>  		if (!rc)
> -			return 0;
> +			goto out;
>  	}
>  
> -	return ima_calc_file_shash(file, hash);
> +	rc = ima_calc_file_shash(f, hash);
> +out:
> +	fput(f);
> +	return rc;
>  }
>  
>  /*
> 
