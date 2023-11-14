Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E663FC54798
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 23:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjKNXmR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 18:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjKNXmQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 18:42:16 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D3CD9
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 15:42:12 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-41b7ec4cceeso35379001cf.1
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 15:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.cmu.edu; s=google-2021; t=1700005332; x=1700610132; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0ZbzgmDszElKBJtPWUc8Ph/B7VdmlFSqeScykz2jDzY=;
        b=Ph6Y5k27+xvOATM5IsOvx6KcW0O93O9HhjvpJFUOQgiEp7OYy22UIa+9mxXUL04mMR
         8FiVxrVl33rQIJjiM3z7s03hK8Jg4Q8cvzyqDJJSNxzkAlTGZgx3BIb/HF86NxAkZTI6
         Nz0878Y5qYvL5q0QQP5F7DAwkSThL/awadUbpuS9SHPi3t0F9C8fYF80Ejmg4K3+PL+w
         Nizw3kKRax6TjEWOg//EUvGdcSibyGdj+V0BQP41Fi1BdnEdtuqkQDXugUkzyUeLZ5P9
         1oRqqZnxfRpzv3QNvXd8+Lf/ccCgDGJhJwnVTixrZwhwMInRDqLfJP6hkR6TxudFd2se
         svEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700005332; x=1700610132;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ZbzgmDszElKBJtPWUc8Ph/B7VdmlFSqeScykz2jDzY=;
        b=NgvYqDU5bq5n7XhNjEFbDFz4deDn91pofkyyLaCpuMBNb+Nj6sKTRLcDNSIhbEG1/5
         Wlq/2Dcr0P8CjjwGQgJyY5YjqZF7ISqHphm4/JUyJLR4dHLEQ9YzYgnJpcXz+jJ1iyRy
         nrk8MzanuigA2mM69rjQGsoXcVrL9LMYvnWBlBCBXFhLYVifgaa3JGNESM2aoJO2v9Py
         pJOHDncyouQRnkHGMVHqMsm/nbpQJfBl+3fWcfHC/7pxgtH6VKODl0yIvNOOLeWvunPS
         SUu0yJHCkmBWFUm+ytvqSZbFmyBHmmSeeV0o2mroVrmJDfgpH+84Q/xCdg4QZcTVqbJu
         15WA==
X-Gm-Message-State: AOJu0YxaggUDGviqxAOu7wPKxgOCq4AvjrBjTVjbJ8vUPXa/mSg3Iijv
        4+mCTjWjwaB3G6eQTYFyDr92yQ==
X-Google-Smtp-Source: AGHT+IEMU5uEboqrjkfjl6sIRD11H42WTjCpp1cVtnhbXOKu6saFfHG5ZFwo+c+q/Zd+vLkyz8d2Fw==
X-Received: by 2002:ac8:584c:0:b0:418:af4c:1853 with SMTP id h12-20020ac8584c000000b00418af4c1853mr4271847qth.25.1700005332044;
        Tue, 14 Nov 2023 15:42:12 -0800 (PST)
Received: from cs.cmu.edu (tunnel29655-pt.tunnel.tserv13.ash1.ipv6.he.net. [2001:470:7:582::2])
        by smtp.gmail.com with ESMTPSA id 3-20020ac85643000000b0041b9b6eb309sm3091835qtt.93.2023.11.14.15.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 15:42:11 -0800 (PST)
Date:   Tue, 14 Nov 2023 18:42:09 -0500
From:   Jan Harkes <jaharkes@cs.cmu.edu>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 09/15] fs: move file_start_write() into vfs_iter_write()
Message-ID: <20231114234209.f626le55r5if4fbp@cs.cmu.edu>
References: <20231114153254.1715969-1-amir73il@gmail.com>
 <20231114153254.1715969-10-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231114153254.1715969-10-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

That is a NACK for me.

Your change inverts lock ordering so that after your change we hold the
inode lock on the coda inode before we calls file_start_write.

See the comments for sb_start_write in include/linux/fs.h
(__sb_start_write is pretty much the only thing file_start_write calls).

 * Since freeze protection behaves as a lock, users have to preserve
 * ordering of freeze protection and other filesystem locks. Generally,
 * freeze protection should be the outermost lock. In particular, we
 * have:
 *
 * sb_start_write
 *   -> i_mutex                 (write path, truncate, directory ops,
 *   ...)
 *   -> s_umount                (freeze_super, thaw_super)

Jan


On Tue, Nov 14, 2023 at 05:32:48PM +0200, Amir Goldstein wrote:
...
> diff --git a/fs/coda/file.c b/fs/coda/file.c
> index 16acc58311ea..7c84555c8923 100644
> --- a/fs/coda/file.c
> +++ b/fs/coda/file.c
> @@ -79,14 +79,12 @@ coda_file_write_iter(struct kiocb *iocb, struct iov_iter *to)
>  	if (ret)
>  		goto finish_write;
>  
> -	file_start_write(host_file);
>  	inode_lock(coda_inode);
> -	ret = vfs_iter_write(cfi->cfi_container, to, &iocb->ki_pos, 0);
> +	ret = vfs_iter_write(host_file, to, &iocb->ki_pos, 0);
>  	coda_inode->i_size = file_inode(host_file)->i_size;
>  	coda_inode->i_blocks = (coda_inode->i_size + 511) >> 9;
>  	inode_set_mtime_to_ts(coda_inode, inode_set_ctime_current(coda_inode));
>  	inode_unlock(coda_inode);
> -	file_end_write(host_file);
>  
>  finish_write:
>  	venus_access_intent(coda_inode->i_sb, coda_i2f(coda_inode),
> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index 5d704461e3b4..35c9546b3396 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -1186,9 +1186,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
>  	since = READ_ONCE(file->f_wb_err);
>  	if (verf)
>  		nfsd_copy_write_verifier(verf, nn);
> -	file_start_write(file);
>  	host_err = vfs_iter_write(file, &iter, &pos, flags);
> -	file_end_write(file);
>  	if (host_err < 0) {
>  		commit_reset_write_verifier(nn, rqstp, host_err);
>  		goto out_nfserr;
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 131621daeb13..690b173f34fc 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -436,9 +436,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>  	if (is_sync_kiocb(iocb)) {
>  		rwf_t rwf = iocb_to_rw_flags(ifl);
>  
> -		file_start_write(real.file);
>  		ret = vfs_iter_write(real.file, iter, &iocb->ki_pos, rwf);
> -		file_end_write(real.file);
>  		/* Update size */
>  		ovl_file_modified(file);
>  	} else {
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 590ab228fa98..8cdc6e6a9639 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -846,7 +846,7 @@ ssize_t vfs_iter_read(struct file *file, struct iov_iter *iter, loff_t *ppos,
>  EXPORT_SYMBOL(vfs_iter_read);
>  
>  static ssize_t do_iter_write(struct file *file, struct iov_iter *iter,
> -		loff_t *pos, rwf_t flags)
> +			     loff_t *pos, rwf_t flags)
>  {
>  	size_t tot_len;
>  	ssize_t ret = 0;
> @@ -901,11 +901,18 @@ ssize_t vfs_iocb_iter_write(struct file *file, struct kiocb *iocb,
>  EXPORT_SYMBOL(vfs_iocb_iter_write);
>  
>  ssize_t vfs_iter_write(struct file *file, struct iov_iter *iter, loff_t *ppos,
> -		rwf_t flags)
> +		       rwf_t flags)
>  {
> +	int ret;
> +
>  	if (!file->f_op->write_iter)
>  		return -EINVAL;
> -	return do_iter_write(file, iter, ppos, flags);
> +
> +	file_start_write(file);
> +	ret = do_iter_write(file, iter, ppos, flags);
> +	file_end_write(file);
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL(vfs_iter_write);
>  
> -- 
> 2.34.1
> 
> 
