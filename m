Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9717C7EE2E
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Jun 2023 11:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239260AbjFMLmf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 13 Jun 2023 07:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235301AbjFMLme (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 13 Jun 2023 07:42:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0129CF7
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Jun 2023 04:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686656508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GkfHbH2GQBwrEoYavn63lIrM8MkPz/Nc2uH1gFOnT2Y=;
        b=VnTn6KukNQgtc9YhPfRRoB6QCbxHt8VeUYQL1ziV+8h74hn3zMLLduIijLSNv82pqQZCTi
        QZ2DC9VnXikiJPoM5AWaQjs1CSsj/sskYsyq2LcBeBZdnwZwaA35Ln9BhG9tGYGMUMfMsQ
        MDEKRHoWxEgKJtTlVZ4VqiyNZrY4Jjs=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-tnvH52ijOb63F4gzfIOqCQ-1; Tue, 13 Jun 2023 07:41:46 -0400
X-MC-Unique: tnvH52ijOb63F4gzfIOqCQ-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-33b88241696so61279355ab.1
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Jun 2023 04:41:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686656506; x=1689248506;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GkfHbH2GQBwrEoYavn63lIrM8MkPz/Nc2uH1gFOnT2Y=;
        b=ZCqaNvrh6YgyJqzTvR4cJ3hxAbNmkLcOkF/ZJ1XlpolArtj4jsYdTsydUlLoliLVku
         vjb3S3lvtaxoPpHXAYiOmj4PfasoI/tMHZ2MWRUhobNmAD/Al2WRPEPhyObFTAcDB/mm
         RywaApcvK/TGPwg2DTzj2c3qbsCkuRX3XBb42LgfcpsIMaP48qq2jXhU9IpC88IKI1WC
         6MrBQbesoYSeB0k4ge9nN3WBw1w+CrCiGXQCcIyyPZEtNRl2rEkQV4PGKY9fDlNkcr4O
         WLADkeKiMMOIIBgqMbVcFuSEnI2U+oc3GRMoncKPGwg+yqVCOwVCUFyautUlRORc6CYk
         NBWQ==
X-Gm-Message-State: AC+VfDzKwpFxR72BCehHhy+MnLV+M6jUrBVNVz4AbczEaM36eWN5GyYs
        zzMBDeRJgTTIubvqF9Q1mQH+Em/HgFtKMNu5/kYUNd1ygXgixjUzj5OQmDyCN5GYCZbFNeafFfR
        97nfZft0gqzEl9KrU35Nyd11ReV2kadrpNLuX5GTtpw==
X-Received: by 2002:a92:dc4c:0:b0:33d:136f:249f with SMTP id x12-20020a92dc4c000000b0033d136f249fmr11130631ilq.22.1686656505854;
        Tue, 13 Jun 2023 04:41:45 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5XTokNuEMwpeWL/KyiMjkxNo6YbS5HbgMi+qKBZ/kOLefYz/fndSHDD72U0nQ4lCjmJ4vMoA7VoK8U6u+Cmgg=
X-Received: by 2002:a92:dc4c:0:b0:33d:136f:249f with SMTP id
 x12-20020a92dc4c000000b0033d136f249fmr11130622ilq.22.1686656505646; Tue, 13
 Jun 2023 04:41:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686565330.git.alexl@redhat.com> <dd294a44e8f401e6b5140029d8355f88748cd8fd.1686565330.git.alexl@redhat.com>
 <20230612190944.GB847@sol.localdomain>
In-Reply-To: <20230612190944.GB847@sol.localdomain>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Tue, 13 Jun 2023 13:41:34 +0200
Message-ID: <CAL7ro1Feep_aQimxEJzKk+4cv6-UNgco3VNDKZrrC3y2u04DCw@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] ovl: Validate verity xattr when resolving lowerdata
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jun 12, 2023 at 9:09=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Mon, Jun 12, 2023 at 12:28:17PM +0200, Alexander Larsson wrote:
> > +int ovl_validate_verity(struct ovl_fs *ofs,
> > +                     struct path *metapath,
> > +                     struct path *datapath)
> > +{
> > +     u8 xattr_data[1+FS_VERITY_MAX_DIGEST_SIZE];
> > +     u8 actual_digest[FS_VERITY_MAX_DIGEST_SIZE];
> > +     enum hash_algo verity_algo;
> > +     int xattr_len;
> > +     int err;
> > +
> > +     if (!ofs->config.verity ||
> > +         /* Verity only works on regular files */
> > +         !S_ISREG(d_inode(metapath->dentry)->i_mode))
> > +             return 0;
> > +
> > +     xattr_len =3D sizeof(xattr_data);
> > +     err =3D ovl_get_verity_xattr(ofs, metapath, xattr_data, &xattr_le=
n);
> > +     if (err =3D=3D -ENODATA) {
> > +             if (ofs->config.require_verity) {
> > +                     pr_warn_ratelimited("metacopy file '%pd' has no o=
verlay.verity xattr\n",
> > +                                         metapath->dentry);
> > +                     return -EIO;
> > +             }
> > +             return 0;
> > +     }
> > +     if (err < 0)
> > +             return err;
> > +
> > +     err =3D ovl_ensure_verity_loaded(datapath);
> > +     if (err < 0) {
> > +             pr_warn_ratelimited("lower file '%pd' failed to load fs-v=
erity info\n",
> > +                                 datapath->dentry);
> > +             return -EIO;
> > +     }
> > +
> > +     err =3D fsverity_get_digest(d_inode(datapath->dentry), actual_dig=
est, &verity_algo);
> > +     if (err < 0) {
> > +             pr_warn_ratelimited("lower file '%pd' has no fs-verity di=
gest\n", datapath->dentry);
> > +             return -EIO;
> > +     }
> > +
> > +     if (xattr_len !=3D 1 + hash_digest_size[verity_algo] ||
> > +         xattr_data[0] !=3D (u8) verity_algo ||
> > +         memcmp(xattr_data+1, actual_digest, xattr_len - 1) !=3D 0) {
> > +             pr_warn_ratelimited("lower file '%pd' has the wrong fs-ve=
rity digest\n",
> > +                                 datapath->dentry);
> > +             return -EIO;
> > +     }
> > +
> > +     return 0;
> > +}
>
> This means the overlayfs verity xattr contains the algorithm ID of the fs=
verity
> digest as a HASH_ALGO_* value.
>
> That works, but I think HASH_ALGO_* is somewhat of an IMA-ism.  fsverity
> actually uses FS_VERITY_HASH_ALG_* everywhere else, including in the UAPI=
 and in
> fsverity-utils which includes libfsverity
> (https://git.kernel.org/pub/scm/fs/fsverity/fsverity-utils.git/tree/inclu=
de/libfsverity.h).
>
> I'm guessing that you used HASH_ALGO_* not because you really wanted to, =
but
> rather just because it's what fsverity_get_digest() happens to return, as=
 IMA is
> currently its only user.

Yeah, that is exactly why.

> Can you consider
> https://lore.kernel.org/r/20230612190047.59755-1-ebiggers@kernel.org whic=
h would
> make fsverity_get_digest() support both types of IDs?  Then you can use
> FS_VERITY_HASH_ALG_*, which I think would make things slightly easier for=
 you.

Sounds very good to me. I'll rebase the patchset on top of it. Not
sure how to best land this though, are you ok with this landing via
overlayfs-next?

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

