Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA7F8C77B7A
	for <linux-unionfs@archiver.kernel.org>; Sun, 11 Jun 2023 11:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbjFKLUY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 11 Jun 2023 07:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbjFKLUX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 11 Jun 2023 07:20:23 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72E210FB
        for <linux-unionfs@vger.kernel.org>; Sun, 11 Jun 2023 04:20:18 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id ada2fe7eead31-43b5882f945so989315137.0
        for <linux-unionfs@vger.kernel.org>; Sun, 11 Jun 2023 04:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686482418; x=1689074418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rGF2bLvqUrQgx2/DoVjy72nkfwvcmnl5slEgEbFBtFc=;
        b=iJkDzOcd8/o57NtG7UQY1F1sIeBqNoWQdgOSRs3ns9urbsYNBz1eYSKLIHibIpp+iI
         wbBtZ/NZVT/dpOGt7k6T/jdCH7EYmSFYNf9BPbHxr867t0SEWZCno4BfJpqQwZ9dBJOW
         WEB83ygVTgm+uygut0G/NyhH+gbmNu/eLKVpFiAqGwi5ekH/68dzjcmT29zyFG8u6MiX
         960ViNDgIRzeo17ROXtGtMaMfbuGGw7QjreaOV7PttD+o+NfYCkI0hAOvLqWw8Sj3CaS
         2FtMUIgXzinN5HGLhzuxKQ7Q8sLZXAO9ywTBP15a6nGsJ4R5Zv98goWFYvsno7TQWMjK
         YFDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686482418; x=1689074418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rGF2bLvqUrQgx2/DoVjy72nkfwvcmnl5slEgEbFBtFc=;
        b=KLNdNOJAzXmnuNkxAf7e8fWFiXuaBWPcNyoPp3mJKJERDnUwx1WhuDl3+oof+/l3zX
         8w7I38f5Jg0A9kkpz8Qou7VaIme5qB1Iwxjvu5v9qvhLY4+caXnmQvxZVXpwfunr2vhi
         dkxMi+mxtkfvhpofFuc2poSwfibADJ0WB1MO8wcwo89G3FHKs5Bs1FQprJlzw10UBTII
         vQS3aF4e7aGq4mMuvE91IM0z2/wUjXw8Q2simQOpDZqHkMnxLWsWkD55FEBh9fPbaUCD
         BjUleRQmIUzBX7PVVMhNZHAmDf/p2LR1JpAU0O+OovJ8+QGBFTmUdzDOJtZBy4YjuKi5
         i3MA==
X-Gm-Message-State: AC+VfDy+XiHm8ncxLYAGrjvRxkmbNs/fmGLun4zIgEuH1CqT1A12/cWF
        vX1Fpj3G1x/LkhxHLigJbwGd5s2wmhQ9fOWqL+E=
X-Google-Smtp-Source: ACHHUZ6Uomhcg3MQgSadOCVtIlGUY4e78rLWi+46N5PdmxjLHyLW9WeB5GGeGorrVM8r4A4cHLc5endRn3LJZWzeugI=
X-Received: by 2002:a67:f04c:0:b0:43b:4688:7fb0 with SMTP id
 q12-20020a67f04c000000b0043b46887fb0mr2522861vsm.16.1686482417812; Sun, 11
 Jun 2023 04:20:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1683102959.git.alexl@redhat.com> <b58e57955e122b5d6c4e087cf2dd6ed664152c7b.1683102959.git.alexl@redhat.com>
 <20230514191647.GD9528@sol.localdomain> <CAOQ4uxhEq8u37YNnqQmLbybJy1Kkg3Qk0TVtRZQP-yHt8CMmWA@mail.gmail.com>
 <CAL7ro1Hqc29w-FuRuoEfcsxiXTnqqwHP73nwvmZRuKVRsz4D9w@mail.gmail.com>
 <CAOQ4uxh_y+YO3q7dB=ALCriq31RhapOHGt+jcXTQbOC7iVqYTw@mail.gmail.com> <CAL7ro1GTzJy5Nv1vH0buVEXUnUk7cXBhSJB2ap8Jt_hutk7nYw@mail.gmail.com>
In-Reply-To: <CAL7ro1GTzJy5Nv1vH0buVEXUnUk7cXBhSJB2ap8Jt_hutk7nYw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 11 Jun 2023 14:20:06 +0300
Message-ID: <CAOQ4uxgbMD2RdEqta7a2t3uVceLuZDxOWA9SBNDAgZSdO_532Q@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] ovl: Validate verity xattr when resolving lowerdata
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Jun 10, 2023 at 6:02=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> On Fri, Jun 9, 2023 at 3:03=E2=80=AFPM Amir Goldstein <amir73il@gmail.com=
> wrote:
> >
> > On Mon, May 15, 2023 at 9:15=E2=80=AFAM Alexander Larsson <alexl@redhat=
.com> wrote:
> > >
> > > On Sun, May 14, 2023 at 11:00=E2=80=AFPM Amir Goldstein <amir73il@gma=
il.com> wrote:
> > > >
> > > > On Sun, May 14, 2023 at 10:16=E2=80=AFPM Eric Biggers <ebiggers@ker=
nel.org> wrote:
> > > > >
> > > > > On Wed, May 03, 2023 at 10:51:38AM +0200, Alexander Larsson wrote=
:
> > > > > > When resolving lowerdata (lazily or non-lazily) we check the
> > > > > > overlay.verity xattr on the metadata inode, and if set verify t=
hat the
> > > > > > source lowerdata inode matches it (according to the verity opti=
ons
> > > > > > enabled).
> > > > >
> > > > > Keep in mind that the lifetime of an inode's fsverity digest is f=
rom when it is
> > > > > first opened to when the inode is evicted from the inode cache.
> > > > >
> > > > > If the inode gets evicted from cache and re-instantiated, it coul=
d have been
> > > > > arbitrarily changed.
> > > > >
> > > > > Given that, does this verification happen in the right place?  I =
would have
> > > > > expected it to happen whenever the file is opened, but it seems y=
ou do it when
> > > > > the dentry is looked up instead.  Maybe that works too, but I'd a=
ppreciate an
> > > > > explanation.
> > > >
> > > > Hmm. I do not think it is wrong because the overlay file cannot be =
opened before
> > > > the inode overlay is looked up and fsverity is verified on lookup.
> > > > In theory, overlay inode with lower could have been instantiated by=
 decode_fh(),
> > > > but verity=3Don and nfs_export=3Don are conflicting options.
> > > >
> > > > However, I agree that doing verify check on lookup is a bit too ear=
ly, as
> > > > ls -lR will incur the overhead of verifying all file's data even
> > > > though their data
> > > > is not accessed in a non-lazy-lower-data scenario.
> > > >
> > > > The intuition of doing verity check before file is opened (or copie=
d up)
> > > > when there is a realfile open is not wrong, it would have gotten ri=
d of the
> > > > dodgy ovl_ensure_verity_loaded(), but I think that will be a bit ha=
rder to
> > > > implement (not sure).
> > > >
> > > > My suggestion for Alexander:
> > > > - Use ovl_set/test_flag(OVL_VERIFIED, inode) for lazy verify
> > > > - Implement ovl_maybe_validate_verity() similar to
> > > >   ovl_maybe_lookup_lowerdata()
> > > > - Implement a helper ovl_verify_lowerdata()
> > > >   that calls them both
> > > > - Replace the ovl_maybe_lookup_lowerdata() calls with
> > > >   ovl_verify_lowerdata() calls
> > > >
> > > > Then before opening (or copy up) a file, it could have either
> > > > lazy lower data lookup or lazy lower data validate or both (or none=
).
> > > >
> > > > This will not avoid ovl_ensure_verity_loaded(), but it will load fs=
verity
> > > > just before it is needed and it is a bit easier to take ovl_inode_l=
ock
> > > > unconditionally, in those call sites then deeper within copy_up, wh=
ere
> > > > ovl_inode_lock is already taken.
> > > >
> > > > I *think* this is a good idea, but we won't know until you try it,
> > > > so please take my suggestion with a grain of salt.
> > >
> > > I'll have a look at it in a bit. It would make performance of
> > > verity=3Don in the non-lazy-lookup case better.
> > >
> >
> > Hi Alex,
> >
> > Now that lazy lookup is queued for next, I wanted to ask about the
> > status of your patches.
> >
> > Is the issue above the only thing you still need to look at?
> > No rush on my end, just wanted to be in sync.
>
> I spent some time on friday doing the initial work on this rework. In
> case you want to look at it  I just pushed it to:
>
> https://github.com/alexlarsson/linux/tree/overlay-verity
>
> The first 3 commits are the same as before, and the last one is the
> new approach. It's turned out pretty nice, simplifying things
> considerable.

It does look nicer :)
I gave you a small review comment on github, but overall looks good.

> But I really haven't had time to do a full re-review and
> test of it, so please don't merge it yet. I'll spend Monday ensuring
> it is in a good state for upstream.
>

When you are done testing, please post v3 patches.

Note that I pushed a new version of ovl-lazy-lowerdata branch to
fstests, with the minor :: syntax change.

Not sure if Miklos will have time to review them this cycle or wait
for the next one.

There are also the mount api changes from Christian that conflict
with the new verify option.

If we want to have all of these changes for this cycle, some collaboration
will be required.

Thanks,
Amir.
