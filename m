Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 042B8EB64D8
	for <linux-unionfs@archiver.kernel.org>; Fri, 16 Jun 2023 05:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjFPFIA (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 01:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjFPFH7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Jun 2023 01:07:59 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB87269D
        for <linux-unionfs@vger.kernel.org>; Thu, 15 Jun 2023 22:07:56 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id ada2fe7eead31-43f582c2ec6so327342137.0
        for <linux-unionfs@vger.kernel.org>; Thu, 15 Jun 2023 22:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686892075; x=1689484075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5ws+eHY7s7LkyWOUmCbuftJqV5Cn/OHIr9fA4gaMF+s=;
        b=W2eLhL9RuG0IzN7TN+jtJ6EVvXm/U1+bjcEKlakCkZq5zVIzHQIla0NWdB+CUY8Hrv
         IiGksxFiFV0Lf+2nPTiropHOiP8JsfPHyauHKwaA4VR7u1gjJaLeKPswMx+B/3uXc9tD
         tcJHWM3zbK4392tjbSRGBELYd9oaaDbCE1vidSbfepNhlmWcBZ9IA9kbocbWpgFB6iOL
         DLVyGa0ngZMSNkoPOZxnK4XACF8hjYrx33jTX+lvUjEr2jx0pabg4v7Ew8YpzE8EzbOS
         FiORQe8OkCA7oksvQo9yImu7DJ8LPsW66Fp2cJRriKCPwCWIX40/PV/mVtKqI5xn2QmY
         pXbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686892075; x=1689484075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5ws+eHY7s7LkyWOUmCbuftJqV5Cn/OHIr9fA4gaMF+s=;
        b=DUtuhrK7ey29iYs0iQYLF/DrD89ASbQ6q7X4I+LnKp9OeceXiw7eXApZyVkO6g4ANC
         D0UYBPp1Z/TlPdVpm0cWY/CdvtIRPHlpbCqSRhx21tEXzgjYeQomBcJGv+HYmWjUdvRE
         22QP2ux3auLtSR4SRanhQVctlPV7Tx69C6OtfeP9d7RF1oGIvuaGHMXGxeg/wsRLdoNs
         T57BlG9ll0nyyqeRk+2b3cFBP+bGWzKX0bcNdaOCR4x9V6236X0Shw/2V5bkO0XgXEvu
         Jp8TGUvv1oyeau0A7KETshGbivNQyMa/wHV2BtAywzitzVcUwVb+tMP93jmDwRgfJTLg
         XeFQ==
X-Gm-Message-State: AC+VfDwzkWxj0rglSSaLCAwhx0M15zlRgtharzcWf149a2sC39vAUtvq
        /DVNirm7PBv7EvGf+72EfcLEJwVK/0KFoDBqbxI=
X-Google-Smtp-Source: ACHHUZ607fYouwSCylrAPq4aUtHmb57IoOjF0BkwWP6yoPNyDyrUK9KhtmodCHcsMdNgUjmRRaPshDuy8eSGLf5z47g=
X-Received: by 2002:a05:6102:55a2:b0:430:13cb:8156 with SMTP id
 dc34-20020a05610255a200b0043013cb8156mr3439749vsb.13.1686892075132; Thu, 15
 Jun 2023 22:07:55 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1683102959.git.alexl@redhat.com> <b58e57955e122b5d6c4e087cf2dd6ed664152c7b.1683102959.git.alexl@redhat.com>
 <20230514191647.GD9528@sol.localdomain> <CAOQ4uxhEq8u37YNnqQmLbybJy1Kkg3Qk0TVtRZQP-yHt8CMmWA@mail.gmail.com>
 <CAL7ro1Hqc29w-FuRuoEfcsxiXTnqqwHP73nwvmZRuKVRsz4D9w@mail.gmail.com>
 <CAOQ4uxh_y+YO3q7dB=ALCriq31RhapOHGt+jcXTQbOC7iVqYTw@mail.gmail.com>
 <CAL7ro1GTzJy5Nv1vH0buVEXUnUk7cXBhSJB2ap8Jt_hutk7nYw@mail.gmail.com>
 <CAOQ4uxgbMD2RdEqta7a2t3uVceLuZDxOWA9SBNDAgZSdO_532Q@mail.gmail.com> <CAL7ro1FF_q7FEJdevWrqvugkJ9S8bU5MxcoHHrLC3D834u4+zQ@mail.gmail.com>
In-Reply-To: <CAL7ro1FF_q7FEJdevWrqvugkJ9S8bU5MxcoHHrLC3D834u4+zQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 16 Jun 2023 08:07:43 +0300
Message-ID: <CAOQ4uxgo9LOM3minBH0vw3huxjrHmO5O-caGfhgOUGCuT0B9Vg@mail.gmail.com>
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

On Mon, Jun 12, 2023 at 1:33=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> On Sun, Jun 11, 2023 at 1:20=E2=80=AFPM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> > On Sat, Jun 10, 2023 at 6:02=E2=80=AFPM Alexander Larsson <alexl@redhat=
.com> wrote:
> > >
> > > On Fri, Jun 9, 2023 at 3:03=E2=80=AFPM Amir Goldstein <amir73il@gmail=
.com> wrote:
> > > >
> > > > On Mon, May 15, 2023 at 9:15=E2=80=AFAM Alexander Larsson <alexl@re=
dhat.com> wrote:
> > > > >
> > > > > On Sun, May 14, 2023 at 11:00=E2=80=AFPM Amir Goldstein <amir73il=
@gmail.com> wrote:
> > > > > >
> > > > > > On Sun, May 14, 2023 at 10:16=E2=80=AFPM Eric Biggers <ebiggers=
@kernel.org> wrote:
> > > > > > >
> > > > > > > On Wed, May 03, 2023 at 10:51:38AM +0200, Alexander Larsson w=
rote:
> > > > > > > > When resolving lowerdata (lazily or non-lazily) we check th=
e
> > > > > > > > overlay.verity xattr on the metadata inode, and if set veri=
fy that the
> > > > > > > > source lowerdata inode matches it (according to the verity =
options
> > > > > > > > enabled).
> > > > > > >
> > > > > > > Keep in mind that the lifetime of an inode's fsverity digest =
is from when it is
> > > > > > > first opened to when the inode is evicted from the inode cach=
e.
> > > > > > >
> > > > > > > If the inode gets evicted from cache and re-instantiated, it =
could have been
> > > > > > > arbitrarily changed.
> > > > > > >
> > > > > > > Given that, does this verification happen in the right place?=
  I would have
> > > > > > > expected it to happen whenever the file is opened, but it see=
ms you do it when
> > > > > > > the dentry is looked up instead.  Maybe that works too, but I=
'd appreciate an
> > > > > > > explanation.
> > > > > >
> > > > > > Hmm. I do not think it is wrong because the overlay file cannot=
 be opened before
> > > > > > the inode overlay is looked up and fsverity is verified on look=
up.
> > > > > > In theory, overlay inode with lower could have been instantiate=
d by decode_fh(),
> > > > > > but verity=3Don and nfs_export=3Don are conflicting options.
> > > > > >
> > > > > > However, I agree that doing verify check on lookup is a bit too=
 early, as
> > > > > > ls -lR will incur the overhead of verifying all file's data eve=
n
> > > > > > though their data
> > > > > > is not accessed in a non-lazy-lower-data scenario.
> > > > > >
> > > > > > The intuition of doing verity check before file is opened (or c=
opied up)
> > > > > > when there is a realfile open is not wrong, it would have gotte=
n rid of the
> > > > > > dodgy ovl_ensure_verity_loaded(), but I think that will be a bi=
t harder to
> > > > > > implement (not sure).
> > > > > >
> > > > > > My suggestion for Alexander:
> > > > > > - Use ovl_set/test_flag(OVL_VERIFIED, inode) for lazy verify
> > > > > > - Implement ovl_maybe_validate_verity() similar to
> > > > > >   ovl_maybe_lookup_lowerdata()
> > > > > > - Implement a helper ovl_verify_lowerdata()
> > > > > >   that calls them both
> > > > > > - Replace the ovl_maybe_lookup_lowerdata() calls with
> > > > > >   ovl_verify_lowerdata() calls
> > > > > >
> > > > > > Then before opening (or copy up) a file, it could have either
> > > > > > lazy lower data lookup or lazy lower data validate or both (or =
none).
> > > > > >
> > > > > > This will not avoid ovl_ensure_verity_loaded(), but it will loa=
d fsverity
> > > > > > just before it is needed and it is a bit easier to take ovl_ino=
de_lock
> > > > > > unconditionally, in those call sites then deeper within copy_up=
, where
> > > > > > ovl_inode_lock is already taken.
> > > > > >
> > > > > > I *think* this is a good idea, but we won't know until you try =
it,
> > > > > > so please take my suggestion with a grain of salt.
> > > > >
> > > > > I'll have a look at it in a bit. It would make performance of
> > > > > verity=3Don in the non-lazy-lookup case better.
> > > > >
> > > >
> > > > Hi Alex,
> > > >
> > > > Now that lazy lookup is queued for next, I wanted to ask about the
> > > > status of your patches.
> > > >
> > > > Is the issue above the only thing you still need to look at?
> > > > No rush on my end, just wanted to be in sync.
> > >
> > > I spent some time on friday doing the initial work on this rework. In
> > > case you want to look at it  I just pushed it to:
> > >
> > > https://github.com/alexlarsson/linux/tree/overlay-verity
> > >
> > > The first 3 commits are the same as before, and the last one is the
> > > new approach. It's turned out pretty nice, simplifying things
> > > considerable.
> >
> > It does look nicer :)
> > I gave you a small review comment on github, but overall looks good.
> >
> > > But I really haven't had time to do a full re-review and
> > > test of it, so please don't merge it yet. I'll spend Monday ensuring
> > > it is in a good state for upstream.
> > >
> >
> > When you are done testing, please post v3 patches.
> >
> > Note that I pushed a new version of ovl-lazy-lowerdata branch to
> > fstests, with the minor :: syntax change.
>
> I posted the patches, and I also had to make some small changes to the
> xfstest commit:
>
> https://github.com/alexlarsson/xfstests/commits/verity-tests
>
> > Not sure if Miklos will have time to review them this cycle or wait
> > for the next one.
> >
> > There are also the mount api changes from Christian that conflict
> > with the new verify option.
> >
> > If we want to have all of these changes for this cycle, some collaborat=
ion
> > will be required.
>
> I would really like to get the overlay.verity xattr support in
> upstream pretty soon, because without it I can't release a stable
> version of the composefs userspace code. I don't want to release
> something that is using an xattr format that is not guaranteed to be
> stable.
>

Alex,

Pondering about this last sentence.

The overlay.verity xattr format is already in its 3rd revision since
the beginning of development.

When it was bare digest, it might have made sense to have no
header that describes the format.

When the algo byte was added, that was already a very big hint
that a proper header was in order.

Now that you had to change the meaning of the byte, it is very hard
to argue that the xattr format is guaranteed to be stable - in the sense
that it can never change again.

Please add a minimal header to the overlay.verity xattr format,
similar to ovl_fb, that will allow composefs/overlayfs to be
maintained as the separate projects that they are.

Something like this?

/* On-disk format for "verity" xattr */
struct ovl_verity {
        u8 version;     /* 0 */
        u8 len;          /* size of this header + size of digest */
        u8 flags;
        u8 algo;        /* digest algo */
        u8 digest[];
};

I realize that digest size may be inferred from xattr size,
but it is better to state the stored digest size explicitly and verify
that it matches expected xattr size.

Eric,

Does the digest buffer passed to fsnotify helpers have any
memory alignment requirements?

Thanks,
Amir.
