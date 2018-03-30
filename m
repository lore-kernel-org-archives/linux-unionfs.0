Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180329193854.13814-18-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com> <20180329193854.13814-18-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 30 Mar 2018 09:50:53 +0300
Message-ID: <CAOQ4uxg8gk+StKLhwa7Zx2doKTbTO+iAhmgU4BOFDOCE1=BAMw@mail.gmail.com>
Subject: Re: [PATCH v13 17/28] ovl: During rename lock both source and target ovl_inode
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> In some cases we need to take both source (old) and target(new) dentry
> ovl_inode->lock. This patch adds support for that. Locks are taken in
> order of increasing inode address to avoid deadlock. This code has been
> taken from lock_two_nondirectories().
>
> As of now, metacopy needs this lock if we are planning to update redirect
> information on source/target ovl_inode. nlink related accounting takes this
> lock on target for the case of overwrite.
>

This is very over complicated.

Here is how this could be simplified.

Setting redirects does NOT need to happen under all the complicated rename
locks. Settings redirects can happen completely before everything else
because it is harmless to set redirect and not rename afterwards.

I would split out a helper ovl_rename_prep() it can also take care of
copy ups and check ovl_can_rename() and then set redirect if needed
on old and/or new locking them one at a time.
You can take the ovl_inode->lock inside ovl_set_redirect() and you can also
override credentials or whatever is needed due to moving set redirect
earlier.

You probably don't need all the nlink_start re-factoring with this change.

Thanks,
Amir.
