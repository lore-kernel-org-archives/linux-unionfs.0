Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE6FFEB64D9
	for <linux-unionfs@archiver.kernel.org>; Thu, 15 Jun 2023 04:24:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbjFOEYa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 00:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237640AbjFOEY2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 15 Jun 2023 00:24:28 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AF6212B;
        Wed, 14 Jun 2023 21:24:28 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8E37D67373; Thu, 15 Jun 2023 06:24:24 +0200 (CEST)
Date:   Thu, 15 Jun 2023 06:24:24 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@lst.de>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v4 1/2] fs: use backing_file container for internal
 files with "fake" f_path
Message-ID: <20230615042424.GA4508@lst.de>
References: <20230614074907.1943007-1-amir73il@gmail.com> <20230614074907.1943007-2-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614074907.1943007-2-amir73il@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 14, 2023 at 10:49:06AM +0300, Amir Goldstein wrote:
> +static struct file *__alloc_file(int flags, const struct cred *cred)
> +{
> +	struct file *f;
> +	int error;
> +
> +	f = kmem_cache_zalloc(filp_cachep, GFP_KERNEL);
> +	if (unlikely(!f))
> +		return ERR_PTR(-ENOMEM);
> +
> +	error = init_file(f, flags, cred);
> +	if (unlikely(error))
> +		return ERR_PTR(error);
> +
>  	return f;

Nit: is there much of a point in keeping this now very trivial helper
instead of open coding it in the two callers?

> +/*
> + * Variant of alloc_empty_file() that allocates a backing_file container
> + * and doesn't check and modify nr_files.
> + *
> + * Should not be used unless there's a very good reason to do so.

I'm not sure this comment is all that helpful..  I'd rather explain
when it should be used (i.e. only from open_backing_file) then when
it should not..

> -struct file *open_with_fake_path(const struct path *path, int flags,
> -				struct inode *inode, const struct cred *cred)
> +struct file *open_backing_file(const struct path *path, int flags,
> +			       const struct path *real_path,
> +			       const struct cred *cred)

Please write a big fat comment on where this function should and should
not be used and how it works.

> +struct path *backing_file_real_path(struct file *f);
> +static inline const struct path *f_real_path(struct file *f)
> +{
> +	if (unlikely(f->f_mode & FMODE_BACKING))
> +		return backing_file_real_path(f);
> +	else
> +		return &f->f_path;
> +}

Nit: no need for the else here.
