Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B40AEC6FA82
	for <linux-unionfs@archiver.kernel.org>; Fri, 23 Sep 2022 15:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbiIWPAS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 11:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbiIWPAI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 23 Sep 2022 11:00:08 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E3E2BEF
        for <linux-unionfs@vger.kernel.org>; Fri, 23 Sep 2022 07:59:55 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id r18so1215874eja.11
        for <linux-unionfs@vger.kernel.org>; Fri, 23 Sep 2022 07:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=mQ2SPM0vQtguYDeNuedTCVLMxjUh7J4gP69et6Pl3Q0=;
        b=hcR754jQ1MowjeiaNS3sauPoo5maN8sn5LAT2ctZMP8jOR0IyWTLj+qhIcC4V+M/+t
         0SALhYW0NYHmkKN/dSTlXHKZlgCFEUAsIHC6qduv++StlYuIZj0maStTlQPhqcS1jbW2
         52ZlSlXHfCE9idAyHDe4/VszRdXReKQJX/340=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=mQ2SPM0vQtguYDeNuedTCVLMxjUh7J4gP69et6Pl3Q0=;
        b=TDFvYMAbf+PacMBGguXtCUO8ar1lM2B3JFpn1drA1J2+9GtGzPAnORQYI3BwDbsW00
         ny0ME3oeRKJzMZt6KNh0vEYAqQKYpjgcrYIHFFhMRcIKTNCF0mDoRf8777yF4oeQEPLi
         ALM0mV1XXh6wBk+Ov69WZuvoN2ZcZCDvLmKV0GzktwfmGii5zaZofn7cdTwijyC1FlLq
         ZPVyXRDX/SYKSCJ2oC+Oc90i7sNqcKEpuPpcSsbbxo2KVmiOtXaEcr8GqiSD2JbX7/FY
         iI87SZDKHY7L+GvZDFVSVlNbTpkxVzS+6SzaL4IxcUekVURlcL1TS0CvoHUtm+KtNNC1
         Guyg==
X-Gm-Message-State: ACrzQf2Z8CzEzhMpQxslByySyupx9hF8xP7yyHRargRdAKLhYv5Z+hRi
        doGK08RpTGqzDU1WL2nBuzYoV5rwO/8MWt7PpkJhxg==
X-Google-Smtp-Source: AMsMyM4RiLftSkJXu68h8CtUe+3nEWg3TS7pyNY1i3NDGSCCuB2UmBaDbDk++ONzGyROid7xQ6zjgl4foXH2q0U2p8c=
X-Received: by 2002:a17:907:62a1:b0:781:b320:90c0 with SMTP id
 nd33-20020a17090762a100b00781b32090c0mr7081371ejc.255.1663945193889; Fri, 23
 Sep 2022 07:59:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220922151728.1557914-1-brauner@kernel.org> <20220922151728.1557914-22-brauner@kernel.org>
In-Reply-To: <20220922151728.1557914-22-brauner@kernel.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 23 Sep 2022 16:59:42 +0200
Message-ID: <CAJfpegu0xgSuvcY9zwEMDsb9PC3_AYPXvvE61fdHYEssVSf-tA@mail.gmail.com>
Subject: Re: [PATCH 21/29] ovl: implement get acl method
To:     Christian Brauner <brauner@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, Seth Forshee <sforshee@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 22 Sept 2022 at 17:18, Christian Brauner <brauner@kernel.org> wrote:
>
> The current way of setting and getting posix acls through the generic
> xattr interface is error prone and type unsafe. The vfs needs to
> interpret and fixup posix acls before storing or reporting it to
> userspace. Various hacks exist to make this work. The code is hard to
> understand and difficult to maintain in it's current form. Instead of
> making this work by hacking posix acls through xattr handlers we are
> building a dedicated posix acl api around the get and set inode
> operations. This removes a lot of hackiness and makes the codepaths
> easier to maintain. A lot of background can be found in [1].
>
> In order to build a type safe posix api around get and set acl we need
> all filesystem to implement get and set acl.
>
> Now that we have added get and set acl inode operations that allow easy
> access to the dentry we give overlayfs it's own get and set acl inode
> operations.
>
> Since overlayfs is a stacking filesystem it will use the newly added
> posix acl api when retrieving posix acls from the relevant layer.
>
> Since overlayfs can also be mounted on top of idmapped layers. If
> idmapped layers are used overlayfs must take the layer's idmapping into
> account after it retrieved the posix acls from the relevant layer.
>
> Note, until the vfs has been switched to the new posix acl api this
> patch is a non-functional change.
>
> Link: https://lore.kernel.org/all/20220801145520.1532837-1-brauner@kernel.org [1]
> Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> ---
>  fs/overlayfs/dir.c       |  3 +-
>  fs/overlayfs/inode.c     | 63 ++++++++++++++++++++++++++++++++++++----
>  fs/overlayfs/overlayfs.h | 10 +++++--
>  3 files changed, 67 insertions(+), 9 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 7bece7010c00..eb49d5d7b56f 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -1311,7 +1311,8 @@ const struct inode_operations ovl_dir_inode_operations = {
>         .permission     = ovl_permission,
>         .getattr        = ovl_getattr,
>         .listxattr      = ovl_listxattr,
> -       .get_inode_acl  = ovl_get_acl,
> +       .get_inode_acl  = ovl_get_inode_acl,
> +       .get_acl        = ovl_get_acl,
>         .update_time    = ovl_update_time,
>         .fileattr_get   = ovl_fileattr_get,
>         .fileattr_set   = ovl_fileattr_set,
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index ecb51c249466..dd11e13cd288 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -14,6 +14,8 @@
>  #include <linux/fileattr.h>
>  #include <linux/security.h>
>  #include <linux/namei.h>
> +#include <linux/posix_acl.h>
> +#include <linux/posix_acl_xattr.h>
>  #include "overlayfs.h"
>
>
> @@ -460,9 +462,9 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
>   * of the POSIX ACLs retrieved from the lower layer to this function to not
>   * alter the POSIX ACLs for the underlying filesystem.
>   */
> -static void ovl_idmap_posix_acl(struct inode *realinode,
> -                               struct user_namespace *mnt_userns,
> -                               struct posix_acl *acl)
> +void ovl_idmap_posix_acl(struct inode *realinode,
> +                        struct user_namespace *mnt_userns,
> +                        struct posix_acl *acl)
>  {
>         struct user_namespace *fs_userns = i_user_ns(realinode);
>
> @@ -495,7 +497,7 @@ static void ovl_idmap_posix_acl(struct inode *realinode,
>   *
>   * This is obviously only relevant when idmapped layers are used.
>   */
> -struct posix_acl *ovl_get_acl(struct inode *inode, int type, bool rcu)
> +struct posix_acl *ovl_get_inode_acl(struct inode *inode, int type, bool rcu)
>  {
>         struct inode *realinode = ovl_inode_real(inode);
>         struct posix_acl *acl, *clone;
> @@ -547,6 +549,53 @@ struct posix_acl *ovl_get_acl(struct inode *inode, int type, bool rcu)
>         posix_acl_release(acl);
>         return clone;
>  }
> +
> +static struct posix_acl *ovl_get_acl_path(const struct path *path,
> +                                         const char *acl_name)
> +{
> +       struct posix_acl *real_acl, *clone;
> +       struct user_namespace *mnt_userns;
> +
> +       mnt_userns = mnt_user_ns(path->mnt);
> +
> +       real_acl = vfs_get_acl(mnt_userns, path->dentry, acl_name);
> +       if (IS_ERR(real_acl))
> +               return real_acl;
> +       if (!real_acl)
> +               return NULL;

if (IS_ERR_OR_NULL(real_acl))
    return real_acl;

> +
> +       if (!is_idmapped_mnt(path->mnt))
> +               return real_acl;
> +
> +       /*
> +        * We cannot alter the ACLs returned from the relevant layer as that
> +        * would alter the cached values filesystem wide for the lower
> +        * filesystem. Instead we can clone the ACLs and then apply the
> +        * relevant idmapping of the layer.
> +        */

Can't vfs_get_acl() return 'const posix_acl *' to enforce that?

Thanks,
Miklos
