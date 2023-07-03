Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A58EEB64DC
	for <linux-unionfs@archiver.kernel.org>; Mon,  3 Jul 2023 08:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjGCIMH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 3 Jul 2023 04:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjGCIMG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 3 Jul 2023 04:12:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CFFE43
        for <linux-unionfs@vger.kernel.org>; Mon,  3 Jul 2023 01:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688371886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jX+9rLub5+S3pVYr3zrONhnGJNN9nYHDWhiAdapEMRQ=;
        b=getWt8hARDxY2KeCt6WuyO3aTsUIIPruJhR8qCNGUIay0vs/pz8ZDmCjZFTW/dDxInQ44O
        ihqvzJYI2wCcoJISKgy9glHrUfKfXQmL4U5A8+MYV9BczDkYatGI2XoP9thTp1+g3YVgqU
        ++5qe9lsgT06naJ9fnVfLczyeUWJzhE=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-316-Ohmbr88yNhKiZyAhBVYbvw-1; Mon, 03 Jul 2023 04:11:25 -0400
X-MC-Unique: Ohmbr88yNhKiZyAhBVYbvw-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-345ad772e36so18150275ab.0
        for <linux-unionfs@vger.kernel.org>; Mon, 03 Jul 2023 01:11:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688371884; x=1690963884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jX+9rLub5+S3pVYr3zrONhnGJNN9nYHDWhiAdapEMRQ=;
        b=IqKQzPP4cSQiMlRbvfnFA8vmpmSs/sZWxyNH1KjuQwignUcIzibUmFe1kvQoV+1trb
         UYAtWoX2U1trZjXoPItDIU++A+sf1YRwHW746BV8unAhfuEEiivnfXmMpzbDdGt+1FG7
         EZk4v0tGg4HyR0UTqigdDygfvrR0MRKXlnG3kZV6a3nvtyUgHCImi3WVzHL4X+PhCzhA
         bJwb3elh6WELUZTHzcMmLt2xqk1BQ0305SwUxotDFhJP42XF0yyp0AmZ5CZsxsPa002c
         TtTkib8SBCr/gYlWk1I6JJf03yvOqXvWyYrB78xgoqi7oGg74wVXbMctV7+k82FeaTkO
         0Vcg==
X-Gm-Message-State: ABy/qLa8KGMsqKP50csuitW9mPelwXw6iVTrC2JY+jD+jbcCB2rVf8UW
        A8xYrJWxrB48Lpt4zQIdPw8YWkjeuEMoYWlyA69h+lcC7srzb1xFp6KHBi16R2/FFpPZa0oLBWu
        TT6FTMuhSi0SpSU5xBbnEBziHMmw+3EU6Uoiiphuen1K7Fi+zEppY
X-Received: by 2002:a92:c904:0:b0:345:69c8:7a41 with SMTP id t4-20020a92c904000000b0034569c87a41mr9414129ilp.1.1688371884501;
        Mon, 03 Jul 2023 01:11:24 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGbbsXziZ6aUgGE50Kgdn+1m5trosLGjQV4132BVUXrtsgu+8y2cuoqCAH10Ke1vX87vdxZHTC7c5GsvWBwYxU=
X-Received: by 2002:a92:c904:0:b0:345:69c8:7a41 with SMTP id
 t4-20020a92c904000000b0034569c87a41mr9414118ilp.1.1688371884302; Mon, 03 Jul
 2023 01:11:24 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686565330.git.alexl@redhat.com> <CAOQ4uxgmV1KKCeq8=8FPkAciwqPpz8JiSM8WEuxDaZbVuYcQ7Q@mail.gmail.com>
 <CAL7ro1EiYOOOqexrKy+UXRzmpGyCaNec3+LHGxnA0YfmoMDN3A@mail.gmail.com>
 <CAL7ro1FKwgUY4e7N_vYi0cFsuVx6St0-oKvcBkiRFnzLH8D1eQ@mail.gmail.com>
 <CAOQ4uxgVnv7wtwFZaBnEotFCwQD1EZcSK2KW4K4vRD8d9fzCiw@mail.gmail.com>
 <CAL7ro1FY6OmhypFGDjinOkkjyJzymntVje4nRA558dKY+KsgzQ@mail.gmail.com>
 <CAOQ4uxjuhzxgTxmRXxczJLDrMzKKr-jzS3R8ESwkw4XQ+UyAfQ@mail.gmail.com>
 <CAL7ro1GYEdMvjn+e8Y8CmMC-s_5NZOXjsj=iv7s5NbnpTZz+Cg@mail.gmail.com>
 <CAOQ4uxjS9mTjCCTS9eS1HmZqKAQV97mh1wpkqJuShCHP_MKqag@mail.gmail.com> <CAOQ4uxjNMJG6TQcZiT2sx8eLTyybf+iLR3GtOKaaj7QydVr_0Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxjNMJG6TQcZiT2sx8eLTyybf+iLR3GtOKaaj7QydVr_0Q@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Mon, 3 Jul 2023 10:11:13 +0200
Message-ID: <CAL7ro1GhLcPK-xahOVmJAtL5pbgMVm0GVd2xW7tgO+_R4dbD5Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] ovl: Add support for fs-verity checking of lowerdata
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     ebiggers@kernel.org, tytso@mit.edu, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Cool, I wanted to look at this, but was on PTO last week.
It looks good to me, and I synced this to:
  https://github.com/alexlarsson/xfstests/commits/verity-tests
To avoid drift.

On Mon, Jun 26, 2023 at 3:14=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Thu, Jun 22, 2023 at 2:45=E2=80=AFPM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> > On Thu, Jun 22, 2023 at 12:52=E2=80=AFPM Alexander Larsson <alexl@redha=
t.com> wrote:
> > >
> > > On Thu, Jun 22, 2023 at 11:37=E2=80=AFAM Amir Goldstein <amir73il@gma=
il.com> wrote:
> ...
> > > > Alex,
> > > >
> > > > Verified that your verity-tests2 work as expected with v5 patches.
> > >
> > > To be honest I have not validated that my changes to the shared verit=
y
> > > code still works with the non-overlayfs tests. If you have a setup fo=
r
> > > it it would be great if you could try the regular ext4 w/ fs-veriy
> > > tests on top of the verity-test2 branch.
> > >
> >
> > There is no problem with "./check -g verity" on ext4
> > those tests pass.
> >
> > However, "./check -overlay -g generic/verity" fails several test:
> > Failures: generic/572 generic/573 generic/574 generic/575 generic/577
> > because _require_scratch_verity falsely claims that overlay (over ext4)
> > supports verify, but then FS_IOC_ENABLE_VERITY actually fails
> > during the test.
> >
> > Instead of changing _require_scratch_verity() as you did,
> > you should consider passing optional arguments, e.g.:
> >   local fstyp=3D${1:-$FSTYP}
> > and calling it from _require_scratch_overlay_verity() with the
> > $OVL_BASE_* values.
> >
>
> FWIW, I pushed this solution to
> https://github.com/amir73il/xfstests/commits/verity-tests
>
> It's ugly, but it works.
>
> Thanks,
> Amir.
>


--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

