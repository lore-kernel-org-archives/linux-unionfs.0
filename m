From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [ANNOUNCE] unionmount-testsuite: Amir's master branch updated
Date: Wed, 6 Dec 2017 10:09:20 +0100
Message-ID: <CAJfpegtJTAF1JBr380UdAAky+4iXHCxaTWeB9bhFvwm5pVGqAw@mail.gmail.com>
References: <CAOQ4uxiiaiq8dettBvZScC59KV-07B-muxE3SS60BDK3dugJow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:46070 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754417AbdLFJJW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 Dec 2017 04:09:22 -0500
Received: by mail-qt0-f178.google.com with SMTP id g10so7233541qtj.12
        for <linux-unionfs@vger.kernel.org>; Wed, 06 Dec 2017 01:09:21 -0800 (PST)
In-Reply-To: <CAOQ4uxiiaiq8dettBvZScC59KV-07B-muxE3SS60BDK3dugJow@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, David Howells <dhowells@redhat.com>, fstests <fstests@vger.kernel.org>

On Tue, Dec 5, 2017 at 9:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Hi All,
>
> The master branch on my unionmount-testsuite tree [1] has been updated.
>
> The head of the master branch is commit:
> 6d04664 Add a test for rename over empty union dir
>
> This small update contains:
> - A few new simple dir rename and dir remove tests
> - A fix for running on kernel <= v4.9 with no redirect_dir support
> - A new setup option --squashfs to setup lower as read-only squashfs
>
> With index enabled, there are no known failures.
> With index disabled this test fails on non-constant st_ino for lower hardlink
> copy up:
>   run --ov=1 --samefs --verify rename-mass-5
>
> Thanks,
> Amir.
>
> [1] https://github.com/amir73il/unionmount-testsuite

Thanks for also taking care of this useful resource!

Miklos
