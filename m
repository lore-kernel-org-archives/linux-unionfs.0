Return-Path: <SRS0=sCFp=CC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCF59C433E1
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 11:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7CB720774
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 11:40:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="haPUNuAJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgHXLkH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 07:40:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44690 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727779AbgHXLj7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Aug 2020 07:39:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598269198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MGX6w16Fo/bNfsQoLln4y8H1qAVBrOEnXuwzrhqCE4c=;
        b=haPUNuAJVdxo2GJ9CWM/q/r5A20D4vE9UsSwjZBE3q5oEc8XxdAgCVjJEfl4vGPK4oJ3t4
        P/CxPoWq5jjsjKJpRSS4uqwXPaMbYy4W7p7+/guiS89ntu3JjfzdMXzwUZlrpRjWs9X0Af
        zO5t3hzZH20dRfV9+bis/VFVehUV3vM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-kXz9_3IgNIKXnoB8N7DUXA-1; Mon, 24 Aug 2020 07:39:54 -0400
X-MC-Unique: kXz9_3IgNIKXnoB8N7DUXA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CEAA618B9F10;
        Mon, 24 Aug 2020 11:39:53 +0000 (UTC)
Received: from localhost (ovpn-114-217.ams2.redhat.com [10.36.114.217])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D6AE2B3A1;
        Mon, 24 Aug 2020 11:39:52 +0000 (UTC)
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
Date:   Mon, 24 Aug 2020 13:39:50 +0200
In-Reply-To: <CAOQ4uxj0SF1VRbMEvVm4a9TuUtdMYuZqFkZhkUyEGMagCWk5NA@mail.gmail.com>
        (Amir Goldstein's message of "Mon, 24 Aug 2020 13:59:41 +0300")
Message-ID: <87a6yknugp.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Amir,

Amir Goldstein <amir73il@gmail.com> writes:

> On Mon, Aug 24, 2020 at 11:15 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> On Sat, Aug 22, 2020 at 11:27 AM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>> >
>> > Vivek Goyal <vgoyal@redhat.com> writes:
>> >
>> > > Container folks are complaining that dnf/yum issues too many sync while
>> > > installing packages and this slows down the image build. Build
>> > > requirement is such that they don't care if a node goes down while
>> > > build was still going on. In that case, they will simply throw away
>> > > unfinished layer and start new build. So they don't care about syncing
>> > > intermediate state to the disk and hence don't want to pay the price
>> > > associated with sync.
>> > >
>>
>> [...]
>>
>> > Ping.
>> >
>> > Is there anything holding this patch?
>>
>> Not sure what happened with protection against mounting a volatile
>> overlay twice, I don't see that in the patch.
>
> Do you mean protection only for new kernels or old kernels as well?
>
> The latter can be achieved by using $workdir/volatile/ as upperdir
> instead of $upperdir.
> Or maybe even use $workdir/work/incompat/volatile/upper, so if older
> kernel tries to re-use that $workdir, it will fail to mount rw with error:
>
>   overlayfs: cleanup of 'incompat/volatile' failed (-39)
>
> If we agree to that, then upperdir= should not be provided at all when
> specifying "volatile".

in this case, what does a program need to do to remount the overlay more
than once?  Is it enough to just delete a file? 

Thanks,
Giuseppe

