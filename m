From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH 03/13] ovl: lookup redirect by file handle
Date: Tue, 18 Apr 2017 09:05:54 -0400
Message-ID: <20170418130554.GB9056@redhat.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
 <1492387183-18847-4-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41892 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753358AbdDRNGC (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Apr 2017 09:06:02 -0400
Content-Disposition: inline
In-Reply-To: <1492387183-18847-4-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Apr 17, 2017 at 02:59:33AM +0300, Amir Goldstein wrote:

[..]
> @@ -272,6 +385,33 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>  			goto out_put_upper;
>  	}
>  
> +	/* Try to lookup lower layers by file handle (at root) */
> +	d.by_path = false;
> +	for (i = 0; !d.stop && d.fh && i < roe->numlower; i++) {
> +		struct path lowerpath = roe->lowerstack[i];
> +
> +		d.last = i == roe->numlower - 1;
> +		err = ovl_lookup_layer_fh(&lowerpath, &d, &this);
> +		if (err)
> +			goto out_put;
> +
> +		if (!this)
> +			continue;
> +
> +		stack[ctr].dentry = this;
> +		stack[ctr].mnt = lowerpath.mnt;
> +		ctr++;
> +	}
> +
> +	/* Fallback to lookup lower layers by name (at parent) */
> +	if (ctr) {
> +		d.stop = true;

Hi Amir,

Got a very basic question. So say I two lower layers and a directory is
in present in both, say lower1/dir1 and lower2/dir1. Now this directory
gets copied up to upper/dir1. Assume lower1/dir1 is being copied up. So
upper/dir1 will save file handle of lower1/dir1 right? This file handle
does not represent lower2/dir1?

IOW, later when I am doing lookup, then using file handle I will find
dentry of lower1/dir1 but not lower2/dir1. And looks like we will not
path based lookup as ctr will be non-zero (as we found one dentry in
one path).

What am I missing.

(This ovl_lookup() logic has become really twisted now. I wished it was
 little easier to read.)

Vivek
