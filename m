From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/4] ovl: introduce incompatible index feature
Date: Wed, 15 Nov 2017 17:14:06 +0200
Message-ID: <CAOQ4uxgsxj7SFvdaMNbqgJ+82ycau4fyeHmq7B5ZPkwMiyZRag@mail.gmail.com>
References: <1508839381-24750-1-git-send-email-amir73il@gmail.com>
 <1508839381-24750-2-git-send-email-amir73il@gmail.com> <20171110135757.GA16917@redhat.com>
 <CAOQ4uxgw-xOG8m=qLk0gZwq8PF=BSp51nMO2y38FpEAYWznG6g@mail.gmail.com> <20171115143442.GB13895@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:53773 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752629AbdKOPOH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Nov 2017 10:14:07 -0500
Received: by mail-yw0-f193.google.com with SMTP id q126so16687517ywq.10
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Nov 2017 07:14:07 -0800 (PST)
In-Reply-To: <20171115143442.GB13895@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Nov 15, 2017 at 4:34 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Nov 10, 2017 at 04:46:53PM +0200, Amir Goldstein wrote:
>> On Fri, Nov 10, 2017 at 3:57 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Tue, Oct 24, 2017 at 01:02:58PM +0300, Amir Goldstein wrote:
>> >> Introduce a new config option OVERLAY_FS_INDEX_INCOMPAT.
>> >>
>> >> If this config option is enabled then inodes index is declared
>> >> an incompatible feature and kernel will refuse to mount an overlay
>> >> with inodes index off when a non-empty index directory exists.
>> >>
>> >> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> >> ---
>> >>  fs/overlayfs/Kconfig     |  8 ++++++++
>> >>  fs/overlayfs/dir.c       | 30 ++++++++++++++++++++++++++++++
>> >>  fs/overlayfs/overlayfs.h |  3 ++-
>> >>  fs/overlayfs/super.c     | 24 +++++++++++++++++++++++-
>> >>  4 files changed, 63 insertions(+), 2 deletions(-)
>> >>
>> >> diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
>> >> index cbfc196e5dc5..e5e6dec7d177 100644
>> >> --- a/fs/overlayfs/Kconfig
>> >> +++ b/fs/overlayfs/Kconfig
>> >> @@ -43,3 +43,11 @@ config OVERLAY_FS_INDEX
>> >>         outcomes.  However, mounting the same overlay with an old kernel
>> >>         read-write and then mounting it again with a new kernel, will have
>> >>         unexpected results.
>> >> +
>> >> +config OVERLAY_FS_INDEX_INCOMPAT
>> >> +     bool "Overlayfs: support incompatible index feature"
>> >> +     depends on OVERLAY_FS_INDEX
>> >> +     help
>> >> +       If this config option is enabled then inodes index is declared an
>> >> +       incompatible feature and kernel will refuse to mount an overlay with
>> >> +       inodes index off when a non-empty index directory exists.
>> >
>> > Hi Amir,
>> >
>> > I don't know much about the issues you have faced. So I have few very
>> > basic questions.
>> >
>> > So the problem you are trying to fix is that if somebody mounted overlay
>> > with index=on and later they try to mount it with index=off.
>> >
>> > What problems happen if we allow that? If its a problem, why not always
>> > disallow that instead of making it an option. IOW, is there a use case
>> > where we will still let user mount later with index=off.
>> >
>>
>> So I have no current issue with going back from index=on, but I would like
>> to start adding incompatible features (like index=all), but in order to add
>> the concept of incompatible feature, first user will need to opt-in in compile
>> time to "overlayfs v2 format" which supports the feature checks.
>> opting-in to format v2 means that user knows he cannot (*) go backwards
>> to kernel that doesn't support v2 format and mount v2 format overlayfs.
>>
>> Actually, the user can go backwards, but he will need to manually remove
>> workdir and indexdir in order to "degrade" overlayfs to v1 before mount.
>>
>> I guess config option could have been
>> OVERLAY_FS_INCOMAT_V2
>
> So this does not protect against user downgrading to older kernel and
> then mount with index=off.
>

In principal no, it does not, although the patch
"ovl: cast a shadow of incomapt index into the past"
does try to make it easier for admin to understand an unsupported downgrade
may be involved.

What I wanted to achieve with this config option is instead of letting
the admin take the blame for every new OVERLAY config option
and having to understand what she is signing up for with every
permutation of incompatible config options - let admin sign up
once for V2 format and understand that this format is incompatible
with V1 format (i.e. downgrade is not allowed).

Then, at flag day, kernel is upgraded to support overlay format V2,
all old overlays can still be mounted,
depending on mount options and possibly on operations (e.g. dir
rename, hardlink copy up), V2 features will be enabled (i.e. redirect_dir,
index, metacopy).

After an incompat feature is enabled on disk, that overlay can no longer
be mounted by a kernel with V2 format but without the specific feature
support. Mounting that overlay with a really old kernel (no V2 support)
may yield ro-mount if workdir was not removed.

What complicates things a bit, because we are planing feature support
this late is that we already deployed some incompatible features and
you probably want users to be able to deploy metacopy before V2
"flag day".
That is still possible to do, without the protection that incompat_V2
feature provide.
In the future, when kernel is upgraded to support V2, the first mount
with metacopy enabled, or the first lookup to notice a metacopy xattr
will mark the metacopy feature enabled and going back to
metacopy=off will no longer be possible.

Any of this make sense to you?

Amir.

P.S. for the record, w.r.t. the discussion about backward/forward
compatible terminology,  file systems terminology usually refers
to backward/forward compatible of the "on-disk format changes".
It is almost never allowed to make on-disk format changes that
are not "forward compatible", meaning that a new kernel cannot
read the old file system from disk.
Is it allowed to make "backward incompatible on-disk changes",
so old kernel cannot mount new file system, but users need to
somehow opt-in for changing the format of an existing fs, so they
know they can no longer downgrade their kernel.

When Miklos introduced redirect_dir, it was going to be an automatic
on-disk format change on kernel upgrade, but Linus did not agree
to this. Miklos also included a proposal for future proof feature set
after this first "silent format upgrade":
https://marc.info/?l=linux-unionfs&m=147739471816673&w=2
which was the inspiration to my patches
