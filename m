Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB5CC41513
	for <linux-unionfs@archiver.kernel.org>; Tue, 15 Aug 2023 16:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238519AbjHOQA1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 15 Aug 2023 12:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238434AbjHOP76 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Aug 2023 11:59:58 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA2C10B
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Aug 2023 08:59:57 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id ada2fe7eead31-44ac277f2fbso169189137.3
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Aug 2023 08:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692115196; x=1692719996;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wx5zUoLLEk3AamBx186xM30bCcV8FLtLxVvNErae820=;
        b=A/2nG/51PcnxDRXhnpuRSk6me9oK0cHm0UIEyVBthBC9KbsOwOmfhGksQOQthuJAMy
         z5UQtsN2qCXXGceflrUaEBcaOCtcEXBf4OTwchlLKyiGFmZ30+RPcvSV2EJaHtglqhfj
         /l6gaIoeukS+ImpYi3UU/LhVa/lnbwTx4bGZr+FyPwk3A6yutTbKoCZ9S1Hjlp+0dy8O
         2eQnd8CUmptZf66vzPAKBwH8pKK+ACeW0S8xd2Ea4wr0jN3p79DziwkZoJoPKmD+tEuu
         N5x1epFTnhL6swMlBU8wUZQjm63ZMVyC+/pg9cXx9AKOX4VTaiz2jtH9d6c1364aZdXY
         qa0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692115196; x=1692719996;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wx5zUoLLEk3AamBx186xM30bCcV8FLtLxVvNErae820=;
        b=FXn2Lo1FXZlxzOwUN2kH6zyfiw0ecmPEyFv0Ie0dDUiT0XgZuM/9g7uyOY7XQFAUlH
         E/IfBMHkUtuG/6VZ9fdOyTPqCbbSVoxp0BhcWwdWuGBHFttvMqzNtb3HuMKHbyQTVIhn
         aMyP19Y9YM8lkB3oYQKN54h6SWW1Rojl1FijXmmLl/7YReSMUySxeAzOwSRgMZGUTuW8
         AdOTU5Cr4JrsscAbatkV1WEq+feZMG8an88r5Ai2nyoknooOpBJmfm/qFZ2xNrKzdKaG
         lSutEW2pfizd0PdUFHR+aEfvfLPjwpP25fJCQaMU/KILHoEjHEEtRFMnTEod0VcfArIp
         rGGg==
X-Gm-Message-State: AOJu0YySylpmYKsNNW5nQL8pM8gXPiJRRMX2VeltkogJD7mveElKP+Yq
        QFs/RwdstkUSNdG2iZ0Fow0IC/jci4NCEmZulb0=
X-Google-Smtp-Source: AGHT+IG0Kc69sK/ujYExqD0MZjmfhYpZfb6nteZieaGYdRSa5Qh/JzQyo6yVxOHrMsKMDDXSfkTx2v2EagLdSYN5sw8=
X-Received: by 2002:a67:fc0a:0:b0:447:60f4:cc51 with SMTP id
 o10-20020a67fc0a000000b0044760f4cc51mr10809777vsq.28.1692115196040; Tue, 15
 Aug 2023 08:59:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230814140518.763674-1-amir73il@gmail.com> <20230814140518.763674-3-amir73il@gmail.com>
 <CAJfpegu=-+jA1026KoqrFBX9dsfvQbcjHbkNunkZ6A794mZ1TQ@mail.gmail.com>
In-Reply-To: <CAJfpegu=-+jA1026KoqrFBX9dsfvQbcjHbkNunkZ6A794mZ1TQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 15 Aug 2023 18:59:44 +0300
Message-ID: <CAOQ4uxiTtraLVdsKJdty6z89=Lm52DGHFf1i_aL9jQz3L80V9Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ovl: do not open/llseek lower file with upper
 sb_writers held
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Jan Kara <jack@suse.cz>, linux-unionfs@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

[cc Christian]

On Tue, Aug 15, 2023 at 6:12=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Mon, 14 Aug 2023 at 16:05, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > overlayfs file open (ovl_maybe_lookup_lowerdata) and overlay file llsee=
k
> > take the ovl_inode_lock, without holding upper sb_writers.
> >
> > In case of nested lower overlay that uses same upper fs as this overlay=
,
> > lockdep will warn about (possibly false positive) circular lock
> > dependency when doing open/llseek of lower ovl file during copy up with
> > our upper sb_writers held, because the locking ordering seems reverse t=
o
> > the locking order in ovl_copy_up_start():
> >
> > - lower ovl_inode_lock
> > - upper sb_writers
> >
> > Take upper sb_writers only when we actually need it, so we won't hold i=
t
> > during lower file open and lower file llseek to avoid the lockdep warni=
ng.
> >
> > Minimizing the scope of ovl_want_write() during copy up is also needed
> > for fixing other possible deadlocks by following patches.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/overlayfs/copy_up.c | 117 +++++++++++++++++++++++++++++++----------
> >  1 file changed, 88 insertions(+), 29 deletions(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index c998dab440f8..f2a31ff790fb 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -251,8 +251,13 @@ static int ovl_copy_up_file(struct ovl_fs *ofs, st=
ruct dentry *dentry,
> >         if (IS_ERR(old_file))
> >                 return PTR_ERR(old_file);
> >
> > +       error =3D ovl_want_write(dentry);
> > +       if (error)
> > +               goto out_fput;
>
> What occurs to me is why are we bothering with getting write access on
> the internal upper mnt each time.  Seems to me it's a historical thing
> without a good reason.  Upper mnt is never changed from R/W to R/O.
>
> So the only thing we need to do is grab the upper mount write access
> on superblock creation and do the sb_start_write/end_write() thing
> which can't fail.  If upper mnt is read-only, we effectively have a
> read-only filesystem, and can handle it that way (sb->s_flags |=3D
> SB_RDONLY).
>
> There's still the possibility that we do some changes to upper even
> for non-modify operations.  But with careful review we can remove a
> most (possibly all) error handling cases from ovl_want_write()
> callsites when we do know that we have write access on upper.  And
> WARN_ON(__mnt_is_readonly(ovl_upper_mnt(ofs))) should ensure that we
> catch any mistakes.
>
> Hmm?
>

I was thinking the same thing myself, before I went on this journey.
I reached the conclusion that doing only sb_start_write() would not be
safe against emergency remount rdonly of the upper sb.

I guess if upper sb is emergency mounted rdonly, then overlayfs
sb would also be emergency remounted rdonly, but for example
ext4 sb can become rdonly on internal errors.
But maybe that is not the responsibility of vfs or ovl to care about?

Christian, is there also an API to set the sb rdonly when private
writable mounts (i.e. ovl_upper_mnt) exist?

Thanks,
Amir.
