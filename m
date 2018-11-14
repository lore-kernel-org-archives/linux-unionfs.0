Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42432 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbeKOA3J (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Nov 2018 19:29:09 -0500
Date: Wed, 14 Nov 2018 09:25:41 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: overlayfs 4.19: unable to make backup link: Invalid cross-device
 link
Message-ID: <20181114142541.GB29804@redhat.com>
References: <20181027200450.GA5909@thunk.org>
 <CAJfpegtCYkXiSYtw4dWGc=Fj2U3GaWiOiub+JmZ8pRXHNk4ERQ@mail.gmail.com>
 <20181029220404.GB15839@thunk.org>
 <CAOQ4uxiu6iS-VuEtPhequVp7Ukx7Kh0FUpECSXfkaZN==o7sJw@mail.gmail.com>
 <CAOQ4uxjsfgfo3rXtFKQk4A_fU2tvo38GFhzz7H9h1+R4trjd6Q@mail.gmail.com>
 <CAJfpeguV6Dwkm-CJieHKZWYK=uw3BYx9nW17KAs8uNJptmnchA@mail.gmail.com>
 <CACTyJpCx7y-5OOhk0P8ETQwp4_n-a1W1Dmc-1dHeE6j_cvdk7A@mail.gmail.com>
 <CAOQ4uxjRGpwGou3+BNUvMV6bCx8ysTyEESOR9RVY4Nc2QvkJjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjRGpwGou3+BNUvMV6bCx8ysTyEESOR9RVY4Nc2QvkJjg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Maciej =?utf-8?B?WmnEmWJh?= <maciekz82@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Theodore Tso <tytso@mit.edu>, Mark Salyzyn <salyzyn@android.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Nov 14, 2018 at 02:09:01PM +0200, Amir Goldstein wrote:

[..]
> Vivek, Mark,
> 
> Either of you care to implement dropping privileges for the duration
> of unionmount-testsuite test cases (in between mounts and unmounts)?

Hi Amir,

I think it will be good to drop priviliges while running
unionmount-testsuite.

BTW, docker build used to run as root/priviliged user. Is that not the case
anymore? Why did it fail to begin with.

Thanks
Vivek

> 
> Thanks,
> Amir.
> 
> ---
> 
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index c6289147c787..82c129bfe58d 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -651,6 +651,18 @@ static int ovl_symlink(struct inode *dir, struct
> dentry *dentry,
>         return ovl_create_object(dentry, S_IFLNK, 0, link);
>  }
> 
> +static int ovl_set_link_redirect(struct dentry *dentry)
> +{
> +       const struct cred *old_cred;
> +       int err;
> +
> +       old_cred = ovl_override_creds(dentry->d_sb);
> +       err = ovl_set_redirect(dentry, false);
> +       revert_creds(old_cred);
> +
> +       return err;
> +}
> +
>  static int ovl_link(struct dentry *old, struct inode *newdir,
>                     struct dentry *new)
>  {
> @@ -670,7 +682,7 @@ static int ovl_link(struct dentry *old, struct
> inode *newdir,
>                 goto out_drop_write;
> 
>         if (ovl_is_metacopy_dentry(old)) {
> -               err = ovl_set_redirect(old, false);
> +               err = ovl_set_link_redirect(old);
>                 if (err)
>                         goto out_drop_write;
>         }
