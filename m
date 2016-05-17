From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: 45aebeaf4f67 "ovl: Ensure upper filesystem supports d_type"
 breaking Docker
Date: Tue, 17 May 2016 16:24:43 +0200
Message-ID: <CAJfpeguDRps94_NYXSjc7gtO7OYMU-BEwU3nqp8XABtZ5Cftcg@mail.gmail.com>
References: <87d1ombix6.fsf@gamma.ozlabs.ibm.com>
	<20160516130727.GA26411@redhat.com>
	<20160517062829.GG14480@ZenIV.linux.org.uk>
	<CAOssrKejFhkVssL19uXQnfuEMfP8CXNPMHNGq0_3yazPOk+Xpg@mail.gmail.com>
	<20160517121023.GA6553@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34533 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbcEQOYo (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 17 May 2016 10:24:44 -0400
Received: by mail-oi0-f48.google.com with SMTP id k142so27243152oib.1
        for <linux-unionfs@vger.kernel.org>; Tue, 17 May 2016 07:24:44 -0700 (PDT)
In-Reply-To: <20160517121023.GA6553@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, Daniel Axtens <dja@axtens.net>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, mpe@ellerman.id.au, dchinner@redhat.com

On Tue, May 17, 2016 at 2:10 PM, Vivek Goyal <vgoyal@redhat.com> wrote:

> Having said that, what happens when ovl_workdir_create() fails and we
> mount overlayfs read only. In that case I think we will conclude that
> underlying fs does not support d_type and mounting will fail.

Good point, I missed that.

> Any thoughts, on how to handle this failure path better?

Just skip the d_type test.  We won't create whiteouts that way (and
whiteouts would only have been created with a previous kernel that
didn't have this test, which I don't think is a very interesting
case).

Thanks,
Miklos
