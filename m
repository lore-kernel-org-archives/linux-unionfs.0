From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: two questiones about overlayfs
Date: Tue, 15 Aug 2017 17:53:55 +0200
Message-ID: <CAOQ4uxgw4-GaWcZKfQMtGfFjVc26+W39HdtNKvb4R-HzxrtmNA@mail.gmail.com>
References: <b68bea1b-4b51-8573-cf8a-06da4c41ed00@huawei.com>
 <CAOQ4uxiL=Gqy6A=_gKTFG0sQRYkZ37aptdn2fEvcF0phJBmW7Q@mail.gmail.com>
 <20170815133554.GB29201@veci.piliscsaba.szeredi.hu> <CAOQ4uxj6qkN-gi4a9ztKJj0FoBMrJC3DPta-m+3dVeHCxZOBNw@mail.gmail.com>
 <CAJfpegsOjqJ-BXFBA3SsuDVornt37GOomP4E8UTaNBxACtGFFw@mail.gmail.com>
 <CAOQ4uxha+B6bpKVxg824-WG-eYxfoL5OxW-PgmcWGcXGe55LXw@mail.gmail.com> <CAJfpegv-u+=edQ+bpD-HqAMUYf+Yy-hg-CkVGRiG6VDPT=S7aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35985 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751882AbdHOPx4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Aug 2017 11:53:56 -0400
Received: by mail-oi0-f66.google.com with SMTP id b130so1107342oii.3
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Aug 2017 08:53:56 -0700 (PDT)
In-Reply-To: <CAJfpegv-u+=edQ+bpD-HqAMUYf+Yy-hg-CkVGRiG6VDPT=S7aw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, miaoxie@huawei.com, Vivek Goyal <vgoyal@redhat.com>

On Tue, Aug 15, 2017 at 5:33 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Aug 15, 2017 at 5:28 PM, Amir Goldstein <amir73il@gmail.com> wrote:

>> It certainly is. It doesn't mean that fixing incorrect behavior won't
>> lead to unacceptable regressions, which may require explicit
>> d_real() call from filesystem to be fixed.
>
> I don't get it.  The only possible regression is denying modification
> on lower layer where previously was allowed.  But anybody relying on
> that would be pretty crazy.
>

Agreed that is pretty crazy, but consider:
_strong_open_rdwr:
- remove immutable flag
- open file RDWR

That would work on current kernels in spite of possibly changing lower
immutable flag, but may break with this patch.
If this is done by a sufficiently common app, fixing the breakage may require
some explicit copy up somewhere...
Note that the app is not crazy to require changing lower, the app is perfectly
sane to require being able to remove the immutable flag before trying
to open rdrw.

But I guess the only way to know is make the change and wait for the reports.

Amir.
