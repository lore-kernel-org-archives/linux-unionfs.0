From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [POC/RFC PATCH] overlayfs: constant inode numbers
Date: Wed, 30 Nov 2016 17:05:25 +0200
Message-ID: <CAOQ4uxjX=ewaCPjTUmvyynpZAwE1g_qf-+nE05zz5OFq99f+kw@mail.gmail.com>
References: <20161125212934.GB2622@veci.piliscsaba.szeredi.hu>
 <CAOQ4uxgSvo_v37aLJb8FK3c5sDqCkN2XWOd783UXaomdVAvsEQ@mail.gmail.com>
 <CAOQ4uxi2Ko-G2nA_bSWT8juuss9aS9ZfiBWS95RrdfBy30Tozg@mail.gmail.com>
 <CAOQ4uxjAODFk2L7d9P+br8wOY9NW5qKH3aaRC=umBfCGPeyxkg@mail.gmail.com>
 <CAJfpegvrRF7ZS+Shx6Q8L2BsbYpX3x3UEXkPn=3oEWs2zMP+eA@mail.gmail.com>
 <CAOQ4uxgSHah2OpbgW2nrDXjwXob=_ypjz9dbmHUO-1QrfwooXg@mail.gmail.com>
 <CAJfpeguTp4AwcnouMAse1=seG=LboW68eNfRjMiEpeaBjxuYQQ@mail.gmail.com>
 <CAOQ4uxhzRkPM6aOkksMsKU1V6tdsUxhObAD938PEUPKYPp6B5Q@mail.gmail.com>
 <CAOQ4uxj2yMwY_eCdc0+6U0QP1ckm5aPw5x6xtMz+WdHvJ4bFTg@mail.gmail.com> <CAJfpegtRNQAebLbz2F2zV8asqt31m7Lrgc+ya28UZU1e8E1oEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34361 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933648AbcK3PF2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 30 Nov 2016 10:05:28 -0500
In-Reply-To: <CAJfpegtRNQAebLbz2F2zV8asqt31m7Lrgc+ya28UZU1e8E1oEw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, Nov 29, 2016 at 11:49 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Nov 29, 2016 at 1:03 PM, Amir Goldstein <amir73il@gmail.com> wrote:
...
> I meant that we can unify OVL_XATTR_INO  with "redirect/fh"
> functionality and get something good out of it.
>
>> Perhaps you meant for non-dir:
>>
>> 5. If redirect_dir=fh, *propagate* lowest-handle on non-dir copy up
>> 6. In ovl_lookup() of non-dir, decode lowest-handle to set oe->ino
>
> Yes.
>
> OVL_XATTR_FH would be safe to ignore, so this is back and forward
> compatible..  And the cost is probably not prohitive, since copy ups
> should be relatively rare.
>
> After a backup + restore it is not expected that we get back the old
> inode numbers so it's fine to ignore the stale file handles.
>

FYI, there are 2 interesting corner case of "semi stale" handles:
- Copy of layers to same fs (without deleting old layers)
- Old layers are deleted but an old deleted file is still open

I have handled both these cases in the last version of redirect_fh
that I pushed yesterday, but not 100% sure that I handled them
correctly.

Anyway, I will get to work on adjusting redirect_fh for use by
stable inodes.

> The following issues are left:
>
>  - performance of readdir;

Here is one very simple optimization for WIP:
@@ -157,6 +157,8 @@ static int ovl_fill_lowest(struct ovl_readdir_data *rdd,
                list_move_tail(&p->l_node, &rdd->middle);
        } else {
                p = ovl_cache_entry_new(rdd, name, namelen, ino, d_type);
+               if (p)
+                       p->ino = ino;

For non-lowets entry, we can provide mount option 'readdir_ino'.
With readdir_ino, readdir pays a penalty of getxattr for any non-lowest
entry (either OVL_XATTR_FH or OVL_XATTR_INO).
Without readdir_ino, readdir will get d_ino = 0, in which case, at least
`find <path> --inum=<n>` does the right thing (fallback to fstat for
this dirent).

>  - what to do if not all layers are on the same fs;

Same as what I did for redirect_fh - turn the feature off.
We can also export this state in /proc/mounts options and maybe allow to
explicitly turn off stable inodes, but I don't think that we should, because
there shouldn't be a program which relies on inode numbers NOT being stable.

>  - hard link copy ups.
>

I'll start by setting up a TODO Wiki page and writing xfstests for all those
issues. Maybe even track them on github..

Amir.
