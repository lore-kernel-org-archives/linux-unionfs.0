Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5798FC433EF
	for <linux-unionfs@archiver.kernel.org>; Fri,  1 Apr 2022 20:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236460AbiDAUNs (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 1 Apr 2022 16:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351898AbiDAUNi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 1 Apr 2022 16:13:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F03502228C0
        for <linux-unionfs@vger.kernel.org>; Fri,  1 Apr 2022 13:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648843901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QAkqv//yUujEapGakh8kyJJBJBOKPdANJn/EPvBn5d4=;
        b=R7eP5xhOY5ykkCbFWumWTgnmZbnRRf9VwTvjMPorbJ4m5c/lUXo7qxus0jRMuHNiPh+qh6
        o9FIGHodAR6SDQZd00SSb20219VYi3nUA6McyzoFIci5qSa2a3j7zMGoP5UEUvG1TEFxE0
        1Vy5kZLjvs7h3QwCU4Tv/Lie2yvapzA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-19-Mq5vNS6pOaSt3-YzK4xF6Q-1; Fri, 01 Apr 2022 16:11:40 -0400
X-MC-Unique: Mq5vNS6pOaSt3-YzK4xF6Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 542F438035C7;
        Fri,  1 Apr 2022 20:11:39 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.32.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00BAF5E9129;
        Fri,  1 Apr 2022 20:11:38 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 99AF3220EFF; Fri,  1 Apr 2022 16:11:38 -0400 (EDT)
Date:   Fri, 1 Apr 2022 16:11:38 -0400
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
Subject: Re: [PATCH v3 17/19] ovl: handle idmappings in layer open helpers
Message-ID: <YkdcejL2Dtu6FjxJ@redhat.com>
References: <20220331112318.1377494-1-brauner@kernel.org>
 <20220331112318.1377494-18-brauner@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331112318.1377494-18-brauner@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Mar 31, 2022 at 01:23:15PM +0200, Christian Brauner wrote:
> In earlier patches we already passed down the relevant upper or lower
> path to ovl_open_realfile(). Now let the open helpers actually take the
> idmapping of the relevant mount into account when checking permissions.
> This is needed to support idmapped base layers with overlay.
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
>  fs/overlayfs/file.c | 7 +++++--
>  fs/overlayfs/util.c | 5 +++--
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 656c30bf20a6..7dd44f4e2757 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -42,6 +42,7 @@ static struct file *ovl_open_realfile(const struct file *file,
>  {
>  	struct inode *realinode = d_inode(realpath->dentry);
>  	struct inode *inode = file_inode(file);
> +	struct user_namespace *real_idmap;
>  	struct file *realfile;
>  	const struct cred *old_cred;
>  	int flags = file->f_flags | OVL_OPEN_FLAGS;
> @@ -51,12 +52,14 @@ static struct file *ovl_open_realfile(const struct file *file,
>  	if (flags & O_APPEND)
>  		acc_mode |= MAY_APPEND;
>  
> +
>  	old_cred = ovl_override_creds(inode->i_sb);
> -	err = inode_permission(&init_user_ns, realinode, MAY_OPEN | acc_mode);
> +	real_idmap = mnt_user_ns(realpath->mnt);
> +	err = inode_permission(real_idmap, realinode, MAY_OPEN | acc_mode);

Just a minor nit. Should we rename "real_idmap" to say "real_mnt_userns".
Becuase they are not idmaps. They are just pionters to user namespace
associated with that mount. And in all the vfs helpers you have used
the name "mnt_userns" anyway.

I see that downside is that name of the variable becomes longer. But
I feel "real_mnt_userns" bring more clarity while reading code.

Thanks
Vivek


>  	if (err) {
>  		realfile = ERR_PTR(err);
>  	} else {
> -		if (!inode_owner_or_capable(&init_user_ns, realinode))
> +		if (!inode_owner_or_capable(real_idmap, realinode))
>  			flags &= ~O_NOATIME;
>  
>  		realfile = open_with_fake_path(&file->f_path, flags, realinode,
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 79fae06ee10a..7dd2e5e6662a 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -523,6 +523,7 @@ bool ovl_is_whiteout(struct dentry *dentry)
>  struct file *ovl_path_open(struct path *path, int flags)
>  {
>  	struct inode *inode = d_inode(path->dentry);
> +	struct user_namespace *real_idmap = mnt_user_ns(path->mnt);
>  	int err, acc_mode;
>  
>  	if (flags & ~(O_ACCMODE | O_LARGEFILE))
> @@ -539,12 +540,12 @@ struct file *ovl_path_open(struct path *path, int flags)
>  		BUG();
>  	}
>  
> -	err = inode_permission(&init_user_ns, inode, acc_mode | MAY_OPEN);
> +	err = inode_permission(real_idmap, inode, acc_mode | MAY_OPEN);
>  	if (err)
>  		return ERR_PTR(err);
>  
>  	/* O_NOATIME is an optimization, don't fail if not permitted */
> -	if (inode_owner_or_capable(&init_user_ns, inode))
> +	if (inode_owner_or_capable(real_idmap, inode))
>  		flags |= O_NOATIME;
>  
>  	return dentry_open(path, flags, current_cred());
> -- 
> 2.32.0
> 

