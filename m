From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC PATCH] overlayfs: support more than one read-only layer
Date: Mon, 17 Nov 2014 11:32:07 +0100
Message-ID: <CAJfpegvYBMbhbmpA2kB01qQ3u5ict7rgWib4tx=941yyzqJBMQ@mail.gmail.com>
References: <20141107170242.GA333@tucsk>
	<20141108192723.444cecd2@gmail.com>
	<20141110090954.GB333@tucsk>
	<20141114095511.789a76ac@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:53925 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaKQKcI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 17 Nov 2014 05:32:08 -0500
Received: by mail-qg0-f52.google.com with SMTP id a108so3233800qge.11
        for <linux-unionfs@vger.kernel.org>; Mon, 17 Nov 2014 02:32:07 -0800 (PST)
In-Reply-To: <20141114095511.789a76ac@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jordi Pujol Palomer <jordipujolp@gmail.com>
Cc: linux-unionfs@vger.kernel.org, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "A. Wan" <jm@mokwan.com>, Patrick Frisch <patrick@frischux.de>, Aaron Campbell <aaron@arbor.net>

On Fri, Nov 14, 2014 at 9:55 AM, Jordi Pujol Palomer
<jordipujolp@gmail.com> wrote:
> EL Mon, 10 Nov 2014 10:09:54 +0100
> Miklos Szeredi <miklos@szeredi.hu> escrigu=C3=A9:
>
>> Maybe it wasn't clear, but the number of lower layers isn't limited =
by
>> FILESYSTEM_MAX_STACK_DEPTH,
> sorry, you have been clear, it's me that have not explained the purpo=
se
> of that patch. This idea is also valid for the main overlayfs
> development.
> Consider that we have an encrypted partition and a live OS that
> uses overlayfs and works over it, when the OS is started already
> reaches the maximum stacking depth (2). Also, hardcoding parameters
> into the code may be annoying because a change implies creating and
> mantaining patches, otherwise when the parameter is configurable we c=
an
> change it in a config value.

Before allowing a change to FILESYSTEM_MAX_STACK_DEPTH we'd need to
analyze the kernel stack usage of anything taking part in the
filesystem stack.  Not something that can be expected of users before
they set a kernel config variable.

'Course we can change overlayfs and/or ecryptfs to use a new context
for operations done on underlying layers.  Not sure how much work that
would be...

> Also, I include a patch to explain better my first statement,
> would say lowerdirs has extended the functionality of lowerdir,
> therefore we can discard the lowerdir case that only works with one
> lower layer and rename lowerdirs to lowerdir. It's more simple and al=
l
> the functionality is preserved.

Yeah.  But we also need some escaping in 'lowerdir=3D' argument to allo=
w
filenames with comma and colon.  Current patch doesn't yet have that,
but will work on it.

Thanks,
Miklos
--
To unsubscribe from this list: send the line "unsubscribe linux-unionfs=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
