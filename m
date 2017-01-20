From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/2] overlayfs: support freeze/thaw/syncfs
Date: Fri, 20 Jan 2017 09:27:56 +0100
Message-ID: <20170120082756.GA14115@quack2.suse.cz>
References: <1484828008-27507-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxiktC6xgZML8G6X56fTKV1bU9qY1CgvWSTODW9bvJPP0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39876 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751397AbdATI3n (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 20 Jan 2017 03:29:43 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiktC6xgZML8G6X56fTKV1bU9qY1CgvWSTODW9bvJPP0Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.com>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu 19-01-17 21:03:12, Amir Goldstein wrote:
> On Thu, Jan 19, 2017 at 2:13 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> I would be grateful if you guys could help me clarify something wrt
> freezefs vs. remount.
> I hope you may be able to enlighten me with just the information
> provided in this email
> without having to dive into overlayfs snapshot details.
> 
> I implemented 'snapshot take' for overlayfs snapshots using a command like:
> mount -o remount,snapshot=/snap/N /mnt
> 
> The 'snapshot take' moment from overlayfs writers perspective is when
> a single pointer
> is modified via rcu_assign_pointer(ufs->__snapmnt, snapmnt):
> 
> https://github.com/amir73il/linux/commit/f0d6759efb7a6281ecc55dcdf33837568f71d29a
> 
> I chose to use the remount_fs() API because it is convenient and make
> sense from user POV, but I could also use some IOCTL API for snapshot
> take.

So I don't see why remounting makes sense for making snapshots. Remounting
is for manipulating mount options, not for instructing filesystem to make a
snapshot. I think using ioctl(2) for manipulation of snapshots like btrfs
does makes more sense (and it is also consistent with the existing
precedens of btrfs).

> For consistency of snapshot from application POV, I need to do:
> fsfreeze -f
> snapshot take
> fsfreeze -u
> 
> But then I cannot use the remount_fs() API which requires that fs be unfrozen.
> 
> Can you please explain why do_remount_sb() requires that fs be unfrozen?

I think initially it was because we expected filesystem may need to modify
on-disk state to change mount options however that would get stuck since
the fs is frozen and thus deadlock would be created (you cannot thaw the
filesystem because the blocked process holds s_umount semaphore). Now also
thaw_super() relies on this as is behaves differently for RO and RW
filesystems.

> Would it be possible to relax this requirement depending on remount flags?

Yes, it would be possible although not trivial if you don't want to
introduce the above mentioned deadlock possibilities. And I don't see the
real need..

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
