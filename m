From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: two questiones about overlayfs
Date: Wed, 16 Aug 2017 12:20:39 +0200
Message-ID: <CAJfpegtSsC6HXQ0PgG5+EsYasm_qrexzf1L+GTQYmd0J0vRq=A@mail.gmail.com>
References: <b68bea1b-4b51-8573-cf8a-06da4c41ed00@huawei.com>
 <CAOQ4uxiL=Gqy6A=_gKTFG0sQRYkZ37aptdn2fEvcF0phJBmW7Q@mail.gmail.com>
 <20170815133554.GB29201@veci.piliscsaba.szeredi.hu> <CAOQ4uxj6qkN-gi4a9ztKJj0FoBMrJC3DPta-m+3dVeHCxZOBNw@mail.gmail.com>
 <CAJfpegsOjqJ-BXFBA3SsuDVornt37GOomP4E8UTaNBxACtGFFw@mail.gmail.com>
 <CAOQ4uxha+B6bpKVxg824-WG-eYxfoL5OxW-PgmcWGcXGe55LXw@mail.gmail.com>
 <CAJfpegv-u+=edQ+bpD-HqAMUYf+Yy-hg-CkVGRiG6VDPT=S7aw@mail.gmail.com>
 <20170815155617.GC3551@redhat.com> <CAOQ4uxh4y1AAcQvv_A71E38TAUE9+Zk2vSQisOE1E=QEs7N-Jw@mail.gmail.com>
 <CAJfpegvwXL01-6FPXcbKcPiOKj+LBp69-eHnhiJtuevQdKd4tQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:36681 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751744AbdHPKUk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Aug 2017 06:20:40 -0400
Received: by mail-wr0-f178.google.com with SMTP id x43so11454037wrb.3
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2017 03:20:40 -0700 (PDT)
In-Reply-To: <CAJfpegvwXL01-6FPXcbKcPiOKj+LBp69-eHnhiJtuevQdKd4tQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, miaoxie@huawei.com, Theodore Tso <tytso@mit.edu>

On Wed, Aug 16, 2017 at 12:19 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Aug 15, 2017 at 6:16 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Tue, Aug 15, 2017 at 5:56 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>
>>> IIUC, so now "chattr -p <id>" will fail on overlayfs (assume file has not
>>> been copied up yet).
>>>
>>
>> Yap.
>>
>>> IOW, on overlayfs, will it be responsibility of user space to make
>>> sure file has been copied up, for chattr operation to succeed? Does that
>>> mean we need to modify chattr to open file for WRITE instead of READ.
>>>
>>
>> I guess that would make sense.
>> I only wonder what was the reason for chattr to open RDONLY in
>> the first place (cc Ted)??
>
> What about copy up of flags?  Should we?  Does reflink copy the flags?

That last one is a stupid question, reflink is a data copying
operation, not an inode copying one...

Thanks,
Miklos
