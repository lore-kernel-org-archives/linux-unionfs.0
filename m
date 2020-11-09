Return-Path: <SRS0=jezc=EP=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40766C2D0A3
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Nov 2020 08:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCD22206ED
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Nov 2020 08:53:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ez1kxHo5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgKIIxV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 9 Nov 2020 03:53:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24571 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728335AbgKIIxV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 9 Nov 2020 03:53:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604911999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HNQPsjTQl5LJpWlmaOSDh69FhP0/dMoZ5uSD4dWGZEs=;
        b=ez1kxHo5mFW+6qJ2nrmFW+zolr3+u/fjc6RpWFOYUHtrm1YOosDAbGkpbHGZ78JJPT5no2
        5LA5ZJHDp3D2/rKdMPt0z62yVYy78g3muWqzxgGA9JGoE3IiFSI8ZE/i8givrkVL2tQGL3
        TaDNfdtyuVlNypU8emJpnmh/Rz9EVWk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-w_uVmLk2NUOGd9-mA0g_Ww-1; Mon, 09 Nov 2020 03:53:15 -0500
X-MC-Unique: w_uVmLk2NUOGd9-mA0g_Ww-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD64D1009E2D;
        Mon,  9 Nov 2020 08:53:13 +0000 (UTC)
Received: from localhost (ovpn-113-223.ams2.redhat.com [10.36.113.223])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CFEE05C1D7;
        Mon,  9 Nov 2020 08:53:08 +0000 (UTC)
From:   Giuseppe Scrivano <gscrivan@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>, Sargun Dhillon <sargun@sargun.me>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Daniel J Walsh <dwalsh@redhat.com>
Subject: Re: [PATCH v7] overlayfs: Provide a mount option "volatile" to skip
 sync
References: <20200831181529.GA1193654@redhat.com>
        <CAMp4zn9dF-umZF-LP=f6qWekyupsXTB6B8CeH6km7=9oVYV+NA@mail.gmail.com>
        <20201106190325.GB1445528@redhat.com> <87o8kamfuo.fsf@redhat.com>
        <CAOQ4uxhyzw=fHokRuCDFwD7SUg14_i1W0HMp9AGD6UxC5t5+tQ@mail.gmail.com>
Date:   Mon, 09 Nov 2020 09:53:01 +0100
In-Reply-To: <CAOQ4uxhyzw=fHokRuCDFwD7SUg14_i1W0HMp9AGD6UxC5t5+tQ@mail.gmail.com>
        (Amir Goldstein's message of "Sat, 7 Nov 2020 11:35:04 +0200")
Message-ID: <87k0uulxn6.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> On Fri, Nov 6, 2020 at 9:43 PM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>>
>> Vivek Goyal <vgoyal@redhat.com> writes:
>>
>> > On Fri, Nov 06, 2020 at 09:58:39AM -0800, Sargun Dhillon wrote:
>> >
>> > [..]
>> >> There is some slightly confusing behaviour here [I realize this
>> >> behaviour is as intended]:
>> >>
>> >> (root) ~ # mount -t overlay -o
>> >> volatile,index=off,lowerdir=/root/lowerdir,upperdir=/root/upperdir,workdir=/root/workdir
>> >> none /mnt/foo
>> >> (root) ~ # umount /mnt/foo
>> >> (root) ~ # mount -t overlay -o
>> >> volatile,index=off,lowerdir=/root/lowerdir,upperdir=/root/upperdir,workdir=/root/workdir
>> >> none /mnt/foo
>> >> mount: /mnt/foo: wrong fs type, bad option, bad superblock on none,
>> >> missing codepage or helper program, or other error.
>> >>
>> >> From my understanding, the dirty flag should only be a problem if the
>> >> existing overlayfs is unmounted uncleanly. Docker does
>> >> this (mount, and re-mounts) during startup time because it writes some
>> >> files to the overlayfs. I think that we should harden
>> >> the volatile check slightly, and make it so that within the same boot,
>> >> it's not a problem, and having to have the user clear
>> >> the workdir every time is a pain. In addition, the semantics of the
>> >> volatile patch itself do not appear to be such that they
>> >> would break mounts during the same boot / mount of upperdir -- as
>> >> overlayfs does not defer any writes in itself, and it's
>> >> only that it's short-circuiting writes to the upperdir.
>> >
>> > umount does a sync normally and with "volatile" overlayfs skips that
>> > sync. So a successful unmount does not mean that file got synced
>> > to backing store. It is possible, after umount, system crashed
>> > and after reboot, user tried to mount upper which is corrupted
>> > now and overlay will not detect it.
>> >
>> > You seem to be asking for an alternate option where we disable
>> > fsync() but not syncfs. In that case sync on umount will still
>> > be done. And that means a successful umount should mean upper
>> > is fine and it could automatically remove incomapt dir upon
>> > umount.
>>
>> could this be handled in user space?  It should still be possible to do
>> the equivalent of:
>>
>> # sync -f /root/upperdir
>> # rm -rf /root/workdir/incompat/volatile
>>
>
> FWIW, the sync -f command above is
> 1. Not needed when re-mounting overlayfs as volatile
> 2. Not enough when re-mounting overlayfs as non-volatile
>
> In the latter case, a full sync (no -f) is required.

Thanks for the clarification.  Why wouldn't a syncfs on the upper
directory be enough to ensure files are persisted and safe to reuse
after a crash?

Regards,
Giuseppe

