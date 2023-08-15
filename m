Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F6EC001B0
	for <linux-unionfs@archiver.kernel.org>; Tue, 15 Aug 2023 19:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240149AbjHOTwe (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 15 Aug 2023 15:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240039AbjHOTwA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Aug 2023 15:52:00 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B19B19A5
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Aug 2023 12:51:59 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id a1e0cc1a2514c-79d93e7ba34so3494553241.1
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Aug 2023 12:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692129118; x=1692733918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D0y1IvgwXiq+AuZgMfP6unwPnoMItMNghmA1i4oi41A=;
        b=nQYomZNrNh45tMFkVxctxWRpf4KMBC0waLIU/ou3cljMuqOdGBqnex+wNc7WuO17ZD
         w39AkWVrVI/9+DCkeYrPVaw5Ze/4Ny4bMQ+pD4EbRrKeS+m4WSVstffAitVOTyFum9iX
         TAj0UGT4kerCn4FEzgrzdW+lkDPyrQZnDsR22NmiIizLxWC7dmId9rRqE+Fu00A6CtYY
         eoK2InzOmc4KyOmQpzUA5gejOlICf8w0cQgppvs/usQl2Isydkd2MiT5xQCUe5WvveyF
         PO2IttIsBtvW31vXSmWZwylObB8xe8WhNTAPZpDfMNMYbAtX3tiTpGmUlLygvMxo7zLa
         XuJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692129118; x=1692733918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D0y1IvgwXiq+AuZgMfP6unwPnoMItMNghmA1i4oi41A=;
        b=kMLa9ZQqpW2HFEIgPpJo0WNyWi3PUJfDFsHF3oLhkupkTR520MKYoGuDVIOLHdjLVv
         6Dl0z3ZTyd7dIdkPFg3a8yUuKuuIny6hDsINunL5cVRxlun16ttU/GkyQrlZI9Qj1PQS
         2l45R68Cmeblc531y66Ifw82iDCT7lCXyOMT3qQfLOeXcZuccAJhhE9wpHJV2iMLzcVH
         NLnRyuvFVAb9PZ0vSyXIJIbQCkQKZgGOa8E7RS7HxxX+5vbvxEyjUEpzdOkuRYpKf1QB
         tIJJ4JXiALuciVhcdAtYumJ2U36jQDJhcGzXjhGAnTDG9BGLFBR4eHEKU0j3NgGwNm6i
         g7xQ==
X-Gm-Message-State: AOJu0Yy8EBYqPPe2kiiWnfMTwqiWEmUarezR7R9RyQeR1giceGXBAI69
        EJi0BV2LEsUDgtlyGFY3DGMqcHZ3IiYdukpWP1w=
X-Google-Smtp-Source: AGHT+IExoFSgXYrh03ay+6g55ClPhi5b3KCBYO3J8nv4t7nEXhSyGMNm5UC4M+pPAU+W5qbrUCX6oWIVqYVU05cCMsA=
X-Received: by 2002:a05:6102:158e:b0:443:5524:8f8b with SMTP id
 g14-20020a056102158e00b0044355248f8bmr2815544vsv.4.1692129118657; Tue, 15 Aug
 2023 12:51:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230814140518.763674-1-amir73il@gmail.com> <20230814140518.763674-3-amir73il@gmail.com>
 <CAJfpegu=-+jA1026KoqrFBX9dsfvQbcjHbkNunkZ6A794mZ1TQ@mail.gmail.com>
 <CAOQ4uxiTtraLVdsKJdty6z89=Lm52DGHFf1i_aL9jQz3L80V9Q@mail.gmail.com> <CAJfpegudye=2e2BWtk+fmaKMN_vUnwsKM8fi-GPcEX5n_vEizQ@mail.gmail.com>
In-Reply-To: <CAJfpegudye=2e2BWtk+fmaKMN_vUnwsKM8fi-GPcEX5n_vEizQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 15 Aug 2023 22:51:47 +0300
Message-ID: <CAOQ4uxi5oF7HWudQ7BBN9Matpsc2jqcftKZNH2Wpc778YK0mNg@mail.gmail.com>
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

On Tue, Aug 15, 2023 at 10:07=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu>=
 wrote:
>
> On Tue, 15 Aug 2023 at 17:59, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > > What occurs to me is why are we bothering with getting write access o=
n
> > > the internal upper mnt each time.  Seems to me it's a historical thin=
g
> > > without a good reason.  Upper mnt is never changed from R/W to R/O.
> > >
> > > So the only thing we need to do is grab the upper mount write access
> > > on superblock creation and do the sb_start_write/end_write() thing
> > > which can't fail.  If upper mnt is read-only, we effectively have a
> > > read-only filesystem, and can handle it that way (sb->s_flags |=3D
> > > SB_RDONLY).
> > >
> > > There's still the possibility that we do some changes to upper even
> > > for non-modify operations.  But with careful review we can remove a
> > > most (possibly all) error handling cases from ovl_want_write()
> > > callsites when we do know that we have write access on upper.  And
> > > WARN_ON(__mnt_is_readonly(ovl_upper_mnt(ofs))) should ensure that we
> > > catch any mistakes.
> > >
> > > Hmm?
> > >
> >
> > I was thinking the same thing myself, before I went on this journey.
> > I reached the conclusion that doing only sb_start_write() would not be
> > safe against emergency remount rdonly of the upper sb.
> >
> > I guess if upper sb is emergency mounted rdonly, then overlayfs
> > sb would also be emergency remounted rdonly, but for example
> > ext4 sb can become rdonly on internal errors.
> > But maybe that is not the responsibility of vfs or ovl to care about?
>
> Consider the case of a writable open file: the mount write access is
> only checked on open.  So not having fine grained mnt write access
> checks is not without precedent.
>

That's true.
I see that at least ext4_sync_file() and ext4_do_writepages()
test the EXT4_MF_FS_ABORTED case specifically to return EROFS.

> I'm not sure, but the number of added lines in this particular patch
> makes me think that at least during copy-up we could separate the mnt
> and the sb write locks.
>

Yeh, I think that makes a lot of sense.

> > Christian, is there also an API to set the sb rdonly when private
> > writable mounts (i.e. ovl_upper_mnt) exist?
>
> You mean notifying overlayfs about rdonly remount of upper mnt?  No,
> that doesn't exist today.
>

What I meant is, except from emergency remount rdonly and fs specific
cases like ext4 remount-ro on error, is there a way via new mount API
that users can request remount of the upper SB rdonly, despite the
fact that this sb has private writable mount clones?
even if ovl has elevated mnt_writers of upper_mnt?

Thanks,
Amir.
