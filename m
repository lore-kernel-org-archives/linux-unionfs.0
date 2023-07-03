Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E815AC001B3
	for <linux-unionfs@archiver.kernel.org>; Mon,  3 Jul 2023 19:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjGCT3z (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 3 Jul 2023 15:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjGCT3y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 3 Jul 2023 15:29:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F04FE52
        for <linux-unionfs@vger.kernel.org>; Mon,  3 Jul 2023 12:29:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F10FA60FE9
        for <linux-unionfs@vger.kernel.org>; Mon,  3 Jul 2023 19:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31893C433C7;
        Mon,  3 Jul 2023 19:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688412592;
        bh=86wsLWTQHzAGsEiZPjWt8DXZlD0a/NMAtvUA3aAvf3Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oi8iPQ9coOy/ztrZmSJGH4axVZhxw0e+wgvSp9LmFswD9SbnqxAAijzG/R6eP+VIe
         Ce/TTk0d7avSDZSpGmrQbwR3KFBJH11+oo0hPS2FZ+3yNaovL8f6nnbedj3GtDV6Lt
         vi101SRnIOIcsErx6yWM0DmnEipX/elriOuZuzmXZNqIOH18ia7sdsgdcVvPyMdo74
         HF+nQjXmCAAn2T4ByoDmBS3RjRG8rJ1xBjemOZatJ53grhBqzB2KRTrGmM0MAleRZK
         wkm/4bKLnMSfvjEYgs1+BqtGHZ6zW6ROItp3wzvV+VNllMsCxrpyYqunGlOCDChqhG
         qhfRw4RDadWpw==
Date:   Mon, 3 Jul 2023 12:29:50 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com, tytso@mit.edu, fsverity@lists.linux.dev
Subject: Re: [PATCH v4 4/4] ovl: Handle verity during copy-up
Message-ID: <20230703192950.GE1194@sol.localdomain>
References: <cover.1687345663.git.alexl@redhat.com>
 <8771725be2a8b7d65ea6c50a69bb6392b9e903aa.1687345663.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8771725be2a8b7d65ea6c50a69bb6392b9e903aa.1687345663.git.alexl@redhat.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 21, 2023 at 01:18:28PM +0200, Alexander Larsson wrote:
> During regular metacopy, if lowerdata file has fs-verity enabled, and
> the verity option is enabled, we add the digest to the metacopy xattr.
> 
> If verity is required, and lowerdata does not have fs-verity enabled,
> fall back to full copy-up (or the generated metacopy would not
> validate).
> 
> Signed-off-by: Alexander Larsson <alexl@redhat.com>
> ---
>  fs/overlayfs/copy_up.c   | 45 ++++++++++++++++++++++++++++++++++++++--
>  fs/overlayfs/overlayfs.h |  3 +++
>  fs/overlayfs/util.c      | 33 ++++++++++++++++++++++++++++-
>  3 files changed, 78 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 68f01fd7f211..fce7d048673c 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -544,6 +544,7 @@ struct ovl_copy_up_ctx {
>  	bool origin;
>  	bool indexed;
>  	bool metacopy;
> +	bool metacopy_digest;
>  };
>  
>  static int ovl_link_up(struct ovl_copy_up_ctx *c)
> @@ -641,8 +642,21 @@ static int ovl_copy_up_metadata(struct ovl_copy_up_ctx *c, struct dentry *temp)
>  	}
>  
>  	if (c->metacopy) {
> -		err = ovl_check_setxattr(ofs, temp, OVL_XATTR_METACOPY,
> -					 NULL, 0, -EOPNOTSUPP);
> +		struct path lowerdatapath;
> +		struct ovl_metacopy metacopy_data = OVL_METACOPY_INIT;
> +
> +		ovl_path_lowerdata(c->dentry, &lowerdatapath);
> +		if (WARN_ON_ONCE(lowerdatapath.dentry == NULL))
> +			err = -EIO;
> +		else
> +			err = ovl_set_verity_xattr_from(ofs, &lowerdatapath, &metacopy_data);

There's no dedicated verity xattr anymore, so maybe ovl_set_verity_xattr_from()
should be renamed to something like ovl_get_verity_digest().

> +
> +		if (metacopy_data.digest_algo)
> +			c->metacopy_digest = true;
> +
> +		if (!err)
> +			err = ovl_set_metacopy_xattr(ofs, temp, &metacopy_data);
> +
>  		if (err)
>  			return err;

The error handling above is a bit weird.  Some early returns would make it
easier to read:

		ovl_path_lowerdata(c->dentry, &lowerdatapath);
		if (WARN_ON_ONCE(lowerdatapath.dentry == NULL))
			return -EIO;
		err = ovl_get_verity_digest(ofs, &lowerdatapath, &metacopy_data);
		if (err)
			return err;

		if (metacopy_data.digest_algo)
			c->metacopy_digest = true;

		err = ovl_set_metacopy_xattr(ofs, temp, &metacopy_data);
		if (err)
			return err;

>  	}
> @@ -751,6 +765,12 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
>  	if (err)
>  		goto cleanup;
>  
> +	if (c->metacopy_digest)
> +		ovl_set_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
> +	else
> +		ovl_clear_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
> +	ovl_clear_flag(OVL_VERIFIED_DIGEST, d_inode(c->dentry));
> +
>  	if (!c->metacopy)
>  		ovl_set_upperdata(d_inode(c->dentry));
>  	inode = d_inode(c->dentry);

Maybe the line 'inode = d_inode(c->dentry);' should be moved earlier, and then
'inode' used instead of 'd_inode(c->dentry)' later on.

> +	if (ofs->config.verity_mode == OVL_VERITY_REQUIRE) {
> +		struct path lowerdata;
> +
> +		ovl_path_lowerdata(dentry, &lowerdata);
> +
> +		if (WARN_ON_ONCE(lowerdata.dentry == NULL) ||
> +		    ovl_ensure_verity_loaded(&lowerdata) ||
> +		    !fsverity_get_info(d_inode(lowerdata.dentry))) {
> +			return false;

Please use !fsverity_active() instead of !fsverity_get_info().

- Eric
