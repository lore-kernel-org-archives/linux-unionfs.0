Return-Path: <SRS0=188/=DB=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE32C2D0E2
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Sep 2020 13:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B04B2344C
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Sep 2020 13:19:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ahOvx9F5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbgIXNTD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 09:19:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56092 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727839AbgIXNTB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Sep 2020 09:19:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600953539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tuLELMVx1d0z9lDtr9vsYVV9sW29/Ls2tmU4OUv+tsg=;
        b=ahOvx9F5MrlyK8izM/LluQU72dMyez9Lt5zvNJkGRRVPIypYGQBNfl7WVkXcuR7VcLwRfp
        ldO/vFei9+Our7xyKZ2gAeMSq4zYF9XqR8qLSUj6djDSHzIelz2ofTxz3DX1LurM/SZG9+
        kubKVWisRKPKAN1RcWmN9FBIjKBDfZ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-MA76MOQMMcue0cXYIbXBoQ-1; Thu, 24 Sep 2020 09:18:56 -0400
X-MC-Unique: MA76MOQMMcue0cXYIbXBoQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 866879CC26;
        Thu, 24 Sep 2020 13:18:54 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-53.rdu2.redhat.com [10.10.116.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3212D5578F;
        Thu, 24 Sep 2020 13:18:54 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 981BC222FC0; Thu, 24 Sep 2020 09:18:53 -0400 (EDT)
Date:   Thu, 24 Sep 2020 09:18:53 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ovl: introduce new "index=nouuid" option for inodes
 index feature
Message-ID: <20200924131853.GA132653@redhat.com>
References: <20200923152308.3389-1-ptikhomirov@virtuozzo.com>
 <20200923194713.GD88270@redhat.com>
 <CAOQ4uxjZ58bCNz7K6_2bk+O2ALEVFxoNPBXABKMC-+D9-oZ6=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjZ58bCNz7K6_2bk+O2ALEVFxoNPBXABKMC-+D9-oZ6=w@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Sep 24, 2020 at 05:44:22AM +0300, Amir Goldstein wrote:
> On Wed, Sep 23, 2020 at 10:47 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Wed, Sep 23, 2020 at 06:23:08PM +0300, Pavel Tikhomirov wrote:
> > > This relaxes uuid checks for overlay index feature. It is only possible
> > > in case there is only one filesystem for all the work/upper/lower
> > > directories and bare file handles from this backing filesystem are uniq.
> >
> > Hi Pavel,
> >
> > Wondering why upper/work has to be on same filesystem as lower for this to
> > work?
> >
> 
> I reckon that's because I asked for this constraint, so I will answer.
> 
> You are right that the important thing is that all lower layers are
> on the same fs, but because of
>   a888db310195 ovl: fix regression with re-formatted lower squashfs

Hi Amir,

So with "upper on same as lower fs" contstraint we are just making it
little harder so that people don't use recreated lower with existing
upper? Is that the intention behind this constraint.

On a side note, I have a question about above commit. 

So this is basically the issue of upper stored file handle resolving to
a different file (in recreated lower). And we are considering this to
be a corner case. But the very fact a user was running into it, it
probably is not that hard to reproduce. So with the fix a888db310195,
we avoided the problem for simple configurations (no-index, no-metacopy,
and no xino). But if same user runs with index=on, with recreatd lower,
they can still run into similar issues?

> 
> I preferred to keep the rules simpler.
> 
> Pavel's use case is clone of disk and change of its UUID.
> This is a real use case and I don't think it is unique to Virtuozzo,
> so I wanted index=nouuid to address that use case only and
> I prefer that it is documented that way too.

Sure. I understand that. I am only harping on this to make sure
we tell people to not use this "recreated lower with existing upper".
In Pavel's use case, it is more of a cloned use case and not
re-created use case.

Otherwise people will re-create lower layers with regular filesystems and
use index=nouuid and then run into squashfs like issue one day.

Or we could document what Miklos had said. Using existing upper
with recreated lower will likely run into issues with advanced
overlay features like (index, metacopy, xino etc).

> 
> Ironically, one of the justifications for index=nouuid is virtiofs -
> because fuse is now allowed as upper (or as same fs),
> one can already use fuse passthough (or one could use fuse
> passthrough when nfs export works correctly) as a "uuid anonymizer"
> for any fs, so in practice, index=nouuid cannot do any more harm
> then one can already do when enabling index over virtiofs.

Interesing. Using virtiofs or a fuse passthrough filesystem on top
just to avoid uuid check will be lot of work. 

But keeping upper/ on same fs as lower fs constraint does not help with this.

> 
> That is why I prefer the interpretation that index=nouuid means
> "use null uuid instead of s_uuid for ovl_fh" over the interpretation
> "relax comparison of uuid in ovl_fh".

So bottom line is that there are many ways where users can recreate
lower layers and run into issues.

- squashfs with index
- use a fuse passthrough filesystem
- use index=nouuid

So to me documenting that don't use existig upper with recreated lower
should help with all.

And putting a constraint of "lower and upper being on same fs" seems fine
for now but I am not sure it helps a lot. Anyway, I am fine with this
constratint. Just wanted to understand the rationale behind it.

Thanks
Vivek

