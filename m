Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B5DFC433EF
	for <linux-unionfs@archiver.kernel.org>; Fri,  1 Apr 2022 18:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbiDASvh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 1 Apr 2022 14:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346038AbiDASvg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 1 Apr 2022 14:51:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A3AF140922
        for <linux-unionfs@vger.kernel.org>; Fri,  1 Apr 2022 11:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648838985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7zK+cqxX1NH/vq28td1ArqUWzD7S4m0D3iu5nz+/VTY=;
        b=TAPPSw6IFlzEY/dM/zdXjIMFK43iATj5vdnIp7ReEM7yOlYZ7iKl5Kp47YaBxlTG3WeeQh
        zQeJQ358HcbXd/sfiKukvpmMMZFIa6XFCJVdH8dEj77vwW2cb+sOrtx0niCUibTxn4V8ob
        hmKDegFsS4//CFDGGcnFP4C68PN47js=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-kVohW_MdO6yybW2lJ52lmg-1; Fri, 01 Apr 2022 14:49:39 -0400
X-MC-Unique: kVohW_MdO6yybW2lJ52lmg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EF5F86B8A3;
        Fri,  1 Apr 2022 18:49:39 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.32.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C698A5E9101;
        Fri,  1 Apr 2022 18:49:38 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 3F110220EFF; Fri,  1 Apr 2022 14:49:38 -0400 (EDT)
Date:   Fri, 1 Apr 2022 14:49:38 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-unionfs@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>
Subject: Re: [PATCH v3 09/19] ovl: use ovl_do_notify_change() wrapper
Message-ID: <YkdJQp7cEYeWODnX@redhat.com>
References: <20220331112318.1377494-1-brauner@kernel.org>
 <20220331112318.1377494-10-brauner@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331112318.1377494-10-brauner@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Mar 31, 2022 at 01:23:07PM +0200, Christian Brauner wrote:
> Introduce ovl_do_notify_change() as a simple wrapper around
> notify_change() to support idmapped layers. The helper mirrors other
> ovl_do_*() helpers that operate on the upper layers.
> 
> When changing ownership of an upper object the intended ownership needs
> to be mapped according to the upper layer's idmapping. This mapping is
> the inverse to the mapping applied when copying inode information from
> an upper layer to the corresponding overlay inode. So e.g., when an
> upper mount maps files that are stored on-disk as owned by id 1001 to
> 1000 this means that calling stat on this object from an idmapped mount
> will report the file as being owned by id 1000. Consequently in order to
> change ownership of an object in this filesystem so it appears as being
> owned by id 1000 in the upper idmapped layer it needs to store id 1001
> on disk. The mnt mapping helpers take care of this.
> 
> All idmapping helpers are nops when no idmapped base layers are used.
> 
> Cc: <linux-unionfs@vger.kernel.org>
> Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> ---
> /* v2 */
> unchanged
> 
> /* v3 */
> unchanged
> ---
>  fs/overlayfs/copy_up.c   |  8 ++++----
>  fs/overlayfs/dir.c       |  2 +-
>  fs/overlayfs/inode.c     |  3 ++-
>  fs/overlayfs/overlayfs.h | 27 +++++++++++++++++++++++++++
>  fs/overlayfs/super.c     |  2 +-
>  5 files changed, 35 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 2c336acb2ba0..a5d68302693f 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -301,7 +301,7 @@ static int ovl_set_size(struct ovl_fs *ofs,
>  		.ia_size = stat->size,
>  	};
>  
> -	return notify_change(&init_user_ns, upperdentry, &attr, NULL);
> +	return ovl_do_notify_change(ofs, upperdentry, &attr);
>  }
>  
>  static int ovl_set_timestamps(struct ovl_fs *ofs, struct dentry *upperdentry,
> @@ -314,7 +314,7 @@ static int ovl_set_timestamps(struct ovl_fs *ofs, struct dentry *upperdentry,
>  		.ia_mtime = stat->mtime,
>  	};
>  
> -	return notify_change(&init_user_ns, upperdentry, &attr, NULL);
> +	return ovl_do_notify_change(ofs, upperdentry, &attr);
>  }
>  
>  int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upperdentry,
> @@ -327,7 +327,7 @@ int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upperdentry,
>  			.ia_valid = ATTR_MODE,
>  			.ia_mode = stat->mode,
>  		};
> -		err = notify_change(&init_user_ns, upperdentry, &attr, NULL);
> +		err = ovl_do_notify_change(ofs, upperdentry, &attr);
>  	}
>  	if (!err) {
>  		struct iattr attr = {
> @@ -335,7 +335,7 @@ int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upperdentry,
>  			.ia_uid = stat->uid,
>  			.ia_gid = stat->gid,
>  		};
> -		err = notify_change(&init_user_ns, upperdentry, &attr, NULL);
> +		err = ovl_do_notify_change(ofs, upperdentry, &attr);
>  	}
>  	if (!err)
>  		ovl_set_timestamps(ofs, upperdentry, stat);
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 27a40b6754f4..9ae0352ff52a 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -516,7 +516,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
>  			.ia_mode = cattr->mode,
>  		};
>  		inode_lock(newdentry->d_inode);
> -		err = notify_change(&init_user_ns, newdentry, &attr, NULL);
> +		err = ovl_do_notify_change(ofs, newdentry, &attr);
>  		inode_unlock(newdentry->d_inode);
>  		if (err)
>  			goto out_cleanup;
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index c51a9dd36cc7..9a8e6b94d9e8 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -21,6 +21,7 @@ int ovl_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
>  		struct iattr *attr)
>  {
>  	int err;
> +	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
>  	bool full_copy_up = false;
>  	struct dentry *upperdentry;
>  	const struct cred *old_cred;
> @@ -77,7 +78,7 @@ int ovl_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
>  
>  		inode_lock(upperdentry->d_inode);
>  		old_cred = ovl_override_creds(dentry->d_sb);
> -		err = notify_change(&init_user_ns, upperdentry, attr, NULL);
> +		err = ovl_do_notify_change(ofs, upperdentry, attr);
>  		revert_creds(old_cred);
>  		if (!err)
>  			ovl_copyattr(upperdentry->d_inode, dentry->d_inode);
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 816a69b46b67..c1f4ff0553b5 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -122,6 +122,33 @@ static inline const char *ovl_xattr(struct ovl_fs *ofs, enum ovl_xattr ox)
>  	return ovl_xattr_table[ox][ofs->config.userxattr];
>  }
>  
> +/*
> + * When changing ownership of an upper object map the intended ownership
> + * according to the upper layer's idmapping. When an upper mount idmaps files
> + * that are stored on-disk as owned by id 1001 to id 1000 this means stat on
> + * this object will report it as being owned by id 1000 when calling stat via
> + * the upper mount.
> + * In order to change ownership of an object so stat reports id 1000 when
> + * called on an idmapped upper mount the value written to disk - i.e., the
> + * value stored in ia_*id - must 1001. The mount mapping helper will thus take
> + * care to map 1000 to 1001.
> + * The mnt idmapping helpers are nops if the upper layer isn't idmapped.

Hi Christian,

Trying to understand the code with above example where upper has been
idmapped to map on disk id 1001 to 1000. My understanding is very 
primitive, so most likely i have very obvious questions.

Given notify_change() takes "mnt_userns" as a parameter, I assumed
that notify_change() will map 1000 to 1001 instead. Looks like
that's not the case. Instead calling filesystem needs to map it
before calling notify_change().

.
> + */
> +static inline int ovl_do_notify_change(struct ovl_fs *ofs,
> +				       struct dentry *upperdentry,
> +				       struct iattr *attr)
> +{
> +	struct user_namespace *upper_idmap = ovl_upper_idmap(ofs);
> +	struct user_namespace *fs_idmap = i_user_ns(d_inode(upperdentry));
> +
> +	if (attr->ia_valid & ATTR_UID)
> +		attr->ia_uid = mapped_kuid_user(upper_idmap, fs_idmap, attr->ia_uid);
> +	if (attr->ia_valid & ATTR_GID)
> +		attr->ia_gid = mapped_kgid_user(upper_idmap, fs_idmap, attr->ia_gid);

Another thing which I don't understand is fs_idmap and its relation with
upper_idmap. 

IIUC, fs_idmap is upper dir's filesystem subper block's namespace. That
should be init_user_ns until and unless filesystem allows unprivileged
mounting from inside a namespace. Is that correct?

So effectively what we are doing is two translations. A filesystem, 
mounted unprivliged, and then idmapped mount created and used as
upper. And then somehow we are doing translations both for idmapped
mounts and fs_idmap?

If you can shed some light on this, that will help a lot.

Thanks
Vivek

> +
> +	return notify_change(upper_idmap, upperdentry, attr, NULL);



> +}
> +
>  static inline int ovl_do_rmdir(struct ovl_fs *ofs,
>  			       struct inode *dir, struct dentry *dentry)
>  {
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index f1deb84aebcf..2cc27e707cb3 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -821,7 +821,7 @@ static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
>  
>  		/* Clear any inherited mode bits */
>  		inode_lock(work->d_inode);
> -		err = notify_change(&init_user_ns, work, &attr, NULL);
> +		err = ovl_do_notify_change(ofs, work, &attr);
>  		inode_unlock(work->d_inode);
>  		if (err)
>  			goto out_dput;
> -- 
> 2.32.0
> 

