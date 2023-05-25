Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E16C77B7A
	for <linux-unionfs@archiver.kernel.org>; Thu, 25 May 2023 17:00:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbjEYRAq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 25 May 2023 13:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjEYRAk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 25 May 2023 13:00:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628D1135
        for <linux-unionfs@vger.kernel.org>; Thu, 25 May 2023 09:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685033992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ffvm+0IZxEbjPg3numXWg88CKyDvX5QOmHRXaYe8lPw=;
        b=Nsc2UuWu9CNedfycMhu0BwM2VJHTFW6FXxZoaqcVezT/NEFTmsaOdu4fvLns5yncbCQON2
        iM+F5jcjlZ7tHfZpO13aEXRvkCNKB2oLdbgSV/f7U1/nWHW/qimDoWBYlaQTbih5awoJje
        MPmYEOuLNabkHtxc7J5WI6WXVb0+HFE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-57-qm8Llk1oNjexQAB6CuYC3g-1; Thu, 25 May 2023 12:59:51 -0400
X-MC-Unique: qm8Llk1oNjexQAB6CuYC3g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A39B03C0D19C;
        Thu, 25 May 2023 16:59:50 +0000 (UTC)
Received: from localhost (unknown [10.39.192.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 351A21121315;
        Thu, 25 May 2023 16:59:50 +0000 (UTC)
From:   Giuseppe Scrivano <gscrivan@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Alexander Larsson <alexl@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
References: <20230427130539.2798797-1-amir73il@gmail.com>
        <CAL7ro1G7DQS_aAC4+9-ppdQz_7vjoXdBLohZ6bKo6S75NQUDPA@mail.gmail.com>
        <CAOQ4uxhN1dPBkhAu3Zag8=RKCbzMQghuXnyp+uur83dRW8tz6Q@mail.gmail.com>
Date:   Thu, 25 May 2023 18:59:48 +0200
In-Reply-To: <CAOQ4uxhN1dPBkhAu3Zag8=RKCbzMQghuXnyp+uur83dRW8tz6Q@mail.gmail.com>
        (Amir Goldstein's message of "Thu, 25 May 2023 19:03:04 +0300")
Message-ID: <87h6s0z6rf.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Amir,

Amir Goldstein <amir73il@gmail.com> writes:

> On Thu, May 25, 2023 at 6:21=E2=80=AFPM Alexander Larsson <alexl@redhat.c=
om> wrote:
>>
>> Something that came up about this in a discussion recently was
>> multi-layer composefs style images. For example, this may be a useful
>> approach for multi-layer container images.
>>
>> In such a setup you would have one lowerdata layer, but two real
>> lowerdirs, like lowerdir=3DA:B::C. In this situation a file in B may
>> accidentally have the same name as a file on C, causing a redirect
>> from A to end up in B instead of C.
>>
>
> I was under the impression that the names of the data blobs in C
> are supposed to be content derived names (hash).
> Is this not the case or is the concern about hash conflicts?
>
>> Would it be possible to have a syntax for redirects that mean "only
>> lookup in lowerdata layers. For example a double-slash path
>> //some/file.
>>
>
> Anything is possible if we can define the problem that needs to be solved.
> In this case, I did not understand why the problem is limited to finding =
a file
> by mistake in layer B.
>
> If there are several data layers A:B::C:D why wouldn't we have the same
> problem with a file name collision between C and D?

the data layer is constructed in a way that files are stored by their
hash and there is control from the container runtime on how this is
built and maintained.  So a file name collision would happen only when
on a hash collision.

Differently for the other layers we've no control on what files are in
the image, unless we limit to mount only one EROFS as the first lower
layer and then all the other lower layers are data layers.

Given your example above A:B::C:D, if both A and B are EROFS we are
limited in the files/directories that can be in B.

e.g. we have A/foo with the following xattrs:

trusted.overlay.metacopy=3D""
trusted.overlay.redirect=3D"/1e/de1743e73b904f16924c04fbd0b7fbfb7e45b864024=
1e7a08779e8f38fc20d"

Now what would happen if /1e is present as a file in layer B?  It will
just cause the lookup for `foo` to fail with EIO since the redirect
didn't find any file in the layers below.


> So if there was a need to be able to redirect to a specific layer,
> I would imagine that we would need to be able to address any layer
> and not just "the start of data layers".
>
> If we were looking for a syntax that is not a current valid redirect,
> anything with // would work as well as anything with / that is not
> an absolute path, e.g. 3:/path/to/file, so both NFS and SMB ;-)
>
> Please describe the problem with more details and examples.
>
> Thanks,
> Amir.
>
>> On Thu, Apr 27, 2023 at 3:06=E2=80=AFPM Amir Goldstein <amir73il@gmail.c=
om> wrote:
>> >
>> > Miklos,
>> >
>> > This v2 combines the prep patch set [1] and lazy lookup patch set [2].
>> >
>> > This work is motivated by Alexander's composefs use case.
>> > Alexander has been developing and testing his fsverity patches over
>> > my lazy-lowerdata-lookup branch [3].
>> >
>> > Alexander has also written tests for lazy lowerdata lookup [4].
>> >
>> > Note that patch #1 is a Fixes patch for stable.
>> > Gao commented that the fix may not be complete, but I think it is bett=
er
>> > than no fix at all.
>> >
>> > Regarding lazy lookup in d_real(), I am not sure if the best effort
>> > lookup is the best solution, but in any case, none of this code kicks =
in
>> > without explicit opt-in to data-only layers, so the risk of breaking
>> > existing setups is quite low.
>> >
>> > Thanks,
>> > Amir.
>> >
>> > Changes since v1:
>> > - Include the prep patch set
>> > - Split remove lowerdata from add lowerdata_redirect patch
>> > - Remove embedded ovl_entry stack optimization
>> > - Add lazy lookup and comment in d_real_inode()
>> > - Improve documentation of :: data-only layers syntax
>> > - Added RVBs
>> >
>> > [1] https://lore.kernel.org/linux-unionfs/20230408164302.1392694-1-ami=
r73il@gmail.com/
>> > [2] https://lore.kernel.org/linux-unionfs/20230412135412.1684197-1-ami=
r73il@gmail.com/
>> > [3] https://github.com/amir73il/linux/commits/ovl-lazy-lowerdata
>> > [4] https://github.com/amir73il/xfstests/commits/ovl-lazy-lowerdata
>> >
>> > Amir Goldstein (13):
>> >   ovl: update of dentry revalidate flags after copy up
>> >   ovl: use OVL_E() and OVL_E_FLAGS() accessors
>> >   ovl: use ovl_numlower() and ovl_lowerstack() accessors
>> >   ovl: factor out ovl_free_entry() and ovl_stack_*() helpers
>> >   ovl: move ovl_entry into ovl_inode
>> >   ovl: deduplicate lowerpath and lowerstack[]
>> >   ovl: deduplicate lowerdata and lowerstack[]
>> >   ovl: remove unneeded goto instructions
>> >   ovl: introduce data-only lower layers
>> >   ovl: implement lookup in data-only layers
>> >   ovl: prepare to store lowerdata redirect for lazy lowerdata lookup
>> >   ovl: prepare for lazy lookup of lowerdata inode
>> >   ovl: implement lazy lookup of lowerdata in data-only layers
>> >
>> >  Documentation/filesystems/overlayfs.rst |  36 +++++
>> >  fs/overlayfs/copy_up.c                  |  11 ++
>> >  fs/overlayfs/dir.c                      |   3 +-
>> >  fs/overlayfs/export.c                   |  41 +++---
>> >  fs/overlayfs/file.c                     |  21 ++-
>> >  fs/overlayfs/inode.c                    |  38 +++--
>> >  fs/overlayfs/namei.c                    | 185 +++++++++++++++++++-----
>> >  fs/overlayfs/overlayfs.h                |  20 ++-
>> >  fs/overlayfs/ovl_entry.h                |  73 ++++++++--
>> >  fs/overlayfs/super.c                    | 132 ++++++++++-------
>> >  fs/overlayfs/util.c                     | 165 ++++++++++++++++-----
>> >  11 files changed, 534 insertions(+), 191 deletions(-)
>> >
>> > --
>> > 2.34.1
>> >
>>
>>
>> --
>> =3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
>>  Alexander Larsson                                Red Hat, Inc
>>        alexl@redhat.com         alexander.larsson@gmail.com
>>

