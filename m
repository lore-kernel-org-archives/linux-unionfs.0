Return-Path: <vgoyal@redhat.com>
Date: Mon, 2 Apr 2018 13:34:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v13 17/28] ovl: During rename lock both source and target
 ovl_inode
Message-ID: <20180402173404.GE23306@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com>
 <20180329193854.13814-18-vgoyal@redhat.com>
 <CAOQ4uxg8gk+StKLhwa7Zx2doKTbTO+iAhmgU4BOFDOCE1=BAMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg8gk+StKLhwa7Zx2doKTbTO+iAhmgU4BOFDOCE1=BAMw@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Mar 30, 2018 at 09:50:53AM +0300, Amir Goldstein wrote:
> On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > In some cases we need to take both source (old) and target(new) dentry
> > ovl_inode->lock. This patch adds support for that. Locks are taken in
> > order of increasing inode address to avoid deadlock. This code has been
> > taken from lock_two_nondirectories().
> >
> > As of now, metacopy needs this lock if we are planning to update redirect
> > information on source/target ovl_inode. nlink related accounting takes this
> > lock on target for the case of overwrite.
> >
> 
> This is very over complicated.
> 
> Here is how this could be simplified.
> 
> Setting redirects does NOT need to happen under all the complicated rename
> locks. Settings redirects can happen completely before everything else
> because it is harmless to set redirect and not rename afterwards.

hmm..., So basically set redirects before doing lock_rename(new_upperdir,
old_upperdir). I guess even before ovl_set_nlink_start() takes inode
lock. That way we don't have to hold two inode locks together and
we should be able to take one inode lock at a time, set redirect and
release lock.

I spent some time thinking if I can spot anything obviously wrong
but could not find anything. So I will try to implement this. If
this works, I like the idea of simplifying the locking a bit. Right
now trying to take two inode locks makes it complicated.

Vivek
> 
> I would split out a helper ovl_rename_prep() it can also take care of
> copy ups and check ovl_can_rename() and then set redirect if needed
> on old and/or new locking them one at a time.
> You can take the ovl_inode->lock inside ovl_set_redirect() and you can also
> override credentials or whatever is needed due to moving set redirect
> earlier.

> 
> You probably don't need all the nlink_start re-factoring with this change.
> 
> Thanks,
> Amir.
