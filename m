Return-Path: <SRS0=sCFp=CC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C6F5C433E1
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 13:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CD8B2074D
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 13:02:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OoavVXYB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgHXNCM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 09:02:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56661 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726189AbgHXNCM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Aug 2020 09:02:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598274130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3rm3qQU/xp9Hz+Vwxu7S3VTdzYyR36pAvy94enHTU/s=;
        b=OoavVXYBvSHHlBGCAsVGPyg18Vl4ha8UE555xbRsstC9UhaqpWRmCYgBWqoEH9DZvIH2VP
        +4oC2R/jD/Bxh2hhnPOyrD2Mek7h0G6mdm2NgYg91mN7v0LWLfwmm6bU1m/Ev0ISyjlKwG
        aaXSeWXEJPv1Yn/NCyRvjqdABgqq5Kc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-u_798eWHNniv34uVwVA4YA-1; Mon, 24 Aug 2020 09:02:08 -0400
X-MC-Unique: u_798eWHNniv34uVwVA4YA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D8011DDEB;
        Mon, 24 Aug 2020 13:02:07 +0000 (UTC)
Received: from localhost (ovpn-114-217.ams2.redhat.com [10.36.114.217])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 545FC5C22A;
        Mon, 24 Aug 2020 13:02:06 +0000 (UTC)
From:   Giuseppe Scrivano <gscrivan@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH v5] overlayfs: Provide a mount option "volatile" to skip
 sync
References: <20200722175024.GA608248@redhat.com> <87h7svyqsd.fsf@redhat.com>
        <CAJfpegtA-16EFFoqhn25rVmXat5hhNUTAWOf+hJEs5L910oQzA@mail.gmail.com>
        <CAOQ4uxj0SF1VRbMEvVm4a9TuUtdMYuZqFkZhkUyEGMagCWk5NA@mail.gmail.com>
        <87a6yknugp.fsf@redhat.com>
        <CAOQ4uxg4xmvsoKVBfGJ0SVCXfM6aeNji6c8FSCevxV-FYX3LtQ@mail.gmail.com>
Date:   Mon, 24 Aug 2020 15:02:04 +0200
In-Reply-To: <CAOQ4uxg4xmvsoKVBfGJ0SVCXfM6aeNji6c8FSCevxV-FYX3LtQ@mail.gmail.com>
        (Amir Goldstein's message of "Mon, 24 Aug 2020 15:38:09 +0300")
Message-ID: <874kosnqnn.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Amir Goldstein <amir73il@gmail.com> writes:

> On Mon, Aug 24, 2020 at 2:39 PM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>>
>> Hi Amir,
>>
>> Amir Goldstein <amir73il@gmail.com> writes:
>>
>> > On Mon, Aug 24, 2020 at 11:15 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>> >>
>> >> On Sat, Aug 22, 2020 at 11:27 AM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>> >> >
>> >> > Vivek Goyal <vgoyal@redhat.com> writes:
>> >> >
>> >> > > Container folks are complaining that dnf/yum issues too many sync while
>> >> > > installing packages and this slows down the image build. Build
>> >> > > requirement is such that they don't care if a node goes down while
>> >> > > build was still going on. In that case, they will simply throw away
>> >> > > unfinished layer and start new build. So they don't care about syncing
>> >> > > intermediate state to the disk and hence don't want to pay the price
>> >> > > associated with sync.
>> >> > >
>> >>
>> >> [...]
>> >>
>> >> > Ping.
>> >> >
>> >> > Is there anything holding this patch?
>> >>
>> >> Not sure what happened with protection against mounting a volatile
>> >> overlay twice, I don't see that in the patch.
>> >
>> > Do you mean protection only for new kernels or old kernels as well?
>> >
>> > The latter can be achieved by using $workdir/volatile/ as upperdir
>> > instead of $upperdir.
>> > Or maybe even use $workdir/work/incompat/volatile/upper, so if older
>> > kernel tries to re-use that $workdir, it will fail to mount rw with error:
>> >
>> >   overlayfs: cleanup of 'incompat/volatile' failed (-39)
>> >
>> > If we agree to that, then upperdir= should not be provided at all when
>> > specifying "volatile".
>>
>> in this case, what does a program need to do to remount the overlay more
>> than once?  Is it enough to just delete a file?
>>
>
> Do you mean re-mount while forgetting all changes to previous "volatile"
> mount?

no, without forgetting them.
The original idea was to have a way to disable any sync operation in the
overlay file system and let the upper layers handle it.  IOW, mount
volatile overlay+umount overlay+syncfs upper dir must still be
considered safe.
If we want to make it safer and disallow remounting the same
workdir+upperdir by default when "volatile" is used, that is fine; but I
think there should still be a way to say "I know what I am doing, just
remount it".

Regards,
Giuseppe

