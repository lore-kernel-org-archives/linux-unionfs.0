Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA9DC77B61
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 07:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242971AbjD0HZS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 03:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243071AbjD0HZL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 03:25:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3F4199
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 00:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682580190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5jeqJ9HassJzAfQwWAImivyo69DUol104gIRj/UZUGc=;
        b=fVBajJn/PP1BarwcIKuG0FrarEV+jpP6DQXr9+0+PfIZ00kSaJSeZm37Y9EjRyk2igSyG4
        /3qux1knNsPWkfxp1W0e4dJAfRYeXM4qLDERx0sH7gcCSw/bJnn8uhPgrBp6Jtnccu4LRM
        k1qvI+Ddhe14Hc4Vu4B44Tc4e/IFCLU=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-dw_rqoIoM-6JnFwVpWupUQ-1; Thu, 27 Apr 2023 03:23:08 -0400
X-MC-Unique: dw_rqoIoM-6JnFwVpWupUQ-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-32b5fe8ab73so60503765ab.2
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 00:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682580188; x=1685172188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5jeqJ9HassJzAfQwWAImivyo69DUol104gIRj/UZUGc=;
        b=fjMk1xt58x8yTympEgzakWI0d9GZbxfymz8X/J+VIoP7GfGFquHnvR1fRLexjXas1p
         fqPm0kgTffd4ZDkTCUNkUWXvnoXuZRVy/Xzp0lWhwnEH/iRNfWget/kSwpolrlS1sWCN
         JqS7DL/onZZxPijYLDiUnM3OrMsvb8pfIaW4i7wA7f7RDnp6zwo2gjmH3IU3xcsgUVFf
         yCz6psDvfGgV+7jRereuCoQ08QzqK67A7hZqSwjhSZ8beae8EzE7iX37GgItetwFZkQU
         +mkXt3pDfiwBuvI+pwhCj0Tvjj+g5MITZdmisCGFdpeAPuIX2aYvBu66evbHXGt3q/Ix
         k+Zg==
X-Gm-Message-State: AC+VfDzQS2HH4IoKz9p6DuuziN/ZsTLx/+Ut03Qog/2O/VxlQsCgaSLh
        lz+Q7tCjDIyWccVK/cPplI62zb33AYz9+QNeRszaIf4x3xIIuANjUz4FHkCES2cVTumpDizYI2l
        h8RvfmJYCq1jF4f6dz3wigjZYQyhj8Uk9MXK3mJXFHg==
X-Received: by 2002:a92:cac8:0:b0:317:6ead:2e4e with SMTP id m8-20020a92cac8000000b003176ead2e4emr671923ilq.5.1682580188209;
        Thu, 27 Apr 2023 00:23:08 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7/5qop1vbx8tY3uDBO2RQRnX5LMLKyFzq26C7+s7nd9J1BQzKLWoIeyB+cY1Zrv0QdaIMEr2wBenDoUzKOLB8=
X-Received: by 2002:a92:cac8:0:b0:317:6ead:2e4e with SMTP id
 m8-20020a92cac8000000b003176ead2e4emr671916ilq.5.1682580188017; Thu, 27 Apr
 2023 00:23:08 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1681917551.git.alexl@redhat.com> <df41e9dc96ddad9f9e1e684e39c28f4e097e9d9b.1681917551.git.alexl@redhat.com>
 <20230426214743.GA58528@sol.localdomain>
In-Reply-To: <20230426214743.GA58528@sol.localdomain>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Thu, 27 Apr 2023 09:22:57 +0200
Message-ID: <CAL7ro1EYZXUQM+Ygp3aO8-rWD0ULZyaJH4rN_+88LNS4h5p78w@mail.gmail.com>
Subject: Re: [PATCH 5/6] ovl: Validate verity xattr when resolving lowerdata
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 26, 2023 at 11:47=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> On Thu, Apr 20, 2023 at 09:44:04AM +0200, Alexander Larsson wrote:
> > +     err =3D fsverity_get_digest(d_inode(datapath->dentry), actual_dig=
est, &verity_algo);
> > +     if (err < 0) {
> > +             pr_warn_ratelimited("lower file '%pd' has no fs-verity di=
gest\n", datapath->dentry);
> > +             return -EIO;
> > +     }
> > +
> > +     if (digest_len !=3D hash_digest_size[verity_algo] ||
> > +         memcmp(required_digest, actual_digest, digest_len) !=3D 0) {
> > +             pr_warn_ratelimited("lower file '%pd' has the wrong fs-ve=
rity digest\n",
> > +                                 datapath->dentry);
> > +             return -EIO;
> > +     }
> > +
> > +     return 0;
>
> This is incorrect because the digest algorithm is not being compared.

This is actually an interesting question. How much are things weakened
by comparing the digest size, but not comparing the digest type. Like,
suppose the xattr has a sha256 digest (32 bytes), how likely is there
to be another new supported verity algorithm of the same digest size
where you can force it to produce matching digests?

I ask because ideally we want to minimize the size of the xattrs,
since they are stored for each file, and not having to specify the
type for each saves space. Currently the only two supported algorithms
(sha256 and sha512) are different sizes, so we essentially compare
type by comparing the size.

I see three options here:
1) Only compare digest + size (like now)
2) Assume size 32 means sha256, and 64 means sha512 and validate that
3) Use more space in the xattr to store an algorithm type

Maybe alternative 2 is the best option on balance, less extensible,
but safe and uses least space.
Opinions?

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

