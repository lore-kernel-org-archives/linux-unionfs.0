Return-Path: <SRS0=M/3b=6E=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C988C3815B
	for <linux-unionfs@archiver.kernel.org>; Mon, 20 Apr 2020 19:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBBE32074F
	for <linux-unionfs@archiver.kernel.org>; Mon, 20 Apr 2020 19:15:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aQcZ4D4h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgDTTPB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 15:15:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47908 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727873AbgDTTPA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 20 Apr 2020 15:15:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587410099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IBBjlQmhXtT29F7ArYIlXssHi/9mhkt3s/KZZqXfZPc=;
        b=aQcZ4D4h4quPYc0jzg/iM2oVsBSn//IRvKrRXBq/0/th07PyA/KYDbMGYAxBgxkPmOW7Kw
        xFGcqdpjQeMElz4C6hwAc5KfMwyNOmcSHyBd4DlPxIafnupYfHQWQxBsjhIUgVEt7KljUW
        sBH1899H53N6P+2AH5/Nt1tnbpgWffQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-6OUwEGY2N1W1KFRvWDNKfg-1; Mon, 20 Apr 2020 15:14:55 -0400
X-MC-Unique: 6OUwEGY2N1W1KFRvWDNKfg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AED121005509;
        Mon, 20 Apr 2020 19:14:54 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-41.rdu2.redhat.com [10.10.114.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6877E27A3A8;
        Mon, 20 Apr 2020 19:14:54 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id C9419220E74; Mon, 20 Apr 2020 15:14:53 -0400 (EDT)
Date:   Mon, 20 Apr 2020 15:14:53 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Configure custom layers via environment variables
Message-ID: <20200420191453.GA21057@redhat.com>
References: <20200415120134.28154-1-amir73il@gmail.com>
 <20200415120134.28154-3-amir73il@gmail.com>
 <20200415153032.GC239514@redhat.com>
 <CAOQ4uxhmxxjGGB3bBoK1OmcAWDsoNi3WdORtH7WDLOcp8=sYSQ@mail.gmail.com>
 <20200415194243.GE239514@redhat.com>
 <CAOQ4uxjZ4Yd3ZWi+Fe64fVkrD=XMDjF1=C=XN_PNdywbGx_gzQ@mail.gmail.com>
 <20200416125807.GB276932@redhat.com>
 <CAOQ4uxi=mT2JYGSXro5YW8gTE5256cxauBddYe2HXM=ZfZ=+ZA@mail.gmail.com>
 <CAOQ4uxjvtGLn=SvLXy3KU6uKbonBUznL==OjdVVjjB6sM=-mgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjvtGLn=SvLXy3KU6uKbonBUznL==OjdVVjjB6sM=-mgg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Apr 18, 2020 at 12:57:27PM +0300, Amir Goldstein wrote:
> > > If I specify UNIONMOUNT_BASEDIR, then --samefs should be implied?
> > >
> >
> > This might have made sense with the meaning of UNIONMOUNT_BASEDIR
> > as it is in current posting, but with intended change, I suppose an empty
> > UNIONMOUNT_LOWERDIR could mean --samefs.
> > When both --samefs and UNIONMOUNT_LOWERDIR are specified, I'll
> > throw a warning that UNIONMOUNT_LOWERDIR is ignored.
> >
> 
> Vivek,
> 
> I updated the logic per some of your suggestions and push to:
>   https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel
> The example of how xfstests uses it is at:
>   https://github.com/amir73il/xfstests/commits/unionmount
> 
> Since I am mostly interested in feedback on config interface, I'll just
> paste the commit message here (same text is also in README).
> 
> In short: if you set UNIONMOUNT_BASEDIR to virtiofs path and
> execute run --ov, all layers will be created under that virtiofs path.

This is nice. I tried following and it seems to work.

UNIONMOUNT_BASEDIR=/mnt/virtiofs/overlayfs-tests
UNIONMOUNT_MNTPOINT=/mnt/virtiofs/mnt

Got a question though. If somebody specifies a BASEDIR, whey not
automatically select mount point also inside that basedir. Is it because
of existing structure where basedir and mnt directory are separate and
defaults are different. Anway, I don't mind overlay mountpoint with
a separate environment variable.

> 
> Let me know if this works for you.
> Thanks,
> Amir.
> 
> commit 8c2ac6e0cd9d4b01e421375e0b9c3703e774cd9f
> Author: Amir Goldstein <amir73il@gmail.com>
> Date:   Sun Apr 12 19:22:19 2020 +0300
> 
>     Configure custom layers via environment variables
> 
>     The following environment variables are supported:
> 
>      UNIONMOUNT_BASEDIR  - parent dir of all samefs layers (default: /base)
>      UNIONMOUNT_LOWERDIR - lower layer path for non samefs (default: /lower)
>      UNIONMOUNT_MNTPOINT - mount point for executing tests (default: /mnt)
> 
>     When user provides paths for base/lower dir, they should point at
>     existing directories and their content will be deleted.
>     When the default base/lower paths are used, tmpfs instances are created.
> 
>     UNIONMOUNT_LOWERDIR is meaningless and will be ignored with --samefs.
>     Empty UNIONMOUNT_LOWERDIR with non-empty UNIONMOUNT_BASEDIR imply --samefs,

What happens if I specify both UNIONMOUNT_LOWERDIR as well as
UNIONMOUNT_BASEDIR. Does that mean only upper and work will be setup in
UNIONMOUNT_BASEDIR.

>     unless user explicitly requested non samefs setup with maxfs=<M>.

So if UNIONMOUNT_LOWERDIR is empty and I specify a UNIONMOUNT_BASEDIR and
use maxfs=<M>. All layers will still come from under UNIONMOUNT_BASEDIR,
right?

What's most intuitive to me is this.

- If user only specifies UNIONMOUNT_BASEDIR, all layers (lower, upper,
  work and even mount point) comes from that directory.

- If user specifies both UNIONMOUNT_LOWERDIR and UNIONMOUNT_BASEDIR, then
  lower layer path comes from UNIONMOUNT_LOWERDIR and rest of the layers
  come from UNIONMOUNT_BASEDIR.

- If user specifies UNIONMOUNT_MNTPOINT, it is used as overlay mount
  point. Otherwise one is selected from UNIONMOUNT_BASEDIR if user
  specified one. Otherwise "/mnt" is the default.

Thanks
Vivek

> 
>     This is going to be used for running unionmount tests from xfstests.
> 
>     Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> 

