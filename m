Return-Path: <SRS0=vZRj=EM=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B05CDC2D0A3
	for <linux-unionfs@archiver.kernel.org>; Fri,  6 Nov 2020 19:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5607520882
	for <linux-unionfs@archiver.kernel.org>; Fri,  6 Nov 2020 19:03:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZhHD35jz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgKFTDa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 6 Nov 2020 14:03:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726075AbgKFTD3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Nov 2020 14:03:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604689408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c8f697oyTMxSfqQjQo3z8gfiVlUa9mOb+N4coRYdeq0=;
        b=ZhHD35jzdsE7qsU6wI4kBfGP8fm9r7hTzq1RCw2qugcDE18wFFG9ZP00RpwasqjMj12fFx
        KdWZ0Hjwq0g+C/Lpcbq/Xm0kyBsNY/RnCil5f8gRXcewL2Vis8W/UIqu1nWKHdMjtVEJ/D
        1iBdYHmSIcnv4v5/EjLMPws4XvpL7kQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-KRTDxJKINsGcsmUvlGykHw-1; Fri, 06 Nov 2020 14:03:27 -0500
X-MC-Unique: KRTDxJKINsGcsmUvlGykHw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD92D6D580;
        Fri,  6 Nov 2020 19:03:25 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-167.rdu2.redhat.com [10.10.115.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA3FB1002C29;
        Fri,  6 Nov 2020 19:03:25 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 3267E225FCD; Fri,  6 Nov 2020 14:03:25 -0500 (EST)
Date:   Fri, 6 Nov 2020 14:03:25 -0500
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Sargun Dhillon <sargun@sargun.me>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>
Subject: Re: [PATCH v7] overlayfs: Provide a mount option "volatile" to skip
 sync
Message-ID: <20201106190325.GB1445528@redhat.com>
References: <20200831181529.GA1193654@redhat.com>
 <CAMp4zn9dF-umZF-LP=f6qWekyupsXTB6B8CeH6km7=9oVYV+NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMp4zn9dF-umZF-LP=f6qWekyupsXTB6B8CeH6km7=9oVYV+NA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Nov 06, 2020 at 09:58:39AM -0800, Sargun Dhillon wrote:

[..]
> There is some slightly confusing behaviour here [I realize this
> behaviour is as intended]:
> 
> (root) ~ # mount -t overlay -o
> volatile,index=off,lowerdir=/root/lowerdir,upperdir=/root/upperdir,workdir=/root/workdir
> none /mnt/foo
> (root) ~ # umount /mnt/foo
> (root) ~ # mount -t overlay -o
> volatile,index=off,lowerdir=/root/lowerdir,upperdir=/root/upperdir,workdir=/root/workdir
> none /mnt/foo
> mount: /mnt/foo: wrong fs type, bad option, bad superblock on none,
> missing codepage or helper program, or other error.
> 
> From my understanding, the dirty flag should only be a problem if the
> existing overlayfs is unmounted uncleanly. Docker does
> this (mount, and re-mounts) during startup time because it writes some
> files to the overlayfs. I think that we should harden
> the volatile check slightly, and make it so that within the same boot,
> it's not a problem, and having to have the user clear
> the workdir every time is a pain. In addition, the semantics of the
> volatile patch itself do not appear to be such that they
> would break mounts during the same boot / mount of upperdir -- as
> overlayfs does not defer any writes in itself, and it's
> only that it's short-circuiting writes to the upperdir.

umount does a sync normally and with "volatile" overlayfs skips that
sync. So a successful unmount does not mean that file got synced
to backing store. It is possible, after umount, system crashed
and after reboot, user tried to mount upper which is corrupted
now and overlay will not detect it.

You seem to be asking for an alternate option where we disable
fsync() but not syncfs. In that case sync on umount will still
be done. And that means a successful umount should mean upper
is fine and it could automatically remove incomapt dir upon
umount.

Intial version of patches had both the volatile modes implemented.
Later we dropped one because it was not clear who wants this
second mode. If this is something which is useful for you, it
can possibly be introduced.

Thanks
Vivek

