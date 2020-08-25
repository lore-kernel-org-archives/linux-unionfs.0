Return-Path: <SRS0=uqCX=CD=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1EA0C433E1
	for <linux-unionfs@archiver.kernel.org>; Tue, 25 Aug 2020 00:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76E742087D
	for <linux-unionfs@archiver.kernel.org>; Tue, 25 Aug 2020 00:55:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Edf8W86x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728403AbgHYAzK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 20:55:10 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29761 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728324AbgHYAzK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Aug 2020 20:55:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598316908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oX3sHpya22yNvEuiJRweTBpLKQY9ToNqo7Bdyqy1v/g=;
        b=Edf8W86xhuWVqGI1DQ+eIxeFSyrwK7tYzMe7/kwCITdW00DMDWE9gZr5Zm9qrMjW9qsjc+
        H9J8zcqtTpk0KJcvG3YXgLHSuHOHweQj2vfwaGb2J+bitiQ1LBPPa0Vex5bx4WW4IMvTil
        xoHKmzlQCdXRkRVFt8YGeDOhLWD38v0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-Bm1vICoIMRGQCgTynZJA9w-1; Mon, 24 Aug 2020 20:55:06 -0400
X-MC-Unique: Bm1vICoIMRGQCgTynZJA9w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04C8881F015;
        Tue, 25 Aug 2020 00:55:05 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-156.rdu2.redhat.com [10.10.115.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABA587C641;
        Tue, 25 Aug 2020 00:55:04 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 2C1832256FC; Mon, 24 Aug 2020 20:55:04 -0400 (EDT)
Date:   Mon, 24 Aug 2020 20:55:04 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH v5] overlayfs: Provide a mount option "volatile" to skip
 sync
Message-ID: <20200825005504.GN963827@redhat.com>
References: <CAJfpegtA-16EFFoqhn25rVmXat5hhNUTAWOf+hJEs5L910oQzA@mail.gmail.com>
 <CAOQ4uxj0SF1VRbMEvVm4a9TuUtdMYuZqFkZhkUyEGMagCWk5NA@mail.gmail.com>
 <87a6yknugp.fsf@redhat.com>
 <CAOQ4uxg4xmvsoKVBfGJ0SVCXfM6aeNji6c8FSCevxV-FYX3LtQ@mail.gmail.com>
 <874kosnqnn.fsf@redhat.com>
 <CAJfpegvaUz_M0jtibOk=a6Cx=U9JBnOcVSmF2xM9cyVmCz8CFg@mail.gmail.com>
 <20200824135108.GB963827@redhat.com>
 <CAOQ4uxi9PoYzWxKF0c2a9zzxnrZMeB08Htomn1eHjYha-djLrA@mail.gmail.com>
 <20200824210053.GL963827@redhat.com>
 <CAOQ4uxhvi5wHhPKivrWzOJ8ygyETDVqc4h4MW6uYN=h1T2B+BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhvi5wHhPKivrWzOJ8ygyETDVqc4h4MW6uYN=h1T2B+BA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 25, 2020 at 12:51:55AM +0300, Amir Goldstein wrote:
> > Ok, I am wondering why are we concerned about older kernels. I mean,
> > if we introduce new features, we don't provide compatibility with
> > older kernels. Say "metacopy", "redirect_dir". If you mount with
> > older kernel, they will see something which you don't expect.
> >
> 
> True. We missed the opportunity to do the work/incompat trick
> with metacopy etc.
> 
> > So why "volatile" is different. We seem to be bending backward and
> > using an unrelated behavior of overlay to provide this.
> >
> > Why not simply drop a file $workdir/volatile for volatile mounts
> > and check for presence of this file when mounting?
> >
> 
> That's an option.
> But what's the problem with
>   $workdir/work/incompat/volatile/dirty
> compared to:
>   $workdir/volatile
> 
> It's not more complicated to implement is it?
> So we get some extra protection with little extra cost. No?

Ok, I will look into it.
> 
> I don't feel strongly about it.
> 
> But I must say, according to Giuseppe's description of the use case:
> "mount volatile overlay+umount overlay+syncfs upper dir..."
> looks like what he is looking for is "volatile,sync=shutdown", is it not?
> 
> And if this is the case, I think it would be much preferred to implement
> "volatile,sync=shutdown", over documenting how to make a "volatile"
> overlay mountable from outside overlay. Don't you guys agree?

When it comes to requirements, to me it felt that Giuseppe seemed
to have two requirements. For running containers, he did not care
seem to care about syncing upper to disk at all. For building
images he probably wanted to sync upper to disk.

From overlayfs perspective, "volatile,sync=shutdown" seems like
a nicer interface because overlay will take care of removing
"dirty" file and until and unless crash happens, user does
not have to step in and there is less confusion about syncing
upper and removing dirty file etc.

Last time Miklos seemed to prefer to implement just "volatile"
for now and drop "sync=shutdown".

https://lore.kernel.org/linux-unionfs/CAJfpegt2k=r6TRok57tKPcLyUhCBOcBAV7bgLSPrQYXsPoPkpQ@mail.gmail.com/

I personally think that "volatile,sync=shutdown" is first good step
because it is less error prone and overlayfs manages dirty file
and it will provide lot of benefits in terms of not having to
do very frequent sync.

And if this does not prove to be enough for certain use cases,
then one can extend this to also implement "volatile,sync=none".

But frankly speaking, there has been so much of back and forth
on this patch, that I am fine with any of the option which is
acceptable to Miklos.

Vivek

> 
> Doesn't matter, either way, the same protection will be used.
> 
> Thanks,
> Amir.
> 

