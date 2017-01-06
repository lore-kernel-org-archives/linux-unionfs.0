From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: overlayfs freeze and remount
Date: Fri, 6 Jan 2017 14:38:59 +0200
Message-ID: <CAOQ4uxj+2rkxb8W=5it7s_+LA-==uaJayQqZKZH=y_bbf5jd8w@mail.gmail.com>
References: <CAOQ4uxg07or5Zs8LGc8toPxcCLuvxKkHBy3MWucJrdQ5NEmSDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33792 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935102AbdAFMjq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Jan 2017 07:39:46 -0500
Received: by mail-oi0-f66.google.com with SMTP id 3so54326717oih.1
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Jan 2017 04:39:01 -0800 (PST)
In-Reply-To: <CAOQ4uxg07or5Zs8LGc8toPxcCLuvxKkHBy3MWucJrdQ5NEmSDw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

On Tue, Dec 20, 2016 at 9:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Hi Miklos,
>
> It's time for me to move on to live snapshot take.

Miklos,

I implemented snapshot take without umount/mount.
Tested with unionmount testsuite with recycling.

If you have some interest and/or some time I could really
use a quick review of the dentry revalidation code:
https://github.com/amir73il/linux/commits/ovl_snapshot-next

BTW, do you know what you have planned for overlayfs for 4.11?
sorting out the rorw fd inconsistency? anything else?

Cheers,
Amir.

>
> The way I see it, in general lines:
> [-] sort out (and test) freezing of overlay sb
> [-] on remount, if options indicate new snapshot= value,
>     freeze overlay sb

Should be done before remount. Not implemented yet.

>     increment ofs->generation (NEW)
>     increment root oe->generation (NEW)

Decided it's not needed.

>     rcu update of ofs->snap_mnt
>     rcu update of root oe->_snapdentry

Hope I got this right...

>     unfreeze overlay sb
> [-] implement d_revalidate ops for snapshot mount
>     invalidate dentry if oe->generation < ofs->generation
>     invalidate dentry if oe->_snapdentry->d_sb !=
> ofs->snapshot_mnt->mnt_sb (that's a nested overlay sb)
>     I'm pretty sure that revalidate may be called on rcu read side. right?
>     lookup will find and set the new oe->_snapdentry, eventually
> resulting in new copy ups

That seems to work fine. I also handled the case of revalidate under LOOKUP_RCU.

>
> Basically, for the snapshot mount that should be enough, because the
> inodes themselves are always the actual lower inodes. only thing that
> needs to be reset on snapshot take is the state of (already copied to
> upper or not), which is the revalidating of oe->_snapdentry.
>
> I have 2 questions for you:
> 1. Does any of this make sense to you? Do you see a wall I am going to hit?
> 2. Is any of this work applicable for overlayfs outside the scope of my project?
>
> For example, do you think it would be interesting to "rotate" a new
> upper on a live overlayfs mount?
> Doing so would practically provide snapshots for overlayfs based containers.
> not the reverse ones I am working on, just rotate live upper.
>
> If you think that is interesting, I will try to approach the
> freeze+remount implementation with the "rotate upper" feature in mind.
>
> Dealing with open files is the next step and it is going to be more challenging.
> For snapshot mount, taking snapshot does not require changing real inode,
> but for overlay upper rotate it does, so fixing that will take more file ops
> intercepting and that is going to be outside the scope for my initial
> implementation.
>
> Thoughts? :-?
>
> Amir.
