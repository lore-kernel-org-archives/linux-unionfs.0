From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] overlayfs update for 4.8
Date: Fri, 29 Jul 2016 22:00:09 +0200
Message-ID: <CAJfpegunRx_uBU2NTV1yAGxMfNCrem3WWKwToS=G5xCX1pZSpw@mail.gmail.com>
References: <20160729112024.GB25404@veci.piliscsaba.szeredi.hu> <CA+55aFzUvF4ENbAygX+YGuvCnk7qmG8Z4JpiS_H6zmtz8hZZag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34984 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbcG2UAK (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 29 Jul 2016 16:00:10 -0400
Received: by mail-oi0-f68.google.com with SMTP id w143so8532241oiw.2
        for <linux-unionfs@vger.kernel.org>; Fri, 29 Jul 2016 13:00:10 -0700 (PDT)
In-Reply-To: <CA+55aFzUvF4ENbAygX+YGuvCnk7qmG8Z4JpiS_H6zmtz8hZZag@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Jul 29, 2016 at 9:26 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Jul 29, 2016 at 4:20 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> First of all, this fixes a regression in overlayfs introduced by the dentry hash
>> salting.  I've moved the patch fixing this to the front of the queue, so if (god
>> forbid) something needs to be bisected in overlayfs this regression won't
>> interfere with that.
>
> Thanks, I had missed that completely, and while I build overlayfs for
> testing, I don't have any actual tests of it.
>

If you want a quick overlayfs test, do "mkdir -p /lower /upper; ./run --ov" from

  git://git.infradead.org/users/dhowells/unionmount-testsuite.git

It takes 17sec on my laptop.

Thanks,
Miklos
