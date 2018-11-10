From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v8 2/2] overlayfs: override_creds=off option bypass creator_cred
Date: Sat, 10 Nov 2018 09:51:45 +0200
Message-ID: <CAOQ4uxgwQAf4NtaE+qhLUTVnvu0ixNZ6Gwotc4q4zR-y35NmZA@mail.gmail.com>
References: <20181106230117.127616-1-salyzyn@android.com> <20181106230117.127616-2-salyzyn@android.com>
 <20181108200106.GB3663@redhat.com> <b057da99-adc6-b355-fb57-b314a29f298f@android.com>
 <CAOQ4uxjVPKSaJ2oscvM7jtsDVabnq_qMPg7k4KQEyOLAVPojcg@mail.gmail.com> <c6518e90-9429-85a1-fe19-83e058154e2a@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c6518e90-9429-85a1-fe19-83e058154e2a@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, "Eric W. Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org, kernel-team@android.com, Paul Lawrence <paullawrence@google.com>, Theodore Tso <tytso@mit.edu>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Nov 9, 2018 at 7:32 PM Mark Salyzyn <salyzyn@android.com> wrote:
>
> On 11/08/2018 07:05 PM, Amir Goldstein wrote:
> >
> > Mark,
> >
> > I have some Android internals background, so I have a general
> > understanding of the
> > use case, but I can understand why people have a hard time connecting to the
> > motivation, thinking "their security model must be flawed".
> >
> > I am not sure if you are avoiding laying out the details of the model
> > because you
> > are not allowed to expose details or because you feel details may confuse us.
>
> I am not a "great communicator"(tm), probably only 50K vocabulary,
> propensity towards quantum leaps, so yes, I was worried about confusion.
> non-overlapping security model is the key takeaway I feel.
>

I hope my comment below will serve as an example why explaining your use
case is preferred to presenting the abstract and generalized problem.
And still - no objections to your current patch, *because* it can solve your
use cases and *because* we don't need to deal with the  abstract and
generalized problem.

> [TL;DR]
>
> In Android there are two use cases this covers:
>
> 1) On userdebug (rooted development) builds, adb remount feature
>     for readonly filesystems which include squashfs, ext4 dedupe,
>     and any right-sized (zero space left over) filesystems.  In these cases
>     the system will resort to utilizing overlayfs, and allow for
>     updated content to a scratch backing storage.
> 2) On operating system updates where new Hardware Abstraction
>     layers have been added and the vendor/oem supplied components
>     supplied to an older release.  In this corner case the operating
>     system update may carefully select overrides that are merged into
>     the vendor partition content directories as hosted by the
>     operating system partition.
>
> The sepolicy model can be browsed at
> https://android.googlesource.com/platform/system/sepolicy/.
>
> In the first use case above the possible insecurity is tempered by the
> debug nature
> of the system and the lurking big elephant in the room privilege
> escalation possibility
> (/system/bin/su existing),

Since you already have an elephant in the room, might as well use it
to mount overlay. I am guessing most of the work in developer mode is
with sepolicy disabled anyway?
Essentially, adb root/adb remount means gloves are off.
Although with overlayed adb remount gloves could be put back on
when you relinquish the overlay and get back to original /system mount.

> in the other a r/o and precise MAC. sepolicy
> and credentials
> will rule over transitions from one security domain to another for
> execution, vendor components are managed by a separate vendor_init and
> the actual xattr content is constant.
>

For this use case, you don't need an upper layer at all and you probably
don't use lower layers redirect_dir. Right?
So all the concerns about get/set trusted overlay xattrs and detecting
opaque directories (do you need those?) are moot.
If you propose that override_creds=off can only be enabled
on lower-only overlayfs, the caveats section of your documentation
would shrink down considerably to the point that it may even be
comprehend-able to mortal users and I don't think you will see much
resistant from overlayfs developers to that "safe side" approach.

> Being able to block reading a file or directory is not a big concern in
> the associated trees, because all of the originals are backed by a r/o
> filesystem image, the content
> is generally visible by all, and if not they are locally restricted
> views into a public filesystem image, that themselves can be mounted on
> a desktop. There are no privilege escalation or privacy issues.
>
> An Android use case this does not cover securely is when overlayfs is
> used as a
> snapshot of the users data during the update process to permit easy
> rollback of user data due to an
> update failure (very unlikely 0.01%, but alas there are tachyons with
> our names on them).
> For those use cases we have opted to add snapshot-ting to
> f2fs and ext4 (using dm-bow in another patch set under discussion for
> the time being)

Very interesting... that's a use case of overlayfs snapshots [1] I was
not aware of.
With regular overlayfs, mounter creds are used to create the "master" copy
while "origin" is left unchanged. With overlayfs snapshots, the "master" copy
is modified by user while the "backup" copy is created with the snapshot
mounter credentials.

> and abandoned overlayfs as insufficient in a dynamic non-overlapping DAC
> and MAC security model.

Essentially, dm-bow target has the same capabilities as overlayfs driver with
mounter creds. When creating the backup copies of modified blocks, it does
not consult the per file granular security policy - not sure if that
is a security
concern? (cc: Paul Lawrence)

As a matter of fact, because the overlayfs snapshots "backup repository"
is a directory tree, granular per file security policy could be applied during
BOW and/or during commit.

> Built in filesystem snapshot-ting is always preferred for performance,
> efficiency and access to the free block pools they maintain so that was an
> easy choice.
>

That's a bold statement and not entirely true.

Overlayfs (as do overlayfs snapshots) is much more efficient in page cache
usage (for unmodified files) than btrfs snapshots and dm thinp.
There is no issue with accessing the "free blocks pool" when the snapshot
solution is at the vfs level (as opposed to block level).
In fact, these two characteristics are probably the main thing going for
overlayfs as a choice for container storage driver.

Nevertheless, it doesn't seem like the Android userdata rollback feature
should care about efficiency of snapshot access at all.

All in all, I think that dm-bow is a neat solution for the specific use case,
but do not confuse it with "built-in filesystem snapshot support".
Getting there with ext4 is much harder. I know because I tried... [2].

Thanks,
Amir.


[1] https://github.com/amir73il/overlayfs/wiki/Overlayfs-snapshots
[2] https://github.com/amir73il/next3-utils/wiki/Ext4-snapshots-TODO
