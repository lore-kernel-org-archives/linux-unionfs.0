Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B875AC4332F
	for <linux-unionfs@archiver.kernel.org>; Mon, 30 Oct 2023 06:15:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjJ3GPp (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 30 Oct 2023 02:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjJ3GPo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 30 Oct 2023 02:15:44 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B1EB7
        for <linux-unionfs@vger.kernel.org>; Sun, 29 Oct 2023 23:15:41 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id 6a1803df08f44-66d190a8f87so28645556d6.0
        for <linux-unionfs@vger.kernel.org>; Sun, 29 Oct 2023 23:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698646540; x=1699251340; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fRN2e3cWiOObS+ZS4exCRxodVGVBbn5Q2IQMulo4C20=;
        b=Y9Mb/y8/xi91gM6PijHaXfJqM9jDFs/HL6qCbax+6fW+njc2aKz9SGrkwguRjFWNiM
         0El7I7f6QDVOh8ATErkVeHmde8Pf3kJrGUKfldzuXO1kFZU84NQiOANLE4RiOxk9inCN
         7JNlQJ5bSnGR8x5Y4dHVfLCjU13xhKrKEmQzwTXZzbw4i+xGRzbWdkFvv0wG7KiXcYJ5
         Ct8c8s3tda9WQEMHaFzVGCUom7pFo6WXmC2jhnCCsTmMzTKEKImEKARrkeg8UQTEEkSY
         oiESPuxo9ywXEuC2jFoI7Bb4DmOA4IktxqgbI2tavDkmVDtCfBcGpO9gE555XSEI3VTH
         RXAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698646540; x=1699251340;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fRN2e3cWiOObS+ZS4exCRxodVGVBbn5Q2IQMulo4C20=;
        b=KJYy8a4qEu+SKMAIs5xphlbVaO81KIjIrRG6yugKDr3TcgiQxgx3IRfjjiyp8WwV0O
         ad+sBGRkZpdUJfpQRugpbrAzYizD8PKKqZbCvhVO4Vk6bqcL1pPrNjfnvkj07fQYRmkc
         qbGtzje83XZany8VmQAIf5kh/GKhqUPoH7OARHT9ZdeIHGpbPHPCWGGRtcr2kb+FWpP7
         kCBfR6ZSE86+jjOGjQUz2SCGT4i9GBJIO/7NoCqE23Sfp566ExVT8MFEK/pTmANUehIq
         sRAzKF3fz6ipRaaastDrFDdRdri/cxdnfsOQqcAd4iwqxoLHJd+xzIaC6fZ+l3QDdg29
         e+aQ==
X-Gm-Message-State: AOJu0YyMc40awuc3GQO6ItnQELGCBa0XK3gWQe4aPIHK0u7Pqryw2L40
        nLT84EtSqL9asdezfPGWmffnyiKarkTpcuFlkJRqTWNKV44=
X-Google-Smtp-Source: AGHT+IFNVHaMRVFHrFj5Bhuxv9xYtXg98QcD23w3Tw7X1SL7eifYrl6xSHtg4U34XFRLkuFH3PHYPy77NQO7naYzpNE=
X-Received: by 2002:a05:6214:acf:b0:66f:b851:bf4d with SMTP id
 g15-20020a0562140acf00b0066fb851bf4dmr12063550qvi.4.1698646540485; Sun, 29
 Oct 2023 23:15:40 -0700 (PDT)
MIME-Version: 1.0
References: <PH7PR14MB55699F84995FB1FBBEA5663BF53BA@PH7PR14MB5569.namprd14.prod.outlook.com>
 <PH7PR14MB55698C0C851B995C9E8C649AF53EA@PH7PR14MB5569.namprd14.prod.outlook.com>
 <PH7PR14MB5569AA53E80797E88333DA5FF5A1A@PH7PR14MB5569.namprd14.prod.outlook.com>
In-Reply-To: <PH7PR14MB5569AA53E80797E88333DA5FF5A1A@PH7PR14MB5569.namprd14.prod.outlook.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 30 Oct 2023 08:15:29 +0200
Message-ID: <CAOQ4uxjUzQeTbPEyUBZK8DyBQQg9cEznroq2abMVJDEK+5dz3Q@mail.gmail.com>
Subject: Re: "Resetting" an overlay fs entry; clearing the upper layer and
 revealing the lower layer
To:     John Ericson <john.ericson@obsidian.systems>
Cc:     "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Oct 30, 2023 at 6:16=E2=80=AFAM John Ericson
<john.ericson@obsidian.systems> wrote:
>
> We aren't working on this at the moment, but I did have some off-list dis=
cuss discussion with Amir Goldstein. I wanted to include our correspondence=
 on this list for posterity --- e.g. us working on this later, someone else=
 working on this later, etc., and he said that is fine, so here it is. It t=
ook me a while to find the time splice together all the replies and their q=
uotes, but now I have it.
>

Thanks for the follow up.

> One thing I'll add is that while I still think this "resetting" operation=
 is a good feature for overlay fs in general (and not just our use-case), t=
he FUSE passthrough work (from Android most recently, not yet merged AFIAK)=
 would be an even better fit for our use-case than overlay fs. I don't know=
 if upstreaming that is still being pursued, but if it is, it seams reasona=
ble to just wait for it.

v14 just posted 2 weeks ago:
https://lore.kernel.org/linux-fsdevel/20231016160902.2316986-1-amir73il@gma=
il.com/

- All issues that Miklos mentioned as must for first release have been addr=
essed
- Only xfstests regressions are due to no invalidate of attribute
cache on mmap writes

I don't know of anything that should be blocking this work from being
merged to v6.8, but it does not mean that it will be merged ;)

> Indeed, FUSE passthrough ought to be a good replacement for the whole gam=
ut of exotic bind/union/overlay mounting without out adding endless more fu=
nctionality and code to the kernel.
>

If you are expecting that FUSE passthough will make overlayfs redundant
you have very high expectations from FUSE passthrough.

First of all, the work that was proposed for upstream is only for FUSE file=
 io
passthrough, which means that any non io operation still has a significant
performance overhead with FUSE compared to overlayfs.

The plan of FUSE BPF, that was presented by Android team has the
potential to bring FUSE passthrough performance much closer to overlayfs
but that is still a long way to go.

Thanks,
Amir.

>
> > On Mon, Jul 24, 2023, 9:29 PM John Ericson <john.ericson@obsidian.syste=
ms> wrote:
> >> On 7/24/23 03:51, Amir Goldstein wrote:
> >>> On Sun, Jul 23, 2023, 6:38 PM John Ericson
> >>>> Thanks for this information, Amir. It's very useful.
> >>>>
> >>>> On Thu, Jul 20, 2023, at 8:51 PM, Amir Goldstein wrote:
> >>>>> Hi
> >>>>>
> >>>>> Writing offlist because I'm on mobile
> >>>>> The problem is hard and you are not the first one to ask about it -=
 need to narrow it down to exact requirements to be able to solve it.
> >>>> Yes, not surprised others have asked about this. If you can point me=
 to the previous times it has been discussed (which I failed to find before=
), I am happy to read that correspondence rather than ask questions which m=
ay already be answered :).
> >>> Afaik it never got passed "we want to do that"... "It's complicated "=
 maybe you'll be the first ;)
> >> OK :)
> >>>> Also, if there was something describing the overall approach of the =
in-memory data structures, (https://docs.kernel.org/filesystems/overlayfs.h=
tml is more user focused, though one can get an inkling of what might be go=
ing on from squinting at it), that would be tremendously useful. (Based on =
the rest of your comments, I think this is the main thing I am missing.)
> >>>>> On Thu, Jul 20, 2023, 7:37 PM John Ericson <john.ericson@obsidian.s=
ystems> wrote:
> >>>>>> We would like to be able to "reset" an overlay-fs directory entry,=
 i.e.
> >>>>>> remove whatever might exist for this entry in the upper layer and =
revert
> >>>>>> back to whatever is in lower layer. This operation would be akin t=
o a
> >>>>>> regular removal, except without creating whiteouts to cover up any=
thing
> >>>>>> in the lower layer.
> >>>>>
> >>>>> Do you actually need to get rid of the upper entry or is it ok to j=
ust reset the upper entry to the metadata of the lower entry and make it a =
transparent "metacopy" ?
> >>>> Today we are modifying the upper layer and then remounting. This has=
 the semantics we want, but of course side-steps these issues by rebuilding=
 the in-memory data overlayfs data structures from scratch (I presume). I a=
m basically open to whatever approach is
> >>>> easiest that roughly corresponds to those semantics; not trying to p=
ut the cart before the horse here demanding extra requirements when I do no=
t know the details of the current implementation well :).
> >>> No documentation that I know of. Vfs is not very well documented.
> >> Gotcha. Well, at least good to know I wasn't missing something.
> >>>>> What if lower entry does not exist?
> >>>> So not sure how you envisioned this API.
> >>>>> What if upper was renamed after copy up? And then
> >>>> For what it is worth, we are not using redict_dir or the inode index=
. I am afraid I do not understand the significance of renaming outside exte=
nsions like those. I can imagine renames/hardlinks can cause inodes to be r=
eused across layers in perhaps-surprising
> >>>> ways , but I didn't think overlay fs would care about this much.
> >>>>> What if lower entry is another file or even a directory with same n=
ame?
> >>>> It should be exposed regardless. I was hoping this would still be an=
 O(1) changing some references in the in-memory VFS data structures, but if=
 it is O(n) because the overlayfs has a its own separate copies to a greate=
r degree than I thought, I could see that
> >>>> being a problem.
> >>> So not sure how you envisioned this API.
> >> My interpretation of your idea was similar to `unlinkat`, basically:
> >>
> >>     int overlayfs_reset_at(int overlay_dirfd, int lower_dirfd, const c=
har pathname, int flags);
> >>
> >> The idea is that the path is relative *both* directory file descriptor=
s. If the path has a /, and *both subdirs exist*, this:
> >>
> >>     overlayfs_reset_at(foo, bar, "asdf/qwer", AT_REMOVEDIR);
> >>
> >>
> >> is shorthand for:
> >>
> >>     overlayfs_reset_at(openat(foo, "asdf", O_PATH), openat(bar, "asdf"=
, O_PATH), "qwer", AT_REMOVEDIR);
> >>
> >> the interesting case is if both subdirs do not exist:
> >>
> >>  1. If the lower one doesn't exist, it means the entry in question is =
within an upper-/overly-only directory. We cannot reset the entry because t=
he overlay/upper parent directory (and possibly some ancestors also) is its=
elf covering it up. The operation can fail in this case, or we can just def=
ault to doing a plain old removal instead.
> >>  2. If the overlay/upper one doesn't exist, it means their must be a f=
ile that is covering up an ancestor directory in the directory in the lower=
 layer. The operation fails.
> >> So the only case where the operation succeeds with a bonafide reset is=
 when we can "cinch up" to both (immediate) parent directories. And to impl=
ement the permission check we just need check the read+execute permissions =
on the lower one. (Conversely, I *don't* think it matters what the permissi=
ons on the target of the entry revealed by the restore is, because those wi=
ll be carried through to the (modified) overlayfs and respected. It is just=
 the existence of the entry which we are guarding against leaking.
> >>
> >> All that said, to go back and walk through your scenario
> >>
> >>> After rename, the target is covering no entry and the source is a whi=
teout.
> >> Great, my understanding matches that.
> >>> You cannot open "the whiteout" for ioctl so you would not be able to =
uncover the lower original file with the suggested ioctl method.
> >>> Same goes for "undoing a delete".
> >> You should not need to ever open a whiteout, but just the directory th=
at contains the whiteout.
> >>> In this case maybe using link() with a special sort of tmpfile and us=
ing an ioctl with lower real fd as an input argument to overlayfs as a way =
to get a special sort of lower tmpfile to link in place of the whiteout ent=
ry.
> >> If we are just opening the directories, I don't think these extra hoop=
s are needed? Or am I missing something?
> >
> > All I can say is it looks like a very big maybe.
> > I can't see big flaws right now, but I think there are more details to =
find out yet
> >
> > Also with all the special cases that are not handled you will need to a=
rgue your case that the limited functionally is useful for an interesting u=
se case.
> >
> >>>>>> As far as our team could discern, the kernel currently does not su=
pport
> >>>>>> this operation. Thus, we are considering what would be necessary t=
o
> >>>>>> implement this ourselves. Our initial exploration led us to
> >>>>>> `ovl_do_remove` within `fs/overlayfs/dir.c` and in particular this
> >>>>>> conditional:
> >>>>>>
> >>>>>>      if (!lower_positive)
> >>>>>>          err =3D ovl_remove_upper(dentry, is_dir, &list);
> >>>>>>      else
> >>>>>>          err =3D ovl_remove_and_whiteout(dentry, &list);
> >>>>>>
> >>>>>> That seemed like a good place to begin --- if one were to force th=
e
> >>>>>> first case no new whiteouts would be created, correct?
> >>>>>
> >>>>> I don't think remove is the right way.
> >>>>> Hard for me to explain why.
> >>>>> The implementation would be more complicated than this if every to =
metacopynis not enough and there is no good reference code for doing someth=
ing like this.
> >>>> Fair enough. Yes, it is not at all clear what the ramifications of *=
not* doing a whiteout here are; I wouldn't want to make the underlying laye=
rs out of sync with the VFS!
> >>> The easiest case is to "punch out" the modified data using an ioctl. =
It does not cover undoing a delete or rename.
> >> Hmm, I am not sure I follow. Do you mean evict the information on this=
 part of the from the VFS so it must be rebuilt on demand from the underlyi=
ng layers? If so, that sounds very promising; much nicer to do that and let=
 things be rebuilt on demand by existing code.
> >>>>>
> >>>>>> Assuming that is indeed the right place to start, I have two follo=
w-up
> >>>>>> questions.
> >>>>>>
> >>>>>> 1. Since the desired end result of the operation is strictly close=
r to
> >>>>>> the lower layer, should we possibly eliminate some of the other
> >>>>>> operations in a fresh copy of this function? For instance, might
> >>>>>> `ovl_copy_up` be unnecessary because if the upper layer already do=
esn't
> >>>>>> "contribute" to this dir entry, no action would need to be taken?
> >>>>>> Additionally, what is the significance of `nlink`? We have not fou=
nd
> >>>>>> much documentation for it; from what we understand, it's an `xattr=
` used
> >>>>>> so some information for the overlay-fs is persisted on disk.
> >>>>>
> >>>>> Hard to explain - if you keep upper metacopy and punch our the data=
 all of the above is not relevant.
> >>>>>
> >>>>>> 2. What is the recommended approach to expose this functionality? =
We
> >>>>>> assume it would be through a new `ioctl`, but with no existing
> >>>>>> overlay-fs-specific `ioctl` as a reference, we are unsure if that =
would
> >>>>>> be the correct choice. We presume there are best practices on this
> >>>>>> matter that we are not currently aware of.
> >>>>>
> >>>>> Not sure. I think there was an ioctl for getflags and it was remove=
. You can look at git history.
> >>>> Thanks, I see it was removed in c4fe8aef2f07c8a41169bcb2c925f6a3a681=
8ca3. I can work from that. (However, I'll set this question aside until I =
know more about the fundamentals of what we would be doing.)
> >>>>>> Our intention is to upstream this patch if we write it. It would b=
e
> >>>>>> therefore beneficial to discuss any objections or concerns beforeh=
and.
> >>>>>> For instance, one possible issue could be overlay-fs usage which
> >>>>>> presumes that covered up lower layer data is private and inaccessi=
ble.
> >>>>>> To make it possible to preserve that invariant, permissions for th=
is
> >>>>>> operation would have to be distinct from write permissions. This c=
oncern
> >>>>>> can thus be addressed, but it would increase the scope of the patc=
h.
> >>>>>
> >>>>> I think it is best if the API can prove user has access to lower ob=
ject (do you have direct access to lower layer?) If ioctl passes open fd of=
 the lower object that caller can read from, it can be used as a proof that=
 there is no security concern with exposing the lower entry data because sa=
me user can rewrite the same data.
> >>>> Oh this is very elegant. Great idea!
> >>> Good luck.
> >> Thanks, we'll need it
