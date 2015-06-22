From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Optional switching off cow in overlayfs
Date: Mon, 22 Jun 2015 16:37:47 +0200
Message-ID: <CAJfpegtcUt6jR7t_2Ca1osu6+-BKGtnTVVTVXEcWrqBtY0fCzA@mail.gmail.com>
References: <5582C6C1.8080602@samsung.com>
	<13405.1434634748@warthog.procyon.org.uk>
	<5582D8F7.1060700@samsung.com>
	<CAJfpegsP-_MAKybYZ=uS3UCxsxL9Hv-cJ-GYrVL4h3B+tWZF9A@mail.gmail.com>
	<5588116E.20509@samsung.com>
	<CAJfpegsVqzVhq8BjCwqA+6dEZey0aNb4amnnOT_JVDfzki9v1g@mail.gmail.com>
	<55881B2A.7090106@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:34774 "EHLO
	mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbbFVOhs (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 22 Jun 2015 10:37:48 -0400
Received: by qkeo142 with SMTP id o142so84228193qke.1
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jun 2015 07:37:47 -0700 (PDT)
In-Reply-To: <55881B2A.7090106@samsung.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jan Olszak <j.olszak@samsung.com>
Cc: David Howells <dhowells@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Jun 22, 2015 at 4:26 PM, Jan Olszak <j.olszak@samsung.com> wrote:
>> You can bind mount individual files from the lower layer to the
>> overlay.  That fixes the "allow modification" part.
>
> Well bind mounting every file that should have COW is unmaintainable - if
> new files appear admin has to mount each one.

No.  I was proposing bind mounts for non-COW ones.

mount -t overlay -olowerdir=/lower,upperdir=/upper,workdir=/work  overlay /ovl
mount --bind /lower/this-file-is-non-cow /ovl/this-file-is-non-cow
...

>>   But what should happen on rename or unlink?
>
> Both would operate on the original inode.

And that would make this hugely complex.

Thanks,
Miklos
