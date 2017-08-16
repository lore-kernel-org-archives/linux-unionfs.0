From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: two questiones about overlayfs
Date: Wed, 16 Aug 2017 18:12:57 +0200
Message-ID: <CAOQ4uxh_CDmv42T7o5oLe5SP_SYFq60QPtLGyjoNLsAxQiMJkw@mail.gmail.com>
References: <b68bea1b-4b51-8573-cf8a-06da4c41ed00@huawei.com>
 <CAOQ4uxiL=Gqy6A=_gKTFG0sQRYkZ37aptdn2fEvcF0phJBmW7Q@mail.gmail.com>
 <20170815133554.GB29201@veci.piliscsaba.szeredi.hu> <CAOQ4uxj6qkN-gi4a9ztKJj0FoBMrJC3DPta-m+3dVeHCxZOBNw@mail.gmail.com>
 <CAJfpegsOjqJ-BXFBA3SsuDVornt37GOomP4E8UTaNBxACtGFFw@mail.gmail.com>
 <CAOQ4uxha+B6bpKVxg824-WG-eYxfoL5OxW-PgmcWGcXGe55LXw@mail.gmail.com>
 <CAJfpegv-u+=edQ+bpD-HqAMUYf+Yy-hg-CkVGRiG6VDPT=S7aw@mail.gmail.com>
 <20170815155617.GC3551@redhat.com> <CAOQ4uxh4y1AAcQvv_A71E38TAUE9+Zk2vSQisOE1E=QEs7N-Jw@mail.gmail.com>
 <CAJfpegvwXL01-6FPXcbKcPiOKj+LBp69-eHnhiJtuevQdKd4tQ@mail.gmail.com> <20170816135258.GC23045@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35970 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751531AbdHPQM7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Aug 2017 12:12:59 -0400
Received: by mail-oi0-f51.google.com with SMTP id g131so40683077oic.3
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2017 09:12:59 -0700 (PDT)
In-Reply-To: <20170816135258.GC23045@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, miaoxie@huawei.com, Theodore Tso <tytso@mit.edu>

On Wed, Aug 16, 2017 at 3:52 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Aug 16, 2017 at 12:19:22PM +0200, Miklos Szeredi wrote:
...
>>
>> What about copy up of flags?  Should we?  Does reflink copy the flags?
>
> Oh yes, copy up of flags seem to be an issue too. I have a file on lower
> with project id 123 and once that file gets copied up, project id goes
> back to 0.
>
> [merged]# lsattr -p foo.txt
>   123 ------------------- foo.txt
>
> [merged]# touch foo.txt
>
> [merged]# lsattr -p foo.txt
>     0 ------------------- foo.txt
>

Vivek,

This specific case I would tag as "desired behavior".
This is the behavior that allowed us to implement container storage quota
for docker using overlayfs + project quota set on overlay upper dir.
Copy up file inherits its project quota id from upper dir recursively, which
at least for docker use case is "desired behavior"

IMO, for the KSTAT_ATTR_FS_IOC_FLAGS use case, copy up flags
(compressed, encrypted, immutable, append, nodump) all make sense,
although immutable/append should be set after copying data while
encrypted/compressed should probably be set before copying data??

Amir.
