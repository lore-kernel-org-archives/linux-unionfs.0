From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 0/2] overlayfs: support freeze/thaw/syncfs
Date: Fri, 20 Jan 2017 10:41:50 +0200
Message-ID: <CAOQ4uxj-Zcz68ar52F19GP5q1cqhBnG-EYDYs8vRUicKsa1MTg@mail.gmail.com>
References: <1484828008-27507-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxiktC6xgZML8G6X56fTKV1bU9qY1CgvWSTODW9bvJPP0Q@mail.gmail.com> <20170120082756.GA14115@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170120082756.GA14115@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.com>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jan 20, 2017 at 10:27 AM, Jan Kara <jack@suse.cz> wrote:
> On Thu 19-01-17 21:03:12, Amir Goldstein wrote:
>> On Thu, Jan 19, 2017 at 2:13 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> I would be grateful if you guys could help me clarify something wrt
>> freezefs vs. remount.
>> I hope you may be able to enlighten me with just the information
>> provided in this email
>> without having to dive into overlayfs snapshot details.
>>
>> I implemented 'snapshot take' for overlayfs snapshots using a command like:
>> mount -o remount,snapshot=/snap/N /mnt
>>
>> The 'snapshot take' moment from overlayfs writers perspective is when
>> a single pointer
>> is modified via rcu_assign_pointer(ufs->__snapmnt, snapmnt):
>>
>> https://github.com/amir73il/linux/commit/f0d6759efb7a6281ecc55dcdf33837568f71d29a
>>
>> I chose to use the remount_fs() API because it is convenient and make
>> sense from user POV, but I could also use some IOCTL API for snapshot
>> take.
>
> So I don't see why remounting makes sense for making snapshots. Remounting
> is for manipulating mount options, not for instructing filesystem to make a
> snapshot. I think using ioctl(2) for manipulation of snapshots like btrfs
> does makes more sense (and it is also consistent with the existing
> precedens of btrfs).
>

Yes, its true, but the way overlay snapshots work is by mounting
and overlay with snapshot=<path> options which points to the
mount point where files are CoWed to, so the remount API makes
sense here.

Anyway, I think what I'll do is use the remount as setup phase
(prepare new snapshot target mount) and then use an ioctl
for the activation of the new snapshot.
That, or I could just check in ovl_freeze() if there is a new snapshot
setup and assign it, as snapshot take is always going to be
preceded by freeze anyway.


>> For consistency of snapshot from application POV, I need to do:
>> fsfreeze -f
>> snapshot take
>> fsfreeze -u
>>
>> But then I cannot use the remount_fs() API which requires that fs be unfrozen.
>>
>> Can you please explain why do_remount_sb() requires that fs be unfrozen?
>
> I think initially it was because we expected filesystem may need to modify
> on-disk state to change mount options however that would get stuck since
> the fs is frozen and thus deadlock would be created (you cannot thaw the
> filesystem because the blocked process holds s_umount semaphore). Now also
> thaw_super() relies on this as is behaves differently for RO and RW
> filesystems.
>
>> Would it be possible to relax this requirement depending on remount flags?
>
> Yes, it would be possible although not trivial if you don't want to
> introduce the above mentioned deadlock possibilities. And I don't see the
> real need..
>

I figures it was something like that. No I won't be able to justify making this
sort of change.

Thanks for explaining.
