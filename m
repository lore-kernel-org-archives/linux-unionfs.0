Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8801EE7FE4
	for <linux-unionfs@archiver.kernel.org>; Fri,  8 Sep 2023 12:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236549AbjIHM3g (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 8 Sep 2023 08:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbjIHM3f (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 8 Sep 2023 08:29:35 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA51A1BF1
        for <linux-unionfs@vger.kernel.org>; Fri,  8 Sep 2023 05:29:31 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id ada2fe7eead31-450711d9bf1so830250137.1
        for <linux-unionfs@vger.kernel.org>; Fri, 08 Sep 2023 05:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694176171; x=1694780971; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cAW4H4Hf9Br34Vfz9+EUhg/lM9Xs99GgxEO0FuyWIWY=;
        b=JG522ALo3yIhTZgFa5RuCY8ddcEeJUaG1r6tohEvOc1I8lsAzlS51eS78TCr+UEB+N
         jRLAx4Jc4w0M2MHcLQtV3vRY6Z1q8YsxwgZyaWZ65BeO1ejcdGpFcXziqw0NWv6X1N8b
         8G4ppHiPY6CbF6zIB2kK3IOAF/rTRpnEr0E15fLgLvqWTZBONCFr/zL8/caX7f8zSNf8
         2VOD2P9EaTBb+dL8tuHB+jjb4TEN0tCIEglRUU5fcy23QNW2JDbdDG5AuzoaJ75fqMNx
         aze7rRYRGVkbYPB1pkIz13pw8QQ1UWq1xWX+gn75P2Bbjn8zKaVXOvJAGK2wC+ihBSVt
         aJHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694176171; x=1694780971;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cAW4H4Hf9Br34Vfz9+EUhg/lM9Xs99GgxEO0FuyWIWY=;
        b=Ndc+g+Sz6OEK1hsAZRVV1MHwK6Gek5SzvrcqwkI1Xq0gedvnEC+zGzNW48FYkfXjqJ
         jspOs1yXpW2QiNx4/wgEZngBBgi0VGJzjQBLnEkLRlhLEVQnOaQnfnsdWMgcpm6OzN3D
         lnM2yU17uZfEsOSiB6ZMdFfSRKFoww+EYBua9pc2sFFstvCJO7ddZAAPYaCOQ5P7S31k
         ohlwQO7wqWa66EIQ2tXUbM+0xJEp733omWGkcD3TOM8g43QoG3HrCUQWDT59IQD59j5r
         0k4FsgGkx6VQZneGLhAYiSAtGNN9qhB02gBg4LwQs5KX6ynx0A27kS/MWyv3tMXAb4mc
         NuJA==
X-Gm-Message-State: AOJu0YyMKKk37K8/5MD1Ewyw6V/JIcrW37VH8mfOtKLeaX6bd+fdbDML
        SUvd2IaziqcyxQSjG7+5GFXwcRohTyPU2n38790=
X-Google-Smtp-Source: AGHT+IFLbOWLSI82AmRUdrh41VI49x2OoS4KzXiSsn1e7+8Z7YXhgSwLcw3KfBntgX/foBf8h5aMB2NiGBdFy/ejh6k=
X-Received: by 2002:a67:d085:0:b0:44e:8ef9:3369 with SMTP id
 s5-20020a67d085000000b0044e8ef93369mr2613417vsi.0.1694176170654; Fri, 08 Sep
 2023 05:29:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230814140518.763674-1-amir73il@gmail.com> <20230814140518.763674-3-amir73il@gmail.com>
 <CAJfpegu=-+jA1026KoqrFBX9dsfvQbcjHbkNunkZ6A794mZ1TQ@mail.gmail.com>
 <CAOQ4uxiTtraLVdsKJdty6z89=Lm52DGHFf1i_aL9jQz3L80V9Q@mail.gmail.com>
 <CAJfpegudye=2e2BWtk+fmaKMN_vUnwsKM8fi-GPcEX5n_vEizQ@mail.gmail.com> <CAOQ4uxj+RAFeaqErOdE7xymUShawJka7L0noCopjzaeFY8ZQ-w@mail.gmail.com>
In-Reply-To: <CAOQ4uxj+RAFeaqErOdE7xymUShawJka7L0noCopjzaeFY8ZQ-w@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 8 Sep 2023 15:29:19 +0300
Message-ID: <CAOQ4uxis1UR36rJ-sLsgfk4mHhTOn_uM3xhSGbR08G0auzbhxQ@mail.gmail.com>
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

On Wed, Aug 16, 2023 at 6:02=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Tue, Aug 15, 2023 at 10:07=E2=80=AFPM Miklos Szeredi <miklos@szeredi.h=
u> wrote:
> >
> > On Tue, 15 Aug 2023 at 17:59, Amir Goldstein <amir73il@gmail.com> wrote=
:
> >
> > > > What occurs to me is why are we bothering with getting write access=
 on
> > > > the internal upper mnt each time.  Seems to me it's a historical th=
ing
> > > > without a good reason.  Upper mnt is never changed from R/W to R/O.
> > > >
> > > > So the only thing we need to do is grab the upper mount write acces=
s
> > > > on superblock creation and do the sb_start_write/end_write() thing
> > > > which can't fail.  If upper mnt is read-only, we effectively have a
> > > > read-only filesystem, and can handle it that way (sb->s_flags |=3D
> > > > SB_RDONLY).
> > > >
> > > > There's still the possibility that we do some changes to upper even
> > > > for non-modify operations.  But with careful review we can remove a
> > > > most (possibly all) error handling cases from ovl_want_write()
> > > > callsites when we do know that we have write access on upper.  And
> > > > WARN_ON(__mnt_is_readonly(ovl_upper_mnt(ofs))) should ensure that w=
e
> > > > catch any mistakes.
> > > >
> > > > Hmm?
> > > >
> > >
> > > I was thinking the same thing myself, before I went on this journey.
> > > I reached the conclusion that doing only sb_start_write() would not b=
e
> > > safe against emergency remount rdonly of the upper sb.
> > >
> > > I guess if upper sb is emergency mounted rdonly, then overlayfs
> > > sb would also be emergency remounted rdonly, but for example
> > > ext4 sb can become rdonly on internal errors.
> > > But maybe that is not the responsibility of vfs or ovl to care about?
> >
> > Consider the case of a writable open file: the mount write access is
> > only checked on open.  So not having fine grained mnt write access
> > checks is not without precedent.
> >
> > I'm not sure, but the number of added lines in this particular patch
> > makes me think that at least during copy-up we could separate the mnt
> > and the sb write locks.
> >
>
> The patch with separate locks during copy-up is not much smaller
> but it is a lot nicer IMO:
>
> https://github.com/amir73il/linux/commits/ovl_want_write-v3
>
> I shall post these shortly after tests are complete.
>

Hi Miklos,

Did you get a change to review v3 patches [1] with the split of
ovl_want_write() to ovl_get_mnt_write() and ovl_start_write()?

I would like to queue this lock ordering change for 6.7.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-unionfs/20230816152334.924960-1-amir73il@=
gmail.com/
