From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 0/2] overlayfs: support freeze/thaw/syncfs
Date: Thu, 19 Jan 2017 21:03:12 +0200
Message-ID: <CAOQ4uxiktC6xgZML8G6X56fTKV1bU9qY1CgvWSTODW9bvJPP0Q@mail.gmail.com>
References: <1484828008-27507-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1484828008-27507-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Jan 19, 2017 at 2:13 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Miklos,
>
> I implemented freeze/thaw of overlayfs, because I need it for
> overlay snapshots (CoW decision is made before mnt_wat_write(upper)
> and I need to serialize it with snapshot take).
>

Miklos, Jan,

I would be grateful if you guys could help me clarify something wrt
freezefs vs. remount.
I hope you may be able to enlighten me with just the information
provided in this email
without having to dive into overlayfs snapshot details.

I implemented 'snapshot take' for overlayfs snapshots using a command like:
mount -o remount,snapshot=/snap/N /mnt

The 'snapshot take' moment from overlayfs writers perspective is when
a single pointer
is modified via rcu_assign_pointer(ufs->__snapmnt, snapmnt):

https://github.com/amir73il/linux/commit/f0d6759efb7a6281ecc55dcdf33837568f71d29a

I chose to use the remount_fs() API because it is convenient and make sense from
user POV, but I could also use some IOCTL API for snapshot take.

For consistency of snapshot from application POV, I need to do:
fsfreeze -f
snapshot take
fsfreeze -u

But then I cannot use the remount_fs() API which requires that fs be unfrozen.

Can you please explain why do_remount_sb() requires that fs be unfrozen?

Would it be possible to relax this requirement depending on remount flags?

The reason I ask is because overlay remount does not do any writes nor
call mnt_want_write() for that matter.

Thanks,
Amir.
